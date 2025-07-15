<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/head.jsp" %>

<style>
    /* 네비게이션 높이만큼 본문 전체를 아래로 밀기 */
    body {
      padding-top: 120px; /* ← 네비게이션 높이만큼 설정 (네비 높이 + 상하 패딩 합산) */
    }
  </style>

<script type="text/javascript">
$(document).ready(function() {
	
	$("#freeBoardTitle").focus();
	
	$("#btnList").on("click", function(){
		document.bbsForm.action = "/board/list";
		document.bbsForm.submit();
	});
	
	$("#btnUpdate").on("click", function(){
		$("#btnUpdate").prop("disabled", true);			// 버튼 비활성화
		
		if($.trim($("#freeBoardTitle").val()).length <= 0)
		{
			alert("제목을 입력하세요.");
			$("#freeBoardTitle").val("");
			$("#freeBoardTitle").focus();
			$("#btnUpdate").prop("disabled", false);	// 버튼 활성화
			return;
		}
		
		if($.trim($("#freeBoardContent").val()).length <= 0)
		{
			alert("내용을 입력하세요.");
			$("#freeBoardContent").val("");
			$("#freeBoardContent").focus();
			$("#btnUpdate").prop("disabled", false);	// 버튼 활성화
			return;
		}
		
		var form = $("#updateForm")[0];
		var formData = new FormData(form);
		
		$.ajax({
			type:"POST",
			enctype:"multipart/form-data",
			url:"/board/updateProc",
			data:formData,
			processData:false,
			contentType:false,
			cache:false,
			beforeSend:function(xhr)
			{
				xhr.setRequestHeader("AJAX", "true");
			},
			success:function(response)
			{
				if(response.code == 0)
				{
					alert("게시물이 수정되었습니다.");
					location.href = "/board/list";
					
					// 기존 검색조건과 페이지 번호 갖고 이동
					document.bbsForm.action = "/board/list";
					document.bbsForm.submit();
				}
				else if(response.code == 400)
				{
					alert("파라미터 값이 올바르지 않습니다.");
					$("#btnUpdate").prop("disabled", false);	// 버튼 활성화
				}
				else if(response.code == 403)
				{
					alert("본인 게시물이 아닙니다.");
					$("#btnUpdate").prop("disabled", false);	// 버튼 활성화
				}
				else if(response.code == 400)
				{
					alert("게시물을 찾을 수 없습니다.");
					location.href = "/board/list";
				}
				else
				{
					alert("게시물 수정 중 오류 발생하였습니다.");
					$("#btnUpdate").prop("disabled", false);	// 버튼 활성화
				}
			},
			error:function(error)
			{
				icia.common.error(error);
				alert("게시물 수정 중 오류가 발생하였습니다.");
				$("#btnUpdate").prop("disabled", false);	// 버튼 활성화				
			},
		});
	});
});
</script>
</head>
<body>

<%@ include file="/WEB-INF/views/include/navigation.jsp" %>
<div class="container">
   <h2>게시물 수정</h2>
   <form name="updateForm" id="updateForm" method="post" enctype="multipart/form-data">
      <input type="text" name="userName" id="userName" maxlength="20" value="${freeBoard.userName}" style="ime-mode:active;" class="form-control mt-4 mb-2" placeholder="이름을 입력해주세요." readonly />
      <input type="text" name="userEmail" id="userEmail" maxlength="30" value="${freeBoard.userEmail}"  style="ime-mode:inactive;" class="form-control mb-2" placeholder="이메일을 입력해주세요." readonly />
      <input type="text" name="freeBoardTitle" id="freeBoardTitle" maxlength="100" style="ime-mode:active;" value="${freeBoard.freeBoardTitle}" class="form-control mb-2" placeholder="제목을 입력해주세요." required />
      <div class="form-group">
         <textarea class="form-control" rows="10" name="freeBoardContent" id="freeBoardContent" style="ime-mode:active;" placeholder="내용을 입력해주세요" required>${freeBoard.freeBoardContent}</textarea>
      </div>
    
      <input type="hidden" name="freeBoardSeq" value="${freeBoard.freeBoardSeq}" />
      <input type="hidden" name="searchType" value="${searchType}" />
      <input type="hidden" name="searchValue" value="${searchValue}" />
      <input type="hidden" name="curPage" value="${curPage}" />
   </form>
   
   <div class="form-group row">
      <div class="col-sm-12">
         <button type="button" id="btnUpdate" class="btn btn-primary" title="수정">수정</button>
         <button type="button" id="btnList" class="btn btn-secondary" title="리스트">리스트</button>
      </div>
   </div>
</div>

<form name="bbsForm" id="bbsForm" method="post">
	<input type="hidden" name="freeBoardSeq" value="${freeBoard.freeBoardSeq}" />
	<input type="hidden" name="searchType" value="${searchType}" />
	<input type="hidden" name="searchValue" value="${SearchValue}" />
	<input type="hidden" name="curPage" value="${curPage}" />
</form>

</body>
</html>