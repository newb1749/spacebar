package com.sist.web.dao;

import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import com.sist.web.model.Wishlist;

@Repository("roomWishlistDao")
public interface WishlistDao {
	//위시리스트 등록
	public int insertWish(Wishlist roomWishlist);
	
	//위시리스트 중복 체크
	public int countWish(@Param("roomSeq") int roomSeq, @Param("userId") String userId);
}
