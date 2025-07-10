package com.sist.web.controller;

import java.security.Principal;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.Header;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;


import com.sist.web.model.ChatMessage;
import com.sist.web.model.User;
import com.sist.web.service.ChatService;
import com.sist.web.service.UserService_mj;
import com.sist.web.util.SessionUtil;

@Controller
public class ChatStompController { 
    private static Logger logger = LoggerFactory.getLogger(ChatStompController.class);

	@Value("#{env['auth.session.name']}")
	private String AUTH_SESSION_NAME;
	
    @Autowired
    private ChatService chatService;
    
    @Autowired
    private UserService_mj userService; 
    
    // 메시지를 직접 보낼 수 있는 메시징 템플릿을 주입받음
    @Autowired
    private SimpMessagingTemplate messagingTemplate; // @SendTo 대신 사용하면 바로 송수신됨
    
    /**
     * WebSocket/STOMP를 통해 들어오는 메시지를 처리.
    */
    @MessageMapping("/chat/sendMessage/{chatRoomSeq}")
    @SendTo("/topic/chat/room/{chatRoomSeq}") // 1. 채팅방의 모두에게 새 메시지 전송(1:N)ㅇ
public ChatMessage sendMessageStomp(@DestinationVariable int chatRoomSeq, ChatMessage chatMessage, @Header("simpSessionAttributes") Map<String, Object> sessionAttributes) {
        
        // 1. Principal 객체에서 현재 사용자 ID를 가져옵니다. (HandshakeInterceptor 덕분에 가능)
    	String senderId = (String) sessionAttributes.get("sessionUserId");
        chatMessage.setSenderId(senderId);
        
<<<<<<< HEAD
        // senderId는 클라이언트가 보낸 chatMessage 객체에서 직접 가져옵니다.
        String senderId = chatMessage.getSenderId();
        
        // senderId로 DB에서 사용자 정보를 다시 조회하여 닉네임과 프로필 정보를 덮어씁니다.
        User sender = userService_mj.userSelect(senderId);
        
        if(sender != null)
        {
=======
        User sender = userService.userSelect(senderId);
        if(sender != null) {
>>>>>>> base
            chatMessage.setSenderName(sender.getNickName());
            chatMessage.setSenderProfileImgExt(sender.getProfImgExt());
        }
       
        logger.debug("[DEBUG] senderId = " + senderId);
        
        chatMessage.setChatRoomSeq(chatRoomSeq);
        chatMessage.setSendDate(new Date());
        
        chatService.sendMessage(chatMessage);
        
        // 2. 상대방에게만 "목록 업데이트" 알림을 개인 큐로 전송합니다.
        List<String> userIds = chatService.findUserIdsByRoomSeq(chatRoomSeq);
        if (userIds != null) {
            for (String userId : userIds) {
            	logger.debug("[DEBUG] userId = {}, senderId = {}", userId, senderId);

                if (!userId.equals(senderId)) {
                	// convertAndSendToUser 사용하려면 WebSocket 세션에 principal 필요하다...
                    // simpMessagingTemplate.convertAndSendToUser()를 사용합니다.
                	logger.debug("Sending to /user/{}/queue/update", userId);
                	// convertAndSendToUser는 userId가 이미 WebSocket 연결 + /user/queue/update 구독 중이어야 수신 가능
                    messagingTemplate.convertAndSendToUser(userId, "/queue/update", "new_message");
                    logger.debug("Sent update notification to user: {}", userId);
                }
            }
        }
        
        // 3. @SendTo를 통해 모든 구독자에게 메시지 객체를 반환합니다.
        return chatMessage;
    }
    
    
    
    /**
     * WebSocket/STOMP를 통해 들어오는 메시지를 처리합니다.
     * 이 메서드의 반환값은 @SendTo 경로를 구독한 모든 사용자에게 전송됩니다.
     
    @MessageMapping("/chat/sendMessage/{chatRoomSeq}")
    public void sendMessageStomp(@DestinationVariable int chatRoomSeq, ChatMessage chatMessage, 
    		@Header("simpSessionAttributes") Map<String, Object> sessionAttributes) {
        
        String senderId = (String)SessionUtil.getSession(request.getSession(), AUTH_SESSION_NAME);
        
        // 1. DB에서 사용자 정보를 조회하여 닉네임, 프로필 이미지 등 정확한 정보 설정
        User sender = userService.userSelect(senderId);
        if(sender != null) {
            chatMessage.setSenderName(sender.getNickName());
            chatMessage.setSenderProfileImgExt(sender.getProfImgExt());
        } else {
            logger.warn("Cannot find user with ID: {}", senderId);
            chatMessage.setSenderName("알수없음");
        }

        // 2. 서버 시간, 방 번호 등 추가 정보 설정
        chatMessage.setChatRoomSeq(chatRoomSeq);
        chatMessage.setSendDate(new Date());
        
        // 3. 메시지를 DB에 저장
        chatService.sendMessage(chatMessage);
        
        // 4. 채팅방의 다른 참여자에게 목록 업데이트 알림 전송 (별도 처리)
        notifyChatListUpdate(chatRoomSeq, senderId);
        
        // 5. 모든 정보가 채워진 메시지 객체를 반환 -> @SendTo 경로로 브로드캐스트됨
        return chatMessage;
    }

    
     // 채팅방 참여자 중, 메시지를 보낸 사람을 제외한 나머지에게 목록 업데이트 신호를 보냅니다.
     
    private void notifyChatListUpdate(int chatRoomSeq, String senderId) {
        List<String> userIds = chatService.findUserIdsByRoomSeq(chatRoomSeq);

        if (userIds != null) {
            for (String userId : userIds) {
                // 참여자의 ID가 메시지를 보낸 사람의 ID와 같지 않을 때만 알림을 보냄
                if (!userId.equals(senderId)) {
                    String userDestination = "/topic/user/" + userId;
                    messagingTemplate.convertAndSend(userDestination, "update");
                    logger.debug("Sent update notification to OTHERS: {}", userDestination);
                }
            }
        }
    }
    */
}