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
    
    private String otherUserNickname; 
    
    public ChatRoom()
    {
    	chatRoomSeq = 0;
    	createDate = null;
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
