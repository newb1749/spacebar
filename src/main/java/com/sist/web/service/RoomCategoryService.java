package com.sist.web.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sist.web.dao.RoomCategoryDao;
import com.sist.web.model.RoomCategory;

@Service("roomCategoryService")
public class RoomCategoryService {
	@Autowired
	private RoomCategoryDao roomCategoryDao;
	
	public List<RoomCategory> categoryList()
	{
		return roomCategoryDao.categoryList();
	}
}
