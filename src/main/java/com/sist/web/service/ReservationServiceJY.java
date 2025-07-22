package com.sist.web.service;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
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
	private Logger logger = LoggerFactory.getLogger(ReservationServiceJY.class);
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
        System.out.println("11111111111 [calculateFinalAmount Start] 1111111111111");
        int baseAmount = reservation.getTotalAmt();
        int discountAmount = 0;

        Integer couponSeq = reservation.getCouponSeq();
        if (couponSeq != null) {
            Coupon coupon = couponService.getCouponBySeq(couponSeq);
            
            System.out.println("222222222222 [calculateFinalAmount couponService.getCouponBySeq 실행] 222222222222");
            if (coupon != null) {
            	reservation.setCouponSeq(couponSeq);
                boolean isValidStatus = "Y".equals(coupon.getCpnStat());
                boolean isValidAmount = baseAmount >= (coupon.getMinOrderAmt() != 0 ? coupon.getMinOrderAmt() : 0);

                Date startDate = null;
                Date endDate = null;
                SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");  // 날짜 포맷에 맞게 변경 필요
                
                try {
                    if (coupon.getIssueStartDt() != null && !coupon.getIssueStartDt().isEmpty()) {
                        startDate = sdf.parse(coupon.getIssueStartDt());
                    }
                    if (coupon.getIssueEndDt() != null && !coupon.getIssueEndDt().isEmpty()) {
                        endDate = sdf.parse(coupon.getIssueEndDt());
                    }
                } catch (ParseException e) {
                    e.printStackTrace();  // 또는 로그 기록
                    // 날짜 파싱 실패 시 유효기간 체크를 false로 처리할 수도 있음
                }

                boolean isValidDate = isWithinDateRange(startDate, endDate);
 
                if (isValidStatus && isValidAmount && isValidDate) {
                    if (coupon.getDiscountRate() != 0 && coupon.getDiscountRate() > 0) {
                        discountAmount = (int) Math.round(baseAmount * coupon.getDiscountRate() / 100.0);
                    } else if (coupon.getDiscountAmt() != 0 && coupon.getDiscountAmt() > 0) {
                        discountAmount = coupon.getDiscountAmt();
                    }
                }
            }
        }

        int finalAmount = baseAmount - discountAmount;
        return Math.max(finalAmount, 0);
    }

    private boolean isWithinDateRange(Date start, Date end) {
        Date now = new Date();
        if (start != null && now.before(start)) return false;
        if (end != null && now.after(end)) return false;
        return true;
    }
    
    // 결제 완료 시 쿠폰 사용 처리 메서드 예시
    @Transactional
    public void completeReservationPayment(Reservation reservation) throws Exception {
        // 1) 예약 정보 DB에 저장 (또는 기존 예약 업데이트)
        reservationDao.insertReservation(reservation);
        
        // 2) 결제 상태를 '결제완료' 등으로 변경
        reservationDao.updatePaymentStatus(reservation.getRsvSeq(), "PAID"); // 예: PAID 상태
        
        // 3) 쿠폰 사용 처리 (쿠폰 번호 및 사용자 아이디가 존재하는 경우만)
        if (reservation.getCouponSeq() != null && reservation.getGuestId() != null && !reservation.getGuestId().trim().isEmpty()) {
            couponService.markCouponAsUsed(reservation.getGuestId(), reservation.getCouponSeq());
        }
    }

    // 기존 insertReservation 메서드에 결제 및 쿠폰 사용까지 포함하는 방식도 가능
    @Transactional
    public void insertReservationWithPayment(Reservation reservation) throws Exception {
        System.out.println("insertReservationWithPayment 호출됨");
        insertReservation(reservation);  // 기존 예약 등록 메서드 재사용
        
        updatePaymentStatus(reservation.getRsvSeq(), "PAID");
        
        if (reservation.getCouponSeq() != null && reservation.getGuestId() != null && !reservation.getGuestId().trim().isEmpty()) {
            System.out.println("쿠폰 사용 처리 시작");
            couponService.markCouponAsUsed(reservation.getGuestId(), reservation.getCouponSeq());
            System.out.println("쿠폰 사용 처리 완료");
        }
    }


    //호스트 ID로 예약 리스트 조회(호스트페이지 - 판매 내역에 사용)
    public List<Reservation> reservationsListByHostId(String hostId)
    {
    	List<Reservation> list = null;
    	
    	try
    	{
    		list = reservationDao.reservationsListByHostId(hostId);
    	}
    	catch(Exception e)
    	{
    		logger.error("[reservationService]reservationsListByHostId Exception", e);
    	}
    	
    	return list;
    }
    
}