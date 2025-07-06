package com.sist.web.controller;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.sist.web.model.Room;
import com.sist.web.model.RoomImage;
import com.sist.web.model.RoomTypeJY;
import com.sist.web.service.RoomImgService;
import com.sist.web.service.RoomService;
import com.sist.web.service.RoomTypeServiceJY;
import com.sist.web.util.HttpUtil;

@Controller("roomControllerJY")
public class RoomControllerJY 
{
    @Autowired
    private RoomService roomService;

    @Autowired
    private RoomImgService roomImgService;

    @Autowired
    private RoomTypeServiceJY roomTypeService;
    
    
    @Value("#{env['auth.session.name']}")
    private String AUTH_SESSION_NAME;

    @RequestMapping(value = "/room/roomDetail", method = RequestMethod.GET)
    public String roomDetail(HttpServletRequest request, Model model) 
    {
        int roomSeq = HttpUtil.get(request, "roomSeq", 0);

        if(roomSeq > 0) 
        {
            Room room = roomImgService.getRoomDetail(roomSeq);

            if(room != null) 
            {
                List<RoomImage> roomImg = roomImgService.getRoomImgDetail(roomSeq);
                if(roomImg != null) 
                {
                    room.setRoomImageList(roomImg);
                    RoomImage mainImages = null;
                    List<RoomImage> detailImages = new ArrayList<>();

                    for(RoomImage img : roomImg) 
                    {
                        if("main".equals(img.getImgType())) 
                        {
                            mainImages = img;
                        } 
                        else
                        {
                            detailImages.add(img);
                        }
                    }

                    model.addAttribute("mainImages", mainImages);
                    model.addAttribute("detailImages", detailImages);
                }

                model.addAttribute("room", room);
                
                model.addAttribute("roomCatSeq", room.getRoomCatSeq());
                
                logger.debug("roomCatSeq = " + room.getRoomCatSeq());
                
                // **여기서 roomSeq로 객실 타입 리스트 받아서 넘기기**
                List<RoomTypeJY> roomTypes = roomTypeService.getRoomTypesByRoomSeq(roomSeq);
                model.addAttribute("roomTypes", roomTypes);
            }
        }

        return "/room/roomDetail";
    }

}
