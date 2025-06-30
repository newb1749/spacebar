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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.sist.common.util.StringUtil;
import com.sist.web.model.Room;
import com.sist.web.model.RoomImage;
import com.sist.web.service.RoomImgService;
import com.sist.web.service.RoomService;
import com.sist.web.util.HttpUtil;

@Controller("roomControllerJY")
public class RoomControllerJY 
{
private static Logger logger = LoggerFactory.getLogger(RoomController.class);
	
	@Value("#{env['auth.cookie.name']}")
	private String AUTH_COOKIE_NAME;
	
	@Value("#{env['upload.save.dir']}") // env.xml에 있음
	private String UPLOAD_SAVE_DIR;
	
	@Autowired
	private RoomService roomService;
	
	@Autowired
	private RoomImgService roomImgService;
	
	
	// 숙소 상세
	@RequestMapping(value = "/room/roomDetail", method = RequestMethod.GET)
	public String roomDetail(HttpServletRequest request, Model model) 
	{
	    int roomSeq = HttpUtil.get(request, "roomSeq", 0);

	    if (roomSeq > 0)
	    {
	    	Room room = roomImgService.getRoomDetail(roomSeq);
	    	
	    	if(room != null)
	    	{
		        List<RoomImage> roomImg = roomImgService.getRoomImgDetail(roomSeq);
		        
		        if (roomImg != null) 
		        {
		        	room.setRoomImageList(roomImg);

		            RoomImage mainImages = null;
		            List<RoomImage> detailImages = new ArrayList<>();

	                for(RoomImage img : roomImg) // room.getRoomImageList()
	                {
	                    if (StringUtil.equals(img.getImgType(), "main"))
	                    {
	                    	mainImages = img;
	                    }
	                    else
	                    {
	                    	detailImages.add(img);
	                    }
	                }
		            
		            model.addAttribute("room", room);	
		            model.addAttribute("mainImages", mainImages);
		            model.addAttribute("detailImages", detailImages);
		        }
	    	}
	    }

	    return "/room/roomDetail";
	}
}