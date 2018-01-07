<%@ page contentType="text/html; charset=utf-8" %><%@ page language="java" import="java.util.*"%><%@ page import="java.sql.*"%><%@ page import = "java.text.SimpleDateFormat" %>
<%@ page language="java" import="com.wsu.basic.util.Tools" %>
<%@ page language="java" import="com.wsu.basic.dbsconnect.*"%>
<%

//request.setCharacterEncoding("GBK");
String c_userid = Tools.RmNull((String)session.getAttribute("c_userid"));
if(c_userid.equals("")||c_userid.length()<1){
	response.sendRedirect("/login.jsp?rturl=/m/user_uppass.jsp");
	return;
}

int c_mtype = 0;
String c_logdate = "";
String ypass = "";
String o_pass = Tools.toMD5(Tools.RmFilter(request.getParameter("o_pass")));
String c_pass = Tools.toMD5(Tools.RmFilter(request.getParameter("c_pass")));
String r_pass = Tools.toMD5(Tools.RmFilter(request.getParameter("r_pass")));
String c_wt = Tools.RmNull(request.getParameter("c_wt"));
String c_da = Tools.RmNull(request.getParameter("c_da"));

String c_id = Tools.RmNull(request.getParameter("c_id"));

String c_jf = Tools.RmNull(request.getParameter("jf"));	//会员积分
String c = Tools.RmNull(request.getParameter("c"));
String Method = Tools.RmNull(request.getMethod());
Method = Method.toLowerCase();

Calendar cal  = Calendar.getInstance();
SimpleDateFormat formatter =new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
String nowtime = formatter.format(cal.getTime());
String c_ip = request.getRemoteAddr();
String sql = "";
String msg = "";
Connection conn = null;
Statement stmt = null;
PreparedStatement pstmt = null;
ResultSet rs = null;
try {
	DBcon dba = new DBcon();
	conn = dba.getConnection();
	stmt = conn.createStatement();
	//c_userid = "dddd";
	if (Method.equals("post")&&c.equals("2")) {

		
		sql = "select c_pass,c_id from t_member where c_userid='"+ c_userid + "'";
		//查询数据库
		rs = stmt.executeQuery(sql);
		if (rs.next()) {
			ypass = Tools.RmNull(rs.getString(1));

		}else
		{
			response.sendRedirect("/logout.jsp?rturl=/m/message.jsp");
		}
		rs.close();
		
		if (r_pass.equals(c_pass)) {
			if (ypass.equals(o_pass)) {
				
				
				sql = "update t_member set c_pass=?,c_wt=?,c_da=? where c_userid=?";
			
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, c_pass);
				pstmt.setString(2, c_wt);
				pstmt.setString(3, c_da);
				pstmt.setString(4, c_userid);
				pstmt.executeUpdate();
				pstmt.close();
				
				//log
				sql = "insert into t_log (c_uid,c_type,c_appdate,c_ip,c_userid,c_enable,c_act) values "
					+"(0,0,'"+nowtime+"','"+c_ip+"','"+c_userid+"',0,'pass')";
				stmt.executeUpdate(sql);
				msg = "密码已修改成功!";
			}else
			{
				msg = "原密码错误,请从新输入";
			}

		}else
		{
			msg = "新密码输入两遍不一致,请从新输入";
		}


		
		
		
		
		//response.sendRedirect("/3g/m.jsp");
		
	}else
	{


		sql = "select c_jf,c_mtype,c_wt,c_da,c_id from t_member where c_userid='"+ c_userid + "'";
		//查询数据库
		rs = stmt.executeQuery(sql);
		if (rs.next()) {
			c_mtype = rs.getInt(2);
			c_wt = Tools.RmNull(rs.getString(3));
			c_da = Tools.RmNull(rs.getString(4));
			c_id = rs.getString(5);
			
		}else
		{
			response.sendRedirect("/logout.jsp?rturl=/m/message.jsp");
		}
		rs.close();
	}
	
} catch (Exception e){
   	System.out.println("/m/user_uppass.jsp error Exception :" + e);
}finally
{
	if (stmt != null) {
		stmt.close();
	}
	if (pstmt!=null) {
		pstmt.close();
	}
	if (conn != null) {
		conn.close();
	}
}
%>

<!DOCTYPE html>
<html>
<head>
<title>账号密码管理_3G</title>
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
<script type="text/javascript" src="/js/jquery.validate.min.js"></script>
<script type="text/javascript" src="/js/huiduo.js"></script>
<script type="text/javascript" src="/js/jquery.cookie.js"></script>
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

