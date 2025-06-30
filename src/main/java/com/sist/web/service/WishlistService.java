package com.sist.web.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.sist.web.dao.RoomDao;
import com.sist.web.dao.WishlistDao;
import com.sist.web.model.Room;
import com.sist.web.model.Wishlist;

@Service("roomWishlistService")
public class WishlistService {
	private static Logger logger = LoggerFactory.getLogger(WishlistService.class);

	@Value("#{env['upload.save.dir']}")
	private String UPLOAD_SAVE_DIR;
	
	@Autowired
	private WishlistDao roomWishlistDao;
	
	@Autowired
	private RoomDao roomDao;
	
	//위시리스트 등록
	public int insertWish(Wishlist roomWishlist)
	{
		int count = 0;
		
		try
		{
			count = roomWishlistDao.insertWish(roomWishlist);
		}
		catch(Exception e)
		{
			logger.error("[RoomWishlistService] insertWish Exception : ", e);
		}
		
		return count;
	}
	
	//위시리스트 중복 체크
	public int countWish(int roomSeq, String userId)
	{
		int count = 0;
		
		try
		{
			count = roomWishlistDao.countWish(roomSeq, userId);
		}
		catch(Exception e)
		{
			logger.error("[RoomWishlistService] countWish Exception : ", e);
		}
		
		return count;
	}
	
	
}
