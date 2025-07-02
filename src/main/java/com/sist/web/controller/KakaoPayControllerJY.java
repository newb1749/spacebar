package com.sist.web.controller;

import java.net.URI;
import java.util.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
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
     */
    @PostMapping("/chargeMileage")
    public String chargeMileageAndPay(@ModelAttribute ReservationJY reservation,
                                      HttpServletRequest request,
                                      Model model) 
    {
        String guestId = (String) request.getSession().getAttribute("sessionUserId");
        if (guestId == null || guestId.isEmpty()) 
        {
            model.addAttribute("error", "로그인이 필요합니다.");
            return "redirect:/user/login";
        }

        try 
        {
            // 사용자 마일리지 조회
            int userMileage = mileageService.getUserMileage(guestId);

            // 결제 금액
            int finalAmt = reservation.getFinalAmt();

            if(userMileage < finalAmt) 
            {
                model.addAttribute("error", "마일리지가 부족합니다.");
                return "redirect:/payment/chargeMileage";
            }

            // 마일리지 차감
            mileageService.deductMileage(guestId, finalAmt);
            request.getSession().setAttribute("userMileage", userMileage - finalAmt);

            // 예약 저장
            reservation.setGuestId(guestId);
            reservation.setRsvStat("CONFIRMED");
            reservation.setRsvPaymentStat("PAID");
            reservationService.insertReservation(reservation);

            // 예약 PK(예: rsvSeq) 받아오기 (insert 후 얻어야 함)
            int rsvSeq = reservation.getRsvSeq(); // 예약 PK가 set 되어있어야 함

            // 리다이렉트 시 예약 상세 페이지로 이동
            return "redirect:/reservation/detail?seq=" + rsvSeq;

        } 
        catch(Exception e) 
        {
            model.addAttribute("error", "예약 처리 중 오류가 발생했습니다: " + e.getMessage());
            return "redirect:/payment/chargeMileage";
        }
    }
}
