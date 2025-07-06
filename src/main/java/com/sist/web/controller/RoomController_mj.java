package com.sist.web.controller;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.sist.common.util.StringUtil;
import com.sist.web.model.Paging;
import com.sist.web.model.Response;
import com.sist.web.model.Room;
import com.sist.web.model.RoomImage;
import com.sist.web.model.RoomQnaComment_mj;
import com.sist.web.model.RoomQna_mj;
import com.sist.web.model.RoomType;
import com.sist.web.model.RoomTypeJY;
import com.sist.web.model.User_mj;
import com.sist.web.service.RoomImgService_mj;
import com.sist.web.service.RoomQnaCommentService_mj;
import com.sist.web.service.RoomQnaService_mj;
import com.sist.web.service.RoomService_mj;
import com.sist.web.service.RoomTypeServiceJY;
import com.sist.web.service.UserService_mj;
import com.sist.web.util.HttpUtil;

@Controller("roomController_mj")
public class RoomController_mj 
{
	private static Logger logger = LoggerFactory.getLogger(RoomController_mj.class);
	
    @Autowired
    private RoomService_mj roomService;
    
    @Autowired
    private RoomQnaService_mj roomQnaService;
    
    @Autowired
    private RoomQnaCommentService_mj roomQnaCommentService;

    @Autowired
    private RoomImgService_mj roomImgService;

    @Autowired
    private RoomTypeServiceJY roomTypeService;
    
    @Autowired
    private UserService_mj userService;
    
    @Value("#{env['auth.session.name']}")
    private String AUTH_SESSION_NAME;
	
	private static final int LIST_COUNT = 1; 		//한 페이지의 게시물 수
	private static final int PAGE_COUNT = 2; 		//페이징 수

