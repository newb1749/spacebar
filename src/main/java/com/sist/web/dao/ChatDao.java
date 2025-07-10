package com.sist.web.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.sist.web.model.ChatMessage;
import com.sist.web.model.ChatRoom;

public interface ChatDao {
	
	/**
	 * 채팅방 생성 (생성된 키를 ChatRoom 객체에 바로 담아줌)
	 * @param chatRoom
	 * @return
	 */
    public int createChatRoom(ChatRoom chatRoom);

    
    /**
     * 채팅방 참여자 추가
     * @param chatRoomSeq 채팅방
     * @param userId 새로 들어오는 참여자
     * @return
     */
    public int addParticipant(@Param("chatRoomSeq") int chatRoomSeq, @Param("userId") String userId);

    /**
     * 두 사용자 ID로 기존 1:1 채팅방 조회, 추가로 닉네임도 가져옴(상대방 포함)
     * @param userId1
     * @param userId2
     * @return
     */
    public Integer findChatRoomByUsers(@Param("userId1") String userId1, @Param("userId2") String userId2);

    /**
     * 특정 사용자가 참여중인 모든 채팅방 목록 조회
     * @param userId
     * @return 채팅방 목록
     */
    public List<ChatRoom> findChatRoomsByUserId(String userId);

    
    /**
     * 특정 채팅방의 메시지 목록 조회
     * @param chatRoomSeq 특정채팅방 id
     * @return 메시지 목록
     */
    public List<ChatMessage> findMessagesByRoomSeq(int chatRoomSeq);
 
    /**
     * 메시지 저장
     * @param chatMessage
     * @return
     */
    public int saveMessage(ChatMessage chatMessage);
    
    /**
     * 특정 채팅방의 메시지 읽음 처리 (상대방이 채팅방에 들어왔을 때)
     * @param chatRoomSeq
     * @param userId 
     * @return 
     */
    public int updateReadCount(@Param("chatRoomSeq") int chatRoomSeq, @Param("userId") String userId);
    
    /**
     * 채팅방 참여자 ID 목록을 조회하는 서비스, 채팅방 목록 페이지에서 메시지 왔을 때 즉시 알리기 위해서
     * @param chatRoomSeq 채팅방 시퀀스
     * @return 사용자 ID 목록
     */
    public List<String> findUserIdsByRoomSeq(int chatRoomSeq);
}
