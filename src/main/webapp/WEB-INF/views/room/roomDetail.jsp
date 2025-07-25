
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
}

/* 4) 이미지 크기 */
.property-slider-wrap .tns-outer > .tns-controls button img {
  display: block !important;
  width: 32px !important;
  height: 32px !important;
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

/* 1) 이미지·텍스트 칸의 h-100 해제 대상에 col‑md‑6 추가 */
.col-md-5.h-100,
.col-md-6.h-100,
.col-md-7.h-100,
.property-slider-wrap.h-100,
.my-roomtype-slider.h-100,
.slide-item.h-100 {
  height: auto !important;
  min-height: 0 !important;
}

/* 2) inner row.align-items-stretch 강제 해제 (g-0 행) */
.room-types .row.g-0.align-items-stretch {
  align-items: flex-start !important;
}

/* 3) card-body padding 좀 더 줄이기 */
.room-types .card-body {
  padding-top: 0.4rem !important;
  padding-bottom: 0.4rem !important;
}

.room-types .my-roomtype-slider img.h-100 {
  height: auto !important;
  min-height: 0 !important;
}

.room-types .slide-item img {
  height: auto !important;      /* 인라인 height:100% 무시 */
  max-height: 200px;            /* 필요하면 원하는 높이(px)로 제한 */
  object-fit: cover !important; /* 기존 object-fit 유지 */
}

/* 슬라이더 컨테이너 및 slide-item 높이 조정 */
.my-roomtype-slider,
.my-roomtype-slider .slide-item {
  height: auto !important;
  min-height: 0 !important;
}

/* 이미지는 가로폭에 맞추고, 세로는 자동 */
.my-roomtype-slider .slide-item img {
  width: 100%;
  height: auto !important;     /* 이거 꼭 auto! */
  max-height: 260px;           /* 세로 최대치(필요 없으면 삭제) */
  object-fit: cover !important;
  display: block;
  border-radius: 18px !important;
}

.extra-small {
  font-size: 0.75em; /* 기본 small(0.875em)보다 더 작음 */
  letter-spacing: -0.01em;
}

.room-types .card {
  border: none;
  border-bottom: 1.5px solid #e2e6ea;
  margin-bottom: 28px;
  box-shadow: 0 2px 12px rgba(0,0,0,0.04);
  transition: box-shadow 0.2s;
}
.room-types .card:last-child {
  border-bottom: none; /* 마지막 카드는 선X */
  margin-bottom: 0;
}
/* 카드 내부 여백 */
.room-types .card-body {
  display: flex;
  flex-direction: column;
  height: 100%;
  padding-bottom: 1.2rem !important;
}
/* 버튼 하단 고정 + 간격 */
.room-types .roomtype-btns {
  margin-top: auto;
  display: flex;
  gap: 0.5rem;
  width: 100%;
}
/* 버튼 스타일(작게+둥글+그림자) */
.room-types .roomtype-btns .btn {
  flex: 1 1 0;
  min-width: 0;
  border-radius: 18px;
  font-size: 1rem;
  padding: 0.45em 0.7em;
  box-shadow: 0 2px 6px rgba(0,0,0,0.07);
  white-space: nowrap;
}
/* 만실(비활성) 버튼 더 연하게 */
.room-types .btn-secondary:disabled {
  background: #e9ecef;
  color: #b0b4b9;
  border: none;
}
/* 이미지와 텍스트 영역 분리 */
.room-types .row.g-0.align-items-stretch {
  align-items: stretch !important;
}

.my-slider .slide-item {
  display: flex;
  justify-content: center;
  align-items: center;
  /* height: 260px; ← 이 줄도 아예 지우거나 주석! */
  /* 높이 제한 없으면 슬라이더 영역도 이미지 크기에 따라 자동 늘어남 */
}

.my-slider .slide-item img {
  width: 100%;           /* 가로 원본 */
  height: 600px;          /* 세로 원본 */
  max-width: none;       /* 제한 없음 */
  max-height: none;      /* 제한 없음 */
  object-fit: cover;      /* 원본 비율/크기 유지 */
  display: block;
  margin: 0 auto;
  border-radius: 18px;
}
.heading {
  font-family: 'Nanum Pen Script', cursive;
  font-size: 3.2rem;
  font-weight: normal;
  color: #222;
  -webkit-text-stroke: 1.2px #222;
  text-shadow: 2px 2px 8px #19e86a; /* ← 밝은 녹색 그림자 */
}

.btn-slim {
  padding: 0.38em 1.3em;
  border-radius: 22px !important;
  font-size: 1.1rem;
  font-weight: 600;
  border: 2px solid #15b360 !important;     /* 진초록 */
  background: #fff;
  color: #15b360 !important;                /* 진초록 글씨 */
  letter-spacing: 0.01em;
  box-shadow: 0 2px 12px #1db95422;
  transition: 
    background 0.16s,
    color 0.16s,
    border-color 0.16s,
    box-shadow 0.16s;
}

.btn-slim:hover, .btn-slim:focus {
  background: #15b360;
  color: #fff !important;
  border-color: #15b360 !important;
  box-shadow: 0 4px 18px #1db95444;
}

.btn-slim-black {
  border-color: #222 !important;
  color: #222 !important;
  background: #fff;
}

.btn-slim-black:hover, .btn-slim-black:focus {
  background: #222;
  color: #fff !important;
  border-color: #19e86a !important;
}

.property-info ul.list-unstyled {
  font-size: 1.23rem;              /* 전체 글자 크기 업 */
  font-weight: 500;                /* 약간 두껍게 */
  color: #202e23;                  /* 더 선명한 검정 */
  letter-spacing: 0.02em;
  line-height: 1.8;
  margin-top: 1.6rem;
  margin-bottom: 1.6rem;
  padding: 0 4px;
  background: #f6fdf7;
  border-radius: 14px;
  box-shadow: 0 4px 18px #17ae5e12;
  border: 1.5px solid #d1f6dc;
}
.property-info ul.list-unstyled li {
  margin-bottom: 0.15em;
  padding: 0.12em 0.2em;
  font-size: 1.18em;                /* 한 번 더 업 */
}

.property-info ul.list-unstyled strong {
  color: #13a656;                   /* 초록 포인트 */
  font-weight: 700;
  margin-right: 4px;
  letter-spacing: 0.03em;
}
/* 공통 버튼 베이스 */
  .btn-green,
  .btn-green-outline {
    border-radius: 24px;
    font-weight: 500;
    padding: 0.6rem 1.2rem;
    transition: background-color 0.3s, color 0.3s, transform 0.1s, box-shadow 0.3s;
    cursor: pointer;
  }

  /* 예약하러 가기 — 채운 버튼 */
  .btn-green {
    background: linear-gradient(135deg, #4caf50 0%, #388e3c 100%);
    color: #fff;
    border: none;
    box-shadow: 0 4px 10px rgba(56, 142, 60, 0.4);
  }
  .btn-green:hover {
    background: linear-gradient(135deg, #43a047 0%, #2e7d32 100%);
    transform: translateY(-2px);
  }
  .btn-green:active {
    background: #2e7d32;
    transform: translateY(0);
    box-shadow: 0 2px 6px rgba(56, 142, 60, 0.2);
  }

  /* 리스트로 돌아가기 — 테두리만 있는 버튼 */
  .btn-green-outline {
    background: transparent;
    color: #388e3c;
    border: 2px solid #388e3c;
    box-shadow: 0 2px 6px rgba(56, 142, 60, 0.2);
    padding: 0.55rem 1.1rem;
  }
  .btn-green-outline:hover {
    background: #388e3c;
    color: #fff;
    transform: translateY(-2px);
    box-shadow: 0 4px 10px rgba(56, 142, 60, 0.4);
  }
  .btn-green-outline:active {
    background: #2e7d32;
    color: #fff;
    transform: translateY(0);
    box-shadow: 0 2px 6px rgba(56, 142, 60, 0.2);
  }

.sticky-tabs.is-fixed {
  position: fixed;
  top: 0px; /* ← 네비게이션 높이만큼 조절 (예: nav가 80px이면) */
  left: 0;
  right: 0;
  z-index: 1001;
  background: #fff;
  border-bottom: 1px solid #eee;
  box-shadow: 0 2px 6px rgba(0,0,0,0.06);
}

.tabs-list li a {
  display: block;
  padding: 0.6rem 1.2rem;
  color: #333;
  font-weight: 700;        /* ← 더 굵게 (기존 500 → 700) */
  font-size: 1.1rem;       /* ← 약간 크게 (기존보다 키움) */
  text-decoration: none;
  border-bottom: 2px solid transparent;
  transition: color 0.2s, border-color 0.2s;
}
  </style>
<script>
// 리뷰 비동기로
function loadReviewList(page) {
    const roomSeq = "${room.roomSeq}";

    $.ajax({
        url: "/review/list",
        type: "GET",
        data: {
            roomSeq: roomSeq,
            reviewCurPage: page
        },
        success: function(fragment) {
            $("#reviewContainer").html(fragment);

            // ✅ 리뷰 렌더링 완료 후 댓글 비동기 호출 시작
            $(".review").each(function () {
                const reviewSeq = $(this).data("review-seq");
                
                console.log("🔥 리뷰시퀀스:", reviewSeq);

                if (reviewSeq && !isNaN(reviewSeq)) {
                    fetch("/review/comment/list?reviewSeq=" + reviewSeq)
                        .then(res => res.json())
                        .then(data => {
                            console.log("💬 댓글 응답: ", data);

                            // ✅ DOM에 댓글 삽입 예시 (id 규칙이 review-comment-2처럼 가정)
                            const commentListHtml = data.data.map(comment => `
                                <div class="comment">
                                    <span><b>${comment.userId}</b></span> :
                                    <span>${comment.reviewCmtContent}</span>
                                </div>
                            `).join("");

                            $("#review-comment-" + reviewSeq).html(commentListHtml);
                        })
                        .catch(err => {
                            console.error("댓글 호출 실패", err);
                        });
                }
            });
        },
        error: function(xhr) {
            alert("리뷰 목록을 불러오는 데 실패했습니다.");
        }
    });
}

/*
function loadReviewList(page) {
    const roomSeq = "${room.roomSeq}";

    $.ajax({
        url: "${pageContext.request.contextPath}/review/list",
        type: "GET",
        data: {
            roomSeq: roomSeq,
            reviewCurPage: page
        },
        success: function(responseHtml) {
            $("#reviewContainer").html(responseHtml);

            // 🚀 댓글 JS 바인딩
            if (typeof bindCommentScripts === 'function') {
                bindCommentScripts();
            }
        }
        error: function(xhr) {
            alert("리뷰 목록을 불러오는 데 실패했습니다.");
            console.error(xhr);
        }
    });
}*/

$(document).ready(function(){
	console.log("✅ 리뷰 호출 시작");
	loadReviewList(1); // 첫 페이지 로딩
	
	$("#btnRoomList").on("click", function(){
	  // 예: 룸 리스트로
	  const url = "${pageContext.request.contextPath}/room/roomList"
	            + "?regionList=" + encodeURIComponent($("#regionList").val())
	            + "&startDate="   + encodeURIComponent($("#checkIn").val())
	            + "&endDate="     + encodeURIComponent($("#checkOut").val())
	            + "&personCount="+ encodeURIComponent($("#_personCount").val())
	            + /*…필요한 파라미터 모두 붙여서…*/"";
	  window.location.href = url;
	});
	
	$("#btnSpaceList").on("click", function(){
	  // 예: 룸 리스트로
	  const url = "${pageContext.request.contextPath}/room/spaceList"
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
	    }, 0);
	  });
	 
	 
});



// 리뷰 페이지 이동 함수 (AJAX)
function fn_review_list(page) {
    const roomSeq = '${room.roomSeq}';

    $.ajax({
        type: "GET",
        url: "/room/reviewListAjax", // 1단계에서 만든 컨트롤러 메소드 URL
        data: {
            roomSeq: roomSeq,
            reviewCurPage: page
        },
        beforeSend: function() {
            $("#review-list-area").html('<div class="text-center p-5"><i class="fa fa-spinner fa-spin"></i> 로딩 중...</div>');
        },
        success: function(responseHtml) {
            $("#review-list-area").html(responseHtml);
        },
        error: function(xhr, status, error) {
            alert("리뷰 목록을 불러오는 데 실패했습니다.");
            console.error("Review AJAX Error: ", error);
        }
    });
}


</script>
<link href="https://fonts.googleapis.com/css2?family=Nanum+Pen+Script&display=swap" rel="stylesheet">
</head>
<body>

<%@ include file="/WEB-INF/views/include/navigation.jsp" %>
<div class="site-mobile-menu"><div class="site-mobile-menu-body"></div></div>
<div class="loader"></div>
<div id="overlayer"></div>

<!-- fixed 탭바 -->
<div class="sticky-tabs" id="tabBar">
  <ul class="tabs-list">
    <li><a href="#mainContent">날짜 선택</a></li>
    <li><a href="#roomTypesSection">예약</a></li>
    <li><a href="#reviewSection">리뷰</a></li>
    <li><a href="#qnaSection">QnA</a></li>
  </ul>
</div>



<div id="mainContent" class="section">
  <div class="container">
    <div class="row justify-content-between align-items-start">
    <!-- 왼쪽 정렬 -->
      <div class="col-lg-9">
		<div class="property-slider-wrap">
		  <!-- Tiny Slider 구조 -->
		  <div class="my-slider">
		    <c:forEach var="roomImg" items="${roomImg}" varStatus="st">
		      <div class="slide-item">
		        <c:choose>
		          <c:when test="${st.first}">
		            <img
		              src="${pageContext.request.contextPath}/resources/upload/room/main/${roomImg.roomImgName}"
		              class="img-fluid"
		              alt="첫번째 룸 이미지" />
		          </c:when>
		          <c:otherwise>
		            <img
		              src="${pageContext.request.contextPath}/resources/upload/room/detail/${roomImg.roomImgName}"
		              class="img-fluid"
		              alt="${roomImg.imgType}" />
		          </c:otherwise>
		        </c:choose>
		      </div>
		    </c:forEach>
		  </div>
		</div>
		
		<div style="height:60px"></div>
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
      <div class="card">
        <div class="row g-0 align-items-stretch">
          <!-- 이미지 영역 -->
          <div class="col-md-6 h-100">

			  <div class="property-slider-wrap h-100">
			    <div class="my-roomtype-slider h-100">
			      <c:forEach var="img" items="${rt.roomTypeImageList}" varStatus="st">
			        <div class="slide-item">
			          <c:choose>
			           
			            <c:when test="${st.first}">
			              <img
			                src="${pageContext.request.contextPath}/resources/upload/roomtype/main/${img.roomTypeImgName}"
			                class="img-fluid w-100"
			                style="object-fit: cover;"
			                alt="첫번째 커스텀 이미지" />
			            </c:when>
			          
			            <c:otherwise>
			              <img
			                src="${pageContext.request.contextPath}/resources/upload/roomtype/detail/${img.roomTypeImgName}"
			                class="img-fluid w-100"
			                style="object-fit: cover;"
			                alt="${img.imgType}" />
			            </c:otherwise>
			          </c:choose>
			        </div>
			      </c:forEach>
			    </div>
			  </div>
			</div>

          <!-- 텍스트 영역 -->
          <div class="col-md-6 d-flex align-items-stretch h-100">
            <div class="card-body">
              <h5 class="card-title fs-4 mb-2">
                ${rt.roomTypeTitle}
              </h5>
              <c:if test="${not empty rt.roomTypeDesc}">
                <p class="text-muted mb-0">${rt.roomTypeDesc}</p>
              </c:if>
              <div style="border-bottom:1px solid #eee; margin: 16px 0;"></div>
              <p class="mb-3 price-line">
                <strong>가격:</strong>
                <fmt:formatNumber value="${rt.weekdayAmt}" pattern="#,###"/>원
                &nbsp;/&nbsp;
                <fmt:formatNumber value="${rt.weekendAmt}" pattern="#,###"/>원
                <br><strong>정원:</strong> ${rt.maxGuests}명
                <br><strong>체크인:</strong>
                ${fn:substring(startDate, 4, 6)}월 ${fn:substring(startDate, 6, 8)}일
                ${fn:substring(rt.roomCheckInTime, 0, 2)}:${fn:substring(rt.roomCheckInTime, 2, 4)}
                &nbsp;/&nbsp;
                <strong>체크아웃:</strong>
					<c:if test="${roomCatSeq >= 8 && roomCatSeq <= 14}">
                ${fn:substring(endDate, 4, 6)}월 ${fn:substring(endDate, 6, 8)}일
                	</c:if>
                ${fn:substring(rt.roomCheckOutTime, 0, 2)}:${fn:substring(rt.roomCheckOutTime, 2, 4)}
              </p>
              <!-- ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓ -->
              <div class="roomtype-btns">
                <c:choose>
                  <c:when test="${rt.reservationCheck > 0}">
                    <button type="button" class="btn btn-secondary btn-sm" disabled>만실</button>
                  </c:when>
                  <c:otherwise>
                    <button type="button"
                      class="btn btn-outline-secondary btn-sm"
                      onclick="fn_reservation(${rt.roomTypeSeq}, ${rt.maxGuests}, ${rt.roomCheckInTime}, ${rt.roomCheckOutTime});">
                      예약하기
                    </button>
                    <button type="button"
                      class="btn btn-outline-secondary btn-sm"
                      onclick="fn_addCart(${rt.roomTypeSeq}, ${rt.maxGuests}, ${rt.roomCheckInTime}, ${rt.roomCheckOutTime});">
                      장바구니
                    </button>
                  </c:otherwise>
                </c:choose>
              </div>
              <!-- ↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑ -->
            </div>
          </div>
        </div>
      </div>
    </div>
    <div style="height:20px"></div>
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
	    <div class="mt-4 p-3 bg-light border rounded shadow-sm">
      <i class="fa fa-map-marker-alt text-success me-2"></i>
      <strong>주소:</strong> ${room.roomAddr}
    </div>
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
                class="w-100 text-center d-inline-block"
                style="font-size:1.1rem; padding:0.6em 0; background-color:#fff; border:1px solid #ddd; border-radius:12px; font-weight:700;">
                 <img src="/resources/upload/facility/${fac.facSeq}.png" alt="${fac.facName}" style="height:40px; margin-right:8px;">
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

<section id="reviewSection" class="review-section section-block">
<h2 class="section-heading">리뷰 목록</h2>
    <div id="reviewContainer"></div>
</section>


<section id="qnaSection" class="Qna-section section-block">
	<div class="container">
		<h2 class="section-heading">QnA목록</h2>
		        <!-- 질문 작성 버튼 -->
			<div class="d-flex justify-content-end gap-2 mb-3 mt-4">
			  <c:if test="${user.userType eq 'G'}">
			    <a href="/room/qnaForm?roomSeq=${room.roomSeq}" class="btn btn-outline-primary">
			      ✏ Q&A 작성하기
			    </a>
			  </c:if>
	
			  <!-- 수정 버튼 (작성자가 회원 본인일 경우에만 노출) -->
			  <!-- <c:if test="${sessionUserId == roomQna.userId}">
			    <a href="/room/qnaUpdateForm?roomSeq=${room.roomSeq}&roomQnaSeq=${qna.roomQnaSeq}" class="btn btn-outline-warning btn">
			      ✏ Q&A 수정하기
			    </a>
			  </c:if> -->
			</div>     
	<!-- QnA 리스트 -->
	<iframe id="qnaIframe" src="/room/qnaList?roomSeq=${room.roomSeq}" width="100%" height="700" frameborder="0"></iframe>
	
	</div>
</section>

      </div>

		<!-- 오른쪽 정렬 -->
      <div class="col-lg-3">
        <div class="property-info">
        
        <!-- ▼ 호스트 정보 카드 -->
  <div class="card mb-4 host-info-card">
    <div class="card-body text-center">
    
     <p class="text-secondary mb-2">이 방의 호스트</p>
      <!-- 1) 프로필 이미지 -->
      <c:choose>
	      <c:when test="${!empty host.profImgExt}">
		      <img
		        src="${pageContext.request.contextPath}/resources/upload/userprofile/${host.userId}.${host.profImgExt}"
		        alt="호스트 프로필"
		        class="rounded-circle mb-3"
		        style="width: 80px; height: 80px; object-fit: cover;"
		      />
	      </c:when>
	      <c:otherwise>
	      	 <img src="/resources/upload/userprofile/default_profile.png" alt="profile" width="40" height="40" style="border-radius: 50%;" />
	      </c:otherwise>
	  </c:choose>
      <!-- 2) 호스트 이름 -->
      <h5 class="card-title mb-1">${host.nickName}</h5>

      <!-- 3) 가입일 -->
      <p class="text-muted mb-2">
        호스트 가입일: 
        ${host.joinDt}
      </p>

      <!-- 4) 소개글 -->
      <p class="mb-0">${host.hostComment}</p>
    </div>

    <!-- 5) 기타 정보 리스트 -->
    <ul class="list-group list-group-flush text-start">
      <li class="list-group-item">
        <strong>이메일:</strong> ${host.email}
      </li>
      <!-- 필요하다면 추가 정보 예시
      <li class="list-group-item">
        <strong>전화번호:</strong> ${host.phone}
      </li>
      -->
    </ul>
  </div>
          

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
          
           

          <!-- 예약 버튼 (초록 아웃라인, 감성) -->
