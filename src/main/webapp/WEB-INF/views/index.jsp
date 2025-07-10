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
  	
  	
  /* pulsate effect for heart */
@keyframes pulse {
  0%   { transform: scale(1); }
  50%  { transform: scale(1.4); }
  100% { transform: scale(1); }
}

/*****************************최근등록공간****************************/
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
	}
.category-grid .category-btn img {
  width: 60px;
  height: 60px;
  object-fit: cover; /* 필요에 따라 비율 유지용 */
}

.category-grid .category2-btn img {
  width: 60px;
  height: 60px;
  object-fit: cover; /* 필요에 따라 비율 유지용 */
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

	<div class="section py-5">
  <div class="container">
    <h2 class="text-center mb-4">s p a c e b a r</h2>
    
      <div class="category-grid">
      <c:forEach var="cat2" items="${spaceCategoryList}">
        <button type="button"
              class="category2-btn"
              data-name="${cat2.roomCatName}">
        <img src="${pageContext.request.contextPath}/resources/images/category/${cat2.roomCatSeq}.${cat2.roomCatIconExt}"/>
        <div class="small text-dark">${cat2.roomCatName}</div>
      </button>
      </c:forEach>
    </div>
    
        </br>
    
    <div class="category-grid">
      <c:forEach var="cat" items="${roomCategoryList}">
        <button type="button"
              class="category-btn"
              data-name="${cat.roomCatName}">
        <img src="${pageContext.request.contextPath}/resources/images/category/${cat.roomCatSeq}.${cat.roomCatIconExt}"/>
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
                <a href="${pageContext.request.contextPath}/room/roomDetailSh?roomSeq=${newSpaceList.roomSeq}"
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
                    <a href="${pageContext.request.contextPath}/room/roomDetailSh?roomSeq=${newSpaceList.roomSeq}"
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
                <a href="${pageContext.request.contextPath}/room/roomDetailSh?roomSeq=${newList.roomSeq}"
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
                    <a href="${pageContext.request.contextPath}/room/roomDetailSh?roomSeq=${newList.roomSeq}"
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
              <h3 class="mb-3">Our Properties</h3>
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
              <h3 class="mb-3">Property for Sale</h3>
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
              <h3 class="mb-3">Real Estate Agent</h3>
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
                 <a href="${pageContext.request.contextPath}/room/roomDetailSh?roomSeq=${rev.roomSeq}">
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


    <div class="section section-4 bg-light">
      <div class="container">
        <div class="row justify-content-center text-center mb-5">
          <div class="col-lg-5">
            <h2 class="font-weight-bold heading text-primary mb-4">
              Let's find home that's perfect for you
            </h2>
            <p class="text-black-50">
              Lorem ipsum dolor sit amet consectetur adipisicing elit. Numquam
              enim pariatur similique debitis vel nisi qui reprehenderit.
            </p>
          </div>
        </div>
        <div class="row justify-content-between mb-5">
          <div class="col-lg-7 mb-5 mb-lg-0 order-lg-2">
            <div class="img-about dots">
              <img src="/resources/images/hero_bg_3.jpg" alt="Image" class="img-fluid" />
            </div>
          </div>
          <div class="col-lg-4">
            <div class="d-flex feature-h">
              <span class="wrap-icon me-3">
                <span class="icon-home2"></span>
              </span>
              <div class="feature-text">
                <h3 class="heading">2M Properties</h3>
                <p class="text-black-50">
                  Lorem ipsum dolor sit amet consectetur adipisicing elit.
                  Nostrum iste.
                </p>
              </div>
            </div>

            <div class="d-flex feature-h">
              <span class="wrap-icon me-3">
                <span class="icon-person"></span>
              </span>
              <div class="feature-text">
                <h3 class="heading">Top Rated Agents</h3>
                <p class="text-black-50">
                  Lorem ipsum dolor sit amet consectetur adipisicing elit.
                  Nostrum iste.
                </p>
              </div>
            </div>

            <div class="d-flex feature-h">
              <span class="wrap-icon me-3">
                <span class="icon-security"></span>
              </span>
              <div class="feature-text">
                <h3 class="heading">Legit Properties</h3>
                <p class="text-black-50">
                  Lorem ipsum dolor sit amet consectetur adipisicing elit.
                  Nostrum iste.
                </p>
              </div>
            </div>
          </div>
        </div>
        <div class="row section-counter mt-5">
          <div
            class="col-6 col-sm-6 col-md-6 col-lg-3"
            data-aos="fade-up"
            data-aos-delay="300"
          >
            <div class="counter-wrap mb-5 mb-lg-0">
              <span class="number"
                ><span class="countup text-primary">3298</span></span
              >
              <span class="caption text-black-50"># of Buy Properties</span>
            </div>
          </div>
          <div
            class="col-6 col-sm-6 col-md-6 col-lg-3"
            data-aos="fade-up"
            data-aos-delay="400"
          >
            <div class="counter-wrap mb-5 mb-lg-0">
              <span class="number"
                ><span class="countup text-primary">2181</span></span
              >
              <span class="caption text-black-50"># of Sell Properties</span>
            </div>
          </div>
          <div
            class="col-6 col-sm-6 col-md-6 col-lg-3"
            data-aos="fade-up"
            data-aos-delay="500"
          >
            <div class="counter-wrap mb-5 mb-lg-0">
              <span class="number"
                ><span class="countup text-primary">9316</span></span
              >
              <span class="caption text-black-50"># of All Properties</span>
            </div>
          </div>
          <div
            class="col-6 col-sm-6 col-md-6 col-lg-3"
            data-aos="fade-up"
            data-aos-delay="600"
          >
            <div class="counter-wrap mb-5 mb-lg-0">
              <span class="number"
                ><span class="countup text-primary">7191</span></span
              >
              <span class="caption text-black-50"># of Agents</span>
            </div>
          </div>
        </div>
      </div>
    </div>

    <div class="section">
      <div class="row justify-content-center footer-cta" data-aos="fade-up">
        <div class="col-lg-7 mx-auto text-center">
          <h2 class="mb-4">Be a part of our growing real state agents</h2>
          <p>
            <a
              href="#"
              target="_blank"
              class="btn btn-primary text-white py-3 px-4"
              >Apply for Real Estate agent</a
            >
          </p>
        </div>
        <!-- /.col-lg-7 -->
      </div>
      <!-- /.row -->
    </div>

    <div class="section section-5 bg-light">
      <div class="container">
        <div class="row justify-content-center text-center mb-5">
          <div class="col-lg-6 mb-5">
            <h2 class="font-weight-bold heading text-primary mb-4">
              Our Agents
            </h2>
            <p class="text-black-50">
              Lorem ipsum dolor sit amet consectetur adipisicing elit. Numquam
              enim pariatur similique debitis vel nisi qui reprehenderit totam?
              Quod maiores.
            </p>
          </div>
        </div>
        <div class="row">
          <div class="col-sm-6 col-md-6 col-lg-4 mb-5 mb-lg-0">
            <div class="h-100 person">
              <img
                src="/resources/images/person_1-min.jpg"
                alt="Image"
                class="img-fluid"
              />

              <div class="person-contents">
                <h2 class="mb-0"><a href="#">James Doe</a></h2>
                <span class="meta d-block mb-3">Real Estate Agent</span>
                <p>
                  Lorem ipsum dolor sit amet consectetur adipisicing elit.
                  Facere officiis inventore cumque tenetur laboriosam, minus
                  culpa doloremque odio, neque molestias?
                </p>

                <ul class="social list-unstyled list-inline dark-hover">
                  <li class="list-inline-item">
                    <a href="#"><span class="icon-twitter"></span></a>
                  </li>
                  <li class="list-inline-item">
                    <a href="#"><span class="icon-facebook"></span></a>
                  </li>
                  <li class="list-inline-item">
                    <a href="#"><span class="icon-linkedin"></span></a>
                  </li>
                  <li class="list-inline-item">
                    <a href="#"><span class="icon-instagram"></span></a>
                  </li>
                </ul>
              </div>
            </div>
          </div>
          <div class="col-sm-6 col-md-6 col-lg-4 mb-5 mb-lg-0">
            <div class="h-100 person">
              <img
                src="/resources/images/person_2-min.jpg"
                alt="Image"
                class="img-fluid"
              />

              <div class="person-contents">
                <h2 class="mb-0"><a href="#">Jean Smith</a></h2>
                <span class="meta d-block mb-3">Real Estate Agent</span>
                <p>
                  Lorem ipsum dolor sit amet consectetur adipisicing elit.
                  Facere officiis inventore cumque tenetur laboriosam, minus
                  culpa doloremque odio, neque molestias?
                </p>

                <ul class="social list-unstyled list-inline dark-hover">
                  <li class="list-inline-item">
                    <a href="#"><span class="icon-twitter"></span></a>
                  </li>
                  <li class="list-inline-item">
                    <a href="#"><span class="icon-facebook"></span></a>
                  </li>
                  <li class="list-inline-item">
                    <a href="#"><span class="icon-linkedin"></span></a>
                  </li>
                  <li class="list-inline-item">
                    <a href="#"><span class="icon-instagram"></span></a>
                  </li>
                </ul>
              </div>
            </div>
          </div>
          <div class="col-sm-6 col-md-6 col-lg-4 mb-5 mb-lg-0">
            <div class="h-100 person">
              <img
                src="/resources/images/person_3-min.jpg"
                alt="Image"
                class="img-fluid"
              />

              <div class="person-contents">
                <h2 class="mb-0"><a href="#">Alicia Huston</a></h2>
                <span class="meta d-block mb-3">Real Estate Agent</span>
                <p>
                  Lorem ipsum dolor sit amet consectetur adipisicing elit.
                  Facere officiis inventore cumque tenetur laboriosam, minus
                  culpa doloremque odio, neque molestias?
                </p>

                <ul class="social list-unstyled list-inline dark-hover">
                  <li class="list-inline-item">
                    <a href="#"><span class="icon-twitter"></span></a>
                  </li>
                  <li class="list-inline-item">
                    <a href="#"><span class="icon-facebook"></span></a>
                  </li>
                  <li class="list-inline-item">
                    <a href="#"><span class="icon-linkedin"></span></a>
                  </li>
                  <li class="list-inline-item">
                    <a href="#"><span class="icon-instagram"></span></a>
                  </li>
                </ul>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <div class="site-footer">
      <div class="container">
        <div class="row">
          <div class="col-lg-4">
            <div class="widget">
              <h3>Contact</h3>
              <address>43 Raymouth Rd. Baltemoer, London 3910</address>
              <ul class="list-unstyled links">
                <li><a href="tel://11234567890">+1(123)-456-7890</a></li>
                <li><a href="tel://11234567890">+1(123)-456-7890</a></li>
                <li>
                  <a href="mailto:info@mydomain.com">info@mydomain.com</a>
                </li>
              </ul>
            </div>
            <!-- /.widget -->
          </div>
          <!-- /.col-lg-4 -->
          <div class="col-lg-4">
            <div class="widget">
              <h3>Sources</h3>
              <ul class="list-unstyled float-start links">
                <li><a href="#">About us</a></li>
                <li><a href="#">Services</a></li>
                <li><a href="#">Vision</a></li>
                <li><a href="#">Mission</a></li>
                <li><a href="#">Terms</a></li>
                <li><a href="#">Privacy</a></li>
              </ul>
              <ul class="list-unstyled float-start links">
                <li><a href="#">Partners</a></li>
                <li><a href="#">Business</a></li>
                <li><a href="#">Careers</a></li>
                <li><a href="#">Blog</a></li>
                <li><a href="#">FAQ</a></li>
                <li><a href="#">Creative</a></li>
              </ul>
            </div>
            <!-- /.widget -->
          </div>
          <!-- /.col-lg-4 -->
          <div class="col-lg-4">
            <div class="widget">
              <h3>Links</h3>
              <ul class="list-unstyled links">
                <li><a href="#">Our Vision</a></li>
                <li><a href="#">About us</a></li>
                <li><a href="#">Contact us</a></li>
              </ul>

              <ul class="list-unstyled social">
                <li>
                  <a href="#"><span class="icon-instagram"></span></a>
                </li>
                <li>
                  <a href="#"><span class="icon-twitter"></span></a>
                </li>
                <li>
                  <a href="#"><span class="icon-facebook"></span></a>
                </li>
                <li>
                  <a href="#"><span class="icon-linkedin"></span></a>
                </li>
                <li>
                  <a href="#"><span class="icon-pinterest"></span></a>
                </li>
                <li>
                  <a href="#"><span class="icon-dribbble"></span></a>
                </li>
              </ul>
            </div>
            <!-- /.widget -->
          </div>
          <!-- /.col-lg-4 -->
        </div>
        <!-- /.row -->

        <div class="row mt-5">
          <div class="col-12 text-center">
            <!-- 
              **==========
              NOTE: 
              Please don't remove this copyright link unless you buy the license here https://untree.co/license/  
              **==========
            -->

            <p>
              Copyright &copy;
              <script>
                document.write(new Date().getFullYear());
              </script>
              . All Rights Reserved. &mdash; Designed with love by
              <a href="https://untree.co">Untree.co</a>
              <!-- License information: https://untree.co/license/ -->
            </p>
            <div>
              Distributed by
              <a href="https://themewagon.com/" target="_blank">themewagon</a>
            </div>
          </div>
        </div>
      </div>
      <!-- /.container -->
    </div>
    <!-- /.site-footer -->

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
  	      } else {
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

   
    </script>
    

    
    <%@ include file="/WEB-INF/views/include/footer.jsp" %>
  </body>
</html>
