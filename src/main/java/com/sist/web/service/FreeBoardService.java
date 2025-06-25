package com.sist.web.service;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.sist.common.util.StringUtil;
import com.sist.web.dao.FreeBoardDao;
import com.sist.web.model.FreeBoard;

@Service("freeBoardService")
public class FreeBoardService {
	private static Logger logger = LoggerFactory.getLogger(FreeBoardService.class);
	
	@Value("#{env['upload.save.dir']}")
	private String UPLOAD_SAVE_DIR;
	
	@Autowired
	private FreeBoardDao freeBoardDao;
	
	//게시물 리스트
	public List<FreeBoard> boardList(FreeBoard freeBoard)
	{
		List<FreeBoard> list = null;
		
		try
		{
			list = freeBoardDao.boardList(freeBoard);
		}
		catch(Exception e)
		{
			logger.error("[FreeBoardService] boardList Exception : ", e);
		}
		
		return list;
	}
	
	//총 게시물 수
	public int boardListCount(FreeBoard freeBoard)
	{
		int count = 0;
		
		try
		{
			count = freeBoardDao.boardListCount(freeBoard);
			logger.debug("ttt : " + count);
		}
		catch(Exception e)
		{
			logger.error("[FreeBoardService] boardListCount : ", e);
		}
		
		return count;
	}
	
	//게시물 상세 조회
	public FreeBoard boardView(long freeBoardSeq, String cookieUserId)
	{
		FreeBoard freeBoard = null;
		
		try
		{
			freeBoard = freeBoardDao.boardSelect(freeBoardSeq);
			
			if(freeBoard != null)
			{
				if(cookieUserId != null && !StringUtil.equals(freeBoard.getUserId(), cookieUserId))
				{
					//조회수 증가
					freeBoardDao.boardCntPlus(freeBoardSeq);	
				}
			}
		}
		catch(Exception e)
		{
			logger.error("[FreeBoardService] boardView Exception ", e);
		}
		
		return freeBoard;
	}
}
