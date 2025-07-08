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
import com.sist.web.model.User;
import com.sist.web.service.ChatService;
import com.sist.web.service.UserService_mj;

@Controller
public class ChatStompController { 
    private static Logger logger = LoggerFactory.getLogger(ChatStompController.class);

    @Autowired
    private ChatService chatService;
    
    @Autowired
    private UserService_mj userService_mj; // 이름을 userService_mj로 명확히 함

    /**
     * WebSocket/STOMP를 통해 들어오는 메시지를 처리.
     */
    @MessageMapping("/chat/sendMessage/{chatRoomSeq}")
    @SendTo("/topic/chat/room/{chatRoomSeq}")
    public ChatMessage sendMessageStomp(@DestinationVariable int chatRoomSeq, ChatMessage chatMessage) {
        
        logger.debug("STOMP Message Received: {}", chatMessage.getMessageContent());
        
        // senderId는 클라이언트가 보낸 chatMessage 객체에서 직접 가져옵니다.
        String senderId = chatMessage.getSenderId();
        
        // senderId로 DB에서 사용자 정보를 다시 조회하여 닉네임과 프로필 정보를 덮어씁니다.
        User sender = userService_mj.userSelect(senderId);
        
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
        
        return chatMessage;
    }
}