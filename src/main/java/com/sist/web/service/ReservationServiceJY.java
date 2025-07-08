package com.sist.web.service;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.sist.web.dao.ReservationDao;
import com.sist.web.model.Reservation;
import com.sist.web.model.RoomType;

@Service
public class ReservationServiceJY 
{
    @Autowired
    private ReservationDao reservationDao;
    
    @Autowired
    private RoomServiceJY roomService;
    
    @Autowired
    private RoomTypeServiceJY roomTypeService;
    
    /**
     * 예약 등록 - hostId 자동 설정 포함
     */
    @Transactional
    public void insertReservation(Reservation reservation) throws Exception
    {
        // 🔥 디버깅 로그 추가
        System.out.println("=== insertReservation 시작 ===");
        System.out.println("전달받은 roomTypeSeq: " + reservation.getRoomTypeSeq());
        System.out.println("전달받은 hostId: " + reservation.getHostId());
        
        // 🔥 hostId 검증 및 설정
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
        
        // 🔥 최종 검증
        if (reservation.getHostId() == null || reservation.getHostId().trim().isEmpty()) {
            throw new IllegalArgumentException("HOST_ID가 설정되지 않았습니다.");
        }
        
        // 🔥 필수 필드 검증
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
    public void cancelReservation(Reservation reservation) throws Exception
    {
        reservationDao.cancelReservation(reservation);
    }
}