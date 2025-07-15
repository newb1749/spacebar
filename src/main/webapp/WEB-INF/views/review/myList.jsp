<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/head.jsp" %>
<!-- 본인이 작성한 리뷰 조회 -->
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>나의 리뷰</title>
<style>
    .container { max-width: 960px; margin: 30px auto; padding: 20px; }
    .review-table { width: 100%; border-collapse: collapse; margin-top: 20px; }
    .review-table th, .review-table td { padding: 12px; border-bottom: 1px solid #ddd; text-align: center; }
    .review-table th { background-color: #f8f9fa; }
    .review-table td.title { text-align: left; }
    .btn { padding: 6px 12px; border: 1px solid #ccc; border-radius: 4px; background-color: white; cursor: pointer; text-decoration: none; color: black; }
    .btn-delete { border-color: #dc3545; color: #dc3545; }
</style>
<script>
    // RedirectAttributes로 전달된 메시지 alert으로 띄우기
    <c:if test="${not empty message}">
        alert('${message}');
    </c:if>
    <c:if test="${not empty errorMessage}">
        alert('${errorMessage}');
    </c:if>
</script>
</head>
<body>
    <div class="container">
        <h1>나의 리뷰 목록</h1>
        <table class="review-table">
            <thead>
                <tr>
                    <th style="width:25%;">숙소/객실 정보</th>
                    <th style="width:35%;">제목</th>
                    <th style="width:10%;">평점</th>
                    <th style="width:15%;">작성일</th>
                    <th style="width:15%;">관리</th>
                </tr>
            </thead>
            <tbody>
                <c:if test="${empty myReviews}">
                    <tr>
                        <td colspan="5">작성한 리뷰가 없습니다.</td>
                    </tr>
                </c:if>
                <c:forEach var="review" items="${myReviews}">
                    <tr>
                        <td>
                            <strong>${review.roomTitle}</strong><br>
                            <small>${review.roomTypeTitle}</small>
                        </td>
                        <td class="title">${review.reviewTitle}</td>
                        <td>⭐ ${review.rating}</td>
                        <td>${review.regDt}</td>
                        <td>
                            <button type="button" class="btn" onclick="location.href='/review/updateForm?reviewSeq=${review.reviewSeq}'">수정</button>
                            <form action="/review/inactiveProc" method="post" style="display:inline;" onsubmit="return confirm('정말 삭제하시겠습니까?');">
                                <input type="hidden" name="reviewSeq" value="${review.reviewSeq}">
                                <button type="submit" class="btn btn-delete">삭제</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</body>
</html>