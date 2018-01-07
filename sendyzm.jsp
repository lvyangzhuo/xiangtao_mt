<!DOCTYPE html>
<html>
<head>
<title>短信优惠下载</title>
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

<script type="text/javascript">

$().ready(function() { 
	//短信
	
	$("#f1").submit( function () {
		var msg ="";
	  	var q = $("#c_tel").val();
		if(q==""){
			alert("请输入手机号码");
			return false;
		}else if(q!="")
		{
			if(/^[0-9_-]+$/.test(q)){ 
				if(q.length<11){
					alert("请输入正确的手机号码");
					return false;
				}else
				{
					return true;
				}

			}else {
				alert("手机号码只能为数字");
				return false;
			}
		}
	});
	/**/
})


</script>

<body>



<iframe id="upfm" name="upfm" style="display: none;"></iframe>

<%@ include file="header.jsp" %>


<div class="good-detail sift-mg">
	<h3 class="h_h3">获取验证码：<font color="red"></font> </h3>
	<div class="parting-line"></div>

<iframe id="upfm" name="upfm" style="display: none;"></iframe>

<%@ page contentType="text/html; charset=utf-8" %><%@ page import="java.text.SimpleDateFormat"%><%@ page language="java" import="java.util.*"%><%@ page language="java" import="java.io.*"%><%@ page language="java" import="java.sql.*"%><%@ page language="java" import="com.wsu.basic.util.Tools"%><%@ page language="java" import="com.wsu.basic.dbsconnect.*"%>
<%@ page import="java.net.HttpURLConnection"%>
<%@ page import="java.net.URL"%>
<%@ page import="java.net.URLEncoder"%>

<%
request.setCharacterEncoding("GBK");
String jid = Tools.RmNull(request.getParameter("jid"));
String sid = Tools.RmNull(request.getParameter("sid"));
//c_text = new String(c_text.getBytes("utf-8"), "GBK");
//c_fee = new String(c_fee.getBytes("utf-8"), "GBK");
String c_tel = Tools.RmNull(request.getParameter("c_tel"));
String c_text = Tools.RmNull(request.getParameter("c_text"));

String c = Tools.RmNull(request.getParameter("c")); 
Connection con = null;
Statement stmt = null;
ResultSet rs = null;
PreparedStatement pstmt = null;
String sql = "";
String msg = "";
int i = 0;
int count = 0;							//商家允许发送数
int enable = 1;
Calendar cal  = Calendar.getInstance();
SimpleDateFormat formatter =new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
SimpleDateFormat formatter2 =new SimpleDateFormat("E");
String c_appdate = formatter.format(cal.getTime());
String week = formatter2.format(cal.getTime());
int hour = Tools.isNumber(c_appdate.substring(11,13));
String c_ip = request.getRemoteAddr();
String c_titles = "";
String c_sms = "";
String c_etime = "";
String c_enable = "";
String c_mod = "";
int c_jf = 0;
cal.add(Calendar.MINUTE,-5);
String olddate = formatter.format(cal.getTime());

