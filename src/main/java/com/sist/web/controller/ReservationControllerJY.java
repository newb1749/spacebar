package com.sist.web.controller;


import com.sist.web.dao.MileageHistoryDao;
import com.sist.web.dao.ReservationDao;
import com.sist.web.model.MileageHistory;
import com.sist.web.model.Reservation;
import com.sist.web.model.RoomType;

import com.sist.web.dao.MileageHistoryDao;
import com.sist.web.dao.ReservationDao;
import com.sist.web.model.MileageHistory;
import com.sist.web.model.Reservation;
import com.sist.web.model.RoomType;
import com.sist.web.service.MileageServiceJY;
import com.sist.web.service.ReservationServiceJY;
import com.sist.web.service.RoomService;
import com.sist.web.service.RoomTypeService;
import com.sist.web.service.UserService_mj;
import com.sist.web.service.MileageHistoryService;

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
import java.util.Date;
import java.util.List;

@Controller
@RequestMapping("/reservation")
public class ReservationControllerJY {

    private static Logger logger = LoggerFactory.getLogger(ReservationControllerJY.class);
    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd");
    private static final DateTimeFormatter INPUT_FORMAT = DateTimeFormatter.ofPattern("yyyy-MM-dd");
    private static final DateTimeFormatter DB_FORMAT = DateTimeFormatter.ofPattern("yyyyMMdd");

    @Autowired
    private UserService_mj userService;  // 회원 서비스는 유지 (필요시 사용)

    @Autowired
    private UserService_mj userService;

    /**
     * 객실 타입(RoomType) 정보를 조회하는 서비스
     */
    @Autowired
    private RoomTypeServiceJY roomTypeService;

    /**
     * 마일리지 충전/차감/복구 등 마일리지 관련 기능 담당 서비스
     */
    @Autowired
    private MileageServiceJY mileageService;

    /**
     * 예약 관련 DB 직접 접근 (CRUD 등)
     */
    @Autowired
    private ReservationDao reservationDao;

    @Autowired
    private RoomServiceJY roomService;

    /**
     * 예약 1단계 페이지로 이동하기 위한 컨트롤러 메서드
     * @param roomTypeSeq 예약하려는 객실 타입의 고유 번호 (필수)
	 * @param checkIn 체크인 날짜 (yyyy-MM-dd 형식, 필수)
	 * @param checkOut 체크아웃 날짜 (yyyy-MM-dd 형식, 필수)
	 * @param numGuests 투숙 인원 수 (기본값: 1)
	 * @param model JSP에 데이터 전달을 위한 모델 객체
	 * @param request 로그인 여부 확인을 위한 HTTP 요청 객체
	 * @return 예약 1단계 페이지 뷰 이름 또는 리디렉션 경로
     */
    @GetMapping("/step1JY")
    public String reservationStep1(@RequestParam("roomTypeSeq") Integer roomTypeSeq,
                                   @RequestParam("checkIn") String checkIn,
                                   @RequestParam("checkOut") String checkOut,
                                   @RequestParam(value = "numGuests", defaultValue = "1") int numGuests,
                                   Model model, HttpServletRequest request) 
    {
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
        return "/reservation/step1JY";
    }

    private void insertReservation(Reservation reservation) throws Exception {
        if (reservation.getHostId() == null || reservation.getHostId().trim().isEmpty()) {
            Integer roomTypeSeq = reservation.getRoomTypeSeq();
            if (roomTypeSeq == null) 
            {
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
        }
        if (reservation.getHostId() == null || reservation.getHostId().trim().isEmpty()) {
            throw new IllegalArgumentException("HOST_ID가 여전히 null입니다.");
        }
        reservationDao.insertReservation(reservation);
    }

    @GetMapping("/list")
    public String reservationList(HttpServletRequest request, Model model) 
    {
        String guestId = (String) request.getSession().getAttribute("SESSION_USER_ID");
        if (guestId == null || guestId.isEmpty()) {
            return "redirect:/user/login";
        }

        List<Reservation> reservations = reservationService.getReservationsByGuestId(guestId);
        model.addAttribute("reservations", reservations);
        return "/reservation/reservationHistoryJY";
    }

    @GetMapping("/detailJY")
    public String reservationDetail(@RequestParam(value = "rsvSeq", required = false) Integer rsvSeq,
                                    HttpSession session,
                                    Model model) {
        Reservation reservation = null;

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
            return "redirect:/reservation/paymentConfirm";
        }

        model.addAttribute("reservation", reservation);

        String guestId = (String) session.getAttribute("SESSION_USER_ID");
        if (guestId != null) {
            long mileage = getUserMileage(guestId);
            model.addAttribute("userMileage", mileage);
        }

        return "/reservation/detailJY";
    }

