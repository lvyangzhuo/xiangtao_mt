<%@ page contentType="text/html; charset=utf-8" %><%@ page language="java" import="java.util.*"%><%@ page import="java.sql.*"%><%@ page import = "java.text.SimpleDateFormat" %>
<%@ page language="java" import="com.wsu.basic.util.Tools" %>
<%@ page language="java" import="com.wsu.basic.dbsconnect.*"%>
<%@ page import="com.wsu.web.sql.DataTurnPage"%>
<%
//request.setCharacterEncoding("GBK");
String c_userid = Tools.RmNull((String)session.getAttribute("c_userid"));
if(c_userid.equals("")||c_userid.length()<1){
	response.sendRedirect("login.jsp?rturl=/3g/shangjia_dingdan.jsp");
	return;
}
String c = Tools.RmNull(request.getParameter("c"));
String Method = Tools.RmNull(request.getMethod());
Method = Method.toLowerCase();

String act = Tools.RmNull(request.getParameter("act"));
String stime = Tools.RmNull(request.getParameter("stime"));
String etime = Tools.RmNull(request.getParameter("etime"));
String peisong = "";
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
String did = "";
String shopid = "";
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
String list = "";

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

String name ="";
String mobile = "";
String address = "";
String dtime = "";
String zip = "";
String email = "";
String sidlist = "";
String showStr[] = {};
String sqlstr = "";
int num = 0;
int dj = 0;
int zj = 0;
int psf = 0;
try {
	DBcon dba = new DBcon();
	conn = dba.getConnection();
	stmt = conn.createStatement();
	
	sql = "select c_jf,c_id from t_member where c_userid='"+c_userid+"'";
	rs = stmt.executeQuery(sql);
	if(rs.next()){
		jf = rs.getString(1);
		c_sid = rs.getString(2);
	}
	rs.close();
	/*
	sql = "select c_uid,c_appdate,c_act from t_log where c_enable<9 and c_userid='"+c_userid+"' and c_appdate>='"
		+stime+"' and c_appdate<='"+etime+" 23:59:00' "+whereSql+" order by c_id desc";
		*/
	//name,tel,mobile,address,dtime,bz,money,appuser,appdate,rip,enable

	//sql ="select rid,titles,enable,money,appdate,name,mobile,address,dtime from t_dingdan where appdate>='"
	//+stime+"' and appdate<='"+etime+" 23:59:00' and appuser='"+c_userid+"'  order by rid desc";

	sql = "select distinct(t_dingass.did),t_dingdan.titles,t_dingdan.enable,t_dingdan.money,t_dingdan.appdate,t_dingdan.name,t_dingdan.mobile,t_dingdan.address,t_dingdan.dtime,t_dingdan.email,t_dingdan.zip,t_dingdan.tel,t_dingdan.peisong from t_bang,t_news,t_dingass,t_dingdan where t_bang.c_sid=t_news.ctype_b and t_bang.c_mid="+c_sid+" and (t_news.ctype='cp' or t_news.ctype='tg' or t_news.ctype='wm') and t_news.rid=t_dingass.rid and t_dingass.did=t_dingdan.rid order by t_dingdan.rid desc";
	
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
		c_titles =(String)obj[1];
		c_act = (String)obj[2];
		c_pname = (String)obj[3];
		c_appdate = (String)obj[4];

		name =(String)obj[5];
		mobile = (String)obj[6];
		address = (String)obj[7];
		dtime = (String)obj[8];
		email = (String)obj[9];
		zip = (String)obj[10];
		sidlist = (String)obj[11];
		peisong = (String)obj[12];
		did = c_appdate.substring(0,10).replaceAll("-","")+"000"+c_id;		
				
		//if(c_sname.length()>15)c_sname = c_sname.substring(0,15)+"..";

		if(dtime.length()>16)dtime = dtime.substring(0,16);
		if(c_appdate.length()>16)c_appdate = c_appdate.substring(0,16);

		
		if (sidlist.indexOf(",")>-1) {
			showStr = sidlist.split(",");

			for(int j=0;j<showStr.length;j++)
			{
				if(showStr[j].length()>0)
				{
					sqlstr+=" or rid="+showStr[j];
					
				}
			}
		}else
		{
			sqlstr=" or rid="+sidlist;
		}

		if (sqlstr.length()>3) {
			
			sqlstr = sqlstr.substring(3,sqlstr.length());
			sqlstr = "select distinct(ctype_b),t_shops.c_sname,t_shops.c_psf,t_shops.c_id from t_news,t_shops where  ("+sqlstr+") and t_news.ctype_b=t_shops.c_id";

			//out.println("sqlstr="+sqlstr);
			sidlist = "";
			rs = stmt.executeQuery(sqlstr);
			sqlstr = "";
			while (rs.next())
			{
				
				//arr2 = arr2+c_id+",";
				//c_sname=rs.getString(2);
				//psf = rs.getString(3);
				sidlist += "<tr>    <td>配送费</td>    <td>"+rs.getString(2)+"</td>    <td>"+rs.getString(3)+".0元</td>    <td></td>    </tr>  ";
				shopid=rs.getString(4);

			}
			rs.close();
		}
		

		//查订单详情
		list = "";
		sql = "select t_dingass.rid,t_news.titles,t_shops.c_sname,t_dingass.money,t_dingass.num,t_shops.c_psf from t_dingass,t_news,t_shops,t_bang where t_dingass.did="+c_id+" and t_dingass.rid=t_news.rid and t_news.ctype_b=t_shops.c_id and t_bang.c_sid=t_shops.c_id and t_bang.c_mid="+c_sid;
		rs = stmt.executeQuery(sql);
		int zjq = 0;
		while(rs.next())
		{
			dj = rs.getInt(4);
			num = rs.getInt(5);
			psf = rs.getInt(6);
			zj = dj*num;
			//System.out.println(zj);
			zjq = zjq +zj+psf;
			list += "<tr>    <td>"+rs.getString(2)+"</td>    <td>"+rs.getString(3)+"</td>    <td>"+dj+".0元</td>    <td align=center>"+num+" </td>  </tr>  ";
		}
		rs.close();


		
		switch(Tools.isNumber(c_act)){
			case 0:
				c_act = "<font color=#fd9929>货到付款</font>";
				if (peisong.indexOf("在线支付")>-1)c_act = "<font color=#fd9929>未支付</font>";
				break;
			case 1:
				c_act = "<font color=#fd9929>货到付款</font>";
				if (peisong.indexOf("在线支付")>-1)c_act = "<font color=#fd9929>未支付</font>";
				break;
			case 2:
				c_act = "<font color=#336600>配送中</font>";
				break;
			case 3:
				c_act = "<font color=red>未领取</font>";
				break;
			case 4:
				c_act = "<font color=#000>已领取</font>";
				break;
			case 5:
				c_act = "<font color=green>订单完成</font>";
				break;
			case 6:
				c_act = "<font color=#fd9929>因故未完成</font>";
				break;
			case 7:
				c_act = "<font color=green>订单已付款</font>";
				break;
			case 9:
				c_act = "<font color=#cccccc>已取消</font>";
				break;
		}

		

		list = "<table width='100%' border='0' style='font-size:11px'>  <tr align='left' style='font-weight:bold'><td>菜品</td>	<td>所属商家</td>    <td>单价</td>    <td align=center>数量</td>  </tr>  "+list+sidlist+"<tr>    <td></td>   <td align=right>总价：</td>    <td>"+zjq+".0元</td> <td></td>  </tr>  <tr><td colspan=4>订购人："+name+"</td></tr><tr><td colspan=4>联系电话："+mobile+"</td></tr><tr><td colspan=4>送货地址："+address+"</td></tr><tr><td colspan=4>送货时间："+dtime+"</td>     </tr><tr> <td colspan=4>订单号："+did+"&nbsp;状态：&nbsp;"+c_act+"</td></tr><tr><td  colspan=4>短信验证码：<B>"+email+"</B>  （消费时请出示）</td><tr></table>";

		
		str += "<tr>"
			+ "    <td height=\"70\" class=\"bgtd tit2\" align=center><input type=\"checkbox\" name=\"cid\" value=\""+c_id+"\" /></td>"
			+ "    <td align=\"center\" class=\"bgtd\">"+c_act+"</td>"
			+ "    <td align=\"center\" class=\"bgtd\"><a href=\"javascript:;\" onClick=\"sText('txt"+c_id+"')\" >"+c_titles+"<br>【查看详情】</a></td>"
			+ "    <td align=\"center\" class=\"bgtd\">"+zjq+".0元</td>"
			+ "    <td align=\"center\" class=\"bgtd2\">"+c_appdate+"<span id='txt"+c_id+"' style=\"display:none\">"+list+"</span></td>"
			+ "  </tr>";

	}
	if(s.size()==0)str = "<tr>"
			+ "    <td height=\"70\" class=\"bgtd tit2\" colspan=3>　　您还没有使用过外卖订餐，<a href='/waimai/' target=_blank>快来看看吧</a></td>"
			+ "    <td align=\"center\" class=\"bgtd\"></td>"
			+ "    <td align=\"center\" class=\"bgtd2\"></td>"
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
   	System.out.println("/3g/shangjia_dingdan.jsp error Exception :" + e);
}finally
{
	if (stmt != null) {
		stmt.close();
	}
	if (conn != null) {
		conn.close();
	}
}
xinxi = "<!-- 共有 <em>"+count+"</em> 条记录， 当前-->第 <em>"+pagenow+"</em> 页，共 <em>"+pagenum+"</em> 页";
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

