<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>

<%
   // GNB 번호 (사용자관리)
   request.setAttribute("_gnbNo", 2);
%>

<!DOCTYPE html>
<html lang="ko">
<head>
  <%@ include file="/WEB-INF/views/include/head.jsp" %>
  <meta charset="UTF-8">
  <title>공지사항 목록</title>
  <style>
  
    	.site-nav .container {
    max-width: none !important; /* 부트스트랩 max-width 제거 */
    width: 1330px;  /* 화면 너비의 80% */
    margin: 0 auto !important;   /* 가운데 정렬 */
    padding: 0 !important;
  }
  
    .section-block {
      padding: 40px 0;
      margin-bottom: 40px;
      border-top: 2px solid #e9ecef;
    }

    .section-heading {
	  font-size: 1.75rem;
	  font-weight: 600;
	  margin: 70px 0 1rem 0; /* 상단 여백 40px 추가 */
	  padding-bottom: .5rem;
	  border-bottom: 3px solid #007bff;
	  display: inline-block;
	}

    .table {
      width: 100%;
      border-collapse: collapse;
      margin-top: 20px;
    }

    .table th, .table td {
      padding: 12px;
      border: 1px solid #dee2e6;
      text-align: center;
    }

    .table thead th {
      background-color: #f1f3f5;
      font-weight: bold;
    }

    .btn-primary {
      display: inline-block;
      margin-top: 20px;
    }
  </style>
</head>
<body>
<%@ include file="/WEB-INF/views/include/navigation.jsp" %>

<div class="container section-block">
  <h2 class="section-heading">공지사항 목록</h2>

  <table class="table">
    <thead>
      <tr>
        <th>번호</th>
        <th>제목</th>
        <th>작성자</th>
        <th>글상태</th>
        <th>등록일</th>
      </tr>
    </thead>
    <tbody>
      <c:forEach var="n" items="${noticeList}">
        <tr>
          <td>${n.noticeSeq}</td>
          <td><a href="/notice/detail?noticeSeq=${n.noticeSeq}">${n.noticeTitle}</a></td>
          <td>${n.adminId}</td>
          <td><fmt:formatDate value="${n.regDt}" pattern="yyyy-MM-dd HH:mm" /></td>
          <td><fmt:formatDate value="${n.updateDt}" pattern="yyyy-MM-dd HH:mm" /></td>
        </tr>
      </c:forEach>
      <c:if test="${empty noticeList}">
        <tr><td colspan="4">등록된 공지사항이 없습니다.</td></tr>
      </c:if>
    </tbody>
  </table>

</div>

<%-- <%@ include file="/WEB-INF/views/include/footer.jsp" %> --%>
<script src="${pageContext.request.contextPath}/resources/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/aos.js"></script>

</body>
</html>
