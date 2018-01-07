<%@ page contentType="text/html;charset=utf-8"%>
<%@ page language="java" import="java.util.*"%>
<%@ page language="java" import="java.lang.*"%>
<%@ page language="java" import="java.text.*"%>
<%@ page language="java" import="java.io.*"%>
<%@ page language="java" import="java.sql.*"%>
<%@ page language="java" import="com.wsu.basic.util.Tools"%>
<%@ page language="java" import="com.wsu.basic.dbsconnect.*"%>
<%@ page language="java" import="com.wsu.web.sql.DataTurnPage"%>
<%
	/*
	 优惠券列表页生成程序
	 */
	 request.setCharacterEncoding("utf-8");
	String v = Tools.RmNull(request.getParameter("v"));
	String sql = "";
	String modstr = "";
	String str = "";
	String morepage = "";
	String whereSql = "";
	String fenlei = ""; //分类菜单
	String diqu = ""; //地区
	String quan = ""; //商圈
	String msg = "优惠劵";
	
	//搜索选项
	String name = Tools.RmFilter(request.getParameter("name")); //名称
	String c = Tools.RmFilter(request.getParameter("c")); //类别分类,大类12类
	String a = Tools.RmFilter(request.getParameter("a")); //区
	String q = Tools.RmFilter(request.getParameter("q")); //商圈
	String e = Tools.RmFilter(request.getParameter("e")); //优惠券类型 4 
	String sid = Tools.RmFilter(request.getParameter("sid")); //商家id号

	String mm = Tools.RmNull(request.getParameter("mm")); //判断搜商家还是优惠券
	
	//翻页参数
	int count = 0; //总记录数
	int pagenum = 0; //总页数
	int shownum = 10; //每页显示篇数
	int pagenow = 0; //当前页码

	String snpage = request.getParameter("npage");

	if (snpage != null)
		pagenow = Tools.isNumber(snpage);
	if (pagenow < 1)
		pagenow = 1;

	if (request.getMethod() == "GET") {
		name = new String(name.getBytes("ISO-8859-1"), "utf-8");
		a = new String(a.getBytes("ISO-8859-1"), "utf-8");
		q = new String(q.getBytes("ISO-8859-1"), "utf-8");
	}

	//检索条件
	if (!name.equals("")) {
		whereSql = " and c_titles like '%" + name + "%'";
	}
	if (!c.equals("")) {
		whereSql += " and c_grade=" + c;

	}
	if (!a.equals("")) {
		whereSql += " and c_area='" + a + "'";
	}
	if (!q.equals("")) {
		whereSql += " and c_quan='" + q + "'";
	}
	if (!e.equals("")) {
		whereSql += " and c_enable=" + e;

	}
	if (!sid.equals("")) {
		whereSql += " and c_sid=" + sid;

	}
	//if (whereSql.length() > 5)
		//whereSql = whereSql.substring(4, whereSql.length());

	//System.out.println(whereSql);

	String picname = ""; 		//图片名
	String fname = "";
	String c_id = ""; 			//优惠劵id
	String c_sid = "";			//商家id
	String c_sname = ""; 		//商家名称
	String c_address = ""; 		//商家地址
	String c_tel = ""; 			//商家tel
	String tj = ""; 			//统计数  or 优惠券数 
	String c_titles = ""; 		//优惠券名称
	String c_contents = ""; 	//优惠内容
	String c_etime = ""; 		//有效期
	String c_p = ""; 			//打印数
	String c_v = ""; 			//浏览数
	String c_d = ""; 			//顶次数
	String appdate = "";
	
	Connection con = null;
	Statement stmt = null;
	Statement stmt2 = null;
	ResultSet rs = null;
	ResultSet rs2 = null;

	Calendar cal  = Calendar.getInstance();
	SimpleDateFormat formatter =new SimpleDateFormat("yyyy-MM-dd");
	String nowdate = formatter.format(cal.getTime());
	


	try {
		DBcon dbcon = new DBcon(); //数据库连接
		con = dbcon.getConnection();
		stmt = con.createStatement();
		//stmt2 = con.createStatement();

		sql = "select rid,enable,titles,contents,picname,appuser,appdate from t_news where enable<>255 and ctype='307' order by rid desc ";

		//System.out.println(sql);

		DataTurnPage tp = new DataTurnPage();
		//		@return n*m 1 sql语句 2 本页显示条数 3 第几页
		tp.selectTurnPage(sql, shownum, pagenow);

		List s = new ArrayList();
		s = tp.getRes(); //获得结果集
		pagenum = tp.getPagenum(); //获得总页数
		count = tp.getCount(); //获得总记录数

		//获得结果集字段
		Object[] obj = null;
		for (int i = 0; i < s.size(); i++) {

			obj = (Object[]) s.get(i);

			c_id = (String) obj[0];
			c_sid = (String) obj[1];
			c_titles = (String) obj[2];
			c_contents = Tools.rmHtml((String) obj[3]);
			picname = Tools.RmNull((String) obj[4]);
			c_etime = (String) obj[5];
			appdate = (String) obj[6];
			
			appdate = appdate.substring(0,8).replaceAll("-","");
			//统计数
			sql = "select c_p,c_v,c_d from t_juan_tj where c_jid="+c_id;
			rs = stmt.executeQuery(sql);
			if(rs.next())
			{
				c_v = rs.getString(2);
			}
			rs.close();
			
			//图片信息
			sql = "select pictxt from t_pic where rid="+c_id;
			rs = stmt.executeQuery(sql);
			if(rs.next())
			{
				picname = rs.getString(1);
				//c_address = Tools.RmNull(rs.getString(2));
			}
			rs.close();
			
		
			if (picname.length() > 10)
				picname = "/pic/image/" + picname.substring(0, 8) + "/" + picname;
			else
				picname = "/img/nopicb.jpg";

			fname = c_titles;
			//if(c_sname.length()>15)c_sname = c_sname.substring(0,15)+"..";
			if(c_contents.length()>68)c_contents = c_contents.substring(0,68)+"..";
			else c_contents = c_contents+"&nbsp;";
			
			int sj = new Random().nextInt(36);
			
			if (!name.equals(""))c_titles = c_titles.replaceAll(name,"<font color=red>"+name+"</font>");
			
			str += "<li style=\"padding: 10px;border-top: none;overflow: hidden;line-height: 1.6em;\"> <a href=\"news_info.jsp?id="+c_id+"\" title=\"" + fname+ "\" style=\"display: block;overflow: hidden;lear: both;padding: .22em 0;\"> <span class=\"mu-tmb\" style=\"float:left;margin-right:8px;\"><b style=\"position:absolute;padding:2px 2px 2px 2px;font-size:.65em;background:red;color:white;\">HOT</b><img src=\""+picname+"\"  width=\"100\" height=\"80\"> </span> <span>" + c_titles + "</span><span class=\"red\" style=\"display: block;\">分享人："+c_etime+"</span></a> </li>";

			//str += "<a href=\"news_info.jsp?id="+c_id+"\" title=\"" + fname
			//+ "\">" + c_titles + "</a> &nbsp;[<a href=\"news_info.jsp?id="+c_id+"\">手机下载</a>] | ["+c_address+"]<br />";
		}

		shownum = pagenow - 1;

	} catch (Exception ex) {
		System.out.println("coupon_list error :" + e);
		ex.printStackTrace();

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
	String filename = request.getRealPath("/3g/list.html");
	File fileobj = new File(filename);
	if (!fileobj.exists()) {
		//如果模板文件找不到
		out.println("出错了,模板list.html文件找不到或丢失!");
		return;
	}
	//System.out.println(filename);

	

	//读入模板
	StringBuffer strb =Tools.readFile(filename,"UTF-8");
	
	strb = Tools.replaceAll(strb, "[str]", str);
	strb = Tools.replaceAll(strb, "[msg]", msg);
	strb = Tools.replaceAll(strb, "[name]", name);
	strb = Tools.replaceAll(strb, "[q]", q);
	strb = Tools.replaceAll(strb, "[a]", a);
	strb = Tools.replaceAll(strb, "[c]", c);
	strb = Tools.replaceAll(strb, "[e]", e);
	strb = Tools.replaceAll(strb, "[sid]", sid);
	
	strb = Tools.replaceAll(strb, "[aa]", java.net.URLEncoder.encode(a, "utf-8"));
	strb = Tools.replaceAll(strb, "[qq]", java.net.URLEncoder.encode(q, "utf-8"));

	strb = Tools.replaceAll(strb, "[pagenum]", pagenum + "");
	strb = Tools.replaceAll(strb, "[pagenow]", pagenow + "");
	strb = Tools.replaceAll(strb, "[shownum]", shownum + "");
	strb = Tools.replaceAll(strb, "[count]", count + "");
	strb = Tools.replaceAll(strb, "<script language=\"javascript\" src=\"http://count25.51yes.com/click.aspx?id=253271550&logo=1\" charset=\"gb2312\"></script>","");
	
	//		屏蔽多余翻页
	if (pagenow == 1) {
		strb = Tools.replaceAll(strb, "[上一页]",
				"<a class=\"next\">上一页</a>");
		strb = Tools.replaceAll(strb, "[shang]",
				"<a class=\"next\">&nbsp;</a>");
		//strb = Tools.replaceAll(strb,"[首页]","<a >首页</a>");
	}
	if (pagenow == pagenum) {
		strb = Tools.replaceAll(strb, "[下一页]",
				"<a  class=\"next\">下一页</a>");
		//strb = Tools.replaceAll(strb,"[尾页]","<a >尾页</a>");
	}

	int fn = 1;
	int en = 11;
	if (pagenow > 10) {
		//System.out.println(pn/5);

		fn = (pagenow / 10) * 10;
		en = fn + 10;
	}
	for (int d = fn; d < en && d <= pagenum; d++) {

		if (d == pagenow) {

			morepage += "<a class=\"current\">" + d + "</a>";
		} else {
			morepage += "<a href=\"share_list.jsp?npage=" + d + "&name="
					+ name + "&c=" + c + "&q=" + q + "&a=" + a + "&e="
					+ e + "&sid=" + sid + "\" >" + d + "</a>";
		}

	}
	strb = Tools.replaceAll(strb, "[morepage]", morepage);

	if (pagenow >= pagenum)
		pagenow = pagenum;
	if (pagenow < pagenum)
		pagenow = pagenow + 1;

	if (!name.equals(""))
		strb = Tools.replaceAll(strb, "输入您想要的商家或优惠券", name);

	strb = Tools.replaceAll(strb, "[fenlei]", fenlei);
	
	
	//name = java.net.URLEncoder.encode(name, "GBK");
	strb = Tools.replaceAll(strb, "[shang]",
			"<a href=\"share_list.jsp?npage=" + shownum + "&name=" + name
					+ "&c=" + c + "&q=" + q + "&a=" + a + "&e=" + e
					+ "&sid=" + sid + "\" class=\"next\">&nbsp;</a>");

	strb = Tools.replaceAll(strb, "[上一页]", "<a href=\"share_list.jsp?npage="
			+ shownum + "&name=" + name + "&c=" + c + "&q=" + q + "&a="
			+ a + "&e=" + e + "&sid=" + sid
			+ "\" class=\"next\">上一页</a>");
	strb = Tools.replaceAll(strb, "[下一页]", "<a href=\"share_list.jsp?npage="
			+ pagenow + "&name=" + name + "&c=" + c + "&q=" + q + "&a="
			+ a + "&e=" + e + "&sid=" + sid
			+ "\" class=\"next\">下一页</a>");

	/*
	strb = Tools.replaceAll(strb,"[首页]",
	        "<a href=share_list.jsp?npage=1&c_sname=" + name + "&stime=&etime=&c="+c+">首页</a>");
	strb = Tools.replaceAll(strb,"[尾页]","<a href=share_list.jsp?npage="
	        + pagenum + "&c_sname=" + name + "&stime=&etime=&c="+c+">尾页</a>");
	 */

	strb = Tools.replaceAll(strb, "[npage]", pagenow + "");
	strb = Tools.replaceAll(strb,"[c_remark]","");
	strb = Tools.replaceAll(strb,"[c_range]","");
	strb = Tools.replaceAll(strb,"区域：","");
	

	out.println(strb);

	strb = null;
%>