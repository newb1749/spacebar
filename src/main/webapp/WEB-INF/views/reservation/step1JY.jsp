<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<%@ include file="/WEB-INF/views/include/head.jsp" %>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>예약상세</title>
  <!-- Bootstrap5 CSS -->
  <link href="${pageContext.request.contextPath}/resources/css/bootstrap.min.css" rel="stylesheet" />
  <link href="${pageContext.request.contextPath}/resources/css/style.css" rel="stylesheet" />
  <style>
    .reservation-card {
      max-width: 1140px;
      max-height: 840px;
      margin: 0 auto;
    }
    .reservation-card-body {
      padding: 3rem;
    }
    .reservation-info-list li {
      font-size: 1.2rem;
    }
    .form-label {
      font-size: 1.2rem;
    }
    .reservation-textarea {
      padding-left: 12px;
      padding-right: 12px;
      margin-left: 4px;
      margin-right: 4px;
    }
    /* 체크인/체크아웃 시간 숫자 부분 스타일 */
    .time-info {
      font-size: 1.2rem;
    }
    .time-info span.time-value {
      font-size: 1.5rem;
      font-weight: bold;
    }
  </style>
  <script>
    // 로그인 여부 체크
    $(document).ready(function() {
      var sessionUserId = '<%= session.getAttribute("SESSION_USER_ID") != null ? session.getAttribute("sessionUserId") : "" %>';
      if (!sessionUserId) {
        alert("로그인이 필요합니다.");
        window.location.href = '${pageContext.request.contextPath}/index.jsp';
      }
    });
  </script>
</head>
<body>

<%@ include file="/WEB-INF/views/include/navigation.jsp" %>

<section class="bg-light" style="margin-top: 100px; padding-top: 60px; padding-bottom: 60px;">
  <div class="container">
    <div class="card mx-auto reservation-card">
      <div class="card-body reservation-card-body">
        <h3 class="card-title mb-4">예약 정보 확인</h3>
        <ul class="list-unstyled mb-4 reservation-info-list">
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

          <!-- 체크인 시간 표시 -->
          <div class="mb-3 time-info">
            <label class="form-label">체크인 시간</label>
            : <span class="time-value">${fn:substring(checkInTime, 0, 2)}:${fn:substring(checkInTime, 2, 4)}</span>
          </div>

          <!-- 체크아웃 시간 표시 -->
          <div class="mb-3 time-info">
            <label class="form-label">체크아웃 시간</label>
            : <span class="time-value">${fn:substring(checkOutTime, 0, 2)}:${fn:substring(checkOutTime, 2, 4)}</span>
          </div>

          <div class="mb-3">
            <label class="form-label">요청사항</label>
            <textarea
              name="guestMsg"
              class="form-control reservation-textarea"
              rows="3"
              placeholder="요청사항을 입력하세요."></textarea>
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
