<%@ page contentType="text/html; charset=utf-8" %>
<%@page import="java.sql.*"%>
<%@ page import = "java.text.SimpleDateFormat" %>
<%@ page language="java" import="com.wsu.basic.util.Tools" %>
<%@ page language="java" import="com.wsu.basic.dbsconnect.*"%>
<%!	
public static String RmFilter(String message){

	if ((message == null) || (message.equals(""))) {
      message = "";
    }
	message = message.replace("<",""); 
	message = message.replace(">",""); 
	message = message.replace("'","");
	message = message.replace("\"","");
	//message = message.replace("/","/");
	message = message.replace("%",""); 
	message = message.replace(";",""); 
	message = message.replace("(",""); 
	message = message.replace(")",""); 
	message = message.replace("&",""); 
	message = message.replace("+","_"); 
	return message;
}
%>
<% 
String rturl = RmFilter(request.getParameter("rturl"));		//跳转url

String UserId = RmFilter(request.getParameter("userid"));
String PassWd = Tools.toMD5(RmFilter(request.getParameter("userpass")));
String remember = RmFilter(request.getParameter("remember"));	
String yzm = RmFilter(request.getParameter("yzm"));
String num = RmFilter(request.getParameter("num"));	
String random = (String)session.getAttribute("post_validate_code");	//随机生成验证码
num = num.toLowerCase();


java.util.Date Datenow=new java.util.Date();
SimpleDateFormat formatter =new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
String nowdate = formatter.format(Datenow);

String ErrMsg = "";					//错误信息
String UrlStr = "";		//我的优惠

Cookie cookies[]=request.getCookies();		// 将适用目录下所有Cookie读入并存入cookies数组中 
Cookie sCookie=null; 
String sName ="";
String sValue ="";
String errpass = (String)session.getAttribute("errpass")+"";
int ep = Tools.isNumber(errpass);
int v=0;
//System.out.println("r="+rturl);
if(!rturl.equals("")||rturl.length()>2){
	if(rturl.equals("/index.html"))rturl = "/3g/m.jsp";
	UrlStr = rturl;
}
if(cookies!=null)
{
	for(int jj=0;jj<cookies.length; jj++) // 循环列出所有可用的Cookie 
	{ 
		sCookie=cookies[jj]; 
		sName = sCookie.getName();
		String ce = sCookie.getValue();
		sValue = java.net.URLDecoder.decode(sCookie.getValue());
		if (sName.equals("138do_uid")) {
			if(sValue.length()>1)
			{
				
				//sValue = new String(sValue.getBytes("ISO-8859-1"), "gb2312");
				//System.out.println("sValue2=="+sValue);
				//session.setAttribute("c_userid",sValue);
				//session.setAttribute("UserName",sValue);
				v++;
			}
		}
	}
	if(v==1){
		//System.out.println("22222222222"+session.getAttribute("userid"));
		//response.sendRedirect(UrlStr);
		//return;
	}
}

