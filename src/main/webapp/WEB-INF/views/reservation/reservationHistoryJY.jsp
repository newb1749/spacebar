<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<%@ include file="/WEB-INF/views/include/head.jsp" %>
  <meta charset="UTF-8">
  <title>내 예약 내역</title>

  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/bootstrap.min.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">

  <style>
    body {
      padding-top: 80px;
      background-color: #f8f9fa;
    }
    h2 {
      margin-top: 50px;
      text-align: left !important;
    }
    table {
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
    .btn, .btn-sm {
      font-size: 1.1rem;
      padding: 0.5rem 1.2rem;
      margin-top: 6px;
    }
    form {
      display: inline-block;
    }
    .status-confirmed { color: #28a745; font-weight: bold; }
    .status-pending { color: #ffc107; font-weight: bold; }
    .status-cancelled { color: #dc3545; font-weight: bold; }
    .payment-paid { color: #28a745; font-weight: bold; }
    .payment-unpaid { color: #ffc107; font-weight: bold; }
    .payment-refunded { color: #6c757d; font-weight: bold; }
    
    /* 디버깅용 스타일 */
    .debug-info {
      font-size: 0.8rem;
      color: #6c757d;
      font-style: italic;
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
  <h2>내 예약 내역</h2>

  <!-- 디버깅 정보 (개발 중에만 표시, ?debug=true로 접근 시) -->
  <c:if test="${param.debug eq 'true'}">
    <div class="alert alert-info">
      <strong>디버깅 정보:</strong><br/>
      총 예약 수: ${reservations.size()}<br/>
      <c:if test="${not empty reservations}">
        첫 번째 예약 상태: "${reservations[0].rsvStat}"<br/>
        첫 번째 결제 상태: "${reservations[0].rsvPaymentStat}"
      </c:if>
    </div>
  </c:if>

  <c:if test="${empty reservations}">
    <div class="alert alert-info text-center">예약 내역이 없습니다.</div>
  </c:if>

  <c:if test="${not empty reservations}">
    <table class="table table-bordered">
      <thead>
        <tr>
          <th>예약번호</th>
          <th>객실유형</th>
          <th>체크인</th>
          <th>체크아웃</th>
          <th>상태</th>
          <th>결제상태</th>
          <th>총금액</th>
          <th>작업</th>
        </tr>
      </thead>
      <tbody>
        <c:forEach var="r" items="${reservations}">
          <tr>
            <td>${r.rsvSeq}</td>
            <td>
              <c:choose>
                <c:when test="${not empty r.roomTypeTitle}">
                  ${r.roomTypeTitle}
                </c:when>
                <c:otherwise>
                  객실 ${r.roomTypeSeq}
                </c:otherwise>
              </c:choose>
            </td>
            <td>
              <fmt:formatDate value="${r.rsvCheckInDateObj}" pattern="yyyy-MM-dd"/>
              <c:if test="${not empty r.rsvCheckInTime and r.rsvCheckInTime ne ''}">
                <br/><small>${r.rsvCheckInTime}</small>
              </c:if>
            </td>
            <td>
              <fmt:formatDate value="${r.rsvCheckOutDateObj}" pattern="yyyy-MM-dd"/>
              <c:if test="${not empty r.rsvCheckOutTime and r.rsvCheckOutTime ne ''}">
                <br/><small>${r.rsvCheckOutTime}</small>
              </c:if>
            </td>
            <td>
              <!-- 🔥 수정된 예약 상태 처리 -->
              <c:choose>
                <c:when test="${r.rsvStat eq '예약완료' or r.rsvStat eq 'CONFIRMED' or r.rsvStat eq 'confirmed' or r.rsvStat eq '확정'}">
                  <span class="status-confirmed">예약완료</span>
                </c:when>
                <c:when test="${r.rsvStat eq '취소' or r.rsvStat eq 'CANCELLED' or r.rsvStat eq 'cancelled' or r.rsvStat eq 'CANCEL'}">
                  <span class="status-cancelled">예약취소</span>
                </c:when>
                <c:when test="${r.rsvStat eq 'PENDING' or r.rsvStat eq 'pending' or r.rsvStat eq '대기'}">
                  <span class="status-pending">결제대기</span>
                </c:when>
                <c:otherwise>
                  <span class="status-confirmed">${r.rsvStat}</span>
                  <c:if test="${param.debug eq 'true'}">
                    <br/><span class="debug-info">"${r.rsvStat}"</span>
                  </c:if>
                </c:otherwise>
              </c:choose>
            </td>
            <td>
              <!-- 🔥 수정된 결제 상태 처리 -->
              <c:choose>
                <c:when test="${r.rsvPaymentStat eq '결제완료' or r.rsvPaymentStat eq 'PAID' or r.rsvPaymentStat eq 'paid' or r.rsvPaymentStat eq '완료'}">
                  <span class="payment-paid">결제완료</span>
                </c:when>
                <c:when test="${r.rsvPaymentStat eq 'UNPAID' or r.rsvPaymentStat eq 'unpaid' or r.rsvPaymentStat eq '미결제' or r.rsvPaymentStat eq '대기'}">
                  <span class="payment-unpaid">미결제</span>
                </c:when>
                <c:when test="${r.rsvPaymentStat eq '취소' or r.rsvPaymentStat eq 'REFUNDED' or r.rsvPaymentStat eq 'refunded' or r.rsvPaymentStat eq '환불완료' or r.rsvPaymentStat eq 'CANCELLED'}">
                  <span class="payment-refunded">환불완료</span>
                </c:when>
                <c:otherwise>
                  <span class="payment-paid">${r.rsvPaymentStat}</span>
                  <c:if test="${param.debug eq 'true'}">
                    <br/><span class="debug-info">"${r.rsvPaymentStat}"</span>
                  </c:if>
                </c:otherwise>
              </c:choose>
            </td>
            <td class="amount">
              <fmt:formatNumber value="${r.finalAmt}" groupingUsed="true"/> 원
              <c:if test="${r.totalAmt != r.finalAmt and r.totalAmt > 0}">
                <br/><small class="text-muted">
                  (원가: <fmt:formatNumber value="${r.totalAmt}" groupingUsed="true"/>원)
                </small>
              </c:if>
            </td>
            <td>
              <!-- 🔥 작업 컬럼 수정 - 상태에 따른 적절한 버튼/텍스트 표시 -->
              <c:choose>
                <c:when test="${(r.rsvStat eq '예약완료' or r.rsvStat eq 'CONFIRMED' or r.rsvStat eq 'confirmed' or r.rsvStat eq '확정') 
                               and (r.rsvPaymentStat eq '결제완료' or r.rsvPaymentStat eq 'PAID' or r.rsvPaymentStat eq 'paid')}">
                  <form action="${pageContext.request.contextPath}/reservation/cancel" method="post" 
                        onsubmit="return confirm('정말 취소하시겠습니까?\n환불된 마일리지는 마일리지 내역에서 확인하실 수 있습니다.')">
                    <input type="hidden" name="rsvSeq" value="${r.rsvSeq}" />
                    <button type="submit" class="btn btn-sm btn-danger">환불</button>
                  </form>
                </c:when>
                <c:when test="${r.rsvStat eq '취소' or r.rsvStat eq 'CANCELLED' or r.rsvPaymentStat eq '취소' or r.rsvPaymentStat eq 'REFUNDED'}">
                  <span class="text-success font-weight-bold">환불완료</span>
                </c:when>
                <c:when test="${r.rsvPaymentStat eq 'UNPAID' or r.rsvPaymentStat eq 'unpaid' or r.rsvPaymentStat eq '미결제' or r.rsvPaymentStat eq '대기'}">
                  <span class="text-warning font-weight-bold">결제대기</span>
                </c:when>
                <c:otherwise>
                  <span class="text-primary font-weight-bold">예약완료</span>
                </c:otherwise>
              </c:choose>
            </td>
          </tr>
        </c:forEach>
      </tbody>
    </table>
    
    <div class="mt-4">
      <a href="${pageContext.request.contextPath}/payment/mileageHistory" class="btn btn-outline-primary">마일리지 내역 보기</a>
      <a href="${pageContext.request.contextPath}/" class="btn btn-primary">메인으로 돌아가기</a>
    </div>
  </c:if>
</div>

<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>