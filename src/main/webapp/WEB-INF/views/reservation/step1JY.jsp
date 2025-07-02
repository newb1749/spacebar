<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>예약 – 1단계</title>
  <!-- Bootstrap5 CSS -->
  <link href="${pageContext.request.contextPath}/resources/css/bootstrap.min.css" rel="stylesheet" />
  <link href="${pageContext.request.contextPath}/resources/css/style.css" rel="stylesheet" />

<script>
function askAndAddToCart() {
	  if (!confirm("장바구니에 담으시겠습니까?")) return;
	  const data = $('#reserveForm').serialize();
	  $.post('${ctx}/cart/add', data)
	   .done(function(res) {
	     if (res.code === 0) {
	       alert(res.msg);
	       window.location.href = '${ctx}/cart/list';
	     } else {
	       alert("오류: " + res.msg);
	     }
	   })
	   .fail(function(xhr) {
	     alert("네트워크 에러");
	   });
	}

</script>

</head>
<body>



<%@ include file="/WEB-INF/views/include/navigation.jsp" %>

<section class="bg-light" style="margin-top: 100px; padding-top: 60px; padding-bottom: 60px;">
  <div class="container">
    <div class="card mx-auto" style="max-width: 500px;">
      <div class="card-body">
        <h3 class="card-title mb-4">예약 정보 확인</h3>
        <ul class="list-unstyled mb-4">
          <li><strong>객실 타입:</strong> ${roomTypeSeq}</li>
          <li><strong>체크인 날짜:</strong> ${checkIn}</li>
          <li><strong>체크아웃 날짜:</strong> ${checkOut}</li>
          <li><strong>인원 수:</strong> ${numGuests}명</li>
        </ul>

        <form id="reserveForm" action="${pageContext.request.contextPath}/reservation/detailJY" method="post">
          <!-- 공통 hidden -->
          <input type="hidden" name="roomTypeSeq"     value="${roomTypeSeq}" />
          <input type="hidden" name="rsvCheckInDt"     value="${checkIn}" />
          <input type="hidden" name="rsvCheckOutDt"    value="${checkOut}" />
          <input type="hidden" name="numGuests"        value="${numGuests}" />

          <div class="mb-3">
            <label class="form-label">체크인 시간</label>
            <input type="time"  name="rsvCheckInTime"  class="form-control" required />
          </div>
          <div class="mb-3">
            <label class="form-label">체크아웃 시간</label>
            <input type="time"  name="rsvCheckOutTime" class="form-control" required />
          </div>
          <div class="mb-3">
            <label class="form-label">요청사항</label>
            <textarea name="guestMsg" class="form-control" rows="3" placeholder="요청사항을 입력하세요."></textarea>
          </div>

          <!-- 1) 예약확인 -->
          <button type="submit"
                  class="btn btn-primary w-100 mb-2">
            예약 내용 확인
          </button>

          <!-- (2) 장바구니 담기: onclick 으로 AJAX -->
		  <button type="button"
		          class="btn btn-secondary w-100"
		          onclick="askAndAddToCart()">
		    장바구니에 담기
		  </button>
        </form>

      </div>
    </div>
  </div>
</section>

<%@ include file="/WEB-INF/views/include/footer.jsp" %>
<script src="${pageContext.request.contextPath}/resources/js/bootstrap.bundle.min.js"></script>
</body>
</html>
