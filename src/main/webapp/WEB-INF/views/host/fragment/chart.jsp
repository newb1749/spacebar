<%-- /WEB-INF/views/host/fragment/chart.jsp --%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!-- 주간 / 월간 선택 버튼 -->
<div class="chart-period-selector" style="margin-bottom: 12px; display: flex; justify-content: center; gap: 10px;">
  <button class="btn-period active" data-period="week" onclick="onChartTypeChange('week')">주간</button>
  <button class="btn-period" data-period="month" onclick="onChartTypeChange('month')">월간</button>
</div>

<!-- 날짜 입력 필드 -->
<div class="chart-inputs" style="display: flex; justify-content: center; align-items: center; gap: 12px; margin-bottom: 20px;">
  <label>시작일:</label>
  <input type="text" id="chartStartDate" value="20240501" style="width: 120px;">
  <label>종료일:</label>
  <input type="text" id="chartEndDate" value="20251231" style="width: 120px;">
  <button onclick="onChartSearch()" style="padding: 6px 12px;">검색</button>
</div>

<canvas id="chartCanvas" width="800" height="400"></canvas>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
let currentChartPeriod = 'week';

function drawChart(period, startDate, endDate) {
  console.log("📊 drawChart 호출됨", period, startDate, endDate);

  $.get("/host/statisticsChart", {
	groupBy: period,
    startDate: startDate,
    endDate: endDate
  }, function (res) {
    console.log("✅ chart 응답", res);

    const labels = res.map(item => item.LABEL);
    const salesCount = res.map(item => item.SALESCOUNT);
    const salesAmount = res.map(item => item.SALESAMOUNT);
    const avgScores = res.map(item => item.AVGRATING);

    let formattedLabels = labels;
    if (period === "week") {
    	formattedLabels = labels.map(function (range) {
    	    // "2025년 14주차"에서 연도와 주차 추출
    	    const parts = range.split("년 ");
    	    const year = parseInt(parts[0]); // 2025
    	    const weekStr = parts[1].replace("주차", ""); // "14"
    	    const weekOfYear = parseInt(weekStr); // 14
    	    
    	    // 해당 연도의 첫 번째 날부터 주차를 계산하여 날짜 구하기
    	    const firstDay = new Date(year, 0, 1); // 1월 1일
    	    const daysToAdd = (weekOfYear - 1) * 7; // 주차에 해당하는 일수
    	    const targetDate = new Date(firstDay.getTime() + daysToAdd * 24 * 60 * 60 * 1000);
    	    
    	    const month = targetDate.getMonth() + 1; // 0부터 시작하므로 +1
    	    const weekOfMonth = Math.ceil(targetDate.getDate() / 7);
    	    
    	    return month + "월 " + weekOfMonth + "주차";
    	});
    }

    const ctx = document.getElementById("chartCanvas").getContext("2d");
    if (window.salesChart) {
      window.salesChart.destroy();
    }

    window.salesChart = new Chart(ctx, {
      type: "bar",
      data: {
        labels: formattedLabels,
        datasets: [
          {
            label: "판매건수",
            data: salesCount,
            backgroundColor: "rgba(54, 162, 235, 0.5)",
            yAxisID: "y1",
            borderWidth: 1,
            type: "bar",
          },
          {
            label: "판매금액",
            data: salesAmount,
            borderColor: "rgba(255, 206, 86, 1)",
            backgroundColor: "rgba(255, 206, 86, 0.2)",
            yAxisID: "y2",
            borderWidth: 2,
            type: "line",
            tension: 0.3,
          },
          {
            label: "평균평점",
            data: avgScores,
            borderColor: "rgba(255, 0, 0, 1)",
            backgroundColor: "rgba(255, 0, 0, 0.2)",
            yAxisID: "y3",
            borderWidth: 2,
            type: "line",
            tension: 0.3,
          },
        ],
      },
      options: {
        responsive: true,
        plugins: {
          tooltip: {
            callbacks: {
              label: function (context) {
                const i = context.datasetIndex;
                const v = context.parsed.y;
                if (i === 1) return "판매금액: " + v.toLocaleString() + "원";
                if (i === 0) return "판매건수: " + v;
                return "평균평점: " + v;
              }
            }
          },
          legend: {
            display: true,
            position: "top"
          }
        },
        scales: {
          y1: {
            type: "linear",
            position: "left",
            title: {
              display: true,
              text: "판매건수"
            },
            beginAtZero: true,
            ticks: {
              precision: 0
            }
          },
          y2: {
            type: "linear",
            position: "right",
            title: {
              display: true,
              text: "판매금액"
            },
            beginAtZero: true,
            grid: {
              drawOnChartArea: false
            },
            ticks: {
              callback: function (value) {
                return value.toLocaleString() + "원";
              }
            }
          },
          y3: {
            type: "linear",
            position: "right",
            title: {
              display: true,
              text: "평균평점"
            },
            beginAtZero: true,
            min: 0,
            max: 5,
            grid: {
              drawOnChartArea: false
            },
            ticks: {
              stepSize: 1
            }
          }
        }
      }
    });
  }).fail(function (err) {
    console.error("❌ 차트 데이터 요청 실패", err);
  });
}

