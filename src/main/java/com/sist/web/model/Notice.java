package com.sist.web.model;

import java.util.Date;
import java.util.List;

public class Notice {
    private int noticeSeq;
    private String noticeTitle;
    private String noticeContent;
    private String adminId;
    private String noticeStat;
    private Date regDt;
    private Date updateDt;
    private List<NoticeReply> replies;
	public int getNoticeSeq() {
		return noticeSeq;
	}
	public void setNoticeSeq(int noticeSeq) {
		this.noticeSeq = noticeSeq;
	}
	public String getNoticeTitle() {
		return noticeTitle;
	}
	public void setNoticeTitle(String noticeTitle) {
		this.noticeTitle = noticeTitle;
	}
	public String getNoticeContent() {
		return noticeContent;
	}
	public void setNoticeContent(String noticeContent) {
		this.noticeContent = noticeContent;
	}
	public String getAdminId() {
		return adminId;
	}
	public void setAdminId(String adminId) {
		this.adminId = adminId;
	}
	public String getNoticeStat() {
		return noticeStat;
	}
	public void setNoticeStat(String noticeStat) {
		this.noticeStat = noticeStat;
	}
	public Date getRegDt() {
		return regDt;
	}
	public void setRegDt(Date regDt) {
		this.regDt = regDt;
	}
	public Date getUpdateDt() {
		return updateDt;
	}
	public void setUpdateDt(Date updateDt) {
		this.updateDt = updateDt;
	}
	public List<NoticeReply> getReplies() {
		return replies;
	}
	public void setReplies(List<NoticeReply> replies) {
		this.replies = replies;
	}
    
    // Getters and Setters
    
}
