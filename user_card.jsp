<%@ page contentType="text/html; charset=utf-8" %><%@ page language="java" import="java.util.*"%><%@ page import="java.sql.*"%><%@ page import = "java.text.SimpleDateFormat" %>
<%@ page language="java" import="com.wsu.basic.util.Tools" %>
<%@ page language="java" import="com.wsu.basic.dbsconnect.*"%>
<%

//request.setCharacterEncoding("GBK");
String c_userid = Tools.RmNull((String)session.getAttribute("c_userid"));
if(c_userid.equals("")||c_userid.length()<1){
	response.sendRedirect("/login.jsp?rturl=/m/user_card.jsp");
	return;
}


int c_mtype = 0;
int count = 0;
String status = "";
String card = "";
String msg = "";
String c_logdate = "";
String cardid = Tools.RmFilter(request.getParameter("cardid"));
String cardpwd = Tools.RmFilter(request.getParameter("cardpwd"));
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
String c_fax = "";
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

		//验证密码分配卡号
		sql = "select count(pwd) from t_card where pwd='"+cardpwd+"'";
		rs = stmt.executeQuery(sql);
		if (rs.next()) {
			count = rs.getInt(1);
		}
		rs.close();
		if (count>0) {
			//激活成功
			sql = "update t_member set t_card=?,c_fax=? where c_userid=?";
		
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, 1);
			pstmt.setString(2, cardid);
			pstmt.setString(3, c_userid);
			pstmt.executeUpdate();
			pstmt.close();
			
			//log
			sql = "insert into t_log (c_uid,c_type,c_appdate,c_ip,c_userid,c_enable,c_act) values "
				+"(0,0,'"+nowtime+"','"+c_ip+"','"+c_userid+"',0,'jihuo')";
			stmt.executeUpdate(sql);
			msg = "您已激活VIP用户成功";
			response.sendRedirect("user_card.jsp");

		}else{
			msg = "您的卡号密码不正确哦";
			card = "0";
			//您的卡号密码不正确哦
			//response.sendRedirect("/m/message.jsp?m=8&c=3&t=3&jf="+c_jf);
		}
		
		
		
	}else
	{


		sql = "select c_jf,c_mtype,c_wt,c_da,c_id,t_card,c_fax from t_member where c_userid='"+ c_userid + "'";
		//查询数据库
		rs = stmt.executeQuery(sql);
		if (rs.next()) {
			c_jf = Tools.RmNull(rs.getString(1));
			c_mtype = rs.getInt(2);
			c_wt = Tools.RmNull(rs.getString(3));
			c_da = Tools.RmNull(rs.getString(4));
			c_id = rs.getString(5);
			card = rs.getString(6);
			c_fax = rs.getString(7);
			
		}else
		{
			response.sendRedirect("/logout.jsp?rturl=/m/message.jsp");
		}
		rs.close();
	}

	if (!card.equals("0")) {
		//已激活
		status = "disabled=\"disabled\"";
		msg = "您已激活VIP用户成功";
	}else
	{
		status = "";

		if (cardid.equals("")||cardpwd.equals("")) {
			msg = "卡号密码不能为空";
			status = "";
		}
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
<title>激活会员卡_3G</title>
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
			cardid:{
				required: true,
				minlength: 6,
				maxlength: 16
				
			},
			cardpwd:{
				required: true,
				minlength: 6,
				maxlength: 16
			}
		},
		messages:{
			cardid:{
				required: "　请填写卡号",
				minlength: "　输入必须是6-16位字符长度",
				maxlength: "　输入必须是6-16位字符长度"
				
			},
			cardpwd:{
				required: "　请填写密码",
				minlength: "　输入必须是6-16位字符长度",
				maxlength: "　输入必须是6-16位字符长度"
			}
		}
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


  <h3 class="h_h3">激活会员卡成为VIP用户<font color="red"></font> </h3>
	<div class="parting-line"></div>
  <form name="member" id="member" action="user_card.jsp?c=2" method="post">
  <input type=hidden name="c_id" id="c_id"  value="<%=c_id%>">
  <input type=hidden name="jf" id="jf"  value="<%=c_jf%>">
  <div class="member_in">
  	<ul>

		<li class="left_j"></li>
        <li class="right_j"><strong><font style='font-size:16px'><%=msg%></font></strong> </li>



    	<li class="left_a"><span class="xing">*</span>会员卡卡号：</li>
        <li class="right_a"><span class="mes"><input type="text" name="cardid" id="cardid" value="<%=c_fax%>" class="intext" maxlength="16" <%=status%> />  </span><span id="old">　</span></li>
       	<li class="left_a"><span class="xing">*</span>会员卡密码：</li>
        <li class="right_a"><span class="mes"><input type="text" name="cardpwd" id="cardpwd" value="" class="intext" maxlength="16" <%=status%> />  </span> <span class="gri"></span></li>

		<li class="left_a"><span class="xing">*</span>您注册账号：</li>
        <li class="right_a"><span class="mes"><%=c_userid%>  </span></li>

        
		<li class="left_a"></li>
        <li class="right_a"><input type="submit" name="submit2"  class="logbtn" value="激活一卡通"></li>
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


