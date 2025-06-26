<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.sist.web.util.HttpUtil" %>    
<%
	String address = HttpUtil.get(request, "address", "");
	String roomName = HttpUtil.get(request, "roomName", "");
%>
<%@ include file="/WEB-INF/views/include/head.jsp" %>    


<%--카카오맵 api 호출 및 키 입력 --%>
<%--카카오맵 화면 크기 조절  --%>
<%-- 로직은 /resources/js/map.js --%>
<div id="map" style="width:33%; height:350px;" data-address="<%= address %>" data-room-name="<%= roomName%>"></div>

<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${initParam.KAKAO_MAP_KEY}&libraries=services"></script>

<script src="<c:url value='/resources/js/map.js' />"></script>