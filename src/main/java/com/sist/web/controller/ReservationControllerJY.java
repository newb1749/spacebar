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

    /**
     * 예약 비즈니스 로직을 처리하는 서비스 계층
     */
    @Autowired
    private ReservationServiceJY reservationService;

    /**
     * 사용자 정보 조회 및 업데이트 관련 서비스
     */
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
    private ReservationDaoJY reservationDao;

    /**
     * 개별 객실(Room) 정보 조회 등 담당
     */
    @Autowired
    private RoomServiceJY roomService;

    /**
     * 예약 1단계 페이지로 이동하기 위한 컨트롤러 메서드
     * 로그인 여부 확인
     * 예약 정보 유효성 확인
     * 파라미터를 모델에 담아 JSP로 전달
     * 예약 1단계 JSP 페이지 반환
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
     * 숙소 예약 정보를 데이터베이스에 저장하는 기능을 수행
     * ReservationJY 객체를 기반으로 예약 정보를 저장하기 전에, hostId가 비어있을 경우 자동으로 채워주고, 그 다음 DB에 insert함
     * hostId 유무 확인
     * roomTypeSeq로 RoomType 정보 조회
     * RoomType에서 hostId 조회 시도
     * hostId가 최종적으로 없으면 예외
     * hostId가 설정된 상태로 insert 실행
     * ReservationJY: 예약 정보를 담고 있는 모델 클래스
     * RoomTypeJY: 숙소 타입 정보 (호스트 포함)
     * reservationDao: DB 접근 객체
     * roomTypeService: 숙소 타입을 조회하는 서비스
     * ReservationJY 객체의 hostId가 없을 경우 자동으로 찾아서 보완한 뒤, 정상적인 예약 정보만 DB에 저장하도록 검증 + 삽입하는 핵심 로직
     * @param reservation
     * @throws Exception
     */
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

	/**
     * URL 경로: /list (GET 방식)
     * 기능: 로그인한 사용자의 예약 목록을 가져와서 JSP에 출력
     * 반환 뷰: /reservation/list.jsp
     * 조건: 로그인하지 않았다면 로그인 페이지로 리디렉션
     * 클라이언트가 /reservation/list 요청을 보냈을 때 호출되는 메서드
     * 로그인 여부 확인
     * 사용자 예약 목록 조회
     * 예약 리스트를 모델에 추가
     * 예약 목록 JSP로 이동
	 * @param request 현재 HTTP 요청 객체 (세션에서 로그인 ID를 얻기 위해 사용)
	 * @param model   JSP로 데이터 전달을 위한 모델 객체
	 * @return 예약 목록 JSP 경로 또는 로그인 페이지 리디렉션
	 */
    @GetMapping("/list")
    public String reservationList(HttpServletRequest request, Model model) 
    {
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

    /**
     * 예약 취소 요청을 처리하는 컨트롤러 메서드
     * 클라이언트가 "예약 취소" 버튼을 눌렀을 때 동작하며, 예약을 취소 처리한 뒤 예약 목록 페이지로 리다이렉트
     * URL 경로: /reservation/cancel (POST 방식)
     * 역할: ReservationJY 객체를 통해 예약 취소 처리 후 → 성공 시 예약 목록 페이지, 실패 시 상세 페이지로 리다이렉트
     * 주요 처리 로직: 서비스 계층의 cancelReservation() 메서드를 호출
     * 			   예외 발생 시 오류 메시지를 전달하고 상세 페이지로 리다이렉션
     * 예약 취소 서비스 호출
     * 예외 발생 시 에러 메시지와 함께 상세 페이지로 이동
     * 성공 시 예약 목록 페이지로 이동
     * @param reservation    폼에서 전달된 예약 정보 (rsvSeq, cancelReason 등)
	 * @param redirectAttrs  리다이렉트 시 플래시 메시지 전달을 위한 객체
	 * @return 예약 목록 또는 예약 상세 페이지로의 리다이렉션 경로
     */
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

    /**
     * 예약 1단계(step1JY.jsp) 이후에 실행되는 컨트롤러
     * 사용자가 입력한 정보를 바탕으로 **예약 상세정보 확인 페이지(detailJY.jsp)**로 이동시키는 로직
     * URL 경로: /reservation/detailJY (POST 방식)
     * 역할: 사용자의 예약 요청 정보를 바탕으로, 객실 가격 및 마일리지 정보를 포함한 예약 상세 페이지로 이동
     * 입력: ReservationJY (모델 객체), 세션의 로그인 정보
     * 출력: detailJY.jsp 렌더링
     * 로그인 체크
     * 객실 정보 조회 및 호스트 ID 설정
     * 총 결제금액 계산
     * 사용자의 현재 마일리지 조회
     * reservation 객체와 userMileage를 detailJY.jsp로 데이터 전달
     * @param reservation
     * @param request
     * @param model
     * @return
     */
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

    /**
     * 마일리지로 숙소 예약 결제를 진행하는 핵심 컨트롤러
     * 클라이언트로부터 예약 정보 및 체크인/체크아웃 일시를 입력받고,
     * 마일리지로 결제 가능한지 확인한 뒤,
     * 마일리지를 차감하고
     * 예약을 DB에 저장한 후
     * 예약 완료 페이지(/reservation/confirm)로 이동하는 전체 결제 흐름을 처리
     * 입력: ReservationJY 예약 객체 (@ModelAttribute)
     *      HttpServletRequest 및 HttpSession → 로그인 ID 및 request param
     *      RedirectAttributes → 오류 시 리디렉션과 함께 메시지 전달
     * 로그인 여부 확인
     * 객실 정보 유효성 검증
     * 날짜 및 시간 파싱
     * 마일리지 차감 여부 확인
     * 마일리지 차감 실행
     * 예약 저장
     * 최종 성공 → 예약 확인 페이지로 이동
     * @param reservation     예약 정보 객체
	 * @param request         HttpServletRequest (체크인/체크아웃 날짜 및 시간 파싱용)
	 * @param session         사용자 세션 정보
	 * @param redirectAttrs   리디렉션 시 에러 메시지 전달용
	 * @return 예약 완료 페이지로 리디렉션 또는 오류 발생 시 해당 페이지로 리디렉션
     */
    @PostMapping("/payment/chargeMileage")
    public String chargeMileageAndReserve(@ModelAttribute ReservationJY reservation,
                                          HttpServletRequest request,
                                          HttpSession session,
                                          RedirectAttributes redirectAttrs) 
    {
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

    // StringUtil로 빼는게 어떨까
    /**
     * 시간 문자열을 HHmm 형식으로 변환하기 위한 간단한 유틸리티 메서드
     * HH:mm 또는 H:mm 형식의 시간 문자열에서 콜론(:)을 제거하여 HHmm 포맷으로 바꾸는 것
     * @param timeStr
     * @return
     */
    private String convertTimeToHHmm(String timeStr) 
    {
        if (timeStr == null || timeStr.isEmpty()) return null;
        return timeStr.replace(":", "");
    }

    /**
     * 예약 완료 후 사용자에게 결제 결과를 보여주는 확인 페이지(/payment/paymentConfirm.jsp)로 이동하는 컨트롤러
     * 예약 완료 후 결제 확인 페이지로 이동
	 * 예약 번호와 상태에 따라 성공 또는 오류 메시지를 전달
     * 경로: /reservation/confirm?rsvSeq=1234
     * 목적: 예약 완료 정보를 보여주는 결제 확인 페이지 출력
     * 조건: 예약 성공 또는 실패 여부에 따라 처리 분기
     * 뷰:  항상 /payment/paymentConfirm.jsp 사용 (성공/실패 공통)
     * 파라미터)
     * rsvSeq: 예약 고유번호 (reservation sequence)
     * error: 실패 시 전달되는 에러 메시지 (optional)
     * model: JSP에 데이터 전달을 위한 Spring 객체
	 * @param rsvSeq 예약 번호 (필수 아님)
	 * @param error  외부에서 전달된 에러 메시지 (선택)
	 * @param model  JSP로 전달할 데이터
	 * @return 결제 확인 JSP 뷰
     */
    @GetMapping("/confirm")
    public String confirmReservation(@RequestParam(value = "rsvSeq", required = false) Integer rsvSeq,
                                     @RequestParam(value = "error", required = false) String error,
                                     Model model) 
    {
        if (error != null && !error.trim().isEmpty()) 
        {
            model.addAttribute("status", "ERROR");
            model.addAttribute("error", error);
            return "/payment/paymentConfirm";  // (1) 에러 시도 동일 JSP 사용
        }

        if (rsvSeq == null || rsvSeq <= 0) {
            model.addAttribute("status", "ERROR");
            model.addAttribute("error", "잘못된 예약 번호입니다.");
            return "/payment/paymentConfirm";  // (2) 잘못된 rsvSeq 시에도 동일 JSP
        }

        ReservationJY reservation = reservationDao.selectReservationById(rsvSeq);
        if (reservation == null) {
            model.addAttribute("status", "ERROR");
            model.addAttribute("error", "예약 정보를 찾을 수 없습니다.");
            return "/payment/paymentConfirm";  // (3) DB에 없는 경우에도
        }

        // (4) 정상 예약인 경우
        model.addAttribute("reservation", reservation);
        model.addAttribute("status", "SUCCESS");

        int remainingMileage = userService.getCurrentMileage(reservation.getGuestId());
        model.addAttribute("remainingMileage", remainingMileage);

        return "/payment/paymentConfirm";  // 최종 결제 완료 시 확인 페이지로 이동
    }

    /**
     * 마일리지 충전 페이지를 보여주는 컨트롤러 메서드
     * 마일리지 부족 상황에서 사용자에게 마일리지 잔액, 결제 금액, 부족한 마일리지 등을 알려주고 충전 페이지를 렌더링함
     * URL 경로: /payment/chargeMileage (GET)
     * 역할: 로그인된 사용자의 마일리지 잔액 조회
     * 최종 결제 금액과 부족 금액 계산
     * JSP에 finalAmt, userMileage, shortage 값을 전달
     * 뷰: /payment/chargeMileage.jsp
     * finalAmt: 결제해야 할 총 금액 (optional)
     * userMileage: 현재 사용자 마일리지 (optional)
     * shortage: 부족한 마일리지 양 (optional)
     * session: 로그인 정보 확인용
     * model: JSP로 데이터 전달
     * 로그인 사용자 확인 및 마일리지 조회
     * 부족 마일리지 계산
     * 모델에 데이터 세팅
     * 마일리지 충전 페이지 반환
     * @param finalAmt     결제에 필요한 총 금액 (optional)
	 * @param userMileage  사용자의 현재 마일리지 (optional)
	 * @param shortage     부족한 마일리지 양 (optional)
	 * @param session      HTTP 세션 (로그인 정보 확인용)
	 * @param model        JSP로 전달할 데이터 모델
	 * @return 마일리지 충전 JSP 경로
     */
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