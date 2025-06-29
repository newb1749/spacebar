package com.sist.web.controller;

import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.sist.common.util.StringUtil;
import com.sist.web.model.ChatMessage;
import com.sist.web.model.ChatRoom;
import com.sist.web.model.Response;
import com.sist.web.service.ChatService;
import com.sist.web.util.SessionUtil;

import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;

@Controller("chatController")
public class ChatController {
	private static Logger logger = LoggerFactory.getLogger(ChatController.class);
	
	@Autowired
	private ChatService chatService;
	
	
	// 내 채팅 목록 페이지로 이동
	@RequestMapping(value="/chat/list", method=RequestMethod.GET)
	public String chatListPage(Model model, HttpServletRequest request)
	{	
		
		HttpSession session = request.getSession();
		
        // --- 테스트를 위한 하드코딩 ---
        // 실제 로그인 기능이 구현되면 이 3줄은 반드시 삭제해야 합니다.
        // 현재 사용자를 "userA"로 강제 로그인 처리
        SessionUtil.setSession(session, "USER_ID", "userA");
        // --- 여기까지 ---
        
		String userId = (String) SessionUtil.getSession(session, "USER_ID");
		
		// 로그인 했는지 확인
		if(userId == null) {
			return "redirect:/user/login";
		}
		
		List<ChatRoom> myChatRooms = chatService.findMyChatRooms(userId);
		model.addAttribute("myChatRooms", myChatRooms);
		
		return "/chat/list";
	}
	
	
	// 특정 사용자와 1:1 채팅 시작(방 없으면 생성)
	@RequestMapping(value="/chat/start", method=RequestMethod.GET)
	public String startChat(@RequestParam("otherUserId") String otherUserId, HttpServletRequest request)
	{
		HttpSession session = request.getSession();
		
        // --- 테스트를 위한 하드코딩 ---
        SessionUtil.setSession(session, "USER_ID", "userA");
        // --- 여기까지 ---
        
		String currentUserId = (String) SessionUtil.getSession(session, "USER_ID");
		
        // 나와 상대방의 아이디가 같으면 채팅을 시작할 수 없음
        if (StringUtil.equals(otherUserId, currentUserId)) {
            return "redirect:/somewhere/error"; // 에러 페이지로 리다이렉트
        }
        
        ChatRoom chatRoom = chatService.findOrCreateChatRoom(currentUserId, otherUserId);
        
        // 생성,조회된 채팅방 페이지로 리다이렉트
        return "redirect:/chat/room?chatRoomSeq=" + chatRoom.getChatRoomSeq();		
	}
	
	
	// 채팅방 페이지로 이동
	@RequestMapping(value="/chat/room", method=RequestMethod.GET)
    public String chatRoomPage(@RequestParam("chatRoomSeq") int chatRoomSeq, Model model, HttpServletRequest request) {
        HttpSession session = request.getSession();
        
        // --- 테스트를 위한 하드코딩 ---
        SessionUtil.setSession(session, "USER_ID", "userA");    
        // --- 여기까지 ---
        
        String userId = (String) SessionUtil.getSession(session, "USER_ID");

        if (userId == null) {
            return "redirect:/user/login";
        }
        
        model.addAttribute("chatRoomSeq", chatRoomSeq);
        
        return "/chat/room"; 
    }
	

	
	// 특정 채팅방의 메시지 목록을 조회(AJAX)
	@RequestMapping(value="/chat/message", method=RequestMethod.GET)
	@ResponseBody
	public ResponseEntity<Response<List<ChatMessage>>> getMessages(@RequestParam(value="chatRoomSeq", required=false) Integer chatRoomSeq, HttpServletRequest request) {
		
	    if (chatRoomSeq == null) {
	        logger.warn("chatRoomSeq is missing from the request.");
	        // 파라미터가 없다는 명시적인 에러 메시지를 클라이언트로 보냄
	        return ResponseEntity.badRequest().body(new Response<>(400, "chatRoomSeq 파라미터가 누락되었습니다."));
	    }
	    
	    HttpSession session = request.getSession();
	    
        // --- 테스트를 위한 하드코딩 ---
        SessionUtil.setSession(session, "USER_ID", "userA");
        // --- 여기까지 ---
        
	    String userId = (String) SessionUtil.getSession(session, "USER_ID");

	    if (userId == null) {
            // 이 부분은 Response(int code, String msg) 생성자를 사용하므로 기존 코드 유지
	        return ResponseEntity.status(401).body(new Response<>(401, "Unauthorized"));
	    }
	    
	    List<ChatMessage> messages = chatService.findMessagesByRoomSeq(chatRoomSeq, userId);
	    
	    // 성공 시 code(0)와 msg("SUCCESS")를 함께 전달
	    return ResponseEntity.ok(new Response<>(0, "SUCCESS", messages));
	}
	
	
	// 메시지 전송
	@RequestMapping(value="/chat/message", method=RequestMethod.POST)
    @ResponseBody
    public ResponseEntity<Response<ChatMessage>> sendMessage(@RequestBody ChatMessage chatMessage, HttpServletRequest request) {
        HttpSession session = request.getSession();
        
        // --- 테스트를 위한 하드코딩 ---
        SessionUtil.setSession(session, "USER_ID", "userA");
        // --- 여기까지 ---
        
        String senderId = (String) SessionUtil.getSession(session, "USER_ID");

        if (senderId == null) {
            return ResponseEntity.status(401).body(new Response<>(401, "Unauthorized"));
        }
        
        chatMessage.setSenderId(senderId);
        ChatMessage sentMessage = chatService.sendMessage(chatMessage);
        
        if (sentMessage != null) {
            // 성공 시 code(0)와 msg("SUCCESS")를 함께 전달
            return ResponseEntity.ok(new Response<>(0, "SUCCESS", sentMessage));
        } else {
            return ResponseEntity.status(500).body(new Response<>(500, "Failed to send message"));
        }
    }
	
	
//    /**
//     * WebSocket/STOMP를 통해 들어오는 메시지를 처리합니다.
//     * 클라이언트가 "/app/chat.sendMessage/{chatRoomSeq}"로 메시지를 보내면 이 메서드가 호출됨
//     * * @param chatRoomSeq 메시지를 보낼 채팅방 시퀀스
//     * @param chatMessage 클라이언트가 보낸 메시지 정보 (JSON)
//     * @return 모든 구독자에게 전달될 최종 메시지
//     */
//	@MessageMapping("/chat/sendMessage/{chatRoomSeq}")
//	@SendTo("/topic/chat/room/{chatRoomSeq}")	// 이 주소를 구독하는 클라이언트에게 메시지를 브로드캐스트함
//	public ChatMessage sendMessageStomp(@DestinationVariable int chatRoomSeq, ChatMessage chatMessage)
//	{
//		// 보낸 사람, 방 번호 등 추가 정보 설정
//		// (하드코딩된 세션에서 가져오거나 chatMessage에 담겨온 정보를 신뢰)
//		chatMessage.setSenderId("userA");	// 실제 인증 정보 필요!! 임시
//		chatMessage.setChatRoomSeq(chatRoomSeq);
//		// 서버에서 현재 시간 설정
//		chatMessage.setSendDate(new Date());
//		// 메시지를 DB에 저장
//		chatService.sendMessage(chatMessage);
//		
//		// NICKNAME 등 추가 정보를 다시 조회해서 채워넣으면 더 좋음
//		// 현재는 클라이언트에서 받은 내용을 그대로 다시 보냄
//		// ex: chatMessage.setSenderName("테스트A");  <-- 닉네임
//		
//		return chatMessage;
//	}
}
