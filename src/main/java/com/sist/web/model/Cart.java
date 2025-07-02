package com.sist.web.model;

import java.io.Serializable;

public class Cart implements Serializable
{

	/**
	 * 
	 */
	private static final long serialVersionUID = 8472399271520013457L;
	
	private int cartSeq;			//장바구니 시퀀스 (기본키)
    private String userId;			//사용자 ID (외래키)
    private String cartCheckInDt;		//장바구니에 담긴 체크인 날짜
    private String cartCheckOutDt;	//장바구니에 담긴 체크아웃 날짜
    
    private String cartCheckInTime;		//장바구니에 담긴 체크인 날짜
    private String cartCheckOutTime;	//장바구니에 담긴 체크아웃 날짜
    
    private int cartGuestsNum;		//장바구니에 담긴 인원수
    private int cartTotalAmt;		//장바구니 총 금액
    private String regDt;			//등록일
    private String updateDt;		//마지막 업데이트 일시
    private int roomTypeSeq;		//룸별타입별 시퀀스
    
    private String roomTypeTitle;	//룸타입 제목
    private String roomTypeImgName; //룸타입 이미지이름
	
    private String roomTitle;		//룸 제목
    private String roomAddr;		//룸 주소
    private String cancelPolicy;	//취소정책
    private String roomCatName;		//룸카테고리이름
    
    public Cart()
    {
    	cartSeq = 0;
        userId = "";			
        cartCheckInDt = "";			
        cartCheckOutDt = "";		
        cartGuestsNum = 0;	
        cartTotalAmt = 0;	
        regDt = "";					
        updateDt = "";				
        roomTypeSeq = 0;
        roomTypeTitle = "";
        roomTypeImgName = "";
        
        cartCheckInTime = "";
        cartCheckOutTime = "";
        
        roomTitle = "";
        roomAddr = "";
        cancelPolicy = "";
        roomCatName = "";
    }

	public int getCartSeq() {
		return cartSeq;
	}

	public void setCartSeq(int cartSeq) {
		this.cartSeq = cartSeq;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getCartCheckInDt() {
		return cartCheckInDt;
	}

	public void setCartCheckInDt(String cartCheckInDt) {
		this.cartCheckInDt = cartCheckInDt;
	}

	public String getCartCheckOutDt() {
		return cartCheckOutDt;
	}

	public void setCartCheckOutDt(String cartCheckOutDt) {
		this.cartCheckOutDt = cartCheckOutDt;
	}

	public int getCartGuestsNum() {
		return cartGuestsNum;
	}

	public void setCartGuestsNum(int cartGuestsNum) {
		this.cartGuestsNum = cartGuestsNum;
	}

	public int getCartTotalAmt() {
		return cartTotalAmt;
	}

	public void setCartTotalAmt(int cartTotalAmt) {
		this.cartTotalAmt = cartTotalAmt;
	}

	public String getRegDt() {
		return regDt;
	}

	public void setRegDt(String regDt) {
		this.regDt = regDt;
	}

	public String getUpdateDt() {
		return updateDt;
	}

	public void setUpdateDt(String updateDt) {
		this.updateDt = updateDt;
	}

	public int getRoomTypeSeq() {
		return roomTypeSeq;
	}

	public void setRoomTypeSeq(int roomTypeSeq) {
		this.roomTypeSeq = roomTypeSeq;
	}

	public String getRoomTypeTitle() {
		return roomTypeTitle;
	}

	public void setRoomTypeTitle(String roomTypeTitle) {
		this.roomTypeTitle = roomTypeTitle;
	}

	public String getRoomTypeImgName() {
		return roomTypeImgName;
	}

	public void setRoomTypeImgName(String roomTypeImgName) {
		this.roomTypeImgName = roomTypeImgName;
	}

	public String getCartCheckInTime() {
		return cartCheckInTime;
	}

	public void setCartCheckInTime(String cartCheckInTime) {
		this.cartCheckInTime = cartCheckInTime;
	}

	public String getCartCheckOutTime() {
		return cartCheckOutTime;
	}

	public void setCartCheckOutTime(String cartCheckOutTime) {
		this.cartCheckOutTime = cartCheckOutTime;
	}

	public String getRoomTitle() {
		return roomTitle;
	}

	public void setRoomTitle(String roomTitle) {
		this.roomTitle = roomTitle;
	}

	public String getRoomAddr() {
		return roomAddr;
	}

	public void setRoomAddr(String roomAddr) {
		this.roomAddr = roomAddr;
	}

	public String getCancelPolicy() {
		return cancelPolicy;
	}

	public void setCancelPolicy(String cancelPolicy) {
		this.cancelPolicy = cancelPolicy;
	}

	public String getRoomCatName() {
		return roomCatName;
	}

	public void setRoomCatName(String roomCatName) {
		this.roomCatName = roomCatName;
	}
    
    
}
