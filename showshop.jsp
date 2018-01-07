<%@ page contentType="text/html;charset=utf-8"%>
<%@ page language="java" import="java.util.*"%>
<%@ page language="java" import="java.lang.*"%>
<%@ page language="java" import="java.io.*"%>
<%@ page language="java" import="java.sql.*"%>
<%@ page language="java" import="com.wsu.basic.util.Tools"%>
<%@ page language="java" import="com.wsu.basic.dbsconnect.*"%>
<%@ page import = "com.wsu.basic.imageio.ImageTools"%>
<%
	/*
	 网站店铺终极页生成程序
	 */
	String v = Tools.RmNull(request.getParameter("v"));
	String sql = "";
	String modstr = "";
	String str = "";
	String foucs = "";
	String service = "";
	String c_fee2 = "";
	String c_main2 = "";
	String log = "";
	String npage = Tools.RmFilter(request.getParameter("npage"));
	String id = Tools.RmNull(request.getParameter("id")); //id
	String c_sname = "";
	String c_address = "";
	String c_des = "";
	String c_main = "";
	String c_tel = "";
	String c_hours = "";
	String c_service = "";
	String c_fee = "";
	String c_bus = "";
	String c_map = "";
	String c_logo = "";
	String c_logo2 = "";
	String c_grade = "";
	String c_name = "";
	String picname = "";

	String c_titles = "";
	String c_contents = "";
	String c_etime = "";
	String c_pname = "";
	String c_id = "";
	String c_vip = "";
	String c_web = "";

	
	String jiao = "";
	String jiao2 = "";
	int sx = 0;
	
	Connection con = null;
	Statement stmt = null;
	Statement stmt2 = null;
	ResultSet rs = null;
	ResultSet rs2 = null;
	int i = 0;
	int j= 0;
	try {
		DBcon dbcon = new DBcon(); //数据库连接
		con = dbcon.getConnection();
		stmt = con.createStatement();
		stmt2 = con.createStatement();

		//查询店铺商家基本信息
		sql = "select c_sname,c_address,t_shops.c_des,c_main,c_tel,c_hours,c_service,c_fee,c_bus,c_map,c_logo,t_shops.c_grade,c_name,c_web,c_qq,c_vip from "
				+ "t_shops,t_type where c_id="
				+ Tools.isNumber(id)
				+ " and t_shops.c_grade=t_type.c_code";
		rs = stmt.executeQuery(sql);
		if (rs.next()) {
			c_sname = rs.getString(1);
			c_address = Tools.RmNull(rs.getString(2));
			c_des = Tools.RmNull(rs.getString(3)).replaceAll("\n",
					"<br>");
			c_main = Tools.RmNull(rs.getString(4));
			c_tel = Tools.RmNull(rs.getString(5));
			c_hours = Tools.RmNull(rs.getString(6));
			c_service = Tools.RmNull(rs.getString(7));
			c_fee = Tools.RmNull(rs.getString(8)).replaceAll("人均", "");
			c_bus = Tools.RmNull(rs.getString(9));
			c_map = Tools.RmNull(rs.getString(10));
			c_logo = Tools.RmNull(rs.getString(11));
			c_grade = rs.getString(12);
			c_name = Tools.RmNull(rs.getString(13));
			c_web  = Tools.RmNull(rs.getString(14));
			c_vip = Tools.RmNull(rs.getString(16));
			c_logo2 = c_logo;
			sx++;
			if (c_logo.length() > 10) {
				c_logo = "/pic/" + c_logo.substring(0, 6) + "/"
						+ c_logo.substring(6, 8) + "/thumb_" + c_logo;
				c_logo2 = "/pic/" + c_logo2.substring(0, 6) + "/"
						+ c_logo2.substring(6, 8) + "/" + c_logo2;
				
				c_logo = "<img src=\""+c_logo2+"\"  height='180' width='290' border=\"0\" />";
				jiao = "img1=new Image();img1.src='"+c_logo2+"';\n";
				jiao2 = "url1=new Image();url1.src='down.jsp?id="+id+"&p="+c_logo2+"';\n";

			} else
				c_logo = "暂无图片";
		}
		rs.close();
		int g = Tools.isNumber(c_grade);
		if (g == 9 || g == 10) {
			c_fee2 = "人均消费";
			c_main2 = "特色美食";
		} else {
			c_fee2 = "消费参考";
			c_main2 = "特色服务";
		}
		if (c_service.indexOf("停车位") > -1)
			service = "<li class=\"style03\">有停车场</li>";
		if (c_service.indexOf("包间") > -1)
			service += "<li class=\"style04\">有独立包间</li>";
		if (c_service.indexOf("外卖") > -1)
			service += "<li class=\"style05\">有配送外卖</li>";
		if (c_service.indexOf("银联刷卡") > -1)
			service += "<li class=\"style02\">支持银联刷卡</li>";
		if (c_service.indexOf("网络") > -1)
			service += "<li class=\"style06\">支持无线网络</li>";

		if (c_main.length() > 11)
			c_main = c_main.substring(0, 11) + ".";

		
		ImageTools imgtool = new ImageTools();
		String width = "";
		int wth = 0;
		//查询店铺相册图片
		sql = "select c_pname from t_shops_p where c_sid="
				+ Tools.isNumber(id);
		rs = stmt.executeQuery(sql);
		i = 0;
		while (rs.next() && i < 3) {
			picname = rs.getString(1);
			if (picname.length() > 10)
				picname = "/pic/" + picname.substring(0, 6) + "/"
						+ picname.substring(6, 8) + "/" + picname;
			else
				picname = "/images/nopicb.jpg";
			
			width = imgtool.ToZoom(request.getRealPath(picname),0,237);
			width = width.substring(0,width.indexOf(","));
			
			wth = Tools.isNumber(width);
			if(wth>684)wth = 684;
			foucs += "<a href=\""
					+ picname
					+ "\" target=\"_blank\" title=\""+c_sname+"\" ><img src=\""
					+ picname
					+ "\" alt=\""+c_sname+"\" width=\""+wth+"\" height=\"237\"/></a>";
			jiao += "img"+(i+2)+"=new Image();img"+(i+2)+".src='"+picname+"';\n";
			jiao2 += "url"+(i+2)+"=new Image();url"+(i+2)+".src='down.jsp?id="+id+"&p="+picname+"';\n";
			sx++;

			i++;
		}
		if(i==0)foucs = "<a href=\"/images/no_focus.jpg\" target=\"_blank\"><img src=\"/images/no_focus.jpg\" alt=\""+c_sname+"\" width=\"684\" height=\"237\"/></a>";
		rs.close();
		j = i;

		//查询店铺所有优惠
		sql = "select c_titles,c_id,c_etime,c_pname from t_juan where c_sid="
				+ Tools.isNumber(id) + " and c_enable<9 order by c_id desc";
		rs = stmt.executeQuery(sql);
		i = 0;
		while (rs.next() && i < 8) {
			c_titles = rs.getString(1);
			//c_contents = rs.getString(2);
			c_id = rs.getString(2);
			c_etime = rs.getString(3).substring(0,10);
			c_pname = Tools.RmNull(rs.getString(4));
			
			
			if (c_pname.length() > 10)
				c_pname = "/pic/" + c_pname.substring(0, 6) + "/"
						+ c_pname.substring(6, 8) + "/thumb_" + c_pname;
			else
				c_pname = "/images/nopicb.jpg";
			
			if (c_titles.length() > 18)
				c_titles = c_titles.substring(0, 18) + "..";
			
			str += "<a href=\"showinfo.jsp?id="+c_id+"\" title=\"" + c_titles
			+ "\">" + c_titles + "</a> &nbsp;[<a href=\"showinfo.jsp?id="+c_id+"\">手机下载</a>] <!-- 截止:["+c_etime+"] --><br />";				
			i++;
		}
		rs.close();
		
		
		//查询店铺所发菜品
		if (c_vip.equals("2")) {
			str += "<a href=\"javascript:;\" class=\"good-lnk2\" style=\"margin-left:10px\"> <span class=\"tit\">店铺商品</span> </a>";

			sql = "select titles,t_news.rid,appdate from t_news where ctype_b="
				+ Tools.isNumber(id) + " and (ctype='cp' or ctype='tg' or ctype='wm') and enable<>255 order by rid desc";  //,t_pic.pictxt and t_news.rid=t_pic.rid 
			rs = stmt.executeQuery(sql);
			i = 0;
			while (rs.next() && i < 8) {
				c_titles = rs.getString(1);
				c_id = rs.getString(2);
				c_etime = rs.getString(3).substring(0,10);
				sql = "select pictxt from t_pic where rid="+c_id+" order by ord asc";
				rs2 = stmt2.executeQuery(sql);
				if (rs2.next()) {
					c_pname = rs2.getString(1);
					
				}
				rs2.close();
				
				
				if (c_pname.length() > 10)
					c_pname = "/pic/image/" + c_pname.substring(0, 8) + "/" + c_pname;
				else
					c_pname = "/images/nopicb.jpg";
				
				if (c_titles.length() > 18)
					c_titles = c_titles.substring(0, 18) + "..";
				
				
				str += "<a href=\"news_info.jsp?id="+c_id+"\" title=\"" + c_titles
				+ "\"><img src='"+c_pname+"' border=0 width=130 height=80>" + c_titles + "</a> &nbsp;<a href=\"news_info.jsp?id="+c_id+"\"><img src=/images/btn-sbook.png border=0></a> <div class=\"parting-line\" style='margin:8px 0'></div>";				
				i++;

			}
			rs.close();
		}


		

	} catch (Exception e) {
		System.out.println("shop_info error :" + e);
		e.printStackTrace();

	} finally {
		if (stmt2 != null) {
			stmt2.close();
		}

		if (stmt != null) {
			stmt.close();
		}
		if (con != null) {
			con.close();
		}

	}

	/*************读写模板文件操作*****************/

	//读模板,先判断此信息最终极分类有没有,没有读t_type c_belong根栏目分类模板,还没有读news_info.html资讯类默认模板
	String filename = request.getRealPath("/3g/shopinfo.html");
	File fileobj = new File(filename);
	if (!fileobj.exists()) {
		//如果模板文件找不到
		out.println("出错了,模板/3g/shopinfo.html文件找不到或丢失!");
		return;
	}
	//System.out.println(filename);

	

	//读入模板
	StringBuffer strb = Tools.readFile(filename,"UTF-8");

	strb = Tools.replaceAll(strb, "[c_name]", c_name);
	strb = Tools.replaceAll(strb, "[c_grade]", c_grade);
	strb = Tools.replaceAll(strb, "[c_titles]", c_sname);
	strb = Tools.replaceAll(strb, "[c_sname]", c_sname);
	strb = Tools.replaceAll(strb, "[foucs]", foucs);
	strb = Tools.replaceAll(strb, "[c_fee]", c_fee);
	strb = Tools.replaceAll(strb, "[c_fee2]", c_fee2);
	strb = Tools.replaceAll(strb, "[service]", service);
	strb = Tools.replaceAll(strb, "[c_service]", c_service);
	strb = Tools.replaceAll(strb, "[c_main]", c_main);
	strb = Tools.replaceAll(strb, "[c_main2]", c_main2);
	strb = Tools.replaceAll(strb, "[c_contents]", c_des);
	strb = Tools.replaceAll(strb, "[c_hours]", c_hours);
	strb = Tools.replaceAll(strb, "[c_address]", c_address);
	strb = Tools.replaceAll(strb, "[c_tel]", c_tel);
	strb = Tools.replaceAll(strb, "[c_map]", c_map);
	strb = Tools.replaceAll(strb, "[c_pname]", c_logo);
	strb = Tools.replaceAll(strb, "[c_logo2]", c_logo2);
	strb = Tools.replaceAll(strb, "[id]", id);
	strb = Tools.replaceAll(strb, "[str]", str);
	strb = Tools.replaceAll(strb,"[jiao]",jiao);
	strb = Tools.replaceAll(strb,"[jiao2]",jiao2);
	strb = Tools.replaceAll(strb,"[sx]",sx+"");

	strb = Tools.replaceAll(strb, "[c_web]", c_web);

	if(j<2){
		//店铺相册1张图时不滚动
		strb = Tools.replaceAll(strb, "b++", "//b++");
		strb = Tools.replaceAll(strb, "visibility:hidden;", "");
	}
	

	out.println(strb);

	strb = null;
%>

<jsp:include page="dianping.jsp">
<jsp:param name="sid" value="<%=id%>"/>
<jsp:param name="f" value=""/>
<jsp:param name="npage" value="<%=npage%>"/>
</jsp:include>