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

          <%-- <div class="mb-3">
            <label class="form-label">체크인 시간</label>
            <c:choose>
            	<c:when test="${roomCatSeq >= 1 && roomCatSeq <= 7}">
            		<input type="time" name="rsvCheckInTime" class="form-control" required />
            	</c:when>
            	<c:when test="${roomCatSeq >= 8 && roomCatSeq <= 14}">
            		: ${fn:substring(checkInTime, 0, 2)}:${fn:substring(checkInTime, 2, 4)}
            	</c:when>
            </c:choose>
            
          </div>
          <div class="mb-3">
            <label class="form-label">체크아웃 시간</label>
            <c:choose>
            	<c:when test="${roomCatSeq >= 1 && roomCatSeq <= 7}">
            		<input type="time" name="rsvCheckOutTime" class="form-control" required />
            	</c:when>
            	<c:when test="${roomCatSeq >= 8 && roomCatSeq <= 14}">
            		: ${fn:substring(checkOutTime, 0, 2)}:${fn:substring(checkOutTime, 2, 4)}
            	</c:when>
            </c:choose> --%>
            
          	<!-- 체크인 시간 표시 -->
			<div class="mb-3">
			  <label class="form-label">체크인 시간</label>
			  : ${fn:substring(checkInTime, 0, 2)}:${fn:substring(checkInTime, 2, 4)}
			</div>
			
			<!-- 체크아웃 시간 표시 -->
			<div class="mb-3">
			  <label class="form-label">체크아웃 시간</label>
			  : ${fn:substring(checkOutTime, 0, 2)}:${fn:substring(checkOutTime, 2, 4)}
			</div>
			          
          </div>
          <div class="mb-3">
		  <label class="form-label" style="padding-left: 8px; padding-right: 8px;">요청사항</label>
		  <textarea 
		    name="guestMsg" 
		    class="form-control" 
		    rows="3" 
		    placeholder="요청사항을 입력하세요."
		    style="padding-left: 12px; padding-right: 12px; margin-left: 4px; margin-right: 4px;">
		  </textarea>
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
