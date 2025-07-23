<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!-- ✅ flatpickr 스타일 및 스크립트 로딩 -->
<link rel="stylesheet" href="https://unpkg.com/flatpickr/dist/flatpickr.min.css">
<script src="https://unpkg.com/flatpickr"></script>
<script src="https://unpkg.com/flatpickr/dist/l10n/ko.js"></script>

<!-- ✅ 주간 날짜 선택용 입력창 -->
<input type="text" id="weekCalendar" placeholder="날짜 선택 (주간 범위 자동 지정)" readonly
       style="width: 220px; padding: 10px; margin-bottom: 10px;">

<!-- ✅ 선택된 주간의 시작/종료일을 저장할 숨은 필드 -->
<input type="hidden" id="weekCalendar_start" name="startDate">
<input type="hidden" id="weekCalendar_end" name="endDate">

<!-- ✅ 통계 카드 UI -->
<div class="stat-cards" style="display:flex; gap:20px;">
  <div class="stat-card">
    <div class="stat-number"><h2 id="totalSales">0</h2></div>
    <div class="stat-label">총 판매 건수</div>
  </div>
  <div class="stat-card">
    <div class="stat-number"><h2 id="totalAmount">0원</h2></div>
    <div class="stat-label">총 판매 금액</div>
  </div>
  <div class="stat-card">
    <div class="stat-number"><h2 id="avgReviewScore">0.0</h2></div>
    <div class="stat-label">평균 리뷰 평점</div>
  </div>
</div>

<!-- ✅ 달력 관련 함수 정의 (main.jsp에서 호출 가능) -->
<script>
  // 주간 범위 계산 함수
  function getWeekRangeFromDate(date) {
    const day = date.getDay(); // 0=일, 1=월 ...
    const monday = new Date(date);
    monday.setDate(date.getDate() - ((day + 6) % 7));
    const sunday = new Date(monday);
    sunday.setDate(monday.getDate() + 6);

    const format = (d) =>
      d.getFullYear() + "-" +
      String(d.getMonth() + 1).padStart(2, '0') + "-" +
      String(d.getDate()).padStart(2, '0');

    return { start: format(monday), end: format(sunday) };
  }

  
  // flatpickr 초기화 함수 → main.jsp에서 호출 가능
  function initWeekCalendar() {
    flatpickr("#weekCalendar", {
      locale: "ko",
      altInput: true,
      altFormat: "Y년 m월 d일 (D)",
      dateFormat: "Y-m-d",
      onChange: function (selectedDates) {
    	  if (selectedDates.length === 1) {
    	    const { start, end } = getWeekRangeFromDate(selectedDates[0]);
    	    document.getElementById("weekCalendar_start").value = start;
    	    document.getElementById("weekCalendar_end").value = end;
    	    console.log("📆 달력 선택 주간:", start, "~", end);
    	    loadStats("week", start + "~" + end); // ✅ 직접 전달
    	  }
    	},
      onReady: function (selectedDates, dateStr, instance) {
        initPeriodClickEvents(instance); // 월/연도 클릭 이벤트 등록
      }
    });

    // ✅ 진입 시 기본값 세팅
    const today = new Date();
    const { start, end } = getWeekRangeFromDate(today);
    document.getElementById("weekCalendar_start").value = start;
    document.getElementById("weekCalendar_end").value = end;
    console.log("✅ 주간 초기 날짜 세팅:", start, "~", end);
  }
  
  

  // 월/연도 선택 시 실행될 이벤트 바인딩
  function initPeriodClickEvents(flatpickrInstance) {
    const calendarContainer = flatpickrInstance.calendarContainer;

    const monthElement = calendarContainer.querySelector('.flatpickr-monthDropdown-months');
    if (monthElement) {
      monthElement.addEventListener('click', () => {
        const selectedMonth = flatpickrInstance.currentMonth + 1;
        const year = flatpickrInstance.currentYear;
        console.log("📅 월간 선택:", year + "-" + selectedMonth);
        fetchStats('month', year, selectedMonth);
      });
    }

    const yearElement = calendarContainer.querySelector('.numInput.cur-year');
    if (yearElement) {
      yearElement.addEventListener('click', () => {
        const year = flatpickrInstance.currentYear;
        console.log("📅 연간 선택:", year);
        fetchStats('year', year);
      });
    }
  }
</script>
