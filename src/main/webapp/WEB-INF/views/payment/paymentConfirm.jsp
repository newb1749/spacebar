<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>결제 확인</title>
  <link href="${pageContext.request.contextPath}/resources/css/bootstrap.min.css" rel="stylesheet" />
  <link href="${pageContext.request.contextPath}/resources/css/style.css" rel="stylesheet" />
  <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
  <style>
    body {
      padding-top: 230px;
    }
    .container {
      max-width: 720px;
    }
    .info-box {
      background: #f9f9f9;
      padding: 20px;
      border-radius: 8px;
      margin-top: 20px;
    }
    .info-box h5 {
      margin-top: 0;
    }
  </style>
</head>
<body>
  <jsp:include page="/WEB-INF/views/include/navigation.jsp" />

  <div class="container">
    <h2 class="mb-4">결제 상태 확인</h2>

    <c:choose>
      <c:when test="${status eq 'SUCCESS'}">
        <div class="alert alert-success">
          <strong>결제가 성공적으로 완료되었습니다!</strong><br/>
          예약이 완료되었으며, 아래 상세 정보를 확인하세요.
        </div>

        <div class="info-box">
          <h5>예약 정보</h5>
          <p><strong>객실 번호:</strong> ${reservation.roomTypeSeq}</p>
          <p><strong>게스트 ID:</strong> ${reservation.guestId}</p>
          <p><strong>체크인 날짜:</strong> ${reservation.rsvCheckInDt}</p>
          <p><strong>체크아웃 날짜:</strong> ${reservation.rsvCheckOutDt}</p>
          <p><strong>체크인 시간:</strong> ${reservation.rsvCheckInTime}</p>
          <p><strong>체크아웃 시간:</strong> ${reservation.rsvCheckOutTime}</p>
          <p><strong>총 인원:</strong> ${reservation.numGuests}</p>
        </div>

        <div class="info-box">
          <h5>결제 정보</h5>
          <p><strong>결제 금액(마일리지):</strong> <fmt:formatNumber value="${reservation.finalAmt}" type="number" /> 원</p>
          <p><strong>남은 마일리지:</strong> <fmt:formatNumber value="${remainingMileage}" type="number" /> 원</p>
        </div>
      </c:when>

      <c:when test="${status eq 'ERROR'}">
        <div class="alert alert-danger">
          <strong>오류:</strong>
          <c:choose>
            <c:when test="${not empty error}">
              ${error}
            </c:when>
            <c:otherwise>
              결제 실패 또는 알 수 없는 상태입니다.<br/>
              문제가 발생했습니다. 관리자에게 문의해 주세요.
            </c:otherwise>
          </c:choose>
        </div>
      </c:when>

      <c:when test="${status eq 'CANCEL'}">
        <div class="alert alert-warning">
          <strong>결제가 취소되었습니다.</strong><br/>
          결제를 다시 시도해 주세요.
        </div>
      </c:when>

      <c:otherwise>
        <div class="alert alert-danger">
          <strong>결제 실패 또는 알 수 없는 상태입니다.</strong><br/>
          문제가 발생했습니다. 관리자에게 문의해 주세요.
        </div>
      </c:otherwise>
    </c:choose>

    <a href="${pageContext.request.contextPath}/" class="btn btn-primary mt-3">메인으로 돌아가기</a>
  </div>

  <jsp:include page="/WEB-INF/views/include/footer.jsp" />
  <script src="${pageContext.request.contextPath}/resources/js/bootstrap.bundle.min.js"></script>
</body>
</html>
