<%-- /WEB-INF/views/host/fragment/roomList.jsp --%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>


<%-- detail-content 클래스로 감싸서 기존 디자인과 통일 --%>
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
            <table class="table table-hover"> <%-- table-hover 추가 --%>
                <thead>
					  <tr>
					    <th>이미지</th>  <%-- ✅ 이렇게 수정 --%>
					    <th>숙소명</th>
					    <th>주소</th>
					    <th>등록일</th>
					    <th>평점</th>
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
							             alt="대표 이미지"
							             style="width: 100px; height: 80px; object-fit: cover; border-radius: 6px;" />
							      </c:when>
							      <c:otherwise>
							        <img src="${pageContext.request.contextPath}/resources/images/no-image.png"
							             alt="기본 이미지"
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
							<td>
							  <a href="/room/roomDetail?roomSeq=${room.roomSeq}" target="_blank"
							     style="color: #3B5B6D; font-weight: bold; text-decoration: none;">
							    ${room.roomTitle}
							  </a>
							</td>

                            <td>${room.roomAddr}</td>
					        <td>
					            <%-- 1. DB에서 온 String을 Date 객체로 변환하여 "parsedDate" 변수에 저장 --%>
					            <%-- 중요: pattern은 실제 데이터베이스 문자열 형식과 일치해야 합니다. --%>
					            <fmt:parseDate value="${room.regDt}" pattern="yyyy-MM-dd HH:mm:ss" var="parsedDate" />
					
					            <%-- 2. 변환된 Date 객체를 원하는 형식(yyyy-MM-dd)으로 출력 --%>
					            <fmt:formatDate value="${parsedDate}" pattern="yyyy-MM-dd" />
					        </td>
                            <td>${room.averageRating}</td>
                            <%-- 수정, 판매중지(재개), 삭제 버튼 추가 --%>
							<td>
							  <div style="display: flex; flex-direction: column; gap: 6px;">
							  
							    <a href="/host/updateRoom?roomSeq=${room.roomSeq}" target="_blank"
							       class="btn btn-sm"
							       style="background-color: #3B5B6D; color: white; width: 100%;">
							       수정
							    </a>
							
							    <c:choose>
							      <c:when test="${room.saleYn eq 'Y'}">
							        <form action="/host/room/stopSelling" method="post"
							              onsubmit="return confirm('판매를 중지하시겠습니까?');"
							              style="margin: 0; width: 100%;">
							          <input type="hidden" name="roomSeq" value="${room.roomSeq}" />
							          <button type="submit" class="btn btn-sm"
							                  style="background-color: #799EFF; color: white; width: 100%;">
							            판매 중지
							          </button>
							        </form>
							      </c:when>
							      <c:otherwise>
							        <form action="/host/room/resumeSelling" method="post"
							              onsubmit="return confirm('판매를 재개하시겠습니까?');"
							              style="margin: 0; width: 100%;">
							          <input type="hidden" name="roomSeq" value="${room.roomSeq}" />
							          <button type="submit" class="btn btn-sm"
							                  style="background-color: #34699A; color: white; width: 100%;">
							            판매 재개
							          </button>
							        </form>
							      </c:otherwise>
							    </c:choose>
							
							    <form action="/host/room/delete" method="post"
							          onsubmit="return confirm('정말 삭제하시겠습니까?');"
							          style="margin: 0; width: 100%;">
							      <input type="hidden" name="roomSeq" value="${room.roomSeq}" />
							      <button type="submit" class="btn btn-sm"
							              style="background-color: #EA5B6F; color: white; width: 100%;">
							        삭제
							      </button>
							    </form>
							
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