	//ROOM 상세페이지 + Q&A 리스트
    @RequestMapping(value = "/room/roomDetail_mj", method = RequestMethod.GET)
    public String roomDetail(HttpServletRequest request, Model model) 
    {
        int roomSeq = HttpUtil.get(request, "roomSeq", 0);
        int roomQnaSeq = HttpUtil.get(request, "roomQnaSeq", 0);
        int curPage = HttpUtil.get(request, "curPage", 1);
        
        //userType = 'G' 'H'인지 구분하여 Q&A 질문 / 답변 버튼 보여주기 위함
        String sessionUserId = (String)request.getSession().getAttribute(AUTH_SESSION_NAME);
        logger.debug("sessionUserId : " + sessionUserId);
        
        String userType = null;
        if (sessionUserId != null) 
        {
            User_mj userId = userService.userSelect(sessionUserId);
            
            if (userId != null) 
            {
                userType = userId.getUserType(); 
                model.addAttribute("user", userId);
                model.addAttribute("sessionUserId", sessionUserId);
            }
        }
        model.addAttribute("userType", userType);
        
        //Q&A수정시 roomQnaSeq로 조회하기 위함
        RoomQna_mj roomQna = roomQnaService.qnaSelect(roomQnaSeq);
        model.addAttribute("roomQna", roomQna);
        
        List<RoomQna_mj> qnaList = null;
        RoomQna_mj search = new RoomQna_mj();
        int totalCount = 0;
        Paging paging = null;

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

                // **여기서 roomSeq로 객실 타입 리스트 받아서 넘기기**
                List<RoomTypeJY> roomTypes = roomTypeService.getRoomTypesByRoomSeq(roomSeq);
                model.addAttribute("roomTypes", roomTypes);
                
                //QNA 총 개수
                totalCount = roomQnaService.qnaListCount(roomSeq);
                logger.debug("totalCount : " + totalCount);
                
                if(totalCount > 0)
                {
                	paging = new Paging("/room/roomDetail_mj", totalCount, LIST_COUNT, PAGE_COUNT, curPage, "curPage");
                	search.setRoomSeq(roomSeq);
                	search.setStartRow((int)paging.getStartRow());
                	search.setEndRow((int)paging.getEndRow());
                	
                	qnaList = roomQnaService.qnaList(search);
                	
                	if(qnaList != null)
                	{
                		int i;
                		for(i=0; i<qnaList.size(); i++)
                		{
                			qnaList.get(i).setRoomQnaComment(roomQnaCommentService.roomQnaCommontSelect(qnaList.get(i).getRoomQnaSeq()));
                		}
                		
                	}
                }
        		
                model.addAttribute("qnaList", qnaList);
                model.addAttribute("paging", paging);
            }
           
        }

        return "/room/roomDetail_mj";
    }

    //Q&A 등록 화면
    @RequestMapping(value="/room/qnaForm_mj", method=RequestMethod.GET)
    public String qnaForm(Model model, HttpServletRequest request, HttpServletResponse response)
    {
    	int roomSeq = HttpUtil.get(request, "roomSeq", 0);
    	String sessionUserId = (String)request.getSession().getAttribute(AUTH_SESSION_NAME);
    	logger.debug("sessionUserId : " + sessionUserId);
    	
		if(StringUtil.isEmpty(sessionUserId))
		{
			return "redirect:/";
		}
		
		User_mj user = userService.userSelect(sessionUserId);	
		model.addAttribute("user", user);
		
		Room room = roomService.getRoomDetail(roomSeq);
		model.addAttribute("room", room);
		
    	return "/room/qnaForm_mj";
    }
    
    //Q&A 등록
    @RequestMapping(value="/room/qnaWriteProc", method=RequestMethod.POST)
    @ResponseBody
    public Response<Object> qnaProc(Model model, HttpServletRequest request, HttpServletResponse response)
    {
    	Response<Object> ajaxRes = new Response<Object>();
    	
    	int roomSeq = HttpUtil.get(request, "roomSeq", 0);
    	String roomQnaTitle = HttpUtil.get(request, "roomQnaTitle");
    	String roomQnaContent = HttpUtil.get(request, "roomQnaContent");
    	String sessionUserId = (String)request.getSession().getAttribute(AUTH_SESSION_NAME);
    	
        logger.debug("roomSeq : " + roomSeq);
        logger.debug("roomQnaTitle : " + roomQnaTitle);
        logger.debug("roomQnaContent : " + roomQnaContent);
        logger.debug("sessionUserId : " + sessionUserId);
    	
    	if(roomSeq > 0 && sessionUserId != null && !StringUtil.isEmpty(roomQnaTitle) && !StringUtil.isEmpty(roomQnaContent))
    	{
    		RoomQna_mj roomQna = new RoomQna_mj();
    		roomQna.setRoomSeq(roomSeq);
    		roomQna.setRoomQnaTitle(roomQnaTitle);
    		roomQna.setRoomQnaContent(roomQnaContent);
    		roomQna.setUserId(sessionUserId);
    		
    		if(roomQnaService.qnaInsert(roomQna) > 0)
    		{
    			ajaxRes.setResponse(0, "success");
    		}
    		else
    		{
    			ajaxRes.setResponse(500, "internal server error");
    		}
    	}
    	else
    	{
    		ajaxRes.setResponse(400, "bad request");
    	}
    	
    	return ajaxRes;
    			
    }

    //Q&A 수정 화면
    @RequestMapping(value="/room/qnaUpdateForm_mj", method=RequestMethod.GET)
    public String qnaUpdateForm(Model model, HttpServletRequest request, HttpServletResponse response)
    {
    	int roomSeq = HttpUtil.get(request, "roomSeq", 0);
    	int roomQnaSeq = HttpUtil.get(request, "roomQnaSeq", 0);
    	String sessionUserId = (String)request.getSession().getAttribute(AUTH_SESSION_NAME);
    	logger.debug("sessionUserId : " + sessionUserId);
    	
		if(StringUtil.isEmpty(sessionUserId))
		{
			return "redirect:/";
		}
		
		User_mj user = userService.userSelect(sessionUserId);	
		model.addAttribute("user", user);
		
		Room room = roomService.getRoomDetail(roomSeq);
		model.addAttribute("room", room);
		
		RoomQna_mj roomQna = roomQnaService.qnaSelect(roomQnaSeq);
		model.addAttribute("roomQna", roomQna);
    	
    	return "/room/qnaUpdateForm_mj";
    }
    
    //Q&A 수정
    @RequestMapping(value="/room/qnaUpdateProc", method=RequestMethod.POST)
    @ResponseBody
    public Response<Object> qnsUpdateProc(Model model, HttpServletRequest request, HttpServletResponse response)
    {
    	Response<Object> ajaxRes = new Response<Object>();
    	
    	int roomSeq = HttpUtil.get(request, "roomSeq", 0);
    	int roomQnaSeq = HttpUtil.get(request, "roomQnaSeq", 0);
    	String roomQnaTitle = HttpUtil.get(request, "roomQnaTitle");
    	String roomQnaContent = HttpUtil.get(request, "roomQnaContent");
    	String sessionUserId = (String)request.getSession().getAttribute(AUTH_SESSION_NAME);
    	
        logger.debug("roomSeq : " + roomSeq);
        logger.debug("roomQnaSeq : " + roomQnaSeq);
        logger.debug("roomQnaTitle : " + roomQnaTitle);
        logger.debug("roomQnaContent : " + roomQnaContent);
        logger.debug("sessionUserId : " + sessionUserId);
    	
    	if(roomSeq > 0 && roomQnaSeq >= 0 && sessionUserId != null && !StringUtil.isEmpty(roomQnaTitle) && !StringUtil.isEmpty(roomQnaContent))
		{
    		RoomQna_mj roomQna = new RoomQna_mj();
    		roomQna.setRoomSeq(roomSeq);
    		roomQna.setRoomQnaSeq(roomQnaSeq);
    		roomQna.setRoomQnaTitle(roomQnaTitle);
    		roomQna.setRoomQnaContent(roomQnaContent);
    		roomQna.setUserId(sessionUserId);
    		
    		if(roomQnaService.qnaUpdate(roomQna) > 0)
    		{
    			ajaxRes.setResponse(0, "success");
    		}
    		else
    		{
    			ajaxRes.setResponse(500, "internal server error");
    		}
    	}
    	else
    	{
    		ajaxRes.setResponse(400, "bad request");
    	}
    	
    	return ajaxRes;
    }
    
    //Q&A 답글 등록 화면
    @RequestMapping(value="/room/qnaCmtForm_mj", method=RequestMethod.GET)
    public String qnaCmtForm(Model model, HttpServletRequest request, HttpServletResponse response)
    {
    	int roomSeq = HttpUtil.get(request, "roomSeq", 0);
    	int roomQnaSeq = HttpUtil.get(request, "roomQnaSeq", 0);
    	String sessionUserId = (String)request.getSession().getAttribute(AUTH_SESSION_NAME);
    	logger.debug("sessionUserId : " + sessionUserId);
    	
    	logger.debug("==================================================");
    	logger.debug("roomQnaSeq : " + roomQnaSeq );
    	
		if(StringUtil.isEmpty(sessionUserId))
		{
			return "redirect:/";
		}
		
		User_mj user = userService.userSelect(sessionUserId);	
		model.addAttribute("user", user);
		
		Room room = roomService.getRoomDetail(roomSeq);
		model.addAttribute("room", room);
		
		RoomQna_mj roomQna = roomQnaService.qnaSelect(roomQnaSeq);
		model.addAttribute("roomQna", roomQna);
		model.addAttribute("roomQnaSeq", roomQnaSeq);
		
    	return "/room/qnaCmtForm_mj";
    }
    
    
    //Q&A 답글 등록
    @RequestMapping(value="/room/qnaCmtWriteProc", method=RequestMethod.POST)
    @ResponseBody
    public Response<Object> qnaCmtProc(Model model, HttpServletRequest request, HttpServletResponse response)
    {
    	Response<Object> ajaxRes = new Response<Object>();
    	
    	int roomQnaSeq = HttpUtil.get(request, "roomQnaSeq", 0);
    	String roomQnaCmtContent = HttpUtil.get(request, "roomQnaCmtContent");
    	String sessionUserId = (String)request.getSession().getAttribute(AUTH_SESSION_NAME);
    	
        logger.debug("roomQnaSeq : " + roomQnaSeq);
        logger.debug("roomQnaCmtContent : " + roomQnaCmtContent);
        logger.debug("sessionUserId : " + sessionUserId);
    	
    	if(roomQnaSeq >= 0 && sessionUserId != null && !StringUtil.isEmpty(roomQnaCmtContent))
    	{
    		RoomQnaComment_mj roomQnaCmt = new RoomQnaComment_mj();
    		roomQnaCmt.setRoomQnaSeq(roomQnaSeq);
    		roomQnaCmt.setRoomQnaCmtContent(roomQnaCmtContent);
    		roomQnaCmt.setUserId(sessionUserId);
    		
    		if(roomQnaCommentService.qnaCommentInsert(roomQnaCmt) > 0)
    		{
    			ajaxRes.setResponse(0, "success");
    		}
    		else
    		{
    			ajaxRes.setResponse(500, "internal server error");
    		}
    	}
    	else
    	{
    		ajaxRes.setResponse(400, "bad request");
    	}
    	
    	return ajaxRes;
    			
    }
    
    //Q&A 답글 수정 화면
	@RequestMapping(value="/room/qnaCmtUpdateForm_mj", method=RequestMethod.GET)
	public String qnaCommentUpdateForm(Model model, HttpServletRequest request, HttpServletResponse response)
	{
		int roomSeq = HttpUtil.get(request, "roomSeq", 0);
		int roomQnaSeq = HttpUtil.get(request, "roomQnaSeq", 0);
		int roomQnaCmtSeq = HttpUtil.get(request, "roomQnaCmtSeq", 0);
		String sessionUserId = (String)request.getSession().getAttribute(AUTH_SESSION_NAME);
		logger.debug("sessionUserId : " + sessionUserId);
		
		if(StringUtil.isEmpty(sessionUserId))
		{
			return "redirect:/";
		}
		
		User_mj user = userService.userSelect(sessionUserId);	
		model.addAttribute("user", user);
		
		Room room = roomService.getRoomDetail(roomSeq);
		model.addAttribute("room", room);
		
		RoomQna_mj roomQna = roomQnaService.qnaSelect(roomQnaSeq);
		model.addAttribute("roomQna", roomQna);
		
		RoomQnaComment_mj roomQnaComment = roomQnaCommentService.roomQnaCommontSelect(roomQnaCmtSeq);
		model.addAttribute("roomQnaComment", roomQnaComment);
		model.addAttribute("roomQnaCmtSeq", roomQnaCmtSeq);
		
		
		return "/room/qnaCmtUpdateForm_mj";
	}
    
    //Q&A 답글 수정
    @RequestMapping(value="/room/qnaCmtUpdateProc", method=RequestMethod.POST)
    @ResponseBody
    public Response<Object> qnaCommentUpdateProc(Model model, HttpServletRequest request, HttpServletResponse response)
    {
    	Response<Object> ajaxRes = new Response<Object>();
    	
    	int roomQnaSeq = HttpUtil.get(request, "roomQnaSeq", 0);
    	int roomQnaCmtSeq = HttpUtil.get(request, "roomQnaCmtSeq", 0);
    	String roomQnaCmtContent = HttpUtil.get(request, "roomQnaCmtContent");
    	String sessionUserId = (String)request.getSession().getAttribute(AUTH_SESSION_NAME);
    	
        logger.debug("roomQnaSeq : " + roomQnaSeq);
        logger.debug("roomQnaCmtSeq : " + roomQnaCmtSeq);
        logger.debug("roomQnaCmtContent : " + roomQnaCmtContent);
        logger.debug("sessionUserId : " + sessionUserId);
    	
    	if(roomQnaSeq > 0 && roomQnaCmtSeq > 0 && sessionUserId != null && !StringUtil.isEmpty(roomQnaCmtContent))
		{
    		RoomQnaComment_mj roomQnaCmt = new RoomQnaComment_mj();
    		
    		roomQnaCmt.setRoomQnaSeq(roomQnaSeq);
    		roomQnaCmt.setRoomQnaCmtSeq(roomQnaCmtSeq);
    		roomQnaCmt.setRoomQnaCmtContent(roomQnaCmtContent);
    		roomQnaCmt.setUserId(sessionUserId);
    		
    		if(roomQnaCommentService.qnaCommentUpdate(roomQnaCmt) > 0)
    		{
    			ajaxRes.setResponse(0, "success");
    		}
    		else
    		{
    			ajaxRes.setResponse(500, "internal server error");
    		}
    	}
    	else
    	{
    		ajaxRes.setResponse(400, "bad request");
    	}
    	
    	return ajaxRes;
    }
    
    
    //Q&A 삭제(Q&A 답글도 같이 삭제)

}





















