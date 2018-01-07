<%@ page contentType="text/html; charset=utf-8" %><%@ page language="java" import="java.util.*"%><%@ page import="java.sql.*"%><%@ page import = "java.text.SimpleDateFormat" %>
<%@ page language="java" import="com.wsu.basic.util.Tools" %>
<%@ page language="java" import="com.wsu.basic.dbsconnect.*"%>
<%
String s = Tools.RmNull(request.getParameter("s"));
String a = Tools.RmNull(request.getParameter("a"));
String sta = Tools.RmNull(request.getParameter("sta"));
String c_userid = Tools.RmNull((String)session.getAttribute("c_userid"));
String c_uid_tmp = c_userid;
String c_qq = Tools.RmNull((String)session.getAttribute("c_qq"));


Cookie cookies[]=request.getCookies();		// 将适用目录下所有Cookie读入并存入cookies数组中 
Cookie sCookie=null; 
String sName ="";
String sValue ="";
int v=0;
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
				//out.println("c_userid="+c_userid);
				//out.println("sValue="+sValue);
				c_userid = sValue;
				session.setAttribute("c_userid",sValue);
				v++;
			}
		}
	}
}

if(v==0){
	if (s.length()>2) {
		session.setAttribute("c_userid",s);
		c_userid = s;
	}else
	{
		if(c_userid.equals("")||c_userid.length()<2){
			response.sendRedirect("login.jsp");
			return;
		}else
		{
			/*
			int maxAge = 30*60;	//默认30分钟
			if(Tools.isNumber(a)>2000)maxAge = 30*24*60*60;	//一个月
			//System.out.println("2="+maxAge);
			Cookie cook0=new Cookie("138do_uid",c_userid);  
			cook0.setMaxAge(maxAge);
			cook0.setPath("/");
			response.addCookie(cook0);
			*/
		}
	}
}else
{
	if(!c_uid_tmp.equals(""))c_userid = c_uid_tmp;
	session.setAttribute("c_userid",c_userid);
}



String Referer = Tools.RmNull(request.getHeader("Referer"));
int i = 0;
int jf =0;
int c_mtype = 0;
boolean log_qq = false;
String c_logdate = "";
String c_nick = "";
String c_avatar = "";
String tongzhi = "";
String wanshan = "";
String id = ""; //id
String name = ""; //标题
String title = "";
String picname = ""; //图片名
String juan = "";
String c_uid = "";
String c_appdate = "";
String c_act = "";
String c_titles = "";
String youhui = "";
String dianping = "";
Calendar cal  = Calendar.getInstance();
SimpleDateFormat formatter =new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
SimpleDateFormat formatter2 =new SimpleDateFormat("E");
String nowtime = formatter.format(cal.getTime());
String week = formatter2.format(cal.getTime());
String c_ip = request.getRemoteAddr();
String sql ="";


String act[] = new String[2];
act[0] = "c_g";
act[1] = "c_d";
//act[2] = "c_x";
//act[3] = "c_q";

String dp = "";
/*
String dp[] = new String[2];
dp[0] = "c_jid=0";
dp[1] = "c_jid>0";
*/

//基本信息
	String w_tel = "";
	String w_qun="";
	String w_web="";
	String w_mail = "";
	String w_im ="";
	String w_keyword ="";
	String w_name = "";
	String w_icp = "";
	String w_city = "";

