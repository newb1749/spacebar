<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <title>마일리지 충전</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/bootstrap.min.css" />
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
<%@ include file="/WEB-INF/views/include/navigation.jsp" %>

<div class="container mt-5">
  <div class="card mx-auto" style="max-width: 500px;">
    <div class="card-body">
      <h3 class="card-title text-center">마일리지 충전</h3>
      <div class="mb-3">
        <label for="amount" class="form-label">충전 금액</label>
        <input type="number" id="amount" name="amount" class="form-control" min="1000" step="1000" required />
      </div>
      <button id="chargeBtn" class="btn btn-primary w-100">카카오페이로 충전하기</button>
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

	    // 카카오페이 결제 준비 요청
		$.ajax(
	    {
			type: 'POST',
	      	url: '${pageContext.request.contextPath}/payment/readyAjax',
	      	data: 
	      	{ 
				chargeAmount: amount 
			},
			success: function (res)
			{
				if(res.code === 0 && res.data && res.data.next_redirect_pc_url) 
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
