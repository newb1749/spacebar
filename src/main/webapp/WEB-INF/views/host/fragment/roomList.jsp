<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="detail-content">
	<div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px;">
	    <h3 style="margin: 0;">내가 등록한 공간 목록</h3>
	    <a href="/room/addForm" class="btn btn-sm"
	       style="background-color: #FDF5AA; color: black;">
	       + 객실 추가
	    </a>
	</div>

	<c:choose>
	    <c:when test="${not empty roomList}">
	        <table class="table table-hover">
	            <thead>
	                <tr>
	                    <th>이미지</th>
	                    <th>숙소명</th>
	                    <th>주소</th>
	                    <th>등록일</th>
	                    <th style="width: 80px; text-align: center;">평점</th>
	                    <th style="width: 15%;">관리</th>
	                </tr>
	            </thead>
	            <tbody>
	                <c:forEach var="room" items="${roomList}">
	                    <tr>
	                        <td>
	                            <c:choose>
	                                <c:when test="${not empty room.mainImageName}">
	                                    <img src="${pageContext.request.contextPath}/resources/upload/room/main/${room.mainImageName}"
	                                         style="width: 100px; height: 80px; object-fit: cover; border-radius: 6px;" />
	                                </c:when>
	                                <c:otherwise>
	                                    <img src="${pageContext.request.contextPath}/resources/images/no-image.png"
	                                         style="width: 100px; height: 80px; object-fit: cover; border-radius: 6px;" />
	                                </c:otherwise>
	                            </c:choose>
	                        </td>
	                        <td>
	                            <a href="/room/roomDetail?roomSeq=${room.roomSeq}" target="_blank"
	                               style="color: #3B5B6D; font-weight: bold; text-decoration: none;">
	                               ${room.roomTitle}
	                            </a>
	                        </td>
	                        <td>${room.roomAddr}</td>
	                        <td>
	                            <fmt:parseDate value="${room.regDt}" pattern="yyyy-MM-dd HH:mm:ss" var="parsedDate" />
	                            <fmt:formatDate value="${parsedDate}" pattern="yyyy-MM-dd" />
	                        </td>
	                        <td style="text-align: center;">${room.averageRating}</td>
	                        <td>
	                            <div style="display: flex; flex-direction: column; gap: 6px;">
	                                <a href="/host/updateRoom?roomSeq=${room.roomSeq}" target="_blank"
	                                   class="btn btn-sm"
	                                   style="background-color: #3B5B6D; color: white;">수정</a>

	                                <c:choose>
	                                    <c:when test="${room.saleYn eq 'Y'}">
	                                        <button type="button" class="btn btn-sm btn-stop"
	                                                data-room-seq="${room.roomSeq}"
	                                                style="background-color: #799EFF; color: white;">판매 중지</button>
	                                    </c:when>
	                                    <c:otherwise>
	                                        <button type="button" class="btn btn-sm btn-resume"
	                                                data-room-seq="${room.roomSeq}"
	                                                style="background-color: #34699A; color: white;">판매 재개</button>
	                                    </c:otherwise>
	                                </c:choose>

	                                <button type="button" class="btn btn-sm btn-delete"
	                                        data-room-seq="${room.roomSeq}"
	                                        style="background-color: #EA5B6F; color: white;">삭제</button>
	                            </div>
	                        </td>
	                    </tr>
	                </c:forEach>
	            </tbody>
	        </table>
	    </c:when>
	    <c:otherwise>
	        <div class="no-data">등록한 공간이 없습니다.</div>
	    </c:otherwise>
	</c:choose>
</div>

