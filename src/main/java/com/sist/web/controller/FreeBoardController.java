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

import com.sist.common.util.StringUtil;
import com.sist.web.model.FreeBoard;
import com.sist.web.model.Paging;
import com.sist.web.service.FreeBoardService;
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
		
		logger.debug("searchType1: {}", search.getSearchType());
		logger.debug("searchValue1: {}", search.getSearchValue());
		logger.debug("startRow1: {}", search.getStartRow());
		logger.debug("endRow1: {}", search.getEndRow());
		logger.debug("search1: {}", search);
		
	
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
		
		//totalCount = freeBoardService.boardListCount(search);
		totalCount = freeBoardService.boardListCount2();
		
		logger.debug("==================================");
		logger.debug("totalcCount  : " + totalCount);
		logger.debug("==================================");
		
		logger.debug("searchType2: {}", search.getSearchType());
		logger.debug("searchValue2: {}", search.getSearchValue());
		logger.debug("startRow2: {}", search.getStartRow());
		logger.debug("endRow2: {}", search.getEndRow());
		logger.debug("search2: {}", search);
		logger.debug("totalCount: {}", totalCount);
		
		if(totalCount > 0)
		{
			paging = new Paging("/board/list", totalCount, LIST_COUNT, PAGE_COUNT, curPage, "curPage");
			
			search.setStartRow(paging.getStartRow());
			search.setEndRow(paging.getEndRow());
			
			list = freeBoardService.boardList(search);
			
			logger.debug("searchType3: {}", search.getSearchType());
			logger.debug("searchValue:3 {}", search.getSearchValue());
			logger.debug("startRow:3 {}", search.getStartRow());
			logger.debug("endRow3: {}", search.getEndRow());
		}
		
		logger.debug("searchType4: {}", search.getSearchType());
		logger.debug("searchValue4: {}", search.getSearchValue());
		logger.debug("startRow4: {}", search.getStartRow());
		logger.debug("endRow4: {}", search.getEndRow());
		logger.debug("search4: {}", search);
		
		model.addAttribute("list", list);
		model.addAttribute("searchType", searchType);
		model.addAttribute("searchValue", searchValue);
		model.addAttribute("curPage", curPage);
		model.addAttribute("paging", paging);
		
		logger.debug("searchType5: {}", search.getSearchType());
		logger.debug("searchValue5: {}", search.getSearchValue());
		logger.debug("startRow5: {}", search.getStartRow());
		logger.debug("endRow5: {}", search.getEndRow());
		
		
		return "/board/list";
	}
	
	
}
