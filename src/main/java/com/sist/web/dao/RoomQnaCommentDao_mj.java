package com.sist.web.dao;

import org.springframework.stereotype.Repository;

import com.sist.web.model.RoomQnaComment_mj;

@Repository("roomQnaComment_mj")
public interface RoomQnaCommentDao_mj 
{
	//Q&A 답글 조회
	public RoomQnaComment_mj roomQnaCommontSelect(int roomQnaSeq);
	
	//Q&A 답글 등록
	public int qnaCommentInsert(RoomQnaComment_mj roomQnaComment);
	
	//Q&A 답글 수정
	public int qnaCommentUpdate(RoomQnaComment_mj roomQnaCmtSeq);
}
