<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
<style>
    /* 네비게이션 높이만큼 본문 전체를 아래로 밀기 */
    body {
      padding-top: 120px; /* ← 네비게이션 높이만큼 설정 (네비 높이 + 상하 패딩 합산) */
    }
  </style>

<%@ include file="/WEB-INF/views/include/head.jsp" %>
<script type="text/javascript">
$(document).ready(function() {
	$("#qnaTitle").focus();
	
	$("#btnList").on("click", function(){
		document.bbsForm.action = "/qna/list";
		document.bbsForm.submit();
	});
	
	$("#btnWrite").on("click", function(){
		$("#btnWrite").prop("disabled", true);		// 버튼 비활성화
		
		if($.trim($("#qnaTitle").val()).length <= 0)
		{
			alert("제목을 입력하세요.");
			$("#qnaTitle").val("");
			$("#qnaTitle").focus();
			
			$("#btnWrite").prop("disabled", false);		// 버튼 활성화
			return;
		}
		
		if($.trim($("#qnaContent").val()).length <= 0)
		{
			alert("내용을 입력하세요.");
			$("#qnaContent").val("");
			$("#qnaContent").focus();
			
			$("#btnWrite").prop("disabled", false);		// 버튼 활성화
			return;
		}
		
		var form = $("#writeForm")[0];
		var formData = new FormData(form);		// 자바스크립트에서 폼 데이터를 다루는 객체
		
		$.ajax({
			type:"POST",
			enctype:"multipart/form-data",
			url:"/qna/writeProc",
			data:formData,
			processData:false,		// formData를 string으로 변환하지 않음.
			contentType:false,		// content-type 헤더가 multipart/form-data로 전송
			cache:false,
			timeout:600000,
			beforeSend:function(xhr)
			{
				xhr.setRequestHeader("AJAX", "true");
			},
			success:function(response)
			{
				if(response.code == 0)
				{
					alert("QnA가 등록되었습니다.");
					location.href = "/qna/list";
				}
				else if(response.code == 400)
				{
					alert("파라미터 값이 올바르지 않습니다.");
					$("#btnWrite").prop("disalbed", false);
					$("#qnaTitle").focus();
				}
				else
				{
					alert("게시물 등록 중 오류가 발생하였습니다.");
					$("#btnWrite").prop("disalbed", false);
					$("#btnWrite").focus();
					
				}
				
			},
			error:function(error)
			{
				icia.common.error(error);
				alert("QnA 등록 중 오류가 발생하였습니다.");
			}
			
		});
	});
});
</script>

</head>
<body>
<%@ include file="/WEB-INF/views/include/navigation.jsp" %>
<div class="container">
   <h2>QnA 작성</h2>
   <form name="writeForm" id="writeForm" method="post" enctype="multipart/form-data">
      <input type="text" name="userName" id="userName" maxlength="20" value="${user.userName}" style="ime-mode:active;" class="form-control mt-4 mb-2" placeholder="이름을 입력해주세요." readonly />
      <input type="text" name="userEmail" id="userEmail" maxlength="30" value="${user.email}" style="ime-mode:inactive;" class="form-control mb-2" placeholder="이메일을 입력해주세요." readonly />
      <input type="text" name="qnaTitle" id="qnaTitle" maxlength="100" style="ime-mode:active;" class="form-control mb-2" placeholder="제목을 입력해주세요." required />
      <input type="hidden" name="userId" id="userId" value="${user.userId}"/>
      <div class="form-group">
         <textarea class="form-control" rows="10" name="qnaContent" id="qnaContent" style="ime-mode:active;" placeholder="내용을 입력해주세요" required></textarea>
      </div>
      <div class="form-group row">
         <div class="col-sm-12">
            <button type="button" id="btnWrite" class="btn btn-primary" title="저장">저장</button>
            <button type="button" id="btnList" class="btn btn-secondary" title="리스트">리스트</button>
         </div>
      </div>
   </form>
	
	<form name="bbsForm" id="bbsForm" method="post">
		<input type="hidden" name="searchValue" id="searchValue" value="${searchValue}" />
		<input type="hidden" name="curPage" id="curPage" value="${curPage}" />
	</form>
	
</div>
</body>
</html>