<button id="reserveBtn" class="btn-green mt-3" type="button">예약하러 가기</button>

<div class="mt-2 d-flex gap-2">
  <c:choose>
    <c:when test="${room.roomCatSeq >= 1 && room.roomCatSeq <= 7}">
      <button id="btnSpaceList" type="button" class="btn-green-outline btn-sm px-3">
        공간 리스트로 돌아가기
      </button>
    </c:when>
    <c:when test="${room.roomCatSeq >= 8 && room.roomCatSeq <= 14}">
      <button id="btnRoomList" type="button" class="btn-green-outline btn-sm px-3">
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
document.addEventListener('DOMContentLoaded', function(){
	  const tabBar = document.querySelector('.sticky-tabs');
	  const startOffset = tabBar.offsetTop;

	  window.addEventListener('scroll', () => {
	    if (window.pageYOffset >= startOffset) {
	      tabBar.classList.add('is-fixed');
	    } else {
	      tabBar.classList.remove('is-fixed');
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
	    autoHeight: true,
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
   //document.roomQnaForm.roomSeq.value = "${room.roomSeq}";
   //document.roomQnaForm.curPage.value = curPage;
   //document.roomQnaForm.action = "/room/roomDetail#qnaSection";
   //document.roomQnaForm.submit();
   
    var roomSeq = document.getElementById("roomSeq").value;
    var iframe = document.getElementById("qnaIframe");

    if (iframe && roomSeq) 
    {
        iframe.src = "/room/qnaList?roomSeq=" + roomSeq + "&curPage=" + curPage;
    }
   

}

document.addEventListener('DOMContentLoaded', function(){
	  // room‑type 슬라이더 전부 초기화
	  document.querySelectorAll('.my-roomtype-slider').forEach(function(container){
	    tns({
	      container: container,
	      items: 1,               // 한 슬라이드에 보여줄 개수
	      slideBy: 'page',
	      gutter: 10,
	      autoplay: true,
	      autoplayButtonOutput: false,
	      nav: false,
	      controls: true,
	      autoHeight: true,
	      controlsText: [
	        '<img src="${pageContext.request.contextPath}/resources/images/prev.png" alt="이전">',
	        '<img src="${pageContext.request.contextPath}/resources/images/next.png" alt="다음">'
	      ]
	    });
	  });
	});
	
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
  <input type="hidden" name="roomCatSeq" id="roomCatSeq" value="${roomCatSeq}" />
</form>

<form name="roomQnaForm" id="roomQnaForm">
	<input type="hidden" id="roomSeq" name="roomSeq" value="${room.roomSeq}" />
	<input type="hidden" id="curPage" name="curPage" value="${curPage}" />
</form>
<%--  리뷰 페이징을 위한 폼  --%>
<form name="reviewPageForm" id="reviewPageForm" method="get">
    <input type="hidden" name="roomSeq" value="${room.roomSeq}" />
    <input type="hidden" name="reviewCurPage" value="${reviewCurPage}" />
</form>


</body>
</html>
