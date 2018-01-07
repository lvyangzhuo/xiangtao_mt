<%@ page contentType="text/html;charset=utf-8"%><%@ page language="java" import="java.text.*"%><%@ page language="java" import="java.util.*"%><%@ page language="java" import="java.lang.*"%><%@ page language="java" import="java.io.*"%><%@ page language="java" import="java.sql.*"%><%@ page language="java" import="com.wsu.basic.util.Tools"%><%@ page language="java" import="com.wsu.basic.dbsconnect.*"%><%@ page language="java" import="com.wsu.web.sql.DataTurnPage"%><%@ page language="java" import="java.util.regex.Matcher"%>
<%@ page language="java" import="java.util.regex.Pattern"%><%
	/*
	 网站店铺列表页生成程序
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
	String listid = "";
	String title = "团购商家";	//seo 关键词
	String c_remark = "";	//区域
	String c_range = "";	//商圈
	//搜索选项
	String name = Tools.RmFilter(request.getParameter("name")); //名称
	String c = Tools.RmFilter(request.getParameter("c")); //类别分类,大类12类
	String g = Tools.RmFilter(request.getParameter("g")); //类别分类,小类
	String a = Tools.RmFilter(request.getParameter("a")); //区
	String q = Tools.RmFilter(request.getParameter("q")); //商圈
	String j = Tools.RmFilter(request.getParameter("j")); //是否有优惠卷
	String mm = Tools.RmNull(request.getParameter("mm")); //判断搜商家还是优惠券
	if (mm.equals("2")) {
		response.sendRedirect("/coupon/list.jsp?name="+new String(name.getBytes("GBK"), "ISO-8859-1"));
		return;
	}

	//翻页参数
	int count = 0; //总记录数
	int pagenum = 0; //总页数
	int shownum = 12; //每页显示篇数
	int pagenow = 0; //当前页码

	String snpage = request.getParameter("npage");

	if (snpage != null)
		pagenow = Tools.isNumber(snpage);
	if (pagenow < 1)
		pagenow = 1;

	if (request.getMethod() == "GET") {
		name = new String(name.getBytes("ISO-8859-1"), "GBK");
		a = new String(a.getBytes("ISO-8859-1"), "GBK");
		q = new String(q.getBytes("ISO-8859-1"), "GBK");
	}

	//检索条件
	if (!a.equals("")) {
		whereSql = " and c_area='" + a + "'";
		title = a;
	}
	if (!q.equals("")) {
		whereSql += " and c_quan='" + q + "'";
		title = q;
	}
	if (!c.equals("")) {
		whereSql += " and c_grade=" + c;
		title = Tools.getType(c);
	}
	if (!g.equals("")) {
		whereSql += " and c_type=" + g;
		title = Tools.getType(g);
	}

	if (!name.equals("")) {
		whereSql += " and t_news.titles like '%" + name + "%' ";
		title = name;
	}

	/*
	if (j.equals("on")) {
		whereSql += " and c_jnum>0";
	}
	*/
	//System.out.println(request.getMethod());
	if ((request.getMethod() == "POST")&&(name.length()>0)) {
		//name = new String(name.getBytes("ISO-8859-1"), "GBK");
		Calendar cal  = Calendar.getInstance();
		SimpleDateFormat formatter2 = new java.text.SimpleDateFormat("yyyy-MM");
		String now =  formatter2.format(cal.getTime());	
		
		java.io.File f = new java.io.File(request.getRealPath("/log/"+now+".log"));
		BufferedWriter br = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(f,true)));  
		br.write(name+"_waimai\r\n");  
		br.flush();       
		br.close();
	}
	//if (whereSql.length() > 5)
		//whereSql = "where " + whereSql.substring(4, whereSql.length());

	//System.out.println(whereSql);

	String picname = ""; //图片名
	String fname = "";
	String sid = ""; //商家id
	String c_sname = ""; //商家名称
	String c_address = ""; //商家地址
	String c_tel = ""; //商家tel
	String tj = ""; //统计数  or 优惠券数
	String c_map = "";
	String c_vip = "";	//商家等级
	String c_hao = "";
	String c_dps = "";

	String rid = "";
	String titlescp = "";
	String price = "";
	String c_contents ="";
	int star = 0;
	Connection con = null;
	Statement stmt = null;
	Statement stmt2 = null;
	ResultSet rs = null;
	ResultSet rs2 = null;
	
	sql = "select c_id,c_sname,c_address,c_tel,c_logo,c_jnum,c_vip,c_map,c_hao,c_dps,t_news.rid,t_news.titles,t_news.price from t_shops,t_news where c_vip=2 and (c_enable<9 or c_enable=11)"
		+ whereSql + " and t_shops.c_id=t_news.ctype_b and t_news.ctype='cp' "+whereSql+" order by rid desc,c_id desc";

	//out.println(sql);
	
	DataTurnPage tp = new DataTurnPage();
	//		@return n*m 1 sql语句 2 本页显示条数 3 第几页
	tp.selectTurnPage(sql, shownum, pagenow);
	
	List s = new ArrayList();
	//导航选项
	ArrayList daohang = new ArrayList();
	String zdh = "";

	try {
		DBcon dbcon = new DBcon(); //数据库连接
		con = dbcon.getConnection();
		stmt = con.createStatement();
		stmt2 = con.createStatement();

		
		s = tp.getRes(); //获得结果集
		pagenum = tp.getPagenum(); //获得总页数
		count = tp.getCount(); //获得总记录数
		String style = "";
		
		//获得结果集字段
		Object[] obj = null;
		for (int i = 0; i < s.size(); i++) {

			obj = (Object[]) s.get(i);

			sid = (String) obj[0];
			c_sname = (String) obj[1];
			c_address = (String) obj[2];
			c_tel = (String) obj[3];
			picname = Tools.RmNull((String) obj[4]);
			tj = (String) obj[5];
			c_vip = (String) obj[6];
			c_map = Tools.RmNull((String) obj[7]);
			c_hao = Tools.RmNull((String) obj[8]);
			c_dps = Tools.RmNull((String) obj[9]);

			rid = Tools.RmNull((String) obj[10]);
			titlescp = Tools.RmNull((String) obj[11]);
			price = Tools.RmNull((String) obj[12]);
			
			listid += "sid["+i+"] = ['"+sid+"'];\n";
			
			star = Tools.isNumber(c_hao);
			

			fname = c_sname;

			String htmlStr = c_contents;
			String regEx_script = "<[\\s]*?script[^>]*?>[\\s\\S]*?<[\\s]*?\\/[\\s]*?script[\\s]*?>"; // 定义script的正则表达式{或<script[^>]*?>[\\s\\S]*?<\\/script>
			// }
			String regEx_style = "<[\\s]*?style[^>]*?>[\\s\\S]*?<[\\s]*?\\/[\\s]*?style[\\s]*?>"; // 定义style的正则表达式{或<style[^>]*?>[\\s\\S]*?<\\/style>
			// }
			String regEx_html = "<[^>]+>"; // 定义HTML标签的正则表达式
			String regEx_cont1 = "[\\d+\\s*`~!@#$%^&*\\(\\)\\+=|{}':;',\\[\\].<>/?~！@#￥%……&*（）——+|{}【】‘：”“’_]"; // 定义HTML标签的正则表达式
			String regEx_cont2 = "[\\w[^\\W]*]"; // 定义HTML标签的正则表达式[a-zA-Z]
			Pattern p_script = Pattern.compile(regEx_script, Pattern.CASE_INSENSITIVE);
			Matcher m_script = p_script.matcher(htmlStr);
			htmlStr = m_script.replaceAll(""); // 过滤script标签
			Pattern p_style = Pattern.compile(regEx_style, Pattern.CASE_INSENSITIVE);
			Matcher m_style = p_style.matcher(htmlStr);
			htmlStr = m_style.replaceAll(""); // 过滤style标签
			Pattern p_html = Pattern.compile(regEx_html, Pattern.CASE_INSENSITIVE);
			Matcher m_html = p_html.matcher(htmlStr);
			htmlStr = m_html.replaceAll(""); // 过滤html标签
			/*
			Pattern p_cont1 = Pattern.compile(regEx_cont1, Pattern.CASE_INSENSITIVE);
			Matcher m_cont1 = p_cont1.matcher(htmlStr);
			htmlStr = m_cont1.replaceAll(""); // 过滤其它标签
			Pattern p_cont2 = Pattern.compile(regEx_cont2, Pattern.CASE_INSENSITIVE);
			Matcher m_cont2 = p_cont2.matcher(htmlStr);
			htmlStr = m_cont2.replaceAll(""); // 过滤html标签
			*/
			c_contents = htmlStr;

			c_contents = c_contents.replaceAll("-","");
			//out.println("<!--==="+c_contents+"-->"); 
			

			if(c_contents.length()>35)c_contents = c_contents.substring(0,35)+"..";
			else c_contents = c_contents+"&nbsp;";


			//if(c_sname.length()>15)c_sname = c_sname.substring(0,15)+"..";
			
			if (!name.equals(""))titlescp = titlescp.replaceAll(name,"<font color=red>"+name+"</font>");
			if (c_tel.equals("0379-")||c_tel.equals(""))c_tel = "暂无";
			
			//样式不同
			if(i%2==0)style = "list1";else style = "list2";
			//if(Integer.parseInt(c_vip)>0)c_vip = "1";else c_vip ="2";
			c_hao = "";
			//星星 
			for (int n = 0; n < star; n++)c_hao+="<span class=\"bri\">&nbsp;</span>";
			for (int n = 0; n < (5-star); n++)c_hao+="<span class=\"dar\">&nbsp;</span>";
			
			if(Tools.isNumber(c_dps)>0)c_dps = "<a href=\"/waimai/shop_"+ sid+ ".html#dps\" target=_blank title=\""+c_dps+"条点评\">"+c_dps+"条</a>";
			else c_dps = c_dps+"条";

			//查菜品
			sql = "select count(rid) from t_news where enable<>255 and ctype='cp' and ctype_b="+Tools.isNumber(sid);
			rs = stmt.executeQuery(sql);
			if (rs.next()) {
				tj = rs.getString(1);
				
			}
			rs.close();

			picname = "";
			//查图片
			sql = "select pictxt from t_pic where rid="+rid+" order by ord asc";
			rs = stmt.executeQuery(sql);
			if (rs.next()) {
				picname = rs.getString(1);
				
			}
			rs.close();

			if (picname.length() > 10)
				picname = "/pic/image/" + picname.substring(0, 8) + "/"
						+ picname;
			else
				picname = "/images/nopic_j.jpg";

			//"+c_vip+"
			
			/*
			str += "<DIV class=\"border-outer\"><DIV class=\"border-inner \" ><DIV class=\"deal_tag\"><A target=\"_blank\"></A></DIV><DIV class=\"deal-img-content\"><A href=\"/waimai/"
				+ rid
				+ ".html\" target=\"_blank\" ><IMG class=\"deal-img dynload\" alt=\""+fname+"\" src=\""+picname+"\" ></A></DIV><DIV class=\"deal-title linkHoverBlue\"><A class=\"title\"  href=\"/waimai/"
				+ rid
				+ ".html\" target=\"_blank\" ><DIV class=\"indent\"><EM >"+titlescp+"</EM></DIV></A><A class=\"title\" href=\"/shop/shop_"
				+ sid
				+ ".html\" target=\"_blank\" ><SPAN>商家【"+c_sname+"】</SPAN></A></DIV><DIV class=\"deal-price-btn\"><DIV class=\"price\"><SPAN class=\"symbol\"></SPAN>                                                                <SPAN class=\"value \" style='font-size:14px'>价格:<B><span style='color:red'> ￥"+price+".0元</span></B>                                        </SPAN></DIV><SPAN class=\"deal-btn\"><A class=\"participation\" href=\"/waimai/"
				+ rid
				+ ".html\" target=\"_blank\"   alt=\""+fname+"\">参与</A></SPAN></DIV><DIV class=\"deal-people-address\"><SPAN class=\"deal-people\"><!-- <SPAN class=\"num\">20</SPAN> --><span class=\"xq\"  onClick=\"userAct('a_"+sid+"')\">想买：</span><span class=\"gra pi\" onClick=\"userAct('a_"+sid+"')\" id='a_"+sid+"'>0</span>&nbsp;<span class=\"qg\"  onClick=\"userAct('b_"+sid+"')\">买过：</span><span class=\"gra pi\" onClick=\"userAct('b_"+sid+"')\" id='b_"+sid+"'>0</span></SPAN></DIV></DIV></DIV>";
				*/

				str += "<li style=\"padding: 10px;border-top: none;overflow: hidden;line-height: 1.6em;\"> <a href=\"news_info.jsp?id="+rid+"\" title=\"" + fname+ "\" style=\"display: block;overflow: hidden;lear: both;padding: .22em 0;\"> <span class=\"mu-tmb\" style=\"float:left;margin-right:8px;\"><b style=\"position:absolute;padding:2px 2px 2px 2px;font-size:.65em;background:red;color:white;\">HOT</b><img src=\""+picname+"\"  width=\"100\" height=\"80\"> </span> <span>" + titlescp + "</span><span class=\"red\" style=\"display: block;\">单价：￥"+price+".0元</span><span><img src=/images/btn-sbook.png border=0></span></a> </li>";

			
		}
		if(s.size()==0)
		{
			str = "<div class=\"list1 fl\" style=\"height:50px\"><div class=\"list-t fl\"><a class=\"tit2\" href='javascript:;'>"
			+"查询暂无数据，请您换个关键词试试！</a></div></div>";
		}
		shownum = pagenow - 1;

		//取区域，和商圈信息
		String keys[] = {};
		sql = "select c_remark,c_range from t_user where c_admin=253 and c_userid='root'";
		rs = stmt.executeQuery(sql);
		if(rs.next())
		{
			c_remark = Tools.RmNull(rs.getString(1));
			c_range = Tools.RmNull(rs.getString(2));

			keys = c_remark.split(",");
			c_remark = "";
			for(int jj=0;jj<keys.length&&jj<3;jj++)
			{
				c_remark += "<a href=\"shop_wm.jsp?name=[name]&c=[c]&j=[j]&a="+keys[jj]+"\"  class=searchbtn2>"+keys[jj]+"</a> ";
			}

			keys = c_range.split(",");
			c_range = "";
			for(int jj=0;jj<keys.length&&jj<3;jj++)
			{
				c_range += "<a href=\"shop_wm.jsp?name=[name]&c=[c]&q="+keys[jj]+"&j=[j]\"  class=searchbtn2>"+keys[jj]+"</a> ";
			}
		}
		rs.close();

		c_remark = c_remark+"<a href=\"diqu.jsp\" class=searchbtn2>更多</a> ";

		//按分类导航生成
		String bcode = "";
		String bname = "";
		String code = "";
		String cname = "";
		String list = "";
		String btitle = "";
		int dd = 0;
		int dh = 0;
		sql = "select c_code,c_name,c_belong from t_type where c_grade<9 and c_belong=8 order by c_enable asc";
		rs = stmt.executeQuery(sql);
		while (rs.next()) {
			bcode = rs.getString(1);
			bname =  rs.getString(2);
			
			btitle ="";
			sql = "select c_code,c_name,c_belong from t_type where c_grade<9 and c_belong="+bcode+" order by c_enable asc";
			rs2 = stmt2.executeQuery(sql);
			zdh += "<a href=\"/waimai/pic.jsp?name=[name]&c="+bcode+"&q=[q]&a=[a]&j=[j]\" >"+bname+"</a>";
			if (dh==6) {
				zdh=zdh+"<br>";
			}
			list = "";
			dd = 0;
			while (rs2.next()) {
				code = rs2.getString(1);
				cname = rs2.getString(2);
				btitle += cname;

				if (btitle.length()>25&&dd==8) {
						list += "</li><li class=\"zfhang\"><a href=\"/waimai/list.jsp?c="+bcode+"&g="+code+"&q=[q]&a=[a]&j=[j]\" >"+cname+"</a>\n			";
				}else{
						list += "<a href=\"/waimai/pic.jsp?c="+bcode+"&g="+code+"&q=[q]&a=[a]&j=[j]\" >"+cname+"</a>\n";
				}
				dd++;
			}
			rs2.close();

			list = list+"\n";
			
			daohang.add("<div id=\"z"+bcode+"\" class=\"zf\">		<div class=\"zftop\"><span class=\"guanbi\" onClick=\"clszf('z"+bcode+"')\">&nbsp;</span>\n</div>		<div class=\"zfmiddle\">		<ul><li>"+list+"</li>		</ul>		</div>	</div>\n");

			//System.out.println(daohang.get(dd)+"____");
			dh++;
		}
		rs.close();

	} catch (Exception e) {
		System.out.println("3g/shop_wmpic error :" + e);
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
	String filename = request.getRealPath("/3g/list.html");
	File fileobj = new File(filename);
	if (!fileobj.exists()) {
		//如果模板文件找不到
		out.println("出错了,模板shop_lm.html文件找不到或丢失!");
		return;
	}
	//System.out.println(filename);

	StringBuffer strb =Tools.readFile(filename,"UTF-8");


	strb = Tools.replaceAll(strb, "[zdh]", zdh);
	for(int dd=0;dd<daohang.size();dd++)
	{
		strb = Tools.replaceAll(strb, "[daohang"+dd+"]", daohang.get(dd)+"");
	}
	int mw = 0;
	for(int dd=0;dd<(14-daohang.size());dd++)
	{
		mw = dd+daohang.size();
		strb = Tools.replaceAll(strb, "[daohang"+mw+"]","");
	}

	strb = Tools.replaceAll(strb, "[msg]", title);
	strb = Tools.replaceAll(strb, "[c_remark]", c_remark);
	strb = Tools.replaceAll(strb, "[c_range]", c_range);
	//strb = Tools.replaceAll(strb, "[right]", strb_r.toString());
	strb = Tools.replaceAll(strb, "[str]", str);

	strb = Tools.replaceAll(strb, "[name]", name);
	strb = Tools.replaceAll(strb, "[q]", q);
	strb = Tools.replaceAll(strb, "[a]", a);
	strb = Tools.replaceAll(strb, "[c]", c);
	strb = Tools.replaceAll(strb, "[g]", g);
	strb = Tools.replaceAll(strb, "[j]", j);
	
	strb = Tools.replaceAll(strb, "[aa]", java.net.URLEncoder.encode(a, "GBK"));
	strb = Tools.replaceAll(strb, "[qq]", java.net.URLEncoder.encode(q, "GBK"));

	strb = Tools.replaceAll(strb, "[pagenum]", pagenum + "");
	strb = Tools.replaceAll(strb, "[pagenow]", pagenow + "");
	strb = Tools.replaceAll(strb, "[shownum]", shownum + "");
	strb = Tools.replaceAll(strb, "[count]", count + "");
	strb = Tools.replaceAll(strb, "<script language=\"javascript\" src=\"http://count25.51yes.com/click.aspx?id=253271550&logo=1\" charset=\"gb2312\"></script>","");
	
	//		屏蔽多余翻页
	if (pagenow == 1) {
		strb = Tools.replaceAll(strb, "[上一页]",
				"<a class=\"last\">上一页</a>");
		strb = Tools.replaceAll(strb,"[shang]","<a class=\"last\">&nbsp;</a>");
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
			morepage += "<a href=\"shop_wmpic.jsp?npage=" + d + "&name="
					+ name + "&c=" + c + "&g="+g+"&q=" + q + "&j="+j+"&a=" + a + "\" >"
					+ d + "</a>";
		}

	}
	
	//strb = Tools.replaceAll(strb, "if(j==0)", "$(\"#union\")[0].className=\"current\";\n //if(j==0)");
	
	
	
	strb = Tools.replaceAll(strb, "[morepage]", morepage);

	if (pagenow >= pagenum)
		pagenow = pagenum;
	if (pagenow < pagenum)
		pagenow = pagenow + 1;

	if (!name.equals("")){
		strb = Tools.replaceAll(strb, "id=\"query\" value=\"\"", "id=\"query\" value=\""+name+"\"");
	}
	strb = Tools.replaceAll(strb, "[fsuo]", name);	

	strb = Tools.replaceAll(strb, "[fenlei]", fenlei);

	//name = java.net.URLEncoder.encode(name, "GBK");
	strb = Tools.replaceAll(strb,"[shang]","<a href=\"shop_wmpic.jsp?npage="
			+ shownum + "&name=" + name + "&c=" + c + "&g="+g+"&q=" + q + "&j="+j+"&a="
			+ a + "\" class=\"last\">&nbsp;</a>");
	
	strb = Tools.replaceAll(strb, "[上一页]", "<a href=\"shop_wmpic.jsp?npage="
			+ shownum + "&name=" + name + "&c=" + c + "&g="+g+"&q=" + q + "&j="+j+"&a="
			+ a + "\" class=\"last\">上一页</a>");
	strb = Tools.replaceAll(strb, "[下一页]", "<a href=\"shop_wmpic.jsp?npage="
			+ pagenow + "&name=" + name + "&c=" + c + "&g="+g+"&q=" + q + "&j="+j+"&a="
			+ a + "\" class=\"next\">下一页</a>");

	/*
	strb = Tools.replaceAll(strb,"[首页]",
	        "<a href=list.jsp?npage=1&c_sname=" + name + "&stime=&etime=&c="+c+">首页</a>");
	strb = Tools.replaceAll(strb,"[尾页]","<a href=list.jsp?npage="
	        + pagenum + "&c_sname=" + name + "&stime=&etime=&c="+c+">尾页</a>");
	 */

	strb = Tools.replaceAll(strb, "[npage]", pagenow + "");
	strb = Tools.replaceAll(strb, "[listid]", listid);
	strb = Tools.replaceAll(strb, "[title]", title);
	
	out.println(strb);


	strb = null;
%>