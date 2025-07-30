<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>

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

  <!-- Fonts -->
  <link rel="preconnect" href="https://fonts.googleapis.com" />
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
  <link href="https://fonts.googleapis.com/css2?family=Work+Sans:wght@400;500;600;700&display=swap" rel="stylesheet" />
  <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;600;700&display=swap" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@500;600;700&display=swap" rel="stylesheet">

  <!-- CSS -->
  <link rel="stylesheet" href="/resources/fonts/icomoon/style.css" />
  <link rel="stylesheet" href="/resources/fonts/flaticon/font/flaticon.css" />
  <link rel="stylesheet" href="/resources/css/tiny-slider.css" />
  <link rel="stylesheet" href="/resources/css/aos.css" />
  <link rel="stylesheet" href="/resources/css/style.css" />
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/static/pretendard.css" />

  <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

  <style>
  :root{
    --brand-grad: linear-gradient(135deg,#FFD54F 0%, #FF8F00 50%, #FF6F00 100%);
    --hero-soft-font: 'Poppins','Plus Jakarta Sans','Pretendard','Noto Sans KR',sans-serif;
    --ff-kr-main: 'Pretendard','Noto Sans KR',sans-serif;
  }

  .site-nav .container{max-width:none !important;width:1300px;margin:0 auto !important;padding:0 !important;}
  @keyframes pulse{0%{transform:scale(1);}50%{transform:scale(1.4);}100%{transform:scale(1);}}
<<<<<<< HEAD
  .section{padding-top:3rem !important;padding-bottom:3rem !important;}
  .section-space .heading,.section-room .heading{margin-top:.5rem !important;margin-bottom:.5rem !important;font-family:'Plus Jakarta Sans',sans-serif;font-weight:700;}
  .wish-heart.clicked{animation:pulse .3s ease;}

  body{padding-top:110px;background:#f9f9f9;font-family:'Work Sans','Noto Sans KR',sans-serif;}
=======
  .section{padding-top:2rem !important;padding-bottom:2rem !important;}
  .section-space .heading,.section-room .heading{margin-top:.5rem !important;margin-bottom:.5rem !important;font-family:'Plus Jakarta Sans',sans-serif;font-weight:700;}
  .wish-heart.clicked{animation:pulse .3s ease;}

  body{padding-top:100px;background:#f9f9f9;font-family:'Work Sans','Noto Sans KR',sans-serif;}
>>>>>>> develop/kjy
  .container{max-width:1300px;margin:0 auto;}

  #wishlistBody{display:grid;grid-template-columns:repeat(auto-fill,minmax(300px,1fr));gap:24px;}

<<<<<<< HEAD
  .property-slider-wrap {
  position: relative;
  overflow: visible; /* ✅ 버튼이 바깥으로 나가게 허용 */
}
=======
  .property-slider-wrap{position:relative;padding:0;overflow:hidden;margin-top:.5rem;margin-bottom:.5rem;}
>>>>>>> develop/kjy
  .property-item{
    position:relative;background:#fff;border-radius:8px;box-shadow:0 4px 12px rgba(0,0,0,.1);
    overflow:hidden;transition:transform .2s ease;margin-bottom:20px;
  }
  .property-item:hover{transform:translateY(-6px);}
  .property-item .img{width:100%;height:240px;overflow:hidden;border-radius:8px 8px 0 0;}
  .property-item .img img{width:100%;height:100%;object-fit:cover;display:block;}

  .property-content{
    padding:10px;margin-top:0 !important;display:flex;flex-direction:column;justify-content:space-between;
  }
  .property-content .price,
  .property-content .city{
    font-size:1.15rem;font-weight:700;color:#222;margin-bottom:3px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;
    font-family:'Plus Jakarta Sans',sans-serif;
  }
  .property-content .city:hover{color:#007acc;text-decoration:underline;}
  .property-content .specs{font-size:.9rem;color:#777;margin-bottom:3px;}
  .property-content .specs .caption{font-size:.9rem;color:#888;}

  .property-content .room-price{display:flex;justify-content:space-between;align-items:center;margin-top:2px;}
  .property-content .room-price strong{font-size:1.05rem;color:#4a90e2;font-family:'Plus Jakarta Sans',sans-serif;}

  .wish-heart{
    font-size:28px;color:#e74c3c;background:none;border:none;cursor:pointer;padding:0;margin:0;line-height:1;transition:transform .2s ease;
  }
  .property-content .room-price .wish-heart{position:absolute;bottom:16px;right:16px;}
  .wish-heart:hover{transform:scale(1.2);color:#c0392b;}
  .wish-heart .wished,.wished{color:#e74c3c;}

  .category-grid{
    display:grid;grid-template-columns:repeat(7,1fr);gap:1rem;justify-items:center;margin:1rem 0;
  }
  .category-grid .category-btn,.category-grid .category2-btn{border:none;background:transparent;padding:0;margin:0;cursor:pointer;outline:none;}
  .category-grid .category-btn img,.category-grid .category2-btn img{
    width:70px;height:70px;object-fit:contain;border-radius:50%;background:#f2f2f2;padding:10px;transition:transform .2s;
  }
  .category-grid .category-btn:hover img,.category-grid .category2-btn:hover img{transform:scale(1.1);}
  .category-grid .category-btn .small,.category-grid .category2-btn .small{margin-top:6px;font-size:1rem;color:#333;font-family:'Noto Sans KR',sans-serif;}

  .property-slider-wrap .property-item{display:flex;flex-direction:column;min-height:300px}
  .property-slider-wrap .property-item .img{flex:none !important;width:100% !important;height:240px !important;}
  .property-slider-wrap .property-item .property-content{flex:1;display:flex;flex-direction:column;justify-content:space-between;}
  .property-content .room-addr{line-height:1.2em;min-height:calc(1.2em * 2);font-family:'Noto Sans KR',sans-serif;}

  .property-slider{display:flex !important;}
  .property-item .img{display:block;width:100%;}
  .property-item .img img{display:block;width:100%;height:100%;object-fit:cover;object-position:center;}

<<<<<<< HEAD
.property-slider-wrap .controls .prev,
.property-slider-wrap .controls .next {
  position: absolute;
  top: 50%;
  transform: translateY(-50%);
  font-size: 2.2rem;          /* 👉 화살표 크기만 조절 */
  color: #00204a;             /* 👉 화살표 색상 */
  background: none;           /* ✅ 배경 제거 */
  border: none;               /* ✅ 테두리 제거 */
  border-radius: 0;           /* ✅ 둥글게 제거 */
  width: auto;                /* ✅ 너비 제한 없음 */
  height: auto;
  cursor: pointer;
  pointer-events: auto;
  transition: color 0.2s ease;
}

.property-slider-wrap .controls .prev {
  left: -50px; /* ✅ 슬라이더 바깥으로 튀어나가게 */
}

.property-slider-wrap .controls .next {
  right: -50px; /* ✅ 반대쪽도 마찬가지 */
}
	
	
	.property-slider-wrap .controls {
  position: absolute;
  top: 50%;
  z-index: 10;
  transform: translateY(-50%);
  width: 100%;
  pointer-events: none; /* 자식 span만 클릭 가능하게 */
}

.property-slider-wrap .controls span {
  font-size: 2rem;
  color: #00204a;
  background: rgba(255, 255, 255, 0.85);
  border-radius: 50%;
  width: 33px;
  height: 33px;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  pointer-events: auto;
  transition: background 0.2s;
  
    outline: none;         /* ✅ 기본 포커스 테두리 제거 */
  box-shadow: none;      /* ✅ 일부 브라우저는 이걸로도 그림자 생김 */
}

.property-slider-wrap .controls span:focus {
  outline: none;
  box-shadow: none;
}

.property-slider-wrap .controls span:hover {
  background: #ddd;
}

.property-slider-wrap .controls .prev:hover,
.property-slider-wrap .controls .next:hover {
  color: #007bff;  /* 👉 hover 시 색만 변화 */
}
=======
  .property-slider-wrap .controls .prev,
  .property-slider-wrap .controls .next{
    width:auto !important;height:auto !important;border:none !important;background:none !important;
    font-size:1.5rem;color:#00204a;line-height:1;cursor:pointer;user-select:none;
  }
  .property-slider-wrap .controls{
    display:flex;justify-content:space-between;margin-top:-8px;padding:0 10px;pointer-events:none;
  }
  .property-slider-wrap .controls span{pointer-events:auto;}
>>>>>>> develop/kjy

  .sec-testimonials{padding-top:2rem;padding-bottom:2rem;}
  .testimonial{
    overflow-wrap:break-word;word-wrap:break-word;word-break:break-word;white-space:normal !important;border-radius:8px;
  }
  .testimonial .fw-bold,.testimonial .text-muted,.testimonial blockquote{
    overflow-wrap:break-word;word-wrap:break-word;word-break:break-word;white-space:normal !important;
    font-family:'Noto Sans KR',sans-serif;
  }
  .testimonial-slider .item .testimonial img.img-fluid{width:100%;height:200px;object-fit:cover;border-radius:8px;}
  .testimonial .mb-3 img.rounded-circle{border-radius:50%;}

  .section.py-5,.section-space.py-5{padding-top:1rem !important;padding-bottom:1rem !important;}
  .section-space .row.mb-5,.section-room .row.mb-5{margin-top:.5rem !important;margin-bottom:.5rem !important;}

  /* ===== HERO ===== */
  .hero-overlay{
    max-width:1300px;width:100%;height:400px;margin:0 auto 1rem;
    overflow:hidden;position:relative;border-radius:8px;background-color:#f8f8f8;
  }
  .hero-overlay .hero-slider .slide img{
    width:100%;height:100%;object-fit:cover;object-position:center;filter:brightness(70%);
  }

  .hero-title{
    position:absolute;top:50%;left:50%;transform:translate(-50%,-50%);
    z-index:5;text-align:center;white-space:nowrap;
  }
  /* 윗문장: 그라데이션(노/주), 작게 */
.hero-sub{
  font-family:var(--hero-soft-font);
  font-size:clamp(1rem,2.2vw,1.4rem);
  font-weight:700;
  line-height:1.2;
  background:#FFF176;
  -webkit-background-clip:text;
  -webkit-text-fill-color:transparent;
  color:transparent;
  margin-bottom:.4rem;
  text-shadow:0 1px 4px rgba(0,0,0,.45);
}
  /* 아래 메인: 흰색, 크게 */
  .hero-main{
    font-family:var(--hero-soft-font);
    font-weight:700;
    font-size:clamp(4rem,9vw,6.5rem);
    letter-spacing:.7rem;
    line-height:1;
    color:#fff;
    -webkit-text-fill-color:#fff;
    background:none;
    position:relative;
    text-rendering:optimizeLegibility;
    -webkit-font-smoothing:antialiased;
  }
  .hero-main .static{margin-right:.2rem;}
  #typewriter{display:inline-block;}
  .cursor{
    display:inline-block;
    margin-left:.2rem;
    animation:blink 1s step-end infinite;
    color:#fff;
  }
  @keyframes blink{50%{opacity:0;}}

  .features-1 .box-feature{border-radius:8px;font-family:'Noto Sans KR',sans-serif;}
  .features-1 .box-feature h3{font-family:'Plus Jakarta Sans',sans-serif;font-weight:600;}

  body{font-family:var(--ff-kr-main) !important;font-weight:400;letter-spacing:-0.1px;}
  .section-space .heading,.section-room .heading,.heading,h1,h2,h3,h4,h5,h6{
    font-family:var(--ff-kr-main) !important;font-weight:700;letter-spacing:-0.15px;
  }
  .btn,.btn-primary,a.btn,a.btn-primary{font-family:var(--ff-kr-main) !important;font-weight:600;letter-spacing:-0.1px;}
  .property-content .city,.property-content .price,.property-content .room-price strong{font-family:var(--ff-kr-main) !important;font-weight:600;}
  .testimonial,.testimonial blockquote,.testimonial .fw-bold,.testimonial .text-muted{font-family:var(--ff-kr-main) !important;font-weight:400;}

  .section-alt-bg{background:#f0f4f7;}
  .section-board-bg{background:#f5f5f5;}

  .link-seeall{
    color:#4a90e2 !important;font-size:.95rem;font-weight:600;text-decoration:none;white-space:nowrap;
  }
  .link-seeall:hover{text-decoration:underline;}

  /* Promo banner */
  .promo-wrap{position:relative;max-width:850px;margin:30px auto;}
  .promo-slider{--banner-h:220px;display:flex !important;}
  @media(min-width:992px){.promo-slider{--banner-h:260px;}}
  .promo-slider .tns-item{display:flex !important;justify-content:center;align-items:center;}
  .promo-item{
    width:100%;height:var(--banner-h);
    display:flex;justify-content:center;align-items:center;
    overflow:hidden;border-radius:16px;background:#fff;
  }
  .promo-item img{
    max-width:100%;max-height:100%;width:auto;height:auto;object-fit:contain;
    display:block;margin:0 auto;border-radius:inherit;
  }
  .promo-btn{
    position:absolute;top:50%;transform:translateY(-50%);
    width:46px;height:46px;border:none;border-radius:50%;
    background:rgba(0,0,0,.35);color:#fff;font-size:26px;line-height:1;
    display:flex;align-items:center;justify-content:center;cursor:pointer;z-index:10;
  }
  .promo-btn:hover{background:rgba(0,0,0,.5);}
  .promo-prev{left:10px;}
  .promo-next{right:10px;}
  .promo-wrap,.promo-slider,.promo-item,.promo-slider .tns-outer,.promo-slider .tns-ovh{background:transparent !important;}
  </style>

  <title>Property &mdash; Free Bootstrap 5 Website Template by Untree.co</title>
</head>
<body>
<%@ include file="/WEB-INF/views/include/navigation.jsp" %>

<div class="site-mobile-menu site-navbar-target">
  <div class="site-mobile-menu-header">
    <div class="site-mobile-menu-close"><span class="icofont-close js-menu-toggle"></span></div>
  </div>
  <div class="site-mobile-menu-body"></div>
</div>

<!-- HERO -->
<div class="hero-overlay">
  <div class="hero-slider">
    <c:forEach var="idx" begin="1" end="5">
      <div class="slide">
        <img src="${pageContext.request.contextPath}/resources/upload/index/${idx}.jpg"
             alt="Placeholder ${idx}"
             onerror="this.src='${pageContext.request.contextPath}/resources/upload/index/default-room.jpg'"/>
      </div>
    </c:forEach>
  </div>
  <div class="hero-title">
    <div class="hero-sub"> press to pause and find your perfect space.</div>
    <div class="hero-main">
      <span class="static"></span><span id="typewriter"></span><span class="cursor">_</span>
    </div>
  </div>
</div>

<!-- CATEGORY SECTION -->
<div class="section py-5 section-alt-bg">
  <div class="container">
    <div class="category-grid">
      <c:forEach var="cat2" items="${spaceCategoryList}">
        <button type="button" class="category2-btn" data-name="${cat2.roomCatName}">
          <img src="${pageContext.request.contextPath}/resources/upload/category/${cat2.roomCatSeq}.${cat2.roomCatIconExt}"/>
          <div class="small text-dark">${cat2.roomCatName}</div>
        </button>
      </c:forEach>
    </div>

    <div class="category-grid">
      <c:forEach var="cat" items="${roomCategoryList}">
        <button type="button" class="category-btn" data-name="${cat.roomCatName}">
          <img src="${pageContext.request.contextPath}/resources/upload/category/${cat.roomCatSeq}.${cat.roomCatIconExt}"/>
          <div class="small text-dark">${cat.roomCatName}</div>
        </button>
      </c:forEach>
    </div>
  </div>
</div>

<!-- 신규등록공간 -->
<div class="section section-space">
  <div class="container">
    <div class="row mb-5 align-items-center">
      <div class="col-lg-6">
        <h2 class="font-weight-bold text-primary heading">신규 공간</h2>
      </div>
      <div class="col-lg-6 text-lg-end">
        <a href="${pageContext.request.contextPath}/room/spaceList" class="link-seeall">모든공간보기</a>
      </div>
    </div>
    <div class="row">
      <div class="col-12">
        <div class="property-slider-wrap">
          <div class="property-slider space-slider">
            <c:forEach var="newSpaceList" items="${spaceList}">
              <div class="property-item">
                <a href="${pageContext.request.contextPath}/room/roomDetail?roomSeq=${newSpaceList.roomSeq}" class="img">
                  <img src="${pageContext.request.contextPath}/resources/upload/room/main/${newSpaceList.roomImgName}"
                       onerror="this.src='${pageContext.request.contextPath}/resources/upload/room/main/default-room.png'"
                       alt="${newSpaceList.roomTitle}" class="img-fluid"/>
                </a>
                <div class="property-content">
                  <div>
                    <span class="d-block mb-2 text-black-50 room-addr">${newSpaceList.roomAddr}</span>
                    <a href="${pageContext.request.contextPath}/room/roomDetail?roomSeq=${newSpaceList.roomSeq}"
                       class="city d-block mb-3 text-decoration-none text-black">${newSpaceList.roomTitle}</a>
                    <div class="specs d-flex mb-4">
                      <span class="d-block d-flex align-items-center me-3">
                        <span class="caption">⭐ ${newSpaceList.averageRating}</span>&nbsp;
                        <span class="caption">(${newSpaceList.reviewCount}명)</span>
                      </span>
                    </div>
                    <div class="room-price">
                      <strong><fmt:formatNumber value="${newSpaceList.weekdayAmt}" pattern="#,###" />원~</strong>
                      <c:set var="isWished" value="false"/>
                      <c:forEach var="seq" items="${wishSeqs}">
                        <c:if test="${seq eq newSpaceList.roomSeq}"><c:set var="isWished" value="true"/></c:if>
                      </c:forEach>
                      <button class="wish-heart" data-wished="${isWished}" onclick="toggleWish(${newSpaceList.roomSeq}, this)">
                        <i class="${isWished ? 'fas fa-heart wished' : 'far fa-heart'}"></i>
                      </button>
                    </div>
                  </div>
                </div>
              </div>
            </c:forEach>
          </div>
          <div id="space-nav" class="controls" tabindex="0" aria-label="Carousel Navigation">
            <span class="prev" data-controls="prev" aria-controls="property">◀</span>
            <span class="next" data-controls="next" aria-controls="property">▶</span>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

<!-- PROMO BANNER SLIDER -->
<div class="promo-wrap">
  <div id="promoSlider" class="promo-slider">
    <div class="promo-item">
      <img src="${pageContext.request.contextPath}/resources/upload/index/11.png" alt="Summer Sale" />
    </div>
    <div class="promo-item">
      <img src="${pageContext.request.contextPath}/resources/upload/index/12.png" alt="Welcome to Spacebar" />
    </div>
    <div class="promo-item">
      <img src="${pageContext.request.contextPath}/resources/upload/index/13.png" alt="Black Friday" />
    </div>
    <div class="promo-item">
      <img src="${pageContext.request.contextPath}/resources/upload/index/14.png" alt="Spacebar Pass" />
    </div>
  </div>
  <button type="button" class="promo-btn promo-prev" aria-label="이전">‹</button>
  <button type="button" class="promo-btn promo-next" aria-label="다음">›</button>
</div>

<!-- 신규등록숙소 -->
<div class="section section-room section-alt-bg">
  <div class="container">
    <div class="row mb-5 align-items-center">
      <div class="col-lg-6">
        <h2 class="font-weight-bold text-primary heading">신규 숙소</h2>
      </div>
      <div class="col-lg-6 text-lg-end">
        <a href="${pageContext.request.contextPath}/room/roomList" class="link-seeall">모든숙소보기</a>
      </div>
    </div>
    <div class="row">
      <div class="col-12">
        <div class="property-slider-wrap">
          <div class="property-slider room-slider">
            <c:forEach var="newList" items="${roomList}">
              <div class="property-item">
                <a href="${pageContext.request.contextPath}/room/roomDetail?roomSeq=${newList.roomSeq}" class="img">
                  <img src="${pageContext.request.contextPath}/resources/upload/room/main/${newList.roomImgName}"
                       onerror="this.src='${pageContext.request.contextPath}/resources/upload/room/main/default-room.png'"
                       class="img-fluid"/>
                </a>
                <div class="property-content">
                  <div>
                    <span class="d-block mb-2 text-black-50 room-addr">${newList.roomAddr}</span>
                    <a href="${pageContext.request.contextPath}/room/roomDetail?roomSeq=${newList.roomSeq}"
                       class="city d-block mb-3 text-decoration-none text-black">${newList.roomTitle}</a>
                    <div class="specs d-flex mb-4">
                      <span class="d-block d-flex align-items-center me-3">
                        <span class="caption">⭐ ${newList.averageRating}</span>&nbsp;
                        <span class="caption">(${newList.reviewCount}명)</span>
                      </span>
                    </div>
                    <div class="room-price">
                      <strong><fmt:formatNumber value="${newList.weekdayAmt}" pattern="#,###" />원~</strong>
                      <c:set var="isWished" value="false"/>
                      <c:forEach var="seq" items="${wishSeqs}">
                        <c:if test="${seq eq newList.roomSeq}"><c:set var="isWished" value="true"/></c:if>
                      </c:forEach>
                      <button class="wish-heart" data-wished="${isWished}" onclick="toggleWish(${newList.roomSeq}, this)">
                        <i class="${isWished ? 'fas fa-heart wished' : 'far fa-heart'}"></i>
                      </button>
                    </div>
                  </div>
                </div>
              </div>
            </c:forEach>
          </div>
          <div id="room-nav" class="controls" tabindex="0" aria-label="Carousel Navigation">
            <span class="prev" data-controls="prev" aria-controls="property">◀</span>
            <span class="next" data-controls="next" aria-controls="property">▶</span>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

<!-- FEATURES -->
<section class="features-1">
  <div class="container">
    <div class="row">
      <div class="col-6 col-lg-3" data-aos="fade-up" data-aos-delay="300">
        <div class="box-feature">
          <span class="flaticon-house"></span>
          <h3 class="mb-3"><a href="${pageContext.request.contextPath}/board/list" class="learn-more">자유게시판</a></h3>
          <p>공간을 빌리는 사람도, <br> 빌려주는 사람도<br> 경험과 팁을 나누는 <br> 우리만의 자유게시판입니다.</p>
          <p><a href="${pageContext.request.contextPath}/board/list" class="learn-more">방문하기</a></p>
        </div>
      </div>
      <div class="col-6 col-lg-3" data-aos="fade-up" data-aos-delay="500">
        <div class="box-feature">
          <span class="flaticon-building"></span>
          <h3 class="mb-3"><a href="${pageContext.request.contextPath}/qna/list" class="learn-more">qna게시판</a></h3>
          <p>spacebar만의 <br> 공간·숙소 대여가 궁금하다면 <br> 여기서 묻고, <br>답변 받아보세요.</p>
          <p><a href="${pageContext.request.contextPath}/qna/list" class="learn-more">방문하기</a></p>
        </div>
      </div>
      <div class="col-6 col-lg-3" data-aos="fade-up" data-aos-delay="400">
        <div class="box-feature">
          <span class="flaticon-house-3"></span>
          <h3 class="mb-3"><a href="${pageContext.request.contextPath}/notice/noticeList" class="learn-more">공지사항</a></h3>
          <p>Spacebar  <br> 공식 소식과   <br> 꼭 알아야 할 안내를   <br> 한 곳에서 확인하세요.</p>
          <p><a href="${pageContext.request.contextPath}/notice/noticeList" class="learn-more">방문하기</a></p>
        </div>
      </div>
      <div class="col-6 col-lg-3" data-aos="fade-up" data-aos-delay="600">
        <div class="box-feature">
          <span class="flaticon-house-1"></span>
          <h3 class="mb-3"><a href="${pageContext.request.contextPath}/board/faq" class="learn-more">자주묻는질문</a></h3>
          <p>한 번에 해결하는   <br>  기본 궁금증!   <br>  예약·결제·환불·쿠폰까지 <br>  FAQ에서 빠르게 확인하세요.</p>
          <p><a href="${pageContext.request.contextPath}/board/faq" class="learn-more">방문하기</a></p>
        </div>
      </div>
    </div>
  </div>
</section>

<!-- 후기 -->
<div class="section sec-testimonials section-alt-bg">
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
                <img src="${pageContext.request.contextPath}/resources/upload/userprofile/${rev.userId}.${rev.profImgExt}"
                     onerror="this.src='${pageContext.request.contextPath}/resources/upload/userprofile/회원.png'"
                     class="rounded-circle" width="50" height="50"/>
                <strong class="d-block mt-2">${rev.userNickname}</strong>
              </div>
              <div class="mb-3">
                <a href="${pageContext.request.contextPath}/room/roomDetail?roomSeq=${rev.roomSeq}">
                  <img src="${pageContext.request.contextPath}/resources/upload/review/${rev.reviewImgName}"
                       onerror="this.src='${pageContext.request.contextPath}/resources/upload/room/main/default-room.png'"
                       class="img-fluid rounded"/>
                </a>
              </div>
              <blockquote class="mb-2">
			    &ldquo;<c:out value="${rev.reviewContent}" escapeXml="false"/>&rdquo;
			</blockquote>
              <div class="fw-bold mb-1">${rev.roomTitle} (${rev.roomTypeTitle})</div>
              <div class="text-muted small">${rev.roomAddr}</div>
            </div>
          </div>
        </c:forEach>
      </div>
      <div class="testimonial-dots text-center mt-4"></div>
    </div>
  </div>
</div>

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
function toggleWish(roomSeq, btn){
  const $btn   = $(btn);
  const $icon  = $btn.find('i.fa-heart');
  const wished = $btn.data('wished');
  const url    = wished ? "/wishlist/remove" : "/wishlist/add";

  $.post(url,{roomSeq:roomSeq})
    .done(function(res){
      if(res.code===0){
        if(wished){
          $icon.removeClass("fas wished").addClass("far");
          $btn.data('wished',false);
          Swal.fire({icon:"success",title:"삭제됐습니다",text:"찜 목록에서 제거되었습니다.",timer:1500,showConfirmButton:false});
        }else{
          $icon.removeClass("far").addClass("fas wished");
          $btn.data('wished',true);
          Swal.fire({icon:"success",title:"추가되었습니다",text:"찜 목록에 추가되었습니다.",timer:1500,showConfirmButton:false});
        }
      }else if(res.code===500){
        Swal.fire("로그인 후 이용하세요",res.message,"warning");
      }else{
        Swal.fire("오류",res.message,"error");
      }
    })
    .fail(function(){
      Swal.fire("네트워크 오류","잠시 후 다시 시도해주세요.","error");
    });
}

$(".category-btn, .category2-btn").on("click",function(){
  const name = $(this).data("name");
  const target = $(this).hasClass("category2-btn")
                 ? "${pageContext.request.contextPath}/room/spaceList"
                 : "${pageContext.request.contextPath}/room/roomList";

  $("#searchForm").attr("action",target).find("#category").val(name);
  $("#searchForm").find("input[name=curPage]").val(1);
  $("#searchForm")[0].submit();
});

document.addEventListener('DOMContentLoaded', () => {
  const text = 'Spacebar';      // 타이핑할 글자
  const el   = document.getElementById('typewriter');
  const TYPE_DELAY = 90;   // 한 글자 속도
  const INTERVAL   = 7000; // 반복 주기

  function runTypewriter(){
    el.textContent = '';
    for(let i=0;i<text.length;i++){
      setTimeout(() => {
        el.textContent += text[i];
      }, TYPE_DELAY * i);
    }
  }

  runTypewriter();
  setInterval(runTypewriter, INTERVAL);
});
</script>

<%@ include file="/WEB-INF/views/include/footer.jsp" %>
</body>
</html>
