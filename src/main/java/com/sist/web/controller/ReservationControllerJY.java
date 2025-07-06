package com.sist.web.controller;

import com.sist.web.dao.ReservationDaoJY;
import com.sist.web.model.ReservationJY;
import com.sist.web.model.RoomTypeJY;
import com.sist.web.service.MileageServiceJY;
import com.sist.web.service.ReservationServiceJY;
import com.sist.web.service.RoomServiceJY;
import com.sist.web.service.RoomTypeServiceJY;
import com.sist.web.service.UserService_mj;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
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
public class ReservationControllerJY
{
    @Autowired
    private ReservationServiceJY reservationService;
    
    @Autowired
    private UserService_mj userService;

    // 객실 타입 정보 조회용 서비스 (추가)
    @Autowired
    private RoomTypeServiceJY roomTypeService;

    @Autowired
    private MileageServiceJY mileageService;
    
    @Autowired
    private ReservationDaoJY reservationDao;
    
    @Autowired
    private RoomServiceJY roomService;
    @Value("#{env['auth.session.name']}")
    private String AUTH_SESSION_NAME;


    /**
     * 예약 1단계 페이지 요청
     * - 사용자가 객실 타입과 체크인/체크아웃 날짜를 선택하여 예약을 시작하는 화면
     * - 로그인 체크 후 예약 정보가 없으면 목록으로 리다이렉트
     */
    @GetMapping("/step1JY")
    public String reservationStep1(
            @RequestParam(value = "roomTypeSeq", required = true) Integer roomTypeSeq,
            @RequestParam("checkIn") String checkIn,
            @RequestParam("checkOut") String checkOut,
            @RequestParam(value = "numGuests", defaultValue = "1") int numGuests,
            Model model,
            HttpServletRequest request)
    {
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

    /**
     * 예약 정보 저장 (예약 확정)
     * - 사용자가 예약을 완료하고 저장 요청을 보낼 때 처리
     * - 로그인 확인 후 예약 저장
     * - 저장 성공 시 예약 상세 페이지로 리다이렉트
     */
    @PostMapping("/insert")
    public String insertReservation(@ModelAttribute ReservationJY reservation,
                                    HttpServletRequest request,
                                    RedirectAttributes redirectAttrs) {
        try {
            String guestId = (String) request.getSession().getAttribute("sessionUserId");
            if (guestId == null || guestId.isEmpty()) {
                redirectAttrs.addFlashAttribute("error", "로그인이 필요합니다.");
                return "redirect:/user/login";
            }

            reservation.setGuestId(guestId);

            // 객실 유형 정보 조회
            RoomTypeJY roomType = roomTypeService.getRoomType(reservation.getRoomTypeSeq());
            if (roomType == null) {
                redirectAttrs.addFlashAttribute("error", "존재하지 않는 객실 유형입니다.");
                return "redirect:/reservation/step1JY";
            }

            String hostId = roomType.getHostId();
            if (hostId == null || hostId.isEmpty()) {
                redirectAttrs.addFlashAttribute("error", "호스트 정보가 없습니다.");
                return "redirect:/reservation/step1JY";
            }
            reservation.setHostId(hostId);

            // 예약 저장 처리
            reservationService.insertReservation(reservation);

            redirectAttrs.addFlashAttribute("successMessage", "예약이 성공적으로 완료되었습니다.");
            redirectAttrs.addFlashAttribute("rsvSeq", reservation.getRsvSeq());

            return "redirect:/reservation/detail?seq=" + reservation.getRsvSeq();
        } catch (Exception e) {
            e.printStackTrace();
            redirectAttrs.addFlashAttribute("error", "예약 중 오류가 발생했습니다.");
            return "redirect:/reservation/step1JY";
        }
    }

    /**
     * 사용자의 예약 내역 리스트 조회
     * - 로그인한 사용자가 자신의 예약 목록을 조회하는 화면
     */
    @GetMapping("/list")
    public String reservationList(HttpServletRequest request, Model model)
    {
        String guestId = (String) request.getSession().getAttribute("sessionUserId");
        if (guestId == null || guestId.isEmpty())
        {
            return "redirect:/user/login";
        }

        List<ReservationJY> reservations = reservationService.getReservationsByGuestId(guestId);
        model.addAttribute("reservations", reservations);
        return "/reservation/list";
    }

    /**
     * 예약 상세 페이지 조회
     * - 예약 번호(seq)로 특정 예약 정보를 조회하여 상세 화면을 보여줌
     */
    @GetMapping("/detail")
    public String reservationDetail(@RequestParam("seq") int rsvSeq, Model model) {
        ReservationJY reservation = reservationService.getReservationBySeq(rsvSeq);
        model.addAttribute("reservation", reservation);
        return "/reservation/detail";
    }

    /**
     * 예약 취소 처리
     * - 사용자가 예약을 취소할 때 POST 요청으로 처리
     * - 취소 성공 시 예약 목록 페이지로 이동
     */
    @PostMapping("/cancel")
    public String cancelReservation(@ModelAttribute ReservationJY reservation, Model model)
    {
        try
        {
            reservationService.cancelReservation(reservation);
            return "redirect:/reservation/list";
        }
        catch (Exception e)
        {
            model.addAttribute("error", "예약 취소 중 오류가 발생했습니다.");
            return "/reservation/detail";
        }
    }
    
    /**
     * 객실 타입별 가격 계산 메서드
     * - ROOM_TYPE 테이블의 WEEKDAY_AMT, WEEKEND_AMT를 기준으로
     *   체크인~체크아웃 기간 동안 일별 요금을 계산해 합산
     */
    private int calculateTotalAmount(int roomTypeSeq, String checkInDateStr, String checkOutDateStr) {
        RoomTypeJY roomType = roomTypeService.getRoomType(roomTypeSeq);
        if (roomType == null) {
            throw new IllegalArgumentException("존재하지 않는 객실 유형입니다.");
        }

        int weekdayAmt = roomType.getWeekdayAmt();
        int weekendAmt = roomType.getWeekendAmt();

        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        LocalDate checkIn = LocalDate.parse(checkInDateStr.trim(), formatter);
        LocalDate checkOut = LocalDate.parse(checkOutDateStr.trim(), formatter);

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

    /**
     * 예약 상세 보기 (step1JY.jsp에서 상세 확인용)
     * - 예약 요청 데이터로 예약 상세 정보를 계산 및 준비하여 상세 페이지로 이동
     * - 마일리지 등 결제 정보를 포함해서 보여줌
     */
    @PostMapping("/detailJY")
    public String reservationDetailJY(@ModelAttribute ReservationJY reservation, HttpServletRequest request, Model model) {
        String guestId = (String) request.getSession().getAttribute("sessionUserId");
        if (guestId == null || guestId.isEmpty()) {
            return "redirect:/user/login";
        }

        reservation.setGuestId(guestId);

        // TODO: hostId 세팅 필요 - 예를 들어 방 정보를 통해 호스트 ID 조회 후 세팅
        Integer roomTypeSeq = reservation.getRoomTypeSeq();
        RoomTypeJY roomType = roomTypeService.getRoomType(roomTypeSeq);
        if(roomType != null) {
            reservation.setHostId(roomType.getHostId());  // hostId 필드 추가/확인 필요
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
    public String chargeMileageAndReserve(@ModelAttribute ReservationJY reservation, Model model, HttpSession session, RedirectAttributes redirectAttrs) {
        String userId = (String) session.getAttribute("sessionUserId");
        int userMileage = mileageService.getUserMileage(userId);

        if(userMileage < reservation.getFinalAmt()) 
        {
            redirectAttrs.addFlashAttribute("error", "마일리지가 부족합니다.");
            return "redirect:/payment/chargeMileagePage";  // 충전 페이지 URL
        }

        boolean success = mileageService.deductMileage(userId, reservation.getFinalAmt());
        if (!success) {
            redirectAttrs.addFlashAttribute("error", "결제 실패했습니다.");
            return "redirect:/reservation/detailJY";  // 상세 페이지로 돌아가기
        }

        reservation.setGuestId(userId);

        try {
            reservationService.insertReservation(reservation);
        } catch (Exception e) {
            redirectAttrs.addFlashAttribute("error", "예약 저장 중 오류가 발생했습니다.");
            return "redirect:/reservation/detailJY";
        }

        // 예약 성공 후 예약 상세 페이지로 리다이렉트
        return "redirect:/reservation/detail?seq=" + reservation.getRsvSeq();
    }

    @RequestMapping("/reservation/confirm")
    public String confirmReservation(@RequestParam("rsvSeq") int rsvSeq, Model model) 
    {
        ReservationJY reservation = reservationDao.selectReservationById(rsvSeq);
        model.addAttribute("reservation", reservation);
        return "/reservation/confirmPage"; // 예약 확인 페이지
    }

}