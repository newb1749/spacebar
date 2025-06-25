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
	
	//test
	public int boardListCount2();
}
