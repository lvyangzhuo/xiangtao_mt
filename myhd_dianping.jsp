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
query = query.replaceAll("_cc=deldp","");
query = query.replaceAll("_query=","");
//System.out.println("query="+query);
String c = Tools.RmNull(request.getParameter("c"));
String []cid = request.getParameterValues("cid");
String Method = Tools.RmNull(request.getMethod());
Method = Method.toLowerCase();

String act = Tools.RmNull(request.getParameter("act"));
String stime = Tools.RmNull(request.getParameter("stime"));
String etime = Tools.RmNull(request.getParameter("etime"));

String c_id = "";
String c_sid="";
String c_jid="";
String c_dtype="";
String c_fee="";
String c_text="";
String c_appdate="";
String c_retext="";
String c_redate="";
String c_titles = "";
String c_link = "";
String str = "";
String jf = "";	//会员积分
String xinxi = "";
String xinxi2 = "";
String link1 = "";
String link9 = "";
String links = "";
String linkn = "";
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
PreparedStatement pstmt = null;
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
	
	if(act.equals(">")||act.equals("="))whereSql = "and c_jid "+act+"0 ";
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
	
	sql = "select c_sid,c_jid,c_dtype,c_fee,c_text,c_appdate,c_retext,c_redate,c_id from t_dianping where c_enable<9 and c_userid='"+c_userid+"'  "+whereSql+" order by c_id desc";
	
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
		
		c_sid=(String)obj[0];
		c_jid=(String)obj[1];
		c_dtype=(String)obj[2];
		c_fee=(String)obj[3];
		c_text=(String)obj[4];
		c_appdate=(String)obj[5];
		c_retext=(String)obj[6];
		c_redate=(String)obj[7];
		c_id = (String)obj[8];
		
		c_text = c_text.replaceAll("\r\n","<br>");
		if(c_appdate.length()>16)c_appdate = c_appdate.substring(0,16);
		if(c_fee.length()>11)c_fee = c_fee.substring(0,11)+".";
		if(c_fee.length()>0)c_fee = "推荐：<span class=\"gri\">"+c_fee+"</span>";
			
		//查劵 or 商家信息
		sql = "select c_id,c_sname from t_shops where c_id="+c_sid;
		if(Tools.isNumber(c_jid)>0)sql = "select c_id,c_titles from t_juan where c_id="+c_jid;
		rs = stmt.executeQuery(sql);
		if(rs.next())
		{
			c_sid = rs.getString(1);
			c_titles = rs.getString(2);
		}
		rs.close();
		if(c_titles.length()>15)c_titles = c_titles.substring(0,15)+"..";

		if(Tools.isNumber(c_jid)>0)c_link = "showinfo.jsp?id="+c_sid+"";
		else c_link="showshop.jsp?id="+c_sid+"";
		
		
		
		//商家回复是否有
		if(c_retext.length()>1){
			c_redate = c_redate.substring(0,16);
			c_retext = "<div class=\"hftext pl12\"><span class=\"hft fl\">商家回复：</span>"+c_retext+"<span class=\"gri\">　"+c_redate+"</span></div>";
		}else
		{
			c_retext = "";
		}
		
		//星星 
		star = Tools.isNumber(c_dtype);
		c_dtype = "";
		for (int n = 0; n < star; n++)c_dtype+="<span class=\"bri\"></span>";
		for (int n = 0; n < (5-star); n++)c_dtype+="<span class=\"dar\"></span>";
		
		str += "    <div class=\"youhui\">"
			+ "    <div class=\"youhui_top\">"
			+ "    	<span class=\"youhui_title\">"
			+ "        <a href=\""+c_link+"\" target=_blank>"+c_titles+"</a>　　　"
			+""+c_fee+"</span>"
			+ "        <span class=\"youhui_you\">"+c_dtype+"　　<span class=\"gri\">"+c_appdate+"</span>　　"
			+"<a href='###' "
			+"onClick=\"{if(confirm('确定要删除选中的点评吗？')){window.location.href='myhd_updates.jsp?c=deldp&cid="+c_id+"&query="+query+"';return true;}return false;}\"><span class=\"del\">删除</span></a></span>"
			+ "    </div>"
			+ "    "
			+ "    <div class=\"dptext gri\">"+c_text+""
			+ "    </div>"
			+ "    "+c_retext+""
			+ "    </div><div class=parting-line></div>";

	}
	if(s.size()==0)str = "    <div class=\"youhui\">"
		+ "    <div class=\"youhui_top\">"
		+ "    </div>"
		+ "    "
		+ "    <div class=\"dptext gri\">您还没有点评过店铺和优惠劵，<a href='coupon_list.jsp' target=_blank>快来点评吧</a>"
		+ "    </div>"
		+ "    "
		+ "    </div>";

	/**/
	shownum = pagenow - 1;
	
} catch (Exception e){
   	System.out.println("/m/myhd_dianping.jsp error Exception :" + e);
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
xinxi = "共有 <em>"+count+"</em> 条点评，当前第 <em>"+pagenow+"</em> 页，共 <em>"+pagenum+"</em> 页";
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

if(links.indexOf("javascript")<0)links = "myhd_dianping.jsp?npage="+ shownum + "&act=" + act + "&stime="+stime+"&etime="+etime+"&c="+c+"";
if(linkn.indexOf("javascript")<0)linkn = "myhd_dianping.jsp?npage="+ pagenow + "&act=" + act + "&stime="+stime+"&etime="+etime+"&c="+c+"";
if(link1.indexOf("javascript")<0)link1 = "myhd_dianping.jsp?npage=1&act=" + act + "&stime="+stime+"&etime="+etime+"&c="+c+"";
if(link9.indexOf("javascript")<0)link9 = "myhd_dianping.jsp?npage="+ pagenum + "&act=" + act + "&stime="+stime+"&etime="+etime+"&c="+c+"";
%>

<!DOCTYPE html>
<html>
<head>
<title>我自己的点评_3G</title>
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


<h3 class="h_h3">我自己的点评<font color="red"></font> </h3>

<form name="list" action="myhd_dianping.jsp?act=<%=act%>&stime=<%=stime%>&etime=<%=etime%>&c=<%=c%>" method="get">
  <div class="list">
  <div class="xinxi" style="font-size:12px">
 <div class="sou">
    　点评类别：<select name="act" id="act" class="sel">
 <option value="" selected>全部</option>
    <option value="=">商家</option>
    <option value=">">优惠券</option>
</select>
    　<input type="submit" name="cha" id="cha" value="查询" class="logbtn" />
    <input type="hidden" name="cc" id="cc" value="deldp" />
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

