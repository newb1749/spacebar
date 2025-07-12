package com.sist.web.service;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.sist.web.dao.RoomQnaCommentDao;
import com.sist.web.dao.RoomQnaDao;
import com.sist.web.model.RoomQna;

@Service("roomQnaService_mj")
public class RoomQnaService 
{		
	private static Logger logger = LoggerFactory.getLogger(RoomQnaService.class);
	
	@Autowired
	private RoomQnaDao roomQnaDao;
	
	@Autowired
	private RoomQnaCommentDao roomQnaCommentDao;
	
    //QNA 리스트
    public List<RoomQna> qnaList(RoomQna roomQna)
    {
    	List<RoomQna> list = null;
    	
    	try
    	{
    		list = roomQnaDao.qnaList(roomQna);
    	}
    	catch(Exception e)
    	{
    		logger.error("[RoomService]qnaList Exception", e);
    	}
    	
    	return list;
    }
    
    
    //QNA 총 갯수
    public int qnaListCount(RoomQna roomQna)
    {
    	int count = 0;
    	
    	try
    	{
    		count = roomQnaDao.qnaListCount(roomQna);
    	}
    	catch(Exception e)
    	{
    		logger.error("[RoomService]qnaListCount Exception", e);
    	}
    	
    	return count;
    }
    
    //QNA 등록
    public int qnaInsert(RoomQna roomQna)
    {
    	int count = 0;
    	
    	try
    	{
    		count = roomQnaDao.qnaInsert(roomQna);
    	}
    	catch(Exception e)
    	{
    		logger.error("[RoomService]qnaInsert Exception", e);
    	}
    	
    	return count;
    }
    
	//QNA 조회
	public RoomQna qnaSelect(int roomQnaSeq) 
	{
		RoomQna roomQna = null;
    	
    	try
    	{
    		roomQna = roomQnaDao.qnaSelect(roomQnaSeq);
    	}
    	catch(Exception e)
    	{
    		logger.error("[RoomService]qnaSelect Exception", e);
    	}
    	
    	return roomQna;
	}
    
    //QNA 수정
  	public int qnaUpdate(RoomQna roomQna)
  	{
  		int count = 0;
  		
    	try
    	{
    		count = roomQnaDao.qnaUpdate(roomQna);
    	}
    	catch(Exception e)
    	{
    		logger.error("[RoomService]qnaUpdate Exception", e);
    	}
  		
  		return count;
  	}
  	
    //QNA 삭제(Q&A 답글도 같이 삭제 => sts 'N' 변경)
  	@Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
  	public int qnaDelete(int roomQnaSeq)throws Exception
  	{
  		int count = 0;
  		
  		//Q&A 답글 삭제
  		roomQnaCommentDao.qnaCommentDelete(roomQnaSeq);
  		//Q&A 삭제
  		count = roomQnaDao.qnaDelete(roomQnaSeq);
  		
  		return count;
  	}
}
