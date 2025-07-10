<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="javax.servlet.http.Cookie" %>
<%@ page import="com.sist.web.util.CookieUtil" %>
<%@ page import="com.sist.web.util.SessionUtil"%>

<%
    String sessionId = (String)session.getAttribute("SESSION_USER_ID"); // 세션 키 정확히!
    boolean isLoggedIn = (sessionId != null && !sessionId.isEmpty());
%>


<!-- Navigation Start -->
<nav class="site-nav">
  <div class="container">
    <div class="menu-bg-wrap">
      <div class="site-navigation">
        <a href="/" class="logo m-0 float-start">Spacebar</a>

        <ul class="js-clone-nav d-none d-lg-inline-block text-start site-menu float-end">
          <li><a href="/">Home</a></li>
          <li><a href="/room/roomList">숙소목록</a></li>

          <li><a href="/board/list">게시판</a></li>

          <li><a href="/room/spaceList">공간대여목록</a></li>
          <li><a href="/kakao/pay2">카카오페이</a></li>
          <c:if test="<%= isLoggedIn %>">
            <li><a href="/user/myPage_mj">마이페이지</a></li>
            <li><a href="/user/loginOut">로그아웃</a></li>
          </c:if>
          <c:if test="<%= !isLoggedIn %>">
            <li><a href="/user/loginForm_mj">로그인</a></li>
            <li><a href="/user/regForm_mj">회원가입</a></li>
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
