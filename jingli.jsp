<%@ page contentType="text/html;charset=GBK"%><%@ page import="java.text.SimpleDateFormat"%><%@ page language="java" import="java.util.*"%><%@ page language="java" import="java.util.*"%><%@ page language="java" import="java.lang.*"%><%@ page language="java" import="java.io.*"%><%@ page language="java" import="java.sql.*"%><%@ page language="java" import="com.wsu.basic.util.Tools"%><%@ page language="java" import="com.wsu.basic.dbsconnect.*"%><%@ page import="com.wsu.web.sql.DataTurnPage"%><%@ page import = "com.wsu.basic.imageio.ImageTools"%><%
request.setCharacterEncoding("GBK");

String Referer = Tools.RmFilter(request.getHeader("Referer"));

String sql = "";
String jid = Tools.RmFilter(request.getParameter("jid"));
String sid = Tools.RmFilter(request.getParameter("sid"));
String f = Tools.RmFilter(request.getParameter("f"));
String j = Tools.RmFilter(request.getParameter("j"));
String sf = Tools.RmFilter(request.getParameter("sf"));
f = new String(f.getBytes("ISO-8859-1"), "GBK");
String []fee = {};

String whereSql = "";
String c_dtype = "";
String c_fee = "";
String c_text = "";
String c_userid = "";
String c_appdate = "";
String show = "";
String c_retext = "";
String c_redate = "";
String c_nick = "";
String c_avatar = "";
String c_jf = "";
Connection con = null;
Statement stmt = null;
ResultSet rs = null;
int star = 0;
int c_adm = 0;
int c_guest = 0;

int count = 0;			//总记录数
int pagenum = 0; 		//总页数
int shownum = 10; 		//每页显示篇数
int pagenow = 0; 		//当前页码
String snpage = Tools.RmFilter(request.getParameter("npage"));

if (snpage != null)
	pagenow = Tools.isNumber(snpage);
if (pagenow < 1)
	pagenow = 1;
Calendar cal  = Calendar.getInstance();
SimpleDateFormat formatter =new SimpleDateFormat("yyyy-MM-dd HH:mm");
SimpleDateFormat formatter2 =new SimpleDateFormat("E");
String nowdate = formatter.format(cal.getTime()).substring(0,16);
String week = formatter2.format(cal.getTime());
int hour = Tools.isNumber(nowdate.substring(11,13));

whereSql = " c_enable>0 and c_enable<9";


int v=0;
Cookie cookies[]=request.getCookies();	
Cookie sCookie=null; 
String sName ="";
String sValue ="";
if(cookies!=null)
{
	for(int jj=0;jj<cookies.length; jj++) // 循环列出所有可用的Cookie 
	{ 
		sCookie=cookies[jj]; 
		sName = sCookie.getName(); 
		sValue = java.net.URLDecoder.decode(sCookie.getValue());
		if (sName.equals("138do_uid")) {
			if(sValue.length()>3)
			{	
				sValue = new String(sValue.getBytes("GBK"), "UTF-8");
				session.setAttribute("c_userid",sValue);
			}
			v++;
		}
	}
	if(v==1){
		//response.sendRedirect(UrlStr);
		//return;
	}
}

String userid = Tools.RmNull((String)session.getAttribute("c_userid"));
String lgs = "&nbsp; <span class=kuo>[</span>&nbsp;<a href=\"login.jsp?rturl=/3g/showinfo.jsp?id="+jid+"\" >登录</a>&nbsp;<span class=kuo>]</span>";
if(userid.length()>3)lgs = " &nbsp; <span class=kuo>"+userid+"</span>&nbsp; <span class=kuo>[</span>&nbsp;<a href=\"/logout.jsp?rturl=/3g/showinfo.jsp?id="+jid+"\" target=_top>退出</a>&nbsp;<span class=kuo>]</span>";

if(v==0&&userid.length()>3)
{
	//cookie丢session在的话 重写cookie 解决cookie和session不同步问题
	Cookie cook1=new Cookie("138do_uid",userid);  
	cook1.setMaxAge(30*60);	//30分钟
	cook1.setPath("/");
	response.addCookie(cook1);
}

