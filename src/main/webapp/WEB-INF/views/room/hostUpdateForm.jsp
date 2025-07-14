<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<%@ include file="/WEB-INF/views/include/head.jsp" %>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
  
<style>
.section-block {
  padding: 40px 0;
  margin-bottom: 40px;
  border-top: 2px solid #e9ecef;
}

.section-heading {
  font-size: 1.75rem;
  font-weight: 600;
  margin-bottom: 1rem;
  padding-bottom: .5rem;
  border-bottom: 3px solid #007bff;
  display: inline-block;
}

.section-bg-light {
  background-color: #f8f9fa;
}
.hero.page-inner {
  /* 기존 overlay 클래스는 지웠다고 가정합니다 */
  width: calc(100% - 40px) !important;
  margin: 0 auto !important;

  /* 배경 이미지 고해상도로 꽉 채우기 */
  background-size: cover !important;
  background-position: center !important;
  background-repeat: no-repeat !important;

  /* height를 조금 더 크게 조정 (예: 300px → 400px 또는 뷰포트 비율) */
  min-height: 400px !important;
  /* 또는 화면의 절반 높이를 사용하려면
  height: 50vh !important;
  */

  /* 브라우저 스케일 품질 최적화 (크롬 등에서 고해상도 렌더링) */
  image-rendering: auto;
  image-rendering: -webkit-optimize-contrast; /* WebKit 전용 */
}


  /* 1) 부모를 기준으로 절대 위치 */
.property-slider-wrap {
  position: relative !important;
}

/* 2) 컨트롤 박스를 슬라이더 전체 높이에 걸쳐서 flex 컨테이너로 */
.property-slider-wrap .tns-outer > .tns-controls {
  position: absolute !important;
  top: 0 !important;
  bottom: 0 !important;
  left: 0 !important;
  right: 0 !important;
  display: flex !important;
  align-items: center !important;       /* 수직 중앙 */
  justify-content: space-between !important; /* 좌우 끝으로 */
  pointer-events: none !important;      /* 배경 클릭 방해 안 함 */
  z-index: 100 !important;
}

/* 3) 버튼만 클릭 가능하도록 */
.property-slider-wrap .tns-outer > .tns-controls button {
  pointer-events: auto !important;
  background: none !important;
  border: none !important;
  padding: 0 !important;
  transform: translateY(-50px) !important;
}

/* 4) 이미지 크기 */
.property-slider-wrap .tns-outer > .tns-controls button img {
  display: block !important;
  width: 32px !important;
  height: 32px !important;
}

  </style>
<script>
$(document).ready(function(){
	$("#btnRoomList").on("click",function(){
		document.roomForm.personCount.value = $("#_personCount").val();
		document.roomForm.action = "/room/roomList";
		document.roomForm.submit();
	});
	
	 $("#reserveBtn").on("click", function(e){
	    e.preventDefault();  // form submit 방지
	    $('html, body').animate({
	      scrollTop: $("#roomTypesSection").offset().top
	    }, 50);
	  });
	 
	 $("#hostDetailDeleteRoom").on("click",function(){
		 
		 alert("삭제 하시겠습니까??");
		 
		 var form = $("roomForm")[0];
		 var formData = new FormData(form);
		 
		 $.ajax({
			type:"POST",
			url:"/room/hostDeleteProc",
			data:formData,
			processData:false,
			contentType:false,
			cache:false,
			timeout:600000,
			dataType:"JSON",
			beforeSend:function(xhr)
			{
				xhr.setRequestHeader("AJAX","true");
			},
			success:function(res)
			{
				if(res.code == 0)
				{
					alert("회원 탈퇴가 완료되었습니다. 소중한 의견 감사드리며, 더 나은 서비스로 찾아뵙겠습니다.");
					location.href = "/";
				}
				else if(res.code == 404)
				{
					alert("회원정보가 존재하지 않습니다.");
					location.href = "/";
				}
				else if(res.code == 410)
				{
					alert("로그인 후 이용 가능합니다.");
					location.href = "/";
				}
				else if(res.code == 500)
				{
					alert("회원탈퇴 중 오류가 발생하였습니다.");
					$("#userPwd").focus();
				}
				else
				{
					alert("회원탈퇴 중 알 수 없는 오류가 발생하였습니다.");
					$("#userPwd").focus();
				}
			},
			error:function(error)
			{
				icia.common.error(error);
			}
		 });
	 });
});
</script>
</head>
<body>

<%@ include file="/WEB-INF/views/include/navigation.jsp" %>
<div class="site-mobile-menu"><div class="site-mobile-menu-body"></div></div>
<div class="loader"></div>
<div id="overlayer"></div>


