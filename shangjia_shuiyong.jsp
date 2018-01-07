<%@ page contentType="text/html; charset=utf-8" %><%@ page language="java" import="java.util.*"%><%@ page import="java.sql.*"%><%@ page import = "java.text.SimpleDateFormat" %>
<%@ page language="java" import="com.wsu.basic.util.Tools" %>
<%@ page language="java" import="com.wsu.basic.dbsconnect.*"%>
<%@ page import="com.wsu.web.sql.DataTurnPage"%>
<%
//request.setCharacterEncoding("GBK");

String Referer = Tools.RmNull(request.getHeader("Referer"));

String c_userid = Tools.RmNull((String)session.getAttribute("c_userid"));
if(c_userid.equals("")||c_userid.length()<1){
	response.sendRedirect("/login.jsp?rturl=/m/shangjia.jsp");
	return;
}
String mtype = Tools.RmNull((String)session.getAttribute("c_mtype"));
if(Tools.isNumber(mtype)==0)
{
	response.sendRedirect("/m/index.jsp");
	return;
}
String c = Tools.RmNull(request.getParameter("c"));
String rid = Tools.RmNull(request.getParameter("rid"));
String Method = Tools.RmNull(request.getMethod());
Method = Method.toLowerCase();

String act = Tools.RmNull(request.getParameter("act"));
String stime = Tools.RmNull(request.getParameter("stime"));
String etime = Tools.RmNull(request.getParameter("etime"));

String c_id= "";
String c_sid = "";
String c_jid = "";
String name = "";
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
Statement stmt2 = null;
ResultSet rs = null;
ResultSet rs2 = null;
String sql = "";
String whereSql = "";
Calendar cal  = Calendar.getInstance();
SimpleDateFormat formatter =new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
String c_ip = request.getRemoteAddr();

