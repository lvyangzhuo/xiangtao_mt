<%@ page contentType="text/html; charset=utf-8" %>
<!DOCTYPE html>
<html>
<head>
<title>会员注册_优惠券网</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="author" content="shuidazhe.com">
<meta name="viewport" content="width=device-width,initial-scale=1.0,maximum-scale=1.0,minimum-scale=1.0,user-scalable=0">
<meta name="apple-touch-fullscreen" content="yes">
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-status-bar-style" content="black">
<meta name="format-detection" content="telephone=no">

<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
<link rel="stylesheet" type="text/css" href="images/h5_lottery_pc.20131105.css" />
<link rel="stylesheet" type="text/css" href="images/base.css?v=shuidazhe" />

<script type="text/javascript" src="/js/jquery.min.js"></script>
<script type="text/javascript" src="/js/jquery.cookie.js"></script>
<script type="text/javascript" src="/js/huiduo.js"></script>
<script type="text/javascript" src="/3g/reg.js"></script>
<script type="text/javascript">
      var isIE6=false;
      var isPC = true;
    </script>
    <!--[if lte IE 6]><script type="text/javascript">isIE6=true;</script><![endif]-->

    <!--[if IE]>
    <script src="http://static.518.qq.com/js/html5.js"></script>
    <![endif]-->
    
 <!--[if !IE]>|xGv00|d28af0a4048868ce5256cac58120a57c<![endif]--> 
<!--[if lte IE 9]>
<link rel='stylesheet'  href='http://static.paipaiimg.com/lottery/pbcss/ie_hack.20130417.css' type='text/css' media='all' />
<![endif]-->

<script type="text/javascript">


//vb2ctg对应的导航样式
var navCfg={
  "0":"mode_webapp"
};
  

</script>
</head>

<style>
.logbtn {
	margin: 0px 0px 0px; border-radius: 5px; border: 1px solid rgb(186, 172, 157); width: 100px; height: 30px; text-align: center; color: rgb(60, 60, 60); line-height: 30px; font-size: 1em; display: inline-block; cursor: pointer; -webkit-border-radius: 5px; -moz-border-radius: 5px;font-size:15px;
}
</style>

<body>

<%@ include file="header.jsp" %> 

<div class="good-detail sift-mg">
	<h3 class="h_h3"><span class="title">注册</span><span class="title_f">或者 <a href="login.jsp">登录</a></span><font color="red"></font> </h3>
	<div class="parting-line"></div>
	<div align="center" style="height:auto;padding-top:10px">

<form name="regform" id="regform" method="post" action="/m/reg.jsp?type=mob" class="search" AUTOCOMPLETE="OFF">

<ul class="mu_lw">
			<li class="mu_l"><span class="mu_lh">* 手机号码：</span> <span class="mu_lc"><input type="text" name="uname" id="uname" size="20" maxlength="20" class="keyword" onblur="" ><span class="gri"></span></span></li>
			<li class="mu_l"><span class="mu_lh">* 短信验证码：</span><span class="mu_lc"><input type="text" name="yan" id="yzan" size="5" maxlength="5" class="keyword" > 
        <input type="button" value="发送短信验证码" name="fsyz" id="sendsms" style="width:100px;height:32px"></span></li>

			<li class="mu_l"><span class="mu_lh">* 用户密码： </span><span class="mu_lc"><input type="text" name="password" id="password" size="20" maxlength="20" class="keyword" onfocus="this.type='password'" ></span></li>
			<li class="mu_l"><span class="mu_lh">* 确认密码：</span><span class="mu_lc"><input type="text" name="rpassword" id="rpassword" size="20" maxlength="16" class="keyword" onfocus="this.type='password'" ></span></li>
			
</ul>

  		<li class="mu_l"><span class="mu_lh">&nbsp;</span> <span class="mu_lc q-txt"><input type="submit" name="submit2"  class="logbtn" value="手机注册"></span></li>	
		<li class="mu_l"><span class="mu_lh">&nbsp;</span> <span class="mu_lc q-txt">&nbsp;</span></li>	
		<div class="parting-line"></div>
		<ul class="mu_lw">
						<li class="mu_l"> <span class="mu_lh"><strong>已有账户？</strong></span> <span class="mu_lc"><span class="gri">立即 <a href="login.jsp">登录</a></span></span></li>
						
			
					
		</ul>

  </form>
 </div>
	 </div>
 <div class="to-top"><a href="javascript:scroll(0,0)" hidefocus="true"><span></span>回顶部</a></div>

<%/*@ include file="footer.jsp" */%>

</body>
</html>
<script>

var wait=60;
	function time(o) {
		
			if (wait == 0) {
				o.removeAttribute("disabled");            
				o.value="发送短信验证码";
				wait = 60;
			} else { // www.jbxue.com
				o.setAttribute("disabled", true);
				o.value="重新发送(" + wait + ")";
				wait--;
				setTimeout(function() {
					time(o)
				},
				1000)
			}
		}

//验证码
$("#sendsms").click(function(){
				var fid = $("#uname").val();
				//获得手机号
				if (fid.length!=11) {
					alert("手机号码输入不正确，请检查！");
				}else
				{
					//$("#uploadhtml").show();
					//dialog("发送短信验证码","url:/m/sendsms.jsp?c=2&c_tel="+fid,"450px","239px","window");

					$.ajax({
						type: "get",
						async:false,
						url: "/m/sendsms.jsp",
						data: "c=2&t=mob&c_tel="+fid,
						cache: false,
						error:function(status){
						},
						success: function(data){
							var vnote = "";
							if (data.indexOf("sjyzm")>0) {
								vnote= data.substring(data.indexOf("sjyzm=")+6,data.indexOf("jsyzm"));
							}
							//alert("11");
							alert(vnote);	
					  }
					});
					time(this);
				}
				
});

</script>