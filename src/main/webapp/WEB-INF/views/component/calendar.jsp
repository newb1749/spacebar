<<<<<<< HEAD
<!-- /WEB-INF/views/component/calendar.jsp -->
<link rel="stylesheet" href="https://unpkg.com/flatpickr/dist/flatpickr.min.css">
<script src="https://unpkg.com/flatpickr"></script>
<script src="https://unpkg.com/flatpickr/dist/l10n/ko.js"></script>

<!-- 달력 입력창 -->
<input type="text" id="${param.calId}" placeholder="날짜 선택" readonly style="width: 220px; padding: 10px;">


<!-- 숨겨진 날짜 input -->
<input type="hidden" id="${param.calId}_start" name="startDate" />
<input type="hidden" id="${param.calId}_end" name="endDate" />

<!-- roomCalendar.js -->
<script src="/resources/js/roomCalendar.js"></script>

<!-- 캘린더 초기화용 변수 -->
<script>
  var calendarId = "${param.calId}";
  var fetchUrl = "${param.fetchUrl}";
  
  function parseYYYYMMDD(str) {
	    if (!str || str.length !== 8) return null;
	    return new Date(str.substring(0, 4), str.substring(4, 6) - 1, str.substring(6, 8));
	  }

	  var defaultStart = parseYYYYMMDD("${param.startDate}");
	  var defaultEnd = parseYYYYMMDD("${param.endDate}");

	  var defaultDates = (defaultStart && defaultEnd) ? [defaultStart, defaultEnd] : [];
</script>

<!-- DOM 준비 후 실행 -->
<script>
document.addEventListener('DOMContentLoaded', function () {
  console.log('Calendar ID:', calendarId);
  console.log('Fetch URL:', fetchUrl);

  if (!calendarId) {
    console.error('calId가 설정되지 않았습니다.');
    return;
  }

  // 1️⃣ 캘린더 초기화
  initRoomCalendar(calendarId, {
  fetchUrl: fetchUrl,
  defaultDates: defaultDates,
  altInput: true,
  altFormat: "Y년 m월 d일 (D)", // 사용자용 보기용 날짜 포맷
  onChange: (dates) => console.log("선택된 날짜:", dates)
});

  // 2️⃣ hidden input을 form 내부로 강제 이동
  const startInput = document.getElementById(calendarId + '_start');
  const endInput = document.getElementById(calendarId + '_end');
  const form = document.getElementById("roomForm");

  if (form) {
    if (startInput && !form.contains(startInput)) {
      form.appendChild(startInput);
    }
    if (endInput && !form.contains(endInput)) {
      form.appendChild(endInput);
    }
  } else {
    console.warn("roomForm이 아직 존재하지 않음. hidden input 이동 실패");
  }
});
</script>
=======
<!-- /WEB-INF/views/component/calendar.jsp -->
<!-- UNPKG CDN 사용 (CORS 문제가 적음) -->
<link rel="stylesheet" href="https://unpkg.com/flatpickr/dist/flatpickr.min.css">
<script src="https://unpkg.com/flatpickr"></script>
<script src="https://unpkg.com/flatpickr/dist/l10n/ko.js"></script>

<!-- 달력 입력창 -->
<input type="text" id="${param.calId}" placeholder="날짜 선택" readonly style="width: 220px; padding: 10px;">

<!-- roomCalendar.js를 일반 스크립트로 로드 -->
<script src="/resources/js/roomCalendar.js"></script>

<!-- JSP 파라미터를 JavaScript 변수로 먼저 선언 -->
<!-- - calId: 달력 input 요소의 고유 ID (예: "searchCalendar", "detailCalendar")
     - fetchUrl: 예약 불가능한 날짜를 가져올 API URL 
                (빈 문자열("")이면 서버 호출 없이 기본 달력만 표시)
                
                 -->
<script>
  var calendarId = "${param.calId}";	// 달력 ID
  var fetchUrl = "${param.fetchUrl}";	// 예약 데이터 조회 URL(나중에)
</script>

<script> 
  // DOM이 로드된 후 실행
  document.addEventListener('DOMContentLoaded', function() {
    console.log('Calendar ID:', calendarId);
    console.log('Fetch URL:', fetchUrl);
    
    if (!calendarId) {
      console.error('calId가 설정되지 않았습니다.');
      return;
    }
    
    // 전역 함수로 호출
    initRoomCalendar(calendarId, { 
      fetchUrl: fetchUrl, 	// 서버 데이터 조회 URL
      defaultDates: [], 	// 기본 선택 날짜 (빈 배열이면 오늘~내일 자동 설정)
      onChange: (dates) => console.log("선택된 날짜:", dates) 
    }); 
  });
</script>
>>>>>>> feature/cart
