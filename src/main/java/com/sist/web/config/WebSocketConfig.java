package com.sist.web.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.messaging.simp.config.MessageBrokerRegistry;
//import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.socket.config.annotation.EnableWebSocketMessageBroker;
import org.springframework.web.socket.config.annotation.StompEndpointRegistry;
import org.springframework.web.socket.config.annotation.WebSocketMessageBrokerConfigurer;

import com.sist.web.interceptor.WebSocketHandshakeInterceptor;

@Configuration
@EnableWebSocketMessageBroker	// STOMP 메시징을 사용하도록 활성화ㅇ
public class WebSocketConfig implements WebSocketMessageBrokerConfigurer{
	
    @Override
    public void configureMessageBroker(MessageBrokerRegistry registry) {
    	// /topic	1:N 브로드캐스트 (모든 구독자에게 보냄) @SendTo 
    	// /queue	1:1 개인 메시지 (또는 대기열 구조)	convertAndSend()	
        registry.enableSimpleBroker("/topic", "/queue");
        
        // 클라이언트가 보낸 메시지를 @MessageMapping 메서드로 라우팅하기 위한 접두사
        // 즉, 클라이언트 → 서버 발행 메시지 경로의 prefix
        registry.setApplicationDestinationPrefixes("/app");
        // 특정 사용자에게만 메시지를 보내기 위한 경로 규칙을 설정(개인 메시지), 우린 채팅방 목록
        registry.setUserDestinationPrefix("/user");
    }
	
    @Override
    public void registerStompEndpoints(StompEndpointRegistry registry) {
        registry.addEndpoint("/ws-chat")		// 클라이언트가 STOMP/SockJS를 통해 WebSocket 연결을 시도하는 엔드포인트
                .addInterceptors(new WebSocketHandshakeInterceptor()) // WebSocketHandshakeInterceptor 설정, 이건 세션 복사용
                .setHandshakeHandler(new CustomHandshakeHandler())     // CustomHandshakeHandler 설정
                .withSockJS();
    }


}