if(links.indexOf("javascript")<0)links = "shangjia_dingdan.jsp?npage="+ shownum + "&act=" + act + "&stime="+stime+"&etime="+etime+"&c="+c+"";
if(linkn.indexOf("javascript")<0)linkn = "shangjia_dingdan.jsp?npage="+ pagenow + "&act=" + act + "&stime="+stime+"&etime="+etime+"&c="+c+"";
if(link1.indexOf("javascript")<0)link1 = "shangjia_dingdan.jsp?npage=1&act=" + act + "&stime="+stime+"&etime="+etime+"&c="+c+"";
if(link9.indexOf("javascript")<0)link9 = "shangjia_dingdan.jsp?npage="+ pagenum + "&act=" + act + "&stime="+stime+"&etime="+etime+"&c="+c+"";
%>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GBK" />
<title>我的外卖订单</title>
<meta name="keywords" content="郑州打折，郑州优惠劵，郑州促销，郑州旅游，郑州饮食，郑州购物">
<meta name="description" content="优惠网-郑州地区消费导航网站，为商户提供更有效的信息传递渠道，为网民提供更有价值的信息"> 
<meta name="viewport" content="width=device-width,initial-scale=1.0,maximum-scale=1.0,minimum-scale=1.0,user-scalable=0">
<meta name="apple-touch-fullscreen" content="yes">
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-status-bar-style" content="black">
<meta name="format-detection" content="telephone=no">
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
<link href="/m/css/window.css" rel="stylesheet" type="text/css" />  
<link rel="stylesheet" type="text/css" href="images/h5_lottery_pc.20131105.css" />
<link rel="stylesheet" type="text/css" href="images/base.css?v=shuidazhe" />