try {
	DBcon db = new DBcon(); //数据库连接
	con = db.getConnection();
	stmt = con.createStatement();
	
	//精华
	sql = "select c_dtype,c_fee,c_text,c_userid,c_appdate,c_retext,c_redate,c_adm,c_guest from t_dianping where "+whereSql+" and c_jid="+Tools.isNumber(jid)+"";

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

		c_dtype =(String)obj[0];
		c_fee = (String)obj[1];
		c_text = Tools.RmNull((String)obj[2]).replaceAll("\n","<br>");
		c_userid = Tools.RmNull((String)obj[3]);
		c_appdate = (String)obj[4];
		c_retext = Tools.RmNull((String)obj[5]);
		c_redate = (String)obj[6];
		star = Tools.isNumber(c_dtype);
		c_adm = Tools.isNumber((String)obj[7]);
		c_guest = Tools.isNumber((String)obj[8]);
		c_appdate = c_appdate.substring(0,16);
		
		c_avatar = "";
		c_nick = "";
		c_jf = "";
		sql = "select c_nick,c_avatar,c_jf,c_mtype from t_member where c_userid='"+ c_userid + "'";
		rs = stmt.executeQuery(sql);
		if(rs.next())
		{
			c_nick = Tools.RmNull(rs.getString(1));
			c_avatar = Tools.RmNull(rs.getString(2));
			c_jf = Tools.RmNull(rs.getString(3));
		}
		rs.close();
		
		if(c_nick.length()>1)c_userid = c_nick;
		if (c_avatar.length() > 10)
			c_avatar = "/pic/" + c_avatar.substring(0, 6) + "/"
					+ c_avatar.substring(6, 8) + "/thumb_" + c_avatar;
		else
			c_avatar = "/images/pic7.gif";
		
		if(c_adm==1&&c_guest==1)c_userid = "游客";
		
		//商家回复是否有
		if(c_retext.length()>1){
			c_redate = c_redate.substring(0,16);
			c_retext = "<div class=\"ans fr\"><span class=\"red\">商家回复</span> "
			+"<span class=\"gra\">"+c_redate+"</span><br />"+c_retext+"</div>";
		}else
		{
			c_retext = "";
		}
		
		//星星 
		c_dtype = "";
		for (int n = 0; n < star; n++)c_dtype+="<span class=\"bri\">&nbsp;</span>";
		for (int n = 0; n < (5-star); n++)c_dtype+="<span class=\"dar\">&nbsp;</span>";
		/*
		show += "<div class=\"fl com-a\"><img src=\""+c_avatar+"\" width=45 height=45 /></div>"
			+ "   <div class=\"com-n fr\"><a href=\"javascript:;\" class=\"blu\">"+c_userid+"</a><span class=\"bad\">&nbsp;</span><br />"
			+ "     "+c_dtype+"<span class=\"rec\">推荐：</span><span class=\"gra\">"+c_fee+"</span><br />"
			+ "     "+c_text+"<br />"
			+ "     <span class=\"rep\"><a href=\"javascript:;\" onClick=\"jubao('举报:用劵点评_"+((pagenow-1)*10+i+1)+"_coupon_"+jid+".html')\">举报</a></span><span class=\"dat1\">"+c_appdate+"</span></div>"
			+ "   "+c_retext+""
			+ "   <div class=\"spa\"></div>";
			*/

		show += "<div class=\"parting-line\"></div><a href=\"javascript:;\" class=\"good-lnk2\" style=\"margin-left:10px\"> <span class=\"tit\"><img src=\""+c_avatar+"\" width=45 height=45 /> &nbsp;"+c_userid+"： 给了 "+c_dtype+" "+c_text+"  &nbsp;&nbsp;&nbsp;<span class='mu_l mu_lh' style='color:#a6a5a5'>评论于:"+c_appdate+"</span> </span> </a>";
	}
	shownum = pagenow - 1;
	if(s.size()==0)show = "<div class=\"parting-line\"></div><a href=\"javascript:;\" class=\"good-lnk2\" style=\"margin-left:10px\">暂无评论～</a>";
	
	c_fee = "";
	if(f.indexOf(" ")>-1)fee = f.split(" ");
	else c_fee = "<a href=\"javascript:;\" onClick=\"addfee('"+f+"')\">"+f+"</a>";
	
	for(int z=0;z<fee.length;z++)c_fee+="<a href=\"javascript:;\" onClick=\"addfee('"+fee[z]+"')\">"+fee[z]+"</a> ";

	
	
} catch (Exception e) {
	System.out.println("jingli.jsp error :" + e);
	e.printStackTrace();
} finally {

	if (stmt != null) {
		stmt.close();
	}
	if (con != null) {
		con.close();
	}

}
int fy = pagenow;
/**/
if (pagenow >= pagenum)
	fy = pagenum;

if (pagenow < pagenum)
	fy = pagenow + 1;


//System.out.println("f="+f);
//f = java.net.URLEncoder.encode(f, "utf-8");
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GBK" />
<title>用劵点评</title>

<script type="text/javascript" src="/js/jquery.min.js"></script>
<script type="text/javascript" src="/js/jquery.cookie.js"></script>
<script type="text/javascript" src="/3g/dianping.js"></script>
</head>

<style>
.good-lnk2{
	margin-left:10px;
}

