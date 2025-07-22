<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>


<!-- /*
* Template Name: Property
* Template Author: Untree.co
* Template URI: https://untree.co/
* License: https://creativecommons.org/licenses/by/3.0/
*/ -->
<!DOCTYPE html>
<html lang="en">
  <head>
    <%@ include file="/WEB-INF/views/include/head.jsp" %>
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta name="author" content="Untree.co" />
    <link rel="shortcut icon" href="favicon.png" />

    <meta name="description" content="" />
    <meta name="keywords" content="bootstrap, bootstrap5" />

    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link
      href="https://fonts.googleapis.com/css2?family=Work+Sans:wght@400;500;600;700&display=swap"
      rel="stylesheet"
    />

    <link rel="stylesheet" href="/resources/fonts/icomoon/style.css" />
    <link rel="stylesheet" href="/resources/fonts/flaticon/font/flaticon.css" />

    <link rel="stylesheet" href="/resources/css/tiny-slider.css" />
    <link rel="stylesheet" href="/resources/css/aos.css" />
    <link rel="stylesheet" href="/resources/css/style.css" />
<link rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
  
  	<style>
  	.site-nav .container {
  max-width: none !important;   /* 부트스트랩 max-width 제거 */
  width:68% !important;        /* 화면 너비의 80% */
  margin: 0 auto !important;    /* 가운데 정렬 */
  padding: 0 !important;
}
  	
  /* pulsate effect for heart */
@keyframes pulse {
  0%   { transform: scale(1); }
  50%  { transform: scale(1.4); }
  100% { transform: scale(1); }
}

.section {
  padding-top: 2rem !important;
  padding-bottom: 2rem !important;
}

/*****************************최근등록공간****************************/

.section-space .heading,
.section-room .heading {
  margin-top: 0.5rem !important;
  margin-bottom: 0.5rem !important;
}

.wish-heart.clicked {
  animation: pulse 0.3s ease;
}

/* page base */
body {
    padding-top: 120px;
    background-color: #f9f9f9;
    font-family: 'Noto Sans KR', sans-serif;
}
.container {
  max-width: 1200px;
  margin: 0 auto;
}


/* grid */
#wishlistBody {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 24px;
}

  /* ================ 슬라이더 래퍼 */
  .property-slider-wrap {
      position: relative;
  padding: 0;
  overflow: hidden; /* 보통은 hidden 으로 */
      margin-top: 0.5rem;
  margin-bottom: 0.5rem;
  }
  
  

/* card wrapper */
.property-item {
    position: relative;
    background-color: #fff;
    border-radius: 0px;
    box-shadow: 0 4px 12px rgba(0,0,0,0.1);
    overflow: hidden;
    transition: transform 0.2s ease;
    margin-bottom: 20px;
}
.property-item:hover {
  transform: translateY(-6px);
}

  .property-item .img {
    width: 100%;
    height: 240px;
    overflow: hidden;
  }



/* thumbnail */
.property-item .img img {
    width: 100%;
    height: 100%;
    object-fit: cover;
    display: block;
}

/* content */
.property-content {
    padding: 10px;
    margin-top: 0 !important;  /* 겹침 방지 */
    display: flex;
    flex-direction: column;
    justify-content: space-between;
}

/* 가격 (위쪽) */
.property-content .price {
  font-size: 1.15rem;
    font-weight: 700;
    color: #222;
    margin-bottom: 3px;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
}

/* 제목 */
.property-content .city {
   font-size: 1.15rem;
    font-weight: 700;
    color: #222;
    margin-bottom: 1px;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
}
.property-content .city:hover {
  color: #007acc;
  text-decoration: underline;
}

/* 별점·리뷰 */
.property-content .specs {
    font-size: 0.9rem;
    color: #777;
    margin-bottom: 3px;
}
.property-content .specs .caption {
  font-size: 0.9rem;
  color: #888;
}

