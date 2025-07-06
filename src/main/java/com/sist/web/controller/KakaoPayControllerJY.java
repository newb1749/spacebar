package com.sist.web.controller;

<<<<<<< HEAD
import java.net.URI;
import java.util.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.*;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;

import com.sist.web.model.MiliageHistory;
import com.sist.web.model.ReservationJY;
import com.sist.web.service.MileageServiceJY;
import com.sist.web.service.ReservationServiceJY;
import com.sist.web.service.UserService_mj;

@Controller
@RequestMapping("/payment")
public class KakaoPayControllerJY
{
    @Autowired
    private UserService_mj userService_mj;    
    
    @Autowired
    private MileageServiceJY mileageService;
    
    @Autowired
    private ReservationServiceJY reservationService;
    
    @Value("#{env['auth.session.name']}")
    private String AUTH_SESSION_NAME;

    /**
     * 카카오페이 결제 준비 (Ajax)
     */
    @PostMapping("/readyAjax")
    @ResponseBody
    public Map<String, Object> kakaoPayReady(@RequestParam int chargeAmount, HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        try {
            String itemName = "마일리지 충전";

            RestTemplate restTemplate = new RestTemplate();
            HttpHeaders headers = new HttpHeaders();
            headers.set("Authorization", "KakaoAK [ADMIN_KEY]");
            headers.set("Content-type", "application/x-www-form-urlencoded;charset=utf-8");

            String orderId = UUID.randomUUID().toString();
            session.setAttribute("orderId", orderId);

            String userId = (String) session.getAttribute("userId");
            if (userId == null) userId = "user001";
            session.setAttribute("userId", userId);
            session.setAttribute("chargeAmount", chargeAmount);

            MultiValueMap<String, String> params = new LinkedMultiValueMap<>();
            params.add("cid", "TC0ONETIME");
            params.add("partner_order_id", orderId);
            params.add("partner_user_id", userId);
            params.add("item_name", itemName);
            params.add("quantity", "1");
            params.add("total_amount", String.valueOf(chargeAmount));
            params.add("tax_free_amount", "0");
            params.add("approval_url", "http://localhost:8080/payment/success");
            params.add("cancel_url", "http://localhost:8080/payment/cancel");
            params.add("fail_url", "http://localhost:8080/payment/fail");

            HttpEntity<MultiValueMap<String, String>> request = new HttpEntity<>(params, headers);
            ResponseEntity<Map> response = restTemplate.postForEntity(
                    URI.create("https://kapi.kakao.com/v1/payment/ready"), request, Map.class);

            session.setAttribute("tid", response.getBody().get("tid"));
            result.put("code", 0);
            result.put("data", response.getBody());
        } catch (Exception e) {
            result.put("code", -1);
            result.put("msg", "결제 준비 실패: " + e.getMessage());
        }
        return result;
    }

    /**
     * 카카오페이 결제 성공 후 승인 처리
     */
    @GetMapping("/success")
    public String kakaoPayApprove(@RequestParam String pg_token, HttpSession session, Model model) {
        try {
            String tid = (String) session.getAttribute("tid");
            String orderId = (String) session.getAttribute("orderId");
            String userId = (String) session.getAttribute("userId");

            HttpHeaders headers = new HttpHeaders();
            headers.set("Authorization", "KakaoAK [ADMIN_KEY]");
            headers.set("Content-type", "application/x-www-form-urlencoded;charset=utf-8");

            MultiValueMap<String, String> params = new LinkedMultiValueMap<>();
            params.add("cid", "TC0ONETIME");
            params.add("tid", tid);
            params.add("partner_order_id", orderId);
            params.add("partner_user_id", userId);
            params.add("pg_token", pg_token);

            HttpEntity<MultiValueMap<String, String>> request = new HttpEntity<>(params, headers);
            RestTemplate restTemplate = new RestTemplate();
            ResponseEntity<Map> response = restTemplate.postForEntity(
                    URI.create("https://kapi.kakao.com/v1/payment/approve"), request, Map.class);

            Map amountMap = (Map) response.getBody().get("amount");
            int amount = (int) amountMap.get("total");
            userService_mj.chargeMileage(userId, amount);

            session.setAttribute("paymentStatus", "SUCCESS");

            model.addAttribute("result", "success");
            model.addAttribute("info", response.getBody());

        } 
        catch (Exception e) 
        {
            session.setAttribute("paymentStatus", "FAIL");
            model.addAttribute("result", "fail");
            model.addAttribute("message", "카카오페이 결제 처리 중 오류가 발생하였습니다.");
        }
        return "/payment/result";
    }

