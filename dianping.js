function  toppage()  
{                          
     if(!+[1,])
	 {
		if  (self.location!=top.location)frameElement.height=document.body.scrollHeight  +  10; 
		//alert("这是ie浏览器"+document.body.scrollHeight);
	 }
	 else{
		if  (self.location!=top.location)frameElement.height=document.documentElement.scrollHeight + 10;
		//alert("这不是ie浏览器"+document.body.scrollHeight); 
	 }   

} 

function jubao(url) {
	window.parent.jubao(url);
	//我要举报
}

function denglu(url) {
	window.parent.denglu(url);
}

function showlog(content) {
	$("#lgstatus").html(content);
}

function showStar(num) {
	var n =1;
	var star = "";
	for (n = 1; n <= num; n++)star+="<span class=\"bri\" onmouseover=\"showStar("+n+")\">&nbsp;</span>";
	var j = n;
	
	for (n = j; n <= 5; n++)star+="<span class=\"dar\" onmouseover=\"showStar("+n+")\">&nbsp;</span>";
	$("#star").html(star);
	$("#xx").val(num);
	//alert($("#xx").val());
}

function addfee(name)
{
	var o =$("#c_fee").val();
	if(o.indexOf(name)<0)
	{
		$("#c_fee").val($("#c_fee").val()+name+"　");
	}
}
function getNowTime()
{
	//取得当前时间  
    var now= new Date();  
    var year=now.getYear();  
    var month=now.getMonth()+1;  
    var day=now.getDate();  
    var hour=now.getHours();  
    var minute=now.getMinutes();  
    var second=now.getSeconds();  
    var nowdate=year+"-"+month+"-"+day+" "+hour+":"+minute+":"+second;
    return nowdate;
}

//点评设置焦点
function setFocus()
{
	var ua = navigator.userAgent;
	ua = ua.toLowerCase();
	if (ua.indexOf("chrome") > -1) {
		window.parent.setChrome(); 
	}
	$("#c_text").focus();
}

function xzhong()
{
	if($("#niming").attr("checked")==true){
		$("#niming").attr("checked",false);
	}else
	{
		$("#niming").attr("checked",true);
	}
}

function huifu(id)
{
	$("#tidp").removeAttr("disabled");
	$("#jltj").removeAttr("disabled");
}