/* 아래 가격 + 하트 */
.property-content .room-price {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-top: 2px;
}
.property-content .room-price strong {
   font-size: 1.05rem;
    color: #4a90e2;
}

/* 하트 버튼 */
.wish-heart {
  font-size: 28px;
  color: #e74c3c;
  background: none;
  border: none;
  cursor: pointer;
  padding: 0;
  margin: 0;
  line-height: 1;
  transition: transform 0.2s ease;
}
.property-content .room-price .wish-heart {
  /* 위치를 바닥 오른쪽 모서리에 붙이고 싶으시면 아래처럼 절대 위치 지정 */
  position: absolute;
  bottom: 16px;
  right: 16px;
}
.wish-heart:hover {
  transform: scale(1.2);
  color: #c0392b;
}

/* 찜된 상태 */
.wish-heart .wished,
.wished {
  color: #e74c3c;
}
  


	/* 7열 그리드 : gap 조정해 주세요 */
	.category-grid {
	  display: grid;
	  grid-template-columns: repeat(7, 1fr);
	  gap: 1rem;
	  justify-items: center;
	   margin-top: 1rem;
  margin-bottom: 1rem;
	}
.category-grid .category-btn,
.category-grid .category2-btn {
  border: none;
  background: transparent;
  padding: 0;
  margin: 0;
  cursor: pointer;
  outline: none;
}

.category-grid .category-btn img,
.category-grid .category2-btn img {
  width: 70px;
  height: 70px;
  object-fit: contain;
  border-radius: 50%;
  background-color: #f2f2f2;   /* 원 안에 연한 배경색 */
  padding: 10px;               /* 원 안 여백 */
  transition: transform .2s;
}

.category-grid .category-btn:hover img,
.category-grid .category2-btn:hover img {
  transform: scale(1.1);
}

/* 5) 버튼 아래 카테고리 이름 간격·폰트 조정 */
.category-grid .category-btn .small,
.category-grid .category2-btn .small {
  margin-top: 6px;
  font-size: .85rem;
  color: #333;
}
	
.property-slider-wrap .property-item {
  display: flex;
  flex-direction: column;
  min-height: 300px          /* 부모 컨테이너(슬라이더)가 허용하는 최대 높이로 늘리기 */
}

.property-slider-wrap .property-item .img {
    flex: none !important;
  width: 100% !important;
  height: 240px !important;
}

.property-slider-wrap .property-item .property-content {
  flex: 1;               /* 남은 공간 전부 채우기 */
  display: flex;
  flex-direction: column;
  justify-content: space-between; /* 제목·별점 영역과 하단 가격·하트 버튼을 위아래로 분리 */
}

.property-content .room-addr {
  line-height: 1.2em;               /* 한 줄의 높이 */
  min-height: calc(1.2em * 2);      /* 2줄 분량 만큼 항상 확보 */
  
  /* mb-2 클래스가 이미 margin-bottom: .5rem 을 주고 있으니 추가 여백 필요 없을 겁니다 */
}

.property-slider {
  /* tiny-slider 가 쓰는 tns-item 들을 flex 컨테이너로 감쌌을 때 */
  display: flex !important;
}

.property-item .img {
  display: block;
  width: 100%;
}

/* img-fluid 가 물려준 display/height:auto 등을 덮어씌우고, object-fit으로 꽉 채우기 */
.property-item .img img {
 display: block;
  width: 100%;
  height: 100%;
  object-fit: cover;
  object-position: center; /* 가운데 중심으로 자를 때 유용합니다 */
}

.property-slider-wrap {
  position: relative;
}

.property-slider-wrap .controls .prev,
.property-slider-wrap .controls .next {
  /* width/height/border 설정 삭제 → 문자 ◀ ▶ 가 자연스럽게 보이도록 */
  width: auto !important;
  height: auto !important;
  border: none !important;
  background: none !important;

  /* 텍스트 화살표 크기 / 컬러 조절 */
  font-size: 1.5rem;
  color: #00204a;
  line-height: 1;
  cursor: pointer;
  user-select: none;
}

