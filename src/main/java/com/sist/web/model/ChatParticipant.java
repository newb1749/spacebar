package com.sist.web.model;

import java.io.Serializable;

public class ChatParticipant implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = -6357988187468662677L;
	
    private int chatRoomSeq;
    private String userId;
    
    public ChatParticipant()
    {
    	chatRoomSeq = 0;
    	userId = "";
    }

	public int getChatRoomSeq() {
		return chatRoomSeq;
	}

	public void setChatRoomSeq(int chatRoomSeq) {
		this.chatRoomSeq = chatRoomSeq;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}
    
	
}
