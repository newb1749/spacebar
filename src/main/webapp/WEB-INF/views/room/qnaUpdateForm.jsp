<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html lang="ko">
  <title>${room.roomTitle}</title>
<head>
<%@ include file="/WEB-INF/views/include/head.jsp" %>
<script type="text/javascript">
$(document).ready(function(){
	$("#roomQnaTitle").focus();
	
	$("#btnQnaUpdate").on("click",function(){
		$("#btnQnaUpdate").prop("disabled", true);
		
		if($.trim($("#roomQnaTitle").val()).length <= 0)
		{
			alert("제목을 입력하세요.");
			$("#roomQnaTitle").val("");
			$("#roomQnaTitle").focus();
			$("#btnQnaUpdate").prop("disabled", false);
			return;
		}
		
		if($.trim($("#roomQnaContent").val()).length <= 0)
		{
			alert("내용을 입력하세요.");
			$("#roomQnaContent").val("");
			$("#roomQnaContent").focus();
			$("#btnQnaUpdate").prop("disabled", false);
			return;
		}
		
		var form = $("#qnaUpdateForm")[0];
		var formData = new FormData(form);
		
		$.ajax({
			type:"POST",
			url:"/room/qnaUpdateProc",
			enctype:"multipart/form-data",
			data:formData,
			processData:false,
			contentType:false,
			cache:false,
			timeout:600000,
			dataType:"JSON",
			beforeSend:function(xhr)
			{
				xhr.setRequestHeader("AJAX","true");
			},
			success:function(res)
			{
				if(res.code == 0)
				{
					alert("Q&A가 수정되었습니다.");
					//location.href = "/room/roomDetail?roomSeq=" + $("input[name=roomSeq]").val();
					if (window.parent && window.parent.document) {
						const roomSeq = $("input[name=roomSeq]").val();
						const iframe = window.parent.document.getElementById("qnaIframe");
						iframe.src = "/room/qnaList?roomSeq=" + roomSeq;
					}
				}
				else if(res.code == 400)
				{
					alert("파라미터 값이 올바르지 않습니다.");
					$("#btnQnaUpdate").prop("disabled", false);
					$("#roomQnaTitle").focus();
				}
				else
				{
					alert("Q&A 수정 중 오류가 발생하였습니다.");
					$("#btnQnaUpdate").prop("disabled", false);
					$("#roomQnaTitle").focus();
				}
			},
			error:function(error)
			{
				icia.common.error(error);
				alert("Q&A 수정 중 알 수 없는 오류가 발생하였습니다.");
				$("#btnQnaUpdate").prop("disabled", false);
			}
		});
	});
	
	$("#btnQnaDelete").on("click",function(){
		alert("Q&A를 삭제하시겠습니까?");
		
		var form = $("#qnaUpdateForm")[0];
		var formData = new FormData(form);
		
		$.ajax({
			type:"POST",
			url:"/room/qnaDeleteProc",
			enctype:"multipart/form-data",
			data:formData,
			processData:false,
			contentType:false,
			cache:false,
			timeout:600000,
			dataType:"JSON",
			beforeSend:function(xhr)
			{
				xhr.setRequestHeader("AJAX","true");
			},
			success:function(res)
			{
				if(res.code == 0)
				{
					alert("Q&A 삭제가 완료되었습니다.");
					location.href = "/room/roomDetail?roomSeq=" + $("input[name=roomSeq]").val();
				}
				else if(res.code == 410)
				{
					alert("로그인 후 이용 가능합니다.");
					location.href = "/";
				}
				else if(res.code == 500)
				{
					alert("회원탈퇴 중 오류가 발생하였습니다.");
					$("#userPwd").focus();
				}
				else
				{
					alert("회원탈퇴 중 알 수 없는 오류가 발생하였습니다.");
					$("#userPwd").focus();
				}
			},
			error:function(error)
			{
				icia.common.error(error);
			}
		});
	});
});
</script>
  <title>질문 수정하기</title>
</head>
<body>


<div class="container mt-5">
  <h2 class="mb-4">질문 수정하기</h2>

  <form name="qnaUpdateForm" id="qnaUpdateForm" method="post" enctype="multipart/form-data">
    <input type="hidden" name="roomSeq" value="${room.roomSeq}" />
    <input type="hidden" name="roomQnaSeq" value="${roomQna.roomQnaSeq}" />

	<div class="mb-3">
      <label for="userId" class="form-label">아이디</label>
		<input type="text" class="form-control" id="userId" name="userId" value="${user.userId}" readonly >
    </div>
    
    <div class="mb-3">
      <label for="nickName" class="form-label">닉네임</label>
      <input type="text" class="form-control" id="nickName" name="nickName" value="${user.nickName}" readonly >
    </div>

    <div class="mb-3">
		<label for="qnaTitle" class="form-label">제목</label>
		<input type="text" class="form-control" id="roomQnaTitle" name="roomQnaTitle" value="${roomQna.roomQnaTitle}" required>
    </div>

    <div class="mb-3">
		<label for="qnaContent" class="form-label">질문 내용</label>
      	<textarea class="form-control" rows="5" name="roomQnaContent" id="roomQnaContent" style="ime-mode:active;" placeholder="질문 내용을 작성해주세요.">${roomQna.roomQnaContent}</textarea>
    </div>

    <div class="form-group mt-3">
    	<button type="button" id="btnBack" onclick="history.back()" class="btn btn-primary">뒤로가기</button>
        <button type="button" id="btnQnaUpdate" class="btn btn-primary">수정하기</button>     
        <button type="button" id="btnQnaDelete" class="btn btn-danger">삭제하기</button> 
    </div>
  </form>
</div>



</body>
</html>
