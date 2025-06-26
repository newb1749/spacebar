<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>예약 – 1단계</title>
  <!-- Bootstrap5 CSS -->
  <link href="${pageContext.request.contextPath}/resources/css/bootstrap.min.css" rel="stylesheet" />
  <link href="${pageContext.request.contextPath}/resources/css/style.css" rel="stylesheet" />
</head>
<body>

<%@ include file="/WEB-INF/views/include/navigation.jsp" %>

<!-- 카드 위·아래로 여백 추가 -->
<section class="bg-light" style="margin-top: 100px; padding-top: 60px; padding-bottom: 60px;">
  <div class="container">
    <div class="card mx-auto" style="max-width: 500px;">
      <div class="card-body">
        <h3 class="card-title mb-4">예약 정보 확인</h3>
        <ul class="list-unstyled mb-4">
          <li><strong>인원:</strong> ${numGuests}명</li>
          <li><strong>체크인:</strong> ${checkIn}</li>
          <li><strong>체크아웃:</strong> ${checkOut}</li>
          <li><strong>객실 타입 ID:</strong> ${roomTypeSeq}</li>
        </ul>
        <form action="${pageContext.request.contextPath}/reservation/insert" method="post">
          <input type="hidden" name="roomTypeSeq" value="${roomTypeSeq}" />
          <input type="hidden" name="rsvCheckInDt" value="${checkIn}" />
          <input type="hidden" name="rsvCheckOutDt" value="${checkOut}" />
          <input type="hidden" name="numGuests" value="${numGuests}" />
          <div class="mb-3">
            <label class="form-label">체크인 시간</label>
            <input type="time" name="rsvCheckInTime" class="form-control" required />
          </div>
          <div class="mb-3">
            <label class="form-label">체크아웃 시간</label>
            <input type="time" name="rsvCheckOutTime" class="form-control" required />
          </div>
          <div class="mb-3">
            <label class="form-label">요청사항</label>
            <textarea name="guestMsg" class="form-control" rows="3"></textarea>
          </div>
          <button type="submit" class="btn btn-primary w-100">예약 완료</button>
        </form>
      </div>
    </div>
  </div>
</section>

<%@ include file="/WEB-INF/views/include/footer.jsp" %>
<script src="${pageContext.request.contextPath}/resources/js/bootstrap.bundle.min.js"></script>
</body>
</html>