String userid = Tools.RmNull((String)session.getAttribute("c_userid"));
try {
	DBcon dbcon = new DBcon(); //数据库连接
	con = dbcon.getConnection();
	stmt = con.createStatement();
	
	if(c.equals("1"))
	{
		//查询count
		sql = "select c_sid,c_titles,c_sms,c_etime,c_jf,c_enable,c_mod from t_juan where c_id="+Tools.isNumber(jid);
		rs = stmt.executeQuery(sql);
		if(rs.next())
		{
			sid = rs.getString(1);
			c_titles = Tools.RmNull(rs.getString(2));
			c_sms = Tools.RmNull(rs.getString(3));
			c_etime = rs.getString(4);
			c_jf = rs.getInt(5);
			c_enable = Tools.RmNull(rs.getString(6));
			c_mod = Tools.RmNull(rs.getString(7));

			c_etime = c_etime.substring(0,10);
			if(c_etime.indexOf("2099")>-1)c_etime = "长期有效";
			else c_etime = c_etime+"前有效";
		}
		rs.close();

		if (c_mod.equals("3")) {
			//登录会员才能使用
			if (userid.length()<2) {
					out.println("<div align=left>"
				+"请您先登录,才能使用本优惠！<br><br>"
				+"</div>"
				+"<br><div align=center><input type='button' onclick='javascript:history.back(-1);' name='cls' value='返回查看' id='cls' style='width:100px;height:30px;'>&nbsp;&nbsp;&nbsp;</div>");
				return;
			}
		}

		//会员特惠频道优惠券
		/*
		if (c_enable.equals("3")) {
			//查询是否激活卡用户
			sql = "select t_card from t_member where c_userid='"+userid+"'";
			rs = stmt.executeQuery(sql);
			int t_card = 0 ;
			if(rs.next())
			{
				t_card= rs.getInt(1);
			}
			rs.close();

			if (t_card==0) {
				//未激活用户不能使用本优惠
				out.println("<div align=left>"
				+"您还未激活您的一卡通会员卡,不能使用本优惠！<br><br>"
				+"</div>"
				+"<br><div align=center><input type='button' onclick='javascript:history.back(-1);' name='cls' value='返回查看' id='cls' style='width:100px;height:30px;'>&nbsp;&nbsp;&nbsp;</div>");
				return;
			}
		}
		*/


		
		if(c_sms.length()<3)c_sms = c_titles;

		//查询所需积分和用户积分余额
		sql = "select c_jf from t_member where c_userid='"+userid+"'";
		rs = stmt.executeQuery(sql);
		int yejf = 0 ;
		if(rs.next())
		{
			yejf= rs.getInt(1);
		}
		rs.close();


		//查询短信count
		sql = "select c_zip from t_shops where c_id="+sid;
		rs = stmt.executeQuery(sql);
		if(rs.next())
		{
			count = Tools.isNumber(rs.getString(1));
		}
		rs.close();
		if (count>0) {

			//余额积分必须大于所需积分才能下载
			if (yejf>=c_jf) {
				out.println("<form method=post name=f1 id=f1 action='/3g/sendyzm.jsp?c=2'><div align=left>"
						+"<input type=hidden name=c_text value='优惠券@"+c_sms+"【惠多网】'>"
						+"<input type=hidden name=jid value='"+jid+"'>"
						+"<input type=hidden name=sid value='"+sid+"'>"
						+"输入手机号获取：<input type=text name=c_tel id=c_tel maxlength=11 class='smstext'><br>"
						+"<span style='color:#666666;'></span></div>"
						+"<br><div align=center style='width:300px;'><input type=submit name=send id=send value=点击领取  style='width:80px;height:30px;'></div><br></form>");
			}else
			{
				out.println("<div align=left>"
				+"<br>您的积分余额不够下载本优惠券，请先获取足够积分！<br><br>"
				+"</div>"
				+"<br><div align=center><input type='button' onclick='javascript:history.back(-1);' name='cls' value='返回查看' id='cls' style='width:100px;height:30px;'>&nbsp;&nbsp;&nbsp;</div>");
			}
		}else
		{
				out.println("<div align=left>"
				+"<br>本商家短信条数已用完，商家充值后才可下载！<br><br>"
				+"</div>"
				+"<br><div align=center><input type='button' onclick='javascript:history.back(-1);' name='cls' value='返回查看' id='cls' style='width:100px;height:30px;'>&nbsp;&nbsp;&nbsp;</div>");
		
		}
		//System.out.println(sql);
		//stmt.executeUpdate(sql);
	
	}else if(!jid.equals("")&&c.equals("2"))
	{
		c_tel = c_tel.trim(); 
        String regex=  "^1\\d{10}$";
        boolean isMob = c_tel.matches(regex);
		if(c_tel.equals("")||c_tel.length()<11||!isMob){
			out.println("<div align=center style='width:300px;'>手机号码错误请检查<br><a href='showinfo.jsp?id="+jid+"'>返回</a></div>");
			return;
		}
		
		//三分钟之类不能下载同一条优惠
		i = 0;
		sql = "select count(c_id) from t_smslog where c_tel='"+c_tel+"' and c_jid="+Tools.isNumber(jid)
		+" and c_appdate>='"+olddate+"' and c_appdate<='"+c_appdate+"'";
		//System.out.println(sql);
		rs = stmt.executeQuery(sql);
		if(rs.next())
		{
			i = rs.getInt(1);
		}
		rs.close();
		if(i>0)
		{
			out.println("<div align=center style='width:300px;'>验证码已领取，请进入我的优惠查看！<br><a href='myhd_youhui.jsp'>我的优惠</a></div>");
			return;
		}
		
		c_etime = c_appdate.substring(0,10);
		sql = "select count(c_id) from t_smslog where c_tel='"+c_tel+"' and c_appdate>'"+c_etime+"' and c_appdate<'"+c_etime+" 23:59:00'";
		rs = stmt.executeQuery(sql);
		if(rs.next())
		{
			i = rs.getInt(1);
		}
		rs.close();
		//System.out.println(i);
		
		if(i<5){

		//查询
		sql = "select c_sms,c_jf from t_juan where c_id="+Tools.isNumber(jid);
		rs = stmt.executeQuery(sql);
		if(rs.next())
		{
			c_sms = Tools.RmNull(rs.getString(1));
			c_jf = rs.getInt(2);
		}
		rs.close();
		
		//发送内容
		
		String content = "优惠券@榕树下:凭此短信缘分天空KTV七折优惠，2010-12-31前有效。"; 
		c_text = "手机在线领取验证码:";
		
		
		String inputline = "100";
		
			if(inputline.equals("100"))
			{
				//System.out.println(enable+"_"+c_text+"_fee:"+c_fee+"_xx:"+xx);
				sql = "insert into t_smslog (c_jid,c_sid,c_text,c_tel,c_appdate,c_ip,c_userid) "
				+"values (?,?,?,?,?,?,?)";
				pstmt = con.prepareStatement(sql);
				pstmt.setInt(1, Tools.isNumber(jid));
				pstmt.setInt(2, Tools.isNumber(sid));
				pstmt.setString(3, "3G_"+c_text);
				pstmt.setString(4, c_tel);
				pstmt.setString(5, c_appdate);
				pstmt.setString(6, c_ip);
				pstmt.setString(7, userid);
				pstmt.executeUpdate();
				pstmt.close();

				sql = "update t_juan_tj set c_p=c_p+1,c_v=c_v+1 where c_jid="+Tools.isNumber(jid);
				stmt.executeUpdate(sql);

				//查询短信count
				sql = "select c_zip from t_shops where c_id="+sid;
				rs = stmt.executeQuery(sql);
				if(rs.next())
				{
					count = Tools.isNumber(rs.getString(1));
					count = count-1;
				}
				rs.close();
				
				//商家短信条数减1
				sql = "update t_shops set c_zip="+count+" where c_id="+Tools.isNumber(sid);
				stmt.executeUpdate(sql);

				
				//用户积分减去所需积分
				sql = "update t_member set c_jf=c_jf-"+c_jf+" where c_userid='"+userid+"'";
				stmt.executeUpdate(sql);

				
				sql = "insert into t_log (c_uid,c_type,c_appdate,c_ip,c_userid,c_enable,c_act) values "
					+"("+Tools.isNumber(jid)+",1,'"+c_appdate+"','"+c_ip+"','"+userid+"',0,'sms')";
				stmt.executeUpdate(sql);

				out.println("<div align=center style='width:300px;'>验证码已领取，请进入我的优惠查看！<br><a href='myhd_youhui.jsp'>我的优惠</a></div>");
			}else
			{
				/*
				out.print("短信发送失败，请您稍后再试！<br><br>"
						+"<div align=center><input type='button' onclick='CloseWin()' name='cls' value='关闭窗口' id='cls' style='width:100px;height:30px;'></div>");
						*/
				out.println("<div align=center style='width:300px;'>发送失败,请返回重试<br><a href='showinfo.jsp?id="+jid+"'>返回</a></div>");
				
			}
		
		}else
		{
			/*
			out.print("每个号码每天限发5条优惠券，你的号码已经用完限额！<br><br>"
					+"<div align=center><input type='button' onclick='CloseWin()' name='cls' value='关闭窗口' id='cls' ></div>");
			*/
			out.println("<div align=center style='width:300px;'>每个号码每天限发5条优惠券，你的号码已经用完限额！<br><a href='showinfo.jsp?id="+jid+"'>返回</a></div>");
			
		}
	}
} catch (Exception e) {
	System.out.println("/3g/sendsms.jsp error :" + e);
	out.print("sendsms error"); 
} finally {

	if (stmt != null) {
		stmt.close();
	}
	if (pstmt!=null) {
		pstmt.close();
	   }
	if (con != null) {
		con.close();
	}

}
%>

	<div class="parting-line"></div>

	 </div>

<%@ include file="footer.jsp" %>

</body>
</html>