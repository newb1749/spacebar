<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/head.jsp" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>내 채팅 목록</title>
<style>
    /* 간단한 스타일 */
    body { font-family: sans-serif; }
    .chat-list { list-style: none; padding: 0; }
    .chat-list li { border: 1px solid #ccc; padding: 15px; margin-bottom: 10px; border-radius: 5px; }
    .chat-list a { text-decoration: none; color: black; font-size: 1.2em; }
</style>
</head>
<body>

    <h1>내 채팅 목록</h1>

    <ul class="chat-list">
        <c:if test="${!empty myChatRooms}">
            <c:forEach var="room" items="${myChatRooms}">
                <li>
                    <a href="/chat/room?chatRoomSeq=${room.chatRoomSeq}">
                        채팅방 번호: ${room.chatRoomSeq} <br />
                        <small>생성일: <fmt:formatDate value="${room.createDate}" pattern="yyyy-MM-dd HH:mm" /></small>
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

    <%-- 다른 사용자와 채팅을 시작하는 테스트용 링크 --%>
    <hr />
    <h3>테스트용 채팅 시작</h3>
    <a href="/chat/start?otherUserId=userB">userB와 채팅 시작하기</a> <br />
    <a href="/chat/start?otherUserId=userC">userC와 채팅 시작하기</a>
</body>
</html>