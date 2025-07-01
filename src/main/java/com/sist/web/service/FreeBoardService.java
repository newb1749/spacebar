package com.sist.web.service;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.sist.common.util.StringUtil;
import com.sist.web.dao.FreeBoardDao;
import com.sist.web.model.FreeBoard;
import com.sist.web.model.FreeBoardComment;

@Service("freeBoardService")
public class FreeBoardService {
	private static Logger logger = LoggerFactory.getLogger(FreeBoardService.class);
	
	@Value("#{env['upload.save.dir']}")
	private String UPLOAD_SAVE_DIR;
	
	@Autowired
	private FreeBoardDao freeBoardDao;
	
	//게시물 리스트
	public List<FreeBoard> boardList(FreeBoard freeBoard)
	{
		List<FreeBoard> list = null;
		
		try
		{
			list = freeBoardDao.boardList(freeBoard);
		}
		catch(Exception e)
		{
			logger.error("[FreeBoardService] boardList Exception : ", e);
		}
		
		return list;
	}
	
	//총 게시물 수
	public int boardListCount(FreeBoard freeBoard)
	{
		int count = 0;
		
		try
		{
			count = freeBoardDao.boardListCount(freeBoard);
			logger.debug("ttt : " + count);
		}
		catch(Exception e)
		{
			logger.error("[FreeBoardService] boardListCount : ", e);
		}
		
		return count;
	}
	
	//게시물 상세 조회
	public FreeBoard boardView(long freeBoardSeq, String sessionUserId)
	{
		FreeBoard freeBoard = null;
		
		try
		{
			freeBoard = freeBoardDao.boardSelect(freeBoardSeq);
			
			if(freeBoard != null)
			{
				if(sessionUserId != null && !StringUtil.equals(freeBoard.getUserId(), sessionUserId))
				{
					//조회수 증가
					freeBoardDao.boardCntPlus(freeBoardSeq);	
				}
			}
		}
		catch(Exception e)
		{
			logger.error("[FreeBoardService] boardView Exception ", e);
		}
		
		return freeBoard;
	}
	
	//게시물 등록
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
	public int boardInsert(FreeBoard freeBoard) throws Exception
	{
		int count = 0;
		
		try
		{
			count = freeBoardDao.boardInsert(freeBoard);
		}
		catch(Exception e)
		{
			logger.error("[FreeBoardService] boardInsert Exception ", e);
		}
		
		return count;
	}
	
	//댓글 리스트 조회
	public List<FreeBoardComment> commentList(long freeBoardSeq)
	{
		List<FreeBoardComment> cmtList = null;
		
		try
		{
			cmtList = freeBoardDao.commentList(freeBoardSeq);
		}
		catch(Exception e)
		{
			logger.error("[FreeBoardService] commentList Exception : ", e);
		}
		
		return cmtList;
	}
	
	// 댓글 단건 조회 (부모 댓글 정보용)
    public FreeBoardComment getCommentBySeq(long freeBoardCmtSeq) {
        FreeBoardComment comment = null;
        try {
            comment = freeBoardDao.commentSelect(freeBoardCmtSeq);
        } catch (Exception e) {
            logger.error("[FreeBoardService] getCommentBySeq Exception", e);
        }
        return comment;
    }
	
    // 댓글 등록 전 orderNo 밀어내기
    public int boardGroupOrderUpdate(FreeBoardComment comment) {
        int result = 0;
        try {
            result = freeBoardDao.boardGroupOrderUpdate(comment);
        } catch (Exception e) {
            logger.error("[FreeBoardService] boardGroupOrderUpdate Exception", e);
        }
        return result;
    }

    // 댓글 등록
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public int commentInsert(FreeBoardComment comment) {
        int result = 0;
        try {
            result = freeBoardDao.commentInsert(comment);
        } catch (Exception e) {
            logger.error("[FreeBoardService] commentInsert Exception", e);
            throw e; // 트랜잭션 롤백을 위해 예외 다시 throw
        }
        return result;
    }

   //최상위 댓글 등록 후 group_seq 업데이트
    public int updateGroupSeq(FreeBoardComment comment) {
        int result = 0;
        try {
            result = freeBoardDao.updateGroupSeq(comment);
        } catch (Exception e) {
            logger.error("[FreeBoardService] updateGroupSeq Exception", e);
        }
        return result;
    }
    
    //게시물 삭제시 댓글 수 조회
    public int boardAnswersCount(long freeBoardSeq)
	{
		int count = 0;
		
		try
		{
			count = freeBoardDao.boardAnswersCount(freeBoardSeq);
		}
		catch(Exception e)
		{
			logger.error("[FreeBoardService] boardAnswersCount Exception : ", e);
		}
		
		return count;
	}
    
    //게시물 삭제(댓글도 같이 삭제)
    @Transactional
    public int boardDelete(long freeBoardSeq) throws Exception
	{
    	int count = 0;
    	
    	try
		{
    		
    		freeBoardDao.boardCommentDelete(freeBoardSeq);
			count = freeBoardDao.boardDelete(freeBoardSeq);

		}
		catch(Exception e)
		{
			logger.error("[FreeBoardService] boardDelete Exception : ", e);
		}
		
		return count;
	}
    
    //댓글 삭제
    public int commentDelete(long freeBoardCmtSeq) throws Exception
	{
    	int count = 0;
    	
    	try
		{
    		count = freeBoardDao.commentDelete(freeBoardCmtSeq);
		}
		catch(Exception e)
		{
			logger.error("[FreeBoardService] boardDelete Exception : ", e);
		}
		
		return count;
	}
    
    //게시물 수정
    public int boardUpdate(FreeBoard freeBoard) throws Exception
	{
    	int count = 0;
    	
    	try
		{
    		count = freeBoardDao.boardUpdate(freeBoard);
		}
		catch(Exception e)
		{
			logger.error("[FreeBoardService] boardUpdate Exception : ", e);
		}
		
		return count;
	}
    
    //댓글 수정
    public int commentUpdate(FreeBoardComment freeBoardComment)
    {
    	int count = 0;
    	
    	try
    	{
    		count = freeBoardDao.commentUpdate(freeBoardComment);
    	}
    	catch(Exception e)
    	{
    		logger.error("[FreeBoardService] commentUpdate Exception : ", e);
    	}
    	
    	return count;
    }
}
