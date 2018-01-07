<%@ page contentType="text/html; charset=utf-8" %><%@ page language="java" import="java.util.*"%><%@ page import="java.sql.*"%><%@ page import = "java.text.SimpleDateFormat" %>
<%@ page language="java" import="com.wsu.basic.util.Tools" %>
<%@ page language="java" import="com.wsu.basic.dbsconnect.*"%>
<%@ page import="com.wsu.web.sql.DataTurnPage"%>
<%
//request.setCharacterEncoding("GBK");
String c_userid = Tools.RmNull((String)session.getAttribute("c_userid"));
if(c_userid.equals("")||c_userid.length()<1){
	response.sendRedirect("/login.jsp?rturl=/m/");
	return;
}
String c = Tools.RmNull(request.getParameter("c"));
String Method = Tools.RmNull(request.getMethod());
Method = Method.toLowerCase();

String act = Tools.RmNull(request.getParameter("act"));
String stime = Tools.RmNull(request.getParameter("stime"));
String etime = Tools.RmNull(request.getParameter("etime"));

String c_id= "";
String c_sid = "";
String c_titles = "";
String c_sname = "";
String c_pname = "";
String c_act = "";
String c_appdate = "";
String str = "";
String jf = "";	//会员积分
String xinxi = "";
String xinxi2 = "";
String link1 = "";
String link9 = "";
String links = "";
String linkn = "";
String c_tel = "";
String yzm = "";
String sjsj = "";
int count = 0;			//总记录数
int pagenum = 0; 		//总页数
int shownum = 10; 		//每页显示篇数
int pagenow = 0; 		//当前页码

String snpage = request.getParameter("npage");

if (snpage != null)
	pagenow = Tools.isNumber(snpage);
if (pagenow < 1)
	pagenow = 1;

Connection conn = null;
Statement stmt = null;
ResultSet rs = null;
String sql = "";
String whereSql = "";
Calendar cal  = Calendar.getInstance();
SimpleDateFormat formatter =new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
String c_ip = request.getRemoteAddr();

String nowdate = formatter.format(cal.getTime()).substring(0,10);
cal.add(Calendar.DATE,-1392);
String olddate = formatter.format(cal.getTime()).substring(0,10);
String c_enable = "";

if (request.getMethod() == "GET") {
	//name = new String(name.getBytes("ISO-8859-1"), "GBK");
}

//检索条件
if(!act.equals(""))
{
	whereSql = "and c_act ='"+act+"' ";
}else
{
	whereSql = "and (c_act ='sms' or c_act ='c_p')";
}
if(stime.length()<5||etime.length()<5)
{
	stime = olddate;
	etime = nowdate;
	//System.out.println("aa");
}

