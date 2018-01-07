<%
/* *
 功能：支付宝页面跳转同步通知页面
 版本：3.2
 日期：2011-03-17
 说明：
 以下代码只是为了方便商户测试而提供的样例代码，商户可以根据自己网站的需要，按照技术文档编写,并非一定要使用该代码。
 该代码仅供学习和研究支付宝接口使用，只是提供一个参考。

 //***********页面功能说明***********
 该页面可在本机电脑测试
 可放入HTML等美化页面的代码、商户业务逻辑程序代码
 TRADE_FINISHED(表示交易已经成功结束，并不能再对该交易做后续操作);
 TRADE_SUCCESS(表示交易已经成功结束，可以对该交易做后续操作，如：分润、退款等);
 //********************************
 * */
%>
<%@ page language="java" contentType="text/html; charset=gbk" pageEncoding="gbk"%>
<%@ page import="java.util.*"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.alipay.util.*"%>
<%@ page import="com.alipay.config.*"%>
<%@ page import="java.text.SimpleDateFormat"%><%@ page language="java" import="java.util.*"%><%@ page language="java" import="java.io.*"%><%@ page language="java" import="java.sql.*"%><%@ page language="java" import="com.wsu.basic.util.Tools"%><%@ page language="java" import="com.wsu.basic.dbsconnect.*"%>
<html>
  <head>
		<meta http-equiv="Content-Type" content="text/html; charset=gbk">
		<title>支付宝页面跳转同步通知页面</title>
  </head>
  <body>
<%
	//获取支付宝GET过来反馈信息
	Map<String,String> params = new HashMap<String,String>();
	Map requestParams = request.getParameterMap();
	for (Iterator iter = requestParams.keySet().iterator(); iter.hasNext();) {
		String name = (String) iter.next();
		String[] values = (String[]) requestParams.get(name);
		String valueStr = "";
		for (int i = 0; i < values.length; i++) {
			valueStr = (i == values.length - 1) ? valueStr + values[i]
					: valueStr + values[i] + ",";
		}
		//乱码解决，这段代码在出现乱码时使用。如果mysign和sign不相等也可以使用这段代码转化
		valueStr = new String(valueStr.getBytes("ISO-8859-1"), "utf-8");
		params.put(name, valueStr);
	}
	
	//获取支付宝的通知返回参数，可参考技术文档中页面跳转同步通知参数列表(以下仅供参考)//
	//商户订单号
	String out_trade_no = new String(request.getParameter("out_trade_no").getBytes("ISO-8859-1"),"GBK");

	//支付宝交易号
	String trade_no = new String(request.getParameter("trade_no").getBytes("ISO-8859-1"),"GBK");

	//交易状态
	String trade_status = new String(request.getParameter("trade_status").getBytes("ISO-8859-1"),"GBK");

	//获取支付宝的通知返回参数，可参考技术文档中页面跳转同步通知参数列表(以上仅供参考)//
	
	//计算得出通知验证结果
	boolean verify_result = AlipayNotify.verify(params);
	
	/*
	if(verify_result){//验证成功
		//////////////////////////////////////////////////////////////////////////////////////////
		//请在这里加上商户的业务逻辑程序代码

		//——请根据您的业务逻辑来编写程序（以下代码仅作参考）——
		if(trade_status.equals("TRADE_FINISHED") || trade_status.equals("TRADE_SUCCESS")){
			//判断该笔订单是否在商户网站中已经做过处理
				//如果没有做过处理，根据订单号（out_trade_no）在商户网站的订单系统中查到该笔订单的详细，并执行商户的业务程序
				//如果有做过处理，不执行商户的业务程序
		}
		
		//该页面可做页面美工编辑
		out.println("验证成功<br />");
		//——请根据您的业务逻辑来编写程序（以上代码仅作参考）——
		System.out.println("r_out_trade_no=="+out_trade_no);
		System.out.println("r_trade_status=="+trade_status);
		//////////////////////////////////////////////////////////////////////////////////////////
	}else{
		//该页面可做页面美工编辑
		out.println("验证失败");
	}
	*/

	out.println("验证成功<br />");
		//——请根据您的业务逻辑来编写程序（以上代码仅作参考）——
		System.out.println("r_out_trade_no=="+out_trade_no);
		System.out.println("r_trade_status=="+trade_status);



request.setCharacterEncoding("GBK");
String c = Tools.RmNull(request.getParameter("c")); 

String []cid = request.getParameterValues("cid");
//c_text = new String(c_text.getBytes("utf-8"), "GBK");
//c_fee = new String(c_fee.getBytes("utf-8"), "GBK");


String callback = request.getParameter("jsonpCallback"); 
String r = Tools.RmNull(request.getParameter("r")); //r

Connection con = null;
Statement stmt = null;
ResultSet rs = null;
PreparedStatement pstmt = null;
String sql = "";
String msg = "";
String whereSql = "";
int enable = 1;
Calendar cal  = Calendar.getInstance();
SimpleDateFormat formatter =new SimpleDateFormat("yyyy-MM-dd HH:mm");
SimpleDateFormat formatter2 =new SimpleDateFormat("E");
String c_appdate = formatter.format(cal.getTime());
String week = formatter2.format(cal.getTime());
int hour = Tools.isNumber(c_appdate.substring(11,13));
String c_ip = request.getRemoteAddr();

String c_userid = Tools.RmNull((String)session.getAttribute("c_userid"));

String userid = Tools.RmNull((String)session.getAttribute("userid"));
if(userid.equals("")&&c_userid.equals(""))
{
	response.sendRedirect("/do/login.html");
	return;
}
int j =0;
enable = Tools.isNumber(c);

		try {
	DBcon dbcon = new DBcon(); //数据库连接
	con = dbcon.getConnection();
	stmt = con.createStatement();
	ArrayList s = new ArrayList();
	// update 
	if(trade_status.equals("TRADE_SUCCESS"))
	{
		sql = "update t_dingdan set enable=? where rid=?";
		pstmt = con.prepareStatement(sql);
		int i =0;



				pstmt.setInt(1, 7);
				pstmt.setInt(2, Tools.isNumber(out_trade_no));
				pstmt.addBatch();
				
				//whereSql += " or c_id="+cid[i];
				//System.out.println(i+"_"+cid[i]);
				j++;	


		pstmt.executeBatch(); 
		
		
		
		out.println("订单已支付成功！&nbsp;<input type=\"button\" name=\"Submit\" value=\"确认关闭窗口\" onclick=\"window.close();\"  />");
	}
	
	
	
} catch (Exception e) {
	System.out.println("return_url.jsp error :" + e);
	out.print(callback + "error"); 
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
  </body>
</html>