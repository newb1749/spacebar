package com.sist.web.service;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sist.web.dao.RoomQnaDao;
import com.sist.web.model.RoomQna;

@Service("roomQnaService_mj")
public class RoomQnaService_mj 
{		
	private static Logger logger = LoggerFactory.getLogger(RoomQnaService_mj.class);
	
	@Autowired
	private RoomQnaDao roomQnaDao;
	
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
    public int qnaListCount(int roomSeq)
    {
    	int count = 0;
    	
    	try
    	{
    		count = roomQnaDao.qnaListCount(roomSeq);
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
  	
    //QNA 삭제
  	public int qnaDelete(int roomSeq)
  	{
  		int count = 0;
  		
    	try
    	{
    		count = roomQnaDao.qnaDelete(roomSeq);
    	}
    	catch(Exception e)
    	{
    		logger.error("[RoomService]qnaUpdate Exception", e);
    	}
  		
  		return count;
  	}
}
