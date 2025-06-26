package com.sist.web.dao;

import org.springframework.stereotype.Repository;

import com.sist.web.model.User;

@Repository("userDao")
public interface UserDao 
{
	//회원 조회
	public User userSelect(String userId);
	
	//닉네임 관련
	public User nickNameSelect(String nickName);
	
	//회원 등록
	public int userInsert(User user);
	
	//회원 정보 수정
	public int userUpdate(User user);
	
	//회원 탈퇴
	public int userDelete(User user);
	
}
