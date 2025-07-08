package com.sist.web.controller;

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
    public void sendMessageStomp(@DestinationVariable int chatRoomSeq, ChatMessage chatMessage) 
    {
        
        logger.debug("STOMP Message Received: {}", chatMessage.getMessageContent());
        
        // senderId는 클라이언트가 보낸 chatMessage 객체에서 직접 가져옵니다.
        String senderId = chatMessage.getSenderId();
   
        
        // senderId로 DB에서 사용자 정보를 다시 조회하여 닉네임과 프로필 정보를 덮어씁니다.
        User sender = userService.userSelect(senderId);
        
        if(sender != null)
        {
            chatMessage.setSenderName(sender.getNickName());
            chatMessage.setSenderProfileImgExt(sender.getProfImgExt()); // 프로필 이미지 확장자 설정
        }
        else
        {
            logger.warn("Cannot find user with ID: " + senderId);
            chatMessage.setSenderName("알수없음");
        }

        // 방 번호와 서버 시간 설정
        chatMessage.setChatRoomSeq(chatRoomSeq);
        chatMessage.setSendDate(new Date());
        
        // 메시지를 DB에 저장
        chatService.sendMessage(chatMessage);
        
        // @SendTo 대신, 메시징 템플릿으로 직접 메시지를 보냄
        // 목적지 주소를 동적으로 만듦
        String destination = "/topic/chat/room/" + chatRoomSeq;
        
        // 해당 목적지를 구독하는 모든 클라이언트에게 chatMessage 객체를 JSON으로 변환하여 보냄
        messagingTemplate.convertAndSend(destination, chatMessage);
        
        /*
        // 채팅방의 '모든' 참여자에게 목록 업데이트 알림 전송
        List<String> userIds = chatService.findUserIdsByRoomSeq(chatRoomSeq);
        
        if (userIds != null) 
        {
            for (String userId : userIds) 
            {
            	// 참여자의 ID가 메시지를 보낸 사람의 ID와 같지 않을 때만 알림을 보냅니다.
                if (!userId.equals(senderId)) {
                    String userDestination = "/topic/user/" + userId;
                    messagingTemplate.convertAndSend(userDestination, "update");
                    logger.debug("Sent update notification to OTHERS: {}", userDestination);
                }
            }	
        }
        */
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