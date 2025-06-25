<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>

  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
  <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
  <script src="https://cdn.jsdelivr.net/npm/flatpickr/dist/l10n/ko.js"></script>

  <style>
    body {
      font-family: 'Segoe UI', sans-serif;
      background-color: #f4f7f6;
      display: flex;
      justify-content: center;
      align-items: flex-start;
      padding-top: 50px;
    }

    #date-picker-input {
      width: 200px;
      padding: 15px;
      font-size: 16px;
      font-weight: 500;
      text-align: center;
      border: 1px solid #ccc;
      border-radius: 8px;
      background-color: #fff;
      cursor: pointer;
      box-shadow: 0 2px 6px rgba(0,0,0,0.1);
    }
  </style>
</head>
<body>

  <!-- 박스 없이 input만 남김 -->
  <input type="text" id="date-picker-input" placeholder="날짜를 선택하세요" readonly>

  <script>
    document.addEventListener('DOMContentLoaded', () => {
      const dateInput = document.getElementById('date-picker-input');

      const formatDateForDisplay = (date) => {
        const options = { month: 'long', day: 'numeric', weekday: 'short' };
        return new Intl.DateTimeFormat('ko-KR', options).format(date);
      };
	
      
      // reservation 테이블에서 예약된 데이터 제외
      const bookedDates = ["2025-07-20", "2025-07-21", "2025-08-01"];
      const today = new Date();
      const tomorrow = new Date();
      tomorrow.setDate(today.getDate() + 1);

      flatpickr(dateInput, {
        mode: "range",
        showMonths: 2,
        disable: bookedDates,
        minDate: "today",
        locale: "ko",
        dateFormat: "Y-m-d",
        defaultDate: [today, tomorrow],

        position: "below",

        onReady: function (selectedDates) {
          if (selectedDates.length === 2) {
            const [start, end] = selectedDates;
            const displayText = `\${formatDateForDisplay(start)} - \${formatDateForDisplay(end)}`;
            dateInput.value = displayText;
          }
        },
        onChange: function (selectedDates) {
          if (selectedDates.length === 2) {
            const [start, end] = selectedDates;
            const displayText = `\${formatDateForDisplay(start)} - \${formatDateForDisplay(end)}`;
            dateInput.value = displayText;
          }
        }
      });
    });
  </script>
</body>
</html>
