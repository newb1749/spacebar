package com.sist.web.controller;


import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;

import com.sist.web.service.RoomWishlistService;

@Controller("roomWishlistController")
public class RoomWishlistController {
	private static Logger logger = LoggerFactory.getLogger(RoomWishlistController.class);
	
	@Value("#{env['auth.cookie.name']}")
	private String AUTH_COOKIE_NAME;
	
	@Autowired
	private RoomWishlistService roomWishlistService;
	

}
