package com.sist.web.service;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.sist.web.dao.QnaDao;
import com.sist.web.model.FreeBoard;
import com.sist.web.model.Qna;
import com.sist.web.model.QnaComment;

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
	
	public List<Qna> qnaList(Qna qna)
	{
		List<Qna> list = null;
		
		try
		{
			list = qnaDao.qnaList(qna);
		}
		catch(Exception e)
		{
			logger.error("[QnaService]qnaList : ", e);
		}
		
		return list;
	}
	
	public Qna qnaSelect(long qnaSeq)
	{
		Qna qna = null;
		
		try
		{
			qna = qnaDao.qnaSelect(qnaSeq);
		}
		catch(Exception e)
		{
			logger.error("[QnaService]qnaView : ", e);
		}
		
		return qna;
	}

	public QnaComment qnaCommentSelect(long qnaSeq)
	{
		QnaComment qnaComment = null;
		
		try
		{
			qnaComment = qnaDao.qnaCommentSelect(qnaSeq);
		}
		catch(Exception e)
		{
			logger.error("[QnaService]qnaSelect : ", e);
		}
		
		return qnaComment;
	}
	
	//qna게시글, 댓글삭제
	@Transactional
	public int qnaDelete(long qnaSeq) throws Exception
	{
		int count = 0;
		
		try
		{
			qnaDao.qnaCommentDelete(qnaSeq);
			count = qnaDao.qnaDelete(qnaSeq);
		}
		catch(Exception e)
		{
			logger.error("[QnaService]qnaDelete : ", e);
		}
		
		return count;
	}
	
	//게시물 등록
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
	public int qnaInsert(Qna qna) throws Exception
	{
		int count = 0;
		
		try
		{
			count = qnaDao.qnaInsert(qna);
		}
		catch(Exception e)
		{
			logger.error("[FreeBoardService] boardInsert Exception ", e);
		}
		
		return count;
	}
	
}




















