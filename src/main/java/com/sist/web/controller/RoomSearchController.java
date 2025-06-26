package com.sist.web.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.sist.web.service.RoomService;

@Controller("roomSearchController")
public class RoomSearchController {
    
    @Autowired
    private RoomService roomService;
//
//    @RequestMapping(value="/room/testSearch", method=RequestMethod.GET)
//    public String searchPage(Model model) {
//        // DB에서 모든 숙소 타입의 가장 빠른 체크인 가능일과 가장 늦은 체크아웃 가능일을 조회
//        //Map<String, String> overallDates = roomService.getOverallAvailableDates(); // 이 메소드는 새로 구현해야 함
//        
//        // 예: overallDates.put("minDate", "2025-07-01");
//        //     overallDates.put("maxDate", "2025-12-31");
//
//        //model.addAttribute("minDate", overallDates.get("minDate"));
//        //model.addAttribute("maxDate", overallDates.get("maxDate"));
//        
//        return "/room/testSearch"; // search.jsp
//    }
}