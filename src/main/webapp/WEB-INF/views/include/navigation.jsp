
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="javax.servlet.http.Cookie" %>
<%@ page import="com.sist.web.util.CookieUtil" %>
<%@ page import="com.sist.web.util.SessionUtil"%>

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

<!-- Navigation Start -->
<nav class="site-nav">
  <div class="container">
    <div class="menu-bg-wrap">
      <div class="site-navigation">
        <a href="/" class="logo m-0 float-start">Spacebar</a>

        <ul class="js-clone-nav d-none d-lg-inline-block text-start site-menu float-end" style="font-size: 18px;">
          <li><a href="/room/roomList">숙소목록</a></li>
		  <li><a href="/room/spaceList">공간대여목록</a></li>
          
		<li class="has-submenu" style="font-size: 18px;">
		    <a href="/board/list">게시판</a>
		    <ul class="submenu">
		      <li><a href="/notice/list">공지사항</a></li>
		      <li><a href="/board/list">자유게시판</a></li>
		      <li><a href="/qna/list">Q&A</a></li>
		      <li><a href="/board/faq">FaQ</a></li>
		    </ul>
		  </li>

          <li style="font-size: 18px;"><a href="/coupon/listJY">쿠폰리스트</a></li>
          <li><a href="/payment/chargeMileage">카카오페이</a></li>
          <c:if test="<%= isLoggedIn %>">
            <li><a href="/user/myPage">마이페이지</a></li>
            <li><a href="/user/loginOut">로그아웃</a></li>
            
          </c:if>
          <c:if test="<%= !isLoggedIn %>">
            <li><a href="/user/loginForm">로그인</a></li>
            <li><a href="/user/regForm">회원가입</a></li>
          </c:if>
        </ul>

        <a href="#" class="burger light me-auto float-end mt-1 site-menu-toggle js-menu-toggle d-inline-block d-lg-none">
          <span></span>
        </a>
      </div>
    </div>
  </div>
</nav>
<!-- Navigation End -->

