<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="com.wsu.basic.util.Tools"%>
<%
String uid =  Tools.RmFilter(request.getParameter("uid"));

%>
<!DOCTYPE html>
<html>
<head>
<title>地图_3G</title>
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
<body>


<%@ include file="header.jsp" %>


<div class="good-detail sift-mg">
	<h3 class="h_h3">商家地图显示<font color="red"></font> </h3>
	<div class="parting-line"></div>
	<div align="center" style="height:330px;padding-top:10px">
		<iframe width="290" height="290" scrolling="no" border="0" frameborder="0" style="background:url(/img/load/load.gif) center no-repeat;" src="http://searchbox.mapbar.com/publish/template/template1010/index.jsp?CID=huiduo&tid=tid1000&nid=<%=uid%>&width=290&height=290&control=1&infopoi=1&infoname=1&zoom=12&showSearchDiv=1"></iframe>

	</div>

	
	<div class="parting-line"></div>
	 </div>
<div class="to-top"><a href="javascript:scroll(0,0)" hidefocus="true"><span></span>回顶部</a></div>


<%@ include file="footer.jsp" %>
</body>
</html>