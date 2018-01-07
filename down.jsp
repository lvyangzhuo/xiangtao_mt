<%@ page contentType="text/html; charset=utf-8" %><%@ page language="java" import="com.wsu.basic.util.Tools"%>
<%
String p = request.getParameter("p");
if (p==null) {
	p = "";
}

String id = Tools.RmNull(request.getParameter("id"));
%>
<!DOCTYPE html>
<html>
<head>
<title>图片下载_优惠券网</title>
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
<script type="text/javascript" src="/js/reg.js"></script>
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



<script language="javascript" >
		var etime = "";
		//alert("1");
		//统计
		var date = new Date();  
    	date.setTime(date.getTime() + (15 * 60 * 1000));
    	
		var cook = $.cookie('huiduo_p_id'); // 获得cookie
		var tj="tj";
		$.cookie('huiduo_p_id', '<%=id%>', { expires: date }); //设置带时间的cookie
		//alert(cook);
		if(cook=='<%=id%>')
		{
			//cookie不失效不统计
			tj = "";
		}else
		{
			tj = "tj";
		}
		$.ajax({
			type: "get",
		  	url: "/cgi/coupon_tj.jsp",
		  	data: "id=<%=id%>&c=p&v="+tj,
		  	cache: false,
		  	error:function(status){
				//alert("error"+status);
			},
		  	success: function(data){
		
		  }
		}); 

</script>


<body>

<%@ include file="header.jsp" %> 

<div class="good-detail sift-mg">
	<h3 class="h_h3"><span class="title">图片下载</span> </h3>
	<div class="parting-line"></div>
	<div align="center" style="height:auto;padding-top:10px">
	<img src="<%=p%>" width="320" border="0" />
 </div>


 <div align="center" style="height:auto;padding-top:10px">
	在图片上长按屏幕后,即可保存下载图片
 </div>
	 </div>


 <div class="to-top"><a href="javascript:scroll(0,0)" hidefocus="true"><span></span>回顶部</a></div>

<%@ include file="footer.jsp" %> 

</body>
</html>
