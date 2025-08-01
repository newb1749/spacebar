package com.sist.web.model;

import java.io.Serializable;
import java.util.Date;

public class Reservation implements Serializable{
	 /**
	 *  임시로 씀. 리뷰 등록전 예약 및 결제 상태 확인하기 위한 용도로 사용
	 */
	private static final long serialVersionUID = 7452262163386829254L;
	
	
		private Integer rsvSeq;
	    private String guestId;
	    private String hostId;
	    private String rsvCheckInDt;
	    private String rsvCheckOutDt;
	    private String rsvCheckInTime;
	    private String rsvCheckOutTime;
	    private int numGuests;
	    private int totalAmt;
	    private int finalAmt;
	    private String rsvStat;
	    private String rsvPaymentStat;
	    private Date cancelDt;
	    private String cancelReason;
	    private int refundAmt;
	    private String guestMsg;
	    private String hostMsg;
	    private Date regDt;
	    private Date updateDt;
	    private int roomTypeSeq;
	    private Date rsvCheckInDateObj;
	    private Date rsvCheckOutDateObj;
	    private String roomTypeTitle;
	    private Integer couponSeq; // 쿠폰 ID 저장용 필드
	    private Coupon coupon;
	    private String roomTypeImgName;
	    private String reviewYn;
		private long startRow;
		private long endRow;
		private int roomSeq;
	    
	    public Coupon getCoupon() {
	        return coupon;
	    }
	    public void setCoupon(Coupon coupon) {
	        this.coupon = coupon;
	    }
	    public Integer getCouponSeq() {
	        return couponSeq;
	    }

	    public void setCouponSeq(Integer couponSeq) {
	        this.couponSeq = couponSeq;
	    }
	    
	    // getter, setter 추가
	    public Date getRsvCheckInDateObj() 
	    { 
	    	return rsvCheckInDateObj; 
	    }
	    public void setRsvCheckInDateObj(Date rsvCheckInDateObj) 
	    { 
	    	this.rsvCheckInDateObj = rsvCheckInDateObj; 
	    }

	    public Date getRsvCheckOutDateObj() 
	    { 
	    	return rsvCheckOutDateObj; 
	    }
	    public void setRsvCheckOutDateObj(Date rsvCheckOutDateObj) 
	    { 
	    	this.rsvCheckOutDateObj = rsvCheckOutDateObj;
	    }
	    
	    public Reservation()
	    {
			rsvSeq = 0;
		    guestId = "";
		    hostId = "";
		    rsvCheckInDt = "";
		    rsvCheckOutDt = "";
		    rsvCheckInTime = "";
		    rsvCheckOutTime = "";
		    numGuests = 0;
		    totalAmt = 0;
		    finalAmt = 0;
		    rsvStat = "";
		    rsvPaymentStat = "";
		    cancelDt = null;
		    cancelReason = "";
		    refundAmt = 0;
		    guestMsg = "";
		    hostMsg = "";
		    regDt = null;
		    updateDt = null;
		    roomTypeSeq = 0;
		    reviewYn = "N";
		    
		    roomTypeTitle = "";
		    roomTypeImgName = "";
			startRow = 0;
			endRow = 0;
			roomSeq = 0;
	    }

		public int getRoomSeq() {
			return roomSeq;
		}
		public void setRoomSeq(int roomSeq) {
			this.roomSeq = roomSeq;
		}
		public long getStartRow() {
			return startRow;
		}
		public void setStartRow(long startRow) {
			this.startRow = startRow;
		}
		public long getEndRow() {
			return endRow;
		}
		public void setEndRow(long endRow) {
			this.endRow = endRow;
		}
		public String getReviewYn() {
			return reviewYn;
		}
		public void setReviewYn(String reviewYn) {
			this.reviewYn = reviewYn;
		}
		public String getRoomTypeTitle() {
			return roomTypeTitle;
		}
		public void setRoomTypeTitle(String roomTypeTitle) {
			this.roomTypeTitle = roomTypeTitle;
		}

		public String getRoomTypeImgName() {
			return roomTypeImgName;
		}
		public void setRoomTypeImgName(String roomTypeImgName) {
			this.roomTypeImgName = roomTypeImgName;
		}

		// 추가: setUserId → 내부적으로 guestId에 매핑
	    public void setUserId(String userId) {
	        this.guestId = userId;
	    }

	    public String getUserId() {
	        return this.guestId;
	    }

		public Integer getRsvSeq() {
			return rsvSeq;
		}
		public void setRsvSeq(Integer rsvSeq) {
			this.rsvSeq = rsvSeq;
		}
		public String getGuestId() {
			return guestId;
		}
		public void setGuestId(String guestId) {
			this.guestId = guestId;
		}
		public String getHostId() {
			return hostId;
		}
		public void setHostId(String hostId) {
			this.hostId = hostId;
		}
		public String getRsvCheckInDt() {
			return rsvCheckInDt;
		}
		public void setRsvCheckInDt(String rsvCheckInDt) {
			this.rsvCheckInDt = rsvCheckInDt;
		}
		public String getRsvCheckOutDt() {
			return rsvCheckOutDt;
		}
		public void setRsvCheckOutDt(String rsvCheckOutDt) {
			this.rsvCheckOutDt = rsvCheckOutDt;
		}
		public String getRsvCheckInTime() {
			return rsvCheckInTime;
		}
		public void setRsvCheckInTime(String rsvCheckInTime) {
			this.rsvCheckInTime = rsvCheckInTime;
		}
		public String getRsvCheckOutTime() {
			return rsvCheckOutTime;
		}
		public void setRsvCheckOutTime(String rsvCheckOutTime) {
			this.rsvCheckOutTime = rsvCheckOutTime;
		}
		public int getNumGuests() {
			return numGuests;
		}
		public void setNumGuests(int numGuests) {
			this.numGuests = numGuests;
		}
		public int getTotalAmt() {
			return totalAmt;
		}
		public void setTotalAmt(int totalAmt) {
			this.totalAmt = totalAmt;
		}
		public int getFinalAmt() {
			return finalAmt;
		}
		public void setFinalAmt(int finalAmt) {
			this.finalAmt = finalAmt;
		}
		public String getRsvStat() {
			return rsvStat;
		}
		public void setRsvStat(String rsvStat) {
			this.rsvStat = rsvStat;
		}
		public String getRsvPaymentStat() {
			return rsvPaymentStat;
		}
		public void setRsvPaymentStat(String rsvPaymentStat) {
			this.rsvPaymentStat = rsvPaymentStat;
		}
		public Date getCancelDt() {
			return cancelDt;
		}
		public void setCancelDt(Date cancelDt) {
			this.cancelDt = cancelDt;
		}
		public String getCancelReason() {
			return cancelReason;
		}
		public void setCancelReason(String cancelReason) {
			this.cancelReason = cancelReason;
		}
		public int getRefundAmt() {
			return refundAmt;
		}
		public void setRefundAmt(int refundAmt) {
			this.refundAmt = refundAmt;
		}
		public String getGuestMsg() {
			return guestMsg;
		}
		public void setGuestMsg(String guestMsg) {
			this.guestMsg = guestMsg;
		}
		public String getHostMsg() {
			return hostMsg;
		}
		public void setHostMsg(String hostMsg) {
			this.hostMsg = hostMsg;
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
		public int getRoomTypeSeq() {
			return roomTypeSeq;
		}
		public void setRoomTypeSeq(int roomTypeSeq) {
			this.roomTypeSeq = roomTypeSeq;
		}
	    

	    
}