    /**
     * 예약 취소 요청을 처리하는 컨트롤러 메서드
     * @param reservation    폼에서 전달된 예약 정보 (rsvSeq, cancelReason 등)
	 * @param redirectAttrs  리다이렉트 시 플래시 메시지 전달을 위한 객체
	 * @return 예약 목록 또는 예약 상세 페이지로의 리다이렉션 경로
     */
    @PostMapping("/cancel")
    public String cancelReservation(@ModelAttribute Reservation reservation, RedirectAttributes redirectAttrs) {
        try {
            reservationService.cancelReservation(reservation);
        } catch (Exception e) {
            redirectAttrs.addFlashAttribute("error", "예약 저장 실패: " + e.getMessage());
            return "redirect:/reservation/detailJY?rsvSeq=" + reservation.getRsvSeq();
        }

        session.removeAttribute("pendingReservation");
        return "redirect:/reservation/confirm?rsvSeq=" + reservation.getRsvSeq();
    }

    /**
     * 숙박 기간 동안의 총 결제 금액을 계산하는 기능을 하는 calculateTotalAmount() 메서드
     * 사용자가 선택한 check-in ~ check-out 날짜와 객실 타입 정보를 바탕으로 요일별 요금을 계산
     * @param roomTypeSeq     객실 유형 번호
	 * @param checkInDateStr  체크인 날짜 (yyyy-MM-dd)
	 * @param checkOutDateStr 체크아웃 날짜 (yyyy-MM-dd)
	 * @return 계산된 총 요금 (int, 단위: 원)
	 * @throws IllegalArgumentException 객실 유형이 존재하지 않거나 날짜 형식이 잘못된 경우
     */
    private int calculateTotalAmount(int roomTypeSeq, String checkInDateStr, String checkOutDateStr) {
        RoomType roomType = roomTypeService.getRoomType(roomTypeSeq);
        if (roomType == null) {
            throw new IllegalArgumentException("존재하지 않는 객실 유형입니다.");
        }
        int weekdayAmt = roomType.getWeekdayAmt();
        int weekendAmt = roomType.getWeekendAmt();

        LocalDate checkIn = LocalDate.parse(checkInDateStr.trim(), DATE_FORMATTER);
        LocalDate checkOut = LocalDate.parse(checkOutDateStr.trim(), DATE_FORMATTER);

        int totalAmount = 0;
        for (LocalDate date = checkIn; date.isBefore(checkOut); date = date.plusDays(1)) {
            DayOfWeek day = date.getDayOfWeek();
            if (day == DayOfWeek.FRIDAY || day == DayOfWeek.SATURDAY || day == DayOfWeek.SUNDAY) {
                totalAmount += weekendAmt;
            } else {
                totalAmount += weekdayAmt;
            }
        }
        return totalAmount;
    }

    @PostMapping("/detailJY")
    public String reservationDetailJY(@ModelAttribute Reservation reservation,
                                      HttpServletRequest request,
                                      Model model) {

        String guestId = (String) request.getSession().getAttribute("SESSION_USER_ID");
        if (guestId == null || guestId.isEmpty()) {
            return "redirect:/user/login";
        }

        reservation.setGuestId(guestId);

        RoomType roomType = roomTypeService.getRoomType(reservation.getRoomTypeSeq());
        if (roomType != null) {
            reservation.setHostId(roomType.getHostId());
        }

        int totalAmt = calculateTotalAmount(reservation.getRoomTypeSeq(),
                reservation.getRsvCheckInDt(),
                reservation.getRsvCheckOutDt());

        reservation.setTotalAmt(totalAmt);
        reservation.setFinalAmt(totalAmt);

        long userMileage = getUserMileage(guestId);
        model.addAttribute("userMileage", userMileage);
        model.addAttribute("reservation", reservation);

        return "/reservation/detailJY";
    }

    private String convertTimeToHHmm(String timeStr) {
        if (timeStr == null || timeStr.isEmpty()) return null;
        return timeStr.replace(":", "");
    }

