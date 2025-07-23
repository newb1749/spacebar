package com.sist.web.controller;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
// import org.springframework.stereotype.Controller;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.sist.web.dao.MileageHistoryDao;
import com.sist.web.dao.ReservationDao;
import com.sist.web.model.Cart;
import com.sist.web.model.Coupon;
import com.sist.web.model.MileageHistory;
import com.sist.web.model.Reservation;
import com.sist.web.model.Response;
import com.sist.web.model.RoomType;
import com.sist.web.service.CartService;
import com.sist.web.service.CouponServiceJY;
import com.sist.web.service.MileageServiceJY;
import com.sist.web.service.ReservationServiceJY;
import com.sist.web.service.RoomTypeService;
import com.sist.web.util.HttpUtil;

@Controller("cartController")
public class CartController {

    private static final Logger logger = LoggerFactory.getLogger(CartController.class);

    @Autowired
    private CartService cartService;
    
    @Autowired
    private ReservationServiceJY reservationService;

    @Autowired
    private MileageServiceJY mileageService;
    
    @Autowired
    private RoomTypeService roomTypeService;

    @Autowired
    private ReservationDao reservationDao;
    
    @Autowired
    private MileageHistoryDao mileageHistoryDao;
    
    @Autowired
    private CouponServiceJY couponService;
    

    @Value("#{env['auth.session.name']}")
    private String AUTH_SESSION_NAME;

    /** 장바구니 등록 */
    @PostMapping("/cart/add")
    @ResponseBody
    public Response<Object> addCart(HttpServletRequest request) {
        String sessionUserId = (String)request.getSession().getAttribute(AUTH_SESSION_NAME);
        int    roomTypeSeq    = HttpUtil.get(request, "roomTypeSeq", 0);
        String checkInDt      = HttpUtil.get(request, "rsvCheckInDt", "");
        String checkOutDt     = HttpUtil.get(request, "rsvCheckOutDt", "");
        String checkInTime    = HttpUtil.get(request, "rsvCheckInTime", "");
        String checkOutTime   = HttpUtil.get(request, "rsvCheckOutTime", "");
        int    guests         = HttpUtil.get(request, "numGuests", 1);
        
        try {
            checkInTime = String.format("%04d", Integer.parseInt(checkInTime));
        } catch (NumberFormatException e) {
            checkInTime = ""; 
        }
        
        try {
            checkOutTime = String.format("%04d", Integer.parseInt(checkOutTime));
        } catch (NumberFormatException e) {
            checkOutTime = "";
        }
        
        // 1) 룸타입 정보 조회 (service/DAO 에서 WEEKDAY_AMT, WEEKEND_AMT 필드 포함)
        RoomType rt = roomTypeService.getRoomType(roomTypeSeq);
        int weekdayAmt = rt.getWeekdayAmt();
        int weekendAmt = rt.getWeekendAmt();
        
        // 2) 날짜 파싱 및 합산
        DateTimeFormatter fmt = DateTimeFormatter.ofPattern("yyyyMMdd");
        LocalDate start = LocalDate.parse(checkInDt, fmt);
        LocalDate end   = LocalDate.parse(checkOutDt, fmt);
        int totalAmt = 0;
        if (start.equals(end)) {
            // 당일 예약은 1박으로 계산
            DayOfWeek dow = start.getDayOfWeek();
            if (dow == DayOfWeek.FRIDAY 
             || dow == DayOfWeek.SATURDAY 
             || dow == DayOfWeek.SUNDAY) {
                totalAmt += weekendAmt;
            } else {
                totalAmt += weekdayAmt;
            }
        } else {
            // 기존 로직: start 부터 end 전날까지 계산
            for (LocalDate d = start; d.isBefore(end); d = d.plusDays(1)) {
                DayOfWeek dow = d.getDayOfWeek();
                if (dow == DayOfWeek.FRIDAY 
                 || dow == DayOfWeek.SATURDAY 
                 || dow == DayOfWeek.SUNDAY) {
                    totalAmt += weekendAmt;
                } else {
                    totalAmt += weekdayAmt;
                }
            }
        }
        
        

        Cart cart = new Cart();
        cart.setUserId            (sessionUserId);
        cart.setRoomTypeSeq       (roomTypeSeq);
        cart.setCartCheckInDt     (checkInDt);
        cart.setCartCheckOutDt    (checkOutDt);
        cart.setCartCheckInTime   (checkInTime);   // <-- 여기를 setCartCheckInTime 으로
        cart.setCartCheckOutTime  (checkOutTime);  // <-- 여기를 setCartCheckOutTime 으로
        cart.setCartGuestsNum     (guests);
        cart.setCartTotalAmt      (totalAmt);

        Response<Object> ajaxResponse = new Response<>();
        if (cartService.insertCart(cart) > 0) {
            ajaxResponse.setResponse(0, "장바구니에 추가되었습니다.");
        } else {
            ajaxResponse.setResponse(500, "장바구니 추가 실패");
        }
        return ajaxResponse;
    }

