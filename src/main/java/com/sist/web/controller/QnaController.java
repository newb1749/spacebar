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

import com.sist.common.util.StringUtil;
import com.sist.web.model.FreeBoard;
import com.sist.web.model.Paging;
import com.sist.web.model.Qna;
import com.sist.web.service.QnaService;
import com.sist.web.util.HttpUtil;

@Controller("qnaController")
public class QnaController {
	
	private static Logger logger = LoggerFactory.getLogger(QnaController.class);
	
	@Value("#{env['auth.session.name']}")
    private String AUTH_SESSION_NAME;
	
	@Autowired
	private QnaService qnaService;
	
	private static final int LIST_COUNT = 5; 	// 한 페이지의 게시물 수
	private static final int PAGE_COUNT = 3;	// 페이징 수
	
	//게시판 리스트
	@RequestMapping(value="/qna/list")
	public String list(ModelMap model, HttpServletRequest request, HttpServletResponse response)
	{	
		//현재 페이지
		long curPage = HttpUtil.get(request, "curPage", (long)1);
		
		//게시물 리스트
		List<Qna> list = null;
		//조회 객체
		Qna qna = new Qna();
		//총 게시물 수
		long totalCount = 0;
		//페이징 객체
		Paging paging = null;
		
		totalCount = qnaService.qnaListCount(qna);
		
		return "/qna/list";
	}
}