<c:choose>
  <c:when test="${mainImages.imgType eq 'main'}">
    <c:set var="bgImage"
           value="${pageContext.request.contextPath}/resources/upload/room/main/${mainImages.roomImgName}" />
  </c:when>
  <c:otherwise>
    <c:set var="bgImage"
           value="${pageContext.request.contextPath}/resources/images/file.png" />
  </c:otherwise>
</c:choose>

<!-- 한 번만 열고, bgImage 변수 사용 -->
<div class="hero page-inner"
     style="background-image: url('${bgImage}');">
  <div class="container text-center mt-5">
    <h1 class="heading" data-aos="fade-up">${room.roomTitle}</h1>
  </div>
</div>

<div class="section">
  <div class="container">
    <div class="row justify-content-between align-items-start">
        <!-- 룸타입 섹션 시작 -->
		<section class="room-types section-block">
		  <div class="container">
		    <!-- 섹션 제목 -->
		    <h2 class="section-heading" id="roomTypesSection">룸타입</h2>
		    
		    <!-- 카드 리스트 -->
		    <div class="row g-4 mt-4">
				<c:forEach var="room" items="${roomTypes}">
				  <div class="col-12">
				    <div class="card h-100 border rounded" style="min-height: 220px;">
				      <div class="row g-0">
				        <!-- 이미지 영역 -->
				        <div class="col-md-4">
				          <img
				            src="/resources/upload/roomtype/main/${mainImages.roomImgName}"
				            class="img-fluid h-100 w-100 rounded-start"
				            style="object-fit: cover;"
				            alt="${room.roomTypeTitle}" />
				        </div>
				
				        <!-- 텍스트 영역 -->
				        <div class="col-md-8">
				          <div class="card-body p-3">
				            <h5 class="card-title fs-4 mb-2">${room.roomTypeTitle}</h5>
				            <c:if test="${not empty room.roomTypeDesc}">
				              <p class="text-muted mb-0">${room.roomTypeDesc}</p>
				            </c:if>
				            <p class="mb-1"><strong>정원 : </strong> ${room.maxGuests}명</p>
				            <p class="mb-2"><strong>주중 가격 : </strong><fmt:formatNumber value="${room.weekdayAmt}" pattern="#,###"/>원</p>
				            <p class="mb-2"><strong>주말 가격 : </strong><fmt:formatNumber value="${room.weekendAmt}" pattern="#,###"/>원</p>
				
				            <!-- ✅ 수정/삭제 버튼 추가 -->
				            <div class="mt-3 d-flex gap-2">
				              <button type="button" class="btn btn-sm btn-primary"
				                      onclick="location.href='/room/hostDetailUpdateForm?roomSeq=${room.roomSeq}&roomTypeSeq=${roomType.roomTypeSeq}'">수정하기</button>
				              <button type="button" class="btn btn-sm btn-danger"
				                      onclick="hostDetailDeleteRoom('${room.roomTypeSeq}')">삭제하기</button>
				            </div>
				            <!-- ✅ 끝 -->
				          </div>				         
				        </div>
				      </div>
				    </div>
				  </div>
				</c:forEach>
		    </div>
		     <button type="button" class="btn btn-primary btn-lg" id="btnBack" onclick="history.back()">뒤로가기</button>
		  </div>
		</section>
		<!-- 룸타입 섹션 끝 -->
      </div>
    </div>
  </div>

<%@ include file="/WEB-INF/views/include/footer.jsp" %>
<script src="${pageContext.request.contextPath}/resources/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/tiny-slider.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/aos.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/navbar.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/counter.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/custom.js"></script>

<form name="roomForm" id="roomForm" method="post" enctype="multipart/form-data">     
  <input type="hidden" name="roomSeq" value="${roomSeq}" />
  <input type="hidden" name="searchValue" value="${searchValue}" />
  <input type="hidden" name="curPage"  value="${curPage}" />
  <input type="hidden" name="regionList" id="regionList" value="${regionList}" />
  <input type="hidden" name="startTime" id="startTime" value="${startTime}"/>
  <input type="hidden" name="endTime" id="endTime" value="${endTime}"/>
  <input type="hidden" name="category" id="category" value="${category}"/>
  <input type="hidden" name="personCount" id="personCount" value="${personCount}" />
  <input type="hidden" name="minPrice" id="minPrice" value="${minPrice}" />
  <input type="hidden" name="maxPrice" id="maxPrice" value="${maxPrice}" />
</form>

<form name="roomTypeForm" id="roomTypeForm" method="post">
  <input type="hidden" name="roomTypeSeq" id="roomTypeSeq" value="" />
  <input type="hidden" name="checkIn" id="checkIn" value="${startDate}"/>
  <input type="hidden" name="checkOut" id="checkOut" value="${endDate}"/>
  <input type="hidden" name="numGuests" id="numGuests" value="" />
  <input type="hidden" name="checkInTime" id="checkInTime" value="" />
  <input type="hidden" name="checkOutTime" id="checkOutTime" value="" />
</form>

</body>
</html>
