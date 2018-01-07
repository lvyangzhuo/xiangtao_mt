<%@ page contentType="text/html; charset=GBK" %>
<%@ page import="java.io.*"%>
<%@ page import = "java.text.SimpleDateFormat" %>
<%@ page import = "java.util.Date" %>
<%@ page import = "java.sql.*" %>
<%@ page language="java" import="com.wsu.basic.util.Tools"%>
<%@ page language="java" import="com.wsu.basic.dbsconnect.*"%>
<%
	String c = request.getParameter("c");
	String id = Tools.RmNull(request.getParameter("id"));
	if(c==null)c="";

	String userid=Tools.RmNull((String)session.getAttribute("c_userid"));	//是否会员
	String agent = Tools.RmNull(request.getHeader("USER-AGENT")).toLowerCase();
	String query = Tools.RmNull(request.getQueryString());

	if (!id.equals("")&&!c.equals("del")) {
		c = "buy";
	}

	String msg = Tools.RmNull(request.getParameter("msg"));
	//System.out.println("id=="+id);
	if(msg.equals("no"))
	{
		msg = "我的购物车<font color=red><B>商家自己不能购买本店商品哦</B></font><script>alert('商家自己不能购买本店商品哦');</script>";
	}else
	{
		msg = "我的购物车";
	}
	
	//System.out.println("id=="+id);
	
	
if(userid.equals("")||userid.length()<2){
	response.sendRedirect("/3g/login.jsp?rturl=/3g/shopping.jsp?id="+id);
	return;
}else
{

}

int Count = 0;
int i = 0;
Cookie cookies[]=request.getCookies();		// 将适用目录下所有Cookie读入并存入cookies数组中 
Cookie sCookie=null; 
String sName ="";
String sValue ="";
String list = "";
String showlist = "";
String showStr[] = {};
String elist = "";
String sqlstr = "";
String titles = "";
String title = "";
String close = "";
String close2 = "";
String city = "";
String ctype_b = "";
String sql = "";
String c_id = "";
String c_sname = "";
String arr="";
String whereSql = "";
String psf = "";
String arr2="";

