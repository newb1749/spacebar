<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
<head>
    <title>쿠폰 전체 목록</title>
    <style>
        table
		{
            border-collapse: collapse;
            width: 90%;
            margin: 20px auto;
        }
        
        th, td 
        {
            border: 1px solid #aaa;
            padding: 8px 12px;
            text-align: center;
        }
        
        th 
        {
            background-color: #eee;
        }
    </style>
</head>
<body>

<h2 style="text-align:center;">전체 쿠폰 목록</h2>

<table>
    <thead>
        <tr>
            <th>쿠폰번호</th>
            <th>쿠폰명</th>
            <th>설명</th>
            <th>할인율</th>
            <th>할인금액</th>
            <th>최소주문금액</th>
            <th>발급 시작일</th>
            <th>발급 종료일</th>
            <th>쿠폰유형</th>
            <th>상태</th>
            <th>총 발급 가능 수</th>
            <th>등록일</th>
            <th>최종수정일</th>
        </tr>
    </thead>
    <tbody>
    <c:forEach var="coupon" items="${couponList}">
        <tr>
            <td>${coupon.cpnSeq}</td>
            <td>${coupon.cpnName}</td>
            <td>${coupon.cpnDesc}</td>
            <td>
                <c:choose>
                    <c:when test="${coupon.cpnType eq '할인율'}">
                        ${coupon.discountRate}%
                    </c:when>
                    <c:otherwise>-</c:otherwise>
                </c:choose>
            </td>
            <td>
                <c:choose>
                    <c:when test="${coupon.cpnType eq '할인금액'}">
                        ${coupon.discountAmt}원
                    </c:when>
                    <c:otherwise>-</c:otherwise>
                </c:choose>
            </td>
            <td>${coupon.minOrderAmt}원</td>
            <td><fmt:formatDate value="${coupon.issueStartDt}" pattern="yyyy-MM-dd"/></td>
            <td><fmt:formatDate value="${coupon.issueEndDt}" pattern="yyyy-MM-dd"/></td>
            <td>${coupon.cpnType}</td>
            <td>
                <c:choose>
                    <c:when test="${coupon.cpnStat eq 'Y'}">활성</c:when>
                    <c:otherwise>비활성</c:otherwise>
                </c:choose>
            </td>
            <td>${coupon.totalCpnCnt}</td>
            <td><fmt:formatDate value="${coupon.regDt}" pattern="yyyy-MM-dd"/></td>
            <td><fmt:formatDate value="${coupon.updateDt}" pattern="yyyy-MM-dd"/></td>
        </tr>
    </c:forEach>
    </tbody>
</table>

</body>
</html>
