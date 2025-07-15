<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/head.jsp" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>내 채팅 목록</title>
<style>
    body { font-family: sans-serif; }
    .chat-list { list-style: none; padding: 0; }
    .chat-list li { border: 1px solid #ccc; padding: 15px; margin-bottom: 10px; border-radius: 5px; }
    .chat-list a { text-decoration: none; color: black; font-size: 1.2em; }
    .chat-list .nickname { font-weight: bold; }
</style>
</head>
<body>

    <h1>내 채팅 목록</h1>

    <ul class="chat-list">
        <c:if test="${!empty myChatRooms}">
            <c:forEach var="room" items="${myChatRooms}">
                <li>
                    <a href="/chat/room?chatRoomSeq=${room.chatRoomSeq}">
                        <%-- [수정] 채팅방 번호 대신 상대방 닉네임 표시 --%>
                        <span class="nickname">${room.otherUserNickname}</span> 님과의 대화<br />
                        <small>마지막 활동: <fmt:formatDate value="${room.createDate}" pattern="yyyy-MM-dd HH:mm" /></small>
                    </a>
                </li>
            </c:forEach>
        </c:if>

        <c:if test="${empty myChatRooms}">
            <li>
                <p>참여중인 채팅방이 없습니다.</p>
            </li>
        </c:if>
    </ul>

    <%-- 다른 사용자와 채팅을 시작하는 테스트용 링크는 실제 서비스에서는 사용자 목록이나 검색 기능으로 대체됩니다 --%>
    <hr />
    <h3>테스트용 채팅 시작</h3>
    <a href="/chat/start?otherUserId=userB">userB와 채팅 시작하기</a> <br />
    <a href="/chat/start?otherUserId=userC">userC와 채팅 시작하기</a>
</body>
</html>