<%@ page contentType="text/html;charset=GBK"%>
<%@ page language="java" import="java.util.*"%>
<%@ page language="java" import="java.lang.*"%>
<%@ page language="java" import="java.io.*"%>
<%@ page language="java" import="java.sql.*"%>
<%@ page language="java" import="com.wsu.basic.util.Tools"%>
<%@ page language="java" import="com.wsu.basic.dbsconnect.*"%>
<%
/*
	��վ��ҳ���ɳ���
*/
	String v = Tools.RmNull(request.getParameter("v"));
	String sql = "";
	String modstr = "";
	String wyjm = "";		//��Ҫ����
	String gdgg = "";		//������
	String yhjx = "";		//�Żݾ�ѡ
	String juan = "";		//�Ƽ��Ż�ȯ
	String shop = "";		//�Ƽ��̼�
	String link = "";		//��������
	String jiao = "";
	String jiao2 = "";
	String style= "";
	
	String id = "";				//id
	String name = "";			//����
	String picname = "";		//ͼƬ��
	String url = "";			
	String etime = "";			//��ֹʱ��
	String sid = "";			//�̼�id
	String s_name = "";			//�̼�����
	String address = "";		//�̼ҵ�ַ
	String count = "";			//ͳ����  or �Ż�ȯ�� 
	String c_remark = "";
	String c_range = "";


	//������Ϣ
	String w_tel = "";
	String w_qun="";
	String w_web="";
	String w_mail = "";
	String w_im ="";
	String w_keyword ="";
	String w_name = "";
	String w_icp = "";
	String w_city = "";
	String c_fax = "";
	String aboutusn = "";
	String aboutus = "";
	String contact = "";
	String contactn = "";
	
	Connection con = null;
	Statement stmt = null;
	Statement stmt2 = null;
	ResultSet rs = null;
	ResultSet rs2 = null;
	int i = 0;
	try {
		DBcon dbcon = new DBcon(); //���ݿ�����
		con = dbcon.getConnection();
		stmt = con.createStatement();
		stmt2 = con.createStatement();


		
		//��Ҫ����
		/*
		sql = "select titles,origin,rid from t_news where enable<255 and ctype='217' order by ctype_b";
		rs = stmt.executeQuery(sql);
		while (rs.next()&&i<8) {

			name = Tools.RmNull(rs.getString(1));
			url = Tools.RmNull(rs.getString(2));
			id =  rs.getString(3);
			
			if(url.length()<8)url="/index.html";
			
			//ȡͼ
			sql = "select picname from t_pics where rid="+id;
			rs2= stmt2.executeQuery(sql);
			if(rs2.next())picname = Tools.RmNull(rs2.getString(1));
				
			if(picname.length()>10)picname = "/pic/"+picname.substring(0, 6)+"/"+picname.substring(6, 8)+"/"+picname; 
			else picname = "/images/nopic.jpg";
			
			if(i==7)wyjm += "<li class=\"last\"><a href=\""+url+"\" target=_blank><img src=\""+picname+"\" width=\"90\" height=\"58\" alt=\""+name+"\" /></a></li>";
			else wyjm += "<li ><a href=\""+url+"\" target=_blank><img src=\""+picname+"\" width=\"90\" height=\"58\" alt=\""+name+"\" /></a></li>";
			//onmouseover=\"this.style.borderStyle='solid'; this.style.borderWidth='1px'; this.style.borderColor='#FF4100'\" onmouseout=\"this.style.borderStyle='dashed'; this.style.borderWidth='0px'; this.style.borderColor='#fff'\"
			i++;
		}
		rs.close();
		*/

		sql = "select c_units_des,c_tel,c_mobile,c_web,c_email,c_im,c_main,c_address,c_units_no,c_post,c_mobile2,c_fax from t_user where c_userid='root'";
		rs = stmt.executeQuery(sql);
		if (rs.next()) {

			//name = Tools.RmNull(rs.getString(1));	//������  

			w_tel = Tools.RmNull(rs.getString(2));	
			w_qun = Tools.RmNull(rs.getString(3));
			w_web = Tools.RmNull(rs.getString(4));
			w_mail = Tools.RmNull(rs.getString(5));
			w_im = Tools.RmNull(rs.getString(6));
			w_keyword = Tools.RmNull(rs.getString(7));
			w_name = Tools.RmNull(rs.getString(8));
			w_icp = Tools.RmNull(rs.getString(9));
			w_city =Tools.RmNull(rs.getString(10));
			//coupon_style=Tools.RmNull(rs.getString(11));
			c_fax = Tools.RmNull(rs.getString(12));

			
		}
		rs.close();

		//��ѯ�������Ǻ���ϵ��ʽ
		sql = "select titles,t_news.contents from t_type,t_news where c_alias='/aboutus.html' and t_type.c_code=t_news.ctype";
		rs = stmt.executeQuery(sql);
		if (rs.next()) {
			aboutusn = Tools.RmNull(rs.getString(1));
			aboutus = Tools.RmNull(rs.getString(2));
		}
		rs.close();

		sql = "select titles,t_news.contents from t_type,t_news where c_alias='/contact.html' and t_type.c_code=t_news.ctype";
		rs = stmt.executeQuery(sql);
		if (rs.next()) {
			contactn = Tools.RmNull(rs.getString(1));
			contact = Tools.RmNull(rs.getString(2));
		}
		rs.close();
		
		
		//�������ͼƬ  �����Ż� 4��
		sql = "select titles,origin,rid from t_news where enable<255 and ctype='18' order by ctype_b";
		rs = stmt.executeQuery(sql);
		i=0;
		while (rs.next()&&i<4) {

			name = Tools.RmNull(rs.getString(1));
			url = Tools.RmNull(rs.getString(2));
			id =  rs.getString(3);
			name = name.replaceAll(" ","");
			
			if(name.length()>9)name = name.substring(0,9);
			if(url.length()<8)url="/index.html";
			
			//ȡͼ
			sql = "select picname from t_pics where rid="+id;
			rs2= stmt2.executeQuery(sql);
			if(rs2.next())picname = Tools.RmNull(rs2.getString(1));
				
			if(picname.length()>10)picname = "/pic/"+picname.substring(0, 6)+"/"+picname.substring(6, 8)+"/"+picname; 
			else picname = "/images/nopic.jpg";
			
			//gdgg += "['"+picname+"','"+name+"','"+url+"'],";

			if (i==0) {
				style = "first";
			}else
			{
				style = "";
			}
			
			



			jiao += "img"+(i+1)+"=new Image();img"+(i+1)+".src='"+picname+"';\n";
			jiao2 += "url"+(i+1)+"=new Image();url"+(i+1)+".src='"+url+"';\n";
			i++;
		}
		rs.close();
		
		
		
		//վ�ڹ��� 4��
		/*
		sql = "select rid,titles,appdate from t_news where enable<255 and ctype='4' order by rid desc";
		rs = stmt.executeQuery(sql);
		i=0;
		while (rs.next()&&i<4) {
			
			id =  rs.getString(1);
			name = Tools.RmNull(rs.getString(2));
		
			if(name.length()>15)name = name.substring(0,15)+"..";
			
			zngg += "<li><a href=\"/news/"+id+".html\" target=_blank>"+name+"</a></li>";
			
			i++;
		}
		rs.close();
		*/
		
		//������ 4��
		sql = "select rid,titles,price,appdate from t_news,t_index where enable<>255 and (ctype='cp' or ctype='tg' or ctype='wm') and t_index.c_sid=t_news.rid and c_txt='sjcp' order by c_id";
		rs = stmt.executeQuery(sql);
		i=0;
		while (rs.next()&&i<4) {
			
			id =  rs.getString(1);
			name = Tools.RmNull(rs.getString(2));
			url = Tools.RmNull(rs.getString(3));
			if(name.length()>12)name = name.substring(0,12)+"..";

			sql = "select pictxt from t_pic where rid="+id;
			rs2= stmt2.executeQuery(sql);
			picname = "";
			if(rs2.next()){
				
				picname = Tools.RmNull(rs2.getString(1));
			}
			if (picname.length() > 10)
				picname = "/pic/image/" + picname.substring(0, 8) + "/" + picname;
			else
				picname = "/images/nopic_j.jpg";

			if (i==0) {
				style = "first";
			}else
			{
				style = "";
			}
			
			gdgg += "<a href=\"news_info.jsp?id="+id+"\"  title=\"" + name
			+ "\">						<div class=\"box "+style+"\">							<table cellspacing=\"0\" cellpadding=\"0\" class=\"tab\" width=\"95%\" >								<tbody>									<tr>										<td class=\"p-img\" style=\"float:none;\" width=\"105px\"><img src=\""+picname+"\"  alt=\"\"/></td>										<td  valign=\"top\" class=\"text\"><div class=\"p-name\" style=\"color: #3C3C3C;font-size: 0.875em;\" >" + name + "<font color=\"red\"></font> </div>											<div class=\"p-detail\" style=\"width:180px; float:right;line-height:25px\"><span style=\"float:left;display:block;width:140px;\">�����Ƽ��� <font  class=bri2>&nbsp;</font><br>�۸�:��"+url+".0Ԫ</span>&nbsp;<font  class=bri3>&nbsp;</font></div></td>									</tr>								</tbody>							</table>						</div>						</a>";
			//yhjx += "<li><a href=\"/coupon/coupon_"+id+".html\" target=_blank>"+name+"</a></li>";
			
			i++;
		}
		rs.close();

		
		//�Ƽ��Ż�ȯ 6��
		String c_v = "";
		sql = "select c_sid,c_txt from t_index where c_txt='juan' order by c_id";
		rs = stmt.executeQuery(sql);
		i=0;
		while (rs.next()&&i<4) {
			id =  rs.getString(1);
			
			//ȡ����Ϣ,��ͳ����Ϣ
			sql = "select t_juan.c_id,t_juan.c_sid,c_titles,c_etime,c_pname,c_p,c_v from t_juan,t_juan_tj where t_juan.c_id="
			+id+" and t_juan.c_id=t_juan_tj.c_jid";
			rs2= stmt2.executeQuery(sql);
			if(rs2.next()){
				sid = rs2.getString(2);
				name = Tools.RmNull(rs2.getString(3));
				etime = Tools.RmNull(rs2.getString(4));
				picname = Tools.RmNull(rs2.getString(5));
				count = Tools.RmNull(rs2.getString(6));
				c_v  = Tools.RmNull(rs2.getString(7));
			}
			url = name;
			//if(name.length()>8)name = name.substring(0,8)+".";
			etime = etime.substring(0,10).replaceAll("-",".");
			if(etime.indexOf("2099")>-1)etime = "������Ч";
			if(picname.length()>10)picname = "/pic/"+picname.substring(0, 6)+"/"+picname.substring(6, 8)+"/thumb_"+picname; 
			else picname = "/images/nopic.jpg";
			
			//ȡ�̼���
			sql = "select c_sname from t_shops where c_id="+sid;
			rs2= stmt2.executeQuery(sql);
			if(rs2.next())s_name = rs2.getString(1);
			else s_name = "";
			address = s_name;
			if(s_name.length()>8)s_name = s_name.substring(0,8)+".";
			
			if (i==0) {
				style = "first";
			}else
			{
				style = "";
			}

			juan+= "<a href=\"showinfo.jsp?id="+id+"\"  title=\"" + url
			+ "\">						<div class=\"box "+style+"\">							<table cellspacing=\"0\" cellpadding=\"0\" class=\"tab\" width=\"95%\" >								<tbody>									<tr>										<td class=\"p-img\" style=\"float:none;\" width=\"105px\"><img src=\""+picname+"\"  alt=\"\"/></td>										<td  valign=\"top\" class=\"text\"><div class=\"p-name\" style=\"color: #3C3C3C;font-size: 0.875em;\" >" + name + "<font color=\"red\"></font> </div>											<div class=\"p-detail\" style=\"width:180px; float:right\"><span style=\"float:left\">�̼ң� <font color=\"black\" style=\"font-family:Arial;font-weight:bold\"> "+address+"</font> <span></div><div class=\"p-detail\" style=\"width:180px; float:right;padding-top:10px\"><span style=\"float:left\"> ����<font color=\"red\" style=\"font-family:Arial;font-weight:bold\">"+c_v+"��</font>ϲ�� <span></div></td>									</tr>								</tbody>							</table>						</div>						</a>";
		
			//juan += "<a href=\"showinfo.jsp?id="+id+"\" title=\"" + url
			//+ "\">" + name + "</a> &nbsp;[<a href=\"showinfo.jsp?id="+id+"\">�ֻ�����</a>] | ["+address+"]<br />";
			
			i++;
			
		}
		rs.close();
		
		
		//�Ƽ��̼� 6��
		sql = "select c_sid,c_txt from t_index where c_txt='shop' order by c_id";
		rs = stmt.executeQuery(sql);
		i=0;
		while (rs.next()&&i<4) {
			id =  rs.getString(1);
			//ȡ�̼���Ϣ,��ͳ����Ϣ
			sql = "SELECT c_id,c_sname,c_address,c_jnum,c_logo from t_shops where c_id="+id;
			rs2= stmt2.executeQuery(sql);
			if(rs2.next()){
				name = Tools.RmNull(rs2.getString(2));
				address = Tools.RmNull(rs2.getString(3));
				count = Tools.RmNull(rs2.getString(4));
				picname = Tools.RmNull(rs2.getString(5));
			}
			url = name;
			//if(name.length()>7)name = name.substring(0,7)+".";
			//if(address.length()>8)address = address.substring(0,8)+".";
			
			if(picname.length()>10)picname = "/pic/"+picname.substring(0, 6)+"/"+picname.substring(6, 8)+"/thumb_"+picname; 
			else picname = "/images/nopic.jpg";
			
			if (i==0) {
				style = "first";
			}else
			{
				style = "";
			}
			
			shop += "<a href=\"showshop.jsp?id="+id+"\"  title=\"" + url
			+ "\">						<div class=\"box "+style+"\">							<table cellspacing=\"0\" cellpadding=\"0\" class=\"tab\" width=\"95%\" >								<tbody>									<tr>										<td class=\"p-img\" style=\"float:none;\" width=\"105px\"><img src=\""+picname+"\"  alt=\"\"/></td>										<td  valign=\"top\" class=\"text\"><div class=\"p-name\" style=\"color: #3C3C3C;font-size: 0.875em;\" >" + name + "<font color=\"red\"></font> </div>											<div class=\"p-detail\" style=\"width:180px; float:right\"><span style=\"float:left\"><!-- ��ַ��  "+address+" -->�� <font color=\"red\" style=\"font-family:Arial;font-weight:bold\">"+count+"</font> ���Ż�ȯ���� <br>�����Ƽ���<font  class=bri2>&nbsp;</font> <span></div></td>									</tr>								</tbody>							</table>						</div>						</a>";

			//shop += "<a href=\"showshop.jsp?id="+id+"\" title=\"" + url
			//+ "\">" + name + "</a> | "+address+" �� <font color=red>"+count+"</font> ���Ż�ȯ����<br />";
			i++;
		}
		rs.close();
		
		
		//��������
		sql = "select cname,url from link order by ord ";
		rs = stmt.executeQuery(sql);
		i=0;
		while (rs.next()) {
			
			link += "<li><a href=\""+rs.getString(2)+"\" target=_blank >"+rs.getString(1)+"</a></li>";
		}
		rs.close();


		//ȡ���򣬺���Ȧ��Ϣ
		String keys[] = {};
		
		sql = "select c_remark,c_range from t_user where c_admin=253 and c_userid='root'";
		rs = stmt.executeQuery(sql);
		if(rs.next())
		{
			c_remark = Tools.RmNull(rs.getString(1));//����
			c_range = Tools.RmNull(rs.getString(2));  //��Ȧ

			keys = c_remark.split(",");
			c_remark = "";
			for(int jj=0;jj<keys.length&&jj<3;jj++)
			{
				//c_remark += "<input type=button name=quyu"+jj+" value='"+keys[jj]+"' class=searchbtn2 onClick=\"window.location.href='shop_list.jsp?a="+keys[jj]+"'\" > ";
				c_remark += "<a href=\"shop_list.jsp?a="+keys[jj]+"\" class=searchbtn2>"+keys[jj]+"</a> ";
			}

			keys = c_range.split(",");
			c_range = "";
			for(int jj=0;jj<keys.length;jj++)
			{
				c_range += "<a href=\"shop_list.jsp?q="+keys[jj]+"\" class=searchbtn2>"+keys[jj]+"</a> ";
			}
		}
		rs.close();
		c_remark = c_remark+"<a href=\"diqu.jsp\" class=searchbtn2 style='width:26px'>����</a> ";


		
	} catch (Exception e) {
		System.out.println("mkindex error :" + e);
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



		//��ģ��,���жϴ���Ϣ���ռ�������û��,û�ж�t_type c_belong����Ŀ����ģ��,��û�ж�news_info.html��Ѷ��Ĭ��ģ��
		String filename = request.getRealPath("/3g/index_mod.html");
		File fileobj = new File(filename);
		if (!fileobj.exists()) {
			//���ģ���ļ��Ҳ���
			out.println("<font color=red>������,ģ��index_m.html�ļ��Ҳ�����ʧ!</font>");
			return;
		}
		//System.out.println(filename);
		
		
		//StringBuffer strb = Tools.readFile(filename);
		StringBuffer strb = Tools.readFile(filename,"UTF-8");//��ģ��
		strb = Tools.replaceAll(strb,"[head]","");
		strb = Tools.replaceAll(strb,"[titles]","");
		strb = Tools.replaceAll(strb,"[content]","");
		
		strb = Tools.replaceAll(strb,"[wyjm]",wyjm);
		strb = Tools.replaceAll(strb,"[gdgg]",gdgg);
		strb = Tools.replaceAll(strb,"[yhjx]",yhjx);
		strb = Tools.replaceAll(strb,"[juan]",juan);
		strb = Tools.replaceAll(strb,"[shop]",shop);
		strb = Tools.replaceAll(strb,"[link]",link);
		
		strb = Tools.replaceAll(strb,"[jiao]",jiao);
		strb = Tools.replaceAll(strb,"[jiao2]",jiao2);
		strb = Tools.replaceAll(strb,"[c_remark]",c_remark);
		strb = Tools.replaceAll(strb,"[c_range]",c_range);
		strb = Tools.replaceAll(strb, "http://www.138do.com","");

		strb = Tools.replaceAll(strb, "[w_tel]",w_tel);
		strb = Tools.replaceAll(strb, "[w_qun]",w_qun);
		strb = Tools.replaceAll(strb, "[w_web]",w_web);
		strb = Tools.replaceAll(strb, "[w_mail]",w_mail);
		strb = Tools.replaceAll(strb, "[w_im]",w_im);
		strb = Tools.replaceAll(strb, "[w_keyword]",w_keyword);
		strb = Tools.replaceAll(strb, "[w_name]",w_name);
		strb = Tools.replaceAll(strb, "[w_icp]",w_icp);
		strb = Tools.replaceAll(strb, "[w_city]",w_city);

		if(v.equals("show"))
		{
			//Ԥ����ҳ
			out.println(strb);	
		}else
		{
			//������ҳ
			modstr = strb.toString();
			String strFileName = request.getRealPath("/3g/index.html");
				//System.out.println(strFileName);
			try {
				
				FileOutputStream afile = new FileOutputStream(strFileName);
				afile.write(modstr.getBytes("utf-8"));
				afile.close();
				modstr = null;

				
				//�������ְ�ģ��
				 filename = request.getRealPath("/3g/index_mod_old.html");
				 fileobj = new File(filename);
				if (!fileobj.exists()) {
					//���ģ���ļ��Ҳ���
					out.println("<font color=red>������,ģ��index_m_old.html�ļ��Ҳ�����ʧ!</font>");
					return;
				}

				strb = Tools.readFile(filename,"UTF-8");//�����ְ�ģ��
				strb = Tools.replaceAll(strb,"[head]","");
				strb = Tools.replaceAll(strb,"[titles]","");
				strb = Tools.replaceAll(strb,"[content]","");
				
				strb = Tools.replaceAll(strb,"[wyjm]",wyjm);
				strb = Tools.replaceAll(strb,"[gdgg]",gdgg);
				strb = Tools.replaceAll(strb,"[yhjx]",yhjx);
				strb = Tools.replaceAll(strb,"[juan]",juan);
				strb = Tools.replaceAll(strb,"[shop]",shop);
				strb = Tools.replaceAll(strb,"[link]",link);

				//������ҳ
				modstr = strb.toString();
				strFileName = request.getRealPath("/3g/index2.html");
				afile = new FileOutputStream(strFileName);
				afile.write(modstr.getBytes("utf-8"));
				afile.close();
				modstr = null;
				
				//���ɹ������Ǻ���ϵ����
				filename = request.getRealPath("/3g/mod_aboutus.html");
				strb = Tools.readFile(filename,"UTF-8");//��ģ��
				strb = Tools.replaceAll(strb,"[w_icp]",w_icp);
				strb = Tools.replaceAll(strb,"[aboutusn]",aboutusn);
				strb = Tools.replaceAll(strb,"[aboutus]",aboutus);
				modstr = strb.toString();

				strFileName = request.getRealPath("/3g/aboutus.html");
				afile = new FileOutputStream(strFileName);
				afile.write(modstr.getBytes("utf-8"));
				afile.close();
				modstr = null;

				filename = request.getRealPath("/3g/mod_contact.html");
				strb = Tools.readFile(filename,"UTF-8");//��ģ��
				strb = Tools.replaceAll(strb,"[w_icp]",w_icp);
				strb = Tools.replaceAll(strb,"[contactn]",contactn);
				strb = Tools.replaceAll(strb,"[contact]",contact);
				modstr = strb.toString();

				strFileName = request.getRealPath("/3g/contact.html");
				afile = new FileOutputStream(strFileName);
				afile.write(modstr.getBytes("utf-8"));
				afile.close();


			} catch (IOException e) {
				out.println(e.getMessage());
			}
			
			//out.println("<span style='font-size:14px'>���ɳɹ�!<input type='button' value=' ��  �� ' onclick='javascript:history.go(-1);'>&nbsp;&nbsp;"
			//+"<a href='/index.html' target='_blank'>�򿪿���Ч��</a></span>"); 
		}
			
		strb = null;
%>