try {
	DBcon dba = new DBcon();
	conn = dba.getConnection();
	stmt = conn.createStatement();
	
	sql = "select c_jf from t_member where c_userid='"+c_userid+"'";
	rs = stmt.executeQuery(sql);
	if(rs.next())jf = rs.getString(1);
	rs.close();
	
	sql = "select c_uid,c_appdate,c_act,c_enable from t_log where c_enable<9 and c_userid='"+c_userid+"' "+whereSql+" order by c_id desc";

	//out.println(sql); 
	
	
	DataTurnPage tp = new DataTurnPage();
	//		@return n*m 1 sql语句 2 本页显示条数 3 第几页
	tp.selectTurnPage(sql,shownum,pagenow);
	
	List s = new ArrayList();
	s = tp.getRes();			//获得结果集
	pagenum = tp.getPagenum();	//获得总页数
	count = tp.getCount();		//获得总记录数
	
	//获得结果集字段
	Object[] obj = null;
	for (int i = 0; i < s.size(); i++) {

		obj = (Object[]) s.get(i);
		
		c_id =(String)obj[0];
		c_appdate = (String)obj[1];
		c_act = (String)obj[2];
		c_enable = (String)obj[3];
		if (c_enable.equals("0")) {
			c_enable = "<font color='green'>未使用</font>";
		}else
		{
			c_enable = "<font color='red'>已使用</font>";
		}
		
		//if(c_sname.length()>15)c_sname = c_sname.substring(0,15)+"..";

		//查手机号验证码
		
		sql = "select c_tel from t_smslog where c_appdate='"+c_appdate+"'";
		rs = stmt.executeQuery(sql);
		if(rs.next())
		{
			c_tel = rs.getString(1);

		}else
		{
			c_tel = "13700000000";
		}
		rs.close();
		//获取验证码
		sjsj = c_appdate.substring(11,13)+""+c_appdate.substring(14,16)+"";
		int sjh = Tools.isNumber(c_tel.substring(7,11));
			//Random ra = new Random();
			//sjh = sjh+ra.nextInt(20);
		sjh = sjh+Tools.isNumber(sjsj);
		
		//out.println("222"); 
		
		yzm = ""+sjh;
		/**/

		
		//查劵信息
		sql = "select c_sid,c_titles,c_pname,c_sname from t_juan where c_id="+c_id;
		rs = stmt.executeQuery(sql);
		if(rs.next())
		{
			c_sid = rs.getString(1);
			c_titles = rs.getString(2);
			c_pname = rs.getString(3);
			c_sname = rs.getString(4);
		}
		rs.close();
		if(c_appdate.length()>16)c_appdate = c_appdate.substring(0,16);
		if (c_pname.length() > 10)
			c_pname = "/pic/" + c_pname.substring(0, 6) + "/"
					+ c_pname.substring(6, 8) + "/thumb_" + c_pname;
		else
			c_pname = "/img/nopicb.jpg";
		
		if(c_act.equals("sms")){c_act = "验证码";}
		else {
			c_act = "图片下载";
			c_tel = "";
			yzm = "";
		}
		str += "<tr>"
			+ "    <td height=\"50\" class=\"bgtd tit2\">"
			+"<a href=\"showinfo.jsp?id="+c_id+"\" ><img src=\""+c_pname+"\" width=\"70\" height=\"40\" border=\"0\" /></a>"
			+" </td>"
			+ "    <td align=\"center\" class=\"bgtd\">"+c_tel+"</td>"
			+ "    <td align=\"center\" class=\"bgtd\">"+c_act+"</td>"
			+ "    <td align=\"center\" class=\"bgtd2\">"+c_appdate.replaceAll("-","/")+"</td>"
			+ "  </tr><tr><td colspan=4>&nbsp;<B>验证码：&nbsp;<span style='font-size:12px;color:red;'>"+yzm+"</span></B>&nbsp;&nbsp;&nbsp;使用状态："+c_enable+"</td></tr><tr><td colspan=2><a href=\"showinfo.jsp?id="+c_id+"\">"+c_titles+"</a></td><td colspan=2>商家:<a href=\"showshop.jsp?id="+c_sid+"\"  class=\"hei\">"+c_sname+"</a></td></tr><tr><td colspan=4>&nbsp;</td></tr>";

	}
	if(s.size()==0)str = "<tr>"
			+ "    <td height=\"70\" class=\"bgtd tit2\" colspan=4>　　您还没有使用过优惠，<a href='coupon_list.jsp'>快来看看吧</a></td>"
			+ "  </tr>";
	/*
	if (Method.equals("post")&&c.equals("2")) {
		
		sql = "update t_member set c_cname=?,c_faren=?,c_license=?,c_pname=?,c_address=?"
				+",c_zip=?,c_tel=?,c_fax=? where c_userid=?";
		//response.sendRedirect("/m/message.jsp?m=3&c=2&t=2&jf=");
	}
	*/
	shownum = pagenow - 1;
	
} catch (Exception e){
   	System.out.println("/m/myhd_youhui.jsp error Exception :" + e);
}finally
{
	if (stmt != null) {
		stmt.close();
	}
	if (conn != null) {
		conn.close();
	}
}
xinxi = "<em>"+count+"</em> 条记录  <em>"+pagenow+"</em>/<em>"+pagenum+"</em>";
xinxi2 = "<em>"+pagenow+"</em>/ "+pagenum+"";

