<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <title>마일리지 충전 내역</title>
    <style>
        body { font-family: Arial, sans-serif; }
        .msg { padding: 10px; margin: 10px 0; border-radius: 5px; }
        .success { background-color: #d4edda; color: #155724; }
        .error { background-color: #f8d7da; color: #721c24; }
        table { border-collapse: collapse; width: 100%; margin-top: 20px; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: center; }
        th { background-color: #f2f2f2; }
    </style>
</head>
<body>

<h2>마일리지 거래 내역</h2>

<c:if test="${not empty code}">
    <div class="msg ${code == '0' ? 'success' : 'error'}">
        <strong><c:out value="${msg}" /></strong>
    </div>
</c:if>

<table>
    <thead>
        <tr>
            <th>거래 일시</th>
            <th>거래 유형</th>
            <th>거래 금액</th>
            <th>거래 후 잔액</th>
        </tr>
    </thead>
    <tbody>
        <c:forEach var="entry" items="${mileageHistoryList}">
            <tr>
                <td><fmt:formatDate value="${entry.trxDt}" pattern="yyyy-MM-dd HH:mm:ss" /></td>
                <td><c:out value="${entry.trxType}" /></td>
                <td><fmt:formatNumber value="${entry.trxAmt}" groupingUsed="true" /> 원</td>
                <td><fmt:formatNumber value="${entry.balanceAfterTrx}" groupingUsed="true" /> 원</td>
            </tr>
        </c:forEach>
        <c:if test="${empty mileageHistoryList}">
            <tr><td colspan="4">내역이 없습니다.</td></tr>
        </c:if>
    </tbody>
</table>

<p>
    <a href="/payment/chargeMileage">마일리지 충전하기</a> |
    <a href="/reservation/list">예약 내역 보기</a>
</p>

</body>
</html>
