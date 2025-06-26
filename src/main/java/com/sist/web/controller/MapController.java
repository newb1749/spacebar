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
	
	@RequestMapping(value="/room/testCalendar", method=RequestMethod.GET)
	public String testCalendar() 
	{	
		return "/room/testCalendar";
	}
	
	@RequestMapping(value="/room/testCalendar2", method=RequestMethod.GET)
	public String testCalendar2() 
	{	
		return "/room/testCalendar2";
	}
	
	@RequestMapping(value="/room/testCalendar3", method=RequestMethod.GET)
	public String testCalendar3() 
	{	
		return "/room/testCalendar3";
	}
	
    @RequestMapping(value="/room/testSearch", method=RequestMethod.GET)
    public String searchPage(Model model) {
        // DB에서 모든 숙소 타입의 가장 빠른 체크인 가능일과 가장 늦은 체크아웃 가능일을 조회
        //Map<String, String> overallDates = roomService.getOverallAvailableDates(); // 이 메소드는 새로 구현해야 함
        
        // 예: overallDates.put("minDate", "2025-07-01");
        //     overallDates.put("maxDate", "2025-12-31");

        //model.addAttribute("minDate", overallDates.get("minDate"));
        //model.addAttribute("maxDate", overallDates.get("maxDate"));
        
        return "/room/testSearch"; // search.jsp
    }
}
