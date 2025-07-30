// com.sist.web.config.CustomHandshakeHandler.java
package com.sist.web.config;

import java.security.Principal;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.http.server.ServerHttpRequest;
import org.springframework.http.server.ServletServerHttpRequest;
import org.springframework.web.socket.server.support.DefaultHandshakeHandler;

// WebSocket 세션에 Principal 정보를 강제로 주입해주는 클래스ㅇ
// convertAndSendToUser 사용하려면 WebSocket 세션에 principal 필요하다...
public class CustomHandshakeHandler extends DefaultHandshakeHandler {
    @Override
    protected Principal determineUser(ServerHttpRequest request, org.springframework.web.socket.WebSocketHandler wsHandler, Map<String, Object> attributes) {
        if (request instanceof ServletServerHttpRequest) {
            ServletServerHttpRequest servletRequest = (ServletServerHttpRequest) request;
            HttpSession session = servletRequest.getServletRequest().getSession(false);
            if (session != null) {
                final String userId = (String) session.getAttribute("sessionUserId");
                if (userId != null) {
                    return new Principal() {
                        @Override
                        public String getName() {
                            return userId;
                        }
                    };
                }
            }
        }
        return null;
    }
}
