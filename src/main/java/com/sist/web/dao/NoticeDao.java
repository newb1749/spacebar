package com.sist.web.dao;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.sist.web.model.Notice;
import com.sist.web.model.NoticeReply;

@Repository
public interface NoticeDao {
    List<Notice> selectNoticeList();
    Notice selectNoticeById(int noticeSeq);
    void insertNotice(Notice dto);
    void insertReply(NoticeReply reply);
    List<NoticeReply> selectRepliesByNotice(int noticeSeq);
}
