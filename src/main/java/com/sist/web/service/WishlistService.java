package com.sist.web.service;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.sist.web.dao.RoomDao;
import com.sist.web.dao.WishlistDao;
import com.sist.web.model.Room;
import com.sist.web.model.Wishlist;

@Service("wishlistService")
public class WishlistService {
	private static Logger logger = LoggerFactory.getLogger(WishlistService.class);

	@Value("#{env['upload.save.dir']}")
	private String UPLOAD_SAVE_DIR;
	
	@Autowired
	private WishlistDao wishlistDao;
	
	@Autowired
	private RoomDao roomDao;
	
	//위시리스트 등록
	public int insertWish(Wishlist roomWishlist)
	{
		int count = 0;
		
		try
		{
			count = wishlistDao.insertWish(roomWishlist);
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
			count = wishlistDao.countWish(roomSeq, userId);
		}
		catch(Exception e)
		{
			logger.error("[RoomWishlistService] countWish Exception : ", e);
		}
		
		return count;
	}
	
	//위시리스트 조회
	public List<Wishlist> wishlist(Wishlist wishlist)
	{
		List<Wishlist> list = null;
		
		try
		{
			list = wishlistDao.wishlist(wishlist);
		}
		catch(Exception e)
		{
			logger.error("[RoomWishlistService] wishlist Exception : ", e);
		}
		
		return list;
	}
	
	//위시리스트 개수
	public int wishTotalCount(Wishlist wishlist)
	{
		int count = 0;
		
		try
		{
			count = wishlistDao.wishTotalCount(wishlist);
		}
		catch(Exception e)
		{
			logger.error("[RoomWishlistService] wishlist Exception : ", e);
		}
		
		return count;
	}
	
	//위시리스트 삭제
	public int wishRemove(@Param("roomSeq") int roomSeq, @Param("userId") String userId)
	{
		int count = 0;
			
		try
		{
			count = wishlistDao.wishRemove(roomSeq, userId);
		}
		catch(Exception e)
		{
			logger.error("[RoomWishlistService] wishRemove Exception : ", e);
		}
		
		return count;
	}
}
