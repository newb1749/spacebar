<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
  <title>예약 내용 확인</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/bootstrap.min.css" />
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css" />
  <style>
    body {
      padding-top: 100px;
      background-color: #f8f9fa;
      font-family: 'Noto Sans KR', sans-serif;
    }
    h3 {
      color: #343a40;
      font-weight: 700;
      margin-bottom: 30px;
      text-align: center;
    }
    .table {
      background-color: #fff;
      box-shadow: 0 0 12px rgba(0,0,0,0.1);
      border-radius: 8px;
      max-width: 700px;
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
      max-width: 700px;
      display: block;
      margin: 0 auto;
      padding: 12px;
    }
    .btn-primary:hover {
      background-color: #e96328;
    }
    .container {
      max-width: 700px;
      margin: 0 auto;
    }
  </style>
</head>
<body>

<%@ include file="/WEB-INF/views/include/navigation.jsp" %>

<div class="container">
  <h3>예약 내용 확인</h3>

  <table class="table table-bordered">
    <tr>
      <th>객실 타입</th>
      <td>${reservation.roomTypeSeq}</td>
    </tr>
    <tr>
      <th>체크인</th>
      <td>${reservation.rsvCheckInDt} ${reservation.rsvCheckInTime}</td>
    </tr>
    <tr>
      <th>체크아웃</th>
      <td>${reservation.rsvCheckOutDt} ${reservation.rsvCheckOutTime}</td>
    </tr>
    <tr>
      <th>인원 수</th>
      <td>${reservation.numGuests}명</td>
    </tr>
    <tr>
      <th>요청사항</th>
      <td><c:out value="${reservation.guestMsg}" default="없음" /></td>
    </tr>
    <tr>
      <th>총 결제 금액</th>
      <td><strong><fmt:formatNumber value="${reservation.finalAmt}" type="currency" /></strong></td>
    </tr>
    <tr>
      <th>보유 마일리지</th>
      <td><strong><fmt:formatNumber value="${userMileage}" type="currency" /></strong></td>
    </tr>
  </table>

  <form id="paymentForm" action="${pageContext.request.contextPath}/reservation/payment/chargeMileage" method="post">
    <input type="hidden" name="roomTypeSeq" value="${reservation.roomTypeSeq}" />
    <input type="hidden" name="rsvCheckInDt" value="${reservation.rsvCheckInDt}" />
    <input type="hidden" name="rsvCheckOutDt" value="${reservation.rsvCheckOutDt}" />
    <input type="hidden" name="rsvCheckInTime" value="${reservation.rsvCheckInTime}" />
    <input type="hidden" name="rsvCheckOutTime" value="${reservation.rsvCheckOutTime}" />
    <input type="hidden" name="numGuests" value="${reservation.numGuests}" />
    <input type="hidden" name="guestMsg" value="${reservation.guestMsg}" />
    <input type="hidden" name="finalAmt" value="${reservation.finalAmt}" />

    <button type="button" class="btn btn-primary" onclick="confirmPayment()">결제하기</button>
  </form>
</div>

<%@ include file="/WEB-INF/views/include/footer.jsp" %>
<script src="${pageContext.request.contextPath}/resources/js/bootstrap.bundle.min.js"></script>
<script>
	function confirmPayment() 
	{
    	const finalAmt = Number("${reservation.finalAmt}") || 0;
    	const mileage = Number("${userMileage}") || 0;

    	if(mileage < finalAmt) 
    	{
			if(confirm("보유 마일리지가 부족합니다. 마일리지를 충전하시겠습니까?"))
	      	{
				location.href = "${pageContext.request.contextPath}/reservation/payment/chargeMileage";
	      	}
    	}
    	else 
    	{
			document.getElementById("paymentForm").submit();
    	}
  	}
</script>
</body>
</html>
