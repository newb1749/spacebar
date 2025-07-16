<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<h2>${notice.noticeTitle}</h2>
<p>${notice.noticeContent}</p>
<p>작성자: ${notice.adminId} | 날짜: <fmt:formatDate value="${notice.regDt}" pattern="yyyy-MM-dd"/></p>

<hr>
<h3>댓글</h3>
<c:forEach var="reply" items="${notice.replies}">
    <p><strong>${reply.userId}</strong>: ${reply.replyContent} (<fmt:formatDate value="${reply.regDt}" pattern="yyyy-MM-dd"/>)</p>
</c:forEach>

<c:if test="${not empty sessionScope.sessionUserId}">
    <form method="post" action="/notice/reply">
        <input type="hidden" name="noticeSeq" value="${notice.noticeSeq}" />
        <textarea name="replyContent" rows="3" cols="60" required></textarea><br/>
        <button type="submit">댓글 등록</button>
    </form>
</c:if>

</body>
</html>