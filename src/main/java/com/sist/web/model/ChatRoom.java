package com.sist.web.model;

import java.io.Serializable;
import java.util.Date;

public class ChatRoom implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = -9160285189265291512L;
		
    private int chatRoomSeq;
    private Date createDate;
    
    // ▼▼▼ DB 테이블에 없지만 추가한 필드 ▼▼▼
    private String otherUserId;					// 상대방 id, 프로필이미지 때문에 필요
    private String otherUserNickname;			// 다른 사람 닉네임
    private String lastMessage;  				// 마지막 메시지 내용
    private Date lastMessageDate;				// 마지막 메시지 시간
    private int unreadCount;					// 안읽은 메시지 갯수
    private String otherUserProfileImgExt;		// 상대방 프로필 확장자 
    
    public ChatRoom()
    {
    	chatRoomSeq = 0;
    	createDate = null;
    }
    
    
    
	public String getOtherUserId() {
		return otherUserId;
	}



	public void setOtherUserId(String otherUserId) {
		this.otherUserId = otherUserId;
	}



	public String getLastMessage() {
		return lastMessage;
	}

	public void setLastMessage(String lastMessage) {
		this.lastMessage = lastMessage;
	}

	public Date getLastMessageDate() {
		return lastMessageDate;
	}

	public void setLastMessageDate(Date lastMessageDate) {
		this.lastMessageDate = lastMessageDate;
	}


	public int getUnreadCount() {
		return unreadCount;
	}

	public void setUnreadCount(int unreadCount) {
		this.unreadCount = unreadCount;
	}

	public String getOtherUserProfileImgExt() {
		return otherUserProfileImgExt;
	}

	public void setOtherUserProfileImgExt(String otherUserProfileImgExt) {
		this.otherUserProfileImgExt = otherUserProfileImgExt;
	}

	public String getOtherUserNickname() {
		return otherUserNickname;
	}

	public void setOtherUserNickname(String otherUserNickname) {
		this.otherUserNickname = otherUserNickname;
	}
	
	public int getChatRoomSeq() {
		return chatRoomSeq;
	}

	public void setChatRoomSeq(int roomSeq) {
		this.chatRoomSeq = roomSeq;
	}

	public Date getCreateDate() {
		return createDate;
	}

	public void setCreateDate(Date createDate) {
		this.createDate = createDate;
	}
    
    
}
