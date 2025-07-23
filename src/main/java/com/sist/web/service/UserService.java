package com.sist.web.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.sist.web.dao.UserDao;
import com.sist.web.model.User;

@Service("userService")
public class UserService 
{
	private static Logger logger = LoggerFactory.getLogger(UserService.class);
	
	@Autowired
	private UserDao userDao;
	
	@Value("{env['upload.save.dir']}")
	private String UPLOAD_SAVE_DIR;
	
	//회원 조회
	public User userSelect(String userId)
	{
		User user = null;
		
		try
		{
			user = userDao.userSelect(userId);
		}
		catch(Exception e)
		{
			logger.error("[UserService] userSelect Exception",e);
		}
		
		return user;
	}
	
	//회원 조회
	public User hostSelect(int roomSeq)
	{
		User host = null;
		
		try
		{
			host = userDao.hostSelect(roomSeq);
		}
		catch(Exception e)
		{
			logger.error("[UserService] hostSelect Exception",e);
		}
		
		return host;
	}
	
	//닉네임 
	public User nickNameSelect(String nickName)
	{
		User user = null;
		
		try
		{
			user = userDao.nickNameSelect(nickName);
		}
		catch(Exception e)
		{
			logger.error("[UserService] nickNameSelect Exception",e);
		}
		
		return user;
	}
	
	//회원 등록
	public int userInsert(User user)
	{
		int count = 0;

		try
		{
			count = userDao.userInsert(user);
		}
		catch(Exception e)
		{
			logger.error("[UserService] userInsert Exception",e);
		}
		
		return count;
	}
	
	//회원 정보 수정
	public int userUpdate(User user)
	{
		int count = 0;
		
		try
		{
			count = userDao.userUpdate(user);
		}
		catch(Exception e)
		{
			logger.error("[UserService] userUpdate Exception",e);
		}
		
		return count;
	}
	
	//회원 탈퇴
	public int userDelete(User user)
	{
		int count = 0;
		
		try
		{
			count = userDao.userDelete(user);
		}
		catch(Exception e)
		{
			logger.error("[UserService] userDelete Exception",e);
		}
		
		return count;
	}
}