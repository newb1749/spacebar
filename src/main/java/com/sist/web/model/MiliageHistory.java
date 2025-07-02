package com.sist.web.model;

public class MiliageHistory {
	private int mileHistorySeq;
	private String userId;
	private String trxType; // 예: "충전", "결제"
	private int trxAmt;
	private int balanceAfterTrx;
	private String trxDt;  // 거래 일시

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
	public int getBalanceAfterTrx() {
		return balanceAfterTrx;
	}
	public void setBalanceAfterTrx(int balanceAfterTrx) {
		this.balanceAfterTrx = balanceAfterTrx;
	}
	public String getTrxDt() {
		return trxDt;
	}
	public void setTrxDt(String trxDt) {
		this.trxDt = trxDt;
	}
}