if (request.getMethod()=="POST"){
	//System.out.println("post=");
	//登录框用户名记录
	Cookie cook1=new Cookie("138do_userid",UserId);  
	cook1.setMaxAge(30*24*60*60);
	cook1.setPath("/");
	response.addCookie(cook1);
	
	int SValue =0;		//success Value
	
	if (UserId.equals("") || PassWd.equals("")){
		ErrMsg = "用户名或密码不能为空！";
		SValue = 0;
	}
	else{
		if (yzm.equals("1")&&!num.equals(Tools.RmNull(random))) {
			SValue = 3; //验证码不正确
		}else{
			int i = -1; //c_mtype字段权限
			boolean  LoginOk = false;
			Connection conn = null;
			Connection conn2 = null;
			Statement stmt = null;
			Statement stmt2 = null;
			ResultSet rs = null;
			ResultSet rs2 = null;
				try {
					String passwd = "";
					String sql = "select c_userid,c_pass,c_mtype from t_member where c_userid='"+ UserId + "'";
					//查询数据库
					DBcon dba = new DBcon();
					conn = dba.getConnection();
					stmt = conn.createStatement();
					rs = stmt.executeQuery(sql);
					if (rs.next()) {
						passwd = Tools.RmNull(rs.getString(2));
						int j = rs.getInt(3);
						if (PassWd.equals(passwd)){i = j;}
						else{
							ep++;
							session.setAttribute("errpass",ep+"");
						}
					}else
					{
						ep++;
						session.setAttribute("errpass",ep+"");
					}

					//i = ts.checkLogUser(UserId,PassWd);
					
				} catch (Exception e){
					SValue = 4;
				   	System.out.println("login.jsp error Exception :" + e);
				}finally
				{
					if (stmt != null) {
						stmt.close();
					}
					if (conn != null) {
						conn.close();
					}
				}
			
				if(i>-1)
				{
					//System.out.println("i=="+i);
					
					if(i==9)
					{
						SValue = 9;	//被屏蔽
					
					}else{
						
						LoginOk=true; //登录成功
						SValue =  1;
						
						session.setAttribute("c_userid",UserId);
						session.setAttribute("c_mtype",i+"");					//权限 级别
 
						int maxAge = 30*60;	//默认30分钟
						
						//判断是否记忆cookie
						if (Tools.RmNull(remember).equals("on")) {
							maxAge = 30*24*60*60;	//一个月
						}
						maxAge = 30*24*60*60;	//一个月
						//System.out.println(maxAge);
						
						Cookie cook0=new Cookie("138do_uid",UserId);  
						cook0.setMaxAge(maxAge);
						cook0.setPath("/");
						response.addCookie(cook0);

						
						/*
						if(UrlStr.length()<3){
							if(i==0)UrlStr = "/3g/m.jsp?s="+UserId+"&a="+maxAge;
							else if(i==1)UrlStr = "/3g/m.jsp?s="+UserId+"&a="+maxAge;
							else if(i==2)UrlStr = "/3g/m.jsp?s="+UserId+"";
						}
						*/
						UrlStr = "/3g/m.jsp?s="+UserId+"&a="+maxAge;

						//out.println("url=="+UrlStr);
						
						
					}
				}else
				{
					LoginOk=false; //登录失败
					SValue = 2;
				}
		}
		//System.out.println(SValue);

		switch(SValue){
			case 0:
				ErrMsg = "<font color=red>登录失败</font>，用户名或密码不能为空！";	
				break;
			case 1:
				session.removeAttribute("errpass");
				response.sendRedirect(UrlStr);	//登录成功跳转
				break;
			case 2:
				ErrMsg = "<font color=red>登录失败</font>，用户名或密码不正确！";
				break;
			case 3:
				ErrMsg = "<font color=red>登录失败</font>，验证码错误！";
				break;
			case 4:
				ErrMsg = "<font color=red>登录失败</font>，发生错误，请稍后重试！";
				break;
			case 9:
				ErrMsg = "<font color=red>登录失败</font>，会员帐号已被禁止，不能访问！";	
				break;
			default:
				ErrMsg = "<font color=red>登录失败</font>，发生未知错误，请重新登录！";
		}
	}
	
	if(ErrMsg.length()>2)ErrMsg = "<div class=\"err fl\"></div><span class=\"red\">"+ErrMsg+"</span>";
	
	
	//System.out.println(UserId+"_"+ep+"_"+yzm+"_"+remember+"_"+yzm);
}	//end if post


%>

<!DOCTYPE html>
<html>
<head>
<title>登录_3G</title>
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

<body>
<%@ include file="header.jsp" %> 



<div class="good-detail sift-mg">
	<h3 class="h_h3"><span class="title">登录</span><span class="title_f">或者 <a href="reg.jsp">注册</a></span><font color="red"></font> </h3>
	<div class="parting-line"></div>
	<div align="center" style="height:330px;padding-top:10px">



<form name="logform" id="logform" method="post" action="login.jsp" class="search">
<input type="hidden" name="rturl" value="<%=rturl%>">
  
  
  
  <ul class="mu_lw">
			<li class="mu_l"> <span class="mu_lh"></span> <span class="mu_lc"><%=ErrMsg%></span></li>
			<li class="mu_l"><span class="mu_lh">* 用户手机： </span> <span class="mu_lc"><input type="text" name="userid" id="userid" size="20" maxlength="20" class="keyword" ></span></li>
			<li class="mu_l"><span class="mu_lh">* 用户密码：</span> <span class="mu_lc"><input type="password" name="userpass" id="userpass" size="20" maxlength="20" class="keyword"></span> </li>

			<%if(ep>2){ %>
			<li class="mu_l"><span class="mu_lh">* 验证码：</span> <span class="mu_lc red price-txt"><div id="yzm"><input type="text" name="num" id="num" size="4" maxlength="4" class="stext"> 
        <span class="tu"><img src="../image/createImg.jsp" id="random" title="换张图" vspace="3" style="cursor:pointer" onClick="javascript:show(document.getElementById('random'))"></span>&nbsp;&nbsp;&nbsp;<span style="padding-left:90px; font-size:12px;">看不清？<a href="javascript:;" onClick="javascript:show(document.getElementById('random'))">换一张</a></span></div></span></li>


        
     <%} %>


			<li class="mu_l"><span class="mu_lh">&nbsp; </span> <span class="mu_lc red price-txt">&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <input type="checkbox" name="remember" id="remember">&nbsp; <span id="md" style="cursor:pointer;color:#666666">一个月内免登陆</span>
        </span></li>
			<li class="mu_l"><span><span class="mu_lh">&nbsp; </span> <span class="mu_lc red"><span class="red"><span id="mdshow" style="display:none" class=red>为了账户安全,请勿在公共电脑上勾选此项！</span></span></span> </span></li>
			
			<li class="mu_l"><span class="mu_lh">&nbsp;</span> <span class="mu_lc q-txt"><input type="submit" name="submit2"  class="logbtn" value="手机登录"></span></li>		
			
