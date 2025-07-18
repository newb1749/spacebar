package com.sist.web.controller;

import com.sist.web.dao.MileageHistoryDao;
import com.sist.web.model.KakaoPayApproveRequest;
import com.sist.web.model.KakaoPayApproveResponse;
import com.sist.web.model.KakaoPayReadyRequest;
import com.sist.web.model.KakaoPayReadyResponse;
import com.sist.web.model.MileageHistory;
import com.sist.web.model.Reservation;
import com.sist.web.model.Response;
import com.sist.web.service.KakaoPayServiceJY;
import com.sist.web.service.ReservationServiceJY;
import com.sist.web.service.UserService_mj;
import com.sist.web.util.SessionUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.*;
import java.beans.PropertyEditorSupport;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@Controller
@RequestMapping("/payment")
public class KakaoPayControllerJY 
{
    private static final Logger logger = LoggerFactory.getLogger(KakaoPayControllerJY.class);

    @Autowired
    private KakaoPayServiceJY kakaoService;

    @Autowired
    private UserService_mj userService;

    @Autowired
    private ReservationServiceJY reservationService;

    @Autowired
    private MileageHistoryDao mileageHistoryDao;

    // 프로퍼티 대신 직접 상수 선언
    private static final String TID_SESSION = "KAKAO_PAY_TID";
    private static final String ORDER_SESSION = "KAKAO_PAY_ORDER_ID";

    @InitBinder
    public void initBinder(WebDataBinder binder) 
    {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        binder.registerCustomEditor(LocalDate.class, new PropertyEditorSupport() {
            @Override
            public void setAsText(String text) throws IllegalArgumentException {
                if (text == null || text.trim().isEmpty()) {
                    setValue(null);
                } else {
                    setValue(LocalDate.parse(text, formatter));
                }
            }
            @Override
            public String getAsText() {
                LocalDate value = (LocalDate) getValue();
                return (value != null ? value.format(formatter) : "");
            }
        });
    }

    @PostMapping("/readyAjax")
    @ResponseBody
    public Response<Map<String, String>> readyAjax(HttpServletRequest req) 
    {
        Response<Map<String, String>> res = new Response<>();
        try 
        {
            String userId = (String) req.getSession().getAttribute("SESSION_USER_ID");
            int amount = Integer.parseInt(req.getParameter("chargeAmount"));

            String orderId = UUID.randomUUID().toString();
            KakaoPayReadyRequest rq = new KakaoPayReadyRequest(userId, orderId, amount);
            KakaoPayReadyResponse rp = kakaoService.ready(rq);

            if (rp != null && rp.getTid() != null)
            {
                HttpSession session = req.getSession();
                SessionUtil.setSession(session, TID_SESSION, rp.getTid());
                SessionUtil.setSession(session, ORDER_SESSION, orderId);
                session.setAttribute("chargeAmount", amount);

                Map<String, String> data = new HashMap<>();
                data.put("next_redirect_pc_url", rp.getNext_redirect_pc_url());
                res.setResponse(0, "success", data);
            }
            else 
            {
                res.setResponse(-1, "카카오페이 준비 실패");
            }
        } 
        catch (Exception e)
        {
            res.setResponse(-9, "서버 오류: " + e.getMessage());
        }
        return res;
    }

    @GetMapping("/success")
    public String success(HttpServletRequest req, Model model) {
        String pgToken = req.getParameter("pg_token");
        if (pgToken == null) {
            model.addAttribute("error", "결제 실패: pg_token이 없습니다.");
            return "/payment/chargeMileage";
        }
        try {
            String tid = (String) req.getSession().getAttribute(TID_SESSION);
            String orderId = (String) req.getSession().getAttribute(ORDER_SESSION);
            String userId = (String) req.getSession().getAttribute("SESSION_USER_ID");
            int amount = (int) req.getSession().getAttribute("chargeAmount");

            logger.debug("=== 결제 승인 성공 여부 체크 ===");
            logger.debug("tid: {}", tid);
            logger.debug("orderId: {}", orderId);
            logger.debug("userId: {}", userId);
            logger.debug("amount: {}", amount);

            KakaoPayApproveRequest approveReq = new KakaoPayApproveRequest(tid, orderId, userId, pgToken);
            KakaoPayApproveResponse approveRes = kakaoService.approve(approveReq);

            logger.debug("approveRes: {}", approveRes);
            logger.debug("approveRes.amount: {}", approveRes != null ? approveRes.getAmount() : null);

            if (approveRes != null && approveRes.getAmount() != null) {
                int result = userService.chargeMileage(userId, amount);  // int 반환 가정
                boolean success = (result > 0);

                if (success) {
                    model.addAttribute("msg", "마일리지 충전이 완료되었습니다.");
                    return "redirect:/payment/mileageHistory";
                } else {
                    model.addAttribute("error", "마일리지 충전 DB 처리 실패");
                    return "/payment/chargeMileage";
                }
            } else {
                model.addAttribute("error", "카카오페이 결제 승인 실패");
                return "/payment/chargeMileage";
            }
        } catch (Exception e) {
            model.addAttribute("error", "오류 발생: " + e.getMessage());
            return "/payment/chargeMileage";
        }
    }