String nowday = formatter.format(cal.getTime());
String nowdate = formatter.format(cal.getTime()).substring(0,10);
cal.add(Calendar.DATE,-1300);
String olddate = formatter.format(cal.getTime()).substring(0,10);
String nowtime = "";
String c_tel = Tools.RmNull(request.getParameter("tel"));
String mob = "";
String enable = "";
String btn = "";
String cid = "";
String yzm = "";
String sjsj = "";

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
ArrayList sid = new ArrayList();
ArrayList jid = new ArrayList();
try {
	DBcon dba = new DBcon();
	conn = dba.getConnection();
	stmt = conn.createStatement();
	stmt2 = conn.createStatement();
	
	sql = "select c_jf,c_id from t_member where c_userid='"+c_userid+"'";
	rs = stmt.executeQuery(sql);
	if(rs.next()){
		jf = rs.getString(1);
		c_id = rs.getString(2);
	}
	rs.close();
	
	//取 绑定商家sid 和 优惠券id
	sql = "select c_sid from t_bang where c_mid="+c_id+" ";
	
	rs = stmt.executeQuery(sql);
	while (rs.next()) {
		c_sid = rs.getString(1);
		sid.add(c_sid);
		//取劵id信息 
		sql = "select c_id from t_juan where c_sid="
				+ c_sid + " ";
		rs2 = stmt2.executeQuery(sql);
		while (rs2.next()) {
			c_jid = rs2.getString(1);
			
			jid.add(c_jid);
		}
		rs2.close();
	
	}
	rs.close();
	
	//构造sql 条件
	String whereJid = "";
	for(int j=0;j<jid.size();j++)
	{
		
		whereJid += " or c_uid="+jid.get(j)+"";
	}
	if(whereJid.length()>3)whereJid = whereJid.substring(3,whereJid.length());
	if(whereJid.length()>3)whereJid = "and ("+whereJid+")";
	if(jid.size()==0)whereJid = "and (c_uid=-1)";
	
	sql = "select c_uid,c_appdate,c_act,c_userid,c_enable,c_id from t_log where c_enable<9 and c_appdate>='"
		+stime+"' and c_appdate<='"+etime+" 23:59:00' "+whereSql+" "+whereJid+" order by c_id desc";



	if (!c_tel.equals("")) {
		sql = "select t_log.c_uid,t_log.c_appdate,t_log.c_act,t_log.c_userid,t_log.c_enable,t_log.c_id from t_log,t_smslog where c_enable<9 and t_smslog.c_tel='"+c_tel+"' and t_log.c_appdate>='"
		+stime+"' and t_log.c_appdate<='"+etime+" 23:59:00' and t_log.c_appdate=t_smslog.c_appdate "+whereSql+" "+whereJid+" order by t_log.c_id desc";
	}
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
		name = Tools.RmNull((String)obj[3]);
		enable = Tools.RmNull((String)obj[4]);
		cid = Tools.RmNull((String)obj[5]);
		if(name.length()==0)name = "游客";
		nowtime = c_appdate;
		
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
		
		if(c_act.equals("sms")){
			c_act = "短信";
			//查手机号
			sql = "select c_tel from t_smslog where c_jid="+c_id+" and c_appdate='"+nowtime+"'";
			rs = stmt.executeQuery(sql);
			if(rs.next())
			{
				mob = rs.getString(1);
			}
			rs.close();
			
			sjsj = nowtime.substring(11,13)+""+nowtime.substring(14,16)+"";
			
			//out.println("sjsj111aaa="+sjsj); 
			

			int sjh = Tools.isNumber(mob.substring(7,11));
			
			//Random ra = new Random();
			//sjh = sjh+ra.nextInt(20);
			sjh = sjh+Tools.isNumber(sjsj);

			yzm = ""+sjh;

			

			//状态
			if (enable.equals("0")) {
				btn = "<input type='button' name='status' value='未使用' onClick=\"{if(confirm('确定已使用吗?')){window.location.href='shangjia_shuiyong.jsp?c=2&rid="+cid+"';return true;}return false;}\">";
			}else if (enable.equals("1")) {
				btn = "<font color=green>已用</font>";

				//查使用时间
				sql = "select email from t_email where id="+cid+"";
				rs = stmt.executeQuery(sql);
				if(rs.next())
				{
					c_appdate = rs.getString(1);
					if (c_appdate.length()>16) {
						c_appdate = c_appdate.substring(0,16);
					}
				}
				rs.close();
			}
		}
		else {
			c_act = "打印";
			mob = "";
			btn = "";
			yzm = "";
		}

		
		str += "<tr>"
			+ "    <td height=\"70\" class=\"bgtd tit2\"><a href=\"/coupon/coupon_"+c_id+".html\" target=_blank style='font-size:12px'>"+c_titles+"</a></td>"
			+ "    <!-- <td align=\"center\" class=\"bgtd\">"+name+"</td> -->"
			+ "    <td align=\"center\" class=\"bgtd\">"+mob+"</td>"
			+ "    <td align=\"center\" class=\"bgtd\" style='font-size:11px'>"+c_act+"</td>"
			+ "    <td align=\"center\" class=\"bgtd\">"+yzm+"</td>"
			+ "    <!-- <td align=\"center\" class=\"bgtd\">"+c_appdate+"</td> -->"
			+ "    <td align=\"center\" class=\"bgtd2\">"+btn+"</td>"
			+ "  </tr>";

	}
	
	
	if (c.equals("2")) {
		if(Referer.indexOf("?")>-1)Referer = Referer.substring(Referer.indexOf("?")+1,Referer.length());
		else Referer = "shangjia_shuiyong.jsp";

		sql = "update t_log set c_enable=1 where c_id="+rid;

		
		stmt.executeUpdate(sql);

		sql = "insert into t_email(id,email) values ("+rid+",'"+nowday+"')";
		stmt.executeUpdate(sql);

		//System.out.println("sql=="+sql);
		
		response.sendRedirect("shangjia_shuiyong.jsp?"+Referer);
	}
	
	shownum = pagenow - 1;
	
} catch (Exception e){
   	System.out.println("/m/shangjia_shuiyong.jsp error Exception :" + e);
}finally
{
	if (stmt != null) {
		stmt.close();
	}
	if (stmt2 != null) {
		stmt2.close();
	}
	if (conn != null) {
		conn.close();
	}
}
xinxi = "<!-- 共有 <em>"+count+"</em> 条使用记录，当前 -->第 <em>"+pagenow+"</em> 页，共 <em>"+pagenum+"</em> 页";
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

