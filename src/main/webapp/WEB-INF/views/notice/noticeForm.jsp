<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<h2>공지사항 등록</h2>
<form method="post" action="/notice/write">
    제목: <input type="text" name="noticeTitle" required /><br/>
    내용:<br/>
    <textarea name="noticeContent" rows="10" cols="80" required></textarea><br/>
    <button type="submit">등록</button>
</form>

</body>
</html>