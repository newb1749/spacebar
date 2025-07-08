package com.sist.web.service;

import org.slf4j.LoggerFactory;

import java.util.List;

import org.slf4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sist.web.dao.UserDao;
import com.sist.web.model.User;

@Service("userService_ks")
public class UserService_ks {
	private static Logger logger = LoggerFactory.getLogger(UserService_ks.class);
	
	@Autowired
	private UserDao userDao;
	
	/**
	 * <pre>
	 *  사용자 목록 조회.
	 *  채팅방 기능을 위한 전체 유저 조회(본인 제외).
	 *  userId와 nickName을 통한 검색 조회
	 *  </pre>
	 * @param userId 사용자 본인
	 * @param searchKeyword 검색어(userId, nickName)
	 * @return 사용자 리스트
	 */
	public List<User> userList(String userId, String searchKeyword)
	{
		List<User> list = null;
		
		try
		{
			list = userDao.userList(userId, searchKeyword);
		}
		catch(Exception e)
		{
			logger.error("[UserService_ks] userList Exception : ", e);
		}
		
		return list;
	}
}