    @PostMapping("/payment/chargeMileage")
    public String chargeMileageAndReserve(@ModelAttribute Reservation reservation,
                                          HttpServletRequest request,
                                          HttpSession session,
                                          RedirectAttributes redirectAttrs) {
        String userId = (String) session.getAttribute("SESSION_USER_ID");
        if (userId == null || userId.isEmpty()) {
            redirectAttrs.addFlashAttribute("error", "로그인이 필요합니다.");
            return "redirect:/user/login";
        }

        RoomType roomType = roomTypeService.getRoomType(reservation.getRoomTypeSeq());
        if (roomType == null) {
            redirectAttrs.addFlashAttribute("error", "유효하지 않은 객실 정보입니다. 예약을 다시 시도해주세요.");
            return "redirect:/reservation/detailJY?rsvSeq=" + reservation.getRsvSeq();
        }

        try {
            String checkInStr = request.getParameter("rsvCheckInDt");
            String checkOutStr = request.getParameter("rsvCheckOutDt");
            String checkInTime = request.getParameter("rsvCheckInTime");
            String checkOutTime = request.getParameter("rsvCheckOutTime");

            LocalDate checkInDate = LocalDate.parse(checkInStr, INPUT_FORMAT);
            LocalDate checkOutDate = LocalDate.parse(checkOutStr, INPUT_FORMAT);

            reservation.setRsvCheckInDt(checkInDate.format(DB_FORMAT));
            reservation.setRsvCheckOutDt(checkOutDate.format(DB_FORMAT));
            reservation.setRsvCheckInTime(convertTimeToHHmm(checkInTime));
            reservation.setRsvCheckOutTime(convertTimeToHHmm(checkOutTime));

        } catch (Exception e) {
            redirectAttrs.addFlashAttribute("error", "체크인/체크아웃 날짜 또는 시간 파싱 오류: " + e.getMessage());
            return "redirect:/reservation/detailJY?rsvSeq=" + reservation.getRsvSeq();
        }

        reservation.setGuestId(userId);

        long userMileage = getUserMileage(userId);
        if (userMileage < reservation.getFinalAmt()) {
            session.setAttribute("pendingReservation", reservation);
            return "redirect:/reservation/payment/chargeMileage";
        }

        boolean success = deductMileage(userId, reservation.getFinalAmt());
        if (!success) {
            redirectAttrs.addFlashAttribute("error", "마일리지 결제 실패");
            return "redirect:/reservation/detailJY?rsvSeq=" + reservation.getRsvSeq();
        }

        try {
            insertReservation(reservation);
        } catch (Exception e) {
            redirectAttrs.addFlashAttribute("error", "예약 저장 중 오류 발생: " + e.getMessage());
            return "redirect:/reservation/detailJY?rsvSeq=" + reservation.getRsvSeq();
        }

        session.removeAttribute("pendingReservation");
        return "redirect:/reservation/confirm?rsvSeq=" + reservation.getRsvSeq();
    }

    @GetMapping("/confirm")
    public String confirmReservation(@RequestParam(value = "rsvSeq", required = false) Integer rsvSeq,
                                     @RequestParam(value = "error", required = false) String error,
                                     Model model) {
        if (error != null) {
            model.addAttribute("status", "ERROR");
            model.addAttribute("error", error);
            return "/payment/paymentConfirm";
        }

        if (rsvSeq == null || rsvSeq <= 0) {
            model.addAttribute("status", "ERROR");
            model.addAttribute("error", "잘못된 예약 번호입니다.");
            return "/payment/paymentConfirm";
        }

        Reservation reservation = reservationDao.selectReservationById(rsvSeq);
        if (reservation == null) {
            model.addAttribute("status", "ERROR");
            model.addAttribute("error", "예약 정보를 찾을 수 없습니다.");
            return "/payment/paymentConfirm";
        }

        model.addAttribute("reservation", reservation);
        model.addAttribute("status", "SUCCESS");

        long remainingMileage = getUserMileage(reservation.getGuestId());
        model.addAttribute("remainingMileage", remainingMileage);

        return "/payment/paymentConfirm";
    }

    /**
     * 로그인한 사용자의 예약 내역 조회 페이지
     * @param model 뷰에 데이터 전달용
     * @param session 세션에서 로그인 사용자 정보 조회
     * @return 내 예약 내역 jsp 경로
     */
    @GetMapping("/reservationHistoryJY")
    public String reservationHistoryJY(Model model, HttpSession session) 
    {
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
                // 로그 남기거나 예외 처리
            }
        }

        model.addAttribute("reservations", reservations);
        return "/reservation/reservationHistoryJY";
    }
}