if(cookies!=null)
{
	
	for(int jj=0;jj<cookies.length; jj++) // 循环列出所有可用的Cookie 
	{ 
		sCookie=cookies[jj]; 
		sName = sCookie.getName(); 
		sValue = java.net.URLDecoder.decode(sCookie.getValue()); 
		if (sName.equals("ebuy_id")) {
			list=sValue;
		}
		
	}
	//System.out.println("list="+list);

	//数据库查出订单
	DBcon db=new DBcon();
	Connection con=null; 
	Statement stmt=null;
	ResultSet rs=null;
	Statement stmt2 = null;
	ResultSet rs2 = null;
	try {
		con = db.getConnection();
		stmt = con.createStatement();
		stmt2 = con.createStatement();
		if (list.indexOf("#")>-1) showStr = list.split("#");
		int n = 0;
		for(int j=0;j<showStr.length;j++)
		{
			if(showStr[j].length()>0)
			{
				sqlstr+=" or rid="+showStr[j];
				n++;
			}
		}
		
	
		if (n==0) {
			close="disabled=\"disabled\" ";
			close2 = "onclick=\"javascript:alert('您还没有选择商品!')\"";
		}
		String rid = "";

		//System.out.println("sqlstr="+sqlstr);
		
		int accept = 0;
		Count = 0;
		if (sqlstr.length()>3) {
			
			sqlstr = sqlstr.substring(3,sqlstr.length());
			whereSql = sqlstr;
			sqlstr = "select rid,titles,price,ctype_b,city from t_news where "+sqlstr;
			//System.out.println(sqlstr);
			rs = stmt.executeQuery(sqlstr);
			while (rs.next())
			{
				rid = rs.getString(1);
				titles = rs.getString(2);
				if(titles.length()>20)titles=titles.substring(0,20)+"..";

				title = title+titles+"+";
				//if(userid==null||userid.equals(""))accept=rs.getInt(3);//非会员
				//else accept=rs.getInt(4); 
				accept=rs.getInt(3);
				ctype_b = rs.getString(4);
				city = rs.getString(5);
				Count = Count+accept;	//总价
				arr = arr+rid+",";

				sql = "select c_id,c_sname from t_shops where c_id="+Tools.isNumber(ctype_b);
				rs2 = stmt2.executeQuery(sql);
				if (rs2.next()) {
					c_id=rs2.getString(1);
					c_sname=rs2.getString(2);
				}
				rs2.close();

				//查询购买者如果是商家是否购买本店产品,防止刷积分
				boolean iss = true;
				sql = "select t_bang.c_sid from t_member,t_bang where c_userid='"+userid+"' and t_member.c_id=t_bang.c_mid and t_bang.c_sid="+Tools.isNumber(c_id)+"";
				rs2 = stmt2.executeQuery(sql);
				if (rs2.next())
				{
					//商家自己不能购买本店商品
					iss = false;
				}else{
					iss = true;
				}
				rs2.close();

				if(iss){

				showlist+="<tr align=center> <td height=30> "+
						"<input type=\"CheckBox\" name=\"rid\" value=\""+rid+"\" Checked>"+
						"<input type=\"hidden\" name=\"p"+rid+"\" value=\""+accept+"\"></td><td> <a href='news_info.jsp?id="+rid+"' >"+titles+"</a>"+
						"</td>"+
						"<td ><a href='showshop.jsp?id="+c_id+"'>"+c_sname+"</a></td></tr><tr align=center><td width='20%'></td><td width='40%'></td><td width='40%'></td></tr>"+
						"<tr align=center><td ><span>￥<span id='dj"+rid+"'>"+accept+"</span>.0 <span style='font-size:11px'>元</span></span>"+
						"</td>"+
						"<td><a href='javascript:;' onClick=\"jianShu(this.name)\" name='"+rid+"'><img src=/3g/images/jian.jpg border=0></a> <input type=\"Text\" name=\""+rid+"\" id=\""+rid+"\" value=\"1\" size=\"3\" maxlength=\"3\" style='width:20px' class=\"form\" onChange=\"getPrice(this.name)\" > <a href='javascript:;' onClick=\"jiaShu(this.name)\" name='"+rid+"'><img src=/3g/images/jia.jpg border=0></a></td>"+
						"<td ><a href=\"shopping.jsp?id="+rid+"&c=del\" >删除</a></td></tr><tr><td colspan=3 height=30>&nbsp;<div class=parting-line></div></td></tr>";
				i++;

				}else{
					whereSql = "rid=0";
					//out.println(rid);
					list = list.replaceAll(rid+"#","");
					//out.println(list);
					c = "no";
					showlist+="<tr> <td height=30> 商家自己不能购买本店商品哦</td>"+
						"<td class=\"bzj\"></td>"+
						"<td class=\"bzj\"></td>"+
						"<td class=\"amount\"></td>"+
						"<td ></td></tr>";
				}
			}
			rs.close();

			sqlstr = "select distinct(ctype_b),t_shops.c_sname,t_shops.c_psf from t_news,t_shops where  ("+whereSql+") and t_news.ctype_b=t_shops.c_id";
			rs = stmt.executeQuery(sqlstr);
			while (rs.next())
			{
				c_id=rs.getString(1);
				arr2 = arr2+c_id+",";
				c_sname=rs.getString(2);
				psf = rs.getString(3);
				/*
				showlist+="<tr> <td height=30> "+
						"<input type=\"CheckBox\" name=\"peisong\" value=\"\" Checked disabled=\"disabled\"><input type=\"hidden\" name=\"sid\" value=\""+c_id+"\">"+
						"<input type=\"hidden\" name=\"p"+c_id+"\" value=\""+psf+"\"> 配送费"+
						"</td>"+
						"<td class=\"bzj\"><a href='/waimai/shop_"+c_id+".html' target='_blank'>"+c_sname+"</a></td>"+
						"<td class=\"bzj\"><span>￥<span id='psf"+c_id+"'>"+psf+"</span>.00</span>"+
						"</td>"+
						"<td class=\"amount\"></td>"+
						"<td ></td></tr>";
						*/

				showlist+="<tr align=center> <td height=30> "+
						"<input type=\"CheckBox\" name=\"peisong\" value=\"\" Checked disabled=\"disabled\"><input type=\"hidden\" name=\"sid\" value=\""+c_id+"\">"+
						"<span style='font-size:12px'>￥<span id='psf"+c_id+"'>"+psf+"</span>.0 元</span>"+
						"</td>"+
						"<td width='40%'><input type=\"hidden\" name=\"p"+c_id+"\" value=\""+psf+"\"> 商家配送费</td><td width='40%'><a href='/waimai/shop_"+c_id+".html' target='_blank'>"+c_sname+"</a></td></tr><tr align=center><td width='20%'></td><td width='40%'></td><td width='40%'></td></tr>"+
						"<tr align=center><td >"+
						""+
						"</td>"+
						"<td></td></tr><tr><td colspan=3 height=30>&nbsp;<div class=parting-line></div></td></tr>";

				Count = Count+Tools.isNumber(psf);
				//System.out.println(Count);
				

			}
			rs.close();

			if (arr.length()>1) {
				arr = arr.substring(0,arr.length()-1);
			}

			if (arr2.length()>1) {
				arr2 = arr2.substring(0,arr2.length()-1);
			}

			if (title.length()>1) {
				title = title.substring(0,title.length()-1);
			}

		}
		//out.println(list);
		

	}catch (Exception e){
			 
	   System.out.println("/3g/shopping.jsp Exception :" + e);
	   e.printStackTrace();

	} finally {
	   if (stmt!=null) stmt.close();
	   if (stmt2 != null) {
			stmt2.close();
		}
	   if (con!=null) con.close();
	   con = null;
	}
	
}

	int maxAge = 30*60;//默认30分钟
	String str[] = {};
	elist = "";
	if(c.equals("buy"))
	{
		str = list.split("#");
		for(int j=0;j<str.length;j++)
		{
			//if(str[j].equals(id))elist+="";
			//else elist+=id+"#";
			if(str[j].length()>0)
			{
				if(!str[j].equals(id))elist+=str[j]+"#";
			}
			
			//System.out.println("str=="+str[j].length());
		}
		elist =elist+id+"#"; 
		
		Cookie cook0=new Cookie("ebuy_id",elist);  
		cook0.setMaxAge(maxAge);

		cook0.setPath("/");
									//cook0.setDomain("192.168.1.101"); 
		response.addCookie(cook0);
		
		response.sendRedirect("shopping.jsp");
	}
	
	if(c.equals("del"))
	{
		str = list.split("#");
		for(int j=0;j<str.length;j++)
		{
			//if(str[j].equals(id))elist+="";
			//else elist+=id+"#";
			if(str[j].length()>0)
			{
				if(!str[j].equals(id))elist+=str[j]+"#";
			}
			
			//System.out.println("str=="+str[j].length());
		}
		//elist =elist+id+"#"; 
		
		Cookie cook0=new Cookie("ebuy_id",elist);  
		cook0.setMaxAge(maxAge);

		cook0.setPath("/");
									//cook0.setDomain("192.168.1.101"); 
		response.addCookie(cook0);
		
		response.sendRedirect("shopping.jsp");
	}

	if(c.equals("no"))
	{
		str = list.split("#");
		for(int j=0;j<str.length;j++)
		{
			if(str[j].length()>0)
			{
				if(!str[j].equals(id))elist+=str[j]+"#";
			}
		}

		Cookie cook0=new Cookie("ebuy_id",elist);  
		cook0.setMaxAge(maxAge);
		cook0.setPath("/");
		response.addCookie(cook0);
		response.sendRedirect("shopping.jsp?msg=no");
	}

	//读入模板
	StringBuffer strb = Tools.readFile(request.getRealPath("/3g/shopping.html"));
	
	strb = Tools.replaceAll(strb,"[titles]",title);
	strb = Tools.replaceAll(strb,"[showlist]",showlist);
	strb = Tools.replaceAll(strb,"[Count]",Count+"");
	strb = Tools.replaceAll(strb,"[jian]",i+"");
	strb = Tools.replaceAll(strb,"[close]",close);
	strb = Tools.replaceAll(strb,"[close2]",close2);
	strb = Tools.replaceAll(strb,"[arr]",arr);
	strb = Tools.replaceAll(strb,"[arr2]",arr2);

	strb = Tools.replaceAll(strb,"我的购物车",msg);
	
	out.println(strb);
	strb = null;

%>

<jsp:include page="footer.jsp">
<jsp:param name="jid" value=""/>
<jsp:param name="sid" value="0"/>
<jsp:param name="f" value=""/>
</jsp:include>