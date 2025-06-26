package com.sist.web.controller;

import com.sist.web.model.ReservationJY;
import com.sist.web.service.ReservationServiceJY;
import com.sist.web.util.CookieUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

@Controller
@RequestMapping("/reservation")
public class ReservationControllerJY
{

    @Autowired
    private ReservationServiceJY reservationService;

    /**
     * 예약 1단계 화면 진입
     */
    @GetMapping("/step1JY")
    public String reservationStep1(
            @RequestParam(value = "roomTypeSeq", required = true) Integer roomTypeSeq,
            @RequestParam("checkIn") String checkIn,
            @RequestParam("checkOut") String checkOut,
            @RequestParam(value = "numGuests", defaultValue = "1") int numGuests,
            Model model) 
    {
        
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
     * 예약 등록 처리
     */
    @PostMapping("/insert")
    public String insertReservation(@ModelAttribute ReservationJY reservation,
                                    HttpServletRequest request,
                                    Model model) 
    {
        try 
        {
            String guestId = CookieUtil.getHexValue(request, "sb.uid");
            if (guestId == null || guestId.isEmpty()) 
            {
                model.addAttribute("error", "로그인이 필요합니다.");
                return "redirect:/user/login";
            }

            reservation.setGuestId(guestId);
            reservationService.insertReservation(reservation);

            return "redirect:/reservation/list";
        } 
        catch (Exception e)
        {
            model.addAttribute("error", "예약 중 오류가 발생했습니다.");
            return "/reservation/step1";
        }
    }

    /**
     * 나의 예약 목록 보기
     */
    @GetMapping("/list")
    public String reservationList(HttpServletRequest request, Model model)
    {
        String guestId = CookieUtil.getHexValue(request, "sb.uid");
        if (guestId == null || guestId.isEmpty()) 
        {
            return "redirect:/user/login";
        }

        List<ReservationJY> reservations = reservationService.getReservationsByGuestId(guestId);
        model.addAttribute("reservations", reservations);
        return "/reservation/list";
    }

    /**
     * 예약 상세 보기
     */
    @GetMapping("/detail")
    public String reservationDetail(@RequestParam("rsvSeq") int rsvSeq, Model model) 
    {
        ReservationJY reservation = reservationService.getReservationBySeq(rsvSeq);
        model.addAttribute("reservation", reservation);
        return "/reservation/detail";
    }

    /**
     * 예약 취소 처리
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
}
