package com.sist.web.model;

import java.io.Serializable;

public class FreeBoard implements Serializable
{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1660598310852931531L;
	
	
	private long freeBoardSeq;			//게시물 번호(시퀀스: SEQ_FREE_BOARD_SEQ)
	private String freeBoardTitle;		//게시물 제목
	private String freeBoardContent;	//게시글 내용
	private String userId;				//사용자 아이디
	private String freeBoardStat;		//게시글 상태
	private String regDt;				//등록일
	private String updateDt;			//수정일
	private int freeBoardViews;			//조회수
	
	private String userName;			//사용자명
	private String userEmail;			//사용자 이메일
	
	private String searchType;			//검색타입
	private String searchValue;			//검색값
	
	private long startRow;
	private long endRow;
	
    private int commentCount;  // 댓글 수 필드 추가



	public FreeBoard()
	{
		freeBoardSeq = 0;			
		freeBoardTitle = "";		
		freeBoardContent = "";	
		userId = "";			
		freeBoardStat = "";		
		regDt = "";				
		updateDt = "";			
		freeBoardViews = 0;			
		
		userName = "";			
		userEmail = "";			
		
		searchType = "";			
		searchValue = "";			
		
		startRow = 0;	
		endRow = 0;	
	}

    // getter, setter 추가
    public int getCommentCount() {
        return commentCount;
    }
    public void setCommentCount(int commentCount) {
        this.commentCount = commentCount;
    }
	
	public long getFreeBoardSeq() {
		return freeBoardSeq;
	}

	public void setFreeBoardSeq(long freeBoardSeq) {
		this.freeBoardSeq = freeBoardSeq;
	}

	public String getFreeBoardTitle() {
		return freeBoardTitle;
	}

	public void setFreeBoardTitle(String freeBoardTitle) {
		this.freeBoardTitle = freeBoardTitle;
	}

	public String getFreeBoardContent() {
		return freeBoardContent;
	}

	public void setFreeBoardContent(String freeBoardContent) {
		this.freeBoardContent = freeBoardContent;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getFreeBoardStat() {
		return freeBoardStat;
	}

	public void setFreeBoardStat(String freeBoardStat) {
		this.freeBoardStat = freeBoardStat;
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

	public int getFreeBoardViews() {
		return freeBoardViews;
	}

	public void setFreeBoardViews(int freeBoardViews) {
		this.freeBoardViews = freeBoardViews;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getUserEmail() {
		return userEmail;
	}

	public void setUserEmail(String userEmail) {
		this.userEmail = userEmail;
	}

	public String getSearchType() {
		return searchType;
	}

	public void setSearchType(String searchType) {
		this.searchType = searchType;
	}

	public String getSearchValue() {
		return searchValue;
	}

	public void setSearchValue(String searchValue) {
		this.searchValue = searchValue;
	}

	public long getStartRow() {
		return startRow;
	}

	public void setStartRow(long startRow) {
		this.startRow = startRow;
	}

	public long getEndRow() {
		return endRow;
	}

	public void setEndRow(long endRow) {
		this.endRow = endRow;
	}
	
}
