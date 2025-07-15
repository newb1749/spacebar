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

    public Notice getNoticeById(int noticeSeq) {
        Notice dto = noticeDao.selectNoticeById(noticeSeq);
        dto.setReplies(noticeDao.selectRepliesByNotice(noticeSeq));
        return dto;
    }

    public void writeNotice(Notice dto) {
        noticeDao.insertNotice(dto);
    }

    public void writeReply(NoticeReply reply) {
        noticeDao.insertReply(reply);
    }

    public List<NoticeReply> getReplies(int noticeSeq) {
        return noticeDao.selectRepliesByNotice(noticeSeq);
    }
}
