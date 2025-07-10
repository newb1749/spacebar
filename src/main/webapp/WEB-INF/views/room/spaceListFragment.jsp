<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core"      %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"       %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>

<c:forEach var="room" items="${list}">
    <div class="room-list-item">
      <img src="/resources/upload/room/main/${room.roomImageName}" alt="${room.roomTitle}" class="room-thumbnail" onclick="fn_roomDetail(${room.roomSeq});">
      <div class="room-details">
        <div class="room-title" style="cursor: pointer;" onclick="fn_roomDetail(${room.roomSeq});">${room.roomTitle}  ${room.roomSeq}</div>
        <div class="room-location">${room.roomAddr}</div>
        <div class="room-rating">⭐ ${room.averageRating} (${room.reviewCount}명)</div>
        <div class="room-price">
          <fmt:formatNumber value="${room.amt}" type="currency" currencySymbol="₩" />
        
	        <c:set var="isWished" value="false"/>
			  <c:forEach var="seq" items="${wishSeqs}">
			    <c:if test="${seq eq room.roomSeq}">
			      <c:set var="isWished" value="true"/>
			    </c:if>
			  </c:forEach>
			
			  <button class="wish-heart" data-wished="${isWished}"
			          onclick="toggleWish(${room.roomSeq}, this)">
			    <i class="${isWished ? 'fas fa-heart wished' : 'far fa-heart'}"></i>
			  </button>
        
        </div>
      </div>
    </div>
  </c:forEach>
