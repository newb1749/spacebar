package com.sist.web.model;

import java.io.Serializable;

public class CouponJY implements Serializable 
{
    private static final long serialVersionUID = 1L;

    private int cpnSeq;
    private String cpnName;
    private String cpnDesc;
    private double discountRate;
    private int discountAmt;
    private int minOrderAmt;
    private String issueStartDt; // Date → String 변경
    private String issueEndDt;   // Date → String 변경
    private String cpnType;
    private String cpnStat;
    private int totalCpnCnt;
    private String regDt;        // Date → String 변경
    private String updateDt;     // Date → String 변경

    public CouponJY() {
        this.cpnSeq = 0;
        this.cpnName = "";
        this.cpnDesc = "";
        this.discountRate = 0;	// 할인율
        this.discountAmt = 0;		// 할인금액
        this.minOrderAmt = 0;
        this.issueStartDt = "";
        this.issueEndDt = "";
        this.cpnType = "";
        this.cpnStat = "";
        this.totalCpnCnt = 0;
        this.regDt = "";
        this.updateDt = "";
    }

    // getter / setter

    public int getCpnSeq() {
        return cpnSeq;
    }

    public void setCpnSeq(int cpnSeq) {
        this.cpnSeq = cpnSeq;
    }

    public String getCpnName() {
        return cpnName;
    }

    public void setCpnName(String cpnName) {
        this.cpnName = cpnName;
    }

    public String getCpnDesc() {
        return cpnDesc;
    }

    public void setCpnDesc(String cpnDesc) {
        this.cpnDesc = cpnDesc;
    }

    public double getDiscountRate() {
        return discountRate;
    }

    public void setDiscountRate(double discountRate) {
        this.discountRate = discountRate;
    }

    public int getDiscountAmt() {
        return discountAmt;
    }

    public void setDiscountAmt(int discountAmt) {
        this.discountAmt = discountAmt;
    }

    public int getMinOrderAmt() {
        return minOrderAmt;
    }

    public void setMinOrderAmt(int minOrderAmt) {
        this.minOrderAmt = minOrderAmt;
    }

    public String getIssueStartDt() {
        return issueStartDt;
    }

    public void setIssueStartDt(String issueStartDt) {
        this.issueStartDt = issueStartDt;
    }

    public String getIssueEndDt() {
        return issueEndDt;
    }

    public void setIssueEndDt(String issueEndDt) {
        this.issueEndDt = issueEndDt;
    }

    public String getCpnType() {
        return cpnType;
    }

    public void setCpnType(String cpnType) {
        this.cpnType = cpnType;
    }

    public String getCpnStat() {
        return cpnStat;
    }

    public void setCpnStat(String cpnStat) {
        this.cpnStat = cpnStat;
    }

    public int getTotalCpnCnt() {
        return totalCpnCnt;
    }

    public void setTotalCpnCnt(int totalCpnCnt) {
        this.totalCpnCnt = totalCpnCnt;
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
}
