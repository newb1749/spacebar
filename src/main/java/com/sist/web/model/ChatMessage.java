package com.sist.web.model;

import java.io.Serializable;
import java.util.Date;

public class ChatMessage implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = -7116465757312513383L;
	
	
	// JSON은 데이터 get메소드로 자동으로 가져와서 변수명 매우매우매우 중요함!!!
	private int chatMessageSeq; 
	private int chatRoomSeq;
	private String senderId;
	private String messageContent;
	private Date sendDate;
	private int readCount;
	
	// JOIN 결과로 받아올 필드 추가
	private String senderName;
	
	public ChatMessage()
	{
		chatMessageSeq = 0;
		chatRoomSeq = 0;
		senderId = "";
		messageContent = "";
		sendDate = null;
		readCount = 0;
	}

	
	
	public String getSenderName() {
		return senderName;
	}



	public void setSenderName(String senderName) {
		this.senderName = senderName;
	}



	public int getChatMessageSeq() {
		return chatMessageSeq;
	}

	public void setChatMessageSeq(int chatMessageSeq) {
		this.chatMessageSeq = chatMessageSeq;
	}

	public int getChatRoomSeq() {
		return chatRoomSeq;
	}

	public void setChatRoomSeq(int chatRoomSeq) {
		this.chatRoomSeq = chatRoomSeq;
	}

	public String getSenderId() {
		return senderId;
	}

	public void setSenderId(String senderId) {
		this.senderId = senderId;
	}

	public String getMessageContent() {
		return messageContent;
	}

	public void setMessageContent(String messageContent) {
		this.messageContent = messageContent;
	}

	public Date getSendDate() {
		return sendDate;
	}

	public void setSendDate(Date sendDate) {
		this.sendDate = sendDate;
	}

	public int getReadCount() {
		return readCount;
	}

	public void setReadCount(int readCount) {
		this.readCount = readCount;
	}
	
	
}
