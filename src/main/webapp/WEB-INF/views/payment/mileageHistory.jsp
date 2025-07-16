<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <title>마일리지 거래 내역</title>
  <link href="${pageContext.request.contextPath}/resources/css/bootstrap.min.css" rel="stylesheet" />
  <link href="${pageContext.request.contextPath}/resources/css/style.css" rel="stylesheet" />
  <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
  <style>
    body {
      padding-top: 80px;
      background-color: #f8f9fa;
    }
    h2 {
      margin-top: 120px;
      text-align: left !important;
    }
    .alert strong {
      font-size: 30px;
    }
    .container {
      max-width: 960px;
      margin: 0 auto;
    }
    .info-box {
      background: #f9f9f9;
      padding: 20px;
      border-radius: 8px;
      margin-top: -30px;
      margin-bottom: 60px;
    }
    .table-wrapper {
      margin: 0 -20px; /* 표 가로 여백 줄이기 */
    }
    table {
      width: 100%;
      margin-top: 20px;
      font-size: 1.1rem;
    }
    .table thead tr {
      background-color: #343a40;
    }
    .table thead tr th {
      color: #fff;
      text-align: center;
    }
    .table td {
      text-align: center;
      vertical-align: middle;
    }
    .table td.amount {
      text-align: right;
      padding-right: 12px;
    }
    .btn {
      font-size: 1.1rem;
      padding: 0.5rem 1.2rem;
      margin-left: 10px;
    }
  </style>
<<<<<<< HEAD
  <script>
=======
    <script>
>>>>>>> origin/base
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

<jsp:include page="/WEB-INF/views/include/navigation.jsp" />

<div class="container">
  <h2 class="mb-4">마일리지 거래 내역</h2>

  <c:if test="${not empty remainingMileage}">
    <div class="alert alert-success">
      <p>
        <strong>
<<<<<<< HEAD
          보유 마일리지: <fmt:formatNumber value="${remainingMileage}" groupingUsed="true" />원
=======
          보유 마일리지: <fmt:formatNumber value="${remainingMileage}" groupingUsed="true" /> 원
>>>>>>> origin/base
        </strong>
      </p>
    </div>
  </c:if>

  <div class="info-box">
    <div class="table-wrapper">
      <table class="table table-bordered">
        <thead>
          <tr>
            <th>거래 일시</th>
            <th>거래 유형</th>
            <th>거래 금액</th>
            <th>거래 후 잔액</th>
          </tr>
        </thead>
        <tbody>
          <c:forEach var="entry" items="${mileageHistoryList}">
            <tr>
              <td><fmt:formatDate value="${entry.trxDt}" pattern="yyyy-MM-dd HH:mm:ss" /></td>
              <td>
                <c:choose>
                  <c:when test="${entry.trxType eq '충전'}">
                    <span class="badge bg-success">충전</span>
                  </c:when>
                  <c:when test="${entry.trxType eq '결제'}">
                    <span class="badge bg-danger">결제</span>
                  </c:when>
                  <c:when test="${entry.trxType eq '환불'}">
                    <span class="badge bg-info text-dark">환불</span>
                  </c:when>
                  <c:otherwise>
                    <span class="badge bg-secondary"><c:out value="${entry.trxType}" /></span>
                  </c:otherwise>
                </c:choose>
              </td>
              <td class="amount"><fmt:formatNumber value="${entry.trxAmt}" groupingUsed="true" /> 원</td>
              <td class="amount"><fmt:formatNumber value="${entry.balanceAfterTrx}" groupingUsed="true" /> 원</td>
            </tr>
          </c:forEach>
          <c:if test="${empty mileageHistoryList}">
            <tr><td colspan="4" class="text-center">거래 내역이 없습니다.</td></tr>
          </c:if>
        </tbody>
      </table>
    </div>

    <div class="mt-3 text-end">
      <a href="/payment/chargeMileage" class="btn btn-outline-primary">마일리지 충전하기</a>
      <a href="/reservation/reservationHistoryJY" class="btn btn-outline-secondary">예약 내역 보기</a>
    </div>
  </div>
</div>

<jsp:include page="/WEB-INF/views/include/footer.jsp" />
<script src="${pageContext.request.contextPath}/resources/js/bootstrap.bundle.min.js"></script>
</body>
<<<<<<< HEAD
</html>
=======
</html>
>>>>>>> origin/base
