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

.sticky-tabs {
  position: relative;     /* 처음엔 문서 흐름에 따라 위치 */
  top: auto;
  left: 0;
  right: 0;
  background: #fff;
  border-bottom: 1px solid #eee;
  z-index: 200;
  box-shadow: 0 2px 4px rgba(0,0,0,0.05);
  transition: box-shadow .2s;
}

.sticky-tabs.fixed {
  position: fixed;        /* fixed 클래스가 붙으면 고정 */
  top: 0px;              /* 네비게이션바 높이만큼 아래로 */
  width: 100%;
  box-shadow: 0 4px 8px rgba(0,0,0,0.1);
}
/* 탭 리스트 */
.tabs-list {
  display: flex;
  justify-content: center; /* 가운데 정렬 */
  gap: 1rem;
  margin: 0;
  padding: 0.5rem 1rem;
  list-style: none;
}

/* 각 탭 */
.tabs-list li a {
  display: block;
  padding: 0.5rem 1rem;
  color: #333;
  font-weight: 500;
  text-decoration: none;
  border-bottom: 2px solid transparent;
  transition: color 0.2s, border-color 0.2s;
}

.tabs-list li a.active,
.tabs-list li a:hover {
  color: #007bff;
  border-color: #007bff;
}

#mainContent {
  /* 헤더(56px) + 탭바 높이(48px) */
  padding-top: calc(0px + 48px);
}

  </style>
