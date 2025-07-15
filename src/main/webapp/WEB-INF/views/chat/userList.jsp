<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/head.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>대화 상대 선택</title>
<style>
    /* 간단한 스타일링 */
    body { 
        font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Open Sans', 'Helvetica Neue', sans-serif;
        color: #333;
    }
    .container { 
        width: 600px; 
        margin: 40px auto; 
        padding: 20px;
    }
    h1 {
        text-align: center;
        margin-bottom: 30px;
    }
    .search-form { 
        margin-bottom: 20px; 
        display: flex; 
        gap: 10px; /* 입력창과 버튼 사이 간격 */
    }
    .search-form input[type="text"] { 
        flex-grow: 1; 
        padding: 10px; 
        border: 1px solid #ccc;
        border-radius: 5px;
        font-size: 16px;
    }
    .search-form button { 
        padding: 10px 20px; 
        border: none;
        background-color: #007bff;
        color: white;
        border-radius: 5px;
        cursor: pointer;
        font-size: 16px;
    }
    .search-form button:hover {
        background-color: #0056b3;
    }
    .user-list { 
        list-style: none; 
        padding: 0; 
        border-top: 2px solid #eee;
    }
    .user-list li { 
        display: flex; 
        justify-content: space-between; 
        align-items: center; 
        border-bottom: 1px solid #eee; 
        padding: 15px; 
    }
    .user-info strong {
        font-size: 1.1em;
        color: #000;
    }
    .user-info span {
        color: #666;
    }
    .user-list a.chat-button { 
        background-color: #28a745; 
        color: white; 
        text-decoration: none; 
        padding: 8px 12px; 
        border-radius: 5px;
        font-size: 14px;
        transition: background-color 0.2s;
    }
    .user-list a.chat-button:hover {
        background-color: #218838;
    }
    .no-result {
        text-align: center;
        padding: 40px;
        color: #777;
    }
</style>
</head>
<body>

<div class="container">
    <h1>대화 상대 선택 👥</h1>
    
    <form name="searchForm" id="searchForm" action="/chat/userList" method="get">
        <div class="search-form">
            <input type="text" name="searchKeyword" id="searchKeyword" value="${searchKeyword}" placeholder="아이디 또는 닉네임으로 검색" />
            <button type="submit">검색</button>
        </div>
    </form>

    <ul class="user-list">
        <c:if test="${!empty userList}">
            <c:forEach var="user" items="${userList}">
                <li>
                    <div class="user-info">
                        <strong>${user.nickName}</strong> 
                        <span>(${user.userId})</span>
                    </div>
                    <%-- 이 링크를 클릭하면 해당 유저와의 채팅이 시작됩니다. --%>
                    <a href="/chat/start?otherUserId=${user.userId}" class="chat-button">채팅하기</a>
                </li>
            </c:forEach>
        </c:if>

        <c:if test="${empty userList}">
            <li class="no-result">
                <p>표시할 사용자가 없습니다.</p>
            </li>
        </c:if>
    </ul>
</div>

</body>
</html>