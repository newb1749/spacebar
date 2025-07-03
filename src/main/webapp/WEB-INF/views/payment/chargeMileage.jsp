<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
  <title>마일리지 충전</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/bootstrap.min.css" />
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css" />
  <style>
    body {
      padding-top: 100px;
      font-family: 'Noto Sans KR', sans-serif;
      background-color: #f8f9fa;
    }
    .card {
      max-width: 500px;
      margin: 0 auto;
      box-shadow: 0 0 12px rgba(0,0,0,0.1);
      border-radius: 8px;
    }
    .card-body {
      padding: 30px;
    }
    h3 {
      text-align: center;
      font-weight: 700;
      margin-bottom: 30px;
      color: #343a40;
    }
    .btn-primary {
      background-color: #fe7743;
      border: none;
      font-weight: 700;
      font-size: 1.1rem;
      width: 100%;
      transition: background-color 0.3s ease;
    }
    .btn-primary:hover {
      background-color: #e96328;
    }
    .form-label {
      font-weight: 600;
    }
  </style>
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>

<%@ include file="/WEB-INF/views/include/navigation.jsp" %>

<div class="container mt-5">
  <div class="card">
    <div class="card-body">
      <h3>마일리지 충전</h3>
      <div class="mb-3">
        <label for="amount" class="form-label">충전 금액</label>
        <input type="number" id="amount" name="amount" class="form-control" min="1000" step="1000" required />
      </div>
      <button id="chargeBtn" class="btn btn-primary">카카오페이로 충전하기</button>
    </div>
  </div>
</div>

<%@ include file="/WEB-INF/views/include/footer.jsp" %>
<script src="${pageContext.request.contextPath}/resources/js/bootstrap.bundle.min.js"></script>

<script>
	$('#chargeBtn').on('click', function () 
	{
	    const amount = $('#amount').val();
	    if (!amount || parseInt(amount) < 1000) 
	    {
	      alert('최소 1,000원 이상 입력해주세요.');
	      return;
	    }

	    $.ajax({
	      type: 'POST',
	      url: '${pageContext.request.contextPath}/payment/readyAjax',
	      data: { chargeAmount: amount },
	      success: function (res) 
	      {
	        if (res.code === 0 && res.data && res.data.next_redirect_pc_url) 
	        {
	          window.location.href = res.data.next_redirect_pc_url;
	        } 
	        else 
	        {
	          alert("카카오페이 요청에 실패했습니다: " + (res.msg || ""));
	        }
	      },
	      error: function () 
	      {
	        alert("서버 통신에 실패했습니다.");
	      }
	    });
  });
</script>

</body>
</html>
