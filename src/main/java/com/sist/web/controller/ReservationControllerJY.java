package com.sist.web.controller;

import com.sist.web.dao.MileageHistoryDao;
import com.sist.web.dao.ReservationDao;
import com.sist.web.model.Coupon;
import com.sist.web.model.MileageHistory;
import com.sist.web.model.Reservation;
import com.sist.web.model.RoomType;
import com.sist.web.service.CouponServiceJY;
import com.sist.web.service.MileageHistoryService;
import com.sist.web.service.MileageServiceJY;
import com.sist.web.service.ReservationServiceJY;
import com.sist.web.service.RoomService;
import com.sist.web.service.RoomTypeService;
import com.sist.web.service.UserService_mj;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.text.SimpleDateFormat;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Arrays;
import java.util.Date;
import java.util.List;
import java.util.Map;

@Controller
public class ReservationControllerJY {

    private static Logger logger = LoggerFactory.getLogger(ReservationControllerJY.class);
    private static final DateTimeFormatter DB_FORMAT = DateTimeFormatter.ofPattern("yyyyMMdd");

    @Autowired
    private UserService_mj userService;

    @Autowired
    private RoomTypeService roomTypeService;

    @Autowired
    private ReservationDao reservationDao;

    @Autowired
    private RoomService roomService;

    @Autowired
    private ReservationServiceJY reservationService;

    @Autowired
    private MileageHistoryDao mileageHistoryDao;

    @Autowired
    private MileageHistoryService mileageHistoryService;
    
    @Autowired
    private MileageServiceJY mileageService;

    @Autowired
    private CouponServiceJY couponService;
        
    @GetMapping("/reservation/step1JY")
    public String reservationStep1(@RequestParam("roomTypeSeq") Integer roomTypeSeq,
                                   @RequestParam("checkIn") String checkIn,
                                   @RequestParam("checkOut") String checkOut,
                                   @RequestParam(value = "numGuests", defaultValue = "1") int numGuests,
                                   @RequestParam("checkInTime") String checkInTime,
                                   @RequestParam("checkOutTime") String checkOutTime,
                                   @RequestParam("roomCatSeq") Integer roomCatSeq,
                                   Model model, HttpServletRequest request) {
        String sessionUserId = (String) request.getSession().getAttribute("SESSION_USER_ID");
        if (sessionUserId == null || sessionUserId.isEmpty()) {
            model.addAttribute("error", "로그인이 필요합니다.");
            return "redirect:/user/login";
        }
        if (roomTypeSeq == null || checkIn == null || checkOut == null || checkIn.isEmpty() || checkOut.isEmpty()) {
            model.addAttribute("error", "예약 정보가 누락되었습니다. 숙소 목록으로 돌아갑니다.");
            return "redirect:/room/roomList";
        }
        model.addAttribute("roomTypeSeq", roomTypeSeq);
        model.addAttribute("checkIn", checkIn);
        model.addAttribute("checkOut", checkOut);
        model.addAttribute("numGuests", numGuests);
        model.addAttribute("checkInTime", checkInTime);
        model.addAttribute("checkOutTime", checkOutTime);
        model.addAttribute("roomCatSeq", roomCatSeq);
        return "/reservation/step1JY";
    }

    private void insertReservation(Reservation reservation) throws Exception {
        if (reservation.getHostId() == null || reservation.getHostId().trim().isEmpty()) {
            Integer roomTypeSeq = reservation.getRoomTypeSeq();
            if (roomTypeSeq == null) {
                throw new IllegalArgumentException("roomTypeSeq가 null입니다.");
            }
            RoomType roomType = roomTypeService.getRoomType(roomTypeSeq);
            if (roomType == null) {
                throw new IllegalArgumentException("roomType이 존재하지 않습니다. roomTypeSeq: " + roomTypeSeq);
            }
            String hostId = roomType.getHostId();
            if (hostId == null || hostId.trim().isEmpty()) {
                int roomSeq = roomType.getRoomSeq();
                hostId = reservationDao.selectHostIdByRoomSeq(roomSeq);
                if (hostId == null || hostId.trim().isEmpty()) {
                    throw new IllegalArgumentException("호스트 정보가 없습니다. roomSeq: " + roomSeq);
                }
            }
            reservation.setHostId(hostId.trim());
            reservation.setRoomTypeTitle(roomType.getRoomTypeTitle());
        }
        if (reservation.getHostId() == null || reservation.getHostId().trim().isEmpty()) {
            throw new IllegalArgumentException("HOST_ID가 여전히 null입니다.");
        }
        reservationDao.insertReservation(reservation);
    }

