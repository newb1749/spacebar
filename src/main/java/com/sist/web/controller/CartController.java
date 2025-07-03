package com.sist.web.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.sist.web.model.Cart;
import com.sist.web.model.Response;
import com.sist.web.service.CartService;
import com.sist.web.service.RoomTypeServiceJY;
import com.sist.web.util.HttpUtil;

@Controller("cartController")
public class CartController {

    @Autowired
    private CartService cartService;
    
    @Autowired
    private RoomTypeServiceJY roomTypeService;

    private static Logger logger = LoggerFactory.getLogger(CartController.class);
    
    @Value("#{env['auth.session.name']}")
    private String AUTH_SESSION_NAME;
    
    //장바구니 등록 (AJAX)
    // ✅ 일반 HttpServletRequest 로 변경
    @RequestMapping(value="/cart/add", method=RequestMethod.POST)
    @ResponseBody
    public Response<Object> addCart(HttpServletRequest request) {
        String sessionUserId = (String)request.getSession().getAttribute(AUTH_SESSION_NAME);
        int    roomTypeSeq    = HttpUtil.get(request, "roomTypeSeq",    0);
        String checkInDt       = HttpUtil.get(request, "rsvCheckInDt",       "");
        String checkOutDt      = HttpUtil.get(request, "rsvCheckOutDt",      "");
        String checkInTime        = HttpUtil.get(request, "rsvCheckInTime",       "");
        String checkOutTime       = HttpUtil.get(request, "rsvCheckOutTime",      "");
        int    guests         = HttpUtil.get(request, "numGuests",        1);
        int    totalAmt       = HttpUtil.get(request, "totalAmt",      0);

        Cart cart = new Cart();
        cart.setUserId         (sessionUserId);
        cart.setRoomTypeSeq    (roomTypeSeq);
        cart.setCartCheckInDt  (checkInDt);
        cart.setCartCheckOutDt (checkOutDt);
        cart.setCartCheckOutDt (checkInTime);
        cart.setCartCheckOutDt (checkOutTime);
        cart.setCartGuestsNum  (guests);
        cart.setCartTotalAmt   (totalAmt);

        Response<Object> ajaxResponse = new Response<>();
        if (cartService.insertCart(cart) > 0) {
            ajaxResponse.setResponse(0, "장바구니에 추가되었습니다.");
        } else {
            ajaxResponse.setResponse(500, "장바구니 추가 실패");
        }
        return ajaxResponse;
    }

    
    //장바구니 리스트
    @RequestMapping(value="/cart/list")
    public String cartList(ModelMap model, HttpServletRequest request) {
        String sessionUserId = (String)request.getSession().getAttribute(AUTH_SESSION_NAME);
        List<Cart> cartList = cartService.cartList(sessionUserId);
        
        model.addAttribute("cartList", cartList);
        
        return "/cart/list";
    }
    
    //장바구니 삭제
    @RequestMapping(value="/cart/delete", method=RequestMethod.POST)
    @ResponseBody
    public Response<Object> deleteCart(HttpServletRequest request) {
        Response<Object> ajaxResponse = new Response<Object>();

        int cartSeq = HttpUtil.get(request, "cartSeq", 0);

        if (cartSeq > 0) {
            if (cartService.deleteCart(cartSeq) > 0) {
                ajaxResponse.setResponse(0, "장바구니 삭제 성공");
            } else {
                ajaxResponse.setResponse(500, "삭제 실패");
            }
        } else {
            ajaxResponse.setResponse(400, "유효하지 않은 요청입니다.");
        }

        return ajaxResponse;
    }

}