    /**
     * 결제 취소 페이지
     */
    @GetMapping("/cancel")
    public String cancelPage(HttpSession session, Model model) {
        session.setAttribute("paymentStatus", "CANCEL");
        model.addAttribute("result", "fail");
        model.addAttribute("message", "카카오페이 결제가 취소되었습니다.");
        return "payment/result";
    }

    /**
     * 결제 실패 페이지
     */
    @GetMapping("/fail")
    public String failPage(HttpSession session, Model model) {
        session.setAttribute("paymentStatus", "FAIL");
        model.addAttribute("result", "fail");
        model.addAttribute("message", "카카오페이 결제 중 오류가 발생하였습니다.");
        return "/payment/result";
    }

    /**
     * 결제 상태 확인 (Ajax)
     */
    @GetMapping("/checkPaymentStatus")
    @ResponseBody
    public Map<String, Object> checkPaymentStatus(HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        String paymentStatus = (String) session.getAttribute("paymentStatus");
        if (paymentStatus == null) paymentStatus = "UNKNOWN";

        String userId = (String) session.getAttribute("userId");
        int currentMileage = 0;
        if (userId != null) {
            currentMileage = userService_mj.getCurrentMileage(userId);
        }

        result.put("code", 0);
        result.put("status", paymentStatus);
        result.put("currentMileage", currentMileage);
        return result;
    }

    /**
     * 결제 확인 화면
     */
    @GetMapping("/paymentConfirm")
    public String paymentConfirm(HttpSession session, Model model) {
        String paymentStatus = (String) session.getAttribute("paymentStatus");
        if (paymentStatus == null) paymentStatus = "UNKNOWN";

        String userId = (String) session.getAttribute("userId");
        int currentMileage = 0;
        if (userId != null) {
            currentMileage = userService_mj.getCurrentMileage(userId);
        }

        model.addAttribute("status", paymentStatus);
        model.addAttribute("currentMileage", currentMileage);
        return "/payment/paymentConfirm";
    }

    /**
     * 마일리지 내역 조회 화면
     */
    @GetMapping("/payment/history")
    public String mileageHistory(HttpSession session, Model model) {
        String userId = (String) session.getAttribute("userId");
        if (userId != null) {
            List<MiliageHistory> mileageList = userService_mj.getMileageHistory(userId);
            model.addAttribute("mileageList", mileageList);
        }
        return "/payment/mileageHistory";
    }

    /**
     * 마일리지 차감 처리 (Ajax)
     */
    @PostMapping("/deductMileage")
    @ResponseBody
    public Map<String, Object> deductMileage(@RequestParam int amount, HttpSession session) {
        String userId = (String) session.getAttribute("userId");
        Map<String, Object> result = new HashMap<>();
        try {
            boolean success = userService_mj.deductMileage(userId, amount);
            result.put("code", success ? 0 : -1);
            result.put("msg", success ? "마일리지 사용 완료" : "잔액 부족");
        } catch (Exception e) {
            result.put("code", -9);
            result.put("msg", "오류: " + e.getMessage());
        }
        return result;
    }

    /**
     * 마일리지 환불 처리 (Ajax)
     */
    @PostMapping("/refundMileage")
    @ResponseBody
    public Map<String, Object> refundMileage(@RequestParam int amount, HttpSession session) {
        String userId = (String) session.getAttribute("userId");
        Map<String, Object> result = new HashMap<>();
        try {
            boolean success = userService_mj.refundMileage(userId, amount);
            result.put("code", success ? 0 : -1);
            result.put("msg", success ? "환불 완료" : "환불 실패");
        } catch (Exception e) {
            result.put("code", -9);
            result.put("msg", "오류: " + e.getMessage());
        }
        return result;
    }

