package com.sist.web.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller("mapController")
public class MapController {
	
	private static Logger logger = LoggerFactory.getLogger(RoomController.class);

	@RequestMapping(value="/room/test", method=RequestMethod.GET)
	public String mapModule(Model model) 
	{	
		return "/room/test";
	}
}
