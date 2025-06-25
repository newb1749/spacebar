<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<%@ include file="/WEB-INF/views/include/head.jsp" %>

<c:forEach var="room" items="${list}">
    <div class="room-list-item">
      <img src="/resources/upload/room/main/${room.roomImageName}" alt="${room.roomTitle}" class="room-thumbnail">
      <div class="room-details">
        <div class="room-title">${room.roomTitle}</div>
        <div class="room-location">${room.roomAddr}</div>
        <div class="room-rating">⭐ ${room.averageRating} (${room.reviewCount}명)</div>
        <div class="room-price">
          <fmt:formatNumber value="${room.amt}" type="currency" currencySymbol="₩" />
        </div>
      </div>
    </div>
  </c:forEach>