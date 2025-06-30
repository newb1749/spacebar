<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/head.jsp" %>
<script type="text/javascript">
$(document).ready(function(){
	$("#btnDelete").on("click",function(){
		
		if($.trim($("#userPwd1").val()).length <= 0)
		{
			alert("비밀번호를 입력하세요.");
			$("#userPwd1").val("");
			$("#userPwd1").focus();
			return;
		}
		
		if($.trim($("#userPwd2").val()).length <= 0)
		{
			alert("비밀번호 확인을 입력하세요.");
			$("#userPwd2").val("");
			$("#userPwd2").focus();
			return;
		}
		
		if($("#userPwd1").val() != $("#userPwd2").val())
		{
			alert("비밀번호가 일치하지 않습니다.");
			$("#userPwd2").val("");
			$("#userPwd2").focus();
			return;
		}
		
		$("#userPwd").val($("#userPwd1").val());
		
		if($.trim($("#deleteReasonSelect").val()).length <= 0)
		{
			alert("탈퇴사유를 선택해주세요.");
			$("#deleteReasonSelect").focus();
			return;
		}
		
		alert("회원탈퇴 하시겠습니까?");
		
		var form = $("#withdrawForm")[0];
		var formData = new FormData(form);
		
		$.ajax({
			type:"POST",
			url:"/user/deleteProc",
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
					alert("회원 탈퇴가 완료되었습니다. 소중한 의견 감사드리며, 더 나은 서비스로 찾아뵙겠습니다.");
					location.href = "/";
				}
				else if(res.code == 404)
				{
					alert("회원정보가 존재하지 않습니다.");
					location.href = "/";
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

</head>
<body>
<%@ include file="/WEB-INF/views/include/navigation.jsp" %>
<div class="container">
    <div class="row mt-5">
        <h1>회원탈퇴</h1>
    </div>
    <div class="row mt-2">
        <div class="col-12">
            <form name="withdrawForm" id="withdrawForm" method="post" enctype="multipart/form-data">
                <div class="form-group">
                    <label for="userId">사용자 아이디</label>
                    <input type="text" class="form-control" id="userId" name="userId" value="${user.userId}" readonly />
                </div>

                <div class="form-group">
                    <label for="userPwd">비밀번호</label>
                    <input type="password" class="form-control" id="userPwd1" name="userPwd1" placeholder="비밀번호 입력" />
                </div>

                <div class="form-group">
                    <label for="userPwdCheck">비밀번호 확인</label>
                    <input type="password" class="form-control" id="userPwd2" name="userPwd2" placeholder="비밀번호 확인 입력" />
                </div>

				<div class="form-group">
                    <label for="deleteReasonSelect">탈퇴사유</label>
                    <select name="deleteReasonSelect" id="deleteReasonSelect" class="form-control">
						<option value="">탈퇴 사유를 선택해주세요</option>
						<option value="not_satisfied_space">원하는 공간이 없거나 부족함</option>
						<option value="inconvenient_system">예약 시스템이 불편함</option>
						<option value="inconsistent_info">공간 정보가 실제와 다름 (사진, 시설 등)</option>
						<option value="high_cost">대여료/수수료가 비쌈</option>
						<option value="poor_customer_service">고객 지원(피드백, 문의 등)에 불만족</option>
						<option value="found_alternative">더 나은 다른 플랫폼을 찾음</option>
						<option value="privacy_security_concerns">개인 정보 및 보안 우려</option>
						<option value="lack_of_need">더 이상 공간 대여가 필요하지 않음</option>
						<option value="etc">기타 (직접 입력)</option>
					</select>
                </div>

				<div class="form-group">
				    <label for="etcReason">서비스 개선을 위한 의견을 남겨주세요 (선택 사항)</label>
				    <textarea class="form-control" rows="10" name="etcReason" id="etcReason" style="ime-mode:active;" placeholder="선택하신 사유 외에 추가적인 의견이나 개선점 등을 자유롭게 작성해주세요."></textarea>
				</div>

                <div class="form-group mt-3">
                    <button type="button" id="btnDelete" class="btn btn-danger">회원탈퇴</button>
                    <a href="/user/updateForm" class="btn btn-secondary">취소</a>
                </div>
            </form>
        </div>
    </div>
</div>
<%@ include file="/WEB-INF/views/include/footer.jsp"%>
</body>
</html>