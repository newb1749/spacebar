package com.sist.web.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sist.web.dao.NoticeDao;
import com.sist.web.model.Notice;
import com.sist.web.model.NoticeReply;

import java.util.List;

@Service
public class NoticeService {

    @Autowired
    private NoticeDao noticeDao;

    public List<Notice> getNoticeList() {
        return noticeDao.selectNoticeList();
    }

    // 공지사항 상세 조회
    public Notice getNoticeById(int noticeSeq) {
        Notice notice = noticeDao.selectNoticeDetail(noticeSeq);
        if (notice != null) {
            // 공지사항 상세와 함께 댓글도 같이 가져옴
            notice.setReplies(noticeDao.selectRepliesByNotice(noticeSeq));
        }
        return notice;
    }

    public void writeNotice(Notice dto) {
        noticeDao.insertNotice(dto);
    }

    // 댓글 등록
    public void writeReply(NoticeReply reply) {
        noticeDao.insertReply(reply);
    }

    public List<NoticeReply> getReplies(int noticeSeq) {
        return noticeDao.selectRepliesByNotice(noticeSeq);
    }
    
    //댓글수정
    public boolean updateReply(int replySeq, String userId, String replyContent) {
        int updated = noticeDao.updateReply(replySeq, userId, replyContent);
        return updated > 0;
    }
    
    //댓글삭제
    public boolean deleteReply(int replySeq, String userId) {
        int cnt = noticeDao.deleteReply(replySeq, userId);
        return cnt > 0;
    }
}
