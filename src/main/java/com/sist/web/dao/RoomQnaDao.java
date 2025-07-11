package com.sist.web.dao;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.sist.web.model.RoomQna;

@Repository("roomQnaDao")
public interface RoomQnaDao 
{
	//QNA 리스트
	public List<RoomQna> qnaList(RoomQna roomQna);
	
	//QNA 총 갯수
	public int qnaListCount(int roomSeq);
	
	//QNA 등록
	public int qnaInsert(RoomQna roomQna);
	
	//QNA 조회
	public RoomQna qnaSelect(int roomQnaSeq);
	
	//QNA 수정
	public int qnaUpdate(RoomQna roomQna);
	
	//QNA 삭제
	public int qnaDelete(int roomQnaSeq);

	
}