    @PostMapping("/reservation/detailJY")
    public String reservationDetailJY(@ModelAttribute Reservation reservation,
                                      HttpServletRequest request,
                                      HttpSession session,
                                      Model model) {
        String guestId = (String) request.getSession().getAttribute("SESSION_USER_ID");
        if (guestId == null || guestId.isEmpty()) {
            return "redirect:/user/login";
        }
        reservation.setGuestId(guestId);

        RoomType roomType = roomTypeService.getRoomType(reservation.getRoomTypeSeq());
        if (roomType != null) {
            reservation.setHostId(roomType.getHostId());
            reservation.setRoomTypeTitle(roomType.getRoomTypeTitle());
        }

        int totalAmt = calculateTotalAmount(reservation.getRoomTypeSeq(),
                reservation.getRsvCheckInDt(),
                reservation.getRsvCheckOutDt());

        reservation.setTotalAmt(totalAmt);
        reservationService.calculateFinalAmount(reservation);  

        String userId = (String) session.getAttribute("SESSION_USER_ID");
        // 쿠폰 및 마일리지 정보 조회
        logger.debug("88888888888888888888888888888888");
        List<Coupon> couponList = couponService.getAvailableCouponsForUser(userId);
        
        logger.debug("999999999999999999999999999999999999");
        
        model.addAttribute("reservation", reservation);
        
        if(couponList != null)
        {
            model.addAttribute("couponList", couponList);
        }

        long userMileage = getUserMileage(guestId);
        model.addAttribute("userMileage", userMileage);
        model.addAttribute("reservation", reservation);

        return "/reservation/detailJY";
    }

    @GetMapping("/reservation/detailJY")
    public String reservationDetail(@RequestParam(value = "rsvSeq", required = false) Integer rsvSeq,
                                    HttpSession session,
                                    Model model) {
    	logger.debug("88888888888888888888888888888");
        Reservation reservation = null;
        String userId = (String) session.getAttribute("SESSION_USER_ID");

        logger.debug("예약시 총 금액===================");
        logger.debug("예약시 rsvSeq : " + rsvSeq);
        logger.debug("예약시 총 금액===================");
        
        if (rsvSeq != null && rsvSeq > 0) {
            reservation = reservationDao.selectReservationById(rsvSeq);
        }

        if (reservation == null) {
            reservation = (Reservation) session.getAttribute("pendingReservation");
            if (reservation != null) {
                rsvSeq = reservation.getRsvSeq();
            }
        }

        if (reservation == null) {
            // rsvSeq가 없으면 오류 페이지 또는 예약 목록으로 리다이렉트
            return "redirect:/reservation/list";
            // 또는 
            // return "redirect:/payment/paymentConfirm?error=예약 정보가 없습니다.";
        }

        // 쿠폰 및 마일리지 정보 조회
        List<Coupon> couponList = couponService.getAvailableCouponsForUser(userId);
        
        logger.debug("예약시 총 금액===================");
        
        model.addAttribute("reservation", reservation);
        
        if(couponList != null)
        {
            model.addAttribute("couponList", couponList);
        }

        String guestId = (String) session.getAttribute("SESSION_USER_ID");
        if (guestId != null) {
            long mileage = getUserMileage(guestId);
            model.addAttribute("userMileage", mileage);
        }

        return "/reservation/detailJY";
    }

