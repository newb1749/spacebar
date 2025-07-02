<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <title>예약 확인</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/bootstrap.min.css" />
  <!-- 위 스타일 추가 -->
  <style>
  body {
    padding-top: 100px;
    background-color: #f8f9fa;
    font-family: 'Noto Sans KR', sans-serif;
  }

  h3 {
    margin-bottom: 30px;
    color: #343a40;
    font-weight: 700;
  }

  .table {
    background-color: #fff;
    box-shadow: 0 0 12px rgba(0,0,0,0.1);
    border-radius: 8px;
  }

  .table th, .table td {
    vertical-align: middle !important;
  }

  .table th {
    background-color: #343a40;
    color: white;
    font-weight: 600;
    text-align: center;
  }

  .table td {
    text-align: center;
    font-size: 1rem;
    color: #495057;
  }

  .btn-primary {
    background-color: #fe7743;
    border: none;
    font-weight: 700;
    font-size: 1.1rem;
    transition: background-color 0.3s ease;
  }

  .btn-primary:hover {
    background-color: #e96328;
  }

  .container {
    max-width: 700px;
  }

</style>

</head>
<body>
<%@ include file="/WEB-INF/views/include/navigation.jsp" %>

<div class="container mt-5">
  <h3>예약 내용 확인</h3>

  <table class="table table-bordered">
    <tr><th>객실 타입</th><td>${reservation.roomTypeSeq}</td></tr>
    <tr><th>체크인</th><td>${reservation.rsvCheckInDt} ${reservation.rsvCheckInTime}</td></tr>
    <tr><th>체크아웃</th><td>${reservation.rsvCheckOutDt} ${reservation.rsvCheckOutTime}</td></tr>
    <tr><th>인원 수</th><td>${reservation.numGuests}명</td></tr>
    <tr><th>요청사항</th><td>${reservation.guestMsg}</td></tr>
    <tr><th>총 결제 금액</th><td><strong><fmt:formatNumber value="${reservation.finalAmt}" type="currency"/></strong></td></tr>
    <tr><th>보유 마일리지</th><td><strong><fmt:formatNumber value="${userMileage}" type="currency"/></strong></td></tr>
  </table>

  <form id="paymentForm" action="/payment/chargeMileage" method="post">
    <input type="hidden" name="roomTypeSeq" value="${reservation.roomTypeSeq}" />
    <input type="hidden" name="rsvCheckInDt" value="${reservation.rsvCheckInDt}" />
    <input type="hidden" name="rsvCheckOutDt" value="${reservation.rsvCheckOutDt}" />
    <input type="hidden" name="rsvCheckInTime" value="${reservation.rsvCheckInTime}" />
    <input type="hidden" name="rsvCheckOutTime" value="${reservation.rsvCheckOutTime}" />
    <input type="hidden" name="numGuests" value="${reservation.numGuests}" />
    <input type="hidden" name="guestMsg" value="${reservation.guestMsg}" />
    <input type="hidden" name="finalAmt" value="${reservation.finalAmt}" />

    <button type="button" class="btn btn-primary w-100" onclick="confirmPayment()">결제하기</button>
  </form>
</div>

<script>
	function confirmPayment() 
	{
		// EL 치환 후 불필요한 문자가 없는지 확실히 하려면 숫자만 남기기
		const finalAmtStr = "${reservation.finalAmt}";
		const mileageStr = "${userMileage}";
		
		// 숫자로 변환 (숫자 아니면 0 처리)
		const finalAmt = Number(finalAmtStr) || 0;
		const mileage = Number(mileageStr) || 0;
		
		if(mileage < finalAmt) 
		{
			if(confirm("보유 마일리지가 부족합니다. 마일리지를 충전하시겠습니까?")) 
			{
		    	location.href = "/payment/chargeMileage"; // 혹은 마일리지 충전 페이지 URL
		  	}
		}
		else 
		{
		  document.getElementById("paymentForm").submit();
		}
	}
</script>

<%@ include file="/WEB-INF/views/include/footer.jsp" %>
</body>
</html>
