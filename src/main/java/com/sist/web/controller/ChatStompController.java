package com.sist.web.controller;

import java.util.Date;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.stereotype.Controller;

import com.sist.common.util.StringUtil;
import com.sist.web.model.ChatMessage;
import com.sist.web.model.User_mj;
import com.sist.web.service.ChatService;
import com.sist.web.service.UserService_mj;

@Controller
public class ChatStompController { 
    private static Logger logger = LoggerFactory.getLogger(ChatStompController.class);

    @Autowired
    private ChatService chatService;
    
    @Autowired
    private UserService_mj userService;

    /**
     * WebSocket/STOMP를 통해 들어오는 메시지를 처리.
     */
    @MessageMapping("/chat/sendMessage/{chatRoomSeq}")
    @SendTo("/topic/chat/room/{chatRoomSeq}")
    public ChatMessage sendMessageStomp(@DestinationVariable int chatRoomSeq, ChatMessage chatMessage) {
        logger.debug("STOMP Message Received: ", chatMessage.getMessageContent());

        String senderId = chatMessage.getSenderId();

        User_mj sender = userService.userSelect(senderId);
        
        if(sender != null)
        {
        	// 별명, 이미지확장자 
        	chatMessage.setSenderName(sender.getNickName());
        	chatMessage.setSenderProfileImgExt(sender.getProfImgExt());
        }
        else
        {
        	// 비정상적인 접근일 수 있으므로 로깅 및 예외처리
        	logger.warn("Cannot find user with ID: " + senderId + ". Using senderName from client.");
        	// 클라이언트가 보낸 닉네임이 없다면 '일 수 없음'으로 처리
        	if(StringUtil.equals(chatMessage.getSenderName(), "") || StringUtil.isEmpty(chatMessage.getSenderName()))
        	{
        		chatMessage.setSenderName("알수없음");
        	}
        }

        // 방 번호와 서버 시간 설정
        chatMessage.setChatRoomSeq(chatRoomSeq);
        chatMessage.setSendDate(new Date());
        
        // 메시지를 DB에 저장
        chatService.sendMessage(chatMessage);
        
        return chatMessage;
    }
}