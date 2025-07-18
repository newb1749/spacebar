<%-- /WEB-INF/views/host/fragment/roomList.jsp --%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>


<%-- detail-content 클래스로 감싸서 기존 디자인과 통일 --%>
<div class="detail-content">
    <h3>내가 등록한 공간 목록</h3>
    <c:choose>
        <c:when test="${not empty roomList}">
            <table class="table table-hover"> <%-- table-hover 추가 --%>
                <thead>
                    <tr>
                        <th>숙소명</th>
                        <th>주소</th>
                        <th>등록일</th>
                        <th>평점</th>
                        <th style="width: 15%;">관리</th> <%-- [수정] '관리' 항목 추가 --%>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="room" items="${roomList}">
                        <tr>
                            <td>${room.roomTitle}</td>
                            <td>${room.roomAddr}</td>
					        <td>
					            <%-- 1. DB에서 온 String을 Date 객체로 변환하여 "parsedDate" 변수에 저장 --%>
					            <%-- 중요: pattern은 실제 데이터베이스 문자열 형식과 일치해야 합니다. --%>
					            <fmt:parseDate value="${room.regDt}" pattern="yyyy-MM-dd HH:mm:ss" var="parsedDate" />
					
					            <%-- 2. 변환된 Date 객체를 원하는 형식(yyyy-MM-dd)으로 출력 --%>
					            <fmt:formatDate value="${parsedDate}" pattern="yyyy-MM-dd" />
					        </td>
                            <td>${room.averageRating}</td>
                            <%-- [수정] 상세 버튼과 수정 버튼 추가 --%>
							<td>
							    <a href="/room/roomDetail?roomSeq=${room.roomSeq}" target="_blank" class="btn btn-outline-secondary btn-sm">상세</a>
							    <a href="/host/updateRoom?roomSeq=${room.roomSeq}" target="_blank" class="btn btn-outline-primary btn-sm">수정</a>
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
    <a href="/room/addForm" class="btn btn-success mt-3">+ 객실 추가</a>
</div>