    @GetMapping("/reservation/list")
    public String reservationList(HttpSession session, Model model) {
        String userId = (String) session.getAttribute("SESSION_USER_ID");
        if (userId == null) {
            return "redirect:/user/login";
        }

        List<Reservation> reservations = reservationService.getReservationsByGuestId(userId);

        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
        for (Reservation r : reservations) {
            try {
                if (r.getRsvCheckInDt() != null) {
                    Date checkInDate = sdf.parse(r.getRsvCheckInDt());
                    r.setRsvCheckInDateObj(checkInDate);
                }
                if (r.getRsvCheckOutDt() != null) {
                    Date checkOutDate = sdf.parse(r.getRsvCheckOutDt());
                    r.setRsvCheckOutDateObj(checkOutDate);
                }
            } catch (Exception e) {
                // 필요시 로그 기록
            }
        }

        model.addAttribute("reservations", reservations);
        return "redirect:/reservation/reservationHistoryJY";
    }

    @PostMapping("/payment/mileagePay")
    public String processMileagePaymentWithReservation(@ModelAttribute Reservation reservation,
                                                       HttpSession session,
                                                       RedirectAttributes redirectAttrs) {
        logger.info("processMileagePaymentWithReservation 진입");
        String userId = (String) session.getAttribute("SESSION_USER_ID");
        if (userId == null || userId.isEmpty()) {
            redirectAttrs.addFlashAttribute("error", "로그인이 필요합니다.");
            return "redirect:/user/login";
        }
        reservation.setGuestId(userId);
        
        logger.info("couponSeq = {}", reservation.getCouponSeq());

        long userMileage = getUserMileage(userId);
        if (userMileage < reservation.getFinalAmt()) {
            session.setAttribute("pendingReservation", reservation);
            return "redirect:/reservation/chargeMileage";
        }

        boolean deducted = deductMileage(userId, reservation.getFinalAmt());
        if (!deducted) {
            redirectAttrs.addFlashAttribute("error", "마일리지 결제 실패");
            return "redirect:/reservation/detailJY?rsvSeq=" + reservation.getRsvSeq();
        }

        try {
            reservationService.insertReservation(reservation);

            if (reservation.getCouponSeq() != null) {
                logger.info("쿠폰 사용 완료 처리 시작: userId={}, cpnSeq={}", userId, reservation.getCouponSeq());
                couponService.markCouponAsUsed(userId, reservation.getCouponSeq());
                logger.info("쿠폰 사용 완료 처리 종료");
            }

            logger.info("예약 저장 후 rsvSeq: {}", reservation.getRsvSeq());

            if (reservation.getRsvSeq() == null || reservation.getRsvSeq() <= 0) {
                redirectAttrs.addFlashAttribute("error", "예약 번호가 유효하지 않습니다.");
                return "redirect:/reservation/detailJY";
            }

        } catch (Exception e) {
            redirectAttrs.addFlashAttribute("error", "예약 저장 중 오류 발생: " + e.getMessage());
            return "redirect:/reservation/detailJY";
        }

        session.removeAttribute("pendingReservation");

        int seq = reservation.getRsvSeq() != null ? reservation.getRsvSeq() : -1;
        return "redirect:/payment/paymentConfirm?rsvSeq=" + seq;
    }

    // == chargeMileage 경로 확실히 /reservation/chargeMileage 로 수정 ==
    @GetMapping("/reservation/chargeMileage")
    public String showChargeMileagePage(HttpSession session, Model model) {
        String userId = (String) session.getAttribute("SESSION_USER_ID");
        if (userId == null || userId.isEmpty()) {
            return "redirect:/user/login";
        }
        long userMileage = getUserMileage(userId);
        model.addAttribute("userMileage", userMileage);
        return "/payment/chargeMileage";
    }

