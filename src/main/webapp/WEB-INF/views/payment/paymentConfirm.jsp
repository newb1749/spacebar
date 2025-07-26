<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<head>
<%@ include file="/WEB-INF/views/include/head.jsp" %>
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
      color: #495057;
      border-bottom: 1px solid #dee2e6;
      padding-bottom: 10px;
    }
    .success-icon {
      color: #28a745;
      font-size: 3rem;
      text-align: center;
      margin-bottom: 20px;
    }
  </style>
  <script>
    // 로그인 여부 체크
    $(document).ready(function() {
      var sessionUserId = '<%= session.getAttribute("SESSION_USER_ID") != null ? session.getAttribute("SESSION_USER_ID") : "" %>';
      if (!sessionUserId) {
        alert("로그인이 필요합니다.");
        window.location.href = '${pageContext.request.contextPath}/index.jsp';
      }
      
      // 디버깅을 위한 로그
      console.log("Status: ${status}");
      console.log("Error: ${error}");
      console.log("Reservation: ${reservation}");
    });
  </script>
</head>
<body>
  <jsp:include page="/WEB-INF/views/include/navigation.jsp" />
  <div class="container">
    <h2 class="mb-4 text-center">결제 상태 확인</h2>
    
    <!-- 디버깅 정보 (개발 중에만 표시) -->
    <c:if test="${param.debug eq 'true'}">
      <div class="alert alert-info">
        <strong>디버깅 정보:</strong><br/>
        Status: ${status}<br/>
        Error: ${error}<br/>
        Reservation rsvSeq: ${reservation.rsvSeq}<br/>
        UserId: ${reservation.guestId}
      </div>
    </c:if>
    
    <c:choose>
      <c:when test="${status eq 'SUCCESS'}">
        <div class="success-icon">
          ✅
        </div>
        <div class="alert alert-success text-center">
          <strong>결제가 성공적으로 완료되었습니다!</strong><br/>
          예약이 완료되었으며, 아래 상세 정보를 확인하세요.
        </div>
        
        <div class="info-box">
          <h5>📋 예약 정보</h5>
          <div class="row">
            <div class="col-sm-6">
              <p><strong>예약 번호:</strong> ${reservation.rsvSeq}</p>
              <p><strong>객실 타입:</strong> ${reservation.roomTypeTitle}</p>
              <p><strong>게스트 ID:</strong> ${reservation.guestId}</p>
            </div>
            <div class="col-sm-6">
              <p><strong>총 인원:</strong> ${reservation.numGuests}명</p>
              <p><strong>예약 상태:</strong> ${reservation.rsvStat}</p>
              <p><strong>결제 상태:</strong> ${reservation.rsvPaymentStat}</p>
            </div>
          </div>
        </div>
        
        <div class="info-box">
          <h5>📅 체크인/체크아웃 정보</h5>
          <div class="row">
            <div class="col-sm-6">
              <p><strong>체크인:</strong> ${reservation.rsvCheckInDt}</p>
              <p><strong>체크인 시간:</strong> ${reservation.rsvCheckInTime}</p>
            </div>
            <div class="col-sm-6">
              <p><strong>체크아웃:</strong> ${reservation.rsvCheckOutDt}</p>
              <p><strong>체크아웃 시간:</strong> ${reservation.rsvCheckOutTime}</p>
            </div>
          </div>
        </div>
        
        <div class="info-box">
          <h5>💰 결제 정보</h5>
          <div class="row">
            <div class="col-sm-6">
              <p><strong>총 금액:</strong> <fmt:formatNumber value="${reservation.totalAmt}" type="number" />원</p>
              <p><strong>최종 결제 금액:</strong> <fmt:formatNumber value="${reservation.finalAmt}" type="number" />원</p>
            </div>
            <div class="col-sm-6">
              <c:if test="${reservation.couponSeq != null}">
                <p><strong>쿠폰 적용:</strong> 할인 적용됨</p>
                <p><strong>할인 금액:</strong> <fmt:formatNumber value="${reservation.totalAmt - reservation.finalAmt}" type="number" />원</p>
              </c:if>
              <p><strong>남은 마일리지:</strong> <fmt:formatNumber value="${remainingMileage}" type="number" />원</p>
            </div>
          </div>
        </div>
        
        <div class="text-center mt-4">
          <a href="${pageContext.request.contextPath}/reservation/reservationHistoryJY" class="btn btn-outline-primary me-2">예약 내역 보기</a>
          <a href="${pageContext.request.contextPath}/" class="btn btn-primary">메인으로 돌아가기</a>
        </div>
        
      </c:when>
      
      <c:when test="${status eq 'ERROR'}">
        <div class="alert alert-danger">
          <strong>❌ 오류가 발생했습니다</strong><br/>
          <c:choose>
            <c:when test="${not empty error}">
              ${error}
            </c:when>
            <c:otherwise>
              알 수 없는 오류가 발생했습니다. 관리자에게 문의해 주세요.
            </c:otherwise>
          </c:choose>
        </div>
        <div class="text-center mt-4">
          <a href="${pageContext.request.contextPath}/reservation/reservationHistoryJY" class="btn btn-outline-primary me-2">예약 내역 보기</a>
          <a href="${pageContext.request.contextPath}/" class="btn btn-primary">메인으로 돌아가기</a>
        </div>
      </c:when>
      
      <c:when test="${status eq 'CANCEL'}">
        <div class="alert alert-warning">
          <strong>⚠️ 결제가 취소되었습니다</strong><br/>
          결제를 다시 시도해 주세요.
        </div>
        <div class="text-center mt-4">
          <a href="${pageContext.request.contextPath}/reservation/detailJY" class="btn btn-outline-primary me-2">예약 다시 시도</a>
          <a href="${pageContext.request.contextPath}/" class="btn btn-primary">메인으로 돌아가기</a>
        </div>
      </c:when>
      
      <c:otherwise>
        <div class="alert alert-danger">
          <strong>❌ 결제 실패 또는 알 수 없는 상태입니다</strong><br/>
          문제가 발생했습니다. 관리자에게 문의해 주세요.<br/>
          <small class="text-muted">Status: ${status}, Error: ${error}</small>
        </div>
        <div class="text-center mt-4">
          <a href="${pageContext.request.contextPath}/reservation/reservationHistoryJY" class="btn btn-outline-primary me-2">예약 내역 보기</a>
          <a href="${pageContext.request.contextPath}/" class="btn btn-primary">메인으로 돌아가기</a>
        </div>
      </c:otherwise>
    </c:choose>
  </div>
  
  <jsp:include page="/WEB-INF/views/include/footer.jsp" />
  <script src="${pageContext.request.contextPath}/resources/js/bootstrap.bundle.min.js"></script>
</body>
</html>