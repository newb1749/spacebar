package com.sist.web.model;

import java.io.Serializable;
import java.util.Date;

public class RoomTypeJY implements Serializable {
    private static final long serialVersionUID = 1L;

    private int roomTypeSeq;       // 객실 유형 PK
    private int roomSeq;           // 부모 숙소 FK
    private String roomTypeTitle;
    private String roomTypeDesc;
    private int weekdayAmt;        // 주중 요금
    private int weekendAmt;        // 주말 요금
    private String roomCheckInDt;  // YYYYMMDD (예약 가능 시작일)
    private String roomCheckOutDt; // YYYYMMDD (예약 가능 종료일)
    private String roomCheckInTime;  // HH24MI
    private String roomCheckOutTime; // HH24MI
    private int maxGuests;
    private int minDay;
    private int maxDay;
    private Date regDt;
    private Date updateDt;
    private String hostId;

    public String getHostId() {
        return hostId;
    }

    public void setHostId(String hostId) {
        this.hostId = hostId;
    }

    // 기본 생성자, getter/setter
    public int getRoomTypeSeq() {
        return roomTypeSeq;
    }

    public void setRoomTypeSeq(int roomTypeSeq) {
        this.roomTypeSeq = roomTypeSeq;
    }

    public int getRoomSeq() {
        return roomSeq;
    }

    public void setRoomSeq(int roomSeq) {
        this.roomSeq = roomSeq;
    }

    public String getRoomTypeTitle() {
        return roomTypeTitle;
    }

    public void setRoomTypeTitle(String roomTypeTitle) {
        this.roomTypeTitle = roomTypeTitle;
    }

    public String getRoomTypeDesc() {
        return roomTypeDesc;
    }

    public void setRoomTypeDesc(String roomTypeDesc) {
        this.roomTypeDesc = roomTypeDesc;
    }

    public int getWeekdayAmt() {
        return weekdayAmt;
    }

    public void setWeekdayAmt(int weekdayAmt) {
        this.weekdayAmt = weekdayAmt;
    }

    public int getWeekendAmt() {
        return weekendAmt;
    }

    public void setWeekendAmt(int weekendAmt) {
        this.weekendAmt = weekendAmt;
    }

    public String getRoomCheckInDt() {
        return roomCheckInDt;
    }

    public void setRoomCheckInDt(String roomCheckInDt) {
        this.roomCheckInDt = roomCheckInDt;
    }

    public String getRoomCheckOutDt() {
        return roomCheckOutDt;
    }

    public void setRoomCheckOutDt(String roomCheckOutDt) {
        this.roomCheckOutDt = roomCheckOutDt;
    }

    public String getRoomCheckInTime() {
        return roomCheckInTime;
    }

    public void setRoomCheckInTime(String roomCheckInTime) {
        this.roomCheckInTime = roomCheckInTime;
    }

    public String getRoomCheckOutTime() {
        return roomCheckOutTime;
    }

    public void setRoomCheckOutTime(String roomCheckOutTime) {
        this.roomCheckOutTime = roomCheckOutTime;
    }

    public int getMaxGuests() {
        return maxGuests;
    }

    public void setMaxGuests(int maxGuests) {
        this.maxGuests = maxGuests;
    }

    public int getMinDay() {
        return minDay;
    }

    public void setMinDay(int minDay) {
        this.minDay = minDay;
    }

    public int getMaxDay() {
        return maxDay;
    }

    public void setMaxDay(int maxDay) {
        this.maxDay = maxDay;
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
}
