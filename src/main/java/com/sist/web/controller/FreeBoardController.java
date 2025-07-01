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

import com.sist.common.model.FileData;
import com.sist.common.util.StringUtil;
import com.sist.web.model.FreeBoard;
import com.sist.web.model.FreeBoardComment;
import com.sist.web.model.Paging;
import com.sist.web.model.Response;
import com.sist.web.model.User;
//import com.sist.web.model.User;
import com.sist.web.service.FreeBoardService;
import com.sist.web.service.UserService;
import com.sist.web.util.CookieUtil;
import com.sist.web.util.HttpUtil;

@Controller("freeBoardController")
public class FreeBoardController {
	
	private static Logger logger = LoggerFactory.getLogger(FreeBoardController.class);
	
	@Value("#{env['auth.cookie.name']}")
	private String AUTH_COOKIE_NAME;
	
	@Value("#{env['upload.save.dir']}") // env.xml에 있음
	private String UPLOAD_SAVE_DIR;
	
	@Value("#{env['upload.image.detail']}")
	private String UPLOAD_IMAGE_DETAIL;
	
	@Autowired
	private FreeBoardService freeBoardService;
	
	@Autowired
	private UserService userService;
	
	public static final String AUTH_SESSION_NAME = "sessionUserId";
	
	private static final int LIST_COUNT = 5; 	// 한 페이지의 게시물 수
	private static final int PAGE_COUNT = 3;	// 페이징 수
	
	//게시판 리스트
	@RequestMapping(value="/board/list")
	public String list(ModelMap model, HttpServletRequest request, HttpServletResponse response)
	{	
		//조회항목(1:작성자, 2:제목, 3:내용, 4:제목+내용)
		String searchType = HttpUtil.get(request, "searchType", "");
		//조회값
		String searchValue = HttpUtil.get(request, "searchValue", "");
		//현재 페이지
		long curPage = HttpUtil.get(request, "curPage", (long)1);
		
		//게시물 리스트
		List<FreeBoard> list = null;
		//조회 객체
		FreeBoard search = new FreeBoard();
		//총 게시물 수
		long totalCount = 0;
		//페이징 객체
		Paging paging = null;
		
		int cmtCount = 0;
		
	
		if(!StringUtil.isEmpty(searchType) && !StringUtil.isEmpty(searchValue))
		{
			search.setSearchType(searchType);
			search.setSearchValue(searchValue);
		}
		else
		{
			searchType = "";
			searchValue = "";
		}
		
		totalCount = freeBoardService.boardListCount(search);

		if(totalCount > 0)
		{
			paging = new Paging("/board/list", totalCount, LIST_COUNT, PAGE_COUNT, curPage, "curPage");
			
			search.setStartRow(paging.getStartRow());
			search.setEndRow(paging.getEndRow());
			
			list = freeBoardService.boardList(search);
		}
		
		
		cmtCount = freeBoardService.boardAnswersCount(search.getFreeBoardSeq());
		
		model.addAttribute("cmtCount", cmtCount);
		model.addAttribute("list", list);
		model.addAttribute("searchType", searchType);
		model.addAttribute("searchValue", searchValue);
		model.addAttribute("curPage", curPage);
		model.addAttribute("paging", paging);
	
		return "/board/list";
	}
	
	//게시판 상세 조회(댓글도 같이 조회되도록)
	@RequestMapping(value="/board/view")
	public String view(ModelMap model, HttpServletRequest request, HttpServletResponse response)
	{
		long freeBoardSeq = HttpUtil.get(request, "freeBoardSeq", (long)0);
		String searchType = HttpUtil.get(request, "searchType", "");
		String searchValue = HttpUtil.get(request, "searchValue", "");
		long curPage = HttpUtil.get(request, "curPage", (long)1);
		
		String boardMe = "N";
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		
		FreeBoard freeBoard = null;
		
		List<FreeBoardComment> freeBoardComment = null;
		
		if(freeBoardSeq > 0)
		{
			freeBoard = freeBoardService.boardView(freeBoardSeq, cookieUserId);
			freeBoardComment = freeBoardService.commentList(freeBoardSeq);
			
			if(freeBoard != null && StringUtil.equals(freeBoard.getUserId(), cookieUserId))
			{
				logger.debug("userId : " + freeBoard.getUserId());
				logger.debug("cookieUserId : " + cookieUserId);
				boardMe = "Y";
			}
		}
		
		
		model.addAttribute("freeBoardComment", freeBoardComment);
		model.addAttribute("freeBoardSeq", freeBoardSeq);
		model.addAttribute("searchType", searchType);
		model.addAttribute("searchValue", searchValue);
		model.addAttribute("curPage", curPage);
		model.addAttribute("freeBoard", freeBoard);
		model.addAttribute("boardMe", boardMe);

		return "/board/view";
	}
	