<li class="mu_l"><span class="mu_lh">&nbsp;</span> <span class="mu_lc q-txt">&nbsp;</span></li>	
<li class="mu_l"><span class="mu_lh">&nbsp;</span> <span class="mu_lc q-txt">&nbsp;</span></li>	

<li class="mu_l"><span class="mu_lh">&nbsp;</span> <span class="mu_lc q-txt">

<script type="text/javascript" src="http://qzonestyle.gtimg.cn/qzone/openapi/qc_loader.js" data-appid="101208779" data-redirecturi="http://ds.shuidazhe.com/3g/login.jsp" charset="utf-8"></script>

<span id="qqLoginBtn"></span>
<script type="text/javascript">



	//调用QC.Login方法，指定btnId参数将按钮绑定在容器节点中
    QC.Login({
        //btnId：插入按钮的节点id，必选
        btnId: "qqLoginBtn",
        //用户需要确认的scope授权项，可选，默认all
        scope: "all",
        //按钮尺寸，可用值[A_XL| A_L| A_M| A_S|  B_M| B_S| C_S]，可选，默认B_S
        size: "A_M"
    }, function (reqData, opts) {//登录成功
        //根据返回数据，更换按钮显示状态方法
		
		/*
        var dom = document.getElementById(opts['btnId']),
       _logoutTemplate = [
        //头像
            '<span><img src="{figureurl}" class="{size_key}"/></span><br/>',
        //昵称
            '<span style="color:#690;">{nickname}，您好，欢迎使用本站，您已成功接入QQ！</span><br/>',
        //退出
            '<span><a href="/logout.jsp" style="color:#f60;">==点此登出==</a></span>'
                     ].join("");
        dom && (dom.innerHTML = QC.String.format(_logoutTemplate, {
            nickname: QC.String.escHTML(reqData.nickname),
            figureurl: reqData.figureurl
        }));
		*/
		//alert("111"+QC.String.escHTML(reqData.nickname));
		var img1 = QC.String.escHTML(reqData.nickname);
		//alert("img1=="+img1)
	
		if (img1.length>1) {
			window.location.href="/cgi/getqq.jsp?key="+img1+"&type=mob";

			//window.close();	
		}
		/*
		if (img1.length>1) {
			var cook;
			var date = new Date();  
			date.setTime(date.getTime() + (15 * 60 * 1000));  //1 * 24 * 60 * 60 * 1000 1day
			$.cookie('138do_uid', img1, { expires: date }); //设置带时间的cookie 15min 累加sid
			//alert("ok");
					$.ajax({
						type: "get",
						async:false,
						dataType: "json",
						url: "/cgi/getqq.jsp",
						data: "key="+img1 ,
						cache: false,
						error:function(status){
							alert("登录错误或已被禁止访问");
							date.setTime(date.getTime() + (10));
							$.cookie('138do_uid', "", { expires: date }); //设置带时间的cookie 15min 累加sid
						},
						success: function(data){
							//alert(data);
							//alert(img1+"登录成功！");
							//window.location.href='/login.jsp?rturl=<%=rturl%>';		
							self.opener.location.reload();   
							
					  }
					});
		}	
		window.close();	
		*/
    }, function (opts) {//注销成功
        alert('QQ登录 注销成功');
    }
);
    if (QC.Login.check()) {//如果已登录
        //这里可以调用自己的保存接口

        //用JS SDK调用OpenAPI获取用户信息
        var paras = {};
        QC.api("get_user_info", paras)
        //指定接口访问成功的接收函数，s为成功返回Response对象
	    .success(function (s) {
	        //成功回调，通过s.data获取OpenAPI的返回数据
	        //alert("获取用户信息成功！当前用户昵称为：" + s.data.nickname);
	    })
	    //指定接口访问失败的接收函数，f为失败返回Response对象
	    .error(function (f) {
	        //失败回调
	        alert("获取用户信息失败！");
	    })
	    //指定接口完成请求后的接收函数，c为完成请求返回Response对象
	    .complete(function (c) {
	        //完成请求回调
	        //alert("获取用户信息完成！");
			
	    });

	    //调用自己的接口，保存信息
        //......
    }

</script>

	

</span></li>
	</ul>
  
  <div class="parting-line"></div>
	<ul class="mu_lw">
						<li class="mu_l"> <span class="mu_lh"><strong>还没有优惠账户？</strong></span> <span class="mu_lc"><span class="gri">立即 <a href="reg.jsp">注册</a>，仅需30秒</span></span></li>
						
			
					
		</ul>

	
  </form>




	</div>

	
	<div class="parting-line"></div>
	 </div>
<div class="to-top"><a href="javascript:scroll(0,0)" hidefocus="true"><span></span>回顶部</a></div>


<%/*@ include file="footer.jsp" */%>


</body>
</html>




