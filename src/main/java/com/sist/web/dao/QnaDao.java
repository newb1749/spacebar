package com.sist.web.dao;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.sist.web.model.Qna;
import com.sist.web.model.QnaComment;

@Repository("qnaDao")
public interface QnaDao {
	//총 qna 수
	public int qnaListCount(Qna qna);
	
	public List<Qna> qnaList(Qna qna);

	public Qna qnaSelect(long qnaSeq);
	
	public QnaComment qnaCommentSelect(long qnaSeq);
	
	public int qnaCommentDelete(long qnaSeq);
	
	public int qnaDelete(long qnaSeq);
	
	public int qnaInsert(Qna qna);
}
