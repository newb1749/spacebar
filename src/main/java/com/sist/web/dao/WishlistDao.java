package com.sist.web.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import com.sist.web.model.Wishlist;

@Repository("wishlistDao")
public interface WishlistDao {
	//위시리스트 등록
	public int insertWish(Wishlist roomWishlist);
	
	//위시리스트 중복 체크
	public int countWish(@Param("roomSeq") int roomSeq, @Param("userId") String userId);

	//위시리스트 조회
	public List<Wishlist> wishlist(Wishlist wishlist);
	
	//위시리스트 개수
	public int wishTotalCount(Wishlist wishlist);
	
	//위시리스트 삭제
	public int wishRemove(@Param("roomSeq") int roomSeq, @Param("userId") String userId);
}
