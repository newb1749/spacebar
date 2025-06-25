<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>전체 쿠폰 목록 | Spacebar</title>
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />

  <!-- CSS -->
  <link rel="shortcut icon" href="${pageContext.request.contextPath}/resources/images/favicon.ico" type="image/x-icon" />
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/bootstrap.min.css" />
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/aos.css" />
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css" />
  
  <style>
	  .table {
	    width: 100% !important;
	    border-collapse: separate !important;
	    border-spacing: 0;
	    border-radius: 12px;
	    overflow: hidden;
	  }
	  /* 헤더 스타일 */
	  thead tr th {
	    background-color: #273F4F;
	    color: #EFEEEA;
	    font-weight: bold;
	    border: none;
	  }
	  thead tr th:first-child {
	    border-top-left-radius: 12px;
	  }
	  thead tr th:last-child {
	    border-top-right-radius: 12px;
	  }
	  /* 본문 스타일 */
	  tbody tr {
	    background-color: #EFEEEA;
	    color: #000000;
	    transition: background-color 0.3s ease;
	  }
	  tbody tr:hover {
	    background-color: rgba(254, 119, 67, 0.3); /* #FE7743 반투명 */
	  }
	  tbody tr:last-child td:first-child {
	    border-bottom-left-radius: 12px;
	  }
	  tbody tr:last-child td:last-child {
	    border-bottom-right-radius: 12px;
	  }
	  /* 테두리 스타일 */
	  table.table-bordered {
	    border: 1px solid #273F4F;
	  }
	  table.table-bordered td, table.table-bordered th {
	    border: 1px solid #273F4F;
	  }
	</style>
</head>
<body>

<!-- Navigation -->
<jsp:include page="/WEB-INF/views/include/navigation.jsp" />

<!-- 본문 영역 -->
<div class="section bg-light" style="padding-top: 250px;">
  <div class="container">
    <div class="row justify-content-center mb-4">
      <div class="col-lg-12"><!-- 넓게 쓰려고 col-lg-10 → 12로 변경 -->
        <div class="table-responsive">
          <table class="table table-bordered table-hover bg-white text-center align-middle">
            <thead class="table-dark">
              <tr>
                <th>쿠폰번호</th>
                <th>쿠폰명</th>
                <th>설명</th>
                <th>할인율/금액</th>
                <th>발급 시작일</th>
                <th>발급 종료일</th>
                <th>상태</th>
                <th>등록일</th>
              </tr>
            </thead>
            <tbody>
              <c:forEach var="coupon" items="${couponList}">
                <tr>
                  <td>${coupon.cpnSeq}</td>
                  <td>${coupon.cpnName}</td>
                  <td>${coupon.cpnDesc}</td>
                  <td>
                    <c:choose>
                      <c:when test="${coupon.discountRate > 0}">
                        ${coupon.discountRate}%
                      </c:when>
                      <c:when test="${coupon.discountAmt > 0}">
                        ${coupon.discountAmt}원
                      </c:when>
                      <c:otherwise>-</c:otherwise>
                    </c:choose>
                  </td>
                  <td>${coupon.issueStartDt}</td>
                  <td>${coupon.issueEndDt}</td>
                  <td>
                    <c:choose>
                      <c:when test="${coupon.cpnStat eq 'Y'}">활성</c:when>
                      <c:otherwise>비활성</c:otherwise>
                    </c:choose>
                  </td>
                  <td>${coupon.regDt}</td>
                </tr>
              </c:forEach>
              <c:if test="${empty couponList}">
                <tr>
                  <td colspan="8">등록된 쿠폰이 없습니다.</td>
                </tr>
              </c:if>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </div>
</div>

<!-- Footer -->
<jsp:include page="/WEB-INF/views/include/footer.jsp" />

<!-- JS -->
<script src="${pageContext.request.contextPath}/resources/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/aos.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/custom.js"></script>
<script>
  AOS.init({ duration: 800, easing: 'slide', once: true });
</script>

</body>
</html>
