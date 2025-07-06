package com.sist.web.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sist.web.dao.CartDao;
import com.sist.web.model.Cart;

@Service("cartService")
public class CartService {
	@Autowired
    private CartDao cartDao;

    public int insertCart(Cart cart) {
        return cartDao.insertCart(cart);
    }

    public List<Cart> cartList(String userId) {
        return cartDao.cartList(userId);
    }

    public int deleteCart(int cartSeq) {
        return cartDao.deleteCart(cartSeq);
    }
}
