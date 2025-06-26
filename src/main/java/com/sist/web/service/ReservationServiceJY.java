package com.sist.web.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.sist.web.dao.ReservationDaoJY;
import com.sist.web.model.ReservationJY;

@Service
public class ReservationServiceJY 
{

	    @Autowired
	    private ReservationDaoJY reservationDao;

	    /**
	     * 예약 등록
	     */
	    @Transactional
	    public void insertReservation(ReservationJY reservation) throws Exception
	    {
	        reservationDao.insertReservation(reservation);
	    }

	    /**
	     * 특정 게스트의 예약 목록 조회
	     */
	    public List<ReservationJY> getReservationsByGuestId(String guestId)
	    {
	        return reservationDao.selectReservationsByGuestId(guestId);
	    }

	    /**
	     * 특정 예약 상세 조회
	     */
	    public ReservationJY getReservationBySeq(int rsvSeq) 
	    {
	        return reservationDao.selectReservationBySeq(rsvSeq);
	    }

	    /**
	     * 예약 상태 업데이트 (취소, 완료 등)
	     */
	    @Transactional
	    public void updateReservationStatus(int rsvSeq, String status) throws Exception {
	        reservationDao.updateReservationStatus(rsvSeq, status);
	    }

	    /**
	     * 예약 결제 상태 업데이트
	     */
	    @Transactional
	    public void updatePaymentStatus(int rsvSeq, String paymentStatus) throws Exception {
	        reservationDao.updatePaymentStatus(rsvSeq, paymentStatus);
	    }

	    /**
	     * 예약 취소 처리 (취소일, 사유, 환불액 등 포함)
	     */
	    @Transactional
	    public void cancelReservation(ReservationJY reservation) throws Exception
	    {
	        reservationDao.cancelReservation(reservation);
	    }
	
}