	//게시판 등록 화면
	@RequestMapping(value="/board/writeForm")
	public String writeForm(ModelMap model, HttpServletRequest request, HttpServletResponse response)
	{
		// 쿠키값
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		// 조회항목
		String searchType = HttpUtil.get(request, "searchType");
		// 조회값
		String searchValue = HttpUtil.get(request, "searchValue");
		// 현재 페이지
		long curPage = HttpUtil.get(request, "curPage", (long)0);
		
		model.addAttribute("searchType", searchType);
		model.addAttribute("searchValue", searchValue);
		model.addAttribute("curPage", curPage);
		
		// 사용자정보 조회
		User user = userService.userSelect(cookieUserId);
		
		model.addAttribute("user", user);
		
		return "/board/writeForm";
	}
	
	//게시물 등록(ajax 통신)
	@RequestMapping(value="/board/writeProc", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> writeProc(MultipartHttpServletRequest request, HttpServletResponse response)
	{
		Response<Object> ajaxResponse = new Response<Object>();
		
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		String freeBoardTitle = HttpUtil.get(request, "freeBoardTitle", "");
		String freeBoardContent = HttpUtil.get(request, "freeBoardContent", "");
		
		if(!StringUtil.isEmpty(freeBoardTitle) && !StringUtil.isEmpty(freeBoardContent))
		{
			FreeBoard freeBoard = new FreeBoard();
			
			freeBoard.setUserId(cookieUserId);
			freeBoard.setFreeBoardTitle(freeBoardTitle);
			freeBoard.setFreeBoardContent(freeBoardContent);
			
			try
			{
				if(freeBoardService.boardInsert(freeBoard) > 0)
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
	
	//댓글 등록
	@RequestMapping(value = "/board/commentInsert", method = RequestMethod.POST)
	@ResponseBody
	public Response<Object> commentInsert(HttpServletRequest request) {
	    Response<Object> ajaxResponse = new Response<Object>();

	    String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
	    long freeBoardSeq = HttpUtil.get(request, "freeBoardSeq", (long)0);
	    long parentCmtSeq = HttpUtil.get(request, "parentCmtSeq", (long)0); // 부모댓글 seq (0이면 최상위)
	    String content = HttpUtil.get(request, "freeBoardCmtContent", "");
	    
	    if (cookieUserId == null || cookieUserId.isEmpty()) {
	        ajaxResponse.setResponse(401, "로그인이 필요합니다.");
	        return ajaxResponse;
	    }
	    if (freeBoardSeq <= 0) {
	        ajaxResponse.setResponse(400, "잘못된 게시물 정보입니다.");
	        return ajaxResponse;
	    }
	    if (content == null || content.trim().isEmpty()) {
	        ajaxResponse.setResponse(400, "댓글 내용을 입력하세요.");
	        return ajaxResponse;
	    }

	    try {
	        FreeBoardComment comment = new FreeBoardComment();
	        comment.setFreeBoardSeq(freeBoardSeq);
	        comment.setUserId(cookieUserId);
	        comment.setFreeBoardCmtContent(content.trim());
	        comment.setFreeBoardCmtStat("Y"); // 보통 정상 상태
	        comment.setParentCmtSeq(parentCmtSeq);
	        
	        logger.debug("groupSeq1 : " + comment.getGroupSeq());

	        if (parentCmtSeq == 0) {
	            // 최상위 댓글인 경우
	            comment.setDepth(0);
	            // groupSeq와 orderNo는 서비스에서 처리 (새로운 댓글 시퀀스 기준으로 그룹 생성)
	            comment.setGroupSeq(0);
	            comment.setOrderNo(0);
	        } else {
	            // 부모 댓글 정보 가져오기
	            FreeBoardComment parentComment = freeBoardService.getCommentBySeq(parentCmtSeq);
	            if (parentComment == null) {
	                ajaxResponse.setResponse(400, "부모 댓글이 존재하지 않습니다.");
	                return ajaxResponse;
	            }
	            comment.setDepth(parentComment.getDepth() + 1);
	            comment.setGroupSeq(parentComment.getGroupSeq());
	            comment.setOrderNo(parentComment.getOrderNo() + 1);
	            
	            logger.debug("groupSeq2 : " + comment.getGroupSeq());

	            // orderNo 업데이트 (같은 그룹 내 순서 밀어내기)
	            freeBoardService.boardGroupOrderUpdate(comment);
	            
	            logger.debug("groupSeq3 : " + comment.getGroupSeq());
	        }

	        // 댓글 등록
	        int result = freeBoardService.commentInsert(comment);
	        if (result > 0) {
	            // 부모가 없으면 그룹 번호를 새로 등록된 댓글 seq로 셋팅
	            if (parentCmtSeq == 0) {
	                comment.setGroupSeq(comment.getFreeBoardCmtSeq());
	                freeBoardService.updateGroupSeq(comment);
	            }
	            ajaxResponse.setResponse(0, "success");
	        } else {
	        	
	        	logger.debug("groupSeq4 : " + comment.getGroupSeq());
	            ajaxResponse.setResponse(500, "댓글 등록 실패");
	        }
	    } catch (Exception e) {
	        logger.error("[FreeBoardController] commentInsert error", e);
	        ajaxResponse.setResponse(500, "서버 오류 발생");
	    }

	    return ajaxResponse;
	}

	//게시판 삭제(삭제시 댓글도 삭제)
	@RequestMapping(value="/board/delete", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> delete(HttpServletRequest request, HttpServletResponse response)
	{
		Response<Object> ajaxResponse = new Response<Object>();
		
		long freeBoardSeq = HttpUtil.get(request, "freeBoardSeq", (long)0);
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		
		if(freeBoardSeq > 0)
		{
			FreeBoard freeBoard = freeBoardService.boardView(freeBoardSeq, cookieUserId);
			
			if(freeBoard != null)
			{
				if(StringUtil.equals(cookieUserId, freeBoard.getUserId()))
				{
					try
					{
						//게시판 삭제
						if(freeBoardService.boardDelete(freeBoardSeq) > 0)
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
						logger.error("[FreeBoardController] /board/delete  Exception : ", e);
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
	
	//댓글 삭제
	@RequestMapping(value="/board/cmtDelete", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> cmtDelete(HttpServletRequest request, HttpServletResponse response)
	{
		Response<Object> ajaxResponse = new Response<Object>();
		
		long freeBoardCmtSeq = HttpUtil.get(request, "freeBoardCmtSeq", (long)0);
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		
		if(freeBoardCmtSeq > 0)
		{
			FreeBoardComment freeBoardComment = freeBoardService.getCommentBySeq(freeBoardCmtSeq);
			
			if(freeBoardComment != null)
			{
				if(StringUtil.equals(cookieUserId, freeBoardComment.getUserId()))
				{
					try
					{
						//게시판 삭제
						if(freeBoardService.commentDelete(freeBoardCmtSeq) > 0)
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
						logger.error("[FreeBoardController] /board/delete  Exception : ", e);
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
	
	//게시글 수정화면
	@RequestMapping(value="/board/updateForm")
	public String updateForm(ModelMap model ,HttpServletRequest request, HttpServletResponse response)
	{
		// 쿠키값
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		// 게시물번호
		long freeBoardSeq = HttpUtil.get(request, "freeBoardSeq", (long)0);
		// 조회항목
		String searchType = HttpUtil.get(request, "searchType", "");
		// 조회값
		String searchValue = HttpUtil.get(request, "searchValue", "");
		// 현재페이지
		long curPage = HttpUtil.get(request, "curPage", (long)1);
		
		FreeBoard freeBoard = null;
		
		if(freeBoardSeq > 0)
		{
			freeBoard = freeBoardService.boardView(freeBoardSeq, cookieUserId);
			
			if(freeBoard != null)
			{
				if(!StringUtil.equals(freeBoard.getUserId(), cookieUserId))
				{
					freeBoard = null;
				}
			}
		}
		
		model.addAttribute("searchType", searchType);
		model.addAttribute("searchValue", searchValue);
		model.addAttribute("curPage", curPage);
		model.addAttribute("freeBoard", freeBoard);
				
		return "/board/updateForm";
	}
	
	//게시글 수정
	@RequestMapping(value="/board/updateProc", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> updateProc(MultipartHttpServletRequest request, HttpServletResponse response)
	{
		Response<Object> ajaxResponse = new Response<Object>();
		
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		long freeBoardSeq = HttpUtil.get(request, "freeBoardSeq", (long)0);
		String freeBoardTitle = HttpUtil.get(request, "freeBoardTitle", "");
		String freeBoardContent = HttpUtil.get(request, "freeBoardContent", "");
		
		if(freeBoardSeq > 0 && !StringUtil.isEmpty(freeBoardTitle) && !StringUtil.isEmpty(freeBoardContent))
		{
			FreeBoard freeBoard = freeBoardService.boardView(freeBoardSeq, cookieUserId);
			
			if(freeBoard != null)
			{
				freeBoard.setFreeBoardTitle(freeBoardTitle);
				freeBoard.setFreeBoardContent(freeBoardContent);
				try
				{
					if(freeBoardService.boardUpdate(freeBoard) > 0)
					{
						ajaxResponse.setResponse(0, "success");
					}
					else
					{
						ajaxResponse.setResponse(500, "internal server error2");
					}
				}
				catch(Exception e)
				{
					logger.error("[FreeBoardService] updateProc Exception : ", e);
					ajaxResponse.setResponse(500, "internal server error1");
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
	
	//댓글 수정
	@RequestMapping(value="/board/commentUpdate", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> commentUpdate(HttpServletRequest request, HttpServletResponse response)
	{
	    Response<Object> ajaxResponse = new Response<Object>();

	    long freeBoardCmtSeq = HttpUtil.get(request, "freeBoardCmtSeq", (long)0);
	    String content = HttpUtil.get(request, "freeBoardCmtContent", "");
	    String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);

	    if(freeBoardCmtSeq > 0 && !StringUtil.isEmpty(content))
	    {
	        FreeBoardComment comment = freeBoardService.getCommentBySeq(freeBoardCmtSeq);

	        if(comment != null)
	        {
	            // 댓글 작성자 본인 확인
	            if(StringUtil.equals(comment.getUserId(), cookieUserId))
	            {
	                comment.setFreeBoardCmtContent(content.trim());
	                
	                try
	                {
	                    if(freeBoardService.commentUpdate(comment) > 0)
	                    {
	                        ajaxResponse.setResponse(0, "success");
	                    }
	                    else
	                    {
	                        ajaxResponse.setResponse(500, "댓글 수정 실패");
	                    }
	                }
	                catch(Exception e)
	                {
	                    logger.error("[FreeBoardController] commentUpdate Exception : ", e);
	                    ajaxResponse.setResponse(500, "서버 오류 발생");
	                }
	            }
	            else
	            {
	                ajaxResponse.setResponse(403, "권한이 없습니다.");
	            }
	        }
	        else
	        {
	            ajaxResponse.setResponse(404, "댓글을 찾을 수 없습니다.");
	        }
	    }
	    else
	    {
	        ajaxResponse.setResponse(400, "잘못된 요청입니다.");
	    }

	    return ajaxResponse;
	}

}