/* 컨테이너 flex 정렬 유지 */
.property-slider-wrap .controls {
  display: flex;    
  justify-content: space-between;
  margin-top: -8px;
  padding: 0 10px;
  pointer-events: none;
}
.property-slider-wrap .controls span {
  pointer-events: auto;
}


/*****************************후기****************************/

.sec-testimonials {
  padding-top: 2rem;
  padding-bottom: 2rem;
}
.testimonial {
  /* 아이템 너비 안에서만 줄바꿈하도록 보장 */
  overflow-wrap: break-word;   /* IE11+, Chrome, FF */
  word-wrap: break-word;       /* 구 IE 지원 */
  word-break: break-word;      /* 아주 긴 단어라도 줄바꿈 */
  white-space: normal !important; /* 강제 줄바꿈을 허용 */
}

.testimonial .fw-bold,
.testimonial .text-muted {
  overflow-wrap: break-word;
  word-wrap: break-word;
  word-break: break-word;
  white-space: normal !important;
}

.testimonial-slider .item .testimonial img.img-fluid {
  width: 100%;        /* 부모 컨테이너 폭에 딱 맞게 */
  height: 200px;      /* 원하는 높이로 통일 */
  object-fit: cover;  /* 비율 똑같이 자르기 */
}

.section.py-5,
.section-space.py-5 {
  padding-top: 1rem !important;
  padding-bottom: 1rem !important;
}

.section-space .row.mb-5,
.section-room .row.mb-5 {
  margin-top: 0.5rem !important;
  margin-bottom: 0.5rem !important;
}

/****************************대문*******************************/
.hero-overlay {
  max-width: 1180px;
  width: 100%;
  height: 400px;       /* 컨테이너 높이 */
  margin: 0 auto;
  overflow: hidden;    /* 잘린 영역 숨기기 */
  position: relative;
  
   border-radius: 8px;   /* 모서리 반경: 6px (원하는 만큼 조절) */
  overflow: hidden;     /* 둥근 모서리 밖으로 튀어나온 부분 숨김 */
  margin-bottom: 1rem;
}

/* 슬라이드 이미지는 배경처럼 꽉 채우기 */
.hero-overlay .hero-slider .slide img {
 width: 100%;
  height: 100%;
  object-fit: contain; /* 변경: 이미지 전체가 보이도록 비율 유지 */
  object-position: center; /* 변경: 이미지를 가운데로 정렬 */
  filter: blur(3px) brightness(70%);
  
}

/* 글자 타이틀용 */
.hero-overlay .hero-title {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  z-index: 2;
  font-size: 3rem;
  color: white;
  letter-spacing: 1rem;
  white-space: nowrap;
  text-shadow: 0 0 8px rgba(0,0,0,0.6);
  font-family: monospace;
}

#typewriter {
  font-family: monospace;
  font-size: 3rem;
  letter-spacing: 1rem;
  color: #fff;
  text-shadow: 0 0 8px rgba(0,0,0,0.6);
  white-space: nowrap;
  position: relative;
}

/* 언더바는 ::after로 추가하고, 투명도만 토글 */
#typewriter::after {
  content: '_';
  position: absolute;
  /* SPACEBAR 텍스트 끝 바로 다음에 붙도록 */
  left: calc(100% + 0.2rem);
  /* 세로 정렬을 텍스트 중앙에 */
  top: 0;
  animation: blink 1s step-end infinite;
}

