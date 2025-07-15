package com.sist.web.model;

import java.util.Date;

public class MileageHistory {
	private int mileHistorySeq;
	private String userId;
	private String trxType; // 예: "충전", "결제"
	private int trxAmt;
	private long balanceAfterTrx;
	private Date trxDt;  // 거래 일시
	
	@Override
	public String toString() {
	    return "MileageHistory{" +
	           "userId='" + userId + '\'' +
	           ", trxType='" + trxType + '\'' +
	           ", trxAmt=" + trxAmt +
	           ", balanceAfterTrx=" + balanceAfterTrx +
	           ", trxDt=" + trxDt +
	           '}';
	}

	// Getters / Setters
	public int getMileHistorySeq() {
		return mileHistorySeq;
	}
	public void setMileHistorySeq(int mileHistorySeq) {
		this.mileHistorySeq = mileHistorySeq;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getTrxType() {
		return trxType;
	}
	public void setTrxType(String trxType) {
		this.trxType = trxType;
	}
	public int getTrxAmt() {
		return trxAmt;
	}
	public void setTrxAmt(int trxAmt) {
		this.trxAmt = trxAmt;
	}
	public long getBalanceAfterTrx() {
		return balanceAfterTrx;
	}
	public void setBalanceAfterTrx(long l) {
		this.balanceAfterTrx = l;
	}
	public Date getTrxDt() {
		return trxDt;
	}
	public void setTrxDt(Date trxDt) {
		this.trxDt = trxDt;
	} 
<<<<<<< HEAD
}
=======
}
>>>>>>> e6bcdb4938f0734e97499302b774512f1b7ea22f
