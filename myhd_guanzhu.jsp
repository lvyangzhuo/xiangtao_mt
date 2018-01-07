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
String query = Tools.RmNull(request.getQueryString()).replaceAll("&","_");
query = query.replaceAll("#cc=delgz","");
query = query.replaceAll("#query=","");
String c = Tools.RmNull(request.getParameter("c"));
String Method = Tools.RmNull(request.getMethod());
Method = Method.toLowerCase();

String act = Tools.RmNull(request.getParameter("act"));
String stime = Tools.RmNull(request.getParameter("stime"));
String etime = Tools.RmNull(request.getParameter("etime"));
String id= "";
String c_id= "";
String c_sid = "";
String c_titles = "";
String c_sname = "";
String c_pname = "";
String c_act = "";
String c_appdate = "";
String c_address = "";
String c_tel = "";
String str = "";
String jf = "";	//会员积分
String xinxi = "";
String xinxi2 = "";
String link1 = "";
String link9 = "";
String links = "";
String linkn = "";
String c_link = "";
String c_type = "";
String c_hao = "";
String c_dps = "";
String c_map = "";
String c_jnum = "";
String hz = "";
int star = 0;

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


if (request.getMethod() == "GET") {
	//name = new String(name.getBytes("ISO-8859-1"), "GBK");
}

//检索条件
if(!act.equals(""))
{
	if(Tools.isNumber(act)==0)whereSql = "and c_act ='c_g'";	//商家关注
	else if(Tools.isNumber(act)==1)whereSql = "and c_type=1 and c_act ='c_d' ";	//劵关注
}else
{
	whereSql = "and ((c_type=1 and c_act ='c_d') or c_act ='c_g')";
}
if(stime.length()<5||etime.length()<5)
{
	stime = olddate;
	etime = nowdate;
}

