<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="java.lang.*"%>
<%@ page import="java.io.*"%>
<%@ page import = "java.text.SimpleDateFormat" %>
<%@ page import = "java.util.Date" %>
<%@page import="java.util.*"%>
<%@ page import = "java.sql.*" %>
<%@ page language="java" import="com.wsu.basic.util.Tools"%>
<%@ page language="java" import="com.wsu.basic.dbsconnect.*"%>
<%@ page import="java.net.HttpURLConnection"%>
<%@ page import="java.net.URL"%>
<%@ page import="java.net.URLEncoder"%>
<%!	
public int isNumber(String s){
	int tempid=0;
	try{
		tempid=Integer.parseInt(s);
	}catch(NumberFormatException e){
		tempid=0;
	}
	return tempid;
}
%>
<%
request.setCharacterEncoding("GBK");
int Count = 0;
int money = 0;
int number = 0;
int cnum = 0;		//������
int count = 0;							//�̼���������
String msg = "";
String mod = "check.html";
String titles = Tools.RmNull(request.getParameter("titles"));
String userid = Tools.RmNull((String)session.getAttribute("c_userid"));

if(userid.equals("")||userid.length()<2){
	response.sendRedirect("/3g/login.jsp?rturl=/3g/shopping.jsp");
	return;
}else
{

}

String hid = "";
Calendar cal  = Calendar.getInstance();
java.text.SimpleDateFormat formatter = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm");
String tday =  formatter.format(cal.getTime());	

DBcon db=new DBcon();
Connection con=null; 
Statement stmt=null;
PreparedStatement pstmt = null;
ResultSet rs=null;
Cookie cookies[]=request.getCookies();		// ������Ŀ¼������Cookie���벢����cookies������ 
Cookie sCookie=null; 
String sName ="";
String sValue ="";
int v  = 0;
if(cookies!=null)
{
	for(int jj=0;jj<cookies.length; jj++) // ѭ���г����п��õ�Cookie 
	{ 
		sCookie=cookies[jj]; 
		sName = sCookie.getName();
		sValue = java.net.URLDecoder.decode(sCookie.getValue());
		if (sName.equals("ebuy_id")) {
			v++;
		}
	}
}


String str[]={}; 
str = request.getParameterValues("rid");
if (str!=null) {

	for (int i=0; i<str.length; i++)
	{
		//System.out.println(str[i]);
		if (str[i].length()>0) {
				
				//�۸�
				String pri=Tools.RmNull(request.getParameter("p"+str[i]));
				money = isNumber(pri);
				
				//����
				String num=Tools.RmNull(request.getParameter(str[i]));
				number = isNumber(num);
				
				//�ܼ۸�
				Count= Count+(money*number);

				//������
				cnum = cnum+number;
				//System.out.println(str[i]+" num="+(money*number));

				hid +="<input type=\"hidden\" name=\"id\" value=\""+str[i]+"\"><input type=\"hidden\" name=\"p"+str[i]+"\" value=\""+money+"\"><input type=\"hidden\" name=\"n"+str[i]+"\" value=\""+number+"\">\r\n";
		}
		
	}
}

String str2[]={}; 
str2 = request.getParameterValues("sid");
if (str2!=null) {
//System.out.println("str2="+str2.length);
	for (int i=0; i<str2.length; i++)
	{
		
		if (str2[i].length()>0) {
				
				//�۸�
				String pri=Tools.RmNull(request.getParameter("p"+str2[i]));
				money = isNumber(pri);
				//System.out.println("money="+money);
				
				//�ܼ۸�
				Count= Count+money;

				//hid +="<input type=\"hidden\" name=\"id\" value=\""+str[i]+"\"><input type=\"hidden\" name=\"p"+str[i]+"\" value=\""+money+"\"><input type=\"hidden\" name=\"n"+str[i]+"\" value=\""+number+"\">\r\n";
		}
		
	}
}
/*
else
{
	msg = "����ûѡ��Ҫ�������Ʒ";
	mod = "checkmsg.html";
}
*/
	String nickname = "";
	String peisong = "";
	String name = "";
	String tel = "";
	String mobile = "";
	String email = "";
	String zip = "";
	String address = "";
	String dtime = "";
	String bz = "";
	String zmoney = "";
	String sqlstr = "";
	String shopmob = "";
	String caiming = "";	//��ò���������
	tel = Tools.RmNull(request.getParameter("RecPhone"));
	String did = Tools.RmNull(request.getParameter("did"));
	String shopid = Tools.RmNull(request.getParameter("shopid"));
	String ps = Tools.RmNull(request.getParameter("ps"));
	String ssid = "";
	
	