function drawChartAuto(startDate, endDate) {
  const start = new Date(startDate);
  const end = new Date(endDate);
  const diff = (end - start) / (1000 * 60 * 60 * 24);

  let groupBy = 'week';
  if (diff > 31) groupBy = 'month';
  if (diff > 365) groupBy = 'year';

  drawChart(groupBy, startDate, endDate);
}

function onChartSearch() {
  const start = document.getElementById("chartStartDate").value;
  const end = document.getElementById("chartEndDate").value;

  if (!start || !end) {
    alert("시작일과 종료일을 입력하세요.");
    return;
  }

  drawChart(currentChartPeriod, start, end);
}

function onChartTypeChange(type) {
    console.log("🔄 버튼 클릭됨:", type);
    
    currentChartPeriod = type;
    
    // 모든 버튼에서 active 클래스 제거 - 더 구체적인 선택자 사용
    const allButtons = document.querySelectorAll('.chart-period-selector .btn-period');
    allButtons.forEach(function(btn) {
        btn.classList.remove('active');
        console.log("❌ active 제거:", btn.textContent);
    });
    
    // 클릭된 버튼에 active 클래스 추가 - 더 안전한 방식
    const targetButton = document.querySelector('.chart-period-selector .btn-period[data-period="' + type + '"]');
    if (targetButton) {
        targetButton.classList.add('active');
        console.log("✅ active 추가:", targetButton.textContent);
        
        // 강제로 스타일 적용 확인
        console.log("🎨 버튼 클래스:", targetButton.className);
        console.log("🎨 계산된 스타일:", window.getComputedStyle(targetButton).backgroundColor);
    } else {
        console.error("❌ 버튼을 찾을 수 없음:", type);
    }
    
    // DOM 변경 후 약간 지연시켜서 차트 검색
    setTimeout(function() {
        onChartSearch();
    }, 50);
}

// 페이지 로드 완료 시 초기화
document.addEventListener('DOMContentLoaded', function() {
    console.log("📄 차트 페이지 로드 완료");
    
    // 초기 active 버튼 확인
    const activeBtn = document.querySelector('.chart-period-selector .btn-period.active');
    if (activeBtn) {
        console.log("✅ 초기 active 버튼:", activeBtn.textContent);
    }
});

</script>

<style>
/* 기본 버튼 스타일 */
.chart-period-selector .btn-period {
  background-color: #3498db !important;
  color: white !important;
  border: none !important;
  padding: 8px 16px !important;
  font-size: 14px !important;
  border-radius: 6px !important;
  cursor: pointer !important;
  transition: all 0.3s ease !important;
  margin: 0 5px !important;
  outline: none !important;
}

/* 호버 효과 */
.chart-period-selector .btn-period:hover {
  background-color: #2980b9 !important;
  transform: translateY(-1px) !important;
}

/* 활성화된 버튼 스타일 - 가장 높은 우선순위 */
.chart-period-selector .btn-period.active,
.chart-period-selector .btn-period.active:hover,
.chart-period-selector .btn-period.active:focus,
.chart-period-selector .btn-period.active:active {
  background-color: #2c3e50 !important;
  border: 2px solid #34495e !important;
  box-shadow: 0 4px 8px rgba(0,0,0,0.3) !important;
  transform: translateY(-2px) !important;
  font-weight: bold !important;
}
</style>