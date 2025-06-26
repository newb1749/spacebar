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
//아이디 중복확인 버튼 눌렀는지 확인을 위한 변수 
let isIdChecked = false;
//닉네임 중복확인 버튼 눌렀는지 확인을 위한 변수 
let isNickNameChecked = false;

$(document).ready(function(){
	$("#userId").focus();
	
	$("#userId").on("input",function(){
		isIdChecked = false;
	});
	
	$("#nickName").on("input",function(){
		isNickNameChecked = false;
	});
	
	//가입하기 버튼 눌렀을때
	$("#btnReg").on("click",function(){
		
		//공백체크
		var emptCheck = /\s/g;
		//아이디, 비밀번호 8~12자 영문 대소문자, 숫자
		var idPwdCheck = /^[a-zA-Z0-9]{8,12}$/;
		//전화번호 ex)010-0000-0000
		var phoneCheck = /^\d{3}-\d{4}-\d{4}$/;
		
		if($.trim($("#userId").val()).length <= 0)
		{
			alert("아이디를 입력하세요.");
			$("#userId").val("");
			$("#userId").focus();
			return;
		}
		
		if(emptCheck.test($("#userId").val()))
		{
			alert("아이디는 공백을 포함할 수 없습니다.");
			$("#userId").focus();
			return;
		}
		
		if(!idPwdCheck.test($("#userId").val()))
		{
			alert("아이디는 8~12자 영문 대소문자, 숫자로만 입력이 가능합니다.");
			$("#userId").focus();
			return;
		}
		
		if($.trim($("#userPwd1").val()).length <= 0)
		{
			alert("비밀번호를 입력하세요.");
			$("#userPwd1").val("");
			$("#userPwd1").focus();
			return;
		}
		
		if(!idPwdCheck.test($("#userPwd1").val()))
		{
			alert("비밀번호는 8~12자 영문 대소문자, 숫자로만 입력이 가능합니다.");
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
		
		if(!isIdChecked)
		{
			alert("아이디 중복 확인을 해주세요.");
			$("#userId").focus();
			return;
		}
		
		if(!isNickNameChecked)
		{
			alert("닉네임 중복 확인을 해주세요.");
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
		
		if($("input[name='gender']:checked").length == 0)
		{
			alert("성별을 선택해주세요.");
			return;
		}
		
		//생년월일 값 선택 안했을때
		const birthDt = document.getElementById("birthDt");
		const birthDtValue = birthDt.value;
		
		if(!birthDtValue)
		{
			alert("생년월일을 선택해주세요.");
			return;
		}
		
		//주소 입력안했을때
		if($.trim($("#zipCode").val()).length <= 0)
		{
			alert("주소를 입력하세요.");
			$("#zipCode").val("");
			$("#zipCode").focus();
			return;
		}
		
		//상세주소 입력안했을때
		if($.trim($("#detailAdr").val()).length <= 0)
		{
			alert("상세주소를 입력하세요.");
			$("#detailAdr").val("");
			$("#detailAdr").focus();
			return;
		}
				
		if($("input[name='userType']:checked").length == 0)
		{
			alert("사용자 유형을 선택해주세요.");
		}		
		
		//주소 합치기(도로명주소 + 상세주소)
		var userAddr = $("#streetAdr").val() + " " + $("#detailAdr").val();
		document.regForm.userAddr.value = userAddr;
		
		var form = $("#regForm")[0];				
		var formData = new FormData(form);	
		
		//회원가입 
		$.ajax({
			type:"POST",
			url:"/user/regProc",
			enctype:"multipart/form-data",
			data:formData,
			processData:false,
			contentType:false,
			cache:false,
			timeout:600000,
			beforeSead:function(xhr)
			{
				xhr.setRequestHeader("AJAX", "true");
			},
			success:function(res)
			{
				if(res.code == 0)
				{
					alert("회원가입이 완료되었습니다.");
					location.href = "/";
				}
				else if(res.code == 100)
				{
					alert("이미 사용중인 아이디 입니다.");	
					$("#userId").focus();
				}
				else if(res.code == 400)
				{
					alert("파라미터 값이 올바르지 않습니다.");	
					$("#userId").focus();
				}
				else if(res.code == 500)
				{
					alert("회원가입 중 오류가 발생하였습니다.");	
					$("#userId").focus();
				}
				else
				{
					alert("회원가입 중 알 수 없는 오류가 발생하였습니다.");
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

//아이디 중복확인 버튼 눌렀을때 
function fn_idCheck()
{
	//공백체크
	var emptCheck = /\s/g;
	//아이디, 비밀번호 8~12자 영문 대소문자, 숫자
	var idPwdCheck = /^[a-zA-Z0-9]{8,12}$/;
	
	if($.trim($("#userId").val()).length <= 0)
	{
		alert("아이디를 입력하세요.");
		$("#userId").val("");
		$("#userId").focus();
		isIdChecked = false;
		return;
	}
	
	if(emptCheck.test($("#userId").val()))
	{
		alert("아이디는 공백을 포함할 수 없습니다.");
		$("#userId").focus();
		isIdChecked = false;
		return;
	}
	
	if(!idPwdCheck.test($("#userId").val()))
	{
		alert("아이디는 8~12자 영문 대소문자, 숫자로만 입력이 가능합니다.");
		$("#userId").focus();
		isIdChecked = false;
		return;
	}
	
	$.ajax({
		type:"POST",
		url:"/user/idCheck",
		data:
		{
			userId:$("#userId").val()
		},
		dataType:"JSON",
		beforeSend:function(xhr)
		{
			xhr.setRequestHeader("AJAX", "true");	
		},
		success:function(res)
		{
			if(res.code == 0)
			{
				alert("사용가능한 아이디입니다.");
				isIdChecked = true;
			}
			else if(res.code == 100)
			{
				alert("이미 사용중인 아이디 입니다.");
				$("#userId").focus();
				isIdChecked = false;
			}
			else if(res.code == 400)
			{
				alert("파라미터 값이 올바르지 않습니다.");
				$("#userId").focus();
				isIdChecked = false;
			}
			else
			{
				alert("오류가 발생하였습니다.");
				$("#userId").focus();
				isIdChecked = false;
			}			
		},
		error:function(error)
		{
			icia.common.error(error);
			isIdChecked = false;
		}
	});
}

//닉네임 중복확인 버튼 눌렀을때
function fn_nickNameCheck()
{
	if($.trim($("#nickName").val()).length <= 0)
	{
		alert("닉네임을 입력하세요.");
		$("#nickName").val("");
		$("#nickName").focus();
		isNickNameChecked = false;
		return;
	}
	
	$.ajax({
		type:"POST",
		url:"/user/nickNameCheck",
		data:
		{
			nickName:$("#nickName").val()
		},
		dataType:"JSON",
		beforeSend:function(xhr)
		{
			xhr.setRequestHeader("AJAX", "true");	
		},
		success:function(res)
		{
			if(res.code == 0)
			{
				alert("사용가능한 닉네임입니다.");
				isNickNameChecked = true;
			}
			else if(res.code == 100)
			{
				alert("이미 사용중인 닉네임 입니다.");
				$("#nickName").focus();
				isNickNameChecked = false;
			}
			else if(res.code == 400)
			{
				alert("파라미터 값이 올바르지 않습니다.");
				$("#nickName").focus();
				isNickNameChecked = false;
			}
			else
			{
				alert("오류가 발생하였습니다.");
				$("#nickName").focus();
				isNickNameChecked = false;
			}			
		},
		error:function(error)
		{
			icia.common.error(error);
			isNickNameChecked = false;
		}
	});
}

function addrCheck() 
{
    if($("#zipCode").val() == '' && $("#streetAdr").val() == '')
    {
        alert("우편번호를 클릭하여 주소를 검색해주세요.");
        $("#zipCode").focus();
    }
}

</script>
</head>
<body>
<%@ include file="/WEB-INF/views/include/navigation.jsp" %>
<div class="container">
    <div class="row mt-5">
       <h1>회원가입</h1>
    </div>
    <div class="row mt-2">
        <div class="col-12">
            <form name="regForm" id="regForm" method="post" enctype="multipart/form-data">
                   
				<div class="form-group">
				    <label for="profImgExt">프로필 이미지</label>
				    
				    <div style="display: flex; align-items: center; gap: 10px; margin-top: 10px;">
				        <!-- 이미지 미리보기 -->
				       <c:if test="${!empty user.profImgExt}">
				       	<img id="previewImg" src="/resources/upload/userprofile/${user.userId}.${user.profImgExt}" alt="프로필 이미지" width="100" height="100" style="object-fit: cover; border: 1px solid #ccc;" />
					   </c:if>
				       <!-- 파일 선택 -->
				       <c:if test="${empty user.profImgExt}">
                       	<img id="previewImg" src="/resources/upload/userprofile/회원.png" alt="프로필 이미지" width="100" height="100" style="object-fit: cover; border: 1px solid #ccc;" />
                       </c:if>
				        <input type="file" id="profImgExt" name="profImgExt" accept="image/*" />
				    </div>
				
				    <p class="error-message" id="profile-image-error"></p>
				</div>
                
				<div class="form-group">
				    <label for="userId" class="form-label">아이디</label> 
				    <div class="input-group">
				        <input type="text" class="form-control" id="userId" name="userId" placeholder="아이디를 입력하세요 (8~12자 영문/숫자)" required>
				        <button type="button" onclick="fn_idCheck()" class="btn btn-secondary">중복확인</button>
				    </div>
				    <p class="error-message" id="username-error"></p>
				</div>
                
                <div class="form-group">
                    <label for="userPwd">비밀번호</label>
                    <input type="password" class="form-control" id="userPwd1" name="userPwd1" placeholder="비밀번호를 입력하세요 (8~12자 영문/숫자)" required>
					<p class="error-message" id="password-error"></p>
                </div>
                
                <div class="form-group">
                    <label for="userPwd">비밀번호 확인</label>
                   	<input type="password" class="form-control" id="userPwd2" name="userPwd2" placeholder="비밀번호를 다시 입력하세요" required>
				   	<p class="error-message" id="confirm-password-error"></p>
                </div>
                
                <div class="form-group">
                    <label for="username">이름</label>
                    <input type="text" class="form-control" id="userName" name="userName" placeholder="이름을 입력하세요" required>
					<p class="error-message" id="name-error"></p>
                </div>
                
                <div class="form-group">
                    <label for="nickName" class="form-label">닉네임</label>
                    <div class="input-group">
	                    <input type="text" class="form-control" id="nickName" name="nickName" placeholder="닉네임을 입력하세요" required>
						<button type="button" onclick="fn_nickNameCheck()" class="btn btn-primary">중복확인</button>
					</div>
					<p class="error-message" id="nickName-error"></p>
                </div>
                
                <div class="form-group">
                    <label for="email">이메일</label>
                    <input type="email" class="form-control" id="email" name="email" placeholder="이메일을 입력하세요 ex)test@sist.co.kr" required>
					<p class="error-message" id="email-error"></p>
                </div>
                
                <div class="form-group">
                    <label for="phone">전화번호</label>
                    <input type="text" class="form-control" id="phone" name="phone" placeholder="전화번호를 입력하세요 ex)010-0000-0000" required>
					<p class="error-message" id="phone-error"></p>
                </div>
                
                <div class="form-group">
					<div>
						<label for="gender">성별</label>
						<input type="radio" name="gender" value="M"> 남성 (M)					
						<input type="radio" name="gender" value="F"> 여성 (F)
					</div>
					<p class="error-message" id="gender-error"></p>
				</div>
				
				<div class="form-group">
					<label for="birthDt">생년월일</label> 
					<input type="date" id="birthDt" name="birthDt" required>
					<p class="error-message" id="birthdate-error"></p>
				</div>
                              
                                
				<div class="form-group">
				    <label for="userAddr">주소</label>
					<input type="text" class="form-control form-control-user" id="zipCode" name="zipCode" placeholder="우편번호" readonly onclick="sample4_execDaumPostcode()">
					<input type="text" class="form-control form-control-user" id="streetAdr" name="streetAdr" placeholder="도로명 주소" readonly>
					<input type="text" class="form-control form-control-user" id="detailAdr" name="detailAdr" placeholder="상세 주소" onclick="addrCheck()">
				</div>
				
				<div class="form-group">
					<div>
						<label for="userType">사용자 타입</label> 
						<input type="radio" name="userType" value="G" checked> 게스트
						<input type="radio" name="userType" value="H"> 호스트
					</div>
					<p class="error-message" id="usertype-error"></p>
				</div>	
             
				<input type="hidden" id="userPwd" name="userPwd" value="" />
				<input type="hidden" id="userAddr" name="userAddr" value="" />
				<button type="button" id="btnReg" class="btn btn-primary">가입하기</button>
				<p class="login-link">이미 계정이 있으신가요? <a href="/">로그인</a></p>
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
