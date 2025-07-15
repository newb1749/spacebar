<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<h2>공지사항 목록</h2>
<table>
    <tr><th>번호</th><th>제목</th><th>작성자</th><th>날짜</th></tr>
    <c:forEach var="n" items="${noticeList}">
        <tr>
            <td>${n.noticeSeq}</td>
            <td><a href="/notice/detail?noticeSeq=${n.noticeSeq}">${n.noticeTitle}</a></td>
            <td>${n.adminId}</td>
            <td><fmt:formatDate value="${n.regDt}" pattern="yyyy-MM-dd"/></td>
        </tr>
    </c:forEach>
</table>
<c:if test="${sessionScope.sessionRole eq 'ADMIN'}">
    <a href="/notice/write">공지 등록</a>
</c:if>

</body>
</html>