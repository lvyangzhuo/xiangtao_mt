<%@ page contentType="text/html;charset=GBK"%><%@ page import="java.text.SimpleDateFormat"%><%@ page language="java" import="java.util.*"%><%@ page language="java" import="java.io.*"%><%@ page language="java" import="java.sql.*"%><%@ page language="java" import="com.wsu.basic.util.Tools"%><%@ page language="java" import="com.wsu.basic.dbsconnect.*"%><%
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
	//System.out.println("nnnn");
	
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
	if(cid!=null)
	{
		sql = "update t_dingdan set enable=? where rid=?";
		pstmt = con.prepareStatement(sql);
		int i =0;
		for(i=0;i<cid.length;i++)
		{
			if(Tools.RmNull(cid[i]).length()>0)
			{

				pstmt.setInt(1, enable);
				pstmt.setInt(2, Tools.isNumber(cid[i]));
				pstmt.addBatch();
				
				//whereSql += " or c_id="+cid[i];
				//System.out.println(i+"_"+cid[i]);
				j++;	
			}
		}
		if(i>0)pstmt.executeBatch(); 
		
		
		
		out.println("<div align=center>更新成功"+j+"条记录，2秒后自动关闭</div>");
	}
	
	
	
} catch (Exception e) {
	System.out.println("dd_update.jsp error :" + e);
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