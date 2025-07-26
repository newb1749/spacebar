<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <%@ include file="/WEB-INF/views/include/head.jsp" %>
  <style>
    body{padding-top:100px;background:#f8f9fa;font-family:'Noto Sans KR',sans-serif;}
    h3{margin-top:120px;color:#343a40;font-weight:700;margin-bottom:30px;text-align:center;}
    .table{background:#fff;box-shadow:0 0 12px rgba(0,0,0,.1);border-radius:8px;width:100%;margin:0 auto 40px;}
    .table th,.table td{vertical-align:middle!important;text-align:center;font-size:1rem;color:#495057;}
    .table th{background:#343a40;color:#fff;font-weight:600;}
    .btn-primary{background:#fe7743;border:none;font-weight:700;font-size:1.1rem;transition:.3s;width:100%;max-width:900px;margin:0 auto;padding:12px;display:block;}
    .btn-primary:hover{background:#e96328;}
    .container{max-width:1333px;width:90%;margin:0 auto;}
    .row-coupon{width:100%;font-size:.9rem;}
    .origin-price{display:none;text-decoration:line-through;color:#bbb;font-size:.85rem;}
  </style>
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  <script>
    $(function(){
      var sessionUserId = '<%= session.getAttribute("SESSION_USER_ID") != null ? session.getAttribute("SESSION_USER_ID") : "" %>';
      if(!sessionUserId){
        alert("로그인이 필요합니다.");
        location.href='${pageContext.request.contextPath}/index.jsp';
      }
    });
  </script>
</head>
<body>
<%@ include file="/WEB-INF/views/include/navigation.jsp" %>

<div class="container">
  <form id="paymentForm" action="${pageContext.request.contextPath}/cart/checkout" method="post">
    <h3>예약 내용 확인</h3> 

    <table class="table table-bordered" id="orderTable">
      <tr>
        <th style="width:300px">쿠폰</th>
        <th>객실 타입</th>
        <th>체크인</th>
        <th>체크아웃</th>
        <th>인원 수</th>
        <th>금액</th>
      </tr>

      <c:forEach var="r" items="${reservations}" varStatus="st">
        <fmt:parseDate var="inDate"  value="${r.rsvCheckInDt}"  pattern="yyyyMMdd" />
        <fmt:parseDate var="outDate" value="${r.rsvCheckOutDt}" pattern="yyyyMMdd" />
        <fmt:parseDate var="inTime"  value="${r.rsvCheckInTime}"  pattern="HHmm" />
        <fmt:parseDate var="outTime" value="${r.rsvCheckOutTime}" pattern="HHmm" />

        <tr data-idx="${st.index}">
          <td>
            <select name="itemCouponSeq" class="row-coupon form-select">
              <option value="">-- 사용 안 함 --</option>
              <c:forEach var="coupon" items="${couponList}">
                <c:set var="type"  value="${coupon.discountRate > 0 ? 'rate' : 'amount'}" />
                <c:set var="value" value="${coupon.discountRate > 0 ? coupon.discountRate : coupon.discountAmt}" />
                <option value="${coupon.cpnSeq}" data-type="${type}" data-discount="${value}">
                  ${coupon.cpnName} - ${coupon.cpnDesc}
                </option>
              </c:forEach>
            </select>
          </td>

          <td>${r.roomTypeTitle}</td>
          <td><fmt:formatDate value="${inDate}" pattern="yyyy-MM-dd" /> / <fmt:formatDate value="${inTime}" pattern="HH:mm" /></td>
          <td><fmt:formatDate value="${outDate}" pattern="yyyy-MM-dd" /> / <fmt:formatDate value="${outTime}" pattern="HH:mm" /></td>
          <td>${r.numGuests}명</td>

          <td>
            <span class="origin-price" id="origin_${st.index}">
              <fmt:formatNumber value="${r.finalAmt}" type="number"/>원
            </span>
            <strong>
              <span class="row-amt" id="amt_${st.index}" data-origin="${r.finalAmt}">
                <fmt:formatNumber value="${r.finalAmt}" type="number"/>원
              </span>
            </strong>

            <input type="hidden" name="itemFinalAmt" id="itemFinalAmt_${st.index}" value="${r.finalAmt}">
            <input type="hidden" name="useCouponYn"  id="useCouponYn_${st.index}"  value="N">
            <input type="hidden" name="cartSeqs"     value="${cartSeqs[st.index]}">
          </td>
        </tr>
      </c:forEach>

      <tr>
        <th colspan="5" class="text-right">총 결제 금액</th>
        <td><strong><span id="discountedAmt"><fmt:formatNumber value="${totalAmt}" type="number"/>원</span></strong></td>
      </tr>
      <tr>
        <th colspan="5" class="text-right">보유 마일리지</th>
        <td><strong><fmt:formatNumber value="${userMileage}" type="number"/>원</strong></td>
      </tr>
    </table>

    <input type="hidden" id="finalAmt" name="finalAmt" value="${totalAmt}">
    <input type="hidden" id="usedCouponSeqs" name="usedCouponSeqs">

    <button type="button" class="btn btn-primary" onclick="confirmPayment()">결제하기</button>
  </form>
</div>

<%@ include file="/WEB-INF/views/include/footer.jsp" %>
<script src="${pageContext.request.contextPath}/resources/js/bootstrap.bundle.min.js"></script>
<script>
$(function () {
  const $table     = $("#orderTable");
  const $rowCoupon = $table.find(".row-coupon");

  // 쿠폰 선택시
  $rowCoupon.on("change", function(){
    limitDuplicateCoupons();
    recalcAll();
  });

  // 처음 1회 계산
  limitDuplicateCoupons();
  recalcAll();

  function limitDuplicateCoupons(){
    const used = new Set();
    $rowCoupon.each(function(){
      const v = $(this).val();
      if(v) used.add(v);
    });

    $rowCoupon.each(function(){
      const cur = $(this).val();
      $(this).find("option").each(function(){
        const v = $(this).val();
        if(!v) return; // 빈값(-- 사용 안 함 --)
        $(this).prop("disabled", used.has(v) && v !== cur);
      });
    });
  }

  function recalcAll(){
    let total = 0;
    const usedSeqs = [];

    $table.find("tr[data-idx]").each(function(){
      const idx    = $(this).data("idx");
      const $amt   = $("#amt_" + idx);
      const origin = Number($amt.data("origin")); // 원금액 number
      let   final  = origin;

      const $sel   = $(this).find(".row-coupon");
      const seq    = $sel.val();

      if(seq){
        const type     = $sel.find("option:selected").data("type");
        const discount = Number($sel.find("option:selected").data("discount")) || 0;

        if(type === "rate"){
          final = origin - Math.floor(origin * discount / 100);
        }else{
          final = Math.max(0, origin - discount);
        }

        $("#useCouponYn_"+idx).val("Y");
        $("#origin_"+idx).show();
        usedSeqs.push(seq);
      }else{
        $("#useCouponYn_"+idx).val("N");
        $("#origin_"+idx).hide();
      }

      $amt.text(final.toLocaleString('ko-KR') + "원");
      $("#itemFinalAmt_"+idx).val(final);
      total += final;
    });

    $("#discountedAmt").text(total.toLocaleString('ko-KR') + "원");
    $("#finalAmt").val(total);
    $("#usedCouponSeqs").val(usedSeqs.join(","));
  }

  window.confirmPayment = function(){
    const finalAmt = Number($("#finalAmt").val()) || 0;
    const mileage  = Number("${userMileage}") || 0;

    if(mileage < finalAmt){
      if(confirm("보유 마일리지가 부족합니다. 마일리지를 충전하시겠습니까?")){
        location.href = "${pageContext.request.contextPath}/reservation/chargeMileage";
      }
      return;
    }
    $("#paymentForm")[0].submit();
  }
});
</script>
</body>
</html>
