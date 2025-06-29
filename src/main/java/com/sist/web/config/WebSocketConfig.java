package com.sist.web.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.messaging.simp.config.MessageBrokerRegistry;
//import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.socket.config.annotation.EnableWebSocketMessageBroker;
import org.springframework.web.socket.config.annotation.StompEndpointRegistry;
import org.springframework.web.socket.config.annotation.WebSocketMessageBrokerConfigurer;

//@Configuration
//@EnableWebSocketMessageBroker	// STOMP 메시징을 사용하도록 활성화
// @EnableWebMvc // [추가] 이 어노테이션을 추가하여 MVC 설정을 명시적으로 활성화
public class WebSocketConfig implements WebSocketMessageBrokerConfigurer{
	
	@Override
	public void configureMessageBroker(MessageBrokerRegistry config)
	{
		// 1. 메시지 브로커가 /topic 으로 시작하는 주소를 구독하는 클라이언트에게 메시지를 전달하도록 설정
		config.enableSimpleBroker("/topic");
		
		// 2. 클라이언트가 서버로 메시지를 보낼 때 사용할 주소의 접두사(prefix)를 설정
		// ex: 클라이언트 -> 서버 /app/chat.sendMessage
		config.setApplicationDestinationPrefixes("/app");
	}
	
	@Override
	public void registerStompEndpoints(StompEndpointRegistry registry)
	{
		// 3. 클라이언트가 WebSocket 에 접속하기 위한 초기 EndPoint 설정
		// 		/ws-chat 이라는 경로로 접속하며, 오래된 브라우저에서도 통신이 가능하도록 SockJS를 지원
		registry.addEndpoint("/ws-chat").withSockJS();
	}
}