@keyframes blink {
  50% { opacity: 0; }
}


	</style>



    <title>
      Property &mdash; Free Bootstrap 5 Website Template by Untree.co
    </title>
  </head>
  <body>
  <%@ include file="/WEB-INF/views/include/navigation.jsp" %>
  
    <div class="site-mobile-menu site-navbar-target">
      <div class="site-mobile-menu-header">
        <div class="site-mobile-menu-close">
          <span class="icofont-close js-menu-toggle"></span>
        </div>
      </div>
      <div class="site-mobile-menu-body"></div>
    </div>
    
    <div class="hero-overlay">
  <div class="hero-slider">
    <c:forEach var="idx" begin="1" end="5">
      <div class="slide">
        <img 
          src="${pageContext.request.contextPath}/resources/upload/index/${idx}.jpg"
          alt="Placeholder ${idx}"
          onerror="this.src='${pageContext.request.contextPath}/resources/upload/index/default-room.jpg'" />
      </div>
    </c:forEach>
  </div>
  <div class="hero-title"><span id="typewriter"></span></div>
</div>

	<div class="section py-5">
  <div class="container">
    
      <div class="category-grid">
      <c:forEach var="cat2" items="${spaceCategoryList}">
        <button type="button"
              class="category2-btn"
              data-name="${cat2.roomCatName}">
        <img src="${pageContext.request.contextPath}/resources/upload/category/${cat2.roomCatSeq}.${cat2.roomCatIconExt}"/>
        <div class="small text-dark">${cat2.roomCatName}</div>
      </button>
      </c:forEach>
    </div>
    
    
    <div class="category-grid">
      <c:forEach var="cat" items="${roomCategoryList}">
        <button type="button"
              class="category-btn"
              data-name="${cat.roomCatName}">
        <img src="${pageContext.request.contextPath}/resources/upload/category/${cat.roomCatSeq}.${cat.roomCatIconExt}"/>
        <div class="small text-dark">${cat.roomCatName}</div>
      </button>
      </c:forEach>
    </div>
    

    
  
    
  </div>
</div>




<div class="section section-space">
  <div class="container">
    <div class="row mb-5 align-items-center">
      <div class="col-lg-6">
        <h2 class="font-weight-bold text-primary heading">
          신규등록공간
        </h2>
      </div>
      <div class="col-lg-6 text-lg-end">
        <p>
          <a href="${pageContext.request.contextPath}/room/spaceList"
             class="btn btn-primary text-white py-3 px-4">
            모든공간보기
          </a>
        </p>
      </div>
    </div>
    <div class="row">
      <div class="col-12">
        <div class="property-slider-wrap">
          <div class="property-slider space-slider">
            <c:forEach var="newSpaceList" items="${spaceList}">
              <div class="property-item">
                <!-- 1) 클릭 가능한 썸네일 -->
                <a href="${pageContext.request.contextPath}/room/roomDetail?roomSeq=${newSpaceList.roomSeq}"
                   class="img">
                  <img
                    src="${pageContext.request.contextPath}/resources/upload/room/main/${newSpaceList.roomImgName}"
                    onerror="this.src='${pageContext.request.contextPath}/resources/upload/room/main/default-room.png'"
                    alt="${newSpaceList.roomTitle}"
                    class="img-fluid"
                  />
                </a>

                <!-- 2) 카드 하단 정보 -->
                <div class="property-content">
                  <div>
                    <span class="d-block mb-2 text-black-50 room-addr">
                      ${newSpaceList.roomAddr}
                    </span>
                    <a href="${pageContext.request.contextPath}/room/roomDetail?roomSeq=${newSpaceList.roomSeq}"
					   class="city d-block mb-3 text-decoration-none text-black">
					  ${newSpaceList.roomTitle}
					</a>
                    <div class="specs d-flex mb-4">
                      <span class="d-block d-flex align-items-center me-3">
                        <span class="caption">⭐ ${newSpaceList.averageRating}</span>&nbsp;
                        <span class="caption">(${newSpaceList.reviewCount}명)</span>
                      </span>
                    </div>
                    <div class="room-price">
                      <strong>
                        <fmt:formatNumber value="${newSpaceList.weekdayAmt}" pattern="#,###" />원~
                      </strong>
                      <c:set var="isWished" value="false" />
                      <c:forEach var="seq" items="${wishSeqs}">
                        <c:if test="${seq eq newSpaceList.roomSeq}">
                          <c:set var="isWished" value="true" />
                        </c:if>
                      </c:forEach>
                      <!-- 3) 하트 토글 버튼 -->
                      <button class="wish-heart"
                              data-wished="${isWished}"
                              onclick="toggleWish(${newSpaceList.roomSeq}, this)">
                        <i class="${isWished ? 'fas fa-heart wished' : 'far fa-heart'}"></i>
                      </button>
                    </div>
                  </div>
                </div>
              </div>
            </c:forEach>
          </div>
          <div id="space-nav"
               class="controls"
               tabindex="0"
               aria-label="Carousel Navigation">
            <span class="prev" data-controls="prev" aria-controls="property">◀</span>
            <span class="next" data-controls="next" aria-controls="property">▶</span>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>