try {
	DBcon dba = new DBcon();
	conn = dba.getConnection();
	stmt = conn.createStatement();
	
	sql = "select c_jf from t_member where c_userid='"+c_userid+"'";
	rs = stmt.executeQuery(sql);
	if(rs.next())jf = rs.getString(1);
	rs.close();
	
	sql = "select c_uid,c_appdate,c_act,c_type,c_id from t_log where c_enable<9 and c_userid='"+c_userid+"' and c_appdate>='"
		+stime+"' and c_appdate<='"+etime+" 23:59:00' "+whereSql+" order by c_id desc";
	//System.out.println(""+sql);
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
		c_type = (String)obj[3];
		id =(String)obj[4];
		//if(c_sname.length()>15)c_sname = c_sname.substring(0,15)+"..";

		
		//查劵or 商家信息
		sql = "select c_id,c_titles,c_pname,c_address,c_sname,c_sid,c_type,c_grade from t_juan where c_id="+c_id;
		if(Tools.isNumber(c_type)==0)sql = "select c_id,c_sname,c_logo,c_address,c_tel,c_jnum,c_hao,c_dps from t_shops where c_id="+c_id;
		rs = stmt.executeQuery(sql);
		if(rs.next())
		{
			c_id = rs.getString(1);
			c_titles = rs.getString(2);
			c_pname = Tools.RmNull(rs.getString(3));
			
			c_address = Tools.RmNull(rs.getString(4));
			c_tel = Tools.RmNull(rs.getString(5));
			c_sname = rs.getString(6);
			c_hao = rs.getString(7);
			c_dps = rs.getString(8);
		}
		rs.close();
		
		if(c_appdate.length()>16)c_appdate = c_appdate.substring(0,16);
		if (c_pname.length() > 10)
			c_pname = "/pic/" + c_pname.substring(0, 6) + "/"
					+ c_pname.substring(6, 8) + "/thumb_" + c_pname;
		else
			c_pname = "/img/nopicb.jpg";
		
		//0 商家   1劵 
		if(Tools.isNumber(c_type)==0){
			c_sid = c_id;
			c_link = "showshop.jsp?id="+c_id+"";
			//星星 
			star = Tools.isNumber(c_hao);
			c_hao = "";
			for (int n = 0; n < star; n++)c_hao+="<span class=\"bri\"></span>";
			for (int n = 0; n < (5-star); n++)c_hao+="<span class=\"dar\"></span>";
			
			sql = "select count(c_id) from t_dianping where c_sid="+c_sid;
			hz = "#dps";
			if (c_tel.equals("0379-")||c_tel.equals(""))c_tel = "暂无";
			c_tel = "电话："+c_tel;
			c_jnum = "<span class=\"juan\"></span>　<a href=\"coupon_list.jsp?sid="+c_sid+"\" ><font class=\"huise\">共："+c_sname+" 张优惠券</font></a>";
		}else
		{
			c_sid = c_sname;
			c_link = "showinfo.jsp?id="+c_id+"";
			c_hao = "";
			sql = "select count(c_id) from t_dianping where c_jid="+c_id;
			hz = "#jl";
			c_tel = "商家：<a href='showshop.jsp?id="+c_sid+"'  ><span class=gri>"+c_tel+"</span></a>";
			c_jnum = "";
		}
		
		//查询点评数和商家地图
		rs = stmt.executeQuery(sql);
		if(rs.next())c_dps = rs.getString(1);
		rs.close();
		
		sql = "select c_map from t_shops where c_id="+c_sid;
		rs = stmt.executeQuery(sql);
		if(rs.next())c_map = rs.getString(1);
		rs.close();
		
		str += "    <div class=\"youhui\">"
			+ "    <div class=\"youhui_top\">"
			+ "    	<span class=\"youhui_title\"><span class=\"ckbox\">"
			+"</span>"
			+ "        <a href=\""+c_link+"\" >"+c_titles+"</a>　　"
			+"<a href=\"showmap.jsp?uid="+c_map+"\" ><span class=\"fangda\"></span> <span class=\"huise\">地图</span></a></span>"
			+ "        <span class=\"youhui_you\">"+c_hao+"　　"
			+"<a href=\""+c_link+hz+"\" ><font color=\"#000\">点评："+c_dps+" 条</font></a>　　"
			+"<a href='###' onClick=\"{if(confirm('确定要删除选中的关注吗？')){window.location.href='myhd_updates.jsp?c=delgz&cid="+id+"&query="+query+"';return true;}return false;}\"><span class=\"del\">删除</span></a></span>"
			+ "    </div>"
			+ "    "
			+ "    <div class=\"list_pic\">"
			+ "    	<ul>"
			+ "        	<li class=\"pic\"><i></i>"
			+"<a href=\""+c_link+"\" ><img src=\""+c_pname+"\" width=\"83\" height=\"46\" border=\"0\" style=\"vertical-align:middle\"  /></a></li>"
			+ "            <li class=\"gri mt8\">地址："+c_address+" </li>"
			+ "            <li class=\"gri\">"+c_tel+"</li>"
			+ "            <li>"+c_jnum+"</li>"
			+ "        </ul>" + "    </div>" + "    </div><div class=parting-line></div>";

	}
	
	if(s.size()==0)str = "    <div class=\"youhui\">"
		+ "    <div class=\"youhui_top\">"
		+ "    </div>"
		+ "    "
		+ "    <div class=\"dptext gri\">您还没有收藏过任何店铺和优惠劵，<a href='coupon_list.jsp' >快来看看吧</a>"
		+ "    </div>"
		+ "    "
		+ "    </div>";

	shownum = pagenow - 1;
	
} catch (Exception e){
   	System.out.println("/m/myhd_guanzhu.jsp error Exception :" + e);
}finally
{
	if (stmt != null) {
		stmt.close();
	}
	if (conn != null) {
		conn.close();
	}
}
xinxi = "共有 <em>"+count+"</em> 条收藏，当前第 <em>"+pagenow+"</em> 页，共 <em>"+pagenum+"</em> 页";
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

if(links.indexOf("javascript")<0)links = "myhd_guanzhu.jsp?npage="+ shownum + "&act=" + act + "&stime="+stime+"&etime="+etime+"&c="+c+"";
if(linkn.indexOf("javascript")<0)linkn = "myhd_guanzhu.jsp?npage="+ pagenow + "&act=" + act + "&stime="+stime+"&etime="+etime+"&c="+c+"";
if(link1.indexOf("javascript")<0)link1 = "myhd_guanzhu.jsp?npage=1&act=" + act + "&stime="+stime+"&etime="+etime+"&c="+c+"";
if(link9.indexOf("javascript")<0)link9 = "myhd_guanzhu.jsp?npage="+ pagenum + "&act=" + act + "&stime="+stime+"&etime="+etime+"&c="+c+"";
%>
<!DOCTYPE html>
<html>
<head>
<title>我自己的收藏_3G</title>
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


<h3 class="h_h3">我自己的收藏<font color="red"></font> </h3>

<form name="list" action="myhd_guanzhu.jsp?act=<%=act%>&stime=<%=stime%>&etime=<%=etime%>&c=<%=c%>" method="get">
  <div class="list">
  <div class="xinxi" style="font-size:12px">
 <div class="sou">
    　收藏类别：<select name="act" id="act" class="sel">
 <option value="" selected>全部</option>
    <option value="0">商家</option>
    <option value="1">优惠券</option>
</select>
    　<input type="submit" name="cha" id="cha" value="查询" class="logbtn" />
    <input type="hidden" name="cc" id="cc" value="delgz" />
    <input type="hidden" name="query" id="query" value="<%=query%>" />
    </div>
    

  <%=str%>
  

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