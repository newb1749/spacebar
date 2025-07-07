<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/views/include/head.jsp" %>
<!DOCTYPE html>
<html>
<head>
<title>${roomTitle} - 전체 리뷰</title>
<style>
    /* ... 필요한 스타일 ... */
    .review-list-item { border: 1px solid #ddd; padding: 15px; margin-bottom: 10px; cursor: pointer; }
    .review-list-item:hover { background-color: #f9f9f9; }
</style>
</head>
<body>
    <h1>${roomTitle}</h1>
    <h2>전체 리뷰 목록</h2>

    <c:forEach var="review" items="${reviewList}">
        <div class="review-list-item" onclick="location.href='/review/view/${review.reviewSeq}'">
            <strong>${review.reviewTitle}</strong> (평점: ${review.rating})<br>
            <small>작성자: ${review.userNickname} | 작성일: ${review.regDt}</small>
        </div>
    </c:forEach>
</body>
</html>