.wbktext {
	background: rgb(244, 244, 244); padding: 0px 0px 0px 6px; border-radius: 3px; border: 1px solid rgb(207, 203, 197); width: 90%; height: 90px; color: rgb(60, 60, 60); line-height: 30px; font-size: 1em; box-shadow: inset 0px 1px 3px #c8c8c8; -webkit-border-radius: 3px; -moz-border-radius: 3px; -moz-box-shadow: 1px 3px #c8c8c8 inset; -webkit-box-shadow: 0 1px 3px #c8c8c8 inset;
}

</style>

<body style="width:auto;text-align:left;" >

<ul class="mu_lw">
					<a href="javascript:;" class="good-lnk2" > <B>网友评论</B> </a>	
						<%=show%>
		</ul>

<div class="parting-line"></div>
	 <div id="pag">&nbsp;<a href="showinfo.jsp?npage=<%=shownum%>&id=<%=jid%>&jid=<%=jid%>&f=<%=f%>&j=<%=j%>" class="last" >上一页</a> <a href="showinfo.jsp?npage=<%=fy%>&id=<%=jid%>&jid=<%=jid%>&f=<%=f%>&j=<%=j%>" class="next"  >下一页</a> 
	 &nbsp;&nbsp; <span class="red"><%=pagenow%></span>/<%=pagenum%> 页 <span class="red"><%=count%></span> 个点评</div>


<ul class="mu_lw">
			<li class="mu_l"> <span class="mu_lh">好评度：</span> <span class="mu_lc"><span id="star"><span class="bri" onmouseover="showStar(1)">&nbsp;</span><span class="bri" onmouseover="showStar(2)">&nbsp;</span><span class="bri" onmouseover="showStar(3)">&nbsp;</span><span class="dar" onmouseover="showStar(4)">&nbsp;</span><span class="dar" onmouseover="showStar(5)">&nbsp;</span></span></span><input type=hidden name=xx id=xx value=3><span class="dp">&nbsp;</span><span style='float:right'>拖动可选择星星&nbsp;&nbsp;</span></li>
			<li class="mu_l"> <span class="mu_lh"></span> <span class="mu_lc"></span></li>
			<li class="mu_l"><span class="mu_lh">评价内容：</span> <span class="mu_lc"><textarea name="c_text" id="c_text" rows="0" class="wbktext"></textarea></span> </li>
			<li class="mu_l"><span class="mu_lh"><!-- 热门推荐： --></span> <span class="mu_lc red price-txt"><input name="c_fee" id="c_fee" type="hidden" class="wbktext" /> <span class="blu"><%=c_fee%></span></span></li>
			
			<li class="mu_l"><span class="mu_lh"></span> <span class="mu_lc q-txt"></span></li>

			<li class="mu_l"><span class="mu_lh"><span class="nm" onClick="xzhong()">匿名</span> <input type="checkbox" name="niming" id="niming" /></span> <span class="mu_lc q-txt"><input type="image" id="jltj"  name="imageField" src="/images/tj.gif" /></span></li>

			<li class="mu_l"><span class="mu_lh"></span> <span class="mu_lc red"><span class="red"><b>欢迎<span id="lgstatus"><%=lgs%></span></b></span></span> </li>
	
	<input type=hidden name=sid id=sid value='<%=sid%>'>
   <input type=hidden name=jid id=jid value='<%=jid%>'>
   <%
   if(j.equals("1"))count=11; 
   
   if(week.equals("星期日")||hour>=17|| hour<=8)
   {
	   count = 999; //周日和下班时间需审核
   }
   
   %>
   <input type=hidden name=count id=count value='<%=count%>'>
</ul>


<div class="to-top"><a href="javascript:scroll(0,0)" hidefocus="true"><span></span>回顶部</a></div>
<div class="lay_footer" id="page-foot"> 
      
         <div class="ui_fixed fn_bottom_banner" id="page-foot-fixed">
             <div class="fixed_inner" id="page-foot-inner">
                <div class="fn_banner qb_flex" id="header_bar"> <a href="index.jsp" class="flex_box banner_item "> <i class="qb_icon item_icon icon_banner_home"></i> <span class="item_text">回首页</span> </a> <a href="shop_list.jsp" class="flex_box banner_item "> <i class="qb_icon item_icon icon_banner_together"></i> <span class="item_text">搜商家</span> </a> <a href="coupon_list.jsp" class="flex_box banner_item"> <i class="qb_icon item_icon icon_banner_number"></i> <span class="item_text">找优惠</span> </a> <a href="news_list.jsp" class="flex_box banner_item"> <i class="qb_icon item_icon icon_banner_help"></i> <span class="item_text">商 品</span> </a> <a href="diqu.jsp" class="flex_box banner_item"> <i class="qb_icon item_icon icon_banner_myticket"></i> <span class="item_text">按位置</span><b class="item_sup ui_none" id="msg_numbers"></b></a>
				</div>
             </div>
        </div>
</div>



	</body>

	</html>
	<%
	//if(sf.equals("1"))out.println("<script>setFocus()</script>");
	%>