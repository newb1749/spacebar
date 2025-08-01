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
	
	$("#btnQnaWrite").on("click",function(){
		$("#btnQnaWrite").prop("disabled", true);
		
		if($.trim($("#roomQnaTitle").val()).length <= 0)
		{
			alert("제목을 입력하세요.");
			$("#roomQnaTitle").val("");
			$("#roomQnaTitle").focus();
			$("#btnQnaWrite").prop("disabled", false);
			return;
		}
		
		if($.trim($("#roomQnaContent").val()).length <= 0)
		{
			alert("내용을 입력하세요.");
			$("#roomQnaContent").val("");
			$("#roomQnaContent").focus();
			$("#btnQnaWrite").prop("disabled", false);
			return;
		}
		
		var form = $("#qnaWriteForm")[0];
		var formData = new FormData(form);
		
		$.ajax({
			type:"POST",
			url:"/room/qnaWriteProc",
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
					alert("Q&A가 등록되었습니다.");
					location.href = "/room/roomDetail?roomSeq=" + $("input[name=roomSeq]").val();
				}
				else if(res.code == 400)
				{
					alert("파라미터 값이 올바르지 않습니다.");
					$("#btnQnaWrite").prop("disabled", false);
					$("#roomQnaTitle").focus();
				}
				else
				{
					alert("Q&A 등록 중 오류가 발생하였습니다.");
					$("#btnQnaWrite").prop("disabled", false);
					$("#roomQnaTitle").focus();
				}
			},
			error:function(error)
			{
				icia.common.error(error);
				alert("Q&A 등록 중 알 수 없는 오류가 발생하였습니다.");
				$("#btnQnaWrite").prop("disabled", false);
			}
		});
	});
});
</script>
  <title>질문 작성하기</title>
</head>
<body>
<%@ include file="/WEB-INF/views/include/navigation.jsp" %>

<div class="container mt-5">
  <h2 class="mb-4">질문 작성하기</h2>

  <form name="qnaWriteForm" id="qnaWriteForm" method="post" enctype="multipart/form-data">
    <input type="hidden" name="roomSeq" value="${room.roomSeq}" />

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
      <input type="text" class="form-control" id="roomQnaTitle" name="roomQnaTitle" required>
    </div>

    <div class="mb-3">
      <label for="qnaContent" class="form-label">질문 내용</label>
      <textarea class="form-control" rows="5" name="roomQnaContent" id="roomQnaContent" style="ime-mode:active;" placeholder="질문 내용을 작성해주세요."></textarea>
    </div>

    <div class="form-group mt-3">
    	<button type="button" id="btnBack" onclick="history.back()" class="btn btn-primary">뒤로가기</button>
        <button type="button" id="btnQnaWrite" class="btn btn-danger">등록하기</button>               
    </div>
  </form>
</div>


<%@ include file="/WEB-INF/views/include/footer.jsp" %>
</body>
</html>