    @GetMapping({"/cancel", "/fail"})
    public String cancelFail(HttpServletRequest req, Model model) 
    {
        model.addAttribute("error", "결제가 취소되거나 실패하였습니다.");
        return "/payment/chargeMileage";
    }

    @GetMapping("/chargeMileage")
    public String showChargeMileagePage(Model model, HttpSession session) {
        String userId = (String) session.getAttribute("SESSION_USER_ID");
        if (userId == null) {
            return "redirect:/user/login";
        }
        long userMileage = getUserMileage(userId);
        model.addAttribute("userMileage", userMileage);
        return "/payment/chargeMileage";  // JSP 경로
    }

    @PostMapping("/chargeMileage")
    public String chargeMileageAndPay(@ModelAttribute Reservation reservation,
                                      HttpServletRequest request,
                                      Model model) 
    {
        String guestId = (String) request.getSession().getAttribute("SESSION_USER_ID");
        if (guestId == null || guestId.isEmpty()) {
            model.addAttribute("error", "로그인이 필요합니다.");
            return "redirect:/user/login";
        }

        try {
        	String checkIn = request.getParameter("rsvCheckInDt");
            String checkOut = request.getParameter("rsvCheckOutDt");
            String checkInTime = request.getParameter("rsvCheckInTime");
            String checkOutTime = request.getParameter("rsvCheckOutTime");

            LocalDate checkInDate = parseFlexibleDate(checkIn);
            LocalDate checkOutDate = parseFlexibleDate(checkOut);

            DateTimeFormatter dbFormat = DateTimeFormatter.ofPattern("yyyyMMdd");

            reservation.setRsvCheckInDt(checkInDate.format(dbFormat));
            reservation.setRsvCheckOutDt(checkOutDate.format(dbFormat));

            reservation.setRsvCheckInTime(convertTimeToHHmm(checkInTime));
            reservation.setRsvCheckOutTime(convertTimeToHHmm(checkOutTime));
            
            int userMileage = userService.getCurrentMileage(guestId);
            int finalAmt = reservation.getFinalAmt();

            if (userMileage < finalAmt) {
                model.addAttribute("error", "마일리지가 부족합니다.");
                return "redirect:/payment/chargeMileage";
            }

            boolean deducted = userService.deductMileage(guestId, finalAmt);
            if (!deducted) {
                model.addAttribute("error", "마일리지 차감에 실패했습니다.");
                return "redirect:/payment/chargeMileage";
            }

            reservation.setGuestId(guestId);
            reservation.setRsvStat("CONFIRMED");
            reservation.setRsvPaymentStat("PAID");
            reservationService.insertReservation(reservation);

            return "redirect:/reservation/detailJY?seq=" + reservation.getRsvSeq();

        } catch (Exception e) {
            model.addAttribute("error", "예약 처리 중 오류가 발생했습니다: " + e.getMessage());
            return "redirect:/payment/chargeMileage";
        }
    }

    private LocalDate parseFlexibleDate(String dateStr) {
        List<DateTimeFormatter> formatters = Arrays.asList(
            DateTimeFormatter.ofPattern("yyyy-MM-dd"),
            DateTimeFormatter.ofPattern("yyyyMMdd")
        );

        String trimmedDate = dateStr.trim();

        for (DateTimeFormatter formatter : formatters) {
            try {
                return LocalDate.parse(trimmedDate, formatter);
            } catch (Exception e) {
                logger.debug("날짜 파싱 실패: {} with formatter {}", trimmedDate, formatter);
            }
        }

        throw new IllegalArgumentException("지원하지 않는 날짜 형식입니다: " + dateStr);
    }
    
    private String convertTimeToHHmm(String timeStr) {
        if (timeStr == null || timeStr.isEmpty()) {
            return null;
        }
        return timeStr.replace(":", "");
    }

    private int getUserMileage(String userId) {
        Integer mileage = mileageHistoryDao.selectCurrentMileageByUserId(userId);
        return (mileage != null) ? mileage.intValue() : 0;
    }

    @GetMapping("/mileageHistory")
    public String showMileageHistory(@RequestParam(value = "code", required = false) Integer code,
                                     @RequestParam(value = "msg", required = false) String msg,
                                     HttpSession session,
                                     Model model)
    {
        String userId = (String) session.getAttribute("SESSION_USER_ID");
        
        if (userId == null || userId.isEmpty()) {
            return "redirect:/user/login";
        }

        List<MileageHistory> historyList = mileageHistoryDao.selectMileageHistoryByUserId(userId);
        int remainingMileage = getUserMileage(userId);

        model.addAttribute("code", code);
        model.addAttribute("msg", msg);
        model.addAttribute("mileageHistoryList", historyList);
        model.addAttribute("remainingMileage", remainingMileage);

        return "/payment/mileageHistory";
    }
}
