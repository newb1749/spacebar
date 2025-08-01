<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
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
    // 시간 포맷팅 함수 추가
    function formatTime(timeStr) {
      if (!timeStr) return "미정";
      
      // HHMM 형식을 HH:MM으로 변환
      if (timeStr.length === 4) {
        return timeStr.substring(0, 2) + ":" + timeStr.substring(2, 4);
      }
      // 이미 HH:MM 형식인 경우
      if (timeStr.includes(":")) {
        return timeStr;
      }
      return timeStr;
    }
    
    // 로그인 여부 체크
    $(document).ready(function() {
      var sessionUserId = '<%= session.getAttribute("SESSION_USER_ID") != null ? session.getAttribute("SESSION_USER_ID") : "" %>';
      if (!sessionUserId) {
        alert("로그인이 필요합니다.");
        window.location.href = '${pageContext.request.contextPath}/index.jsp';
      }
      
      // 시간 포맷팅 적용
      $('.time-format').each(function() {
        var timeStr = $(this).text().trim();
        $(this).text(formatTime(timeStr));
      });
      
      // 디버깅을 위한 로그
      console.log("Status: ${status}");
      console.log("Error: ${error}");
      console.log("Reservation: ${reservation}");
      console.log("CheckIn Time: ${reservation.rsvCheckInTime}");
      console.log("CheckOut Time: ${reservation.rsvCheckOutTime}");
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
        UserId: ${reservation.guestId}<br/>
        CheckIn Time: '${reservation.rsvCheckInTime}' (길이: ${fn:length(reservation.rsvCheckInTime)})<br/>
        CheckOut Time: '${reservation.rsvCheckOutTime}' (길이: ${fn:length(reservation.rsvCheckOutTime)})
      </div>
    </c:if>
    
    <!-- 임시 디버깅 - 실제 시간 값 확인용 (나중에 제거) -->
  <%--   <div class="alert alert-warning">
      <strong>시간 데이터 확인:</strong><br/>
      CheckIn Time 원본: '[${reservation.rsvCheckInTime}]'<br/>
      CheckOut Time 원본: '[${reservation.rsvCheckOutTime}]'<br/>
      CheckIn Time empty? ${empty reservation.rsvCheckInTime}<br/>
      CheckOut Time empty? ${empty reservation.rsvCheckOutTime}<br/>
      CheckIn Time null? ${reservation.rsvCheckInTime == null}<br/>
      CheckOut Time null? ${reservation.rsvCheckOutTime == null}
    </div> --%>
    
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
              <p><strong>체크인:</strong> 
                <c:choose>
                  <c:when test="${not empty reservation.rsvCheckInDt}">
                    <c:set var="checkInDate" value="${reservation.rsvCheckInDt}" />
                    <c:choose>
                      <c:when test="${fn:length(checkInDate) eq 8}">
                        ${fn:substring(checkInDate, 0, 4)}.${fn:substring(checkInDate, 4, 6)}.${fn:substring(checkInDate, 6, 8)}
                      </c:when>
                      <c:otherwise>
                        ${checkInDate}
                      </c:otherwise>
                    </c:choose>
                  </c:when>
                  <c:otherwise>미정</c:otherwise>
                </c:choose>
              </p>
              <p><strong>체크인 시간:</strong> 
                <c:choose>
                  <c:when test="${empty reservation.rsvCheckInTime or reservation.rsvCheckInTime == null}">
                    미정
                  </c:when>
                  <c:when test="${fn:length(reservation.rsvCheckInTime) eq 4 and not fn:contains(reservation.rsvCheckInTime, ':')}">
                    ${fn:substring(reservation.rsvCheckInTime, 0, 2)}:${fn:substring(reservation.rsvCheckInTime, 2, 4)}
                  </c:when>
                  <c:otherwise>
                    ${reservation.rsvCheckInTime}
                  </c:otherwise>
                </c:choose>
              </p>
            </div>
            <div class="col-sm-6">
              <p><strong>체크아웃:</strong> 
                <c:choose>
                  <c:when test="${not empty reservation.rsvCheckOutDt}">
                    <c:set var="checkOutDate" value="${reservation.rsvCheckOutDt}" />
                    <c:choose>
                      <c:when test="${fn:length(checkOutDate) eq 8}">
                        ${fn:substring(checkOutDate, 0, 4)}.${fn:substring(checkOutDate, 4, 6)}.${fn:substring(checkOutDate, 6, 8)}
                      </c:when>
                      <c:otherwise>
                        ${checkOutDate}
                      </c:otherwise>
                    </c:choose>
                  </c:when>
                  <c:otherwise>미정</c:otherwise>
                </c:choose>
              </p>
              <p><strong>체크아웃 시간:</strong> 
                <c:choose>
                  <c:when test="${empty reservation.rsvCheckOutTime or reservation.rsvCheckOutTime == null}">
                    미정
                  </c:when>
                  <c:when test="${fn:length(reservation.rsvCheckOutTime) eq 4 and not fn:contains(reservation.rsvCheckOutTime, ':')}">
                    ${fn:substring(reservation.rsvCheckOutTime, 0, 2)}:${fn:substring(reservation.rsvCheckOutTime, 2, 4)}
                  </c:when>
                  <c:otherwise>
                    ${reservation.rsvCheckOutTime}
                  </c:otherwise>
                </c:choose>
              </p>
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