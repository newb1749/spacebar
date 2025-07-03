package com.sist.web.service;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.sist.common.util.FileUtil;
import com.sist.common.util.StringUtil;
import com.sist.web.dao.ReviewDao;
import com.sist.web.dao.ReviewImageDao;
import com.sist.web.model.Reservation;
import com.sist.web.model.Review;
import com.sist.web.model.ReviewImage;
import com.sist.web.model.RoomImage;

import java.io.File;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;

@Service("reviewService")
public class ReviewService {
	
			// 1. 예약 테이블에서 RSV_STAT = 'CONFIRMED'
			// and RSV_PAYMENT_STAT = 'PIAD' 인지 확인

			// 2. 리뷰 등록

			// 3. 리뷰 이미지 등록

			// 4. 리뷰 평점 등록
	private static Logger logger = LoggerFactory.getLogger(ReviewService.class);
	
	@Value("#{env['upload.review.dir']}")
	private String UPLOAD_REVIEW_DIR;
	
	@Autowired
	ReviewDao reviewDao;
	
	@Autowired
	ReviewImageDao reviewImageDao;
	
	/**
	 * 리뷰 등록, 트랜잭션을 통해 이미지도 같이
	 * @param review 리뷰 객체를 통해 데이터 받기
	 * @return 
	 */
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public int insertReviewTransaction(Review review)
	{
		int result = 0;
		
		try
		{	
			if(review != null)
			{
				int rsvSeq = review.getRsvSeq();
				review.setRsvSeq(rsvSeq);
				// 1. 리뷰 등록 전 예약 및 결제 상태 확인을 위해
				Reservation reservation = reviewDao.findStatbyRsvSeq(rsvSeq);
				if(reservation == null) {
					logger.warn("예약 정보를 찾을 수 없습니다. rsvSeq: {}", rsvSeq);
					return 0;
				}
				
				// 2. 예약 확정, 결제 완료 일 떄
				if(StringUtil.equals(reservation.getRsvStat(), "CONFIRMED") 
						&& StringUtil.equals(reservation.getRsvPaymentStat(), "PAID"))
				{
					result += reviewDao.insertReview(review);
					// 리뷰이미지한테 건네주기
					int newReviewSeq = review.getReviewSeq();
					logger.debug("새로 생성된 리뷰 시퀀스: {}", newReviewSeq);
					
					// 3. 리뷰 이미지 저장
					List<ReviewImage> reviewImageList = review.getReviewImageList();
					if(reviewImageList != null && reviewImageList.size() > 0)
					{
						for(ReviewImage reviewImage : reviewImageList)
						{	
							// 이게 흠??
							reviewImage.setReviewSeq(newReviewSeq);
							
							// 위에서 받은 값들 넣어서 리뷰 이미지 객체에 데이터 넣기
							saveReviewImageFile(reviewImage, newReviewSeq);
							
							int imageResult = reviewImageDao.insertReviewImage(reviewImage);
							result += imageResult;
							logger.debug("리뷰 이미지 저장 결과: {}, 파일명: {}", imageResult, reviewImage.getReviewImgName());
						}
					}
					else
					{
						logger.debug("첨부된 이미지가 없습니다....roomImageList == null 혹은 roomImageList.size()가 0이거나 이하");
					}
				}
				else
				{
					// 예약 확정, 결제 완료 아닐 떄!
					logger.warn("리뷰 등록 조건 미충족 - 예약상태: {}, 결제상태: {}", 
							reservation.getRsvStat(), reservation.getRsvPaymentStat());
					return 0;
				}
			}
		}
		catch(Exception e)
		{
            logger.error("[ReviewService] insertReviewTransaction 처리 중 오류 발생", e);
            throw e;		
		}
		
		
		return result;
	}
	
	
	/**
	 * ReviewImage 파일을 저장하고 모델에 관련 정보를 채우는 헬퍼 메소드
	 * @param reviewImage 리뷰이미지 객체
	 * @param newReviewSeq 리뷰 시퀀스 넣어서
	 */
	private void saveReviewImageFile(ReviewImage reviewImage, int newReviewSeq)
	{
		try
		{
			if(reviewImage == null || reviewImage.getFile() == null || reviewImage.getFile().isEmpty())
			{
				logger.debug(">> 파일 없음: reviewImage 또는 file 이 null/empty");
				return;
			}
			// 이미지 파일 정보 가져오기
			MultipartFile file = reviewImage.getFile();
			// 원본이름 
			String originalFileName = file.getOriginalFilename();
			// 확장자 추출
			String reviewImgExt = FileUtil.getFileExtension(file.getOriginalFilename());
			// 업로드 경로
			String saveDir = UPLOAD_REVIEW_DIR;
			logger.debug(">> 이미지 UPLOAD_REVIEW_DIR 저장 경로: {}", saveDir);
    		// 디렉토리가 존재하면 구분하는 코드가 포함되어 있음
    		FileUtil.createDirectory(saveDir);
    		
    		// reviewImgSeq 부여하기 위해서 (1부터 시작)
    		short maxReviewImgSeq = reviewImageDao.selectMaxReviewImgSeq(newReviewSeq);
    		short reviewImgSeq = (short)(maxReviewImgSeq + 1);
    		
    		// 파일 이름 설정(리뷰시퀀스_이미지시퀀스.확장자)
    		String fileName = newReviewSeq + "_" + reviewImgSeq + "." + reviewImgExt;
    		// 파일저장
    		File saveFile = new File(saveDir + File.separator + fileName);
    		file.transferTo(saveFile);
    		
    		// 나머지 데이터 채우기
    		reviewImage.setReviewImgSeq(reviewImgSeq);
    		reviewImage.setReviewImgOrigName(originalFileName);
    		reviewImage.setReviewImgName(fileName); // 바꾼 이름
    		reviewImage.setReviewImgExt(reviewImgExt);
    		reviewImage.setImgSize((int)file.getSize());
    		
			logger.debug("이미지 파일 저장 완료 - 원본명: {}, 저장명: {}, 크기: {}", 
					originalFileName, fileName, file.getSize());
		}
		catch(Exception e)
		{
			logger.error("[ReviewService] saveReviewImageFile 처리 중 오류 발생", e);
			throw new RuntimeException("이미지 파일 저장 중 오류가 발생했습니다.", e);
		}
	}
}