    @PostMapping("/reservation/chargeMileage/only")
    public String processChargeMileageOnly(@RequestParam("chargeAmount") int chargeAmount,
                                           HttpSession session,
                                           RedirectAttributes redirectAttrs) {
        String userId = (String) session.getAttribute("SESSION_USER_ID");
        if (userId == null || userId.isEmpty()) {
            redirectAttrs.addFlashAttribute("error", "로그인이 필요합니다.");
            return "redirect:/user/login";
        }

        boolean chargeSuccess = mileageHistoryService.chargeMileage(userId, chargeAmount);

        if (!chargeSuccess) {
            redirectAttrs.addFlashAttribute("error", "마일리지 충전에 실패했습니다.");
            return "redirect:/payment/chargeMileage";
        }

        redirectAttrs.addFlashAttribute("msg", "마일리지 충전이 완료되었습니다.");
        return "redirect:/reservation/mileageHistory";
    }
    // == chargeMileage 경로 끝 ==

    @PostMapping("/reservation/cancel")
    public String cancelReservation(@ModelAttribute Reservation reservation,
                                    HttpSession session,
                                    RedirectAttributes redirectAttrs) {
        try {
            String userId = (String) session.getAttribute("SESSION_USER_ID");
            if (userId == null || userId.isEmpty()) {
                redirectAttrs.addFlashAttribute("error", "로그인이 필요합니다.");
                return "redirect:/user/login";
            }

            Reservation fullReservation = reservationDao.selectReservationBySeq(reservation.getRsvSeq());
            if (fullReservation == null || !userId.equals(fullReservation.getGuestId())) {
                redirectAttrs.addFlashAttribute("error", "잘못된 접근입니다.");
                return "redirect:/reservation/reservationHistoryJY";
            }

            fullReservation.setRsvStat("취소");
            fullReservation.setRsvPaymentStat("취소");
            fullReservation.setCancelDt(new Date());
            fullReservation.setRefundAmt(fullReservation.getFinalAmt());

            // 예약 취소 처리 및 마일리지 환불(내부에서 한번만 호출됨)
            reservationService.cancelReservation(fullReservation);

            redirectAttrs.addFlashAttribute("msg", "환불이 완료되었습니다.");
        } catch (Exception e) {
            redirectAttrs.addFlashAttribute("error", "환불 처리 중 오류가 발생했습니다: " + e.getMessage());
            return "redirect:/reservation/reservationHistoryJY";
        }

        return "redirect:/payment/mileageHistory";
    }
    
    private int calculateTotalAmount(int roomTypeSeq, String checkInDateStr, String checkOutDateStr) {
        RoomType roomType = roomTypeService.getRoomType(roomTypeSeq);
        
        logger.debug("######################################");
        logger.debug("roomTypeSeq : " + roomTypeSeq);
        logger.debug("checkInDateStr : " + checkInDateStr);
        logger.debug("checkOutDateStr : " + checkOutDateStr);
        logger.debug("######################################");
        if (roomType == null) {
            throw new IllegalArgumentException("존재하지 않는 객실 유형입니다.");
        }
        
        logger.debug("???????????????????????????????????");
        logger.debug("roomType.getWeekdayAmt() : " + roomType.getWeekdayAmt());
        logger.debug("roomType.getWeekendAmt() : " + roomType.getWeekendAmt());
        logger.debug("???????????????????????????????????");
        
        int weekdayAmt = roomType.getWeekdayAmt();
        int weekendAmt = roomType.getWeekendAmt();

        LocalDate checkIn = parseFlexibleDate(checkInDateStr);
        LocalDate checkOut = parseFlexibleDate(checkOutDateStr);
        
        //
        LocalDate date1 = checkIn;
        logger.debug("111111111111111111111111111111111111");
        logger.debug("checkIn : " + checkIn);
        logger.debug("checkOut : " + checkOut);
        logger.debug("date1.isBefore(checkOut) : " + date1.isBefore(checkOut));
        logger.debug("date1.plusDays(1) : " + date1.plusDays(1));
        logger.debug("DayOfWeek day = date.getDayOfWeek() : " + date1.getDayOfWeek());
        logger.debug("1111111111111111111111111111111111111");

        
        int totalAmount = 0;
        
        if(checkIn.isEqual(checkOut))
        {
            DayOfWeek day = checkIn.getDayOfWeek();
            if (day == DayOfWeek.FRIDAY || day == DayOfWeek.SATURDAY || day == DayOfWeek.SUNDAY) {
                totalAmount += weekendAmt;
            } else {
                totalAmount += weekdayAmt;
            }
        }
        else
        {
	        for (LocalDate date = checkIn; date.isBefore(checkOut); date = date.plusDays(1)) {
	            DayOfWeek day = date.getDayOfWeek();
	            if (day == DayOfWeek.FRIDAY || day == DayOfWeek.SATURDAY || day == DayOfWeek.SUNDAY) {
	                totalAmount += weekendAmt;
	            } else {
	                totalAmount += weekdayAmt;
	            }
	        }
    	
        }
        logger.debug("Calculated totalAmount = " + totalAmount); 
        return totalAmount;
    }

