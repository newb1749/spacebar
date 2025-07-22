<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <%@ include file="/WEB-INF/views/include/head.jsp" %>
  <style>
    .deleted-title {
      color: gray;
      font-style: italic;
    }

    body {
      padding-top: 120px; /* 네비게이션 높이만큼 설정 */
    }

    /* 탭바 스타일 */
    .nav-tabs .nav-link {
      color: #555;
      font-weight: 500;
    }
    .nav-tabs .nav-link.active {
      color: #007bff;
      border-color: #007bff #007bff transparent;
    }

    /* FAQ 질문/답변 스타일 */
    .faq-question {
      cursor: pointer;
      padding: .75rem 1rem;
      background: #f1f1f1;
      margin-bottom: 2px;
      border-radius: 4px;
    }
    .faq-answer {
      display: none;
      padding: .75rem 1rem;
      border-left: 3px solid #007bff;
      margin-bottom: 1rem;
      background: #fafafa;
    }
  </style>
  <script type="text/javascript">
    $(function(){
      $('.faq-question').on('click', function(){
        $(this).next('.faq-answer').slideToggle(200);
      });
    });
  </script>
</head>
<body>
  <%@ include file="/WEB-INF/views/include/navigation.jsp" %>

  <!-- 탭 내비게이션 -->
  <div class="container mb-4">
    <ul class="nav nav-tabs">
      <li class="nav-item">
        <a class="nav-link ${boardType=='free' ? 'active' : ''}"
           href="${pageContext.request.contextPath}/board/list">
          자유게시판
        </a>
      </li>
      <li class="nav-item">
        <a class="nav-link ${boardType=='qna' ? 'active' : ''}"
           href="${pageContext.request.contextPath}/qna/list">
          Q&amp;A 게시판
        </a>
      </li>
      <li class="nav-item">
        <a class="nav-link ${boardType=='faq' ? 'active' : ''}"
           href="${pageContext.request.contextPath}/board/faq">
          자주 묻는 질문
        </a>
      </li>
    </ul>
  </div>

  <!-- FAQ 컨텐츠 -->
  <div class="container my-4">
    <h2 class="mb-3">자주 묻는 질문 (FAQ)</h2>
    <br>
    
  <div class="faq-question">0. 다음 회차 로또당첨 번호가 어떻게 되나요?</div>
  <div class="faq-answer">8,10,14,20,33,41</div>

  <div class="faq-question">1. 예약은 어떻게 하나요?</div>
  <div class="faq-answer">사이트에서 원하는 공간을 선택한 후, 날짜와 인원 수를 입력하고 결제하면 즉시 예약이 완료됩니다.</div>

  <div class="faq-question">2. 결제 수단에는 어떤 것이 있나요?</div>
  <div class="faq-answer">카카오페이 지원합니다.</div>

  <div class="faq-question">3. 예약 취소 및 환불 정책은 어떻게 되나요?</div>
  <div class="faq-answer">예약 7일 전까지 전액 환불, 3일 전까지 50% 환불, 3일 이내 취소 시 환불 불가합니다.</div>

  <div class="faq-question">4. 예약 변경은 어디서 하나요?</div>
  <div class="faq-answer">마이페이지 > 예약 내역에서 직접 변경 요청하거나, 고객센터로 문의하시면 안내해 드립니다.</div>

  <div class="faq-question">5. 보증금이나 추가 요금이 있나요?</div>
  <div class="faq-answer">일부 공간은 보증금 또는 청소비가 별도 부과될 수 있으며, 상세 페이지에서 확인 가능합니다.</div>

  <div class="faq-question">6. 최소/최대 인원 제한이 있나요?</div>
  <div class="faq-answer">공간별로 최소·최대 인원 범위가 정해져 있으니, 예약 전에 반드시 확인해 주세요.</div>

  <div class="faq-question">7. 퇴실 절차는 어떻게 되나요?</div>
  <div class="faq-answer">퇴실 전 사용하신 집기·시설을 원위치에 두고, 고객센터에 퇴실 완료 메시지를 남겨주시면 됩니다.</div>

  <div class="faq-question">8. 주차장이 제공되나요?</div>
  <div class="faq-answer">대부분의 공간에 1대 무료 주차가 가능하며, 추가 주차는 유료일 수 있습니다.</div>

  <div class="faq-question">9. 애완동물 동반이 가능한가요?</div>
  <div class="faq-answer">일부 공간만 허용되며, 가능 여부와 추가 요금은 상세 페이지에서 확인해 주세요.</div>

  <div class="faq-question">10. 흡연이 가능한가요?</div>
  <div class="faq-answer">모든 공간은 금연을 원칙으로 하며, 지정된 흡연 구역이 없으면 외부에서만 흡연 가능합니다.</div>

  <div class="faq-question">11. 시설 및 청소 상태는 어떻게 확인하나요?</div>
  <div class="faq-answer">상세 페이지의 ‘시설 정보’와 ‘청소 안내’ 탭에서 확인 가능하며, 문의 사항은 고객센터로 연락주세요.</div>

  <div class="faq-question">12. 장애인 편의시설이 있나요?</div>
  <div class="faq-answer">일부 공간에 경사로·엘리베이터·장애인 화장실이 구비되어 있으니, 사전 문의를 추천드립니다.</div>

  <div class="faq-question">13. 신분증 확인이 필요한가요?</div>
  <div class="faq-answer">투명한 예약 관리를 위해 체크인 시 신분증 확인을 요청할 수 있습니다.</div>

  <div class="faq-question">14. 단체(10인 이상) 예약 시 할인 혜택이 있나요?</div>
  <div class="faq-answer">단체 예약 시 별도 할인율이 적용되니, 고객센터에 문의해 주세요.</div>

  <div class="faq-question">15. 최대 예약 가능 기간은 얼마인가요?</div>
  <div class="faq-answer">공간마다 다르지만, 일반적으로 최대 30일까지 예약 가능합니다.</div>
  </div>
  
  

  <%@ include file="/WEB-INF/views/include/footer.jsp" %>
</body>
</html>
