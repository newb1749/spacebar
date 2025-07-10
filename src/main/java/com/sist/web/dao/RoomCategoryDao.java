package com.sist.web.dao;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.sist.web.model.RoomCategory;

@Repository("roomCategoryDao")
public interface RoomCategoryDao {
	//카테고리 가져오기
	public List<RoomCategory> categoryList();
}
