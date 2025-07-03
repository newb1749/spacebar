package com.sist.web.controller;

import com.sist.web.dao.ReservationDaoJY;
import com.sist.web.model.ReservationJY;
import com.sist.web.model.RoomTypeJY;
import com.sist.web.service.MileageServiceJY;
import com.sist.web.service.ReservationServiceJY;
import com.sist.web.service.RoomServiceJY;
import com.sist.web.service.RoomTypeServiceJY;
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

import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;

@Controller
@RequestMapping("/reservation")
public class ReservationControllerJY {

    private static Logger logger = LoggerFactory.getLogger(ReservationControllerJY.class);
    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd");
    private static final DateTimeFormatter INPUT_FORMAT = DateTimeFormatter.ofPattern("yyyy-MM-dd");
    private static final DateTimeFormatter DB_FORMAT = DateTimeFormatter.ofPattern("yyyyMMdd");

    @Autowired
    private ReservationServiceJY reservationService;

    @Autowired
    private UserService_mj userService;

    @Autowired
    private RoomTypeServiceJY roomTypeService;

    @Autowired
    private MileageServiceJY mileageService;

    @Autowired
    private ReservationDaoJY reservationDao;

    @Autowired
    private RoomServiceJY roomService;

    @GetMapping("/step1JY")
    public String reservationStep1(@RequestParam("roomTypeSeq") Integer roomTypeSeq,
                                   @RequestParam("checkIn") String checkIn,
                                   @RequestParam("checkOut") String checkOut,
                                   @RequestParam(value = "numGuests", defaultValue = "1") int numGuests,
                                   Model model, HttpServletRequest request) {

        String sessionUserId = (String) request.getSession().getAttribute("sessionUserId");
        if (sessionUserId == null || sessionUserId.isEmpty()) {
            model.addAttribute("error", "로그인이 필요합니다.");
            return "redirect:/user/login";
        }

        if (roomTypeSeq == null || checkIn == null || checkOut == null || checkIn.isEmpty() || checkOut.isEmpty()) {
            model.addAttribute("error", "예약 정보가 누락되었습니다.");
            return "redirect:/room/list";
        }

        model.addAttribute("roomTypeSeq", roomTypeSeq);
        model.addAttribute("checkIn", checkIn);
        model.addAttribute("checkOut", checkOut);
        model.addAttribute("numGuests", numGuests);

        return "/reservation/step1JY";
    }

