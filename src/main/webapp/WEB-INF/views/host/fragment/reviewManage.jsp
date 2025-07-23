<%-- /WEB-INF/views/host/fragment/reviewManage.jsp --%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<div class="detail-content">
    <h3>받은 리뷰</h3>

    <!-- 숙소 필터 -->
    <select id="roomFilter" class="form-select">
        <option value="">전체 숙소</option>
        <c:forEach var="room" items="${roomList}">
            <option value="${room.roomSeq}">${room.roomTitle}</option>
        </c:forEach>
    </select>

    <!-- 리뷰 목록 테이블 -->
    <div id="reviewTableContainer" style="margin-top: 20px;">
        <table class="table table-striped">
            <thead>
                <tr>
                    <th>숙소</th>
                    <th>객실</th>
                    <th>제목</th>
                    <th>평점</th>
                    <th>작성자</th>
                    <th>작성일</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${empty reviewList}">
                        <tr>
                            <td colspan="6" class="text-center">등록된 리뷰가 없습니다.</td>
                        </tr>
                    </c:when>
                    <c:otherwise>
						<c:forEach var="r" items="${reviewList}">
						    <tr class="review-row" data-room-seq="${r.roomSeq}" style="cursor: pointer;">
						        <td>${r.roomTitle}</td>
						        <td>${r.roomTypeTitle}</td>
						        <td>${r.reviewTitle}</td>
						        <td>${r.rating}</td>
						        <td>${r.userNickname}</td>
						        <td>${r.regDt}</td>
						    </tr>
						</c:forEach>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>
</div>



