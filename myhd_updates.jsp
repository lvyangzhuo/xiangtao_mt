<%@ page contentType="text/html; charset=GBK" %><%@ page language="java" import="java.util.*"%><%@ page import="java.sql.*"%><%@ page import = "java.text.SimpleDateFormat" %>
<%@ page language="java" import="com.wsu.basic.util.Tools" %>
<%@ page language="java" import="com.wsu.basic.dbsconnect.*"%>
<%@ page import="com.wsu.web.sql.DataTurnPage"%>
<%
request.setCharacterEncoding("GBK");
String c_userid = Tools.RmNull((String)session.getAttribute("c_userid"));
if(c_userid.equals("")||c_userid.length()<1){
	response.sendRedirect("/login.jsp");
	return;
}

/*
String Referer = Tools.RmNull(request.getHeader("Referer"));
if(Referer.indexOf("/")>-1)Referer = Referer.substring(Referer.indexOf("/")+1,Referer.length());
else Referer = "";
System.out.println("Referer="+Referer);
*/

//String query = Tools.RmNull(request.getQueryString());
String query = Tools.RmNull(request.getParameter("query"));
query = query.replaceAll("_cc=deldp","");
query = query.replaceAll("_cc=delgz","");
query = query.replaceAll("_cc=delxq","");
query = query.replaceAll("_cc=glyh","");
query = query.replaceAll("_query=","");
query = query.replaceAll("_","&");
//query = new String(query.getBytes("ISO-8859-1"), "GBK");
//System.out.println("query="+query);
/*
if(query.indexOf("npage")>0)query = query.substring(query.indexOf("npage"),query.length());
else query = "";
*/
String rid = Tools.RmNull(request.getParameter("rid"));
String c = Tools.RmNull(request.getParameter("c"));
String []cid = request.getParameterValues("cid");
String Method = Tools.RmNull(request.getMethod());
Method = Method.toLowerCase();

//System.out.println("query2="+query);

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
int id = 0;

if (request.getMethod() == "GET") {
	//name = new String(name.getBytes("ISO-8859-1"), "GBK");
}

//System.out.println("c="+c);
//System.out.println("query="+query);

try {
	DBcon dba = new DBcon();
	conn = dba.getConnection();
	stmt = conn.createStatement();
	
	int i =0;
	
	if(cid!=null&&(c.equals("deldp")||c.equals("delgz")||c.equals("delxq")))
	{
		
		if(c.equals("deldp"))sql = "update t_dianping set c_enable=? where c_id=? and c_userid=?";
		else sql = "update t_log set c_enable=? where c_id=? and c_userid=?";
		
		//System.out.println("sql="+sql);	
		
		pstmt = conn.prepareStatement(sql);
		i =0;
		for(i=0;i<cid.length;i++)
		{
			if(Tools.RmNull(cid[i]).length()>0)
			{

				pstmt.setInt(1, 9);
				pstmt.setInt(2, Tools.isNumber(cid[i]));
				pstmt.setString(3, c_userid);
				pstmt.addBatch();
				
				//whereSql += " or c_id="+cid[i];
				//System.out.println(i+"_"+cid[i]);	
			}
		}
		if(i>0)pstmt.executeBatch(); 
		
	}else if(cid!=null&&c.equals("glyh")){
		
		sql = "update t_juan set c_enable=? where c_id=? and c_appuser=?";
		
		pstmt = conn.prepareStatement(sql);
		i =0;
		for(i=0;i<cid.length;i++)
		{
			//System.out.println("cid="+cid[i]);	
			if(Tools.RmNull(cid[i]).length()>0)
			{

				pstmt.setInt(1, 9);
				pstmt.setInt(2, Tools.isNumber(cid[i]));
				pstmt.setString(3, c_userid);
				pstmt.addBatch();
				
				//whereSql += " or c_id="+cid[i];
				//System.out.println(i+"_"+cid[i]);	
				//¸üÐÂ„»Êý
				sql = "select c_sid from t_juan where c_id="+Tools.isNumber(cid[i]);
				rs = stmt.executeQuery(sql);
				if(rs.next())id = rs.getInt(1);
				else id =0;
				sql = "update t_shops set c_jnum=c_jnum-1 where c_id="+id;
				stmt.executeUpdate(sql);
			}
		}
		if(i>0){
			pstmt.executeBatch(); 
		}
		
	}else if (rid!=null&&(c.equals("fxdr")||c.equals("cp")||c.equals("news"))) {
		sql = "delete from t_news where rid="+rid;
		//System.out.println("sql="+sql);
		
		stmt.executeUpdate(sql);
	}

	if (c.equals("deldp")&&cid!=null) {
		
		response.sendRedirect("myhd_dianping.jsp?"+query);
	}else if (c.equals("delgz")&&cid!=null) {
		//System.out.println("gggggzzzz");
		response.sendRedirect("myhd_guanzhu.jsp?"+query);
	}else if (c.equals("delxq")&&cid!=null) {
		response.sendRedirect("myhd_xiangqu.jsp?"+query);
	}else if (c.equals("glyh")&&cid!=null) {
		response.sendRedirect("shangjia_glyh.jsp?"+query);
	}else if (c.equals("fxdr")&&rid!=null) {
		response.sendRedirect("myhd_jingyan.jsp?"+query);
	}else if (c.equals("cp")&&rid!=null) {
		response.sendRedirect("shangjia_editor.jsp?"+query);
	}else if (c.equals("news")&&rid!=null) {
		response.sendRedirect("shangjia_editor.jsp?"+query);
	}

	
} catch (Exception e){
   	System.out.println("/3g/myhd_updates.jsp error Exception :" + e);
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

%>