    private long getUserMileage(String userId) {
        Integer mileage = mileageHistoryDao.selectCurrentMileageByUserId(userId);
        return mileage != null ? mileage : 0;
    }

    private boolean deductMileage(String userId, int amount) {
        long currentMileage = getUserMileage(userId);
        if (currentMileage < amount) {
            return false;
        }
        int updatedRows = mileageHistoryDao.updateMileageDeduct(userId, amount);
        if (updatedRows > 0) {
            MileageHistory history = new MileageHistory();
            history.setUserId(userId);
            history.setTrxType("결제");
            history.setTrxAmt(-amount);
            history.setBalanceAfterTrx(currentMileage - amount);
            mileageHistoryDao.insertMileageHistory(history);
            return true;
        }
        return false;
    }

    private String convertTimeToHHmm(String timeStr) {
        if (timeStr == null || timeStr.isEmpty()) return null;
        return timeStr.replace(":", "");
    }

    @GetMapping("/payment/paymentConfirm")
    public String confirmReservation(@RequestParam(value = "rsvSeq", required = false) Integer rsvSeq,
                                     @RequestParam(value = "error", required = false) String error,
                                     Model model) {
        logger.info("=== paymentConfirm 호출 ===");
        logger.info("파라미터 rsvSeq = {}", rsvSeq);
        logger.info("파라미터 error = {}", error);

        if (error != null) {
            model.addAttribute("status", "ERROR");
            model.addAttribute("error", error);
            logger.warn("error 파라미터 존재: {}", error);
            return "/payment/paymentConfirm";
        }

        if (rsvSeq == null) {
            logger.error("rsvSeq가 null임");
            model.addAttribute("status", "ERROR");
            model.addAttribute("error", "잘못된 예약 번호입니다.");
            return "/payment/paymentConfirm";
        }
        if (rsvSeq <= 0) {
            logger.error("rsvSeq가 0 이하임: {}", rsvSeq);
            model.addAttribute("status", "ERROR");
            model.addAttribute("error", "잘못된 예약 번호입니다.");
            return "/payment/paymentConfirm";
        }

        Reservation reservation = reservationDao.selectReservationById(rsvSeq);
        if (reservation == null) {
            logger.error("예약 번호 {}에 해당하는 예약을 찾지 못함", rsvSeq);
            model.addAttribute("status", "ERROR");
            model.addAttribute("error", "예약 정보를 찾을 수 없습니다.");
            return "/payment/paymentConfirm";
        }

        logger.info("예약 정보 조회 성공: rsvSeq={}, guestId={}, hostId={}, totalAmt={}", 
                     reservation.getRsvSeq(), reservation.getGuestId(), reservation.getHostId(), reservation.getTotalAmt());

        model.addAttribute("reservation", reservation);
        model.addAttribute("status", "OK");
        return "/payment/paymentConfirm";
    }

