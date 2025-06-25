package com.sist.web.dao;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.sist.web.model.FreeBoard;

@Repository("freeBoardDao")
public interface FreeBoardDao {
	//게시물 리스트
	public List<FreeBoard> boardList(FreeBoard freeBoard); 
	
	//총 게시물 수
	public int boardListCount(FreeBoard freeBoard);
	
	//게시물 조회
	public FreeBoard boardSelect(long freeBoardSeq);
	
	//게시물 조회수 증가
	public int boardCntPlus(long freeBoardSeq);
	
	//본인게시물 조회수 증가안되게구현
	public FreeBoard boardView(long freeBoardSeq, String cookieUserId);
	
	
}
