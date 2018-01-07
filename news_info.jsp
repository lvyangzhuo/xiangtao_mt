<%@ page contentType="text/html;charset=utf-8"%>
<%@ page language="java" import="java.util.*"%>
<%@ page language="java" import="java.lang.*"%>
<%@ page language="java" import="java.io.*"%>
<%@ page language="java" import="java.sql.*"%>
<%@ page language="java" import="com.wsu.basic.util.Tools"%>
<%@ page language="java" import="com.wsu.basic.dbsconnect.*"%>
<%@ page import="com.wsu.web.menuType.MenuGetType"%>
<%
/*
	资讯正文页生成程序
*/
	String sql = "";
	String modstr = "";
	String ctype = "";
	String c_alias = "";
	String c_mod = "";
	String c_name = "";
	String c_belong = "";
	String titles = "";
	String contents = "";
	String appdate = "";
	String appuser = "";
	String dinggou = "";
	String price = "";
	String sname = "";
	String surl = "";
	String npage = Tools.RmFilter(request.getParameter("npage"));
	int id = Tools.isNumber(Tools.RmNull(request.getParameter("id")));

	Connection con = null;
	Statement stmt = null;
	ResultSet rs = null;

	try {
		DBcon dbcon = new DBcon(); //数据库连接
		con = dbcon.getConnection();
		stmt = con.createStatement();

		sql = "select titles,ctype,contents,appdate,appuser,price,ctype_b from t_news where rid="
				+ id;
		rs = stmt.executeQuery(sql);
		if (rs.next()) {
			titles = rs.getString(1);
			ctype = rs.getString(2);
			contents = rs.getString(3);
			appdate = rs.getString(4).substring(0,16);
			appuser =  rs.getString(5);
			price =  Tools.RmNull(rs.getString(6));
			sname = Tools.RmNull(rs.getString(7));
		}
		rs.close();
		
		
		//if (contents.indexOf("<")>-1||contents.indexOf("<DIV")>-1||contents.indexOf("<P>")>-1||contents.indexOf("<p>")>-1) {
			
			//contents = "<div>"+origin+oauthor+"</div>"+contents;

			//显示时把 " 替换回来 
			contents = contents.replaceAll("&quot;","\"");

			StringBuffer strb_content = new StringBuffer(contents);
			//strb_content = Tools.replaceAll(strb_content,"&quot;","\"");
			strb_content = Tools.replaceAll(strb_content,"size=7","  style='font-size:46px;line-height:46px;'");
			strb_content = Tools.replaceAll(strb_content,"size=6","  style='font-size:36px;line-height:36px;'");
			strb_content = Tools.replaceAll(strb_content,"href","  style='text-decoration:underline' target='_blank' HREF");
			strb_content = Tools.replaceAll(strb_content,"<IMG","<Img onload=\"javascript:if(this.width>280)this.width=280;if(this.height>210)this.height=210;\"");
			strb_content = Tools.replaceAll(strb_content,"<img","<Img onload=\"javascript:if(this.width>280)this.width=280;if(this.height>210)this.height=210;\"");

			contents = strb_content.toString();
			
			//显示时把 " 替换回来 
			contents = contents.replaceAll("&quot;","\"");
			//out.println("<!--1111-->"); 
			
		/*
		}else	//批量入库的格式处理
		{
			//StringBuffer strb_content = Tools.txtFormat(new StringBuffer(contents));
			contents = contents.replaceAll("\n","<br>");
			//contents = strb_content.toString();
		}
		*/

		//取所属商家信息
		sql = "select c_id,c_sname from t_shops where c_id="+Tools.isNumber(sname)+"";
		rs = stmt.executeQuery(sql);
		if(rs.next())
		{
			sname = Tools.RmNull(rs.getString(2));
			sname = "<a href='showshop.jsp?id="+Tools.RmNull(rs.getString(1))+"'>"+sname+"</a>";
			surl = "showshop.jsp?id="+Tools.RmNull(rs.getString(1));
		}
		rs.close();

		sql = "select c_name,c_alias,c_mod,c_belong from t_type where c_code="
				+ Tools.isNumber(ctype);
		rs = stmt.executeQuery(sql);
		if (rs.next()) {
			c_name = rs.getString(1);
			c_alias = Tools.RmNull(rs.getString(2));
			c_mod = rs.getString(3);
			c_belong = rs.getString(4);
		}
		rs.close();
		
	} catch (Exception e) {
		System.out.println("news_info error :" + e);
		//e.printStackTrace();

	} finally {
		if (stmt != null) {
			stmt.close();
		}
		if (con != null) {
			con.close();
		}

	}

	/*************读写模板文件操作*****************/



		//读模板,先判断此信息最终极分类有没有,没有读t_type c_belong根栏目分类模板,还没有读news_info.html资讯类默认模板
		String filename = request.getRealPath("/3g/news_" + ctype
				+ ".html");
		File fileobj = new File(filename);
		if (!fileobj.exists()) {
			//如果模板文件找不到，则用Root根极模板文件
			filename = request.getRealPath("/3g/news_" + c_belong
					+ ".html");
			fileobj = new java.io.File(filename);
			if (!fileobj.exists()) {
				//如果还没有文件,就用资讯频道默认模板
				filename = request.getRealPath("/3g/news.html");
			}
		}
		//System.out.println(filename);
		
		//读入head 和 bottom 
	//读入模板
		StringBuffer strb =Tools.readFile(filename,"UTF-8");

		if (ctype.equals("cp")||ctype.equals("tg")||ctype.equals("wm")) {
			dinggou = "<h3 class=\"h_h3\">价格：￥"+price+".0 元<br>所属商家："+sname+"</h3><br><a href=\"shopping.jsp?id="+id+"\" class=\"ncis\" style=\"margin-left:100px\"><font color='#FFFFFF'>立即购买</font></a><br>";
		}else
		{
			strb = Tools.replaceAll(strb,"<!--start","");
			strb = Tools.replaceAll(strb,"end-->","");
		}
		strb = Tools.replaceAll(strb,"[dinggou]",dinggou);
		strb = Tools.replaceAll(strb,"[titles]",titles);
		strb = Tools.replaceAll(strb,"[contents]",contents);
		strb = Tools.replaceAll(strb,"[appdate]",appdate);
		strb = Tools.replaceAll(strb,"[c_name]",c_name);
		strb = Tools.replaceAll(strb,"[id]",id+"");
		strb = Tools.replaceAll(strb,"[appuser]",appuser);
		
		modstr = strb.toString();
		
		out.println(strb);
		strb = null;
		
		
%>

 



<jsp:include page="gentie.jsp">
<jsp:param name="jid" value="<%=id%>"/>
<jsp:param name="sid" value="0"/>
<jsp:param name="f" value=""/>
<jsp:param name="npage" value="<%=npage%>"/>
</jsp:include>