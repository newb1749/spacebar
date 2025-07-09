package com.sist.web.service;

import java.util.List;

import com.sist.web.dao.ChatDao;
import com.sist.web.model.ChatMessage;
import com.sist.web.model.ChatRoom;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service("chatService")
public class ChatService {
    private static Logger logger = LoggerFactory.getLogger(ChatService.class);

    @Autowired
    private ChatDao chatDao;

    /**
     * 특정 사용자가 참여하고 있는 모든 채팅방 목록을 조회합니다.
     * @param userId 사용자 아이디
     * @return 채팅방 목록
     */   
    public List<ChatRoom> findMyChatRooms(String userId) {
        return chatDao.findChatRoomsByUserId(userId);
    }	
	

    /**
     * 특정 채팅방의 모든 메시지를 조회하고, 상대방이 보낸 읽지 않은 메시지를 읽음 처리합니다.
     * @param chatRoomSeq 채팅방 시퀀스
     * @param readerId 현재 접속한 사용자 아이디 (메시지를 읽는 사람)
     * @return 메시지 목록
     */
    @Transactional
    public List<ChatMessage> findMessagesByRoomSeq(int chatRoomSeq, String readerId)
    {
    	// 1. 상대방이 보낸 메세지를 모두 읽음 처리
    	chatDao.updateReadCount(chatRoomSeq, readerId);
    	
    	// 2. 해당 채팅방의 모든 메세지를 조회
    	return chatDao.findMessagesByRoomSeq(chatRoomSeq);
    }

    /**
     * 1:1 채팅방을 생성하거나, 이미 존재하면 기존 방의 정보를 반환합니다.
     * @param currentUserId 현재 로그인한 사용자 아이디
     * @param otherUserId 대화를 시작할 상대방 아이디
     * @return 생성되거나 조회된 채팅방 정보
     */
    @Transactional 
    public ChatRoom findOrCreateChatRoom(String currentUserId, String otherUserId)
    {
    	// 1. 두 사용자 간의 채팅방이 이미 존재하는지 확인
    	Integer chatRoomSeq = chatDao.findChatRoomByUsers(currentUserId, otherUserId);
    	
    	ChatRoom chatRoom = new ChatRoom();
    	
    	if(chatRoomSeq != null && chatRoomSeq > 0)
    	{
    		// 2. 이미 방이 존재하면 해당 방 번호를 설정
    		chatRoom.setChatRoomSeq(chatRoomSeq);
    	}
    	else
    	{
    		// 3. 방이 없으면 새로 생성
    		// 3-1. 채팅방 생성
    		chatDao.createChatRoom(chatRoom);
    		logger.debug("New ChatRoom Created: " + chatRoom.getChatRoomSeq());
    		
    		// 3-2. 참여자 추가 (나)
    		chatDao.addParticipant(chatRoom.getChatRoomSeq(), currentUserId);
    		
    		// 3-3. 참여자 추가 (상대방)
    		chatDao.addParticipant(chatRoom.getChatRoomSeq(), otherUserId);
    	}
    	
    	return chatRoom;
    }
    
    /**
     * 채팅 메시지를 저장(전송)합니다.
     * @param chatMessage 저장할 메시지 정보
     * @return 저장된 메시지 정보 (필요시)
     */
    public ChatMessage sendMessage(ChatMessage chatMessage)
    {
    	if(chatDao.saveMessage(chatMessage) > 0)
    	{
    		return chatMessage;
    	}
    	
    	return null;
    }
    
    
    /**
     * 채팅방 참여자 ID 목록을 조회
     * @param chatRoomSeq 채팅방 시퀀스
     * @return 사용자 ID 목록
     */
    public List<String> findUserIdsByRoomSeq(int chatRoomSeq) 
    {
        try 
        {
            return chatDao.findUserIdsByRoomSeq(chatRoomSeq);
        } 
        catch (Exception e) 
        {
            logger.error("[ChatService] findUserIdsByRoomSeq Exception", e);
            return null;
        }
    }
    
}
