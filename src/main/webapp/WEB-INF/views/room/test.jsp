<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>지도 테스트 페이지</title>
</head>
<body>

  <h1>숙소 위치</h1>

  <%
    String address = "서울특별시 종로구 율곡로 99";
    String roomName = "카카오 스페이스닷원";
  %>

  <jsp:include page="/WEB-INF/views/component/mapModule.jsp">
    <jsp:param name="address" value="<%= address %>"/>
    <jsp:param name="roomName" value="<%= roomName %>"/>
  </jsp:include>
<p>
  📌 주소: ${room.roomAddr} <br/>
</p>


  <hr>
  <p>지도 아래에 다른 컨텐츠가 올 수 있습니다.</p>

</body>
</html>
