<%@ page contentType="text/html;charset=GBK"%><%@ page language="java" import="java.text.*"%><%@ page language="java" import="java.util.*"%><%@ page language="java" import="java.lang.*"%><%@ page language="java" import="java.io.*"%><%@ page language="java" import="java.sql.*"%><%@ page language="java" import="com.wsu.basic.util.Tools"%><%@ page language="java" import="com.wsu.basic.dbsconnect.*"%><%@ page language="java" import="com.wsu.web.sql.DataTurnPage"%><%
	/*
	 ��վ�����б�ҳ���ɳ���
	 */
	request.setCharacterEncoding("GBK");
	String v = Tools.RmNull(request.getParameter("v"));
	String sql = "";
	String modstr = "";
	String str = "";
	String morepage = "";
	String whereSql = "";
	String fenlei = ""; //����˵�
	String diqu = ""; //����
	String quan = ""; //��Ȧ
	String listid = "";
	String title = "���̼�";	//seo �ؼ���
	String c_remark = "";	//����
	String c_range = "";	//��Ȧ
	//����ѡ��
	String name = Tools.RmFilter(request.getParameter("name")); //����
	String c = Tools.RmFilter(request.getParameter("c")); //������,����12��
	String g = Tools.RmFilter(request.getParameter("g")); //������,С��
	String a = Tools.RmFilter(request.getParameter("a")); //��
	String q = Tools.RmFilter(request.getParameter("q")); //��Ȧ
	String j = Tools.RmFilter(request.getParameter("j")); //�Ƿ����Żݾ�
	String mm = Tools.RmNull(request.getParameter("mm")); //�ж����̼һ����Ż�ȯ
	if (mm.equals("2")) {
		response.sendRedirect("/coupon/list.jsp?name="+new String(name.getBytes("GBK"), "ISO-8859-1"));
		return;
	}

	//��ҳ����
	int count = 0; //�ܼ�¼��
	int pagenum = 0; //��ҳ��
	int shownum = 12; //ÿҳ��ʾƪ��
	int pagenow = 0; //��ǰҳ��

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

	//��������
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
		whereSql += " and (c_sname like '%" + name + "%' or c_address like '%" + name + "%' or c_main like '%" + name + "%')";
		title = name;
	}

	
	if (j.equals("on")) {
		whereSql += " and c_jnum>0";
	}
	//System.out.println(request.getMethod());
	if ((request.getMethod() == "POST")&&(name.length()>0)) {
		//name = new String(name.getBytes("ISO-8859-1"), "GBK");
		Calendar cal  = Calendar.getInstance();
		SimpleDateFormat formatter2 = new java.text.SimpleDateFormat("yyyy-MM");
		String now =  formatter2.format(cal.getTime());	
		
		java.io.File f = new java.io.File(request.getRealPath("/log/"+now+".log"));
		BufferedWriter br = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(f,true)));  
		br.write(name+"_shop\r\n");  
		br.flush();       
		br.close();
	}
	//if (whereSql.length() > 5)
		//whereSql = "where " + whereSql.substring(4, whereSql.length());

	//System.out.println(whereSql);
	String msg = "�����̼�";
	String picname = ""; //ͼƬ��
	String fname = "";
	String sid = ""; //�̼�id
	String c_sname = ""; //�̼�����
	String c_address = ""; //�̼ҵ�ַ
	String c_tel = ""; //�̼�tel
	String tj = ""; //ͳ����  or �Ż�ȯ��
	String c_map = "";
	String c_vip = "";	//�̼ҵȼ�
	String c_hao = "";
	String c_dps = "";
	int star = 0;
	Connection con = null;
	Statement stmt = null;
	Statement stmt2 = null;
	ResultSet rs = null;
	ResultSet rs2 = null;
	
	sql = "select c_id,c_sname,c_address,c_tel,c_logo,c_jnum,c_vip,c_map,c_hao,c_dps from t_shops where c_enable=11"
		+ whereSql + " order by c_order desc,c_id desc";

	//System.out.println(sql);
	
	DataTurnPage tp = new DataTurnPage();
	//		@return n*m 1 sql��� 2 ��ҳ��ʾ���� 3 �ڼ�ҳ
	tp.selectTurnPage(sql, shownum, pagenow);
	
	List s = new ArrayList();
	//����ѡ��
	ArrayList daohang = new ArrayList();
	String zdh = "";

	try {
		DBcon dbcon = new DBcon(); //���ݿ�����
		con = dbcon.getConnection();
		stmt = con.createStatement();
		stmt2 = con.createStatement();

		
		s = tp.getRes(); //��ý����
		pagenum = tp.getPagenum(); //�����ҳ��
		count = tp.getCount(); //����ܼ�¼��
		String style = "";
		
		//��ý�����ֶ�
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
			
			listid += "sid["+i+"] = ['"+sid+"'];\n";
			
			star = Tools.isNumber(c_hao);
			if (picname.length() > 10)
				picname = "/pic/" + picname.substring(0, 6) + "/"
						+ picname.substring(6, 8) + "/thumb_" + picname;
			else
				picname = "/img/nopicb.jpg";

			fname = c_sname;
			//if(c_sname.length()>15)c_sname = c_sname.substring(0,15)+"..";
			
			if (!name.equals(""))c_sname = c_sname.replaceAll(name,"<font color=red>"+name+"</font>");
			if (c_tel.equals("0379-")||c_tel.equals(""))c_tel = "����";
			
			//��ʽ��ͬ
			if(i%2==0)style = "list1";else style = "list2";
			//if(Integer.parseInt(c_vip)>0)c_vip = "1";else c_vip ="2";
			c_hao = "";
			//���� 
			for (int n = 0; n < star; n++)c_hao+="<span class=\"bri\">&nbsp;</span>";
			for (int n = 0; n < (5-star); n++)c_hao+="<span class=\"dar\">&nbsp;</span>";
			
			if(Tools.isNumber(c_dps)>0)c_dps = "<a href=\"/waimai/shop_"+ sid+ ".html#dps\" target=_blank title=\""+c_dps+"������\">"+c_dps+"��</a>";
			else c_dps = c_dps+"��";

			//���Ʒ
			sql = "select count(rid) from t_news where enable<>255 and ctype='wm' and ctype_b="+Tools.isNumber(sid);
			rs = stmt.executeQuery(sql);
			if (rs.next()) {
				tj = rs.getString(1);
				
			}
			rs.close();

			str += "<li style=\"padding: 10px;border-top: none;overflow: hidden;line-height: 1.6em;\"> <a href=\"showshop.jsp?id="+sid+"\" title=\"" + fname+ "\" style=\"overflow: hidden;lear: both;padding: .22em 0;\"> <span class=\"mu-tmb\" style=\"float:left;margin-right:8px;\"><b style=\"position:absolute;padding:2px 2px 2px 2px;font-size:.65em;background:red;color:white;\">HOT</b><img src=\""+picname+"\"  width=\"110\" height=\"75\"> </span> <span>" + c_sname + "</span><!-- <span style=\"display: block;\">��ַ��"+c_address+"</span> --></a><a href=\"news_list.jsp?sid="+sid+"\" title=\"" + fname+ "\" style=\"display: block;overflow: hidden;lear: both;padding: .22em 0;\"><span style=\"display: block;\">  �� <font color=red>"+tj+"</font> ���Ʒ</span></a> </li>";	
			
			
			
		}
		if(s.size()==0)
		{
			//str = "<div class=\"list1 fl\" style=\"height:50px\"><div class=\"list-t fl\"><a class=\"tit2\" href='javascript:;'>"
			//+"��ѯ�������ݣ����������ؼ������ԣ�</a></div></div>";

			str = "<li style=\"padding: 10px;border-top: none;overflow: hidden;line-height: 1.6em;\"><a class=\"tit2\" href='javascript:;'>"
			+"��ѯ�������ݣ����Ժ��ԣ�</a></li>";
		}
		shownum = pagenow - 1;

		//ȡ���򣬺���Ȧ��Ϣ
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

		c_remark = c_remark+"<a href=\"diqu.jsp\" class=searchbtn2>����</a> ";

		//�����ർ������
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
			zdh += "<a href=\"/waimai/list.jsp?name=[name]&c="+bcode+"&q=[q]&a=[a]&j=[j]\" >"+bname+"</a>";
			if (dh==7) {
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
						list += "<a href=\"/waimai/list.jsp?c="+bcode+"&g="+code+"&q=[q]&a=[a]&j=[j]\" >"+cname+"</a>\n";
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
		System.out.println("shop_list error :" + e);
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

	/*************��дģ���ļ�����*****************/
	String filename = request.getRealPath("/3g/list.html");
	File fileobj = new File(filename);
	if (!fileobj.exists()) {
		//���ģ���ļ��Ҳ���
		out.println("������,ģ��list.html�ļ��Ҳ�����ʧ!");
		return;
	}
	//����ģ��
	StringBuffer strb =Tools.readFile(filename,"UTF-8");

	strb = Tools.replaceAll(strb, "[str]", str);
	strb = Tools.replaceAll(strb, "[msg]", msg);
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

	//		���ζ��෭ҳ
	if (pagenow == 1) {
		strb = Tools.replaceAll(strb, "[��һҳ]",
				"<a class=\"last\">��һҳ</a>");
		strb = Tools.replaceAll(strb,"[shang]","<a class=\"last\">&nbsp;</a>");
		//strb = Tools.replaceAll(strb,"[��ҳ]","<a >��ҳ</a>");
	}
	if (pagenow == pagenum) {
		strb = Tools.replaceAll(strb, "[��һҳ]",
				"<a  class=\"next\">��һҳ</a>");
		//strb = Tools.replaceAll(strb,"[βҳ]","<a >βҳ</a>");
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
			morepage += "<a href=\"/cgi/shop_lm.jsp?npage=" + d + "&name="
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
	strb = Tools.replaceAll(strb,"[shang]","<a href=\"/cgi/shop_lm.jsp?npage="
			+ shownum + "&name=" + name + "&c=" + c + "&g="+g+"&q=" + q + "&j="+j+"&a="
			+ a + "\" class=\"last\">&nbsp;</a>");
	
	strb = Tools.replaceAll(strb, "[��һҳ]", "<a href=\"/cgi/shop_lm.jsp?npage="
			+ shownum + "&name=" + name + "&c=" + c + "&g="+g+"&q=" + q + "&j="+j+"&a="
			+ a + "\" class=\"last\">��һҳ</a>");
	strb = Tools.replaceAll(strb, "[��һҳ]", "<a href=\"/cgi/shop_lm.jsp?npage="
			+ pagenow + "&name=" + name + "&c=" + c + "&g="+g+"&q=" + q + "&j="+j+"&a="
			+ a + "\" class=\"next\">��һҳ</a>");

	/*
	strb = Tools.replaceAll(strb,"[��ҳ]",
	        "<a href=list.jsp?npage=1&c_sname=" + name + "&stime=&etime=&c="+c+">��ҳ</a>");
	strb = Tools.replaceAll(strb,"[βҳ]","<a href=list.jsp?npage="
	        + pagenum + "&c_sname=" + name + "&stime=&etime=&c="+c+">βҳ</a>");
	 */

	strb = Tools.replaceAll(strb, "[npage]", pagenow + "");
	strb = Tools.replaceAll(strb, "[listid]", listid);
	strb = Tools.replaceAll(strb, "[title]", title);
	

	out.println(strb);
	
	strb = null;
%>