try {
	
	con = db.getConnection();
	stmt = con.createStatement();
	if (!userid.equals("")) {
		//System.out.println("11");
		sqlstr = "select * from t_member where c_userid='"+userid+"' ";
		//System.out.println(sqlstr);
		rs = stmt.executeQuery(sqlstr);
		if (rs.next()) 
		{
			name = rs.getString("c_tname");
			//tel = rs.getString("c_userid");
			mobile = rs.getString("c_userid");
			email = rs.getString("c_mail");
			zip = rs.getString("c_zip");
			address = rs.getString("c_address");
			nickname=  rs.getString("c_nick");
		}
		rs.close();

	}


String c = Tools.RmNull(request.getParameter("c"));
String sid[]={}; 
sid = request.getParameterValues("id");
String rid = "";
/*******��⴦��********/

if (c.equals("1")) {
	peisong = Tools.RmNull(request.getParameter("post"));
	name = Tools.RmNull(request.getParameter("Recname"));
	
	mobile = Tools.RmNull(request.getParameter("CompPhone"));
	email = Tools.RmNull(request.getParameter("Recmail"));
	zip = Tools.RmNull(request.getParameter("ZipCode"));
	address = Tools.RmNull(request.getParameter("address"));
	dtime = Tools.RmNull(request.getParameter("gettime"));
	bz = Tools.RmNull(request.getParameter("Notes"));
	zmoney = Tools.RmNull(request.getParameter("Count"));

	//System.out.println("sid.length=="+sid.length);
	if (sid!=null&&sid.length>0) {

	if(v>0){
	
	Count = 0;
	money = 0;
	number = 0;
	//System.out.println("1111");


	String appip = request.getRemoteAddr();

	//System.out.println("1111111111");

	
	//t_dingdan��
	sqlstr = "insert into t_dingdan (titles,peisong,name,tel,mobile,email,zip,address,dtime,bz,money,appuser,appdate,rip,enable) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";

	pstmt = con.prepareStatement(sqlstr);
	pstmt.setString(1, titles);
	pstmt.setString(2, peisong);
	pstmt.setString(3, name);
	pstmt.setString(4, tel);
	pstmt.setString(5, mobile);
	pstmt.setString(6, email);
	pstmt.setString(7, zip);
	pstmt.setString(8, address);
	pstmt.setString(9, dtime);
	pstmt.setString(10, bz);
	pstmt.setInt(11, isNumber(zmoney));
	pstmt.setString(12, userid);
	pstmt.setString(13, tday);
	pstmt.setString(14, appip);
	pstmt.setInt(15, 0);

	pstmt.executeUpdate();

	sqlstr = "select rid from t_dingdan where titles='"+titles+"' and appdate='"+tday+"'";
	//System.out.println(sqlstr);
	rs = stmt.executeQuery(sqlstr);
	if (rs.next()) rid = rs.getString(1);
	rs.close();

	//�����ͻ��� 
	int zsjf = 0;
	zsjf = isNumber(zmoney)*10;
	sqlstr = "update t_member set c_jf=c_jf+"+zsjf+" where c_userid='"+ userid + "'";
	stmt.executeUpdate(sqlstr);
	//System.out.println(sqlstr);

	//t_dingass����������
	String shopname = "";
	String c_tel = "";
	for (int i=0; i<sid.length; i++)
	{
		//�۸�
		String pri=Tools.RmNull(request.getParameter("p"+sid[i]));
		money = isNumber(pri);
		
		//����
		String num=Tools.RmNull(request.getParameter("n"+sid[i]));
		number = isNumber(num);
		sqlstr = "insert into t_dingass(did,rid,money,num) values("+rid+","+sid[i]+"," + money + ","+number+") ";
		stmt.executeUpdate(sqlstr);
		//System.out.println(sqlstr);
		
		//����̼�id
		sqlstr = "select ctype_b,titles from t_news where rid="+sid[i];
		rs = stmt.executeQuery(sqlstr);
		if (rs.next()) {
			shopname = Tools.RmNull(rs.getString(1));
			caiming += Tools.RmNull(rs.getString(2))+number+"��,";
		}
		rs.close();

		ssid = shopname;
		sqlstr = "select c_sname,c_tel from t_shops where c_id="+Tools.isNumber(shopname);
		rs = stmt.executeQuery(sqlstr);
		if (rs.next()) {
			shopname = Tools.RmNull(rs.getString(1));
			c_tel = Tools.RmNull(rs.getString(2));
		}
		rs.close();

		shopmob = sid[i];
	}

	//����̼ҵ��̵��̼��˺��ֻ���

	/*
	sqlstr = "select c_userid,c_mob from t_member,t_bang where t_bang.c_sid="+Tools.isNumber(shopmob)+" and t_bang.c_mid=t_member.c_id";
	//System.out.println(sqlstr);
	rs = stmt.executeQuery(sqlstr);
	if (rs.next()) shopmob = rs.getString(1);
	

	sqlstr = "select c_tel from t_shops where c_id="+Tools.isNumber(shopmob)+" ";
	//System.out.println(sqlstr);
	rs = stmt.executeQuery(sqlstr);
	if (rs.next()) shopmob = rs.getString(1);

	rs.close();
	*/

	//�����ɹ���������
	String content = "";
	String content2 = "";

	if (titles.length()>15) {
		titles = titles.substring(0,15)+"..";
	}

	//���û�������
	content = nickname+"��Ա������"+shopname+""+titles+"���̼ҵ绰:"+c_tel;
	
	//System.out.println(shopmob+"____"+content);
	
	//���̼ҷ�����
	//content2 = "�¶����ͻ���:"+userid+",�ֻ���:"+mobile+","+titles+",Ԥ��ʱ��"+dtime;
	content2 = "�𾴵��̼ң��¶���:"+caiming+""+name+","+mobile+","+address+","+dtime+","+bz+".("+peisong+")�������찲�����͡���������";

//System.out.println(c_tel+"____"+content2);
	if (peisong.indexOf("����֧��")<0) {

	StringBuffer sb = new StringBuffer("http://www.smsbao.com/sms?");
		
		
	sb.append("u=");

	// ��StringBuffer׷�����루�������MD5 32λ Сд��
	sb.append("&p=");

	// ��StringBuffer׷���ֻ�����
	sb.append("&m="+c_tel+"");

	// ��StringBuffer׷����Ϣ����תURL��׼��
	sb.append("&c="+URLEncoder.encode(content2,"utf-8"));

	// ����url����
	URL url = new URL(sb.toString());

	// ��url����
	HttpURLConnection connection = (HttpURLConnection) url.openConnection();

	// ����url����ʽ ��get�� ���� ��post��
	connection.setRequestMethod("POST");

	// ����
	BufferedReader in = new BufferedReader(new InputStreamReader(url.openStream()));

	// ���ط��ͽ��
	String inputline = in.readLine();

	//System.out.println("dingdan=="+inputline);

	if(inputline.equals("0")||inputline.equals("3")||inputline.equals("2"))
	{
		sqlstr = "insert into t_smslog (c_jid,c_sid,c_text,c_tel,c_appdate,c_ip,c_userid) "
			+"values (?,?,?,?,?,?,?)";
			pstmt = con.prepareStatement(sqlstr);
			pstmt.setInt(1, 0);
			pstmt.setInt(2, Tools.isNumber(ssid));
			pstmt.setString(3, content2);
			pstmt.setString(4, c_tel);
			pstmt.setString(5, tday);
			pstmt.setString(6, appip);
			pstmt.setString(7, userid);
			pstmt.executeUpdate();
			pstmt.close();
			
			//��ѯ����count
			sqlstr = "select c_zip from t_shops where c_id="+Tools.isNumber(ssid);
			rs = stmt.executeQuery(sqlstr);
			if(rs.next())
			{
				count = Tools.isNumber(rs.getString(1));
				count = count-1;
			}
			rs.close();

			//�̼Ҷ���������1
			sqlstr = "update t_shops set c_zip="+count+" where c_id="+Tools.isNumber(ssid);
			stmt.executeUpdate(sqlstr);
	}

	}


	msg = ""+rid+"";
	mod = "checkmsg.html";

	Cookie sName2=new Cookie("ebuy_id","");  
	sName2.setMaxAge(0); // 
	sName2.setPath("/"); 
	response.addCookie(sName2);

	if (peisong.indexOf("����֧��")>-1) {
		peisong = "zfb";
	}
		

	response.sendRedirect("check.jsp?c=2&did="+ rid+"&shopid="+shopmob+"&ps="+peisong);

	}else
	{
		msg = "���ﳵΪ��,��������ѡ����Ʒ";
		mod = "checkmsg.html";
	}
}else
{
	msg = "����ûѡ��Ҫ�������Ʒ";
	mod = "checkmsg.html";
}

}else if (c.equals("2")){
	//String did = Tools.RmNull(request.getParameter("did"));

	//��ö�������Ʒ��Ϣ
	sqlstr = "select titles,money,bz from t_dingdan where rid="+did+"";
	//System.out.println(sqlstr);
	rs = stmt.executeQuery(sqlstr);
	if (rs.next()) {
		titles = Tools.RmNull(rs.getString(1));
		Count = rs.getInt(2);
		name = Tools.RmNull(rs.getString(3));
	
	}
	rs.close();



	if (tday.length()>10) {
		tday = tday.substring(0,10);
	}
	tday = tday.replaceAll("-","");

	msg = tday+"000"+did+"";
	//msg = ""+did+"";
	mod = "checkmsg.html";
}

} catch (Exception e){
   System.out.println("/3g/check.jsp Exception :" + e);
} finally {
     if (stmt!=null) stmt.close();
	 if (pstmt != null) pstmt.close();
	 if (con!=null) con.close();
	 con = null;
}

	//����ģ��
	StringBuffer strb = Tools.readFile(request.getRealPath("/3g/"+mod));
	
	//strb = Tools.replaceAll(strb,"[showlist]",showlist);
	strb = Tools.replaceAll(strb,"[Count]",Count+"");
	strb = Tools.replaceAll(strb,"[cnum]",cnum+"");
	
	strb = Tools.replaceAll(strb,"[hid]",hid);
	strb = Tools.replaceAll(strb,"[titles]",titles);
	
	strb = Tools.replaceAll(strb,"[name]",name);
	strb = Tools.replaceAll(strb,"[tel]",tel);
	strb = Tools.replaceAll(strb,"[mobile]",mobile);
	strb = Tools.replaceAll(strb,"[email]",email);
	strb = Tools.replaceAll(strb,"[zip]",zip);
	strb = Tools.replaceAll(strb,"[address]",address);

	strb = Tools.replaceAll(strb,"[msg]",msg);
	strb = Tools.replaceAll(strb,"[tday]",tday);

	strb = Tools.replaceAll(strb,"[did]",did);
	strb = Tools.replaceAll(strb,"[shopid]",shopid);
	if (ps.equals("zfb")) {
		//����֧����ť


strb = Tools.replaceAll(strb,"type=\"button\" name=\"Submit\" value=\"��������\" onclick=\"window.location.href='news_list.jsp'\"","type=\"Submit\" name=\"Submit\" value=\"֧����֧��\" ");

//strb = Tools.replaceAll(strb,"type=\"button\" name=\"Submit\" value=\"��������\" onclick=\"window.location.href='shop_wm.jsp'\"","type=\"Submit\" name=\"Submit\" value=\"֧����֧��\" ");
	}

	//����head �� bottom 
	StringBuffer strb_head = Tools.readFile(request
			.getRealPath("/index.html"));
	String body = strb_head.toString();
	String head = "";
	String bottom = "";

	head = body.substring(body.indexOf("<!-- header start -->"), body
			.indexOf("<!-- header end -->"));
	bottom = body.substring(body.indexOf("<!-- bottom start -->"), body
			.indexOf("<!-- bottom end -->"));


	strb = Tools.replaceAll(strb,"[head]",head);
	strb = Tools.replaceAll(strb,"[bottom]",bottom);
	
	out.println(strb);
	strb = null;

	/*
<jsp:include page="footer.jsp">
<jsp:param name="jid" value=""/>
<jsp:param name="sid" value="0"/>
<jsp:param name="f" value=""/>
</jsp:include>
*/


%>
