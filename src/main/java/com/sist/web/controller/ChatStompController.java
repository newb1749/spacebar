package com.sist.web.controller;

import java.util.Date;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.stereotype.Controller;

import com.sist.web.model.ChatMessage;
import com.sist.web.service.ChatService;

@Controller
public class ChatStompController { // 새로운 컨트롤러 클래스
    private static Logger logger = LoggerFactory.getLogger(ChatStompController.class);

    @Autowired
    private ChatService chatService;

    /**
     * WebSocket/STOMP를 통해 들어오는 메시지를 처리합니다.
     */
    @MessageMapping("/chat/sendMessage/{chatRoomSeq}")
    @SendTo("/topic/chat/room/{chatRoomSeq}")
    public ChatMessage sendMessageStomp(@DestinationVariable int chatRoomSeq, ChatMessage chatMessage) {
        logger.debug("STOMP Message Received: ", chatMessage.getMessageContent());

        // 실제 세션에서 보낸 사람 ID 가져오기 (지금은 테스트용)
        String senderId = "userA"; 
        chatMessage.setSenderId(senderId);

        // 클라이언트에서 온 닉네임이 없다면 DB에서 조회하거나 테스트용으로 설정
        if (chatMessage.getSenderName() == null || chatMessage.getSenderName().isEmpty()) {
            chatMessage.setSenderName("테스트A"); // 닉네임이 없는 경우를 위한 방어 코드
        }

        // 방 번호와 서버 시간 설정
        chatMessage.setChatRoomSeq(chatRoomSeq);
        chatMessage.setSendDate(new Date());
        
        // 메시지를 DB에 저장
        chatService.sendMessage(chatMessage);
        
        return chatMessage;
    }
}