<div class="section section-room">
  <div class="container">
    <div class="row mb-5 align-items-center">
      <div class="col-lg-6">
        <h2 class="font-weight-bold text-primary heading">
          신규등록숙소
        </h2>
      </div>
      <div class="col-lg-6 text-lg-end">
        <p>
          <a href="${pageContext.request.contextPath}/room/roomList"
             class="btn btn-primary text-white py-3 px-4">
            모든숙소보기
          </a>
        </p>
      </div>
    </div>
    <div class="row">
      <div class="col-12">
        <div class="property-slider-wrap">
          <div class="property-slider room-slider">
            <c:forEach var="newList" items="${roomList}">
              <div class="property-item">
                <!-- 1) 클릭 가능한 썸네일 -->
                <a href="${pageContext.request.contextPath}/room/roomDetail?roomSeq=${newList.roomSeq}"
                   class="img">
                  <img
                    src="${pageContext.request.contextPath}/resources/upload/room/main/${newList.roomImgName}"
                    onerror="this.src='${pageContext.request.contextPath}/resources/upload/room/main/default-room.png'"
                    alt="${newList.roomTitle}"
                    class="img-fluid"
                  />
                </a>

                <!-- 2) 카드 하단 정보 -->
                <div class="property-content">
                  <div>
                    <span class="d-block mb-2 text-black-50 room-addr">
                      ${newList.roomAddr}
                    </span>
                    <a href="${pageContext.request.contextPath}/room/roomDetail?roomSeq=${newList.roomSeq}"
						   class="city d-block mb-3 text-decoration-none text-black">
						  ${newList.roomTitle}
						</a>
                    <div class="specs d-flex mb-4">
                      <span class="d-block d-flex align-items-center me-3">
                        <span class="caption">⭐ ${newList.averageRating}</span>&nbsp;
                        <span class="caption">(${newList.reviewCount}명)</span>
                      </span>
                    </div>
                    <div class="room-price">
                      <strong>
                        <fmt:formatNumber value="${newList.weekdayAmt}" pattern="#,###" />원~
                      </strong>
                      <c:set var="isWished" value="false" />
                      <c:forEach var="seq" items="${wishSeqs}">
                        <c:if test="${seq eq newList.roomSeq}">
                          <c:set var="isWished" value="true" />
                        </c:if>
                      </c:forEach>
                      <!-- 3) 하트 토글 버튼 -->
                      <button class="wish-heart"
                              data-wished="${isWished}"
                              onclick="toggleWish(${newList.roomSeq}, this)">
                        <i class="${isWished ? 'fas fa-heart wished' : 'far fa-heart'}"></i>
                      </button>
                    </div>
                  </div>
                </div>
              </div>
            </c:forEach>
          </div>
          <div id="room-nav"
               class="controls"
               tabindex="0"
               aria-label="Carousel Navigation">
            <span class="prev" data-controls="prev" aria-controls="property">◀</span>
            <span class="next" data-controls="next" aria-controls="property">▶</span>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>


    <section class="features-1">
      <div class="container">
        <div class="row">
          <div class="col-6 col-lg-3" data-aos="fade-up" data-aos-delay="300">
            <div class="box-feature">
              <span class="flaticon-house"></span>
              <h3 class="mb-3">자유게시판</h3>
              <p>
                Lorem ipsum dolor sit amet, consectetur adipisicing elit.
                Voluptates, accusamus.
              </p>
              <p><a href="#" class="learn-more">Learn More</a></p>
            </div>
          </div>
          <div class="col-6 col-lg-3" data-aos="fade-up" data-aos-delay="500">
            <div class="box-feature">
              <span class="flaticon-building"></span>
              <h3 class="mb-3">QnA게시판</h3>
              <p>
                Lorem ipsum dolor sit amet, consectetur adipisicing elit.
                Voluptates, accusamus.
              </p>
              <p><a href="#" class="learn-more">Learn More</a></p>
            </div>
          </div>
          <div class="col-6 col-lg-3" data-aos="fade-up" data-aos-delay="400">
            <div class="box-feature">
              <span class="flaticon-house-3"></span>
              <h3 class="mb-3">공지사항</h3>
              <p>
                Lorem ipsum dolor sit amet, consectetur adipisicing elit.
                Voluptates, accusamus.
              </p>
              <p><a href="#" class="learn-more">Learn More</a></p>
            </div>
          </div>
          <div class="col-6 col-lg-3" data-aos="fade-up" data-aos-delay="600">
            <div class="box-feature">
              <span class="flaticon-house-1"></span>
              <h3 class="mb-3">House for Sale</h3>
              <p>
                Lorem ipsum dolor sit amet, consectetur adipisicing elit.
                Voluptates, accusamus.
              </p>
              <p><a href="#" class="learn-more">Learn More</a></p>
            </div>
          </div>
        </div>
      </div>
    </section>

