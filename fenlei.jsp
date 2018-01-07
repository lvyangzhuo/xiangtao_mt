<%@page contentType="text/html;charset=utf-8"%>
<%@ page import = "java.sql.*" %>
<%@ page language="java" import="java.io.*"%>
<%@page language="java" import="java.util.*"%>
<%@ page import="com.wsu.basic.util.Tools" %>
<%@ page import="com.wsu.basic.dbsconnect.*" %>
<%@ page import="com.wsu.web.menuType.MenuGetType" %>

<%
DBcon db=new DBcon();
	Connection con=null; 
	Statement stmt=null;
	Statement stmt2=null;
	ResultSet rs=null;
	ResultSet rs2=null;

	String sqlstr = "";

	String id = Tools.RmFilter(request.getParameter("id"));	//c_code
	String c = Tools.RmFilter(request.getParameter("c"));		//栏目模板 c_mod
	String t = Tools.RmFilter(request.getParameter("t"));
	String c_belong = Tools.RmFilter(request.getParameter("c_belong"));
	String whereSql = "";
	String code = "";
	String bcode = "";
	String cname = "";
	String bname = "";
	String str = "";
	String list = "";

	if (t.equals("")) {
		t= "8";
	}

	if (!c.equals("")) {
		whereSql = "and c_code="+c+" ";
	}
	try {
	
	con = db.getConnection();
	stmt = con.createStatement();
	stmt2 = con.createStatement();
	sqlstr = "select c_code,c_name,c_belong from t_type where c_grade<9 and c_belong="+t+" "+whereSql+" order by c_enable asc";
	rs = stmt.executeQuery(sqlstr);
	while (rs.next()) {
		bcode = rs.getString(1);
		bname =  rs.getString(2);
		sqlstr = "select c_code,c_name,c_belong from t_type where c_grade<9 and c_belong="+bcode+" order by c_code asc";
		rs2 = stmt2.executeQuery(sqlstr);
		list = "";
		while (rs2.next()) {
			code = rs2.getString(1);
			cname = rs2.getString(2);
			list += "<span><a href='shop_list.jsp?name=&c="+bcode+"&g="+code+"&q=&a=&j='>"+cname+"</a></span>";
		}
		rs2.close();

		str += "<table width='100%' border='0' class='tab-list'>  <tr>    <td valign='top' width='80' align=center style='line-height:28px'><B>"+bname+"</B><img src=images/"+bcode+".png width='46' class=tu_pic></td>    <td valign='top' height='auto' style='line-height:28px'><div class='listm'>"+list+"</div></td>  </tr></table><p><p>";
	}
	rs.close();


	} catch (Exception e){
   System.out.println("fenlei.jsp is error Exception :" + e);
} finally {
	if (rs!=null) rs.close();
	if (rs2!=null) rs2.close();
    if (stmt!=null) stmt.close();
	if (stmt2!=null) stmt2.close();
	
	if (con!=null) con.close();
	
	con = null;
}
//读入模板

StringBuffer strb = Tools.readFile(request.getRealPath("/3g/fenlei.html"),"UTF-8");

strb = Tools.replaceAll(strb,"[str]",str);


out.println(strb);

strb=null;
/**/

%>