<script>
$(document).ready(function(){
	$("#btnRoomList, #btnSpaceList").on("click", function(){
	  // 예: 룸 리스트로
	  const url = "${pageContext.request.contextPath}/room/roomList"
	            + "?regionList=" + encodeURIComponent($("#regionList").val())
	            + "&startDate="   + encodeURIComponent($("#checkIn").val())
	            + "&endDate="     + encodeURIComponent($("#checkOut").val())
	            + "&personCount="+ encodeURIComponent($("#_personCount").val())
	            + /*…필요한 파라미터 모두 붙여서…*/"";
	  window.location.href = url;
	});
	
	 $("#reserveBtn").on("click", function(e){
	    e.preventDefault();  // form submit 방지
	    $('html, body').animate({
	      scrollTop: $("#roomTypesSection").offset().top
	    }, 50);
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

<!-- fixed 탭바 -->
<div class="sticky-tabs" id="tabBar">
  <ul class="tabs-list">
    <li><a href="#typeSection">상품상세</a></li>
    <li><a href="#placeSection">상품평</a></li>
    <li><a href="#qnaSection">상품문의</a></li>
    <li><a href="#shippingInfo">배송/교환/반품 안내</a></li>
  </ul>
</div>

<div id="mainContent" class="section">
  <div class="container">
    <div class="row justify-content-between align-items-start">
    <!-- 왼쪽 정렬 -->
      <div class="col-lg-7">
        <div class="property-slider-wrap">
		  <!-- Tiny Slider 구조 -->
		  <div class="my-slider">
		    <c:forEach var="roomImg" items="${detailImages}">
		      <div class="slide-item">
		        <img src="${pageContext.request.contextPath}/resources/upload/room/detail/${roomImg.roomImgName}"
		             class="img-fluid" alt="${roomImg.imgType}" />
		      </div>
		    </c:forEach>
		  </div>
		</div>
			<section class="room-description section-block section-bg-light">
			  <div class="container">
			    <!-- 제목 -->
			    <h2 class="section-heading text-primary mb-3">${room.roomTitle}</h2>
			    <!-- 위치 -->
			    <p class="meta mb-1">
			      <i class="icon-map-marker"></i>
			      ${room.roomAddr} (${room.region})
			    </p>
			    <!-- 상세 설명 -->
			    <p class="text-black-50">${room.roomDesc}</p>
			  </div>
			</section>
          
          <!-- 룸타입 섹션 시작 -->
<section id="typeSection" class="room-types section-block">
  <div class="container">
    <!-- 섹션 제목 -->
    <h2 class="section-heading" id="roomTypesSection">룸타입</h2>
    
    <!-- 카드 리스트 -->
    <div class="row g-4 mt-4">
      <c:forEach var="rt" items="${roomTypes}">
        <div class="col-12">
          <div class="card h-100 border rounded" style="min-height: 220px;">
            <div class="row g-0">
              <!-- 이미지 영역 -->
              <div class="col-md-4">
                <img
                  src="${pageContext.request.contextPath}/resources/upload/roomtype/main/${rt.roomTypeSeq}.jpg"
                  class="img-fluid h-100 w-100 rounded-start"
                  style="object-fit: cover;"
                  alt="${rt.roomTypeTitle}" />
              </div>
              <!-- 텍스트 영역 -->
              <div class="col-md-8">
                <div class="card-body p-3">
                  <h5 class="card-title fs-4 mb-2">${rt.roomTypeTitle}</h5>
                  <c:if test="${not empty rt.roomTypeDesc}">
                    <p class="text-muted mb-0">${rt.roomTypeDesc}</p>
                  </c:if>
                  <p class="mb-1"><strong>정원:</strong> ${rt.maxGuests}명</p>
                  <p class="mb-2"><strong>주중가격:</strong> ${rt.weekdayAmt}원</p>
                  <p class="mb-3"><strong>주말 가격:</strong> ${rt.weekendAmt}원</p>

                  <c:choose>
                    <c:when test="${rt.reservationCheck > 0}">
                      <button type="button" class="btn btn-secondary mt-3" disabled>만실</button>
                    </c:when>
                    <c:otherwise>
                      <div class="d-flex gap-2 mt-3">
                        <button type="button"
                                class="btn btn-primary"
                                onclick="fn_reservation(${rt.roomTypeSeq}, ${rt.maxGuests}, ${rt.roomCheckInTime}, ${rt.roomCheckOutTime});">
                          예약하기
                        </button>
                        <button type="button"
                                class="btn btn-secondary"
                                onclick="fn_addCart(${rt.roomTypeSeq}, ${rt.maxGuests}, ${rt.roomCheckInTime}, ${rt.roomCheckOutTime});">
                          장바구니
                        </button>
                      </div>
                    </c:otherwise>
                  </c:choose>

                </div>
              </div>
            </div>
          </div>
        </div>
      </c:forEach>
    </div>
  </div>
</section>
<!-- 룸타입 섹션 끝 -->

          

	 <!-- 지도 섹션 시작 -->
	<section id="placeSection" class="map-section section-block">
	  <div class="container">
	    <!-- 섹션 제목 -->
	    <h2 class="section-heading">위치</h2>
	
	    <%-- 지도 모듈 포함 --%>
	    <jsp:include page="/WEB-INF/views/component/mapModule.jsp">
	      <jsp:param name="address"   value="${room.roomAddr}"   />
	      <jsp:param name="roomName"  value="${room.roomTitle}"  />
	    </jsp:include>
	  </div>
	</section>
	<!-- 지도 섹션 끝 -->
	
<section class="facility-section section-block">
  <div class="container">
    <h2 class="section-heading">편의시설</h2>
    <div class="row">
      <c:choose>
        <c:when test="${not empty facilityList}">
          <c:forEach var="fac" items="${facilityList}">
            <div class="col-3 mb-3">
              <span 
                class="badge bg-secondary w-100 text-center" 
                style="font-size:1.1rem; padding:0.6em 0;">
                ${fac.facName}
              </span>
            </div>
          </c:forEach>
        </c:when>
        <c:otherwise>
          <p>선택된 편의시설이 없습니다.</p>
        </c:otherwise>
      </c:choose>
    </div>
  </div>
</section>

<section id="qnaSection" class="Qna-section section-block">
	<div class="container">
		<h2 class="section-heading">QnA목록</h2>
		        <!-- 질문 작성 버튼 -->
			<div class="d-flex justify-content-end gap-2 mb-3 mt-4">
			  <c:if test="${user.userType eq 'G'}">
			    <a href="/room/qnaForm_mj?roomSeq=${room.roomSeq}" class="btn btn-outline-primary">
			      ✏ Q&A 작성하기
			    </a>
			  </c:if>
	
			  <!-- 수정 버튼 (작성자가 회원 본인일 경우에만 노출) -->
			  <!-- <c:if test="${sessionUserId == roomQna.userId}">
			    <a href="/room/qnaUpdateForm_mj?roomSeq=${room.roomSeq}&roomQnaSeq=${qna.roomQnaSeq}" class="btn btn-outline-warning btn">
			      ✏ Q&A 수정하기
			    </a>
			  </c:if> -->
			</div>     
	
	        <!-- QnA 리스트 -->
	        <div class="clearfix">
	        <div class="qna-list mt-3">
	          <c:forEach var="qna" items="${qnaList}">
	            <div class="qna-item d-flex mb-4 pb-4 border-bottom">
	              <div class="qna-avatar me-3">
	              <!-- 게스트 Q&A -->
	              <c:choose>
	              <c:when test="${!empty qna.profImgExt}">
	                <img src="/resources/upload/userprofile/${qna.userId}.${qna.profImgExt}"  
	                alt="profile" width="40" height="40" style="border-radius: 50%;" />
	               </c:when>
	               <c:otherwise>
	               	<img src="/resources/upload/userprofile/default_profile.png"  
	                alt="profile" width="40" height="40" style="border-radius: 50%;" />
	               </c:otherwise>
	              </c:choose>
	              </div>
	              <div class="qna-content w-100">
	                <p class="fw-bold mb-1">${qna.nickName}</p>
	                <p class="mb-1">${qna.roomQnaContent}</p>
					<p class="text-muted mb-2" style="font-size: 0.9em;">
					    <c:choose>
					    	<%-- 수정일자가 있을 경우 --%>
					        <c:when test="${!empty qna.updateDt}">
					            수정일자: ${qna.updateDt}
					        </c:when>
					        <%-- 수정일자가 없을 경우 --%>
					        <c:otherwise>
					            등록일자: ${qna.regDt}
					        </c:otherwise>
					    </c:choose>
					</p>
	                
	           <!-- 수정 버튼 (작성자가 회원 본인일 경우에만 노출) -->
			   <c:if test="${sessionUserId == qna.userId}">
			    <a href="/room/qnaUpdateForm_mj?roomSeq=${qna.roomSeq}&roomQnaSeq=${qna.roomQnaSeq}" class="btn btn-outline-warning btn">
			      ✏ Q&A 수정하기
			    </a>
			  </c:if> 
	                
	                <!-- 호스트 답글 -->
	                <c:if test="${!empty qna.roomQnaComment}">
	                  <div class="qna-answer bg-light p-2 rounded">
	                    <p class="text-primary fw-semibold mb-1">호스트의 답글</p>
	                    <p class="mb-1">${qna.roomQnaComment.roomQnaCmtContent}</p>                  
	                    <p class="text-muted mb-2" style="font-size: 0.9em;">
						    <c:choose>
						    	<%-- 수정일자가 있을 경우 --%>
						        <c:when test="${!empty qna.roomQnaComment.updateDt}">
						            수정일자: ${qna.roomQnaComment.updateDt}
						        </c:when>
						        <%-- 수정일자가 없을 경우 --%>
						        <c:otherwise>
						            등록일자: ${qna.roomQnaComment.createDt}
						        </c:otherwise>
						    </c:choose>
						</p>
	                  </div>
	                </c:if>
	                <!-- 답글 작성 버튼 -->
	                <div class="d-flex justify-content-end gap-2 mb-3 mt-4">
	                 <c:if test="${user.userType =='H' and empty qna.roomQnaComment}">
	                     <a href="/room/qnaCmtForm_mj?roomSeq=${qna.roomSeq}&roomQnaSeq=${qna.roomQnaSeq}" class="btn btn-outline-primary">
	                       ✏ 답글 작성하기
	                     </a>
	                </c:if> 
	                <!-- 답글 수정 버튼 -->
				    <c:if test="${user.userType =='H' and !empty qna.roomQnaComment}">
				      <a href="/room/qnaCmtUpdateForm_mj?roomSeq=${qna.roomSeq}&roomQnaSeq=${qna.roomQnaSeq}&roomQnaCmtSeq=${qna.roomQnaComment.roomQnaCmtSeq}" class="btn btn-outline-warning btn">
				        ✏ 답글 수정하기
				      </a>
				    </c:if>                      
	              </div>
	              </div>
	            </div>
	          </c:forEach>
	          <c:if test="${empty qnaList}">
	            <p class="text-muted text-center">등록된 Q&A가 없습니다.</p>
	          </c:if>
	        </div>
	      </div>
	      
			<!-- 📌 QnA 리스트 아래 페이징 영역 시작 -->
	<div class="paging text-center mt-4">
	  <nav>
	    <ul class="pagination justify-content-center">
	      <c:if test="${!empty paging}">
	        <!-- 이전 블럭 -->
	        <c:if test="${paging.prevBlockPage gt 0}">
	          <li class="page-item">
	            <a class="page-link" href="javascript:void(0)" onclick="fn_list(${paging.prevBlockPage})">이전블럭</a>
	          </li>
	        </c:if>
	
	        <!-- 페이지 번호 -->
	        <c:forEach var="i" begin="${paging.startPage}" end="${paging.endPage}">
	          <c:choose>
	            <c:when test="${i ne curPage}">
	              <li class="page-item">
	                <a class="page-link" href="javascript:void(0)" onclick="fn_list(${i})">${i}</a>
	              </li>
	            </c:when>
	            <c:otherwise>
	              <li class="page-item active">
	                <a class="page-link" href="javascript:void(0)" style="cursor:default;">${i}</a>
	              </li>
	            </c:otherwise>
	          </c:choose>
	        </c:forEach>
	
	        <!-- 다음 블럭 -->
	        <c:if test="${paging.nextBlockPage gt 0}">
	          <li class="page-item">
	            <a class="page-link" href="javascript:void(0)" onclick="fn_list(${paging.nextBlockPage})">다음블럭</a>
	          </li>
	        </c:if>
	      </c:if>
	    </ul>
	  </nav>
	</div>
	<!-- 📌 QnA 리스트 아래 페이징 영역 끝 -->
	</div>
</section>

      </div>

		<!-- 오른쪽 정렬 -->
      <div class="col-lg-4">
        <div class="property-info">
          

          <%-- 달력 모듈 포함 --%>
          <label class="mt-3">날짜 선택: </label></br>
          <jsp:include page="/WEB-INF/views/component/calendar.jsp">
            <jsp:param name="calId" value="roomDetailCalendar" />
            <jsp:param name="fetchUrl" value="" />
            <jsp:param name="startDate" value="${startDate}" />
	    	<jsp:param name="endDate" value="${endDate}" />
          </jsp:include>
		</br>


          <%-- 인원 수 선택 --%>
          <label for="numGuests" class="mt-3">인원 수 선택:</label>
<input type="number" id="_personCount" name="_personCount" class="form-control shadow-sm" style="width: 100px; height: 44px; border-radius: 12px; text-align: center;"
    placeholder="인원수" value="${personCount != 0 ? personCount : ''}" min="0" step="1"/>
          
          <ul class="list-unstyled mt-4">
            <li><strong>등록일:</strong> ${room.regDt}</li>
            <li><strong>이용 시간:</strong> ${room.minTimes} ~ ${room.maxTimes}시간</li>
            <li><strong>자동 예약 확정:</strong>
              <c:choose>
                <c:when test="${room.autoConfirmYn == 'Y'}">예</c:when>
                <c:otherwise>아니오</c:otherwise>
              </c:choose>
            </li>
            <li><strong>취소 정책:</strong> ${room.cancelPolicy}</li>
            <li><strong>평점:</strong> ${room.averageRating} / 리뷰 수: ${room.reviewCount}</li>
          </ul>

          <%-- 예약하기 버튼 --%>
          <button id="reserveBtn" class="btn btn-primary mt-3">예약하기</button>
		
		<%-- roomCatSeq 값에 따라 추가 버튼 노출 --%>
			<div class="mt-2 d-flex">
			  <c:choose>
			    <c:when test="${room.roomCatSeq >= 1 && room.roomCatSeq <= 7}">
			      <button id="btnSpaceList" type="button" class="btn btn-secondary btn-sm px-3">
			        공간 리스트로 돌아가기
			      </button>
			    </c:when>
			    <c:when test="${room.roomCatSeq >= 8 && room.roomCatSeq <= 14}">
			      <button id="btnRoomList" type="button" class="btn btn-secondary btn-sm px-3">
			        룸 리스트로 돌아가기
			      </button>
			    </c:when>
			  </c:choose>
			</div>

        </div>
      </div>
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

<script>
document.addEventListener("DOMContentLoaded", function(){
  const tabBar = document.getElementById("tabBar");
  // 탭바가 문서에서 차지하는 원래 Y 위치
  const stickyPoint = tabBar.getBoundingClientRect().top + window.scrollY - 56;

  window.addEventListener("scroll", () => {
    if (window.scrollY > stickyPoint) {
      tabBar.classList.add("fixed");
    } else {
      tabBar.classList.remove("fixed");
    }
  });
});
</script>

<script>
  document.addEventListener('DOMContentLoaded', function () {

    
 // 2️⃣ hidden input을 form 내부로 강제 이동
    const startInput = document.getElementById(calendarId + '_start');
    const endInput   = document.getElementById(calendarId + '_end');
    const form       = document.getElementById("roomForm");  // 여기에 id="roomForm" 폼을 잡아서

    if (form) {
      if (startInput && !form.contains(startInput)) {
        form.appendChild(startInput);
      }
      if (endInput   && !form.contains(endInput)) {
        form.appendChild(endInput);
      }
    } else {
      console.warn("roomForm을 찾을 수 없음");
    }


    
  });
  
  document.addEventListener('DOMContentLoaded', function() {
	  var slider = tns({
	    container: '.my-slider',
	    items: 1,
	    slideBy: 'page',
	    autoplay: true,
	    autoplayButtonOutput: false,
	    nav: false,
	    controls: true,
	    gutter: 10,
	    controlsText: [
	      // 왼쪽 버튼: <img> 태그로 교체
	      '<img src="${pageContext.request.contextPath}/resources/images/prev.png" alt="이전">',
	      // 오른쪽 버튼: <img> 태그로 교체
	      '<img src="${pageContext.request.contextPath}/resources/images/next.png" alt="다음">'
	    ]
	  });
	});
  
  document.addEventListener('DOMContentLoaded', function(){
	  const calInput = document.getElementById("roomDetailCalendar");
	  const form     = document.getElementById("roomForm");
	  if (!calInput || !calInput._flatpickr || !form) return;

	  // 1) 새로고침 후 이전 스크롤 위치 복원
	  const savedPos = sessionStorage.getItem("roomDetailScrollPos");
	  if (savedPos) {
	    window.scrollTo({ top: parseInt(savedPos, 10), behavior: "instant" });
	    sessionStorage.removeItem("roomDetailScrollPos");
	  }

	  // 2) 날짜 변경 시 — selectedDates 길이가 2일 때만 submit
	  calInput._flatpickr.config.onChange.push(function(selectedDates){
	    if (selectedDates.length === 2) {
	      // 2-1) 현재 스크롤 위치 저장
	      sessionStorage.setItem("roomDetailScrollPos", window.scrollY);
	      // 2-2) 폼 제출 (page reload)
	      form.submit();
	    }
	  });
	});
	
function fn_reservation(roomTypeSeq, maxGuests, roomCheckInTime, roomCheckOutTime)
{
	var count = parseInt(document.getElementById('_personCount').value, 10);
	const roomCatSeq = ${room.roomCatSeq};
	
	const startDate  = document.getElementById('checkIn').value;
	const endDate = document.getElementById('checkOut').value;

	
	if (isNaN(count) || count <= 0) 
	{
	    alert('인원수를 1명 이상 선택해주세요');
	    return;
	}
	
	if (count > maxGuests)
	{
		alert("최대 인원 수는 " + maxGuests + "명입니다.");
		return;
	}
	
	if(roomCatSeq >= 1 && roomCatSeq <= 7)
	{
		if(startDate != endDate)
		{
			alert("날짜는 하루만 선택해 주세요");
			return;
		}
	}
	
	if(roomCatSeq >= 8 && roomCatSeq <= 14)
	{
		if(startDate == endDate)
		{
			alert("날짜는 하루 이상 선택해주세요");
			return;
		}
	}
	
	document.roomTypeForm.method = 'get';
	document.roomTypeForm.roomTypeSeq.value = roomTypeSeq;
	document.roomTypeForm.numGuests.value = count;
	document.roomTypeForm.checkInTime.value = roomCheckInTime;
	document.roomTypeForm.checkOutTime.value = roomCheckOutTime;
	document.roomTypeForm.action = "${pageContext.request.contextPath}/reservation/step1JY";
	document.roomTypeForm.submit();
}

function fn_addCart(roomTypeSeq, maxGuests, roomCheckInTime, roomCheckOutTime)
{
	var count = parseInt(document.getElementById('_personCount').value, 10);
	const roomCatSeq = ${room.roomCatSeq};
	
	const startDate  = document.getElementById('checkIn').value;
	const endDate = document.getElementById('checkOut').value;
	
	if (isNaN(count) || count <= 0) 
	{
	    alert('인원수를 1명 이상 선택해주세요');
	    return;
	}
	
	if (count > maxGuests)
	{
		alert("최대 인원 수는 " + maxGuests + "명입니다.");
		return;
	}
	
	if(roomCatSeq >= 1 && roomCatSeq <= 7)
	{
		if(startDate != endDate)
		{
			alert("날짜는 하루만 선택해 주세요");
			return;
		}
	}
	
	if(roomCatSeq >= 8 && roomCatSeq <= 14)
	{
		if(startDate == endDate)
		{
			alert("날짜는 하루 이상 선택해주세요");
			return;
		}
	}
	document.roomTypeForm.roomTypeSeq.value = roomTypeSeq;
	document.roomTypeForm.numGuests.value = count;
	document.roomTypeForm.checkInTime.value = roomCheckInTime;
	document.roomTypeForm.checkOutTime.value = roomCheckOutTime;
	
	$.ajax({
		type:"POST",
		url:"${pageContext.request.contextPath}/cart/add",
		data:{
			roomTypeSeq:$("#roomTypeSeq").val(),
			rsvCheckInDt:$("#checkIn").val(),
			rsvCheckOutDt:$("#checkOut").val(),
			numGuests:$("#numGuests").val(),
			rsvCheckInTime:$("#checkInTime").val(),
			rsvCheckOutTime:$("#checkOutTime").val()
		},
		datatype:"JSON",
		beforeSend:function(xhr)
		{
			xhr.setRequestHeader("AJAX","true");
		},
		success:function(response)
		{
			if(response.code == 0)
			{
				if (confirm("장바구니에 추가되었습니다.\n지금 장바구니로 이동하시겠습니까?")) 
				{
                    window.location.href = "${pageContext.request.contextPath}/cart/list";
                }
			}
			else if(response.code == 500)
			{
				alert("장바구니 추가에 실패하였습니다.");
				return;
			}
		},
		error:function(xhr,status,error)
		{
			icia.common.error(error);
		}
	});
}

function fn_list(curPage)
{
   document.roomQnaForm.roomSeq.value = "${room.roomSeq}";
   document.roomQnaForm.curPage.value = curPage;
   document.roomQnaForm.action = "/room/roomDetail#qnaSection";
   document.roomQnaForm.submit();
}
	
</script>

<form name="roomForm" id="roomForm" method="get" action="${pageContext.request.contextPath}/room/roomDetail">
  <input type="hidden" name="roomSeq" value="${roomSeq}" />
  <input type="hidden" name="searchValue" value="${searchValue}" />
  <input type="hidden" name="curPage"  value="" />
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

<form name="roomQnaForm" id="roomQnaForm">
	<input type="hidden" name="roomSeq" value="${room.roomSeq}" />
	<input type="hidden" name="curPage" value="${curPage}" />
</form>

</body>
</html>