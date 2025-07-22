<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<%@ include file="/WEB-INF/views/include/head.jsp" %>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
  <title>예약 내용 확인</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/bootstrap.min.css" />
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css" />
  <style>
.site-nav .container {
  max-width: none !important;   /* 부트스트랩 max-width 제거 */
  width:68% !important;        /* 화면 너비의 80% */
  margin: 0 auto !important;    /* 가운데 정렬 */
  padding: 0 !important;
}

/* ─── 기존 CSS ─── */
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
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  <script>
    $(document).ready(function() {
      var sessionUserId = '<%= session.getAttribute("SESSION_USER_ID") != null ? session.getAttribute("SESSION_USER_ID") : "" %>';
      if (!sessionUserId) {
        alert("로그인이 필요합니다.");
        window.location.href = '${pageContext.request.contextPath}/index.jsp';
      }

      const originalFinalAmt = Number("${reservation.finalAmt}");

      // 쿠폰 선택 시 금액 차감
      $("#couponSelect").on("change", function () {
        const selected = $(this).find("option:selected");
        const discount = Number(selected.data("discount")) || 0;
        const type = selected.data("type");
        let discountedAmt = originalFinalAmt;

        if (type === 'rate') {
          discountedAmt = originalFinalAmt - Math.floor(originalFinalAmt * discount / 100);
        } else if (type === 'amount') {
          discountedAmt = originalFinalAmt - discount;
        }

        if (discountedAmt < 0) discountedAmt = 0;

        $("#discountedAmt").text(discountedAmt.toLocaleString() + "원");
        $("#appliedCouponSeq").val(selected.val());
        $("#finalAmt").val(discountedAmt);
      });
    });

    function confirmPayment() {
      const finalAmt = Number($("#finalAmt").val()) || 0;
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
</head>
<body>

<%@ include file="/WEB-INF/views/include/navigation.jsp" %>

<div style="max-width:700px; margin: 20px auto; text-align:center; color:#888;">
  쿠폰 개수: ${fn:length(couponList)}
</div>
<div class="container">
  <h3>예약 내용 확인</h3>

  <table class="table table-bordered">
    <tr>
      <th>객실 타입</th>
      <td>${reservation.roomTypeTitle}</td>
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
      <td><strong><span id="discountedAmt"><fmt:formatNumber value="${reservation.finalAmt}" type="currency" /></span></strong></td>
    </tr>
    <tr>
      <th>보유 마일리지</th>
      <td><strong><fmt:formatNumber value="${userMileage}" type="currency" /></strong></td>
    </tr>
  </table>

  <div class="coupon-box mb-3 text-center">
    <label for="couponSelect" class="mb-1 fw-bold">쿠폰 선택</label>
    <select name="couponSeq" id="couponSelect" class="form-select w-100">
      <c:choose>
        <c:when test="${not empty couponList}">
          <option value="" data-discount="0" data-type="none">-- 쿠폰 선택 안함 --</option>
          <c:forEach var="coupon" items="${couponList}">
            <c:set var="discountType" value="${coupon.discountRate > 0 ? 'rate' : 'amount'}" />
            <c:set var="discountValue" value="${coupon.discountRate > 0 ? coupon.discountRate : coupon.discountAmt}" />
            <option 
              value="${coupon.cpnSeq}" 
              data-discount="${discountValue}" 
              data-type="${discountType}">
              ${coupon.cpnName} - ${coupon.cpnDesc}
            </option>
          </c:forEach>
        </c:when>
        <c:otherwise>
          <option disabled selected>사용 가능한 쿠폰이 없습니다.</option>
        </c:otherwise>
      </c:choose>
    </select>
  </div>

  <form id="paymentForm" action="${pageContext.request.contextPath}/payment/chargeMileage" method="post">
    <input type="hidden" name="roomTypeSeq" value="${reservation.roomTypeSeq}" />
    <input type="hidden" name="rsvCheckInDt" value="${reservation.rsvCheckInDt}" />
    <input type="hidden" name="rsvCheckOutDt" value="${reservation.rsvCheckOutDt}" />
    <input type="hidden" name="rsvCheckInTime" value="${reservation.rsvCheckInTime}" />
    <input type="hidden" name="rsvCheckOutTime" value="${reservation.rsvCheckOutTime}" />
    <input type="hidden" name="numGuests" value="${reservation.numGuests}" />
    <input type="hidden" name="guestMsg" value="${reservation.guestMsg}" />
    <input type="hidden" id="finalAmt" name="finalAmt" value="${reservation.finalAmt}" />
    <input type="hidden" id="appliedCouponSeq" name="couponSeq" value="" />

    <button type="button" class="btn btn-primary" onclick="confirmPayment()">결제하기</button>
  </form>
</div>

<%@ include file="/WEB-INF/views/include/footer.jsp" %>
<script src="${pageContext.request.contextPath}/resources/js/bootstrap.bundle.min.js"></script>
</body>
</html>
