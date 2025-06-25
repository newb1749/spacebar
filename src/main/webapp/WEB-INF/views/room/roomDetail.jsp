<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
  <title>${room.roomTitle}-상세야 좀 되라 열받게 하지 말고</title>

  <!-- CSS -->
  <link rel="shortcut icon" href="${pageContext.request.contextPath}/resources/images/favicon.ico" type="image/x-icon" />
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/tiny-slider.css" />
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/aos.css" />
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css" />
</head>
<body>

  <%@ include file="/WEB-INF/views/include/navigation.jsp" %>

  <!-- 모바일 메뉴 바디 -->
  <div class="site-mobile-menu">
    <div class="site-mobile-menu-body"></div>
  </div>

  <!-- 로딩 애니메이션 -->
  <div class="loader"></div>
  <div id="overlayer"></div>

  <!-- 메인 이미지 경로 설정 -->

  <!-- Hero 영역 -->
<c:choose>
	<c:when test="${mainImages.imgType eq 'main'}">
		<div class="hero page-inner overlay" style="background-image: url('/resources/upload/room/main/${mainImages.roomImgName}')">
	</c:when>
	<c:otherwise>
		<div class="hero page-inner overlay" style="background-image: url('/resources/images/file.png')">
	</c:otherwise>
</c:choose>  

    <div class="container text-center mt-5">
      <h1 class="heading" data-aos="fade-up">${room.roomTitle}</h1>
    </div>
  </div>

  <!-- 상세 영역 -->
  <div class="section">
    <div class="container">
      <div class="row justify-content-between align-items-start">

        <!-- 이미지 슬라이더 -->
        <div class="col-lg-7">
          <div class="property-slider-wrap">
              <div class="property-slider tiny-slider">
                    <div class="item">
			          	<c:if test="${!empty detailImages}">
						<c:forEach var="roomImg" items="${detailImages}" varStatus="status">
							<img src="/resources/upload/room/detail/${roomImg.roomImgName}"
							class="img-fluid" id="tns1_item${status.index}" alt="${roomImg.imgType}" />
						</c:forEach>
						</c:if>
                    </div>
              </div>
          </div>
        </div>
        <!-- 상세 이미지용 시작 -->
        <!--
        <div class="col-lg-7">
          <div class="property-slider-wrap">
            <c:if test="${not empty detailImages}">
              <div class="property-slider tiny-slider">
                <c:set var="prefix" value="${room.roomSeq}_"/>
                <c:forEach var="img" items="${detailImages}">
                  <c:if test="${fn:startsWith(img.roomImgName, prefix)}">
                    <div class="item">
                      <img src="/resources/upload/room/main/${mainImages.roomImgName}" 
                           class="img-fluid" alt="${img.imgType}" />
                    </div>
                  </c:if>
                </c:forEach>
              </div>
            </c:if>
          </div>
        </div>
        -->
         <!-- 상세 이미지용 시작 -->

        <!-- 텍스트 정보 -->
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
            
            <!-- Map -->
            <%-- <c:if test="${not empty room.roomAddr}">
			  <jsp:include page="/WEB-INF/views/component/mapModule.jsp">
			    <jsp:param name="address" value="${room.roomAddr}" />
			    <jsp:param name="roomName" value="${room.roomTitle}" />
			  </jsp:include>
			</c:if>
			<c:if test="${empty room.roomAddr}">
			  <p>지도 주소 정보가 없습니다.</p>
			</c:if>
 --%>
		 
		<jsp:include page="/WEB-INF/views/component/mapModule.jsp">
		  <jsp:param name="address" value="${room.roomAddr}"/>
		  <jsp:param name="roomName" value="${room.roomTitle}"/>
		</jsp:include>

		<script>
		  console.log("📍 room.roomAddr:", "${room.roomAddr}");
		</script>
          </div>
        </div>

      </div>
    </div>
  </div>

  <%@ include file="/WEB-INF/views/include/footer.jsp" %>

  <!-- JS -->
  <script src="${pageContext.request.contextPath}/resources/js/bootstrap.bundle.min.js"></script>
  <script src="${pageContext.request.contextPath}/resources/js/tiny-slider.js"></script>
  <script src="${pageContext.request.contextPath}/resources/js/aos.js"></script>
  <script src="${pageContext.request.contextPath}/resources/js/navbar.js"></script>
  <script src="${pageContext.request.contextPath}/resources/js/counter.js"></script>
  <script src="${pageContext.request.contextPath}/resources/js/custom.js"></script>

  <script>
    document.addEventListener('DOMContentLoaded', function () 
    {
      const slider = document.querySelector('.property-slider');
      if (slider && slider.querySelectorAll('.item').length > 0) 
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
      }

      const loader = document.querySelector('.loader');
      if(loader) 
      {
        loader.style.opacity = 0;
        setTimeout(() => 
        {
          loader.style.display = 'none';
        }, 300);
      }
    });
  </script>

</body>
</html>
