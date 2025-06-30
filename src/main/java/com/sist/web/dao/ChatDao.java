package com.sist.web.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.sist.web.model.ChatMessage;
import com.sist.web.model.ChatRoom;

public interface ChatDao {
	
    // 채팅방 생성 (생성된 키를 ChatRoom 객체에 바로 담아줌)
    int createChatRoom(ChatRoom chatRoom);

    // 채팅방 참여자 추가
    int addParticipant(@Param("chatRoomSeq") int chatRoomSeq, @Param("userId") String userId);

    // 두 사용자 ID로 기존 1:1 채팅방 조회, 추가로 닉네임도 가져옴(상대방 포함)
    Integer findChatRoomByUsers(@Param("userId1") String userId1, @Param("userId2") String userId2);

    // 특정 사용자가 참여중인 모든 채팅방 목록 조회
    List<ChatRoom> findChatRoomsByUserId(String userId);

    // 특정 채팅방의 메시지 목록 조회
    List<ChatMessage> findMessagesByRoomSeq(int chatRoomSeq);

    // 메시지 저장
    int saveMessage(ChatMessage chatMessage);
    
    // 특정 채팅방의 메시지 읽음 처리 (상대방이 채팅방에 들어왔을 때)
    int updateReadCount(@Param("chatRoomSeq") int chatRoomSeq, @Param("userId") String userId);
    
   
}
