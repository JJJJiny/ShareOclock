<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Document</title>
<script src="https://code.jquery.com/jquery-3.4.1.js"></script>
<style>
#wrapper {
	border: 2px solid darkseagreen;
	color: darkseagreen;
	width: 600px;
	margin: auto;
}

#wrapper>div>div {
	display: inline-block;
	margin-top: 5px;
	margin-bottom: 5px;
}

button {
	border-color: darkseagreen;
	background-color: white;
	border-radius: 10px;
}

.textDiv {
	width: 130px;
	text-align: right;
}

.indexDiv {
	text-align: center;
	font-weight: 700;
	margin-top: 10px;
	margin-bottom: 10px;
	font-size: 20px;
}

.lodBtn {
	text-align: center;
	margin-top: 5px;
	margin-bottom: 10px;
}

.add2 {
	width: 300px;
}
</style>
</head>
<body>

	<form action="signup.member" method="get" id="frm">

		<div id="wrapper">
			<div class="indexDiv">회원 가입 정보 입력</div>
			<div id="idDiv">
				<div class="textDiv">아이디 :</div>
				<div>
					<input type="text" id="idInput" name="id">
					<input type="hidden" id="idCheck">
					<button id="idOk" type="button">중복 확인</button>
				</div>
			</div>
			<div id="pwDiv">
				<div class="textDiv">패스워드 :</div>
				<div id="pwInputDiv">
					<input type="password" id="pwInput" name="pw">
				</div>
				<div id="PWinput"></div>
			</div>
			<div id="pwOkDiv">
				<div class="textDiv">패스워드 확인 :</div>
				<div id="pwOkInputDiv">
					<input type="password" id="pwOkInput">
				</div>
				<div id="PWOkinput"></div>
			</div>
			<div id="nameDiv">
				<div class="textDiv">이름 :</div>
				<div>
					<input type="text" id="nameInput" name="name">
				</div>
			</div>
			<div id="phoneDiv">
				<div class="textDiv">전화번호 :</div>
				<div>
					<input type="text" id="phoneInput" name="phone">
				</div>
			</div>
			<div id="emailDiv">
				<div class="textDiv">이메일 :</div>
				<div>
					<input type="text" id="emailInput" name="email">
				</div>
			</div>
			<div id="addressDiv">
				<div class="textDiv">우편번호 :</div>
				<div>
					<input type="text" id="postcode" placeholder="우편번호"
						name="zipcode" readonly>
					<button onclick="execDaumPostcode()" type="button">찾기</button>
				</div>
			</div>
			<div class="addressDiv2">
				<div class="textDiv">주소1 :</div>
				<div>
					<input class="add2" type="text" id="jibunAddress"
						placeholder="지번주소" name="address1"  readonly>
				</div>
			</div>
			<div class="addressDiv2">
				<div class="textDiv">주소2 :</div>
				<div>
					<input class="add2" type="text" id="detailAddress"
						placeholder="상세주소" name="address2">
				</div>
			</div>
			<div class="lodBtn">
				<button type="button" id=send>회원가입</button>
				<button type="reset">다시입력</button>
			</div>
		</div>
	</form>
	<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
	<script>
		$("#send").on("click",function(){
			var input = $("input[type=text]");
			for(i = 0; i<input.length;i++){
				if($(input[i]).val()==""){
					alert("양식을 모두 채워주세요!");
					return;
				}
			}
			if($("#idCheck").val() == "true"){
				$("#frm").submit();
			}else{
				alert("아이디를 중복체크해주세요");

			}
			return;
		});
		$("#idOk").on("click",function() {
			var regex = /^(\w){5}/;
			var id = $("#idInput").val();
			var result = regex.exec(id);
			if($("#idInput").val() == ""){
				alert("아이디를 입력하세요.")
				return;
			}
			if(result == null){
				alert("영문과 숫자로 5자 이상 입력하세요.");
				$("#idInput").val("");
				return;
			}
			window.open("loginCheck.member?id=" + id,"","width=400px,height=300px,top=300px,left=200px");
		});
		$("#pwInput").on("blur", function() {
			var regex = /^(\w){6,12}$/;
			var pwd = $("#pwInput").val();
			var result = regex.exec(pwd);

			if (result == null) {
				$("#PWinput").text("영문과 숫자 6-12");
				$("#pwInput").val("");
			} else {
				$("#PWinput").text("");
			}
		});
		$("#pwOkInput").on("blur", function() {
			if ($("#pwInput").val() == $("#pwOkInput").val()) {
				$("#PWOkinput").text("패스워드가 일치합니다.")
			} else {
				$("#PWOkinput").text("패스워드가 일치하지 않습니다.");
				$("#pwOkInput").val("");
			}
		});
		function execDaumPostcode() {
			new daum.Postcode(
					{
						oncomplete : function(data) {
							document.getElementById('postcode').value = data.zonecode;
							document.getElementById("jibunAddress").value = data.jibunAddress;
							document.getElementById("detailAddress")
									.focus();
						}
					}).open();
		}
	</script>

</body>
</html>