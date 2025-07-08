package com.sist.web.dao;

import org.springframework.stereotype.Repository;

import com.sist.web.model.RoomQnaComment;

@Repository("roomQnaComment")
public interface RoomQnaCommentDao 
{
	//Q&A 답글 조회
	public RoomQnaComment roomQnaCommontSelect(int roomQnaSeq);
	
	//Q&A 답글 등록
	public int qnaCommentInsert(RoomQnaComment roomQnaComment);
	
	//Q&A 답글 수정
	public int qnaCommentUpdate(RoomQnaComment roomQnaCmtSeq);
	
	//Q&A 답글 삭제
	public int qnaCommentDelete(int roomQnaSeq);
}
