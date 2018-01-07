$().ready(function() {
	var ok_u = false;
	var ok_y = false;
	var ok_sms = false;
	$("#uname").blur( function () { 
		var uname = $("#uname").val();
		
		if(uname.length!=11){
			if(uname.length>0){isErr("s1","uname","�ֻ��ű���Ϊ11λ�ַ�����");}
			return false;
		}else{
			
			var reg=/^[1-9]\d*$|^0$/;
			flag = reg.test(uname);
			if (flag) {
				
			
			var pattern =/\W/;
			flag = pattern.test(uname);
			if (flag) 
			{
				isErr("s1","uname","�ֻ��Ų��ܰ�������");
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
						isErr("s1","uname","������,���Ժ�����");
					},
				  	success: function(data){
						if(data.indexOf("ok")>-1)
						{
							isOk("s1","��ȷ");
							ok_u = true;
						}else if(data.indexOf("error")>-1){
							isErr("s1","uname","���ֻ���������ע���");
						}	
				  }
				});
			}

			}else
			{
				isErr("s1","uname","�ֻ��Ų��ܺ����ַ�");
				return false;
			}
		}
		
		
	}); 
	

	$("#password").blur( function () { 
		var password = $("#password").val();
		if(password==""||password.length<6||password.length>16){
			if(password.length>0)isErr("s2","password","���볤��ֻ����6-16λ�ַ�֮��");
			return false;
		}else{
			isOk("s2","��ȷ");
		}
	}); 
	
	$("#rpassword").blur( function () { 
		var password = $("#password").val();
		var rpassword = $("#rpassword").val();
		if(password==""||rpassword!=password){
			if(rpassword.length>0)isErr("s3","rpassword","�����������벻һ��");
			return false;
		}else if(rpassword.length<6||rpassword.length>16){
			if(rpassword.length>0)isErr("s3","rpassword","���볤��ֻ����6-16λ�ַ�֮��");
			return false;	
		}else
		{
			isOk("s3","��ȷ");
		}
	});
	
	


	$("#smsyz").blur( function () { 
		var yan = $("#smsyz").val();
		var uname = $("#uname").val();

		if(yan==""||yan.length<4){
			if(yan.length>0)isErr("s6","smsyz","����");
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
						isOk("s6","��ȷ");
						
						ok_sms = true;
					}else if(data.indexOf("error")>-1){
						isErr("s6","smsyz","����");
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
			isErr("s1","uname","�ֻ��ű���Ϊ11λ�ַ�����");
			return false;
		}else{
			var pattern =/\W/;
			flag = pattern.test(uname);
			if (flag) 
			{
				isErr("s1","uname","�ֻ��Ų��ܰ�������");
				return false;
			}else
			{
				isOk("s1","��ȷ");
			}
		}
		
		if(password==""||password.length<6||password.length>16){
			isErr("s2","password","���볤��ֻ����6-16λ�ַ�֮��");
			return false;
		}else{
			isOk("s2","��ȷ");
		}
		
		if(rpassword!=password){
			isErr("s3","rpassword","�����������벻һ��");
			return false;
		}else{
			isOk("s3","��ȷ");
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
		cook = $.cookie('138do_userid')+""; // ���cookie
	}catch(e){cook = "";}
	if(cook.length>3&&cook!="null"){$("#userid").val(cook);}

	
	$("#logform").submit( function () {
		var uname = $("#userid").val();
		var password = $("#userpass").val();
		var yan = $("#num").val();
		
		if(uname==""||uname.length!=11){
			isErr("s1","uname","�ֻ��ű���Ϊ11λ�ַ����ȣ�����Ϊ����");
			return false;
		}else{
			var pattern =/\W/;
			flag = pattern.test(uname);
			if (flag) 
			{
				isErr("s1","uname","�ֻ��Ų��ܰ�������");
				return false;
			}else
			{
				isOk("s1","");
			}
		}
		
		if(password==""||password.length<6||password.length>16){
			isErr("s2","password","���볤��ֻ����6-16λ�ַ�֮��");
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
			isErr("s1","uname","����11λ����");
			return false;
		}else{
			var pattern =/\W/;
			flag = pattern.test(uname);
			if (flag) 
			{
				isErr("s1","uname","���ܰ�������");
				return false;
			}else
			{
				isOk("s1","");
			}
		}
		
		if(password==""||password.length<6||password.length>16){
			isErr("s2","password","���볤��6-16λ�ַ�");
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

		if(this.id=="uname")isTips("s1","11λ�ֻ��ţ����ܺ����ַ�");
		if(this.id=="userid")isTips("s1","11λ�ֻ��ţ����ܺ����ַ�");
		if(this.id=="yan"){
			//var yan = $("#yan").val();
			if(yf==0){
				$("#random").attr("src","/image/createImg.jsp");
				$("#kbq").css("display","");
				yf=1;
			}
			isTips("s4","�������Ҳ���֤��");
			
		}
		if(this.id=="invite")isTips("s5","����д�����˵��˺ţ�û�пɲ���");
		
	}); 
	
	$("input[type=password]").focus(function(){
		clear();
		$("#"+this.id).css("border","1px solid #ffcc00"); 
		$("#"+this.id).css("background-color","#feff99");
		
		if(this.id=="password")isTips("s2","���볤��ֻ����6-16λ�ַ�֮��");
		if(this.id=="rpassword")isTips("s3","���ظ�����һ������");
		if(this.id=="userpass")isTips("s2","���볤��6-16λ�ַ�");
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



