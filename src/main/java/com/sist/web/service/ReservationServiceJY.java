package com.sist.web.service;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.sist.web.dao.ReservationDao;
import com.sist.web.model.Coupon;
import com.sist.web.model.Reservation;
import com.sist.web.model.RoomType;

@Service
public class ReservationServiceJY 
{
    @Autowired
    private ReservationDao reservationDao;

    @Autowired
    private RoomService roomService;

    @Autowired
    private CouponServiceJY couponService;
    
    @Autowired
    private RoomTypeService roomTypeService;
    
    @Autowired
    private MileageHistoryService mileageHistoryService;
    
    /**
     * 예약 등록 - hostId 자동 설정 포함
     */
    @Transactional
    public void insertReservation(Reservation reservation) throws Exception
    {
        // 디버깅 로그
        System.out.println("=== insertReservation 시작 ===");
        System.out.println("전달받은 roomTypeSeq: " + reservation.getRoomTypeSeq());
        System.out.println("전달받은 hostId: " + reservation.getHostId());
        
        // hostId 검증 및 설정
        if (reservation.getHostId() == null || reservation.getHostId().trim().isEmpty()) 
        {
            Integer roomTypeSeq = reservation.getRoomTypeSeq();
            if(roomTypeSeq == null) throw new IllegalArgumentException("roomTypeSeq가 null입니다.");

            RoomType roomType = roomTypeService.getRoomType(roomTypeSeq);
            String hostId = null;

            if(roomType != null && roomType.getHostId() != null && !roomType.getHostId().trim().isEmpty()) 
            {
                hostId = roomType.getHostId().trim();
                System.out.println("RoomType에서 hostId 획득: '" + hostId + "'");
            } 
            else 
            {
                // roomType에서 hostId가 없으면 roomSeq를 가져와서 직접 조회
                if(roomType == null) {
                    throw new IllegalArgumentException("roomType이 존재하지 않습니다. roomTypeSeq: " + roomTypeSeq);
                }

                int roomSeq = roomType.getRoomSeq();
                System.out.println("RoomType에서 hostId가 없어 ROOM 테이블에서 hostId 조회 시도, roomSeq: " + roomSeq);

                hostId = reservationDao.selectHostIdByRoomSeq(roomSeq);
                System.out.println("DAO에서 조회한 hostId: '" + hostId + "'");
            }
            
            if (hostId == null || hostId.trim().isEmpty())
                throw new IllegalArgumentException("해당 객실의 호스트 정보가 없습니다. roomTypeSeq: " + roomTypeSeq);

            reservation.setHostId(hostId);
            System.out.println("최종 설정된 hostId: '" + reservation.getHostId() + "'");
        }
        
        // 최종 검증
        if (reservation.getHostId() == null || reservation.getHostId().trim().isEmpty()) {
            throw new IllegalArgumentException("HOST_ID가 설정되지 않았습니다.");
        }
        
        // 필수 필드 검증
        if (reservation.getGuestId() == null || reservation.getGuestId().trim().isEmpty()) {
            throw new IllegalArgumentException("GUEST_ID가 설정되지 않았습니다.");
        }
        
        // DB 삽입
        reservationDao.insertReservation(reservation);
    }
    
    /**
     * 특정 게스트의 예약 목록 조회
     */
    public List<Reservation> getReservationsByGuestId(String guestId)
    {
        return reservationDao.selectReservationsByGuestId(guestId);
    }
    
    /**
     * 특정 예약 상세 조회
     */
    public Reservation getReservationBySeq(int rsvSeq) 
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
    public void cancelReservation(Reservation reservation) throws Exception {
        System.out.println("[cancelReservation] 예약 취소 시작, refundAmt=" + reservation.getRefundAmt() + ", guestId=" + reservation.getGuestId());

        reservationDao.cancelReservation(reservation);

        if (reservation.getRefundAmt() > 0) {
            System.out.println("[cancelReservation] 환불 마일리지 처리 시작");
            mileageHistoryService.refundMileage(reservation.getGuestId(), reservation.getRefundAmt());
            System.out.println("[cancelReservation] 환불 마일리지 처리 완료");
        } else {
            System.out.println("[cancelReservation] 환불 금액 없음, 마일리지 환불 처리 안함");
        }
    }
    
    /**
     * 예약 번호로 roomSeq 값 구하기(리뷰에 쓰임)	
     * @param rsvSeq 에약번호(리뷰 확인용)
     * @return 예약번호(리뷰)에 해당하는 roomSeq 값 
     */
    public int getRoomSeqByRsvSeq(int rsvSeq) {
    	return reservationDao.selectRoomSeqByRsvSeq(rsvSeq);
    }
    
    /**
     * 예약 정보에 따라 최종 결제 금액을 계산하는 메서드 예시
     * 할인, 쿠폰, 세금 등을 적용하는 로직을 작성
     */
    public int calculateFinalAmount(Reservation reservation) {
        int baseAmount = reservation.getTotalAmt();
        int discountAmount = 0;

        Integer couponSeq = reservation.getCouponSeq();
        if (couponSeq != null) {
            Coupon coupon = couponService.getCouponBySeq(couponSeq);
            if (coupon != null) {
                if (coupon.getDiscountRate() != 0) {  // 할인율이 0이 아닌 경우
                    discountAmount = (int) Math.round(baseAmount * coupon.getDiscountRate() / 100.0);
                } else if (coupon.getDiscountAmt() != 0) {  // 할인금액이 0이 아닌 경우
                    discountAmount = coupon.getDiscountAmt();
                }
            }
        }

        int finalAmount = baseAmount - discountAmount;
        return finalAmount < 0 ? 0 : finalAmount;
    }


}