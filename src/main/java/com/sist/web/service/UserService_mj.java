package com.sist.web.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.sist.common.model.FileData;
import com.sist.common.util.StringUtil;
import com.sist.web.dao.UserDao_mj;
import com.sist.web.model.User_mj;

@Service("userService_mj")
public class UserService_mj 
{
	private static Logger logger = LoggerFactory.getLogger(UserService_mj.class);
	
	@Autowired
	private UserDao_mj userDao_mj;
	
    @Value("#{env['auth.session.name']}")
    private String AUTH_SESSION_NAME;
	
	@Value("#{env['upload.profile.dir']}")
	private String UPLOAD_PROFILE_DIR;
	
	//회원 조회
	public User_mj userSelect(String userId)
	{
		User_mj user = null;
		
		try
		{
			user = userDao_mj.userSelect(userId);
		}
		catch(Exception e)
		{
			logger.error("[UserService] userSelect Exception",e);
		}
		
		return user;
	}
	
	//닉네임 
	public User_mj nickNameSelect(String nickName)
	{
		User_mj user = null;
		
		try
		{
			user = userDao_mj.nickNameSelect(nickName);
		}
		catch(Exception e)
		{
			logger.error("[UserService] nickNameSelect Exception",e);
		}
		
		return user;
	}
	
	//회원가입
	public int userInsert(User_mj user) 
	{
		int count = 0;

		try
		{
			count = userDao_mj.userInsert(user);
		}
		catch(Exception e)
		{
			logger.error("[UserService] userInsert Exception",e);
		}
		
		return count;
	}
	
	//회원 정보 수정
	public int userUpdate(User_mj user)
	{
		int count = 0;
		
		try
		{
			count = userDao_mj.userUpdate(user);
		}
		catch(Exception e)
		{
			logger.error("[UserService] userUpdate Exception",e);
		}
		
		return count;
	}
	
	//회원 탈퇴
	public int userDelete(User_mj user)
	{
		int count = 0;
		
		try
		{
			user.setUserStat("N");
			count = userDao_mj.userDelete(user);
		}
		catch(Exception e)
		{
			logger.error("[UserService] userDelete Exception",e);
		}
		
		return count;
	}
	
	//아이디 찾기
	public User_mj searchId(User_mj user)
	{
		User_mj result = null;
		
		try
		{
			result = userDao_mj.searchId(user);
		}
		catch(Exception e)
		{
			logger.error("[UserService] searchId Exception",e);
		}
		
		return result;
	}
	
	//비밀번호 찾기
	public User_mj searchPwd(User_mj user)
	{
		User_mj result = null;
		
		try
		{
			result = userDao_mj.searchPwd(user);
		}
		catch(Exception e)
		{
			logger.error("[UserService] searchPwd Exception",e);
		}
		
		return result;
	}
}