<script language="javascript">

	$("#member").validate({
		/*errorLabelContainer: "#messageBox",		//显示错误信息的容器ID
		wrapper: "li",								//包含每个错误信息的容器*/
		rules:{
			o_pass:{
				required: true,
				minlength: 6,
				maxlength: 16
				
			},
			c_pass:{
				required: true,
				minlength: 6,
				maxlength: 16
			},
			r_pass:{
				required: true,
				equalTo: "#c_pass",
				minlength: 6,
				maxlength: 16
			},
			c_wt:{
				required: false,
				minlength: 2,
				maxlength: 30
			},
			c_da:{
				required: false,
				minlength: 2,
				maxlength: 30
			}
		},
		messages:{
			o_pass:{
				required: "　请填写原始旧密码",
				minlength: "　输入必须是6-16位字符长度",
				maxlength: "　输入必须是6-16位字符长度"
				
			},
			c_pass:{
				required: "　请填写新设置密码",
				minlength: "　输入必须是6-16位字符长度",
				maxlength: "　输入必须是6-16位字符长度"
			},
			r_pass:{
				required: "　请填写重复新密码",
				equalTo: "　两次输入的密码不一致",
				minlength: "　输入必须是6-16位字符长度",
				maxlength: "　输入必须是6-16位字符长度"
			},
			c_wt:{
				minlength: "　2-30字之间",
				maxlength: "　2-30字之间"
			},
			c_da:{
				minlength: "　输入2-30字之间",
				maxlength: "　输入2-30字之间"
			}
		}
	});
	

	var msg = false;
	$("#o_pass").blur( function () { 
		var o_pass = $("#o_pass").val();
		if(o_pass.length>5){
			$.ajax({
					type: "get",
					async:false,
					url: "/m/check.jsp",
					data: "c=3&o_pass="+o_pass,
					cache: false,
					error:function(status){
						$("#old").text("　出错了，请联系管理员修改");
						$("#old").attr("class","mes");
						msg = false;
					},
					success: function(data){
						if(data.indexOf("ok")>-1)
						{
							$("#old").text("");
							$("#old").attr("class","");
							msg = true;
						}else if(data.indexOf("error")>-1){
							$("#old").text("　原密码错误");
							$("#old").attr("class","mes");
							msg = false;
						}	
				  }
			});
		}else
		{
			msg = false;
		}
	}); 

	$("#member").submit( function () {
		var o_pass = $("#o_pass").val();
		
		if(o_pass.length>5){
			if (msg) {
				$("#old").text("");
				$("#old").attr("class","");
			}
		}
		return msg;

	}); 

</script>

<style>
.logbtn {
	margin: 0px 0px 0px; border-radius: 5px; border: 1px solid rgb(186, 172, 157); width: 95px; height: 30px; text-align: center; color: rgb(60, 60, 60); line-height: 30px; font-size: 1em; display: inline-block; cursor: pointer; -webkit-border-radius: 5px; -moz-border-radius: 5px;font-size:15px;
}
</style>

<body>



<%@ include file="header.jsp" %>

  
  <div id="myhd_right" style="margin-left:20px">


  <h3 class="h_h3">修改我的密码<font color="red"></font> </h3>

   <form name="member" id="member" action="user_uppass.jsp?c=2" method="post">
  <input type=hidden name="c_id" id="c_id"  value="<%=c_id%>">
  <input type=hidden name="jf" id="jf"  value="<%=c_jf%>">
  <div class="member_in">
  	<ul>
  		<li class="left_j"></li>
	  	<li class="right_j"><h3 class="h_h3"><%=msg%></h3></li>
    	<li class="left_a"><span class="xing">*</span>原始旧密码：</li>
        <li class="right_a"><span class="mes"><input type="password" name="o_pass" id="o_pass" value="" class="intext" maxlength="16" />  </span><span id="old">　</span></li>
       	<li class="left_a"><span class="xing">*</span>新设置密码：</li>
        <li class="right_a"><span class="mes"><input type="password" name="c_pass" id="c_pass" value="" class="intext" maxlength="16" />  </span> <span class="gri">（长度只能在6-16位字符）</span></li>

		<li class="left_a"><span class="xing">*</span>重复新密码：</li>
        <li class="right_a"><span class="mes"><input type="password" name="r_pass" id="r_pass" value="" class="intext" maxlength="16"  />  </span></li>
        
        <li class="left_j"></li>
        <li class="right_j"></li>
        <li class="left_a">密码保护问题：</li>
        <li class="right_a"><span class="mes"><input type="text" name=c_wt id="c_wt" value="<%=c_wt%>" class="intext" maxlength="30" />  </span> <span class="gri">（例如：我的名字。找回密码时需要）</span></li>
        <li class="left_a">密码保护答案：</li>
        <li class="right_a"><span class="mes"><input type="text" name="c_da" id="c_da" value="<%=c_da%>" class="intext" maxlength="30" />  </span></li>
        <li class="left_j"></li>
        <li class="right_j"></li>
        
		<li class="left_a"></li>
        <li class="right_a"><input type="submit" name="submit2"  class="logbtn" value="保存修改"></li>
    </ul>
  </div>
  </form>
  

  </div>
  
<!-- middle end -->

<!-- footer start -->
<%@ include file="footer.jsp" %> 
<!-- footer end -->

</body>
</html>