    /**
     * 마일리지 충전 페이지(GET)
     */
    @GetMapping("/chargeMileage")
    public String showChargeMileagePage() {
        return "/payment/chargeMileage";  // /WEB-INF/views/payment/chargeMileage.jsp
    }

    /**
     * 마일리지 차감 후 예약 결제 처리 (POST)
=======
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
     * 클라이언트(폼, 쿼리스트링 등)에서 넘어오는 문자열을 LocalDate 타입으로 변환할 때
     * 기본 변환기 대신 yyyy-MM-dd 형식으로 파싱하도록 맞춤 처리
     * WebDataBinder에 LocalDate.class 전용 커스텀 에디터 등록
     * setAsText() : 폼 등에서 넘어온 String → LocalDate 변환(값이 없거나 빈 문자열이면 null 처리)
     * getAsText() : LocalDate → String 변환 시 yyyy-MM-dd 포맷으로 출력
     * 컨트롤러 메서드의 @RequestParam이나 @ModelAttribute에 LocalDate가 있을 때,
     * 클라이언트가 "2025-07-04" 같은 날짜 문자열을 보내면 자동으로 LocalDate로 변환시키려고 작성함
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
     * @PostMapping("/readyAjax") 메서드는 Ajax 요청으로 카카오페이 결제 준비(결제 요청 시작)를 처리하는 API 엔드포인트
     * 클라이언트가 충전할 금액(chargeAmount)을 전달하면,
     * 카카오페이 결제 준비 요청을 외부 카카오페이 서비스에 보내고,
     * 응답받은 거래 ID(TID)와 주문 ID를 세션에 저장 후,
     * 결제 진행 URL(next_redirect_pc_url)을 JSON 형태로 클라이언트에 반환
     * 사용자 세션 확인	로그인된 사용자 ID 추출
     * 결제 준비 요청	카카오페이 API에 결제 준비 요청 전달
     * 세션 저장	거래 ID(TID), 주문 ID, 충전금액 세션에 저장
     * 결과 반환	결제 진행 URL을 JSON 형태로 반환
     * 오류 처리	오류 발생 시 에러 코드와 메시지를 반환
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
     * @GetMapping("/success") 메서드는 카카오페이 결제 승인 후 호출되는 콜백 처리 및 마일리지 충전 완료 처리 로직
     * 카카오페이에서 결제 승인 후 리다이렉트되는 URL 핸들러
     * 세션에서 결제 관련 정보(TID, 주문 ID 등)를 꺼내고,
     * 카카오페이 승인 API 호출하여 결제 완료 여부 확인
     * 성공 시 사용자 마일리지 충전 처리
     * 예약이 세션에 남아 있으면 예약 상세 페이지로 이동, 없으면 메인으로 리다이렉트
     * 실패 시 에러 메시지 출력 및 결과 페이지 표시
     * 세션에서 필요한 정보 조회
     * 카카오페이 결제 승인 API 호출
     * 승인 성공 시 마일리지 충전
     * 예약 정보가 세션에 남아 있을 경우 처리
     * 승인 실패 처리
     * 세션 정리 및 결과 페이지 반환
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
     * 카카오페이 결제 중 사용자 취소 또는 결제 실패 시 호출되는 공통 처리 핸들러
     * 매핑 경로: /cancel 또는 /fail (GET 요청)
     * 역할: 요청 URI를 확인해서 결제 취소인지, 결제 실패인지를 구분
     * 각각에 맞는 메시지를 모델에 담아서 결과 페이지(/payment/result.jsp)로 포워딩
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
     * /chargeMileage 경로(GET 요청)로 접근했을 때,
     * 마일리지 충전 페이지(/payment/chargeMileage.jsp)를 단순히 보여주기 위한 컨트롤러 핸들러
     * URL: /chargeMileage
     * HTTP 메서드: GET
     * 역할: 마일리지 충전 페이지 뷰 반환
     * 반환 뷰 이름: /payment/chargeMileage
     * 별도의 파라미터 처리나 세션 체크 없이 단순히 JSP 경로 문자열을 반환해 화면을 보여줌
     * @return
     */
    @GetMapping("/chargeMileage")
    public String showChargeMileagePage()
    {
        return "/payment/chargeMileage";
    }

