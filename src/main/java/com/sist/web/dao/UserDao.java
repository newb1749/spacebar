package com.sist.web.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

<<<<<<< HEAD
import com.sist.web.model.MileageHistory;
=======
import com.sist.web.model.MiliageHistory;
>>>>>>> base
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
	
	//아이디 찾기
	public User searchId(User user);
	
	//비밀번호 찾기
	public User searchPwd(User user);



    int updateMileage(@Param("userId") String userId, @Param("amount") int amount);

<<<<<<< HEAD
    int insertMileageHistory(MileageHistory history);
    
    int selectMileage(String userId); // 현재 마일리지 조회
    
    List<MileageHistory> selectMileageHistory(String userId);
=======
    int insertMileageHistory(MiliageHistory history);
    
    int selectMileage(String userId); // 현재 마일리지 조회
    
    List<MiliageHistory> selectMileageHistory(String userId);
>>>>>>> base
	
	/**
	 * 사용자 목록 조회(검색 기능 포함) 
	 * @param userId: 사용자 본인(본인외에 검색되게 하려고)
	 * @param searchKeyword
	 * @return 검색한 리스트(userId, userName, nickName)
	 */
	public List<User> userList(@Param("userId") String userId, @Param("searchKeyword") String searchKeyword);
}