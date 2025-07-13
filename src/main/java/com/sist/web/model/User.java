package com.sist.web.model;

import java.io.Serializable;

public class User implements Serializable
{
	private static final long serialVersionUID = 2015965517661120001L;
	
	private String	userId;		//사용자 id (기본키)
	private String	userPwd;	//사용자 비밀번호
	private String	userName;	//사용자 이름
	private String	email;		//이메일 주소
	private String	phone;		//전화번호
	private String	userAddr;	//사용자 주소
	private String	joinDt;		//가입일
	private String	nickName;	//닉네임
	private String	grade;		//사용자 등급
	private String	profImgExt;	//프로필 이미지 파일 확장자
	private String	gender;		//성별 (m: 남성, f: 여성)
	private String	birthDt;	//생년월일
	private String	userType;	//사용자 유형 (g: 게스트, h: 호스트)
	private String	approvStat;	//승인 상태 (y: 승인, n: 미승인)
	private String	userStat;	//사용자 상태 (y: 활성, n: 비활성)
	private int	mile;			//마일리지
	private String	updateDt;	//마지막 업데이트 일시
	
	public User()
	{
		userId = "";
		userPwd = "";	
		userName = "";
		email = "";
		phone = "";
		userAddr = "";
		joinDt = "";
		nickName = "";
		grade = "";
		profImgExt = "";
		gender = "";	
		birthDt = "";	
		userType = "G";	
		approvStat = "Y";	
		userStat = "Y";	
		mile = 0;	
		updateDt = "";	
		
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getUserPwd() {
		return userPwd;
	}

	public void setUserPwd(String userPwd) {
		this.userPwd = userPwd;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}

	public String getUserAddr() {
		return userAddr;
	}

	public void setUserAddr(String userAddr) {
		this.userAddr = userAddr;
	}

	public String getJoinDt() {
		return joinDt;
	}

	public void setJoinDt(String joinDt) {
		this.joinDt = joinDt;
	}

	public String getNickName() {
		return nickName;
	}

	public void setNickName(String nickName) {
		this.nickName = nickName;
	}

	public String getGrade() {
		return grade;
	}

	public void setGrade(String grade) {
		this.grade = grade;
	}

	public String getProfImgExt() {
		return profImgExt;
	}

	public void setProfImgExt(String profImgExt) {
		this.profImgExt = profImgExt;
	}

	public String getGender() {
		return gender;
	}

	public void setGender(String gender) {
		this.gender = gender;
	}

	public String getBirthDt() {
		return birthDt;
	}

	public void setBirthDt(String birthDt) {
		this.birthDt = birthDt;
	}

	public String getUserType() {
		return userType;
	}

	public void setUserType(String userType) {
		this.userType = userType;
	}

	public String getApprovStat() {
		return approvStat;
	}

	public void setApprovStat(String approvStat) {
		this.approvStat = approvStat;
	}

	public String getUserStat() {
		return userStat;
	}

	public void setUserStat(String userStat) {
		this.userStat = userStat;
	}

	public int getMile() {
		return mile;
	}

	public void setMile(int mile) {
		this.mile = mile;
	}

	public String getUpdateDt() {
		return updateDt;
	}

	public void setUpdateDt(String updateDt) {
		this.updateDt = updateDt;
	}
	

}

