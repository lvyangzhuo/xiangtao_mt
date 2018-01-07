$().ready(function() {
	var ok_u = false;
	var ok_y = false;
	var ok_sms = false;
	$("#uname").blur( function () { 
		var uname = $("#uname").val();
		
		if(uname.length!=11){
			if(uname.length>0){isErr("s1","uname","手机号必须为11位字符长度");}
			return false;
		}else{
			
			var reg=/^[1-9]\d*$|^0$/;
			flag = reg.test(uname);
			if (flag) {
				
			
			var pattern =/\W/;
			flag = pattern.test(uname);
			if (flag) 
			{
				isErr("s1","uname","手机号不能包含中文");
				return false;
			}else
			{
				$.ajax({
					type: "get",
					async:true,
				  	url: "/m/check.jsp",
				  	data: "c=2&uname="+uname,
				  	cache: false,
				  	error:function(status){
						isErr("s1","uname","出错了,请稍后再试");
					},
				  	success: function(data){
						if(data.indexOf("ok")>-1)
						{
							isOk("s1","正确");
							ok_u = true;
						}else if(data.indexOf("error")>-1){
							isErr("s1","uname","此手机号已有人注册过");
						}	
				  }
				});
			}

			}else
			{
				isErr("s1","uname","手机号不能含有字符");
				return false;
			}
		}
		
		
	}); 
	

	$("#password").blur( function () { 
		var password = $("#password").val();
		if(password==""||password.length<6||password.length>16){
			if(password.length>0)isErr("s2","password","密码长度只能在6-16位字符之间");
			return false;
		}else{
			isOk("s2","正确");
		}
	}); 
	
	$("#rpassword").blur( function () { 
		var password = $("#password").val();
		var rpassword = $("#rpassword").val();
		if(password==""||rpassword!=password){
			if(rpassword.length>0)isErr("s3","rpassword","两次输入密码不一致");
			return false;
		}else if(rpassword.length<6||rpassword.length>16){
			if(rpassword.length>0)isErr("s3","rpassword","密码长度只能在6-16位字符之间");
			return false;	
		}else
		{
			isOk("s3","正确");
		}
	});
	
	


	$("#smsyz").blur( function () { 
		var yan = $("#smsyz").val();
		var uname = $("#uname").val();

		if(yan==""||yan.length<4){
			if(yan.length>0)isErr("s6","smsyz","错误");
			return false;
		}else{
			///image/createImg.jsp
			$.ajax({
				type: "get",
				async:true,
			  	url: "/m/check.jsp",
			  	data: "c=4&uname="+uname+"&smsyz="+yan,
			  	cache: false,
			  	error:function(status){
				},
			  	success: function(data){
					if(data.indexOf("ok")>-1)
					{
						isOk("s6","正确");
						
						ok_sms = true;
					}else if(data.indexOf("error")>-1){
						isErr("s6","smsyz","错误");
						ok_sms = false;
					}	
			  }
			});
		}
	}); 
	
	$("#regform").submit( function () {
		var uname = $("#uname").val();
		var password = $("#password").val();
		var rpassword = $("#rpassword").val();
		var yan = $("#yan").val();
		var smsyz = $("#smsyz").val();

		
		
		if(uname==""||uname.length!=11){
			isErr("s1","uname","手机号必须为11位字符长度");
			return false;
		}else{
			var pattern =/\W/;
			flag = pattern.test(uname);
			if (flag) 
			{
				isErr("s1","uname","手机号不能包含中文");
				return false;
			}else
			{
				isOk("s1","正确");
			}
		}
		
		if(password==""||password.length<6||password.length>16){
			isErr("s2","password","密码长度只能在6-16位字符之间");
			return false;
		}else{
			isOk("s2","正确");
		}
		
		if(rpassword!=password){
			isErr("s3","rpassword","两次输入密码不一致");
			return false;
		}else{
			isOk("s3","正确");
		}

		ok_y = true;
		ok_sms = true;
		//alert(ok_y+"_"+ok_sms);
		
		if(!ok_u)return false;
		if(!ok_y)return false;
		if(!ok_sms)return false;
		/**/
		
	}); 
	
	var cook = "";
	try{
		cook = $.cookie('138do_userid')+""; // 获得cookie
	}catch(e){cook = "";}
	if(cook.length>3&&cook!="null"){$("#userid").val(cook);}

	
	$("#logform").submit( function () {
		var uname = $("#userid").val();
		var password = $("#userpass").val();
		var yan = $("#num").val();
		
		if(uname==""||uname.length!=11){
			isErr("s1","uname","手机号必须为11位字符长度，不能为中文");
			return false;
		}else{
			var pattern =/\W/;
			flag = pattern.test(uname);
			if (flag) 
			{
				isErr("s1","uname","手机号不能包含中文");
				return false;
			}else
			{
				isOk("s1","");
			}
		}
		
		if(password==""||password.length<6||password.length>16){
			isErr("s2","password","密码长度只能在6-16位字符之间");
			return false;
		}else{
			isOk("s2","");
		}
		
	}); 
	
	$("#denglu").submit( function () {
		var uname = $("#userid").val();
		var password = $("#userpass").val();
		var yan = $("#num").val();
		
		if(uname==""||uname.length!=11){
			isErr("s1","uname","必须11位长度");
			return false;
		}else{
			var pattern =/\W/;
			flag = pattern.test(uname);
			if (flag) 
			{
				isErr("s1","uname","不能包含中文");
				return false;
			}else
			{
				isOk("s1","");
			}
		}
		
		if(password==""||password.length<6||password.length>16){
			isErr("s2","password","密码长度6-16位字符");
			return false;
		}else{
			isOk("s2","");
		}
		
		
	}); 
	
	$("input[type=text]").blur( function () { 
		if(this.id=="query")return;
		$("#"+this.id).css("border","1px solid #99cccc"); 
		$("#"+this.id).css("background-color","#fff"); 
	}); 
	$("input[type=password]").blur( function () { 
		$("#"+this.id).css("border","1px solid #99cccc"); 
		$("#"+this.id).css("background-color","#fff"); 
	}); 
	/**/
	var yf=0;
	$("input[type=text]").focus(function(){
		if(this.id=="query")return;
		clear();
		$("#"+this.id).css("border","1px solid #ffcc00"); 
		$("#"+this.id).css("background-color","#feff99");

		if(this.id=="uname")isTips("s1","11位手机号，不能含有字符");
		if(this.id=="userid")isTips("s1","11位手机号，不能含有字符");
		if(this.id=="yan"){
			//var yan = $("#yan").val();
			if(yf==0){
				$("#random").attr("src","/image/createImg.jsp");
				$("#kbq").css("display","");
				yf=1;
			}
			isTips("s4","请输入右侧验证码");
			
		}
		if(this.id=="invite")isTips("s5","可填写邀请人的账号，没有可不填");
		
	}); 
	
	$("input[type=password]").focus(function(){
		clear();
		$("#"+this.id).css("border","1px solid #ffcc00"); 
		$("#"+this.id).css("background-color","#feff99");
		
		if(this.id=="password")isTips("s2","密码长度只能在6-16位字符之间");
		if(this.id=="rpassword")isTips("s3","请重复输入一遍密码");
		if(this.id=="userpass")isTips("s2","密码长度6-16位字符");
	}); 

	
	$("#md").click(function() {
		if($("#remember").attr("checked")==true){
			$("#mdshow").hide();
			$("#remember").attr("checked",false);
		}else
		{
			$("#mdshow").show();
			$("#remember").attr("checked",true);
		}
		
	});
	
	$("#remember").mouseover(function() {
		if($("#remember").attr("checked")==true){
			$("#mdshow").show();
		}else
		{
			$("#mdshow").show();
		}
		
	});
	
	$("#remember").mouseout(function() {
		if($("#remember").attr("checked")==true){
			$("#mdshow").show();
		}else
		{
			$("#mdshow").hide();
		}
		
	});
	
	function isOk(ObjId,text)
	{
		$("#"+ObjId).text(text);
		$("#"+ObjId).css("color","#339900");
		$("#"+ObjId).attr("class","");
		var o = ObjId.substring(1,2);
		$("#"+ObjId+o).attr("class","ok fl");
		$("#"+ObjId).css("background-color","#fff"); 
	}
	
	function isTips(ObjId,text)
	{
		$("#"+ObjId).text(text);
		$("#"+ObjId).css("color","#325f80");
		$("#"+ObjId).attr("class","lan");
		var o = ObjId.substring(1,2);
		$("#"+ObjId+o).attr("class","fl");
	}
	
	function isErr(ObjId,id,text)
	{
		$("#"+ObjId).text(text);
		$("#"+ObjId).css("color","#ff0000");
		$("#"+ObjId).attr("class","");
		var o = ObjId.substring(1,2);
		$("#"+ObjId+o).attr("class","err fl");
		$("#"+id).css("border","1px solid #ff9999"); 
		$("#"+id).css("background-color","#ffe2d2");
	}
	
	function clear()
	{
		$(".lan").each(function() {
			ObjId = this.id;
			//alert();
			$("#"+ObjId).text("");
			var o = ObjId.substring(1,2);
			$("#"+ObjId+o).attr("class","fl");
		}); 
	}
	



});



