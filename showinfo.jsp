<%@ page contentType="text/html;charset=utf-8"%>
<%@ page language="java" import="java.util.*"%>
<%@ page language="java" import="java.lang.*"%>
<%@ page language="java" import="java.io.*"%>
<%@ page language="java" import="java.sql.*"%>
<%@ page language="java" import="com.wsu.basic.util.Tools"%>
<%@ page language="java" import="com.wsu.basic.dbsconnect.*"%>
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
	String appdate = "";
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
	String tempStr = "";
	String next = "";
	String prev = "";

	String c_titles = "";
	String c_contents = "";
	String c_etime = "";
	String c_pname = "";
	String c_id = "";
	String c_sid = "";
	int c_p = 0;
	int c_v = 0;
	int c_mod = 0;
	Connection con = null;
	Statement stmt = null;
	Statement stmt2 = null;
	ResultSet rs = null;
	ResultSet rs2 = null;
	int i = 0;
	try {
		DBcon dbcon = new DBcon(); //数据库连接
		con = dbcon.getConnection();
		stmt = con.createStatement();
		
		//查询优惠劵详细信息
		sql = "select c_titles,c_contents,c_stime,c_etime,c_pname,t_juan.c_sid,c_p,c_v,c_appdate,c_mod,c_url from t_juan,t_juan_tj where t_juan.c_id="+Tools.isNumber(id)
		+" and t_juan.c_id=t_juan_tj.c_jid and c_enable<9";
		rs = stmt.executeQuery(sql);
		if (rs.next()) {
			c_titles = rs.getString(1);
			c_contents = rs.getString(2);
			c_etime = rs.getString(4).substring(0,10);
			c_pname = rs.getString(5);
			c_sid = rs.getString(6);
			
			c_p = rs.getInt(7);
			c_v = rs.getInt(8);
			appdate = rs.getString(9).substring(0,8).replaceAll("-","");
			c_mod = rs.getInt(10);
			if (c_pname.length() > 10){

				c_pname = "/pic/" + c_pname.substring(0, 6) + "/"
						+ c_pname.substring(6, 8) + "/" + c_pname;

			}else
			{
				c_pname = "/images/nopic_j.jpg";
			}
				
				if(c_mod==1) {
					c_pname = "<img src=\""+c_pname+"\" width=\"290\" border=\"0\" /><br><br><a href=sendyzm.jsp?c=1&jid="+Tools.isNumber(id)+" class=searchbtn2>在线领取验证码</a>&nbsp; <a href=down.jsp?id="+id+"&p="+c_pname+" class=searchbtn2>图片下载</a>"+
				"<div>&nbsp;</div>";
				}else if (c_mod==4) {
					//淘宝购物模板
					c_pname = "<img src=\""+c_pname+"\" width=\"290\" border=\"0\" /><br><br><a href='"+Tools.RmNull(rs.getString(11))+"' class=searchbtn2>立即购买</a>"+
								"<div>&nbsp;</div>";
				}else{
					c_pname = "<img src=\""+c_pname+"\" width=\"290\" border=\"0\" /><br><br><a href=sendyzm.jsp?c=1&jid="+Tools.isNumber(id)+" class=searchbtn2>在线领取验证码</a>&nbsp; <a href='sendsms.jsp?c=1&jid="+Tools.isNumber(id)+"' class=searchbtn2>短信下载</a>&nbsp; <a href=down.jsp?id="+id+"&p="+c_pname+" class=searchbtn2>图片下载</a>"+
				"<div>&nbsp;</div>";
				}

				

			/*
			}
			else
			{	c_pname = "暂无图片<br><br><a href='sendsms.jsp?c=1&jid="+Tools.isNumber(id)+"' class=searchbtn2>短信下载</a>&nbsp;";
			
			}
			*/
			if(c_etime.indexOf("2099")>-1)c_etime = "";
		}

		StringBuffer strb_content = new StringBuffer(c_contents);
		strb_content = Tools.replaceAll(strb_content,"<IMG","<Img onload='javascript:if(this.width>280)this.width=280' ");
		strb_content = Tools.replaceAll(strb_content,"<img","<Img onload='javascript:if(this.width>280)this.width=280' ");
		c_contents = strb_content.toString();
		
		
		
		//上一张 下一张

		//查询店铺商家基本信息
		sql = "select c_sname,c_address,t_shops.c_des,c_main,c_tel,c_hours,c_service,c_fee,c_bus,c_map,c_logo,t_shops.c_grade,c_name,c_web,c_qq from "
				+ "t_shops,t_type where c_id="
				+ Tools.isNumber(c_sid)
				+ " and t_shops.c_grade=t_type.c_code";
		rs = stmt.executeQuery(sql);
		if (rs.next()) {
			c_sname = rs.getString(1);

			c_sname = "<a href='showshop.jsp?id="+c_sid+"'>"+c_sname+"</a>";
			c_address = rs.getString(2);
			//c_des = Tools.RmNull(rs.getString(3)).replaceAll("\n","<br>");
			c_main = rs.getString(4);
			c_tel = rs.getString(5);
			c_hours = rs.getString(6);
			c_service = rs.getString(7);
			c_fee = Tools.RmNull(rs.getString(8)).replaceAll("人均", "");
			c_bus = rs.getString(9);
			c_map = rs.getString(10);
			c_logo = rs.getString(11);
			c_grade = rs.getString(12);
			c_name = rs.getString(13);
			c_logo2 = c_logo;
			if (c_logo.length() > 10) {
				c_logo = "/pic/" + c_logo.substring(0, 6) + "/"
						+ c_logo.substring(6, 8) + "/thumb_" + c_logo;
				c_logo2 = "/pic/" + c_logo2.substring(0, 6) + "/"
						+ c_logo2.substring(6, 8) + "/" + c_logo2;
			} else
				c_logo = "/images/nopicb.jpg";
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
		

		if (c_main.length() > 11)
			c_main = c_main.substring(0, 11) + ".";

		
		//查询本店铺其它优惠
		sql = "select c_titles,c_id,c_etime,c_pname from t_juan where c_sid="
				+ Tools.isNumber(c_sid) + " and c_id<>"+Tools.isNumber(id)+" and c_enable<9 order by c_id desc";
		rs = stmt.executeQuery(sql);
		i = 0;
		String titles ="";
		String etime ="";
		String pname ="";
		while (rs.next() && i < 8) {
			titles = rs.getString(1);
			etime = rs.getString(3).substring(0,10);
			pname = rs.getString(4);
			
			
			if (pname.length() > 10)
			{
				pname = "/pic/" + pname.substring(0, 6) + "/"
				+ pname.substring(6, 8) + "/thumb_" + pname;
				
				
			}else{
				pname = "暂无图片";
			}
				
			
			if (titles.length() > 18)
				titles = titles.substring(0, 18) + "..";

					str += "<a href=\"showinfo.jsp?id="+rs.getString(2)+"\" title=\"" + titles
					+ "\" class=\"good-lnk2\" style=\"margin-left:10px\"><span class=\"tit\">" + titles + "</span> </a> &nbsp;[<a href=\"showinfo.jsp?id="+rs.getString(2)+"\">手机下载</a>] <!-- 截止:["+etime+"] --><br />";		
					
			i++;
		}
		rs.close();
		

		
		

	} catch (Exception e) {
		System.out.println("/3g/showinfo error :" + e);
		e.printStackTrace();

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
	String filename = request.getRealPath("/3g/showinfo.html");
	File fileobj = new File(filename);
	if (!fileobj.exists()) {
		//如果模板文件找不到
		out.println("出错了,模板shop_info.html文件找不到或丢失!");
		return;
	}
	//System.out.println(filename);

	//读入模板
	StringBuffer strb = Tools.readFile(filename,"UTF-8");

	
	strb = Tools.replaceAll(strb, "[c_name]", c_name);
	strb = Tools.replaceAll(strb, "[c_grade]", c_grade);
	strb = Tools.replaceAll(strb, "[c_sname]", c_sname);
	strb = Tools.replaceAll(strb, "[foucs]", foucs);
	strb = Tools.replaceAll(strb, "[c_fee]", c_fee);
	strb = Tools.replaceAll(strb, "[c_fee2]", c_fee2);
	strb = Tools.replaceAll(strb, "[service]", service);
	strb = Tools.replaceAll(strb, "[c_service]", c_service);
	strb = Tools.replaceAll(strb, "[c_main]", c_main);
	strb = Tools.replaceAll(strb, "[c_main2]", c_main2);
	strb = Tools.replaceAll(strb, "[c_des]", c_des);
	strb = Tools.replaceAll(strb, "[c_hours]", c_hours);
	strb = Tools.replaceAll(strb, "[c_address]", c_address);
	strb = Tools.replaceAll(strb, "[c_tel]", c_tel);
	strb = Tools.replaceAll(strb, "[c_map]", c_map);
	strb = Tools.replaceAll(strb, "[c_logo]", c_logo);
	strb = Tools.replaceAll(strb, "[c_logo2]", c_logo2);
	strb = Tools.replaceAll(strb, "[c_sid]", c_sid);
	
	strb = Tools.replaceAll(strb, "[id]", id);
	strb = Tools.replaceAll(strb, "[c_titles]", c_titles);
	strb = Tools.replaceAll(strb, "[c_contents]", c_contents);
	strb = Tools.replaceAll(strb, "[c_etime]", c_etime);
	strb = Tools.replaceAll(strb, "[c_pname]", c_pname);
	strb = Tools.replaceAll(strb, "[c_p]", c_p+"");
	strb = Tools.replaceAll(strb, "[c_v]", c_v+"");
	
	strb = Tools.replaceAll(strb, "[next]", next);
	strb = Tools.replaceAll(strb, "[prev]", prev);
	
	strb = Tools.replaceAll(strb, "[str]", str);
	strb = Tools.replaceAll(strb, "[appdate]", appdate);

	

	out.println(strb);
	
	strb = null;
%>

<jsp:include page="jingli.jsp">
<jsp:param name="jid" value="<%=id%>"/>
<jsp:param name="sid" value="<%=c_sid%>"/>
<jsp:param name="f" value=""/>
<jsp:param name="npage" value="<%=npage%>"/>
</jsp:include>