//屏蔽多余翻页
if (pagenow == 1) {
	links = "javascript:;";
	link1 = "javascript:;";
}
if (pagenow == pagenum) {
	linkn = "javascript:;";
	link9 = "javascript:;";
}

if (pagenow >= pagenum)
	pagenow = pagenum;
if (pagenow < pagenum)
	pagenow = pagenow + 1;

if(links.indexOf("javascript")<0)links = "myhd_youhui.jsp?npage="+ shownum + "&act=" + act + "&stime="+stime+"&etime="+etime+"&c="+c+"";
if(linkn.indexOf("javascript")<0)linkn = "myhd_youhui.jsp?npage="+ pagenow + "&act=" + act + "&stime="+stime+"&etime="+etime+"&c="+c+"";
if(link1.indexOf("javascript")<0)link1 = "myhd_youhui.jsp?npage=1&act=" + act + "&stime="+stime+"&etime="+etime+"&c="+c+"";
if(link9.indexOf("javascript")<0)link9 = "myhd_youhui.jsp?npage="+ pagenum + "&act=" + act + "&stime="+stime+"&etime="+etime+"&c="+c+"";
%>

<!DOCTYPE html>
<html>
<head>
<title>我用过的优惠_3G</title>
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
	margin: 0px 0px 0px; border-radius: 5px; border: 1px solid rgb(186, 172, 157); width: 95px; height: 30px; text-align: center; color: rgb(60, 60, 60); line-height: 30px; font-size: 1em; display: inline-block; cursor: pointer; -webkit-border-radius: 5px; -moz-border-radius: 5px;font-size:15px;
}
</style>

<body>



<%@ include file="header.jsp" %>


<h3 class="h_h3">我用过的优惠<font color="red"></font> </h3>

<form name="list" action="myhd_youhui.jsp?act=<%=act%>&stime=<%=stime%>&etime=<%=etime%>&c=<%=c%>" method="get">
  <div class="list">
  <div class="xinxi" style="font-size:12px">
  <div class="sou">
    　使用方式：<select name="act" id="act" class="sel">
    <option value="" selected>全部</option>
    <option value="sms">验证码</option>
    <option value="c_p">图片下载</option>
    </select>
    　<input type="submit" name="cha" id="cha" value="查询" class="logbtn" />
   
    </div>
    
  	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="biaoge">
  <tr class="biaoge_top" >
    <td width="30%" height="37" class="bgtm"><B>优惠券名称</B></td>
    <td width="20%" class="bgtm"><B>手机号</B></td>
    <td width="20%" class="bgtm"><B>方式</B></td>
    <td width="30%"  class="bgtm2"><B>领取时间</B></td>
  </tr>
  <%=str%>
  <tr>
  	<td class="bgtm"></td>
    <td class="bgtm"></td>
    <td class="bgtm"></td>
    <td class="bgtm2"></td>
  </tr>
</table>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td height="35">　<%=xinxi%></td>
    <td align="right"><a href="<%=link1%>" class="fy">首页</a>  |  <a href="<%=links%>" class="fy">上一页</a>  |  <a href="<%=linkn%>" class="fy">下一页</a>  |  <a href="<%=link9%>" class="fy">尾页</a></td>
  </tr>
</table>

</div>
 
 
  </div>
  </form>




<div class="to-top"><a href="javascript:scroll(0,0)" hidefocus="true"><span></span>回顶部</a></div>


<!-- footer start -->
<%@ include file="footer.jsp" %> 
<!-- footer end -->

</body>
</html>


<script type="text/javascript" src="/m/js/myhd.js"></script>