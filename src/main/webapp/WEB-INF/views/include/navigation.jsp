<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<style>
:root{
  --nav-h:63px;
  --nav-max:1333px;
  --nav-font:1.11rem;   /* 메뉴 글씨 크기 */
  --icon-size:24px;     /* 아이콘 크기   */
}

/* ===== 기본 ===== */
.logo{display:flex;align-items:center;line-height:1; margin-left: 9px;}
.logo-img{height:59px;max-width:299px;display:block;}
@media (max-width:1000px){.logo-img{height:52px;}}

.visually-hidden{
  position:absolute;width:1px;height:1px;padding:0;margin:-1px;
  overflow:hidden;clip:rect(0,0,0,0);border:0;
}

/* ===== 네비 영역 ===== */
.site-nav{
  position:fixed;top:0;left:0;right:0;z-index:9999;
  margin:0 !important;padding:0 !important;
  
}
.site-nav .menu-bg-wrap{
  background:transparent !important;box-shadow:none !important;
  margin:0 !important;padding:0 !important;
  min-height:var(--nav-h);display:flex;align-items:center;
}
.site-nav.nav-solid .menu-bg-wrap{
  background:#fff !important;box-shadow:0 2px 10px rgba(0,0,0,.06);
}

/* 내부 폭 */
.site-nav .container{
  max-width:var(--nav-max) !important;width:100% !important;
  margin:0 auto !important;padding:0 16px !important;
}

/* 정렬 */
.site-navigation{display:flex;align-items:center;width:100%;}
.site-navigation .logo{margin-right:auto;}
.site-navigation .site-menu{margin-left:auto;}

/* 메뉴 글씨 크기/색상 */
.site-nav .site-menu > li > a,
.site-nav .submenu a,
.site-nav .site-navigation a:not(.btn){
  color:#000 !important;
  font-size:var(--nav-font);
}
.site-nav .site-menu > li > a:hover,
.site-nav .site-menu > li > a:focus,
.site-nav .submenu a:hover{color:#FF8F00 !important;}

/* 모바일 메뉴/버거 */
.site-mobile-menu .site-mobile-menu-body a{color:#000 !important;}
.burger.light span,
.burger.light span:before,
.burger.light span:after{background:#000 !important;}

/* 본문 상단 패딩 */
body{padding-top:var(--nav-h);}

/* 아이콘 */
.nav-icon a{
  font-size:var(--icon-size);
  line-height:1;
  display:inline-flex;
  align-items:center;
  padding:0 6px;
}
.nav-icon a:hover i{
  transform:scale(1.08);
  transition:transform .15s;
}
.nav-heart i{ color:#e53935; }  /* 빨간 하트 */
.nav-cart  i{ color:#4aa3ff; }  /* 하늘색 카트  */
.site-menu li.nav-icon > a::before{content:none !important;} /* 테마 기본 before 제거 */
</style>


<style id="nav-override">
/* 메뉴 글씨 크기 강제 */
nav.site-nav .site-menu > li > a,
nav.site-nav .submenu a,
nav.site-nav .site-navigation a:not(.btn) {
  font-size: 1.009rem !important;
  color: #000 !important;
}

/* 아이콘 크기 강제 */
nav.site-nav .nav-icon a i {
  font-size: 22px !important;
}

/* 하트/카트 색 */
nav.site-nav .nav-heart i { color:#e53935 !important; }
nav.site-nav .nav-cart  i { color:#4aa3ff !important; }
</style>

<!-- Font Awesome (공통) -->
<link rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css"
      crossorigin="anonymous" referrerpolicy="no-referrer" />

<%
    String sessionId = (String)session.getAttribute("SESSION_USER_ID"); // 세션 키 정확히!
    boolean isLoggedIn = (sessionId != null && !sessionId.isEmpty());
%>
<style>
  .site-menu, .site-menu * {
    font-size: 16px !important;
  }
/* 
  .site-nav .logo {
    font-size: 28px; /* Spacebar 로고 크기만 따로 */
  } */
</style>


<nav class="site-nav">
  <div class="container">
    <div class="menu-bg-wrap">
      <div class="site-navigation">

        <!-- 로고: 왼쪽 -->
        <a href="${pageContext.request.contextPath}/" class="logo">
          <img src="${pageContext.request.contextPath}/resources/upload/index/navi.png"
               srcset="${pageContext.request.contextPath}/resources/upload/index/navi.png 2x"
               alt="Spacebar" class="logo-img">
          <span class="visually-hidden">Spacebar</span>
        </a>

        <!-- 메뉴: 오른쪽 -->
        <ul class="js-clone-nav d-none d-lg-inline-block text-start site-menu">
          <li><a href="${pageContext.request.contextPath}/room/roomList">숙소목록</a></li>
          <li><a href="${pageContext.request.contextPath}/room/spaceList">공간대여목록</a></li>

          <li class="has-submenu">
            <a href="${pageContext.request.contextPath}/board/list">게시판</a>
            <ul class="submenu">
              <li><a href="${pageContext.request.contextPath}/notice/list">공지사항</a></li>
              <li><a href="${pageContext.request.contextPath}/board/list">자유게시판</a></li>
              <li><a href="${pageContext.request.contextPath}/qna/list">Q&amp;A</a></li>
              <li><a href="${pageContext.request.contextPath}/board/faq">FaQ</a></li>
              <li><a href="${pageContext.request.contextPath}/coupon/listJY">쿠폰</a></li>
            </ul>
          </li>

          <li><a href="${pageContext.request.contextPath}/payment/chargeMileage">카카오페이</a></li>

          <!-- 로그인 상태 -->
          <c:if test="${not empty sessionScope.SESSION_USER_ID}">
            <li><a href="${pageContext.request.contextPath}/user/myPage">마이페이지</a></li>
            <li><a href="${pageContext.request.contextPath}/user/loginOut">로그아웃</a></li>

            <li class="nav-icon">
              <a href="${pageContext.request.contextPath}/wishlist/list" class="nav-heart" aria-label="위시리스트">
                <i class="fa-solid fa-heart" aria-hidden="true"></i>
              </a>
            </li>
            <li class="nav-icon">
              <a href="${pageContext.request.contextPath}/cart/list" class="nav-cart" aria-label="장바구니">
                <i class="fa-solid fa-cart-shopping" aria-hidden="true"></i>
              </a>
            </li>

          </c:if>

          <!-- 비로그인 상태 -->
          <c:if test="${empty sessionScope.SESSION_USER_ID}">
            <li><a href="${pageContext.request.contextPath}/user/loginForm">로그인</a></li>
            <li><a href="${pageContext.request.contextPath}/user/regForm">회원가입</a></li>
          </c:if>
        </ul>

        <!-- 모바일 토글 -->
        <a href="#" class="burger light site-menu-toggle js-menu-toggle d-inline-block d-lg-none">
          <span></span>
        </a>
      </div>
    </div>
  </div>
</nav>

<script>
(function(){
  const nav = document.querySelector('.site-nav');
  const onScroll = ()=>{
    if(window.scrollY > 10) nav.classList.add('nav-solid');
    else nav.classList.remove('nav-solid');
  };
  window.addEventListener('scroll', onScroll);
  onScroll();
})();
</script>
