package com.sist.web.model;

import java.io.Serializable;

public class Coupon implements Serializable 
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

    //USER_COUPON 테이블에 있는 것 
    private int userCpnSeq;			//사용자 쿠폰 시퀀스 (기본키)
    private String userId;			//사용자 ID (외래키)
    private String issueDt;			//쿠폰 발급일
    private String usageDt;			//쿠폰 사용일
    private String userCpnIsUsed;	//쿠폰 사용 여부 (Y: 사용, N: 미사용)
    private int userCpnCnt;			//보유 개수
    
    
    public Coupon() {
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
        
        //USER_COUPON 테이블에 있는 것 
        userCpnSeq = 0;
        userId = "";
        issueDt = "";
        usageDt = "";
        userCpnIsUsed = "N";
        userCpnCnt = 0;
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
    
    //USER_COUPON 테이블에 있는 것 
	public int getUserCpnSeq() {
		return userCpnSeq;
	}

	public void setUserCpnSeq(int userCpnSeq) {
		this.userCpnSeq = userCpnSeq;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getIssueDt() {
		return issueDt;
	}

	public void setIssueDt(String issueDt) {
		this.issueDt = issueDt;
	}

	public String getUsageDt() {
		return usageDt;
	}

	public void setUsageDt(String usageDt) {
		this.usageDt = usageDt;
	}

	public String getUserCpnIsUsed() {
		return userCpnIsUsed;
	}

	public void setUserCpnIsUsed(String userCpnIsUsed) {
		this.userCpnIsUsed = userCpnIsUsed;
	}

	public int getUserCpnCnt() {
		return userCpnCnt;
	}

	public void setUserCpnCnt(int userCpnCnt) {
		this.userCpnCnt = userCpnCnt;
	}
    
    
}