package com.sist.web.dao;

import org.springframework.stereotype.Repository;

import com.sist.web.model.Qna;

@Repository("qnaDao")
public interface QnaDao {
	//총 qna 수
	public int qnaListCount(Qna qna);
}
