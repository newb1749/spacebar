<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>예약상세</title>
  <!-- Bootstrap5 CSS -->
  <link href="${pageContext.request.contextPath}/resources/css/bootstrap.min.css" rel="stylesheet" />
  <link href="${pageContext.request.contextPath}/resources/css/style.css" rel="stylesheet" />
</head>
<body>

<%@ include file="/WEB-INF/views/include/navigation.jsp" %>

<section class="bg-light" style="margin-top: 100px; padding-top: 60px; padding-bottom: 60px;">
  <div class="container">
    <div class="card mx-auto" style="max-width: 500px;">
      <div class="card-body">
        <h3 class="card-title mb-4">예약 정보 확인</h3>
        <ul class="list-unstyled mb-4">
          <li><strong>객실 타입:</strong> ${roomTypeSeq}</li>
          <li><strong>체크인 날짜:</strong> ${checkIn}</li>
          <li><strong>체크아웃 날짜:</strong> ${checkOut}</li>
          <li><strong>인원 수:</strong> ${numGuests}명</li>
        </ul>

        <!-- 예약 확인 페이지로 POST 전송 -->
        <form action="${pageContext.request.contextPath}/reservation/detailJY" method="post">
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
            <textarea name="guestMsg" class="form-control" rows="3" placeholder="요청사항을 입력하세요."></textarea>
          </div>
          <button type="submit" class="btn btn-primary w-100">예약 내용 확인</button>
        </form>
      </div>
    </div>
  </div>
</section>

<%@ include file="/WEB-INF/views/include/footer.jsp" %>
<script src="${pageContext.request.contextPath}/resources/js/bootstrap.bundle.min.js"></script>
</body>
</html>
