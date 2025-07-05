package com.sist.web.dao;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.sist.web.model.RoomQna_mj;

@Repository("roomQnaDao_mj")
public interface RoomQnaDao_mj 
{
	//QNA 리스트
	public List<RoomQna_mj> qnaList(RoomQna_mj roomQna);
	
	//QNA 총 갯수
	public int qnaListCount(int roomSeq);
	
	//QNA 등록
	public int qnaInsert(RoomQna_mj roomQna);
	
	//QNA 조회
	public RoomQna_mj qnaSelect(int roomQnaSeq);
	
	//QNA 수정
	public int qnaUpdate(RoomQna_mj roomQna);
	
	//QNA 삭제
	public int qnaDelete(int roomSeq);
}
