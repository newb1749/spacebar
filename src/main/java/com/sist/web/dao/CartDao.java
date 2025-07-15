package com.sist.web.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import com.sist.web.model.Cart;

@Repository("cartDao")
public interface CartDao {
	//장바구니 넣기
	public int insertCart(Cart cart);
	//장바구니 리스트
	public List<Cart> cartList(String userId);
	//장바구니 삭제
	public int deleteCart(int cartSeq);
	
	public List<Cart> getCartsBySeqs(
	        @Param("cartSeqs") List<Integer> cartSeqs,
	        @Param("userId")   String userId
	    );
	public	int deleteCarts(
	        @Param("cartSeqs") List<Integer> cartSeqs,
	        @Param("userId")   String userId
	    );
}