<div class="section sec-testimonials">
  <div class="container">
    <div class="row mb-5 align-items-center">
      <div class="col-md-6">
        <h2 class="heading text-primary">최근등록후기</h2>
      </div>
      <div class="col-md-6 text-md-end">
        <div id="testimonial-nav" class="d-inline-flex gap-3">
          <button type="button" class="prev btn btn-sm btn-outline-secondary">◀</button>
          <button type="button" class="next btn btn-sm btn-outline-secondary">▶</button>
        </div>
      </div>
    </div>
    <div class="testimonial-slider-wrap position-relative">
      <div class="testimonial-slider">
        <c:forEach var="rev" items="${reviewList}">
          <div class="item">
            <div class="testimonial text-center p-4">
              <div class="mb-3">
              
                <img
                  src="${pageContext.request.contextPath}/resources/upload/userprofile/${rev.userId}.${rev.profImgExt}"
                  onerror="this.src='${pageContext.request.contextPath}/resources/upload/userprofile/회원.png'"
                  class="rounded-circle"
                  width="50" height="50"
                />
                <strong class="d-block mt-2">${rev.userNickname}</strong>
              </div>
              <div class="mb-3">
                 <a href="${pageContext.request.contextPath}/room/roomDetail?roomSeq=${rev.roomSeq}">
		          <img
		            src="${pageContext.request.contextPath}/resources/upload/review/${rev.reviewImgName}"
		            onerror="this.src='${pageContext.request.contextPath}/resources/upload/room/main/default-room.png'"
		            class="img-fluid rounded"
		          />
		        </a>
              </div>
              <blockquote class="mb-2">&ldquo;${rev.reviewContent}&rdquo;</blockquote>
              <div class="fw-bold mb-1">${rev.roomTitle} (${rev.roomTypeTitle})</div>
              <div class="text-muted small">${rev.roomAddr}</div>
            </div>
          </div>
        </c:forEach>
      </div>
      <!-- 네비게이션 도트가 들어갈 컨테이너 -->
      <div class="testimonial-dots text-center mt-4"></div>
    </div>
  </div>
