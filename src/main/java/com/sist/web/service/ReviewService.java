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
	
	/**
	 * 내 목록 조회
	 * @param userId 회원 고유아이디
	 * @return 본인의 리뷰 목록
	 */
	public List<Review> selectMyReviews(String userId)
	{
		return reviewDao.selectMyReviews(userId);
	}
	
	/**
	 * 수정할 리뷰 1건 조회 (이미지 포함)
	 * @param reviewSeq 리뷰 고유아이디
	 * @return 선택한 리뷰 객체
	 */
	public Review selectReviewForEdit(int reviewSeq)
	{
		return reviewDao.selectReviewForEdit(reviewSeq);
	}
	
	
	
    /**
     * 리뷰 수정 (텍스트, 평점, 이미지)
     * @param review 수정할 내용이 담긴 객체
     * @param deleteImgSeqs 삭제할 이미지의 번호(reviewImgSeq) 목록
     * @return 성공 시 1 이상
     */
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public int updateReviewTransaction(Review review, List<Short> deleteImgSeqs) throws Exception
	{
		int result = 0;
		
		// 1. 텍스트 정보 수정 (제목, 내용, 평점)
		result += reviewDao.updateReview(review);
		
		// 2. 선택된 기존 이미지 삭제
		if(deleteImgSeqs != null && !deleteImgSeqs.isEmpty())
		{	
			// 선택된 이미지들 삭제
			for(short imgSeq : deleteImgSeqs)
			{	
				ReviewImage delImage = new ReviewImage();
				delImage.setReviewSeq(review.getReviewSeq());
				delImage.setReviewImgSeq(imgSeq);
				
                // 업로드한 파일을 실제로 삭제하기 위해 파일명 조회
				ReviewImage imageToDelete = reviewImageDao.selectReviewImage(delImage);
                if (imageToDelete != null) {
                    FileUtil.deleteFile(UPLOAD_REVIEW_DIR + File.separator + imageToDelete.getReviewImgName());
                }
				// DB에서 선택된 이미지 1개 삭제
				reviewImageDao.deleteReviewImage(delImage);			
			}
		}
		
		// 3. 새로 첨부된 이미지 추가
		List<ReviewImage> newImageList = review.getReviewImageList();
		if(newImageList != null && !newImageList.isEmpty())
		{
			for(ReviewImage newImage : newImageList)
			{
				newImage.setReviewSeq(review.getReviewSeq());
				saveReviewImageFile(newImage, review.getReviewSeq());
				result += reviewImageDao.insertReviewImage(newImage);
			}
		}
		
		return result;
	}

    /**
     * 리뷰 비활성화 (소프트 삭제)
     * @param review reviewSeq와 userId 포함
     * @return 성공 시 1
     */
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor = Exception.class)
	public int inactiveReview(Review review) throws Exception
	{
		return reviewDao.inactiveReview(review);
	}
}
