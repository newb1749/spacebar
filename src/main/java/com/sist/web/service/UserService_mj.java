package com.sist.web.service;

import java.util.Collections;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.sist.common.model.FileData;
import com.sist.common.util.StringUtil;
import com.sist.web.dao.UserDao;
import com.sist.web.model.MileageHistory;
import com.sist.web.model.User;

@Service("userService_mj")
public class UserService_mj 
{
	private static Logger logger = LoggerFactory.getLogger(UserService_mj.class);
	
	@Autowired
	private UserDao userDao;
	

    @Value("#{env['auth.session.name']}")
    private String AUTH_SESSION_NAME;

	
	@Value("#{env['upload.profile.dir']}")
	private String UPLOAD_PROFILE_DIR;
	
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
	
	//회원가입
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
			user.setUserStat("N");
			count = userDao.userDelete(user);
		}
		catch(Exception e)
		{
			logger.error("[UserService] userDelete Exception",e);
		}
		
		return count;
	}

	
	//아이디 찾기
	public User searchId(User user)
	{
		User result = null;
		
		try
		{
			result = userDao.searchId(user);
		}
		catch(Exception e)
		{
			logger.error("[UserService] searchId Exception",e);
		}
		
		return result;
	}
	
	//비밀번호 찾기
	public User searchPwd(User user)
	{
		User result = null;
		
		try
		{
			result = userDao.searchPwd(user);
		}
		catch(Exception e)
		{
			logger.error("[UserService] searchPwd Exception",e);
		}
		
		return result;
	}


	@Transactional(propagation = Propagation.REQUIRED)
	public int chargeMileage(String userId, int amount) {
	    try {
	        // 현재 마일리지 조회
	        int currentMile = userDao.selectMileage(userId);

	        // 마일리지 충전 (기존 + amount)
	        int result = userDao.updateMileage(userId, amount);

	        // 이력 저장
	        MileageHistory history = new MileageHistory();
	        history.setUserId(userId);
	        history.setTrxType("충전");
	        history.setTrxAmt(amount);
	        history.setBalanceAfterTrx(currentMile + amount);
	        userDao.insertMileageHistory(history);

	        return result;
	    } catch (Exception e) {
	        logger.error("[UserService] chargeMileage Exception", e);
	        return 0;
	    }
	}

	// 현재 마일리지 조회
	public int getCurrentMileage(String userId)
	{
	    try 
	    {
	        return userDao.selectMileage(userId);
	    } 
	    catch (Exception e) 
	    {
	        logger.error("[UserService] getCurrentMileage Exception", e);
	        return 0;
	    }
	}
	
	// 마일리지 이력 조회
	public List<MileageHistory> getMileageHistory(String userId) 
	{
	    try 
	    {
	        return userDao.selectMileageHistory(userId);
	    } 
	    catch (Exception e) 
	    {
	        logger.error("[UserService] getMileageHistory Exception", e);
	        return Collections.emptyList();
	    }
	}

	@Transactional
	public boolean deductMileage(String userId, int amount) 
	{
	    try 
	    {
	        int currentMile = userDao.selectMileage(userId);
	        if (currentMile < amount)
	        {
	            return false;  // 잔액 부족
	        }
	        int updated = userDao.updateMileage(userId, -amount); // 마일리지 차감

	        // 마일리지 거래 내역 기록
	        MileageHistory history = new MileageHistory();
	        history.setUserId(userId);
	        history.setTrxType("결제");
	        history.setTrxAmt(-amount);
	        history.setBalanceAfterTrx(currentMile - amount);
	        userDao.insertMileageHistory(history);

	        return updated > 0;
	    } 
	    catch (Exception e)
	    {
	        logger.error("[UserService] deductMileage Exception", e);
	        return false;
	    }
	}

	@Transactional
	public boolean refundMileage(String userId, int amount)
	{
	    try 
	    {
	        int currentMile = userDao.selectMileage(userId);
	        int updated = userDao.updateMileage(userId, amount); // 마일리지 환불(충전)

	        // 마일리지 거래 내역 기록
	        MileageHistory history = new MileageHistory();
	        history.setUserId(userId);
	        history.setTrxType("환불");
	        history.setTrxAmt(amount);
	        history.setBalanceAfterTrx(currentMile + amount);
	        userDao.insertMileageHistory(history);

	        return updated > 0;
	    } 
	    catch (Exception e) 
	    {
	        logger.error("[UserService] refundMileage Exception", e);
	        return false;
	    }
	}

}
