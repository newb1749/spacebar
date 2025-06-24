<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>



<!DOCTYPE html>
<html>
<head>

<!-- jQuery -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>

<meta charset="UTF-8">
<script type="text/javascript">
$(document).ready(function(){
	$("#btnSearch").on("click",function(){
		document.roomForm.roomSeq.value = "";
		document.roomForm.searchValue.value = $("#_searchValue").val();
		document.roomForm.curPage.value = "1";
		document.roomForm.action = "/room/list";
		document.roomForm.submit();
	});
});

function fn_list(curPage)
{
	document.roomForm.roomSeq.value = "";
	document.roomForm.curPage.value = curPage;
	document.roomForm.action = "/room/list";
	document.roomForm.submit();
}

</script>

<title>방 리스트</title>
<style>
  body {
    font-family: 'Arial', sans-serif;
    margin: 20px;
    background-color: #f4f4f4;
  }
  .search-box {
    margin-bottom: 20px;
  }
  .room-container {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
    gap: 20px;
  }
  .room-card {
    background: white;
    border-radius: 10px;
    box-shadow: 0 2px 6px rgba(0,0,0,0.1);
    overflow: hidden;
    transition: 0.2s;
  }
  .room-card:hover {
    transform: translateY(-5px);
  }
  .room-image {
    width: 100%;
    height: 180px;
    object-fit: cover;
  }
  .room-info {
    padding: 15px;
  }
  .room-title {
    font-size: 1.2rem;
    font-weight: bold;
    margin-bottom: 8px;
  }
  .room-price {
    color: #2c7be5;
    font-size: 1rem;
    margin-bottom: 5px;
  }
  .room-location {
    font-size: 0.9rem;
    color: #666;
  }
  .pagination {
    text-align: center;
    margin-top: 30px;
  }
</style>
</head>
<body>

<h2>방 리스트</h2>

<!-- 검색창 -->
<div class="ml-auto input-group" style="width:50%;">
         
         <input type="text" name="_searchValue" id="_searchValue" value="${searchValue}" class="form-control mx-1" maxlength="20" style="width:auto;ime-mode:active;" placeholder="검색값을 입력하세요." />
         <button type="button" id="btnSearch" class="btn btn-secondary mb-3 mx-1">검색</button>
      </div> 
    

<!-- 리스트 -->
<div class="room-container">
  <c:forEach var="room" items="${list}">
    <div class="room-card">
      <img class="room-image" src="" alt="${room.roomTitle}" />
      <div class="room-info">
        <div class="room-title">${room.roomTitle}</div>
        <div class="room-price">
          <fmt:formatNumber value="" type="currency" currencySymbol="₩" />
        </div>
        <div class="room-location">${room.roomAddr}</div>
      </div>
    </div>
  </c:forEach>
</div>

<!-- 페이지네이션 -->
<nav>
      <ul class="pagination justify-content-center">
<c:if test="${!empty paging}">
	<c:if test="${paging.prevBlockPage gt 0}">
         <li class="page-item"><a class="page-link" href="javascript:void(0)" onclick="fn_list(${paging.prevBlockPage})">이전블럭</a></li>
     </c:if>    
	<c:forEach var="i" begin="${paging.startPage}" end="${paging.endPage}">
		<c:choose>
			<c:when test="${i ne curPage}">
        	 <li class="page-item"><a class="page-link" href="javascript:void(0)" onclick="fn_list(${i})">${i}</a></li>
        	</c:when>
        	<c:otherwise> 
        	 <li class="page-item active"><a class="page-link" href="javascript:void(0)" style="cursor:default;">${i}</a></li>
        	</c:otherwise>
         </c:choose>
    </c:forEach>
   
   <c:if test="${paging.nextBlockPage gt 0}"> 
         <li class="page-item"><a class="page-link" href="javascript:void(0)" onclick="fn_list(${paging.nextBlockPage})">다음블럭</a></li>
   </c:if>
</c:if>
      </ul>
   </nav>
   
 	 <form name="roomForm" id="roomForm" method="post">
		<input type="hidden" name="roomSeq" value="${roomSeq}" />
		<input type="hidden" name="searchValue" value="${searchValue}" />
		<input type="hidden" name="curPage"  value="${curPage}" />
	</form>
   

</body>
</html>
