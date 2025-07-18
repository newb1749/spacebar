package com.sist.web.model;

import java.io.Serializable;
import java.util.Date;

public class Alarm implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = -6272686379095277680L;
	
	public int alarmSeq;
	public String receiverId;
	public String alarmType;
	public int targetSeq;
	public String alarmContent;
	public String readYn;
	public Date createDate;
	
	
	public Alarm()
	{
		alarmSeq = 0;
		receiverId = "";
		alarmType = "";
		targetSeq = 0;
		alarmContent = "";
		readYn = "";
		createDate = null;
	}


	public int getAlarmSeq() {
		return alarmSeq;
	}


	public void setAlarmSeq(int alarmSeq) {
		this.alarmSeq = alarmSeq;
	}


	public String getReceiverId() {
		return receiverId;
	}


	public void setReceiverId(String receiverId) {
		this.receiverId = receiverId;
	}


	public String getAlarmType() {
		return alarmType;
	}


	public void setAlarmType(String alarmType) {
		this.alarmType = alarmType;
	}


	public int getTargetSeq() {
		return targetSeq;
	}


	public void setTargetSeq(int targetSeq) {
		this.targetSeq = targetSeq;
	}


	public String getAlarmContent() {
		return alarmContent;
	}


	public void setAlarmContent(String alarmContent) {
		this.alarmContent = alarmContent;
	}


	public String getReadYn() {
		return readYn;
	}


	public void setReadYn(String readYn) {
		this.readYn = readYn;
	}


	public Date getCreateDate() {
		return createDate;
	}


	public void setCreateDate(Date createDate) {
		this.createDate = createDate;
	}
	
	
}