Connection conn = null;
Statement stmt = null;
Statement stmt2 = null;
ResultSet rs = null;
ResultSet rs2 = null;
try {
	//c_userid = "dddd";
	//c_userid = new String(c_userid.getBytes("ISO-8859-1"), "GBK");
	c_userid = c_userid.replaceAll(" ","");
	sql = "select c_userid,c_jf,c_mtype,c_logdate,c_nick,c_avatar from t_member where c_userid='"+ c_userid + "'";
	//out.println(sql);
	
	//查询数据库
	DBcon dba = new DBcon();
	conn = dba.getConnection();
	stmt = conn.createStatement();
	stmt2 = conn.createStatement();
	rs = stmt.executeQuery(sql);
	if (rs.next()) {
		jf = rs.getInt(2);
		c_mtype = rs.getInt(3);
		c_logdate = Tools.RmNull(rs.getString(4));
		c_nick = Tools.RmNull(rs.getString(5));
		c_avatar = Tools.RmNull(rs.getString(6));
		session.setAttribute("c_mtype",c_mtype+"");	
	}else
	{
		//response.sendRedirect("/logout.jsp?rturl=/m/message.jsp");
		//判断是否qq登录，插入数据到库
		if (c_qq.equals("1")) {
			log_qq = true;		//qq登录
		}
	}
	rs.close();

	if (log_qq) {
		sql = "insert into t_member (c_userid,c_pass,c_ip,c_regdate,c_logdate,c_jf,c_mtype,c_invite)"
					+" values ('"+c_userid+"','-69186de769a148d36d5ab622a5ccfeee','"+c_ip+"','"+nowtime+"','"+nowtime+"',200,0,'')";
		stmt.executeUpdate(sql);
	}
	if (c_qq.equals("1")) {
		Referer = "http://www.shuidazhe.com/3g/login.jsp";
	}

	if(c_logdate.length()<10)c_logdate = nowtime;
	else c_logdate = c_logdate.substring(0,16);
	
	if(c_nick.length()<2)
	{
		wanshan = "<span style=\"padding-right:30px;\">请完善你的<a href=\"user_update.jsp?jf="+jf+"\" style=\"padding-left:6px;\">个人信息</a></span>";
	}
	if (c_avatar.length() > 10)
		c_avatar = "/pic/" + c_avatar.substring(0, 6) + "/"
				+ c_avatar.substring(6, 8) + "/thumb_" + c_avatar;
	else
		c_avatar = "/m/images/avatar.jpg";
	
	//查询通知
	sql = "select rid,titles from t_news where ctype='305'";
	rs = stmt.executeQuery(sql);
	if (rs.next()) {
		tongzhi = "<a href='/news/"+rs.getString(1)+".html' target=_blank><span class=hei>"
		+rs.getString(2)+"</span></a>";
	}
	rs.close();
	
	//推荐 热门优惠券 6个 取4个
	sql = "select c_sid from t_index where c_txt='listjuan' order by c_id";
	rs = stmt.executeQuery(sql);
	i = 0;
	while (rs.next() && i < 4) {
		id = rs.getString(1);

		//取劵信息,及统计信息
		sql = "select c_id,c_sid,c_titles,c_pname from t_juan where c_id="
				+ id + " ";
		rs2 = stmt2.executeQuery(sql);
		if (rs2.next()) {

			name = Tools.RmNull(rs2.getString(3));
			picname = Tools.RmNull(rs2.getString(4));

		}
		title = name;
		if (name.length() > 12)
			name = name.substring(0, 12) + "..";

		if (picname.length() > 10)
			picname = "/pic/" + picname.substring(0, 6) + "/"
					+ picname.substring(6, 8) + "/thumb_" + picname;
		else
			picname = "/img/nopicb.jpg";

		juan += "<li><a href=\"/coupon/coupon_"
				+ id
				+ ".html\" target=_blank title='"+title+"'><img src=\""+picname+"\" width=\"170\" height=\"95\" border=\"0\" alt='"+title+"'></a>"
				+"<br><div class=\"bt\"><a href=\"/coupon/coupon_"
				+ id
				+ ".html\" target=_blank title='"+title+"'>"+name+"</a></div></li>";
		
			i++;
	}
	rs.close();
	
	//我的动作
	String whereSql = "";
	for(int j=0;j<act.length;j++)
	{
		whereSql = "and c_act='"+act[j]+"'";
		if(j==0)whereSql="and ((c_type=1 and c_act ='c_d') or c_act ='c_g')";
		if(j==1)whereSql="and c_act ='c_d' and c_type=0";
		sql = "select count(c_userid) from t_log where c_enable<9 "+whereSql+" and c_userid='"+c_userid+"'";
		rs = stmt.executeQuery(sql);
		i = 0;
		if(rs.next())
			act[j] = rs.getString(1);
		//System.out.println("1="+sql);
		rs.close();
	}
	//点评数
	//for(int j=0;j<dp.length;j++)
	//{
		
		sql = "select count(c_id) from t_dianping where c_enable<9 and c_adm=1 and c_userid='"+c_userid+"' ";
		rs = stmt.executeQuery(sql);
		i = 0;
		if(rs.next())
			dp = rs.getString(1);
		//System.out.println("1="+dp[j]);
		rs.close();
	//}
	
	//我用过的优惠
	String l_c = "";
	sql = "select c_uid,c_appdate,c_act from t_log where c_enable<9 and (c_act='c_p' or c_act='sms') and c_userid='"+c_userid+"' order by c_id desc";
	rs = stmt.executeQuery(sql);
	i = 0;
	while(rs.next()&&i<4)
	{
		c_uid = rs.getString(1);
		c_appdate = rs.getString(2);
		c_act = rs.getString(3);
		if(c_appdate.length()>16)c_appdate = c_appdate.substring(0,16);
		//取劵信息,及统计信息
		sql = "select c_id,c_sid,c_titles,c_pname from t_juan where c_id="
				+ c_uid + " ";
		rs2 = stmt2.executeQuery(sql);
		if (rs2.next()) {
			c_titles = Tools.RmNull(rs2.getString(3));
		}
		rs2.close();
		if(i==0)l_c="l_c";
		else l_c = "";
		if(c_act.equals("sms"))c_act = "短信下载";
		else c_act = "在线打印";
		if(c_titles.length()>14)c_titles = c_titles.substring(0,14)+"..";
		
		youhui += "<li class=\""+l_c+" kuan\">"+c_appdate+" "+c_act+"了：<a href=\"/coupon/coupon_"+c_uid+".html\" target=_blank>"+c_titles+"</a></li>";
		
		i++;
	}
	rs.close();
	
	
	//我的点评
	c_appdate = "";
	c_uid = "";
	c_act = "";
	sql = "select c_sid,c_jid,c_appdate from t_dianping where c_userid='"+c_userid+"' and c_enable>0 and c_enable<9 order by c_id desc";
	rs = stmt.executeQuery(sql);
	i = 0;
	while(rs.next()&&i<4)
	{
		c_uid = rs.getString(1);
		c_act = rs.getString(2);
		c_appdate = rs.getString(3);
		
		if(c_appdate.length()>16)c_appdate = c_appdate.substring(0,16);
		//取劵 or 商家信息
		sql = "select c_id,c_sname from t_shops where c_id="
				+ c_uid + " ";
		if(Tools.isNumber(c_act)>0)sql = "select c_id,c_titles,c_pname from t_juan where c_id="+c_act;
		rs2 = stmt2.executeQuery(sql);
		if (rs2.next()) {
			c_uid = rs2.getString(1);
			c_titles = Tools.RmNull(rs2.getString(2));
		}
		rs2.close();
		if(i==0)l_c="l_c";
		else l_c = "";
		
		if(Tools.isNumber(c_act)>0)c_act = "/coupon/coupon_"+c_uid+".html#jl";
		else c_act = "/shop/shop_"+c_uid+".html#dps";
		if(c_titles.length()>16)c_titles = c_titles.substring(0,16)+"..";
		
		dianping += "<li class=\""+l_c+" kuan\">"+c_appdate+" 点评了：<a href=\""+c_act+"\" target=_blank>"+c_titles+"</a></li>";
		
		i++;
	}
	rs.close();
	
	i = 0;
	if(Referer.indexOf("login.jsp")>0||Referer.indexOf("m.jsp")>0)
	{
		//判断登录页过来的   更新登录日志，送积分10
		sql = "select count(c_userid) from t_log where c_appdate>'"+nowtime.substring(0,10)+"' and c_userid='"+ c_userid + "' and c_act='lgi'";
		rs = stmt.executeQuery(sql);
		if(rs.next())i = rs.getInt(1);	//判断当天是否登录过，登录过不送积分
		rs.close();
		
		
		if(i>0)
		{
			sql = "update t_member set c_logdate='"+nowtime+"' where c_userid='"+ c_userid + "'";	//只更新登录时间
		}else
		{
			sql = "update t_member set c_jf=c_jf+10,c_logdate='"+nowtime+"' where c_userid='"+ c_userid + "'";//送积分
		}
		stmt.executeUpdate(sql);
		
		sql = "insert into t_log (c_uid,c_type,c_appdate,c_ip,c_userid,c_enable,c_act) values "
			+"(0,0,'"+nowtime+"','"+c_ip+"','"+c_userid+"',0,'lgi')";
		stmt.executeUpdate(sql);
	}
	
	
	//网站基本信息
		sql = "select c_units_des,c_tel,c_mobile,c_web,c_email,c_im,c_main,c_address,c_units_no,c_post from t_user where c_userid='root'";
		rs = stmt.executeQuery(sql);
		if (rs.next()) {

			name = Tools.RmNull(rs.getString(1));	//搜索词  

			w_tel = Tools.RmNull(rs.getString(2));	
			w_qun = Tools.RmNull(rs.getString(3));
			w_web = Tools.RmNull(rs.getString(4));
			w_mail = Tools.RmNull(rs.getString(5));
			w_im = Tools.RmNull(rs.getString(6));
			w_keyword = Tools.RmNull(rs.getString(7));
			w_name = Tools.RmNull(rs.getString(8));
			w_icp = Tools.RmNull(rs.getString(9));
			w_city =Tools.RmNull(rs.getString(10));

		}
		rs.close();
	
	
	
} catch (Exception e){
   	System.out.println("/3g/m.jsp error Exception :" + e);
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

%>

<!DOCTYPE html>
<html>
<head>
<title>我得手机优惠</title>
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


<div class="parting-line"></div>

<ul class="mu_lw">
						<li class="mu_l"> <span class="mu_lh">网站通知：</span> <span class="mu_lc"><%=tongzhi%></span></li>
						<li class="mu_l"> <span class="mu_lh">&nbsp;</span> <span class="mu_lc">欢迎您：<%=c_userid%> 您已<% if (sta.equals("")) {out.print("登录");}else{out.print("注册");}%>手机网站 &nbsp;<img src="<%=c_avatar%>" width=30 height=30></span></li>
		</ul>



	<div class="parting-line"></div>
	<%

if (c_mtype==1||c_mtype==2) {

%>
<a href="javascript:;" class="good-lnk2" style="margin-left:10px"> <span class="tit">商家功能：</span> </a>
<a  class=logbtn href="shangjia_dingdan.jsp" style="margin-left:10px">用户已下订单</a>  
<a  class=logbtn href="shangjia_shuiyong.jsp" >验证优惠券</a> 

<%

	out.println("<br><br><div class=\"parting-line\"></div>"); 
	
}

%>
<a href="javascript:;" class="good-lnk2" style="margin-left:10px"> <span class="tit">用户功能：</span> </a>

<a  class=logbtn href="myhd_dingdan.jsp" style="margin-left:10px">我的订单</a>
<a  class=logbtn href="myhd_youhui.jsp" >我的优惠</a>  
<a  class=logbtn href="myhd_guanzhu.jsp" >我的收藏</a>

<div style="height:10px"></div>

<a  class=logbtn href="myhd_dianping.jsp" style="margin-left:10px">我的点评</a>
<a  class=logbtn href="myhd_jingyan.jsp" >我的晒经验</a>
<a  class=logbtn href="coupon_list.jsp">找优惠券</a>  

<div style="height:10px"></div>

<a  class=logbtn href="user_update.jsp?jf=" style="margin-left:10px">修改我的信息</a>  
<a  class=logbtn href="user_uppass.jsp?jf=" >修改密码</a>
<a  class=logbtn href="user_card.jsp?jf=" >激活会员卡</a>
<div style="height:10px"></div>

<a  class=logbtn href="shop_list.jsp" style="margin-left:10px">搜索商家</a>
<a  class=logbtn href="fenlei.jsp"  >分类选择</a> 
<a  class=logbtn href="diqu.jsp" >位置选择</a>
<div style="height:10px"></div>


<a  class=logbtn href="/logout.jsp?rturl=/3g/index.jsp" style="margin-left:10px">退 出</a>

<br><br><br>
	<div class="parting-line"></div>
	<%=c_userid%><span >上次登录：<%=c_logdate%> （不是您登录的？<a href="/logout.jsp?rturl=/3g/index.jsp">请点这里）</a></span>
	<div class="parting-line"></div>



<div class="to-top"><a href="javascript:scroll(0,0)" hidefocus="true"><span></span>回顶部</a></div>


<!-- footer start -->
<%@ include file="footer.jsp" %> 
<!-- footer end -->

</body>
</html>
