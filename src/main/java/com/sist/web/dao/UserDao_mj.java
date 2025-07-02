package com.sist.web.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import com.sist.web.model.MiliageHistory;
import com.sist.web.model.User_mj;

@Repository("userDao_mj")
public interface UserDao_mj 
{
	//회원 조회
	public User_mj userSelect(String userId);
	
	//닉네임 관련
	public User_mj nickNameSelect(String nickName);
	
	//회원 등록
	public int userInsert(User_mj user);
	
	//회원 정보 수정
	public int userUpdate(User_mj user);
	
	//회원 탈퇴
	public int userDelete(User_mj user);

    int updateMileage(@Param("userId") String userId, @Param("amount") int amount);

    int insertMileageHistory(MiliageHistory history);
    
    int selectMileage(String userId); // 현재 마일리지 조회
    
    List<MiliageHistory> selectMileageHistory(String userId);
}