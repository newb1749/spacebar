<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/WEB-INF/views/include/head.jsp" %>
<!DOCTYPE html>
<html lang="ko">
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>${room.roomTitle} - 숙소 상세</title>

    <!-- Themewagon Property 템플릿 기반 리소스 -->
    <link rel="stylesheet" href="/resources/fonts/icomoon/style.css" />
    <link rel="stylesheet" href="/resources/fonts/flaticon/font/flaticon.css" />
    <link rel="stylesheet" href="/resources/css/tiny-slider.css" />
    <link rel="stylesheet" href="/resources/css/aos.css" />
    <link rel="stylesheet" href="/resources/css/style.css" />
  </head>
  <body>
    <%@ include file="/WEB-INF/views/include/navigation.jsp" %>

    <!-- Hero 이미지 및 타이틀 -->
    <div class="hero page-inner overlay" style="background-image: url('/resources/images/hero_bg_3.jpg')">
      <div class="container text-center mt-5">
        <h1 class="heading" data-aos="fade-up">${room.roomTitle}</h1>
      </div>
    </div>

    <!-- 숙소 상세 섹션 -->
    <div class="section">
      <div class="container">
        <div class="row justify-content-between align-items-start">

          <!-- 이미지 슬라이더 -->
          <div class="col-lg-7">
            <div class="property-slider-wrap">
              <div class="property-slider tiny-slider">
                <c:forEach var="img" items="${room.roomImageList}">
                  <c:choose>
                    <c:when test="${img.imgType == 'main'}">
                      <div class="item">
                        <img src="/resources/upload/room/mainImg/${img.roomImgOrigName}" class="img-fluid" alt="${img.roomImgOrigName}">
                      </div>
                    </c:when>
                    <c:when test="${img.imgType == 'detail'}">
                      <div class="item">
                        <img src="/resources/upload/room/detailImg/${img.roomImgOrigName}" class="img-fluid" alt="${img.roomImgOrigName}">
                      </div>
                    </c:when>
                  </c:choose>
                </c:forEach>
              </div>
            </div>
          </div>

          <!-- 숙소 텍스트 정보 -->
          <div class="col-lg-4">
            <div class="property-info">
              <h2 class="text-primary mb-3">${room.roomTitle}</h2>
              <p class="meta mb-1"><i class="icon-map-marker"></i> ${room.roomAddr} (${room.region})</p>
              <p class="text-black-50">${room.roomDesc}</p>
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
            </div>
          </div>
        </div>
      </div>
    </div>

    <%@ include file="/WEB-INF/views/include/footer.jsp" %>

    <!-- 공통 JS -->
	<script src="/resources/js/bootstrap.bundle.min.js"></script>
	<script src="/resources/js/tiny-slider.js"></script>
	<script src="/resources/js/aos.js"></script>
	<script src="/resources/js/navbar.js"></script>
	<script src="/resources/js/counter.js"></script>
	<script src="/resources/js/custom.js"></script>

    <!-- 슬라이더 초기화 스크립트 -->
    <script>
    	window.addEventListener('DOMContentLoaded', function () 
		{
        	tns({
					container: '.property-slider',
					items: 1,
					slideBy: 'page',
					autoplay: true,
					controls: false,
					nav: true,
					navPosition: 'bottom'
				});
			});
    </script>
  </body>
</html>
