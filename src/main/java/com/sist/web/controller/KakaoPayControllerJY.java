package com.sist.web.controller;

import com.sist.web.model.*;
import com.sist.web.service.KakaoPayServiceJY;
import com.sist.web.service.ReservationServiceJY;
import com.sist.web.service.UserService_mj;
import com.sist.web.util.SessionUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.*;

import java.beans.PropertyEditorSupport;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

@Controller
@RequestMapping("/payment")
public class KakaoPayControllerJY 
{
    @Autowired
    private KakaoPayServiceJY kakaoService;

    @Autowired
    private UserService_mj userService;

    @Autowired
    private ReservationServiceJY reservationService;

    /**
     * 카카오페이 거래 ID(TID)를 세션에 저장할 때 사용할 키 이름
     */
    @Value("${kakaopay.tid.session.name}")
    private String TID_SESSION;

    /**
     * 카카오페이 주문 ID(Order ID)를 세션에 저장할 때 사용할 키 이름
     */
    @Value("${kakaopay.orderid.session.name}")
    private String ORDER_SESSION;
    
    /**
     * 기본 변환기 대신 yyyy-MM-dd 형식으로 파싱하도록 맞춤 처리
     * @InitBinder 메서드는 스프링 MVC에서 폼 요청 파라미터를 특정 타입으로 변환할 때 커스텀 바인딩 로직을 등록하는 용도
     * @param binder
     */
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

    // 카카오페이 결제 준비 (Ajax)
    /**
     * @param req
     * @return
     */
    @PostMapping("/readyAjax")
    @ResponseBody
    public Response<Map<String, String>> readyAjax(HttpServletRequest req) 
    {
        Response<Map<String, String>> res = new Response<>();
        try 
        {
            String userId = (String) req.getSession().getAttribute("sessionUserId");
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

    // 카카오페이 결제 승인
    /**
     * @param req   HTTP 요청 및 세션 정보
	 * @param model JSP에 전달할 데이터 모델
	 * @return 예약 상세 페이지 또는 결제 결과 페이지 뷰 경로
     */
    @GetMapping("/success")
    public String success(HttpServletRequest req, Model model) 
    {
        HttpSession session = req.getSession(false);
        String tid = String.valueOf(SessionUtil.getSession(session, TID_SESSION));
        String orderId = String.valueOf(SessionUtil.getSession(session, ORDER_SESSION));
        String userId = (String) session.getAttribute("sessionUserId");
        String pg = req.getParameter("pg_token");

        KakaoPayApproveRequest ar = new KakaoPayApproveRequest(tid, orderId, userId, pg);
        KakaoPayApproveResponse ap = kakaoService.approve(ar);

        if (ap != null && ap.getAmount() != null) {
            userService.chargeMileage(userId, ap.getAmount().getTotal());
            model.addAttribute("code", 0);
            model.addAttribute("msg", "충전 완료: " + ap.getAmount().getTotal() + "원");

            ReservationJY pending = (ReservationJY) session.getAttribute("pendingReservation");
            if (pending != null) {
                model.addAttribute("reservation", pending);
                session.removeAttribute("pendingReservation");
                return "/reservation/detailJY";
            } else {
                model.addAttribute("msg", "예약 정보가 없어 메인으로 이동합니다.");
                return "redirect:/reservation/detailJY";
            }
        } else {
            model.addAttribute("code", -1);
            model.addAttribute("msg", "결제 승인 실패");
        }

        SessionUtil.removeSession(session, TID_SESSION);
        SessionUtil.removeSession(session, ORDER_SESSION);

        return "/payment/result";
    }

    // 결제 취소 및 실패 페이지
    /**
     * @param req
     * @param model
     * @return
     */
    @GetMapping({"/cancel", "/fail"})
    public String cancelFail(HttpServletRequest req, Model model) 
    {
        String uri = req.getRequestURI();
        model.addAttribute("code", -1);
        model.addAttribute("msg", uri.endsWith("cancel") ? "결제 취소됨" : "결제 실패");
        return "/payment/result";
    }

    // 마일리지 충전 페이지(GET)
    /**
     * @return
     */
    @GetMapping("/chargeMileage")
    public String showChargeMileagePage()
    {
        return "/payment/chargeMileage";
    }

    // 마일리지 차감 후 예약 결제 처리 (POST)
    /**
     * @param reservation
     * @param request
     * @param model
     * @return
     */
    @PostMapping("/chargeMileage")
    public String chargeMileageAndPay(@ModelAttribute ReservationJY reservation,
                                      HttpServletRequest request,
                                      Model model) 
    {
        String guestId = (String) request.getSession().getAttribute("sessionUserId");
        if (guestId == null || guestId.isEmpty()) {
            model.addAttribute("error", "로그인이 필요합니다.");
            return "redirect:/user/login";
        }

        try {
            String checkIn = request.getParameter("rsvCheckInDt");
            String checkOut = request.getParameter("rsvCheckOutDt");
            String checkInTime = request.getParameter("rsvCheckInTime");   // "HH:mm"
            String checkOutTime = request.getParameter("rsvCheckOutTime"); // "HH:mm"

            DateTimeFormatter inputFormat = DateTimeFormatter.ofPattern("yyyy-MM-dd");
            DateTimeFormatter dbFormat = DateTimeFormatter.ofPattern("yyyyMMdd");

            LocalDate checkInDate = LocalDate.parse(checkIn, inputFormat);
            LocalDate checkOutDate = LocalDate.parse(checkOut, inputFormat);

            reservation.setRsvCheckInDt(checkInDate.format(dbFormat));    // DB용 포맷으로 변환
            reservation.setRsvCheckOutDt(checkOutDate.format(dbFormat));

            // 시간 변환: "HH:mm" -> "HHmm"
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

            return "redirect:/reservation/detail?seq=" + reservation.getRsvSeq();

        } catch (Exception e) {
            model.addAttribute("error", "예약 처리 중 오류가 발생했습니다: " + e.getMessage());
            return "redirect:/payment/chargeMileage";
        }
    }

    // 시간 변환 헬퍼 메서드 추가
    private String convertTimeToHHmm(String timeStr) 
    {
        if (timeStr == null || timeStr.isEmpty()) {
            return null;
        }
        return timeStr.replace(":", "");  // "10:00" -> "1000"
    }
}
