<<<<<<< HEAD
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %> 
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html> 
<html lang="ko"> 
<head> 
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>캘린더 테스트</title> 
</head> 
<body> 
  <h2>📅 캘린더 모듈 테스트</h2> 

  <c:set var="calId" value="calendarTest"/> 
  <c:set var="fetchUrl" value=""/> 
  
  <!-- 디버깅용 출력 -->
  <p>calId: ${calId}</p>
  <p>fetchUrl: ${fetchUrl}</p>
  
  <!-- JSP include로 파라미터 전달 -->
  <jsp:include page="/WEB-INF/views/component/calendar.jsp">
    <jsp:param name="calId" value="${calId}" />
    <jsp:param name="fetchUrl" value="${fetchUrl}" />
  </jsp:include>

</body> 
=======
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %> 
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html> 
<html lang="ko"> 
<head> 
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>캘린더 테스트</title> 
</head> 
<body> 
  <h2>📅 캘린더 모듈 테스트</h2> 

  <c:set var="calId" value="calendarTest"/> 
  <c:set var="fetchUrl" value=""/> 
  
  <!-- 디버깅용 출력 -->
  <p>calId: ${calId}</p>
  <p>fetchUrl: ${fetchUrl}</p>
  
  <!-- JSP include로 파라미터 전달 -->
  <jsp:include page="/WEB-INF/views/component/calendar.jsp">
    <jsp:param name="calId" value="${calId}" />
    <jsp:param name="fetchUrl" value="${fetchUrl}" />
  </jsp:include>

</body> 
>>>>>>> feature/cart
</html>