if(links.indexOf("javascript")<0)links = "shangjia_shuiyong.jsp?npage="+ shownum + "&act=" + act + "&stime="+stime+"&etime="+etime+"&c="+c+"";
if(linkn.indexOf("javascript")<0)linkn = "shangjia_shuiyong.jsp?npage="+ pagenow + "&act=" + act + "&stime="+stime+"&etime="+etime+"&c="+c+"";
if(link1.indexOf("javascript")<0)link1 = "shangjia_shuiyong.jsp?npage=1&act=" + act + "&stime="+stime+"&etime="+etime+"&c="+c+"";
if(link9.indexOf("javascript")<0)link9 = "shangjia_shuiyong.jsp?npage="+ pagenum + "&act=" + act + "&stime="+stime+"&etime="+etime+"&c="+c+"";
%>

<!DOCTYPE html>
<html>
<head>
<title>验证优惠券_3G</title>
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
  
  <div id="myhd_right">

  <div class="lefttop"></div>
  <div class="titles">
  	<ul>
    	<li ><strong class="dabt">谁用过我的优惠</strong></li>
        <li class="more"></li>
    </ul>
  </div>
  <form name="list" action="shangjia_shuiyong.jsp?act=<%=act%>&stime=<%=stime%>&etime=<%=etime%>&c=<%=c%>" method="get">
  <div class="list">
  <div class="xinxi" style="font-size:12px">
  <div class="sou">使用时间： <input type="text" name="stime" id="stime" value="<%=stime%>" class="intext" style="width:80px"/>
  到 <input type="text" name="etime" id="etime" value="<%=etime%>" class="intext" style="width:80px"/>
    　<!-- <br>使用方式：<select name="act" id="act" class="sel">
    <option value="" selected>全部</option>
    <option value="sms">短信</option>
    <option value="c_p">打印</option>
    </select>  -->
	　
	<br>手机号码：<input type="text" name="tel" id="tel" value="<%=c_tel%>" class="intext" maxlength="11" style="width:100px"/>
    　<input type="submit" name="cha" id="cha" value="查询" class="sbtn" />
    <!-- <span style="padding-left:120px;position:relative;top:5px"><%=xinxi2%>　<a href="<%=links%>" class="hei">上一页</a>　|　<span style="position:relative;*top:1px"><a href="<%=linkn%>" class="hei">下一页</a></span></span> -->
    </div>
    <script>$("#act").val("<%=act%>");</script>
  	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="biaoge">
  <tr class="biaoge_top">
    <td width="35%" height="37" class="bgtm">优惠券名称</td>
    <!-- <td width="12%" class="bgtm">使用人</td> -->
	<td width="12%" class="bgtm">手机号</td>
    <td width="10%" class="bgtm">方式</td>
	<td width="15%" class="bgtm">验证码</td>
    <!-- <td width="18%"  class="bgtm">使用时间</td> -->
	<td width="10%" class="bgtm2">状态</td>
  </tr>
  <%=str%>
  <tr>
  	<td class="bgtm"></td>
    <td class="bgtm"></td>
    <td class="bgtm"></td>
	<td class="bgtm"></td>
	<td class="bgtm"></td>
	<td class="bgtm"></td>
    <td class="bgtm2"></td>
  </tr>
</table>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td height="35">　<%=xinxi%></td>
    <td align="right"><a href="<%=link1%>" class="fy">首页</a>  |  <a href="<%=links%>" class="fy">上一页</a>  |  <a href="<%=linkn%>" class="fy">下一页</a> </td>
  </tr>
</table>

</div>
 
 
  </div>
 <div  class="leftbm"></div>
  </form>

  

  </div>
  



  
<div class="to-top"><a href="javascript:scroll(0,0)" hidefocus="true"><span></span>回顶部</a></div>


<!-- footer start -->
<%@ include file="footer.jsp" %> 
<!-- footer end -->

</body>
</html>

<script type="text/javascript" src="/m/js/myhd.js"></script>