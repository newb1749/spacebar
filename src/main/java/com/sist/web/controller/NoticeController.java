package com.sist.web.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.sist.web.model.Response;
import com.sist.web.controller.NoticeController;
import com.sist.web.model.Notice;
import com.sist.web.model.NoticeReply;
import com.sist.web.service.NoticeService;

@Controller
@RequestMapping("/notice")
public class NoticeController {
	
	private static final Logger logger = LoggerFactory.getLogger(NoticeController.class);


    @Autowired
    private NoticeService noticeService;
    
    @Value("#{env['auth.session.name']}")
    private String AUTH_SESSION_NAME;

    @GetMapping("/list")
    public String list(Model model) {
        model.addAttribute("noticeList", noticeService.getNoticeList());
        return "/notice/noticeList";
    }

    @GetMapping("/detail")
    public String detail(@RequestParam int noticeSeq, Model model) {
        Notice notice = noticeService.getNoticeById(noticeSeq);
        
        List<NoticeReply> noticeReplies = noticeService.getReplies(noticeSeq);

        if (notice == null) {
            return "redirect:/notice/list";
        }

        model.addAttribute("notice", notice);
        model.addAttribute("noticeReplies", noticeReplies);
        return "/notice/noticeDetail"; // 뷰 이름만 리턴
    }
    
    @PostMapping("/reply/editProc")
    @ResponseBody
    public Response<Object> editReply(
            @RequestParam int replySeq,
            @RequestParam String replyContent,
            HttpSession session) {

        Response<Object> ajax = new Response<>();
        String userId = (String) session.getAttribute(AUTH_SESSION_NAME);

        if (userId == null) {
            ajax.setResponse(500, "로그인 후 이용하세요.");
            return ajax;
        }

        // (서비스에 위임) 댓글 소유자 확인 & 업데이트
        boolean ok = noticeService.updateReply(replySeq, userId, replyContent);
        if (ok) {
            ajax.setResponse(0, "수정되었습니다.");
        } else {
            ajax.setResponse(400, "수정 권한이 없거나 실패했습니다.");
        }
        return ajax;
    }
    
    @PostMapping("/reply/deleteProc")
    @ResponseBody
    public Response<Object> deleteReply(
            @RequestParam("replySeq") int replySeq,
            HttpSession session) {

        Response<Object> ajax = new Response<>();
        String userId = (String) session.getAttribute(AUTH_SESSION_NAME);
        if (userId == null) {
            ajax.setResponse(500, "로그인 후 이용하세요.");
            return ajax;
        }

        boolean ok = noticeService.deleteReply(replySeq, userId);
        if (ok) {
            ajax.setResponse(0, "삭제되었습니다.");
        } else {
            ajax.setResponse(400, "삭제 권한이 없거나 실패했습니다.");
        }
        return ajax;
    }

    

    @PostMapping("/reply")
    public String reply(@ModelAttribute NoticeReply replyDTO, HttpServletRequest request) {
        String userId = (String) request.getSession().getAttribute(AUTH_SESSION_NAME);
        replyDTO.setUserId(userId);
        noticeService.writeReply(replyDTO);
        return "redirect:/notice/detail?noticeSeq=" + replyDTO.getNoticeSeq();
    }
}