<script type="text/javascript" src="/js/jquery.min.js"></script>
<script type="text/javascript" src="/js/huiduo.js"></script>
<script type="text/javascript" src="/js/jquery.cookie.js"></script>
<script type="text/javascript" src="/m/js/jq.win.js"></script>



<script defer="defer" src="/m/js/datepicker/WdatePicker.js" type="text/javascript"></script>
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

function sText(id)
{
	dialog("查看订单详细内容","id:"+id+"","310px","300px","window");
}
</script>

<%@ include file="header.jsp" %>
  
<div class="good-detail sift-mg">


  <div class="lefttop"></div>
  <div class="titles">
  	<ul>
    	<li ><strong class="dabt">客户已下订单</strong></li>
        <li class="more"></li>
    </ul>
  </div>
  <form name="list" action="shangjia_dingdan.jsp?act=<%=act%>&stime=<%=stime%>&etime=<%=etime%>&c=<%=c%>" method="get">
  <div class="list">
  <div class="xinxi" style="font-size:12px">

  	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="biaoge">
  <tr class="biaoge_top">
    <td width="10%" height="37" class="bgtm"></td>
    <td width="20%" class="bgtm">订单状态</td>
    <td width="40%" class="bgtm" align=center>订单名称</td>
    <td width="10%"  class="bgtm">总价</td>
	<td width="20%"  class="bgtm2">订购时间</td>
  </tr>
  <%=str%>


<tr>
	<td class="bgtd tit2" align=center>
	<input type="checkbox" name="all" id="checkedAll"  /> 全选</td>
  	<td colspan="4" class="bgtd" >
	 &nbsp;
       <input type="button" value="设为已验证" name="yyz" id="yyz"> 
	   &nbsp;
       <input type="button" value="设为配送中" name="bsh" id="bsh"> 
	    &nbsp;
		<input type="button" value="设为已完成" name="ywc" id="ywc">
         &nbsp;

</td>
    
  </tr>

  <tr>
	<td class="bgtd tit2" align=center>
	
  	<td colspan="3" class="bgtd" >
	 &nbsp;
       <input type="button" value="设为用户未领取" name="wsh" id="wsh">
         &nbsp;
       <input type="button" value="取消订单" name="qxdd" id="qxdd">
       </td> <td>
