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
import org.springframework.transaction.annotation.Transactional;
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

    @Transactional
    public void insertReservation(Reservation reservation) throws Exception {
        System.out.println("=== insertReservation 시작 ===");
        System.out.println("전달받은 roomTypeSeq: " + reservation.getRoomTypeSeq());
        System.out.println("전달받은 hostId: " + reservation.getHostId());
        
        // 🔥 기본 상태값 설정 (Controller에서 설정하지 않은 경우)
        if (reservation.getRsvStat() == null || reservation.getRsvStat().trim().isEmpty()) {
            reservation.setRsvStat("CONFIRMED");
        }
        if (reservation.getRsvPaymentStat() == null || reservation.getRsvPaymentStat().trim().isEmpty()) {
            reservation.setRsvPaymentStat("PAID");
        }
        
        // hostId 검증 및 설정
        if (reservation.getHostId() == null || reservation.getHostId().trim().isEmpty()) {
            Integer roomTypeSeq = reservation.getRoomTypeSeq();
            if(roomTypeSeq == null) throw new IllegalArgumentException("roomTypeSeq가 null입니다.");

            RoomType roomType = roomTypeService.getRoomType(roomTypeSeq);
            String hostId = null;

            if(roomType != null && roomType.getHostId() != null && !roomType.getHostId().trim().isEmpty()) {
                hostId = roomType.getHostId().trim();
                System.out.println("RoomType에서 hostId 획득: '" + hostId + "'");
            } else {
                if(roomType == null) {
                    throw new IllegalArgumentException("roomType이 존재하지 않습니다. roomTypeSeq: " + roomTypeSeq);
                }

                int roomSeq = roomType.getRoomSeq();
                System.out.println("RoomType에서 hostId가 없어 ROOM 테이블에서 hostId 조회 시도, roomSeq: " + roomSeq);

                hostId = reservationDao.selectHostIdByRoomSeq(roomSeq);
                System.out.println("DAO에서 조회한 hostId: '" + hostId + "'");
            }
            
            if (hostId == null || hostId.trim().isEmpty())
                throw new IllegalArgumentException("해당 객실의 호스트 정보가 없습니다. roomTypeSeq: " + roomTypeSeq);

            reservation.setHostId(hostId);
            System.out.println("최종 설정된 hostId: '" + reservation.getHostId() + "'");
        }
        
        // RoomType 제목 설정
        if (reservation.getRoomTypeTitle() == null || reservation.getRoomTypeTitle().trim().isEmpty()) {
            RoomType roomType = roomTypeService.getRoomType(reservation.getRoomTypeSeq());
            if (roomType != null && roomType.getRoomTypeTitle() != null) {
                reservation.setRoomTypeTitle(roomType.getRoomTypeTitle());
            }
        }
        
        // 최종 검증
        if (reservation.getHostId() == null || reservation.getHostId().trim().isEmpty()) {
            throw new IllegalArgumentException("HOST_ID가 설정되지 않았습니다.");
        }
        if (reservation.getGuestId() == null || reservation.getGuestId().trim().isEmpty()) {
            throw new IllegalArgumentException("GUEST_ID가 설정되지 않았습니다.");
        }
        
        System.out.println("예약 상태: " + reservation.getRsvStat());
        System.out.println("결제 상태: " + reservation.getRsvPaymentStat());
        
        // DB 삽입
        reservationDao.insertReservation(reservation);
        System.out.println("=== insertReservation 완료 ===");
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

        // 🔥 시간 데이터 검증 및 로깅
        logger.debug("=== 예약 상세 페이지 시간 데이터 ===");
        logger.debug("체크인 시간 (전달받음): '{}'", reservation.getRsvCheckInTime());
        logger.debug("체크아웃 시간 (전달받음): '{}'", reservation.getRsvCheckOutTime());
        
        // 🔥 시간 데이터가 비어있다면 기본값 설정 (폼에서 전달되지 않은 경우에만)
        if (reservation.getRsvCheckInTime() == null || reservation.getRsvCheckInTime().trim().isEmpty()) {
            reservation.setRsvCheckInTime("1500"); // 기본 체크인 시간 15:00
            logger.debug("체크인 시간이 비어있어 기본값 설정: 1500");
        }
        
        if (reservation.getRsvCheckOutTime() == null || reservation.getRsvCheckOutTime().trim().isEmpty()) {
            reservation.setRsvCheckOutTime("1100"); // 기본 체크아웃 시간 11:00
            logger.debug("체크아웃 시간이 비어있어 기본값 설정: 1100");
        }

        RoomType roomType = roomTypeService.getRoomType(reservation.getRoomTypeSeq());
        if (roomType != null) {
            reservation.setHostId(roomType.getHostId());
            reservation.setRoomTypeTitle(roomType.getRoomTypeTitle());
        }

        int totalAmt = calculateTotalAmount(reservation.getRoomTypeSeq(),
                reservation.getRsvCheckInDt(),
                reservation.getRsvCheckOutDt());

        reservation.setTotalAmt(totalAmt);
        reservation.setFinalAmt(totalAmt);

        String userId = (String) session.getAttribute("SESSION_USER_ID");
        // 쿠폰 및 마일리지 정보 조회
        logger.debug("쿠폰 조회 시작");
        List<Coupon> couponList = couponService.getAvailableCouponsForUser(userId);
        logger.debug("쿠폰 조회 완료");
        
        model.addAttribute("reservation", reservation);
        
        if(couponList != null) {
            model.addAttribute("couponList", couponList);
        }

        long userMileage = getUserMileage(guestId);
        model.addAttribute("userMileage", userMileage);

        logger.debug("=== 최종 예약 정보 ===");
        logger.debug("체크인 시간 (최종): '{}'", reservation.getRsvCheckInTime());
        logger.debug("체크아웃 시간 (최종): '{}'", reservation.getRsvCheckOutTime());

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
            if (reservation != null) 
            {
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
        
        // 🔥 예약 상태와 결제 상태 명시적으로 설정
        reservation.setRsvStat("CONFIRMED");        // 또는 "예약완료"
        reservation.setRsvPaymentStat("PAID");      // 또는 "결제완료"
        
        // 🔥 시간 데이터 포맷팅 처리 (HH:MM -> HHMM)
        if (reservation.getRsvCheckInTime() != null) {
            String checkInTime = reservation.getRsvCheckInTime().trim();
            if (checkInTime.contains(":")) {
                checkInTime = checkInTime.replace(":", "");
                reservation.setRsvCheckInTime(checkInTime);
            }
            logger.info("체크인 시간 DB 저장용으로 변환: {}", checkInTime);
        }
        
        if (reservation.getRsvCheckOutTime() != null) {
            String checkOutTime = reservation.getRsvCheckOutTime().trim();
            if (checkOutTime.contains(":")) {
                checkOutTime = checkOutTime.replace(":", "");
                reservation.setRsvCheckOutTime(checkOutTime);
            }
            logger.info("체크아웃 시간 DB 저장용으로 변환: {}", checkOutTime);
        }
        
        // 쿠폰이 선택된 경우 할인 적용
        if (reservation.getCouponSeq() != null && reservation.getCouponSeq() > 0) {
            logger.info("쿠폰 적용: couponSeq = {}", reservation.getCouponSeq());
            int discountedAmount = reservationService.calculateFinalAmount(reservation);
            reservation.setFinalAmt(discountedAmount);
            logger.info("할인 적용 후 금액: originalAmt={}, discountedAmt={}", reservation.getTotalAmt(), discountedAmount);
        }

        long userMileage = getUserMileage(userId);
        if (userMileage < reservation.getFinalAmt()) {
            session.setAttribute("pendingReservation", reservation);
            return "redirect:/reservation/chargeMileage";
        }

        boolean deducted = deductMileage(userId, reservation.getFinalAmt());
        if (!deducted) {
            logger.error("마일리지 차감 실패: userId={}, amount={}", userId, reservation.getFinalAmt());
            redirectAttrs.addFlashAttribute("error", "마일리지 결제 실패");
            return "redirect:/reservation/detailJY?rsvSeq=" + reservation.getRsvSeq();
        }

        try {
            // 🔥 예약 등록일시 설정
            reservation.setRegDt(new Date());
            
            reservationService.insertReservation(reservation);
            logger.info("예약 저장 성공 - rsvSeq: {}, 상태: {}, 결제상태: {}, 체크인시간: {}, 체크아웃시간: {}", 
                       reservation.getRsvSeq(), reservation.getRsvStat(), reservation.getRsvPaymentStat(),
                       reservation.getRsvCheckInTime(), reservation.getRsvCheckOutTime());

            if (reservation.getCouponSeq() != null && reservation.getCouponSeq() > 0) {
                logger.info("쿠폰 사용 완료 처리 시작: userId={}, cpnSeq={}", userId, reservation.getCouponSeq());
                couponService.markCouponAsUsed(userId, reservation.getCouponSeq());
                logger.info("쿠폰 사용 완료 처리 종료");
            }

            if (reservation.getRsvSeq() == null || reservation.getRsvSeq() <= 0) {
                logger.error("예약 번호가 유효하지 않음: rsvSeq={}", reservation.getRsvSeq());
                redirectAttrs.addFlashAttribute("error", "예약 번호가 유효하지 않습니다.");
                return "redirect:/reservation/detailJY";
            }

        } catch (Exception e) {
            logger.error("예약 저장 중 오류 발생", e);
            redirectAttrs.addFlashAttribute("error", "예약 저장 중 오류 발생: " + e.getMessage());
            return "redirect:/reservation/detailJY";
        }

        session.removeAttribute("pendingReservation");

        int rsvSeq = reservation.getRsvSeq();
        logger.info("결제 완료 - 리다이렉트 to paymentConfirm with rsvSeq: {}", rsvSeq);
        return "redirect:/payment/paymentConfirm?rsvSeq=" + rsvSeq;
    }
    
    @PostMapping("/reservation/saveSession")
    @ResponseBody
    public String saveReservationToSession(@ModelAttribute Reservation reservation, 
                                           HttpSession session) {
        logger.info("세션에 예약 정보 저장: {}", reservation.getRsvSeq());
        session.setAttribute("pendingReservation", reservation);
        return "success";
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

 // 🔥 통합된 예약 취소 처리 - 하나의 메서드로 정리
 // 🔥 통합된 예약 취소 처리 - 하나의 메서드로 정리

    @PostMapping("/reservation/cancel")
    @Transactional
    public String cancelReservation(@RequestParam("rsvSeq") Integer rsvSeq,
                                   @RequestParam(value = "cancelReason", required = false) String cancelReason,
                                   RedirectAttributes redirectAttributes,
                                   HttpSession session) {
        try {
            logger.info("=== 예약 취소 처리 시작 ===");
            logger.info("rsvSeq: {}, cancelReason: {}", rsvSeq, cancelReason);
            
            // 로그인 사용자 확인
            String userId = (String) session.getAttribute("SESSION_USER_ID");
            if (userId == null || userId.isEmpty()) {
                redirectAttributes.addFlashAttribute("error", "로그인이 필요합니다.");
                return "redirect:/user/login";
            }
            
            // 예약 정보 조회
            Reservation existingReservation = reservationDao.selectReservationById(rsvSeq);
            if (existingReservation == null) {
                redirectAttributes.addFlashAttribute("error", "예약 정보를 찾을 수 없습니다.");
                return "redirect:/reservation/reservationHistoryJY";
            }
            
            // 예약자 본인 확인
            if (!userId.equals(existingReservation.getGuestId())) {
                redirectAttributes.addFlashAttribute("error", "본인의 예약만 취소할 수 있습니다.");
                return "redirect:/reservation/reservationHistoryJY";
            }
            
            // 이미 취소된 예약인지 확인
            if ("CANCELLED".equals(existingReservation.getRsvStat()) || "취소".equals(existingReservation.getRsvStat())) {
                redirectAttributes.addFlashAttribute("error", "이미 취소된 예약입니다.");
                return "redirect:/reservation/reservationHistoryJY";
            }
            
            // 환불 금액 계산 (전액 환불)
            int refundAmount = existingReservation.getFinalAmt();
            logger.info("환불 예정 금액: {}", refundAmount);
            
            // 🔥 cancelReason null 체크 및 기본값 설정 (더 확실하게)
            if (cancelReason == null || cancelReason.trim().isEmpty()) {
                cancelReason = "고객 요청";  // 기본 취소 사유
            }
            // 추가 안전장치
            cancelReason = cancelReason.trim();
            if (cancelReason.length() > 500) {  // DB 컬럼 길이 제한
                cancelReason = cancelReason.substring(0, 500);
            }
            logger.info("취소 사유: {}", cancelReason);
            
            // 1️⃣ DB에서 예약 상태 업데이트
            Reservation cancelReservation = new Reservation();
            cancelReservation.setRsvSeq(rsvSeq);
            cancelReservation.setRsvStat("취소");  // 🔥 기존 쿼리와 맞춤
            cancelReservation.setRsvPaymentStat("취소");  // 🔥 기존 쿼리와 맞춤
            cancelReservation.setCancelDt(new Date());
            cancelReservation.setCancelReason(cancelReason);
            cancelReservation.setRefundAmt(refundAmount);
            
            reservationDao.cancelReservation(cancelReservation);
            logger.info("예약 상태 업데이트 완료");
            
            // 2️⃣ 마일리지 환불 처리
            if (refundAmount > 0) 
            {
                logger.info("마일리지 환불 처리 시작: userId={}, refundAmount={}", userId, refundAmount);
                
                // 현재 마일리지 조회
                long currentMileage = getUserMileage(userId);
                
                // 마일리지 환불 (증가)
                int updatedRows = mileageHistoryDao.updateMileageAdd(userId, refundAmount);
                
                if (updatedRows > 0) {
                    // 마일리지 히스토리에 환불 내역 추가
                    MileageHistory history = new MileageHistory();
                    history.setUserId(userId);
                    history.setTrxType("환불");  // 🔥 중요: 환불 타입
                    history.setTrxAmt(refundAmount);  // 🔥 양수로 저장 (환불은 증가)
                    history.setBalanceAfterTrx(currentMileage + refundAmount);
                    history.setTrxDt(new Date());
                    
                    mileageHistoryDao.insertMileageHistory(history);
                    
                    logger.info("마일리지 환불 완료: newBalance={}", currentMileage + refundAmount);
                    
                    redirectAttributes.addFlashAttribute("message", 
                        "예약이 취소되고 " + refundAmount + "원이 마일리지로 환불되었습니다.");
                } else {
                    logger.error("마일리지 환불 실패: DB 업데이트 실패");
                    redirectAttributes.addFlashAttribute("error", "마일리지 환불 처리 실패");
                    return "redirect:/reservation/reservationHistoryJY";
                }
            } else {
                redirectAttributes.addFlashAttribute("message", "예약이 취소되었습니다.");
            }
            
            logger.info("=== 예약 취소 처리 완료 ===");
            
            // 마일리지 내역 페이지로 리다이렉트
            return "redirect:/reservation/mileageHistory";
            
        } catch (Exception e) {
            logger.error("예약 취소 중 오류 발생", e);
            redirectAttributes.addFlashAttribute("error", "예약 취소 중 오류가 발생했습니다: " + e.getMessage());
            return "redirect:/reservation/reservationHistoryJY";
        }
    }
    
    
 // 마일리지 환불 처리 메서드 추가
    private boolean refundMileage(String userId, int refundAmount) {
        try {
            // 현재 마일리지 조회
            long currentMileage = getUserMileage(userId);
            
            // 마일리지 환불 (증가)
            int updatedRows = mileageHistoryDao.updateMileageAdd(userId, refundAmount);
            
            if (updatedRows > 0) {
                // 마일리지 히스토리에 환불 내역 추가
                MileageHistory history = new MileageHistory();
                history.setUserId(userId);
                history.setTrxType("환불");  // 🔥 중요: 환불 타입으로 설정
                history.setTrxAmt(refundAmount);  // 🔥 양수로 저장 (환불은 증가)
                history.setBalanceAfterTrx(currentMileage + refundAmount);
                history.setTrxDt(new Date());
                
                mileageHistoryDao.insertMileageHistory(history);
                
                logger.info("마일리지 환불 완료: userId={}, refundAmount={}, newBalance={}", 
                           userId, refundAmount, currentMileage + refundAmount);
                return true;
            }
            
            logger.error("마일리지 환불 실패: DB 업데이트 실패");
            return false;
            
        } catch (Exception e) {
            logger.error("마일리지 환불 처리 중 오류 발생: userId={}, refundAmount={}", userId, refundAmount, e);
            return false;
        }
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
                                     HttpSession session,
                                     Model model) {
        logger.info("=== paymentConfirm 호출 ===");
        logger.info("파라미터 rsvSeq = {}", rsvSeq);
        logger.info("파라미터 error = {}", error);

        // 로그인 체크
        String userId = (String) session.getAttribute("SESSION_USER_ID");
        if (userId == null || userId.isEmpty()) {
            model.addAttribute("status", "ERROR");
            model.addAttribute("error", "로그인이 필요합니다.");
            return "/payment/paymentConfirm";
        }

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

        try {
            Reservation reservation = reservationDao.selectReservationById(rsvSeq);
            if (reservation == null) {
                logger.error("예약 번호 {}에 해당하는 예약을 찾지 못함", rsvSeq);
                model.addAttribute("status", "ERROR");
                model.addAttribute("error", "예약 정보를 찾을 수 없습니다.");
                return "/payment/paymentConfirm";
            }

            // 예약한 사용자와 현재 로그인한 사용자가 같은지 확인
            if (!userId.equals(reservation.getGuestId())) {
                logger.error("예약자와 현재 사용자 불일치: 예약자={}, 현재사용자={}", reservation.getGuestId(), userId);
                model.addAttribute("status", "ERROR");
                model.addAttribute("error", "접근 권한이 없습니다.");
                return "/payment/paymentConfirm";
            }

            // 🔥 시간 데이터 포맷팅 처리
            if (reservation.getRsvCheckInTime() != null) {
                String checkInTime = reservation.getRsvCheckInTime().trim();
                // HHMM 형식을 HH:MM으로 변환
                if (checkInTime.length() == 4 && !checkInTime.contains(":")) {
                    checkInTime = checkInTime.substring(0, 2) + ":" + checkInTime.substring(2, 4);
                    reservation.setRsvCheckInTime(checkInTime);
                }
                logger.info("체크인 시간 처리됨: {}", checkInTime);
            }
            
            if (reservation.getRsvCheckOutTime() != null) {
                String checkOutTime = reservation.getRsvCheckOutTime().trim();
                // HHMM 형식을 HH:MM으로 변환
                if (checkOutTime.length() == 4 && !checkOutTime.contains(":")) {
                    checkOutTime = checkOutTime.substring(0, 2) + ":" + checkOutTime.substring(2, 4);
                    reservation.setRsvCheckOutTime(checkOutTime);
                }
                logger.info("체크아웃 시간 처리됨: {}", checkOutTime);
            }

            // 🔥 RoomType 정보 가져와서 제목 설정
            if (reservation.getRoomTypeTitle() == null || reservation.getRoomTypeTitle().isEmpty()) {
                RoomType roomType = roomTypeService.getRoomType(reservation.getRoomTypeSeq());
                if (roomType != null && roomType.getRoomTypeTitle() != null) {
                    reservation.setRoomTypeTitle(roomType.getRoomTypeTitle());
                }
            }

            logger.info("예약 정보 조회 성공: rsvSeq={}, guestId={}, hostId={}, totalAmt={}, checkInTime={}, checkOutTime={}", 
                         reservation.getRsvSeq(), reservation.getGuestId(), reservation.getHostId(), 
                         reservation.getTotalAmt(), reservation.getRsvCheckInTime(), reservation.getRsvCheckOutTime());

            // 🔥 핵심: SUCCESS 상태로 설정
            model.addAttribute("status", "SUCCESS");
            model.addAttribute("reservation", reservation);
            
            // 남은 마일리지 계산
            long remainingMileage = getUserMileage(userId);
            model.addAttribute("remainingMileage", remainingMileage);
            
            return "/payment/paymentConfirm";
            
        } catch (Exception e) {
            logger.error("예약 정보 조회 중 오류 발생", e);
            model.addAttribute("status", "ERROR");
            model.addAttribute("error", "시스템 오류가 발생했습니다. 잠시 후 다시 시도해주세요.");
            return "/payment/paymentConfirm";
        }
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

        logger.debug("==========================================================");
        logger.debug("========= reservationController > pay > totalAmount: " + totalAmount);
        logger.debug("========= reservationController > pay > finalAmount: " + finalAmount);
        logger.debug("========= reservationController > pay > couponSeq: " + reservation.getCouponSeq());
        logger.debug("==========================================================");
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