    // 마일리지 차감 후 예약 결제 처리 (POST)
    /**
     * 마일리지로 결제를 처리하고 예약을 확정하는 기능
     * 로그인 확인
     * 체크인/체크아웃 날짜 및 시간 파싱 후 DB 형식으로 변환
     * 사용자의 현재 마일리지 조회 및 차감 가능 여부 확인
     * 마일리지 차감 시도
     * 차감 성공 시 예약 상태를 확정하고 예약 데이터 저장
     * 예약 상세 페이지로 리다이렉트
     * 예외 및 오류 처리
     * 로그인 검사
     * 날짜 및 시간 파싱
     * 마일리지 차감 가능 여부 확인
     * 마일리지 차감 시도
     * 예약 정보 저장
     * 예약 상세 페이지로 이동
     * 예외 처리
     * @param reservation
     * @param request
     * @param model
     * @return
>>>>>>> origin/feature/mileage
     */
    @PostMapping("/chargeMileage")
    public String chargeMileageAndPay(@ModelAttribute ReservationJY reservation,
                                      HttpServletRequest request,
                                      Model model) 
    {
        String guestId = (String) request.getSession().getAttribute("sessionUserId");
<<<<<<< HEAD
        if (guestId == null || guestId.isEmpty()) 
        {
=======
        if (guestId == null || guestId.isEmpty()) {
>>>>>>> origin/feature/mileage
            model.addAttribute("error", "로그인이 필요합니다.");
            return "redirect:/user/login";
        }

<<<<<<< HEAD
        try 
        {
            // 사용자 마일리지 조회
            int userMileage = mileageService.getUserMileage(guestId);

            // 결제 금액
            int finalAmt = reservation.getFinalAmt();

            if(userMileage < finalAmt) 
            {
=======
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
>>>>>>> origin/feature/mileage
                model.addAttribute("error", "마일리지가 부족합니다.");
                return "redirect:/payment/chargeMileage";
            }

<<<<<<< HEAD
            // 마일리지 차감
            mileageService.deductMileage(guestId, finalAmt);
            request.getSession().setAttribute("userMileage", userMileage - finalAmt);

            // 예약 저장
=======
            boolean deducted = userService.deductMileage(guestId, finalAmt);
            if (!deducted) {
                model.addAttribute("error", "마일리지 차감에 실패했습니다.");
                return "redirect:/payment/chargeMileage";
            }

>>>>>>> origin/feature/mileage
            reservation.setGuestId(guestId);
            reservation.setRsvStat("CONFIRMED");
            reservation.setRsvPaymentStat("PAID");
            reservationService.insertReservation(reservation);

<<<<<<< HEAD
            // 예약 PK(예: rsvSeq) 받아오기 (insert 후 얻어야 함)
            int rsvSeq = reservation.getRsvSeq(); // 예약 PK가 set 되어있어야 함

            // 리다이렉트 시 예약 상세 페이지로 이동
            return "redirect:/reservation/detail?seq=" + rsvSeq;

        } 
        catch(Exception e) 
        {
=======
            return "redirect:/reservation/detail?seq=" + reservation.getRsvSeq();

        } catch (Exception e) {
>>>>>>> origin/feature/mileage
            model.addAttribute("error", "예약 처리 중 오류가 발생했습니다: " + e.getMessage());
            return "redirect:/payment/chargeMileage";
        }
    }
<<<<<<< HEAD
}
=======

    // 시간 변환 헬퍼 메서드 추가
    private String convertTimeToHHmm(String timeStr) 
    {
        if (timeStr == null || timeStr.isEmpty()) {
            return null;
        }
        return timeStr.replace(":", "");  // "10:00" -> "1000"
    }
}
>>>>>>> origin/feature/mileage
