package com.sist.web.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.sist.common.util.StringUtil;
import com.sist.web.model.FreeBoard;
import com.sist.web.model.FreeBoardComment;
import com.sist.web.model.Paging;
import com.sist.web.model.Qna;
import com.sist.web.model.QnaComment;
import com.sist.web.model.Response;
import com.sist.web.model.User;
import com.sist.web.service.QnaService;
import com.sist.web.service.UserService;
import com.sist.web.util.HttpUtil;

@Controller("qnaController")
public class QnaController {
	
	private static Logger logger = LoggerFactory.getLogger(QnaController.class);
	
	@Value("#{env['auth.session.name']}")
    private String AUTH_SESSION_NAME;
	
	@Autowired
	private QnaService qnaService;
	
	@Autowired
	private UserService userService;
	
	private static final int LIST_COUNT = 5; 	// 한 페이지의 게시물 수
	private static final int PAGE_COUNT = 5;	// 페이징 수
	
	//게시판 리스트
	@RequestMapping(value="/qna/list")
	public String list(ModelMap model, HttpServletRequest request, HttpServletResponse response)
	{	
		//조회값
		String searchValue = HttpUtil.get(request, "searchValue","");
		//현재 페이지
		long curPage = HttpUtil.get(request, "curPage", (long)1);
		
		//게시물 리스트
		List<Qna> list = null;
		//질문 조회 객체
		Qna qna = new Qna();
		//답변 객체
		QnaComment qnaComment = new QnaComment();
		//총 게시물 수
		long totalCount = 0;
		//페이징 객체
		Paging paging = null;
		
		if(!StringUtil.isEmpty(searchValue))
		{
			qna.setSearchValue(searchValue);
		}
		else
		{
			searchValue = "";
		}
		
		totalCount = qnaService.qnaListCount(qna);
		
		if(totalCount > 0)
		{
			paging = new Paging("/qna/list",totalCount,LIST_COUNT,PAGE_COUNT,curPage,"curPage");
			
			qna.setStartRow(paging.getStartRow());
			qna.setEndRow(paging.getEndRow());
			
			list = qnaService.qnaList(qna);
		}
		
		model.addAttribute("list",list);
		model.addAttribute("searchValue",searchValue);
		model.addAttribute("curPage",curPage);
		model.addAttribute("paging",paging);
		model.addAttribute("boardType","qna");
		
		return "/qna/list";
	}
	
	//게시판 상세 조회(댓글도 같이 조회되도록)
	@RequestMapping(value="/qna/view")
	public String view(ModelMap model, HttpServletRequest request, HttpServletResponse response)
	{
		long qnaSeq = HttpUtil.get(request, "qnaSeq", (long)0);
		String searchValue = HttpUtil.get(request, "searchValue","");
		long curPage = HttpUtil.get(request, "curPage", (long)1);
		
		String boardMe = "N";
		String sessionUserId = (String)request.getSession().getAttribute(AUTH_SESSION_NAME);
		
		Qna qna = null;
		QnaComment qnaComment = null;
		
		if(qnaSeq > 0)
		{
			qna = qnaService.qnaSelect(qnaSeq);
			qnaComment = qnaService.qnaCommentSelect(qnaSeq);
			
			if(qna != null && StringUtil.equals(qna.getUserId(), sessionUserId))
			{
				boardMe = "Y";
			}
		}
		
		model.addAttribute("sessionUserId",sessionUserId);
		model.addAttribute("qnaSeq",qnaSeq);
		model.addAttribute("searchValue",searchValue);
		model.addAttribute("curPage",curPage);
		model.addAttribute("boardMe",boardMe);
		model.addAttribute("qna",qna);
		model.addAttribute("qnaComment",qnaComment);
		
		
		
		return "/qna/view";
	}
	
	//게시판 삭제(삭제시 댓글도 삭제)
	@RequestMapping(value="/qna/delete", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> delete(HttpServletRequest request, HttpServletResponse response)
	{
		Response<Object> ajaxResponse = new Response<Object>();
		
		long qnaSeq = HttpUtil.get(request, "qnaSeq", (long)0);
		String sessionUserId = (String)request.getSession().getAttribute(AUTH_SESSION_NAME);
		
		if(qnaSeq > 0)
		{
			Qna qna = qnaService.qnaSelect(qnaSeq);
			
			if(qna != null)
			{
				if(StringUtil.equals(sessionUserId, qna.getUserId()))
				{
					try
					{
						//게시판 삭제
						if(qnaService.qnaDelete(qnaSeq) > 0)
						{
							ajaxResponse.setResponse(0, "success");
						}
						else
						{
							ajaxResponse.setResponse(500, "server error1");
						}
					}
					catch(Exception e)
					{
						logger.error("[QnaController] /qna/delete  Exception : ", e);
						ajaxResponse.setResponse(500, "server error2");
					}
		
				}
				else	// 본인 글이 아닌 경우
				{
					ajaxResponse.setResponse(403, "server error");
				}
			}
			else
			{
				ajaxResponse.setResponse(404, "not found");
			}
		}
		else
		{
			ajaxResponse.setResponse(400, "bad request");
		}
		
		return ajaxResponse;
	}

	//질문 등록 화면
	@RequestMapping(value="/qna/writeForm")
	public String writeForm(ModelMap model, HttpServletRequest request, HttpServletResponse response)
	{
		// 쿠키값
		String sessionUserId = (String)request.getSession().getAttribute(AUTH_SESSION_NAME);
		// 조회값
		String searchValue = HttpUtil.get(request, "searchValue");
		// 현재 페이지
		long curPage = HttpUtil.get(request, "curPage", (long)0);
		
		model.addAttribute("searchValue", searchValue);
		model.addAttribute("curPage", curPage);
		
		// 사용자정보 조회
		User user = userService.userSelect(sessionUserId);
		
		model.addAttribute("user", user);
		
		return "/qna/writeForm";
	}
	
	//질문글 등록(ajax 통신)
	@RequestMapping(value="/qna/writeProc", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> writeProc(MultipartHttpServletRequest request, HttpServletResponse response)
	{
		Response<Object> ajaxResponse = new Response<Object>();
		
		String sessionUserId = (String)request.getSession().getAttribute(AUTH_SESSION_NAME);
		String qnaTitle = HttpUtil.get(request, "qnaTitle", "");
		String qnaContent = HttpUtil.get(request, "qnaContent", "");
		
		if(!StringUtil.isEmpty(qnaTitle) && !StringUtil.isEmpty(qnaContent))
		{
			Qna qna = new Qna();
			
			qna.setUserId(sessionUserId);
			qna.setQnaTitle(qnaTitle);
			qna.setQnaContent(qnaContent);
			
			try
			{
				if(qnaService.qnaInsert(qna) > 0)
				{
					ajaxResponse.setResponse(0, "success");
				}
				else
				{
					ajaxResponse.setResponse(500, "internal server error");
				}
			}
			catch(Exception e)
			{
				logger.error("[FreeBoardService]writeProc Exception", e);
				ajaxResponse.setResponse(500, "internal server error2");
			}
		}
		
		return ajaxResponse;
	}
}














