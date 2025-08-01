<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<title><spring:eval expression="@env['site.title']" /></title>

<!-- Favicon -->
<link rel="shortcut icon" href="/resources/images/favicon.ico" type="image/x-icon">

<!-- CSS -->
<%-- <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/fonts/icomoon/style.css" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/fonts/flaticon/font/flaticon.css" /> --%>
<link rel="stylesheet" href="/resources/css/style.css" type="text/css">
<link rel="stylesheet" href="/resources/css/tiny-slider.css" />
<link rel="stylesheet" href="/resources/css/aos.css" />
<link rel="stylesheet" href="/resources/css/navi.css" />

<!-- JS -->
<script src="/resources/js/jquery-3.5.1.min.js"></script>
<script src="/resources/js/icia.common.js"></script>
<script src="/resources/js/icia.ajax.js"></script>
<!-- 추가 -->
<script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/stompjs@2.3.3/lib/stomp.min.js"></script>



