/**
 * 룸 캘린더 초기화 함수
 * ES6 모듈 대신 전역 함수로 노출
 */
function initRoomCalendar(calId, options) {
  const dateInput = document.getElementById(calId);
  
  if (!dateInput) {
    console.error(`ID가 '${calId}'인 요소를 찾을 수 없습니다.`);
    return;
  }

  const formatDateForDisplay = (date) => {
    const options = { month: 'long', day: 'numeric', weekday: 'short' };
    return new Intl.DateTimeFormat('ko-KR', options).format(date);
  };

  // 기본 옵션 설정
  const defaultOptions = {
    fetchUrl: '',
    defaultDates: [],
    onChange: null,
    mode: "range",
    showMonths: 2,
    minDate: "today",
    locale: "ko",
    dateFormat: "Y-m-d",
    position: "below"
  };

  // 옵션 병합
  const config = Object.assign({}, defaultOptions, options);

  // 비활성화할 날짜들 (서버에서 가져올 수도 있음)
  let disabledDates = [];
  
  // fetchUrl이 있으면 서버에서 비활성 날짜 가져오기
  if (config.fetchUrl) {
    fetch(config.fetchUrl)
      .then(response => response.json())
      .then(data => {
        disabledDates = data.disabledDates || [];
        initCalendar();
      })
      .catch(error => {
        console.error('날짜 데이터 가져오기 실패:', error);
        initCalendar();
      });
  } else {
    initCalendar();
  }

  function initCalendar() {
    const today = new Date();
    const tomorrow = new Date();
    tomorrow.setDate(today.getDate() + 1);

    const flatpickrConfig = {
      mode: config.mode,
      showMonths: config.showMonths,
      disable: disabledDates,
      minDate: config.minDate,
      locale: config.locale,
      dateFormat: config.dateFormat,
      defaultDate: config.defaultDates.length > 0 ? config.defaultDates : [today, tomorrow],
      position: config.position,
      
      onReady: function (selectedDates) {
        if (selectedDates.length === 2) {
          const [start, end] = selectedDates;
          const displayText = `${formatDateForDisplay(start)} - ${formatDateForDisplay(end)}`;
          dateInput.value = displayText;
        }
      },
      
      onChange: function (selectedDates) {
        if (selectedDates.length === 2) {
          const [start, end] = selectedDates;
          const displayText = `${formatDateForDisplay(start)} - ${formatDateForDisplay(end)}`;
          dateInput.value = displayText;
        }
        
        // 콜백 함수 실행
        if (config.onChange && typeof config.onChange === 'function') {
          config.onChange(selectedDates);
        }
      }
    };

    // Flatpickr 초기화
    const picker = flatpickr(dateInput, flatpickrConfig);
    
    return picker;
  }
}

// 전역으로 노출
window.initRoomCalendar = initRoomCalendar;