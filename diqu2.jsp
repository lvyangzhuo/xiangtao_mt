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
	String sql = "";
	String id = Tools.RmNull(request.getParameter("id"));	//c_code
	String c = Tools.RmNull(request.getParameter("c"));		//栏目模板 c_mod
	String t = Tools.RmNull(request.getParameter("t"));
	String c_belong = Tools.RmNull(request.getParameter("c_belong"));
	String whereSql = "";
	String code = "";
	String bcode = "";
	String cname = "";
	String bname = "";
	String str = "";
	String list = "";
		String c_remark = "";
	String c_range = "";

	if (!c.equals("")) {
		whereSql = "and c_code="+c+" ";
	}
	try {
	
	con = db.getConnection();
	stmt = con.createStatement();
	stmt2 = con.createStatement();
	

	//取区域，和商圈信息
		String keys[] = {};
		
		sql = "select c_remark,c_range from t_user where c_admin=253 and c_userid='root'";
		rs = stmt.executeQuery(sql);
		if(rs.next())
		{
			c_remark = Tools.RmNull(rs.getString(1));//区域
			c_range = Tools.RmNull(rs.getString(2));  //商圈

			keys = c_remark.split(",");
			c_remark = "";
			for(int jj=0;jj<keys.length;jj++)
			{
				c_remark += "<span><a href=\"coupon_list.jsp?a="+keys[jj]+"\" class=searchbtn2>"+keys[jj]+"</a></span>";
				//c_remark += "<span><input type=button name=quyu"+jj+" value='"+keys[jj]+"' class=searchbtn2 onClick=\"window.location.href='coupon_list.jsp?a="+keys[jj]+"'\" ></span>";

				//list += "<span><input type=button name=quyu"+jj+" value='"+keys[jj]+"' class=searchbtn2 onClick=\"window.location.href='coupon_list.jsp?a="+keys[jj]+"'\" > </span>";
			}

			keys = c_range.split(",");
			c_range = "";
			for(int jj=0;jj<keys.length;jj++)
			{
				c_range += "<span><a href=\"coupon_list.jsp?q="+keys[jj]+"\"  class=searchbtn2>"+keys[jj]+"</a></span>";
				//c_range += "<span><input type=button name=quyu"+jj+" value='"+keys[jj]+"' class=searchbtn2 onClick=\"window.location.href='coupon_list.jsp?q="+keys[jj]+"'\" ></span>";
			}
		}
		rs.close();
		c_remark = c_remark+"<span><a href=\"coupon_list.jsp\" class=searchbtn2>全部区域</a></span>";

		c_range = c_range+"<span><a href=\"coupon_list.jsp\" class=searchbtn2>全部商圈</a></span>";
		

		str = "<table width='100%' border='0' class='tab-list'>  <tr>    <td valign='top' width='80' align=center style='line-height:28px'><B>按区域：</B><img src=images/hotel.png width='46' class=tu_pic></td>    <td valign='top' height='auto' style='line-height:30px'><div class='listm'>"+c_remark+"</div></td>  </tr></table><p><p>";
		
		str = str+"<table width='100%' border='0' class='tab-list'>  <tr>    <td valign='top' width='80' align=center style='line-height:28px'><B>按商圈：</B><img src=images/movie.png width='46' class=tu_pic></td>    <td valign='top' height='auto' style='line-height:30px'><div class='listm'>"+c_range+"</div></td>  </tr></table><p><p>";

	} catch (Exception e){
   System.out.println("diqu.jsp is error Exception :" + e);
} finally {
	if (rs!=null) rs.close();
	if (rs2!=null) rs2.close();
    if (stmt!=null) stmt.close();
	if (stmt2!=null) stmt2.close();
	
	if (con!=null) con.close();
	
	con = null;
}
//读入模板

StringBuffer strb = Tools.readFile(request.getRealPath("/3g/diqu.html"),"UTF-8");

strb = Tools.replaceAll(strb,"[str]",str);
strb = Tools.replaceAll(strb,"[c_remark]",c_remark);
strb = Tools.replaceAll(strb,"[c_range]",c_range);

out.println(strb);

strb=null;
/**/

%>