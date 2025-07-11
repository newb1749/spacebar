package com.sist.web.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sist.web.dao.QnaDao;
import com.sist.web.model.Qna;

@Service("qnaService")
public class QnaService {
	private static Logger logger = LoggerFactory.getLogger(QnaService.class);
	
	@Autowired
	private QnaDao qnaDao;
	
	//총 qna 수
	public int qnaListCount(Qna qna)
	{
		int count = 0;
		
		try
		{
			count = qnaDao.qnaListCount(qna);
			logger.debug("QnaCount : " + count);
		}
		catch(Exception e) 
		{
			logger.error("[QnaService]qnaListCount : ", e);
		}
		
		return count;
	}
}
