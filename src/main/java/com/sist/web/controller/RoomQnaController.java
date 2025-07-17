
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
import com.sist.web.model.Response;
import com.sist.web.model.Room;
import com.sist.web.model.RoomQnaComment;
import com.sist.web.model.RoomQna;
import com.sist.web.model.RoomQnaComment;
import com.sist.web.model.RoomQna;
import com.sist.web.model.RoomType;
import com.sist.web.model.User;
import com.sist.web.service.RoomQnaCommentService;
import com.sist.web.service.RoomQnaService;
import com.sist.web.service.RoomService;
import com.sist.web.service.UserService_mj;
import com.sist.web.util.HttpUtil;

@Controller("roomQnaController")
public class RoomQnaController 
{
	private static Logger logger = LoggerFactory.getLogger(RoomQnaController.class);
	
    @Autowired
    private RoomService roomService;
    
    @Autowired
    private RoomQnaService roomQnaService;
    
    @Autowired
    private RoomQnaCommentService roomQnaCommentService;
    
    @Autowired
    private UserService_mj userService;
    
    @Value("#{env['auth.session.name']}")
    private String AUTH_SESSION_NAME;

    //Q&A 등록 화면
    @RequestMapping(value="/room/qnaForm", method=RequestMethod.GET)
    public String qnaForm(Model model, HttpServletRequest request, HttpServletResponse response)
    {
    	int roomSeq = HttpUtil.get(request, "roomSeq", 0);
    	String sessionUserId = (String)request.getSession().getAttribute(AUTH_SESSION_NAME);
    	
    	logger.debug("Q&A 등록 화면 sessionUserId : " + sessionUserId);
    	logger.debug("roomSeq : " + roomSeq);
    	
		if(StringUtil.isEmpty(sessionUserId))
		{
			return "redirect:/";
		}
		
		User user = userService.userSelect(sessionUserId);	
		model.addAttribute("user", user);
		
		Room room = roomService.getRoomDetail(roomSeq);
		model.addAttribute("room", room);
		model.addAttribute("roomSeq", roomSeq);
		
    	return "/room/qnaForm";
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
    	
    	logger.debug("Q&A 등록 sessionUserId : " + sessionUserId);
        logger.debug("roomSeq : " + roomSeq);
        logger.debug("roomQnaTitle : " + roomQnaTitle);
        logger.debug("roomQnaContent : " + roomQnaContent);
    	
    	if(roomSeq > 0 && sessionUserId != null && !StringUtil.isEmpty(roomQnaTitle) && !StringUtil.isEmpty(roomQnaContent))
    	{
    		RoomQna roomQna = new RoomQna();
    		roomQna.setRoomSeq(roomSeq);
    		roomQna.setRoomQnaTitle(roomQnaTitle);
    		roomQna.setRoomQnaContent(roomQnaContent);
    		roomQna.setUserId(sessionUserId);
    		roomQna.setRoomQnaStat("Y");
    		
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
    @RequestMapping(value="/room/qnaUpdateForm", method=RequestMethod.GET)
    public String qnaUpdateForm(Model model, HttpServletRequest request, HttpServletResponse response)
    {
    	int roomSeq = HttpUtil.get(request, "roomSeq", 0);
    	int roomQnaSeq = HttpUtil.get(request, "roomQnaSeq", 0);
    	String sessionUserId = (String)request.getSession().getAttribute(AUTH_SESSION_NAME);
    	
    	logger.debug("Q&A 수정 화면 sessionUserId : " + sessionUserId);
    	logger.debug("roomSeq : " + roomSeq);
    	logger.debug("roomQnaSeq : " + roomQnaSeq);
    	
		if(StringUtil.isEmpty(sessionUserId))
		{
			return "redirect:/";
		}
		
		User user = userService.userSelect(sessionUserId);	
		model.addAttribute("user", user);
		
		Room room = roomService.getRoomDetail(roomSeq);
		model.addAttribute("room", room);
		
		RoomQna roomQna = roomQnaService.qnaSelect(roomQnaSeq);
		model.addAttribute("roomQna", roomQna);
    	
    	return "/room/qnaUpdateForm";
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
    	
    	logger.debug("Q&A 수정 sessionUserId : " + sessionUserId);
        logger.debug("roomSeq : " + roomSeq);
        logger.debug("roomQnaSeq : " + roomQnaSeq);
        logger.debug("roomQnaTitle : " + roomQnaTitle);
        logger.debug("roomQnaContent : " + roomQnaContent);
    	
    	if(roomSeq >= 0 && roomQnaSeq >= 0 && sessionUserId != null && !StringUtil.isEmpty(roomQnaTitle) && !StringUtil.isEmpty(roomQnaContent))
		{
    		RoomQna roomQna = new RoomQna();
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
    @RequestMapping(value="/room/qnaCmtForm", method=RequestMethod.GET)
    public String qnaCmtForm(Model model, HttpServletRequest request, HttpServletResponse response)
    {
    	int roomSeq = HttpUtil.get(request, "roomSeq", 0);
    	int roomQnaSeq = HttpUtil.get(request, "roomQnaSeq", 0);
    	String sessionUserId = (String)request.getSession().getAttribute(AUTH_SESSION_NAME);
    	
    	logger.debug("Q&A 답글 등록 화면 sessionUserId : " + sessionUserId);
    	logger.debug("roomSeq : " + roomSeq );
    	logger.debug("==================================================");
    	logger.debug("roomQnaSeq : " + roomQnaSeq );
    	
		if(StringUtil.isEmpty(sessionUserId))
		{
			return "redirect:/";
		}
		
		User user = userService.userSelect(sessionUserId);	
		model.addAttribute("user", user);
		
		Room room = roomService.getRoomDetail(roomSeq);
		model.addAttribute("room", room);
		
		RoomQna roomQna = roomQnaService.qnaSelect(roomQnaSeq);
		model.addAttribute("roomQna", roomQna);
		model.addAttribute("roomQnaSeq", roomQnaSeq);
		
    	return "/room/qnaCmtForm";
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
    	
    	logger.debug("Q&A 답글 등록 sessionUserId : " + sessionUserId);
        logger.debug("roomQnaSeq : " + roomQnaSeq);
        logger.debug("roomQnaCmtContent : " + roomQnaCmtContent);       
    	
    	if(roomQnaSeq >= 0 && sessionUserId != null && !StringUtil.isEmpty(roomQnaCmtContent))
    	{
    		RoomQnaComment roomQnaCmt = new RoomQnaComment();
    		roomQnaCmt.setRoomQnaSeq(roomQnaSeq);
    		roomQnaCmt.setRoomQnaCmtContent(roomQnaCmtContent);
    		roomQnaCmt.setUserId(sessionUserId);
    		roomQnaCmt.setRooQnaCmtStat("Y");
    		
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
	@RequestMapping(value="/room/qnaCmtUpdateForm", method=RequestMethod.GET)
	public String qnaCommentUpdateForm(Model model, HttpServletRequest request, HttpServletResponse response)
	{
		int roomSeq = HttpUtil.get(request, "roomSeq", 0);
		int roomQnaSeq = HttpUtil.get(request, "roomQnaSeq", 0);
		int roomQnaCmtSeq = HttpUtil.get(request, "roomQnaCmtSeq", 0);
		String sessionUserId = (String)request.getSession().getAttribute(AUTH_SESSION_NAME);
		
		logger.debug("Q&A 답글 수정 화면 sessionUserId : " + sessionUserId);
        logger.debug("roomSeq : " + roomSeq);
        logger.debug("roomQnaSeq : " + roomQnaSeq);
        logger.debug("roomQnaCmtSeq : " + roomQnaCmtSeq);
        
		if(StringUtil.isEmpty(sessionUserId))
		{
			return "redirect:/";
		}
		
		User user = userService.userSelect(sessionUserId);	
		model.addAttribute("user", user);
		
		Room room = roomService.getRoomDetail(roomSeq);
		model.addAttribute("room", room);
		
		RoomQna roomQna = roomQnaService.qnaSelect(roomQnaSeq);
		model.addAttribute("roomQna", roomQna);
		
		RoomQnaComment roomQnaComment = roomQnaCommentService.roomQnaCommontSelect(roomQnaCmtSeq);
		model.addAttribute("roomQnaComment", roomQnaComment);
		model.addAttribute("roomQnaCmtSeq", roomQnaCmtSeq);
		
		
		return "/room/qnaCmtUpdateForm";
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
    	
        logger.debug("Q&A 답글 수정 sessionUserId : " + sessionUserId);
        logger.debug("roomQnaSeq : " + roomQnaSeq);
        logger.debug("roomQnaCmtSeq : " + roomQnaCmtSeq);
        logger.debug("roomQnaCmtContent : " + roomQnaCmtContent);
    	
    	if(roomQnaSeq >= 0 && roomQnaCmtSeq >= 0 && sessionUserId != null && !StringUtil.isEmpty(roomQnaCmtContent))
		{
    		RoomQnaComment roomQnaCmt = new RoomQnaComment();
    		
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
    
    
    //Q&A 삭제(Q&A 답글도 같이 삭제 => sts 'N' 변경)
    @RequestMapping(value="/room/qnaDeleteProc", method=RequestMethod.POST)
    @ResponseBody
    public Response<Object> qnaDeleteProc(Model model, HttpServletRequest request, HttpServletResponse response)
    {
    	Response<Object> ajaxRes = new Response<Object>();
    	
    	int roomQnaSeq = HttpUtil.get(request, "roomQnaSeq", 0);
    	String sessionUserId = (String)request.getSession().getAttribute(AUTH_SESSION_NAME);
    	
        logger.debug("Q&A 삭제 sessionUserId : " + sessionUserId);
        logger.debug("roomQnaSeq : " + roomQnaSeq);

        if(sessionUserId == null)
        {
        	ajaxRes.setResponse(410, "loging failed");
        	return ajaxRes;
        }
        
        else
        {
            try
            {
            	if(roomQnaService.qnaDelete(roomQnaSeq) > 0)
            	{
            		ajaxRes.setResponse(0, "success");
            	}
            	else
            	{
            		ajaxRes.setResponse(500, "internal server error");
            	}
            }
            catch(Exception e)
            {
            	logger.error("[RoomController]qnaDeleteProc Exception", e);
            	ajaxRes.setResponse(500, "internal server error2");
            }
        }

    	
    	return ajaxRes;
    }

}
