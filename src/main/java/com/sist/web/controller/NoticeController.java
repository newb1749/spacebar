//package com.sist.web.controller;
//
//import javax.servlet.http.HttpSession;
//
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.stereotype.Controller;
//import org.springframework.ui.Model;
//import org.springframework.web.bind.annotation.GetMapping;
//import org.springframework.web.bind.annotation.ModelAttribute;
//import org.springframework.web.bind.annotation.PostMapping;
//import org.springframework.web.bind.annotation.RequestMapping;
//import org.springframework.web.bind.annotation.RequestParam;
//
//import com.sist.web.model.Notice;
//import com.sist.web.model.NoticeReply;
//import com.sist.web.service.NoticeService;
//
//@Controller
//@RequestMapping("/notice")
//public class NoticeController {
//
//    @Autowired
//    private NoticeService noticeService;
//
//    @GetMapping("/list")
//    public String list(Model model) {
//        model.addAttribute("noticeList", noticeService.getNoticeList());
//        return "/notice/noticeList";
//    }
//
//    @GetMapping("/detail")
//    public String detail(@RequestParam int noticeSeq, Model model) {
//        model.addAttribute("notice", noticeService.getNoticeById(noticeSeq));
//        return "/notice/noticeDetail";
//    }
//
//    @GetMapping("/write")
//    public String writeForm(HttpSession session) {
//        if (!"ADMIN".equals(session.getAttribute("sessionRole"))) {
//            return "redirect:/notice/list";
//        }
//        return "/notice/noticeForm";
//    }
//
//    @PostMapping("/write")
//    public String write(@ModelAttribute Notice dto, HttpSession session) {
//        dto.setAdminId((String) session.getAttribute("sessionUserId"));
//        noticeService.writeNotice(dto);
//        return "redirect:/notice/list";
//    }
//
//    @PostMapping("/reply")
//    public String reply(@ModelAttribute NoticeReply reply, HttpSession session) {
//        reply.setUserId((String) session.getAttribute("sessionUserId"));
//        noticeService.writeReply(reply);
//        return "redirect:/notice/detail?noticeSeq=" + reply.getNoticeSeq();
//    }
//}