    /** 장바구니 리스트 */
    @RequestMapping("/cart/list")
    public String cartList(ModelMap model, HttpServletRequest request) {
        String userId = (String)request.getSession().getAttribute(AUTH_SESSION_NAME);
        List<Cart> cartList = cartService.cartList(userId);
        model.addAttribute("cartList", cartList);
        return "/cart/list";
    }

    /** 장바구니 삭제 */
    @PostMapping("/cart/delete")
    @ResponseBody
    public Response<Object> deleteCart(HttpServletRequest request) {
        int cartSeq = HttpUtil.get(request, "cartSeq", 0);
        Response<Object> ajax = new Response<>();
        if (cartSeq <= 0) {
            ajax.setResponse(400, "유효하지 않은 요청입니다.");
        } else if (cartService.deleteCart(cartSeq) > 0) {
            ajax.setResponse(0, "장바구니 삭제 성공");
        } else {
            ajax.setResponse(500, "삭제 실패");
        }
        return ajax;
    }
    
    @PostMapping("/cart/confirm")
    public String cartConfirm(
            @RequestParam("cartSeqs") List<Integer> cartSeqs,
            HttpSession session,
            Model model,
            RedirectAttributes rt) {

        String userId = (String) session.getAttribute(AUTH_SESSION_NAME);
        if (userId == null) {
            return "redirect:/user/login";
        }

        // Cart → Reservation 변환 리스트
        List<Cart> carts = cartService.getCartsBySeqs(cartSeqs, userId);
        if (carts.size() != cartSeqs.size()) {
            rt.addFlashAttribute("error", "유효하지 않은 장바구니 항목이 있습니다.");
            return "redirect:/cart/list";
        }

        List<Reservation> reservations = new ArrayList<>();
        for (Cart c : carts) {
            Reservation r = new Reservation();
            
            r.setGuestId(userId);
            r.setRoomTypeSeq(c.getRoomTypeSeq());
            r.setRsvCheckInDt(c.getCartCheckInDt());
            r.setRsvCheckOutDt(c.getCartCheckOutDt());
            r.setRsvCheckInTime(c.getCartCheckInTime());
            r.setRsvCheckOutTime(c.getCartCheckOutTime());
            r.setNumGuests(c.getCartGuestsNum());
            r.setTotalAmt(c.getCartTotalAmt());
            r.setFinalAmt(c.getCartTotalAmt());
            r.setRsvStat("CONFIRMED");
            r.setRsvPaymentStat("PAID");
            r.setRoomTypeTitle(c.getRoomTypeTitle());

            reservations.add(r);
        }

        int totalAmt    = reservations.stream().mapToInt(Reservation::getFinalAmt).sum();
        int userMileage = mileageService.getUserMileage(userId);
        
        List<Coupon> couponList = couponService.getAvailableCouponsForUser(userId);
        
        if(couponList != null)
        {
            model.addAttribute("couponList", couponList);
        }

        model.addAttribute("reservations", reservations);
        model.addAttribute("totalAmt", totalAmt);
        model.addAttribute("userMileage", userMileage);
        model.addAttribute("cartSeqs", cartSeqs);

        // 새로 만들 Confirm 뷰 경로
        return "/cart/confirmCart";
    }
    