</div>

    <!-- Preloader -->
    <div id="overlayer"></div>
    <div class="loader">
      <div class="spinner-border" role="status">
        <span class="visually-hidden">Loading...</span>
      </div>
    </div>
    
    <form id="searchForm" method="post">
	  <input type="hidden" name="curPage" value="${curPage}" />
	  <input type="hidden" name="category" id="category" value="${category}" />
	</form>

    <script src="/resources/js/bootstrap.bundle.min.js"></script>
    <script src="/resources/js/tiny-slider.js"></script>
    <script src="/resources/js/aos.js"></script>
    <script src="/resources/js/navbar.js"></script>
    <script src="/resources/js/counter.js"></script>
    <script src="/resources/js/custom.js"></script>
    <script>
    function toggleWish(roomSeq, btn) {
  	  const $btn    = $(btn);
  	  const $icon   = $btn.find('i.fa-heart');
  	  const wished  = $btn.data('wished');              // true면 지금은 찜된 상태
  	  const url     = wished ? "/wishlist/remove" : "/wishlist/add";
  	  
  	  $.post(url, { roomSeq: roomSeq })
  	    .done(function(res) {
  	      if (res.code === 0) {
  	        if (wished) {
  	          // → 삭제(하얀 하트) & 알림
  	          $icon
  	            .removeClass("fas wished")
  	            .addClass("far");
  	          $btn.data('wished', false);
  	          Swal.fire({
  	            icon: "success",
  	            title: "삭제됐습니다",
  	            text: "찜 목록에서 제거되었습니다.",
  	            timer: 1500,
  	            showConfirmButton: false
  	          });
  	        } else {
  	          // → 추가(빨간 하트) & 알림
  	          $icon
  	            .removeClass("far")
  	            .addClass("fas wished");
  	          $btn.data('wished', true);
  	          Swal.fire({
  	            icon: "success",
  	            title: "추가되었습니다",
  	            text: "찜 목록에 추가되었습니다.",
  	            timer: 1500,
  	            showConfirmButton: false
  	          });
  	        }
  	      }
  	    else if(res.code === 500) {
  	        Swal.fire("로그인 후 이용하세요", res.message, "warning");
  	      }
  	      
  	      else {
  	        Swal.fire("오류", res.message, "error");
  	      }
  	    })
  	    .fail(function() {
  	      Swal.fire("네트워크 오류", "잠시 후 다시 시도해주세요.", "error");
  	    });
  	}

    $(".category-btn, .category2-btn").on("click", function(){
        const name   = $(this).data("name");
        // 버튼에 따라 action 바꾸기
        const target = $(this).hasClass("category2-btn")
                        ? "${pageContext.request.contextPath}/room/spaceList"
                        : "${pageContext.request.contextPath}/room/roomList";

        $("#searchForm")
          .attr("action", target)
          .find("#category").val(name);

        $("#searchForm").find("input[name=curPage]").val(1);
        $("#searchForm")[0].submit();
      });

   
    
    document.addEventListener('DOMContentLoaded', () => {
    	  const text   = 'SPACEBAR';
    	  const el     = document.getElementById('typewriter');
    	  const cursor = document.getElementById('cursor');
    	  const INTERVAL = 7000;  // 5초
    	  const TYPE_DELAY = 200; // 타이핑 속도

    	  function runTypewriter() {
    	    el.textContent = '';
    	    // 1글자씩 찍기
    	    for (let i = 0; i < text.length; i++) {
    	      setTimeout(() => {
    	        el.textContent += text[i];
    	      }, TYPE_DELAY * i);
    	    }
    	    // 커서는 CSS 애니메이션에서 알아서 깜빡이므로 따로 처리 안 해도 됩니다
    	  }

    	  // 최초 실행
    	  runTypewriter();
    	  // 5초마다 다시 실행
    	  setInterval(runTypewriter, INTERVAL);
    	});
    </script>
    

    
    <%@ include file="/WEB-INF/views/include/footer.jsp" %>
  </body>
</html>
