package com.sist.web.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;
import com.sist.web.model.User; 

@Repository("userDao_ks")
public interface UserDao_ks {
	
	/**
	 * 사용자 목록 조회(검색 기능 포함) 
	 * @param userId: 사용자 본인(본인외에 검색되게 하려고)
	 * @param searchKeyword
	 * @return 검색한 리스트(userId, userName, nickName)
	 */
	public List<User> userList(@Param("userId") String userId, @Param("searchKeyword") String searchKeyword);
}