    //장바구니 결제
    @RequestMapping(value = "/cart/checkout", method = RequestMethod.POST)
    public String checkout(
            @RequestParam("cartSeqs")                 List<Integer> cartSeqs,
            @RequestParam("itemFinalAmt")             List<Integer> clientItemFinalAmts,
            @RequestParam(value="useCouponYn",   required=false) List<String>  useCouponYnsParam,
            @RequestParam(value="itemCouponSeq", required=false) List<String>  itemCouponSeqStrsParam,
            HttpServletRequest request,
            RedirectAttributes rt
    ) {
        HttpSession session = request.getSession();
        String userId = (String) session.getAttribute(AUTH_SESSION_NAME);
        if (userId == null) {
            return "redirect:/user/login";
        }

        int size = cartSeqs.size();

        // -------- 파라미터 기본값 보정 --------
        List<String> useCouponYns   = new ArrayList<>();
        List<String> itemCouponSeqs = new ArrayList<>();

        for (int i = 0; i < size; i++) {
            // useCouponYn
            String yn = (useCouponYnsParam != null && useCouponYnsParam.size() > i)
                    ? useCouponYnsParam.get(i) : "N";
            useCouponYns.add(yn);

            // itemCouponSeq
            String seqStr = (itemCouponSeqStrsParam != null && itemCouponSeqStrsParam.size() > i)
                    ? itemCouponSeqStrsParam.get(i) : "";
            itemCouponSeqs.add(seqStr);
        }

        // -------- 장바구니 조회 --------
        List<Cart> carts = cartService.getCartsBySeqs(cartSeqs, userId);
        if (carts.size() != size) {
            rt.addFlashAttribute("error", "유효하지 않은 장바구니 항목이 있습니다.");
            return "redirect:/cart/list";
        }
        Map<Integer, Cart> cartMap = new HashMap<>();
        for (Cart c : carts) cartMap.put(c.getCartSeq(), c);

        int totalFinalAmt = 0;
        Set<Integer> usedCouponSeqSet = new HashSet<>();
        List<Integer> finalAmtList = new ArrayList<>(size);

        for (int i = 0; i < size; i++) {
            Cart cart = cartMap.get(cartSeqs.get(i));
            int originAmt = cart.getCartTotalAmt();
            int finalAmt  = originAmt;

            // ---- 쿠폰 처리 ----
            String seqStr = itemCouponSeqs.get(i);
            Integer couponSeq = null;
            if (seqStr != null && !seqStr.trim().isEmpty()) {
                try { couponSeq = Integer.valueOf(seqStr.trim()); } catch (Exception ignore) {}
            }

            if (couponSeq != null && couponSeq > 0) {
                // 같은 쿠폰 중복 사용 방지
                if (usedCouponSeqSet.contains(couponSeq)) {
                    rt.addFlashAttribute("error", "같은 쿠폰은 두 번 사용할 수 없습니다.");
                    return "redirect:/cart/confirm";
                }

                // 보유/미사용 여부
                if (!couponService.isAlreadyIssued(userId, couponSeq)) {
                    rt.addFlashAttribute("error", "사용할 수 없는 쿠폰이 포함되어 있습니다.");
                    return "redirect:/cart/confirm";
                }

                // 쿠폰 상세
                Coupon coupon = couponService.getCouponBySeq(couponSeq);
                if (coupon == null || !"Y".equals(coupon.getCpnStat())) {
                    rt.addFlashAttribute("error", "비활성화된 쿠폰입니다.");
                    return "redirect:/cart/confirm";
                }

                // 기간 체크
                LocalDate endDate = null;
                Object rawEnd = coupon.getIssueEndDt(); // String or Date
                if (rawEnd instanceof Date) {
                    endDate = ((Date)rawEnd).toInstant().atZone(ZoneId.systemDefault()).toLocalDate();
                } else if (rawEnd != null) {
                    String s = rawEnd.toString();
                    if (s.length() >= 10) {
                        endDate = LocalDate.parse(s.substring(0,10), DateTimeFormatter.ISO_LOCAL_DATE);
                    }
                }
                if (endDate != null && endDate.isBefore(LocalDate.now())) {
                    rt.addFlashAttribute("error", "기간이 지난 쿠폰입니다.");
                    return "redirect:/cart/confirm";
                }

                // 최소주문금액 체크(필요시)
                if (coupon.getMinOrderAmt() > 0 && originAmt < coupon.getMinOrderAmt()) {
                    rt.addFlashAttribute("error", "최소 주문금액에 미달한 쿠폰이 있습니다.");
                    return "redirect:/cart/confirm";
                }

                // 할인
                if (coupon.getDiscountRate() > 0) {
                    finalAmt = originAmt - (int)Math.floor(originAmt * coupon.getDiscountRate() / 100.0);
                } else {
                    finalAmt = Math.max(0, originAmt - coupon.getDiscountAmt());
                }

                couponService.markCouponAsUsed(userId, couponSeq);
                usedCouponSeqSet.add(couponSeq);
            }

            totalFinalAmt += finalAmt;
            finalAmtList.add(finalAmt);
        }

        // -------- 마일리지 --------
        int userMileage = mileageService.getUserMileage(userId);
        if (userMileage < totalFinalAmt) {
            rt.addFlashAttribute("error", "마일리지가 부족합니다.");
            return "redirect:/cart/list";
        }
        if (!mileageService.deductMileage(userId, totalFinalAmt)) {
            rt.addFlashAttribute("error", "마일리지 결제 오류");
            return "redirect:/cart/list";
        }

        // 이력
        int updatedRows = mileageHistoryDao.updateMileageDeduct(userId, totalFinalAmt);
        if (updatedRows > 0) {
            MileageHistory history = new MileageHistory();
            history.setUserId(userId);
            history.setTrxType("결제");
            history.setTrxAmt(-totalFinalAmt);
            history.setBalanceAfterTrx(userMileage - totalFinalAmt);
            mileageHistoryDao.insertMileageHistory(history);
        }

        // -------- 예약 저장 --------
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
        for (int i = 0; i < size; i++) {
            Cart c = cartMap.get(cartSeqs.get(i));
            int finalAmt = finalAmtList.get(i);

            Reservation r = new Reservation();
            r.setGuestId(userId);
            r.setRoomTypeSeq(c.getRoomTypeSeq());
            r.setRsvCheckInDt(c.getCartCheckInDt());
            r.setRsvCheckOutDt(c.getCartCheckOutDt());
            r.setRsvCheckInTime(c.getCartCheckInTime());
            r.setRsvCheckOutTime(c.getCartCheckOutTime());
            r.setNumGuests(c.getCartGuestsNum());
            r.setTotalAmt(c.getCartTotalAmt());
            r.setFinalAmt(finalAmt);
            r.setRsvStat("CONFIRMED");
            r.setRsvPaymentStat("PAID");

            try {
                Date inDate  = sdf.parse(c.getCartCheckInDt());
                Date outDate = sdf.parse(c.getCartCheckOutDt());
                r.setRsvCheckInDateObj(inDate);
                r.setRsvCheckOutDateObj(outDate);

                RoomType rtObj = roomTypeService.getRoomType(c.getRoomTypeSeq());
                String hostId = (rtObj != null ? rtObj.getHostId() : null);
                if (hostId == null || hostId.trim().isEmpty()) {
                    hostId = reservationDao.selectHostIdByRoomSeq(rtObj.getRoomSeq());
                }
                r.setHostId(hostId);

                reservationService.insertReservation(r);
            } catch (ParseException pe) {
                rt.addFlashAttribute("error", "날짜 형식 오류: " + c.getCartCheckInDt() + " / " + c.getCartCheckOutDt());
                return "redirect:/cart/list";
            } catch (Exception e) {
                rt.addFlashAttribute("error", "예약 저장 중 오류 발생: " + e.getMessage());
                return "redirect:/cart/list";
            }
        }

        cartService.deleteCarts(cartSeqs, userId);

        rt.addFlashAttribute("msg", "예약이 완료되었습니다.");
        return "redirect:/reservation/list";
    }



}
