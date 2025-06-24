<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>지도 테스트 페이지</title>
</head>
<body>

    <h1>숙소 위치</h1>
    
    <%-- 
        이곳에서 실험용 데이터를 설정합니다.
        실제 프로젝트에서는 서블릿(Controller)에서 DB 데이터를 조회한 후
        request.setAttribute()로 넘겨받은 값을 사용하게 됩니다.
    --%>
    <%
        String address = "서울특별시 종로구 율곡로 99";
        String roomName = "카카오 스페이스닷원";
    %>

    <%-- mapModule.jsp 호출 --%>
    <%-- jsp:param을 사용해서 설정한 데이터들을 파라미터로 전달 --%>
    <jsp:include page="/WEB-INF/views/component/mapModule.jsp">
        <jsp:param name="address" value="<%= address %>"/>
        <jsp:param name="roomName" value="<%= roomName %>"/>
    </jsp:include>
    
    <hr>
    
    <p>지도 아래에 다른 컨텐츠가 올 수 있습니다.</p>

</body>
</html>