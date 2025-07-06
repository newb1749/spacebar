<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <title>마일리지 충전</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/bootstrap.min.css" />
</head>
<body>
<%@ include file="/WEB-INF/views/include/navigation.jsp" %>

<div class="container mt-5">
  <div class="card mx-auto" style="max-width: 500px;">
    <div class="card-body">
      <h3 class="card-title text-center">마일리지 충전</h3>
      <form method="post" action="${pageContext.request.contextPath}/payment/chargeMileage">
        <div class="mb-3">
          <label for="amount" class="form-label">충전 금액</label>
          <input type="number" id="amount" name="amount" class="form-control" min="1000" step="1000" required />
        </div>
        <button type="submit" class="btn btn-primary w-100">충전하기</button>
      </form>
    </div>
  </div>
</div>

<%@ include file="/WEB-INF/views/include/footer.jsp" %>
<script src="${pageContext.request.contextPath}/resources/js/bootstrap.bundle.min.js"></script>
</body>
</html>