    private void insertReservation(ReservationJY reservation) throws Exception {
        if (reservation.getHostId() == null || reservation.getHostId().trim().isEmpty()) {
            Integer roomTypeSeq = reservation.getRoomTypeSeq();
            if (roomTypeSeq == null) {
                throw new IllegalArgumentException("roomTypeSeq가 null입니다.");
            }

            RoomTypeJY roomType = roomTypeService.getRoomType(roomTypeSeq);
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
    public String reservationList(HttpServletRequest request, Model model) {
        String guestId = (String) request.getSession().getAttribute("sessionUserId");
        if (guestId == null || guestId.isEmpty()) {
            return "redirect:/user/login";
        }

        List<ReservationJY> reservations = reservationService.getReservationsByGuestId(guestId);
        model.addAttribute("reservations", reservations);
        return "/reservation/list";
    }

    @GetMapping("/detailJY")
    public String reservationDetail(@RequestParam(value = "rsvSeq", required = false) Integer rsvSeq, Model model) {
        if (rsvSeq == null || rsvSeq <= 0) {
            return "redirect:/reservation/confirm";
        }

        ReservationJY reservation = reservationService.getReservationBySeq(rsvSeq);
        model.addAttribute("reservation", reservation);
        return "/reservation/detailJY";
    }

    @PostMapping("/cancel")
    public String cancelReservation(@ModelAttribute ReservationJY reservation, RedirectAttributes redirectAttrs) {
        try {
            reservationService.cancelReservation(reservation);
        } catch (Exception e) {
            redirectAttrs.addFlashAttribute("error", "예약 취소 중 오류가 발생했습니다: " + e.getMessage());
            return "redirect:/reservation/detailJY?rsvSeq=" + reservation.getRsvSeq();
        }
        return "redirect:/reservation/list";
    }

    private int calculateTotalAmount(int roomTypeSeq, String checkInDateStr, String checkOutDateStr) {
        RoomTypeJY roomType = roomTypeService.getRoomType(roomTypeSeq);
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
    public String reservationDetailJY(@ModelAttribute ReservationJY reservation,
                                      HttpServletRequest request,
                                      Model model) {

        String guestId = (String) request.getSession().getAttribute("sessionUserId");
        if (guestId == null || guestId.isEmpty()) {
            return "redirect:/user/login";
        }

        reservation.setGuestId(guestId);

        RoomTypeJY roomType = roomTypeService.getRoomType(reservation.getRoomTypeSeq());
        if (roomType != null) {
            reservation.setHostId(roomType.getHostId());
        }

        int totalAmt = calculateTotalAmount(reservation.getRoomTypeSeq(),
                reservation.getRsvCheckInDt(),
                reservation.getRsvCheckOutDt());

        reservation.setTotalAmt(totalAmt);
        reservation.setFinalAmt(totalAmt);

        int userMileage = userService.getCurrentMileage(guestId);
        model.addAttribute("userMileage", userMileage);
        model.addAttribute("reservation", reservation);

        return "/reservation/detailJY";
    }

    @PostMapping("/payment/chargeMileage")
    public String chargeMileageAndReserve(@ModelAttribute ReservationJY reservation,
                                          HttpServletRequest request,
                                          HttpSession session,
                                          RedirectAttributes redirectAttrs) {

        String userId = (String) session.getAttribute("sessionUserId");
        if (userId == null || userId.isEmpty()) {
            redirectAttrs.addFlashAttribute("error", "로그인이 필요합니다.");
            return "redirect:/user/login";
        }

        RoomTypeJY roomType = roomTypeService.getRoomType(reservation.getRoomTypeSeq());
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

        int userMileage = mileageService.getUserMileage(userId);
        if (userMileage < reservation.getFinalAmt()) {
            int shortage = reservation.getFinalAmt() - userMileage;
            redirectAttrs.addFlashAttribute("error", "마일리지가 부족합니다.");
            redirectAttrs.addFlashAttribute("userMileage", userMileage);
            redirectAttrs.addFlashAttribute("finalAmt", reservation.getFinalAmt());
            redirectAttrs.addFlashAttribute("shortage", shortage);
            return "redirect:/reservation/payment/chargeMileage";
        }

        boolean success = mileageService.deductMileage(userId, reservation.getFinalAmt());
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

        return "redirect:/reservation/confirm?rsvSeq=" + reservation.getRsvSeq();
    }

    private String convertTimeToHHmm(String timeStr) {
        if (timeStr == null || timeStr.isEmpty()) return null;
        return timeStr.replace(":", "");
    }

    @GetMapping("/confirm")
    public String confirmReservation(@RequestParam(value = "rsvSeq", required = false) Integer rsvSeq,
                                     @RequestParam(value = "error", required = false) String error,
                                     Model model) {

        if (error != null && !error.trim().isEmpty()) {
            model.addAttribute("status", "ERROR");
            model.addAttribute("error", error);
            return "/payment/paymentConfirm";
        }

        if (rsvSeq == null || rsvSeq <= 0) {
            model.addAttribute("status", "ERROR");
            model.addAttribute("error", "잘못된 예약 번호입니다.");
            return "/payment/paymentConfirm";
        }

        ReservationJY reservation = reservationDao.selectReservationById(rsvSeq);
        if (reservation == null) {
            model.addAttribute("status", "ERROR");
            model.addAttribute("error", "예약 정보를 찾을 수 없습니다.");
            return "/payment/paymentConfirm";
        }

        model.addAttribute("reservation", reservation);
        model.addAttribute("status", "SUCCESS");

        int remainingMileage = userService.getCurrentMileage(reservation.getGuestId());
        model.addAttribute("remainingMileage", remainingMileage);

        return "/payment/paymentConfirm";
    }

    @GetMapping("/payment/chargeMileage")
    public String showChargeMileagePage(@RequestParam(value = "finalAmt", required = false) Integer finalAmt,
                                        @RequestParam(value = "userMileage", required = false) Integer userMileage,
                                        @RequestParam(value = "shortage", required = false) Integer shortage,
                                        HttpSession session,
                                        Model model) {
        String userId = (String) session.getAttribute("sessionUserId");
        if (userId != null) {
            if (userMileage == null) {
                userMileage = userService.getCurrentMileage(userId);
            }
            if (finalAmt != null && shortage == null) {
                shortage = Math.max(0, finalAmt - userMileage);
            }
            model.addAttribute("finalAmt", finalAmt);
            model.addAttribute("userMileage", userMileage);
            model.addAttribute("shortage", shortage);
        }
        return "/payment/chargeMileage";
    }

}
