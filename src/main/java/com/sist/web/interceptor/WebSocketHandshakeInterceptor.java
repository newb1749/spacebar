package com.sist.web.interceptor;

import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.server.ServerHttpRequest;
import org.springframework.http.server.ServletServerHttpRequest;
import org.springframework.web.socket.WebSocketHandler;
import org.springframework.web.socket.server.HandshakeInterceptor;

// SESSION_USER_ID가 없는 경우 Principal이 anonymous 됨
// 정확히 세션 값 복사
// 기존 HTTP 세션 정보를 WebSocket 세션에 복사, 둘은 세션이 다름(stateful, stateless)
// 사용하는 이유? @MessageMapping 메서드에서 세션 사용자 정보 접근하려고
public class WebSocketHandshakeInterceptor implements HandshakeInterceptor {

	@Value("#{env['auth.session.name']}")
	private String AUTH_SESSION_NAME;
	
    @Override
    public boolean beforeHandshake(ServerHttpRequest request,
                                   org.springframework.http.server.ServerHttpResponse response,
                                   WebSocketHandler wsHandler,
                                   Map<String, Object> attributes) {
        
        if (request instanceof ServletServerHttpRequest) {
            ServletServerHttpRequest servletRequest = (ServletServerHttpRequest) request;
            // 여기가 핵심! getServletRequest()를 사용해야 함
            HttpServletRequest req = servletRequest.getServletRequest();
            HttpSession session = req.getSession(false);
            System.out.println("AUTH_SESSION_NAME = " + AUTH_SESSION_NAME);
            System.out.println("session.getAttribute(...) = " + session.getAttribute(AUTH_SESSION_NAME));
            
            if (session != null) 
            {
            	String userId = (String) session.getAttribute("SESSION_USER_ID");	// AUTH_SESSION_NAME 사용하려면 bean에 등록해야함.
            	System.out.println("[Handshake] session.getAttribute(SESSION_USER_ID): " + session.getAttribute("SESSION_USER_ID"));
            	System.out.println("[Interceptor] 복사된 userId: " + userId);
         
                if (userId != null && !userId.trim().isEmpty()) 
                {
                    attributes.put("sessionUserId", userId);
                    System.out.println("WebSocket 연결 - 사용자: " + userId);
                } 
                else {
                    attributes.put("sessionUserId", "anonymous");
                    System.out.println("WebSocket 연결 - 익명 사용자");
                }
            } 
            else 
            {
                attributes.put("sessionUserId", "anonymous");
                System.out.println("WebSocket 연결 - 세션 없음");
            }
        }
        return true;
    }

    @Override
    public void afterHandshake(ServerHttpRequest request,
                               org.springframework.http.server.ServerHttpResponse response,
                               WebSocketHandler wsHandler,
                               Exception ex) {
        // do nothing
    }
}