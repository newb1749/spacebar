<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/head.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>내 위치 주변 숙소</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.1.1/css/all.min.css">
    <link rel="stylesheet" href="/resources/css/location.css?v=final">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <script src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${initParam.KAKAO_MAP_KEY}&libraries=services"></script>
    <script src="/resources/js/location/nearbyRooms.js?v=final"></script>
</head>
<body>

<%-- 내비게이션 바 --%>
<%@ include file="/WEB-INF/views/include/navigation.jsp" %>

<%-- 내비게이션 바를 제외한 모든 콘텐츠를 감싸는 래퍼 --%>
<div class="page-content-wrapper">
    <div class="nearby-container">
        <div class="left-panel">
            <div class="filter-area">
                <div class="filter-group">
                    <button class="filter-btn active" data-sort="distance">거리순</button>
                    <button class="filter-btn" data-sort="rating">별점순</button>
                </div>
            </div>
            
            <div class="room-list-wrapper">
                 <div id="roomList">
                     <p>위치 정보 사용을 허용하고 주변 숙소를 찾아보세요.</p>
                 </div>
            </div>
        </div>

        <div class="right-panel">
            <div class="map-category-filter">
                <div class="category-scroll-container">
                    <button class="map-cat-btn active" data-cat-seq=""><i class="fas fa-border-all"></i> 전체</button>
                    <button class="map-cat-btn" data-cat-seq="1">파티룸</button>
                    <button class="map-cat-btn" data-cat-seq="2">카페</button>
                    <button class="map-cat-btn" data-cat-seq="3">연습실</button>
                    <button class="map-cat-btn" data-cat-seq="4">스튜디오</button>
                    <button class="map-cat-btn" data-cat-seq="5">회의실</button>
                    <button class="map-cat-btn" data-cat-seq="6">녹음실</button>
                    <button class="map-cat-btn" data-cat-seq="7">운동시설</button>
                    <button class="map-cat-btn" data-cat-seq="8">풀빌라</button>
                    <button class="map-cat-btn" data-cat-seq="9">호텔</button>
                    <button class="map-cat-btn" data-cat-seq="10">팬션</button>
                    <button class="map-cat-btn" data-cat-seq="11">민박</button>
                    <button class="map-cat-btn" data-cat-seq="12">리조트</button>
                    <button class="map-cat-btn" data-cat-seq="13">주택</button>
                    <button class="map-cat-btn" data-cat-seq="14">캠핑장</button>
                </div>
            </div>
            
            <div id="map"></div>
        </div>
    </div>
</div>

</body>
</html>