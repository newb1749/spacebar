<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/WEB-INF/views/include/head.jsp" %>
<!DOCTYPE html>
<html lang="ko">
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>${room.roomTitle} - 숙소 상세</title>

    <!-- 공통 스타일 및 리소스 -->
    <link rel="stylesheet" href="/css/style.css" />
    <link rel="stylesheet" href="/fonts/icomoon/style.css" />
    <link rel="stylesheet" href="/fonts/flaticon/font/flaticon.css" />
    <link rel="stylesheet" href="/css/tiny-slider.css" />
    <link rel="stylesheet" href="/css/aos.css" />
  </head>
  <body>
    <%@ include file="/WEB-INF/views/include/navigation.jsp" %>

    <!-- 히어로 이미지 및 타이틀 -->
    <div class="hero page-inner overlay" style="background-image: url('/images/hero_bg_3.jpg')">
      <div class="container text-center mt-5">
        <h1 class="heading" data-aos="fade-up">${room.roomTitle}</h1>
      </div>
    </div>

    <!-- 숙소 상세 정보 -->
    <div class="section">
      <div class="container">
        <div class="row justify-content-between">
        <!-- 이미지 -->
		<div class="col-lg-7">
		  <div class="img-property-slide">
		    <c:forEach var="img" items="${room.roomImageList}">
		      <c:choose>
		        <c:when test="${img.imgType == 'main'}">
		          <img src="/resource/upload/room/mainImg/${img.roomImgOrigName}" alt="${img.roomImgOrigName}" class="img-fluid mb-2" />
		        </c:when>
		        <c:when test="${img.imgType == 'detail'}">
		          <img src="/resource/upload/room/detailImg/${img.roomImgOrigName}" alt="${img.roomImgOrigName}" class="img-fluid mb-2" />
		        </c:when>
		      </c:choose>
		    </c:forEach>
		  </div>
		</div>
          
          <!-- 텍스트 정보 -->
          <div class="col-lg-4">
            <h2 class="heading text-primary">${room.roomTitle}</h2>
            <p class="meta">${room.roomAddr} (${room.region})</p>
            <p class="text-black-50">${room.roomDesc}</p>
            <ul class="list-unstyled">
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

    <%@ include file="/WEB-INF/views/include/footer.jsp" %>

    <!-- 공통 JS -->
    <script src="/js/bootstrap.bundle.min.js"></script>
    <script src="/js/tiny-slider.js"></script>
    <script src="/js/aos.js"></script>
    <script src="/js/navbar.js"></script>
    <script src="/js/counter.js"></script>
    <script src="/js/custom.js"></script>
  </body>
</html>
