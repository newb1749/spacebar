package com.sist.web.controller;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.sist.web.model.Room;
import com.sist.web.model.RoomImage;
import com.sist.web.model.RoomType;
import com.sist.web.service.HostService;
import com.sist.web.service.RoomService;
import com.sist.web.service.RoomTypeService;

@Controller("hostController")
public class HostController {
	private static Logger logger = LoggerFactory.getLogger(RoomController.class);
	
	@Value("#{env['auth.session.name']}")
	private String AUTH_SESSION_NAME;
	
	@Value("#{env['upload.save.dir']}") // env.xml에 있음
	private String UPLOAD_SAVE_DIR;
	
	
    @Autowired
    private HostService hostService;
    
    @Autowired
    private RoomService roomService;
    
    @Autowired
    private RoomTypeService roomTypeService;
    
	/**
	 * 호스트 메인 페이지로 이동
	 * @return
	 */
	@RequestMapping(value="/host/main", method = RequestMethod.GET)
	public String main() {
		return "/host/main";
	}
	
	@RequestMapping(value="/host/fragment/roomList", method=RequestMethod.GET)
	public String roomList(Model model, HttpServletRequest request)
	{
		String sessionUserId = (String)request.getSession().getAttribute(AUTH_SESSION_NAME);
		
		// 본인 숙소 조회
		List<Room> roomList = hostService.selectRoomListByHostId(sessionUserId);
		model.addAttribute("roomList", roomList);
		return "/host/fragment/roomList";
	}
	
	
	@GetMapping("/host/updateRoom")
	public String updateRoom(@RequestParam("roomSeq") int roomSeq, Model model) {
	    // 1. 숙소 기본 정보
	    Room room = roomService.getRoomDetail(roomSeq);
	    model.addAttribute("room", room);

	    // 2. 숙소 이미지 (대표/상세 분리)
	    List<RoomImage> images = roomService.getRoomImgDetail(roomSeq);  // 여기 주의!
	    String mainImageName = null;
	    List<String> detailImageNames = new ArrayList<>();

	    for (RoomImage img : images) {
	        if ("main".equalsIgnoreCase(img.getImgType())) {
	            mainImageName = img.getRoomImgName();  // 저장된 실제 파일명
	        } else if ("detail".equalsIgnoreCase(img.getImgType())) {
	            detailImageNames.add(img.getRoomImgName());
	        }
	    }

	    model.addAttribute("mainImageName", mainImageName);
	    model.addAttribute("detailImageNames", detailImageNames);
	    
	    // 3. 객실 타입 목록 별도 조회
	    List<RoomType> roomTypes = roomTypeService.getRoomTypesByRoomSeq(roomSeq);
	    model.addAttribute("roomTypes", roomTypes);
	    
	    return "/host/updateRoom";
	}




	
	
	
	
	
	
	
	
	
	
	
	
	
}
