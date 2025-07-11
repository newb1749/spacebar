package com.sist.web.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sist.web.dao.RoomQnaCommentDao;
import com.sist.web.model.RoomQnaComment;

@Service("roomQnaCommentService_mj")
public class RoomQnaCommentService 
{
	private static Logger logger = LoggerFactory.getLogger(RoomServiceJY.class);
    
	@Autowired
	private RoomQnaCommentDao roomQnaCommentDao;

	//QNA 답글 조회
	public RoomQnaComment roomQnaCommontSelect(int roomQnaSeq)
	{
		RoomQnaComment roomQnaComment = null;
		
		try
		{
			roomQnaComment = roomQnaCommentDao.roomQnaCommontSelect(roomQnaSeq);
		}
		catch(Exception e)
		{
			logger.error("[roomQnaCommentService]roomQnaCommontSelect Exception", e);
		}
		
		return roomQnaComment;
	}
	
	//Q&A 답글 등록
	public int qnaCommentInsert(RoomQnaComment roomQnaComment)
	{
		int count = 0;
		
		try
		{
			count = roomQnaCommentDao.qnaCommentInsert(roomQnaComment);
		}
		catch(Exception e)
		{
			logger.error("[roomQnaCommentService]qnaCommentInsert Exception", e);
		}
		
		return count;
	}
	
	//Q&A 답글 수정
	public int qnaCommentUpdate(RoomQnaComment roomQnaCmtSeq)
	{
		int count = 0;
		
		try
		{
			count = roomQnaCommentDao.qnaCommentUpdate(roomQnaCmtSeq);
		}
		catch(Exception e)
		{
			logger.error("[roomQnaCommentService]qnaCommentUpdate Exception", e);
		}
		
		return count;
	}
	
    //QNA 답글 삭제
  	public int qnaCommentDelete(int roomQnaCmtSeq)
  	{
  		int count = 0;
  		
    	try
    	{
    		count = roomQnaCommentDao.qnaCommentDelete(roomQnaCmtSeq);
    	}
    	catch(Exception e)
    	{
    		logger.error("[RoomService]qnaCommentDelete Exception", e);
    	}
  		
  		return count;
  	}
}