<span id=note></span></td>
    
  </tr>

  <tr>
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
    <td align="right"><!-- <a href="<%=link1%>" class="fy">首页</a>  | -->  <a href="<%=links%>" class="fy">上一页</a>  |  <a href="<%=linkn%>" class="fy">下一页</a>  |  <!-- <a href="<%=link9%>" class="fy">尾页</a> --></td>
  </tr>
</table>

</div>
 
 
  </div>
 <div  class="leftbm"></div>
  </form>

  

  </div>
  
<!-- footer start -->


<!-- footer end -->

</body>
</html>
<script language="javascript">


	$("#checkedAll").click(function() { 

		if ($(this).attr("checked") == true) { // 全选 
 
			 $("input:checkbox").attr("checked",true); 
		} else { // 取消全选 

			$("input:checkbox").attr("checked",false);
		} 
	}); 
	


	//选为 未领取
	$("#wsh").click( function () {
		var i = 0;
		var cid = "";
		$("input:checkbox").each(function() {
			if($(this).attr("checked")==true){
				i++;
				cid+="&cid="+$(this).val();
			}
			
		}); 
		if(i>0){
			dialog("选为用户未领取","url:/3g/dd_update.jsp?c=3"+cid,"280px","130px","window");
			setTimeout(shuaxin,2000);
			return true;
			}
		else {
			$("#note").html("<font color=red>请至少选择一条记录</font>");
			return false;
		}
	}); 

		//选为 已完成
	$("#ywc").click( function () {
		var i = 0;
		var cid = "";
		$("input:checkbox").each(function() {
			if($(this).attr("checked")==true){
				i++;
				cid+="&cid="+$(this).val();
			}
			
		}); 
		if(i>0){
			dialog("选为订单已完成","url:/comp/dd_update.jsp?c=5"+cid,"280px","130px","window");
			setTimeout(shuaxin,2000);
			return true;
			}
		else {
			$("#note").html("<font color=red>请至少选择一条记录</font>");
			return false;
		}
	}); 
	
	//配送中
	$("#bsh").click( function () {
		var i = 0;
		var cid = "";
		$("input:checkbox").each(function() {
			if($(this).attr("checked")==true){
				i++;
				cid+="&cid="+$(this).val();
			}
		}); 

		if(i>0){
			dialog("选为领取任务","url:/3g/dd_update.jsp?c=2"+cid,"280px","130px","window");
			setTimeout(shuaxin,2000);
			return true;
			}
		else {
			$("#note").html("<font color=red>请至少选择一条记录</font>");
			return false;
		}
		
	}); 

	//已验证
	$("#yyz").click( function () {
		var i = 0;
		var cid = "";
		$("input:checkbox").each(function() {
			if($(this).attr("checked")==true){
				i++;
				cid+="&cid="+$(this).val();
			}
		}); 

		if(i>0){
			dialog("选为已验证","url:/comp/dd_update.jsp?c=5"+cid,"280px","130px","window");
			setTimeout(shuaxin,2000);
			return true;
			}
		else {
			$("#note").html("<font color=red>请至少选择一条记录</font>");
			return false;
		}
		
	}); 



	//取消订单
	$("#qxdd").click( function () {
		var i = 0;
		var cid = "";
		$("input:checkbox").each(function() {
			if($(this).attr("checked")==true){
				i++;
				cid+="&cid="+$(this).val();
			}
		}); 

		if(i>0){
			dialog("取消订单","url:/3g/dd_update.jsp?c=9"+cid,"280px","130px","window");
			setTimeout(shuaxin,2000);
			return true;
			}
		else {
			$("#note").html("<font color=red>请至少选择一条记录</font>");
			return false;
		}
		
	}); 




	

	$("input:checkbox").click( function () {
		$("#note").empty();
	}); 



	//弹出元素 需要 live 从新绑定 事件
	//关闭层后取消checkbox选中
	$("#cls").live("click", function(){ 
		$("input:checkbox").each(function() {
			if($(this).attr("checked")==true){
				$(this).attr("checked",false);
			}
			
		}); 
		$("#close").click();
	});

	$("#order").live("click", function(){ 
		$("input:checkbox").each(function() {
			if($(this).attr("checked")==true){
				$(this).attr("checked",false);
			}
			
		}); 
		//$("#close").click();
	});

	

</script>
<script type="text/javascript" src="/m/js/myhd.js"></script>