    @GetMapping("/reservation/mileageHistory")
    public String mileageHistory(HttpSession session, Model model) {
        String userId = (String) session.getAttribute("SESSION_USER_ID");
        if (userId == null) {
            return "redirect:/user/login";
        }
        List<MileageHistory> mileageHistories = mileageHistoryDao.selectMileageHistoryByUserId(userId);
        model.addAttribute("mileageHistories", mileageHistories);
        return "/payment/mileageHistory";
    }
    
    // === 유연한 날짜 파싱 메서드 ===
    private LocalDate parseFlexibleDate(String dateStr) {
//        List<DateTimeFormatter> formatters = Arrays.asList(
//                DateTimeFormatter.ofPattern("yyyy-MM-dd"),
//                DateTimeFormatter.ofPattern("yyyyMMdd")
//        );
        
        List<DateTimeFormatter> formatters = Arrays.asList(
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
    @GetMapping("/reservation/reservationHistoryJY")
    public String reservationHistoryJY(HttpSession session, Model model) {
        String userId = (String) session.getAttribute("SESSION_USER_ID");
        if (userId == null) {
            return "redirect:/user/login";
        }
        List<Reservation> reservations = reservationService.getReservationsByGuestId(userId);

        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");

        for (Reservation r : reservations) {
            try {
                if (r.getRsvCheckInDt() != null) {
                    Date checkInDate = sdf.parse(r.getRsvCheckInDt());
                    r.setRsvCheckInDateObj(checkInDate);
                }
                if (r.getRsvCheckOutDt() != null) {
                    Date checkOutDate = sdf.parse(r.getRsvCheckOutDt());
                    r.setRsvCheckOutDateObj(checkOutDate);
                }
            } catch (Exception e) {
                // 필요 시 로깅
            }
        }

        model.addAttribute("reservations", reservations);
        return "/reservation/reservationHistoryJY";
    }

    @RequestMapping("/reservation/reservationConfirm")
    public String reservationConfirm(@RequestParam Map<String, String> params, Model model, HttpSession session) {
        String userId = (String) session.getAttribute("SESSION_USER_ID");
        if (userId == null) return "redirect:/index.jsp";

        // 예약 정보 구성
        Reservation reservation = new Reservation();
        reservation.setRoomTypeSeq(Integer.parseInt(params.get("roomTypeSeq")));
        reservation.setRsvCheckInDt(params.get("rsvCheckInDt"));
        reservation.setRsvCheckOutDt(params.get("rsvCheckOutDt"));
        reservation.setRsvCheckInTime(params.get("rsvCheckInTime"));
        reservation.setRsvCheckOutTime(params.get("rsvCheckOutTime"));
        reservation.setNumGuests(Integer.parseInt(params.get("numGuests")));
        reservation.setGuestMsg(params.get("guestMsg"));

        // 금액 계산 로직 필요시 작성
        int finalAmt = reservationService.calculateFinalAmount(reservation);
        reservation.setFinalAmt(finalAmt);

        // 쿠폰 및 마일리지 정보 조회
        List<Coupon> couponList = couponService.getAvailableCouponsForUser(userId);
        int userMileage = mileageService.getUserMileage(userId);

        model.addAttribute("reservation", reservation);
        model.addAttribute("couponList", couponList);
        model.addAttribute("userMileage", userMileage);
        model.addAttribute("now", new java.util.Date());

        return "reservation/reservationConfirm"; // jsp 경로
    }

    @PostMapping("/reservation/pay")
    public String pay(@ModelAttribute Reservation reservation, Model model) {
        int totalAmount = reservation.getTotalAmt();
        int finalAmount = totalAmount;

        Integer couponSeq = reservation.getCouponSeq();
        if (couponSeq != null) 
        {
            Coupon coupon = couponService.getCouponBySeq(couponSeq); // 쿠폰 정보 조회
            finalAmount = reservationService.calculateFinalAmount(reservation); // 할인 반영
        }

        model.addAttribute("reservation", reservation);
        model.addAttribute("finalAmount", finalAmount);

        return "reservation/paymentConfirm"; // 결제 확인 페이지로 이동
    }

}