package com.sist.web.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.sist.web.model.Coupon;
import com.sist.web.service.CouponServiceJY;
import com.sist.web.util.CookieUtil;

@Controller("couponControllerJY")
@RequestMapping("/coupon")
public class CouponControllerJY 
{
    private static final Logger logger = LoggerFactory.getLogger(CouponControllerJY.class);

    @Autowired
    private CouponServiceJY couponService;

    @Value("#{env['auth.cookie.name']}") 
    private String AUTH_COOKIE_NAME;     
    
    @Value("#{env['auth.session.name']}")
    private String AUTH_SESSION_NAME;

    @GetMapping("/listJY")
    public String couponList(Model model)  
    {
        try 
        {
            List<Coupon> couponList = couponService.getAllCoupons();
            model.addAttribute("couponList", couponList);
        } 
        catch(Exception e) 
        {
            logger.error("[CouponControllerJY] couponList Exception", e);
        }
        return "/coupon/listJY";
    }

    @PostMapping(value = "/issue", produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public ResponseEntity<Map<String, Object>> issueCoupon(@RequestParam("cpnSeq") int cpnSeq,
                                                           HttpServletRequest request) {
        Map<String, Object> result = new HashMap<>();

        // ⬇️ 수정된 부분
        String userId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);

        if (userId == null || userId.isEmpty()) 
        {
            result.put("success", false);
            result.put("message", "로그인이 필요합니다.");
            return ResponseEntity.ok(result);
        }

        try 
        {
            boolean alreadyIssued = couponService.isAlreadyIssued(userId, cpnSeq);
            if (alreadyIssued) 
            {
                result.put("success", false);
                result.put("message", "이미 발급된 쿠폰입니다.");
            }
            else 
            {
                couponService.issueCouponToUser(userId, cpnSeq);
                result.put("success", true);
                result.put("message", "쿠폰이 발급되었습니다.");
            }
        } 
        catch (Exception e) 
        {
            logger.error("[CouponControllerJY] issueCoupon Exception", e);
            result.put("success", false);
            result.put("message", "쿠폰 발급 중 오류가 발생했습니다.");
        }
        return ResponseEntity.ok(result);
    }
}