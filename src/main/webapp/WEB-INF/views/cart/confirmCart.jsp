<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <%@ include file="/WEB-INF/views/include/head.jsp" %>
  <style>
    body {
      padding-top: 100px;
      background-color: #f8f9fa;
      font-family: 'Noto Sans KR', sans-serif;
    }
    h3 {
      margin-top: 120px;
      color: #343a40;
      font-weight: 700;
      margin-bottom: 30px;
      text-align: center;
    }
    .table {
      background-color: #fff;
      box-shadow: 0 0 12px rgba(0,0,0,0.1);
      border-radius: 8px;
       max-width: 100%;
  width: 100%;
      margin: 0 auto 40px;
    }
    .table th, .table td {
      vertical-align: middle !important;
      text-align: center;
      font-size: 1rem;
      color: #495057;
    }
    .table th {
      background-color: #343a40;
      color: white;
      font-weight: 600;
    }
    .btn-primary {
      background-color: #fe7743;
      border: none;
      font-weight: 700;
      font-size: 1.1rem;
      transition: background-color 0.3s ease;
      width: 100%;
      max-width: 900px;
      width: 900px;
      display: block;
      margin: 0 auto;
      padding: 12px;
    }
    .btn-primary:hover {
      background-color: #e96328;
    }
    .container {
  max-width: 900px;  /* 또는 90% 등 원하는 값으로 조정 */
  width: 90%;
  margin: 0 auto;
    }
  </style>
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  <script>
    // 로그인 여부 체크
    $(document).ready(function() {
      var sessionUserId = '<%= session.getAttribute("SESSION_USER_ID") != null ? session.getAttribute("SESSION_USER_ID") : "" %>';
      if (!sessionUserId) {
        alert("로그인이 필요합니다.");
        window.location.href = '${pageContext.request.contextPath}/index.jsp';
      }
    });
  </script>
</head>
<body>
  <%@ include file="/WEB-INF/views/include/navigation.jsp" %>

  <div class="container">
    <h3>예약 내용 확인</h3>

    <table class="table table-bordered">
      <tr>
        <th>객실 타입</th>
        <th>체크인</th>
        <th>체크아웃</th>
        <th>인원 수</th>
        <th>금액</th>
      </tr>
      <c:forEach var="r" items="${reservations}">
      
      	  <fmt:parseDate var="inDate"  value="${r.rsvCheckInDt}"  pattern="yyyyMMdd" />
		  <fmt:parseDate var="outDate" value="${r.rsvCheckOutDt}" pattern="yyyyMMdd" />
		  <fmt:parseDate var="inTime"  value="${r.rsvCheckInTime}"  pattern="HHmm" />
		  <fmt:parseDate var="outTime" value="${r.rsvCheckOutTime}" pattern="HHmm" />
      	
        <tr>
          <td>${r.roomTypeTitle}</td>
			<td>
		      <fmt:formatDate value="${inDate}"  pattern="yyyy-MM-dd" /> /
		      <fmt:formatDate value="${inTime}"  pattern="HH:mm" />
		    </td>
		    <td>
		      <fmt:formatDate value="${outDate}" pattern="yyyy-MM-dd" /> /
		      <fmt:formatDate value="${outTime}" pattern="HH:mm" />
		    </td>
          <td>${r.numGuests}명</td>
          <td><strong><fmt:formatNumber value="${r.finalAmt}" type="currency"/></strong></td>
        </tr>
      </c:forEach>
      <tr>
        <th colspan="4" class="text-right">총 결제 금액</th>
        <td><strong><fmt:formatNumber value="${totalAmt}" type="currency"/></strong></td>
      </tr>
      <tr>
        <th colspan="4" class="text-right">보유 마일리지</th>
        <td><strong><fmt:formatNumber value="${userMileage}" type="currency"/></strong></td>
      </tr>
    </table>

    <form id="paymentForm" action="${pageContext.request.contextPath}/cart/checkout" method="post">
      <c:forEach var="seq" items="${cartSeqs}">
        <input type="hidden" name="cartSeqs" value="${seq}" />
      </c:forEach>
      <button type="button" class="btn btn-primary" onclick="confirmPayment()">결제하기</button>
    </form>
  </div>

  <%@ include file="/WEB-INF/views/include/footer.jsp" %>
  <script src="${pageContext.request.contextPath}/resources/js/bootstrap.bundle.min.js"></script>
  <script>
    function confirmPayment() {
      const finalAmt = Number("${totalAmt}") || 0;
      const mileage = Number("${userMileage}") || 0;

      if (mileage < finalAmt) {
        if (confirm("보유 마일리지가 부족합니다. 마일리지를 충전하시겠습니까?")) {
          location.href = "${pageContext.request.contextPath}/reservation/chargeMileage";
        }
      } else {
        document.getElementById("paymentForm").submit();
      }
    }
  </script>
</body>
</html>
