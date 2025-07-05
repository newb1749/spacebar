<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/head.jsp" %>
<!-- 카카오 주소 시작 -->
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script>
function sample4_execDaumPostcode()
{
    new daum.Postcode
    ({
        oncomplete: function(data) 
        {
        	// 우편번호
            $("#zipCode").val(data.zonecode);
            // 도로명 및 지번주소
            $("#streetAdr").val(data.roadAddress);
        	// 상세 주소 필드로 포커스 이동 (사용자 편의를 위해 추가)
            $("#detailAddr").focus();
        }
    }).open();
}
</script>
<!-- 카카오 주소 끝 -->

<script type="text/javascript">
$(document).ready(function(){
	
	$("#btndelete").on("click",function(){
		location.href = "/user/deleteForm_mj";	
	});
	
	$("#changeAddrBtn").on("click", function(){
		 $("#addrView").hide(); 
         $("#addrUpdate").show(); 
	});
	
	$("#btnUpdate").on("click", function(){
	
		//공백체크
		var emptCheck = /\s/g;
		//아이디, 비밀번호 4~12자 영문 대소문자, 숫자
		var idPwdCheck = /^[a-zA-Z0-9]{4,12}$/;
		//전화번호 ex)010-0000-0000
		var phoneCheck = /^\d{3}-\d{4}-\d{4}$/;
		
		if($.trim($("#userPwd1").val()).length <= 0)
		{
			alert("비밀번호를 입력하세요.");
			$("#userPwd1").val("");
			$("#userPwd1").focus();
			return;
		}
		
		if(!idPwdCheck.test($("#userPwd1").val()))
		{
			alert("비밀번호는 4~12자 영문 대소문자, 숫자로만 입력이 가능합니다.");
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
		
		if($.trim($("#userName").val()).length <= 0)
		{
			alert("이름을 입력하세요.");
			$("#userName").val("");
			$("#userName").focus();
			return;
		}
		
		if($.trim($("#nickName").val()).length <= 0)
		{
			alert("닉네임을 입력하세요.");
			$("#nickName").val("");
			$("#nickName").focus();
			return;
		}
		
		if($.trim($("#email").val()).length <= 0)
		{
			alert("이메일을 입력하세요.");
			$("#email").val("");
			$("#email").focus();
			return;
		}
		
		if(!fn_emailCheck($("#email").val()))
		{
			alert("이메일 형식이 올바르지 않습니다.");
			$("#email").focus();
			return;
		}
		
		if($.trim($("#phone").val()).length <= 0)
		{
			alert("전화번호를 입력하세요.");
			$("#phone").val("");
			$("#phone").focus();
			return;
		}
		
		if(!phoneCheck.test($("#phone").val()))
		{
			alert("전화번호 형식이 올바르지 않습니다.");
			$("#phone").focus();
			return;
		}
		
		//주소 합치기(도로명주소 + 상세주소)
		var userAddr = $("#streetAdr").val() + " " + $("#detailAdr").val();
		$("#userAddr").val(userAddr);
		//document.updateForm.userAddr.value = userAddr;
		
		var form = $("#updateForm")[0];				
		var formData = new FormData(form);	
		
		$.ajax({
			type:"POST",
			url:"/user/updateProc",
			enctype:"multipart/form-data",
			data:formData,
			processData:false,
			contentType:false,
			cache:false,
			timeout:600000,
			dataType:"JSON",
			beforeSend:function(xhr)
			{
				xhr.setRequestHeader("AJAX", "true");
			},
			success:function(res)
			{
				if(res.code == 0)
				{
					alert("회원정보가 수정되었습니다.")
					location.href = "/user/updateForm_mj";
				}
				else if(res.code == 400)
				{
					alert("파라미터 값이 올바르지 않습니다.");
					$("#userPwd1").focus();
				}
				else if(res.code == 404)
				{
					alert("회원정보가 존재하지 않습니다.");
					location.href = "/";
				}
				else if(res.code == 410)
				{
					alert("로그인을 먼저 하세요.");
					location.href = "/";
				}
				else if(res.code == 430)
				{
					alert("아이디 정보가 다릅니다.");
					location.href = "/";
				}
				else if(res.code == 500)
				{
					alert("회원정보 수정 중 오류가 발생하였습니다.");
					$("#userId").focus();
				}
				else
				{
					alert("오류가 발생하였습니다.");
					$("#userId").focus();
				}
			},
			error:function(error)
			{
				icia.common.error(error);
			}
		});
	});
});

//이메일 정규식 체크
function fn_emailCheck(value)
{
	var emailCheck = /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/;
	
	return emailCheck.test(value);
}
</script>
</head>
<body>
<%@ include file="/WEB-INF/views/include/navigation.jsp" %>
<div class="container">
    <div class="row mt-5">
       <h1>회원정보수정</h1>
    </div>
    <div class="row mt-2">
        <div class="col-12">
            <form name="updateForm" id="updateForm" method="post" enctype="multipart/form-data">
                   
				<div class="form-group">
				    <label for="profImgExt">프로필 이미지</label>
				    
				    <div style="display: flex; align-items: center; gap: 10px; margin-top: 10px;">
				        <!-- 이미지 미리보기 -->
				        <!-- 이미지 등록했을때 -->
				        <c:if test="${!empty user.profImgExt}">
				        <img id="previewImg" src="/resources/upload/userprofile/${user.userId}.${user.profImgExt}" 
				             alt="프로필 이미지" width="100" height="100" style="object-fit: cover; border: 1px solid #ccc;" />
						</c:if>
						<!-- 이미지 등록 안했을때 -->
						<c:if test="${empty user.profImgExt}">
				        <img id="previewImg" src="/resources/upload/userprofile/회원.png" 
				             alt="프로필 이미지" width="100" height="100" style="object-fit: cover; border: 1px solid #ccc;" />
						</c:if>
				        <!-- 파일 선택 -->
				        <input type="file" id="profImgExt" name="profImgExt" accept="image/*" />
				    </div>
				    <p class="error-message" id="profile-image-error"></p>
				</div>								
                
                <div class="form-group">
                    <label for="userId">사용자 아이디</label>
                   <input type="text" class="form-control" id="userId" name="userId" value="${user.userId}" placeholder="아이디" readonly/>
                </div>
                
                <div class="form-group">
                    <label for="userPwd">비밀번호</label>
                    <input type="password" class="form-control" id="userPwd1" name="userPwd1" value="${user.userPwd}" placeholder="비밀번호" />
                </div>
                
                <div class="form-group">
                    <label for="userPwd">비밀번호 확인</label>
                    <input type="password" class="form-control" id="userPwd2" name="userPwd2" value="${user.userPwd}" placeholder="비밀번호 확인" />
                </div>
                
                <div class="form-group">
                    <label for="username">이름</label>
                    <input type="text" class="form-control" id="userName" name="userName" value="${user.userName}" placeholder="사용자 이름" />
                </div>
                
                <div class="form-group">
                    <label for="nickName">닉네임</label>
                    <input type="text" class="form-control" id="nickName" name="nickName" value="${user.nickName}" placeholder="닉네임" />
                </div>
                
                <div class="form-group">
                    <label for="email">이메일</label>
                    <input type="text" class="form-control" id="email" name="email" value="${user.email}" placeholder="사용자 이메일" />
                </div>
                
                <div class="form-group">
                    <label for="phone">전화번호</label>
                    <input type="text" class="form-control" id="phone" name="phone" value="${user.phone}" placeholder="전화번호" />
                </div>
                                
				<div class="form-group">
				    <label for="userAddr">주소</label>
				

				    <!-- 주소 변경 상태 (숨겨져 있다가 버튼 누르면 보여짐) -->
				    <div id="userAddr2">
				        <input type="text" id="zipCode" name="zipCode" placeholder="우편번호" class="form-control" readonly />
				        <input type="text" id="streetAdr" name="streetAdr" placeholder="도로명 주소" value="${user.userAddr}" class="form-control" readonly />
				        <input type="text" id="detailAdr" name="detailAdr" placeholder="상세 주소" class="form-control" />
				        <button type="button" onclick="sample4_execDaumPostcode()" class="btn btn-primary">주소 검색</button>
				    </div>

			
				</div>
             
                <input type="hidden" id="userId" name="userId" value="${user.userId}" />
                <input type="hidden" id="userPwd" name="userPwd" value="" />
                <input type="hidden" id="userAddr" name="userAddr" value="" />
                <br/><button type="button" id="btnBack" onclick="history.back()" class="btn btn-primary">뒤로가기</button>
                <button type="button" id="btnUpdate" class="btn btn-primary">수정</button>
                <button type="button" id="btnDelete" class="btn btn-danger">회원탈퇴</button>        
            </form>
        </div>
    </div>
</div>
<%@ include file="/WEB-INF/views/include/footer.jsp"%>
<script>
document.getElementById('profImgExt').addEventListener('change', function(event) 
{
    const reader = new FileReader();
    reader.onload = function(e)
    {
        document.getElementById('previewImg').src = e.target.result;
    };
    
    if (event.target.files[0]) 
    {
     	reader.readAsDataURL(event.target.files[0]);
    }
});
</script>
</body>
</html>
