package com.sist.web.dao;

import java.util.List;
import org.apache.ibatis.annotations.Param;
import com.sist.web.model.Reservation;

public interface ReservationDao 
{
    // 예약 정보를 DB에 삽입하는 메서드, 성공 시 삽입된 행 개수를 반환
    int insertReservation(Reservation reservation);

    // 특정 게스트 ID로 예약 목록을 조회하는 메서드, 예약 리스트 반환
    List<Reservation> selectReservationsByGuestId(String guestId);

    // 예약 번호(RSV_SEQ)로 특정 예약 상세 정보를 조회하는 메서드
    Reservation selectReservationBySeq(int rsvSeq);

    // 예약 상태(RSV_STAT)를 업데이트하는 메서드, RSV_SEQ와 새 상태를 파라미터로 받음
    int updateReservationStatus(@Param("rsvSeq") int rsvSeq, @Param("status") String status);

    // 예약 결제 상태(RSV_PAYMENT_STAT)를 업데이트하는 메서드, RSV_SEQ와 결제 상태를 파라미터로 받음
    int updatePaymentStatus(@Param("rsvSeq") int rsvSeq, @Param("paymentStatus") String paymentStatus);

    // 예약 취소 처리 시 예약 정보 일부를 업데이트하는 메서드, 예약 객체를 받아 처리
    int cancelReservation(Reservation reservation);

    Reservation selectReservationById(int rsvSeq);

    String selectHostIdByRoomSeq(int roomSeq);
    
    // 예약 번호로 roomSeq 값 구하기(리뷰에 쓰임)	
    int selectRoomSeqByRsvSeq(@Param("rsvSeq") int rsvSeq);
    
}