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
import com.sist.web.dao.UserDao_mj;
import com.sist.web.model.MiliageHistory;
import com.sist.web.model.User_mj;

@Service("userService_mj")
public class UserService_mj 
{
	private static Logger logger = LoggerFactory.getLogger(UserService_mj.class);
	
	@Autowired
	private UserDao_mj userDao_mj;
	
	
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
	@Transactional(propagation = Propagation.REQUIRED)
	public int chargeMileage(String userId, int amount) {
	    try {
	        // 현재 마일리지 조회
	        int currentMile = userDao_mj.selectMileage(userId);

	        // 마일리지 충전 (기존 + amount)
	        int result = userDao_mj.updateMileage(userId, amount);

	        // 이력 저장
	        MiliageHistory history = new MiliageHistory();
	        history.setUserId(userId);
	        history.setTrxType("충전");
	        history.setTrxAmt(amount);
	        history.setBalanceAfterTrx(currentMile + amount);
	        userDao_mj.insertMileageHistory(history);

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
	        return userDao_mj.selectMileage(userId);
	    } 
	    catch (Exception e) 
	    {
	        logger.error("[UserService] getCurrentMileage Exception", e);
	        return 0;
	    }
	}
	
	// 마일리지 이력 조회
	public List<MiliageHistory> getMileageHistory(String userId) 
	{
	    try 
	    {
	        return userDao_mj.selectMileageHistory(userId);
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
	        int currentMile = userDao_mj.selectMileage(userId);
	        if (currentMile < amount)
	        {
	            return false;  // 잔액 부족
	        }
	        int updated = userDao_mj.updateMileage(userId, -amount); // 마일리지 차감

	        // 마일리지 거래 내역 기록
	        MiliageHistory history = new MiliageHistory();
	        history.setUserId(userId);
	        history.setTrxType("결제");
	        history.setTrxAmt(-amount);
	        history.setBalanceAfterTrx(currentMile - amount);
	        userDao_mj.insertMileageHistory(history);

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
	        int currentMile = userDao_mj.selectMileage(userId);
	        int updated = userDao_mj.updateMileage(userId, amount); // 마일리지 환불(충전)

	        // 마일리지 거래 내역 기록
	        MiliageHistory history = new MiliageHistory();
	        history.setUserId(userId);
	        history.setTrxType("환불");
	        history.setTrxAmt(amount);
	        history.setBalanceAfterTrx(currentMile + amount);
	        userDao_mj.insertMileageHistory(history);

	        return updated > 0;
	    } 
	    catch (Exception e) 
	    {
	        logger.error("[UserService] refundMileage Exception", e);
	        return false;
	    }
	}

}