//提交点评
$().ready(function() {  
	
	//dianping
	$("#tidp").click(function() {
		var t = $("#c_text").val();
		
		var cook = "";
		var fs = "";
		try{
			cook = $.cookie('138do_uid')+""; // 获得cookie
			fs = $.cookie('138do_dpid')+"";
		}catch(e){cook = "";fs = "";}
		
		//alert(cook);
		if((cook.length<3||cook=="null")&&($("#niming").attr("checked")==false)){
			alert("请先登录或者选择匿名发表！");
			return false;
		}
		
		if($("#sid").val()==fs){
			alert("不能太频繁哦，请30秒后再试！");
			return false;
		}
		
		if(cook.length<3)cook = "游客";
		
		if(t.length<1)
		{
			alert("请输入点评内容");
			return false;
		}else
		{
			$("#tidp").attr("disabled","disabled");
			setTimeout(huifu,28000);
			
			var c ="";
			var star = "";
			var id = $("#sid").val();
			var xx = $("#xx").val();
			var c_text = $("#c_text").val();
			var c_fee = $("#c_fee").val();
			var count = $("#count").val();
			var now = getNowTime().substring(0,16);
			var niming = 0;
			if($("#niming").attr("checked")==true)niming = 1;
			if(cook.length<3||niming==1)cook = "游客";
			$.ajax({
				type: "POST",
			  	url: "/cgi/getdp.jsp",
			  	data: "sid="+id+"&jid=0&xx="+xx+"&c_text="+c_text+"&c_fee="+c_fee+"&niming="+niming,
			  	cache: false,
			  	error:function(){
					alert("提交失败,稍微请您再试");
				},
			  	success: function(data){
					
					for (var n = 0; n < xx; n++)star+="<span class=\"bri\">&nbsp;</span>";
					for (var n = 0; n < (5-xx); n++)star+="<span class=\"dar\">&nbsp;</span>";
					
					if(count<10)
					{
						c_text = c_text.replace(/\n/g,"<br>");
						var suc = "<span id=add_dp><div class=\"fl com-a\"><img src=\"/images/pic7.gif\" /></div>"
							+ "   <div class=\"com-n fr\"><a href=\"javascript:;\" class=\"blu\">"+cook+"</a><span class=\"bad\">&nbsp;</span><br />"
							+ "     "+star+"<span class=\"rec\">推荐：</span><span class=\"gra\">"+c_fee+"</span><br />"
							+ "     "+c_text+"<br />"
							+ "     <span class=\"rep\"><a href=\"javascript:;\">举报</a></span><span class=\"dat1\">"+now+"</span></div>"
							+ "   "
							+ "   <div class=\"spa\"></div></span>";
						//$("#add_dp").html(suc);
						//window.parent.SetCwinHeight();
						alert(data);
						window.location.reload();
					}else if(count>=11&&count<999)
					{
						alert(data+",请到页尾查看");
					}else if(count==999)
					{
						alert(data+",审核后才能显示");
					}else{
						alert(data);
					}
					
					$("#c_text").val("");
					$("#c_fee").val("");
					
			  }
			}); 
		}
		
	});
	
	//jingli

	$("#jltj").click(function() {
		var t = $("#c_text").val();
		var cook = "";
		var fs = "";
		try{
			cook = $.cookie('138do_uid')+""; // 获得cookie
			fs = $.cookie('138do_dpid')+"";
		}catch(e){cook = "";fs = "";}
		
		
		if((cook.length<3||cook=="null")&&($("#niming").attr("checked")==false)){
			alert("请先登录或者选择匿名发表！");
			return false;
		}
		if($("#sid").val()==fs){
			alert("不能太频繁哦，请30秒后再试！");
			return false;
		}
		
		if(t.length<1)
		{
			alert("请输入点评内容");
			return false;
		}else
		{
			$("#jltj").attr("disabled","disabled");
			setTimeout(huifu,28000);
			var c ="";
			var star = "";
			var id = $("#sid").val();
			var jid = $("#jid").val();
			var xx = $("#xx").val();
			var c_text = $("#c_text").val();
			var c_fee = $("#c_fee").val();
			var count = $("#count").val();
			var now = getNowTime().substring(0,16);
			var niming = 0;
			if($("#niming").attr("checked")==true)niming = 1;
			if(cook.length<3||niming==1)cook = "游客";
			$.ajax({
				type: "POST",
			  	url: "/cgi/getdp.jsp",
			  	data: "sid="+id+"&jid="+jid+"&xx="+xx+"&c_text="+c_text+"&c_fee="+c_fee+"&niming="+niming,
			  	cache: false,
			  	error:function(){
					alert("提交失败,稍微请您再试");
				},
			  	success: function(data){
					for (var n = 0; n < xx; n++)star+="<span class=\"bri\">&nbsp;</span>";
					for (var n = 0; n < (5-xx); n++)star+="<span class=\"dar\">&nbsp;</span>";
					if(count<10)
					{
						c_text = c_text.replace(/\n/g,"<br>");
						var suc = "<span id=add_dp><div class=\"fl com-a\"><img src=\"/images/pic7.gif\" /></div>"
							+ "   <div class=\"com-n fr\"><a href=\"javascript:;\" class=\"blu\">"+cook+"</a><span class=\"bad\">&nbsp;</span><br />"
							+ "     "+star+"<span class=\"rec\">推荐：</span><span class=\"gra\">"+c_fee+"</span><br />"
							+ "     "+c_text+"<br />"
							+ "     <span class=\"rep\"><a href=\"javascript:;\">举报</a></span><span class=\"dat1\">"+now+"</span></div>"
							+ "   "
							+ "   <div class=\"spa\"></div></span>";
						
						//window.parent.SetCwinHeight();
						alert(data);
						window.location.reload();
					}else if(count>=11&&count<999)
					{
						alert(data+",请到页尾查看");
					}else if(count==999)
					{
						alert(data+",审核后才能显示");
					}else{
						alert(data);
					}
					
					$("#c_text").val("");
					$("#c_fee").val("");
					
			  }
			}); 
		}
		
	});
	
	$("#nm").click(function() {
		if($("#nm").attr("checked")==true){
			$("#nm").attr("checked",false);
		}else
		{
			$("#nm").attr("checked",true);
		}
	});
	
	//精华
	$("#sea1").click(function() {
		$('#sea2').css("background","url(/images/cou.gif) 0 -127px repeat-x");
		$('#sea1').css("background","url(/images/cou.gif) -175px -85px repeat-x");
		window.location.href = $("#dp1").attr("href");
	});
	
	$("#sea2").click(function() {
		$('#sea2').css("background","url(/images/cou.gif) -175px -85px repeat-x");
		$('#sea1').css("background","url(/images/cou.gif) 0 -127px repeat-x");
		window.location.href = $("#dp2").attr("href");
	});
	
	
});