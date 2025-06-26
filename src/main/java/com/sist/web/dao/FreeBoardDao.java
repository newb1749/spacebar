package com.sist.web.dao;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.sist.web.model.FreeBoard;
import com.sist.web.model.FreeBoardComment;

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
	
	//게시물 등록
	public int boardInsert(FreeBoard freeBoard);
	
	//댓글 리스조회
	public List<FreeBoardComment> commentList(long freeBoardSeq);
	
	//댓글 시퀀스 다음 값 (PK, 그룹번호용)
    long nextCommentSeq();
	
    //댓글 order_no 조정 (기존 댓글들 order_no +1 처리)
    int boardGroupOrderUpdate(FreeBoardComment comment);
    
    //댓글 등록
    int commentInsert(FreeBoardComment comment);
    
    // 댓글 단건 조회 (부모 댓글 조회용)
    FreeBoardComment commentSelect(long freeBoardCmtSeq);
    
    // 최상위 댓글 등록 후 GROUP_SEQ 업데이트
    int updateGroupSeq(FreeBoardComment comment);
}
