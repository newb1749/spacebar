package com.sist.web.model;

import java.util.Date;

public class ReservationJY
{
    private int rsvSeq;
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

    // 추가: setUserId → 내부적으로 guestId에 매핑
    public void setUserId(String userId) {
        this.guestId = userId;
    }

    public String getUserId() {
        return this.guestId;
    }

    // 기존 getter/setter
    public int getRsvSeq() {
        return rsvSeq;
    }

    public void setRsvSeq(int rsvSeq) {
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
