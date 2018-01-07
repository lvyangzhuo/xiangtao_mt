<%@ page contentType="text/html; charset=utf-8" %><%@ page language="java" import="java.util.*"%><%@ page import="java.sql.*"%><%@ page import = "java.text.SimpleDateFormat" %>
<%@ page language="java" import="com.wsu.basic.util.Tools" %>
<%@ page language="java" import="com.wsu.basic.dbsconnect.*"%>
<%
//request.setCharacterEncoding("GBK");
String c_userid = Tools.RmNull((String)session.getAttribute("c_userid"));

if(c_userid.equals("")||c_userid.length()<2){
	response.sendRedirect("/login.jsp?rturl=/m/user_update.jsp");
	return;
}


int jf =0;
int c_mtype = 0;
String c_logdate = "";
String shangquan = "";
String c_nick = Tools.RmNull(request.getParameter("c_nick"));
String c_tname = Tools.RmNull(request.getParameter("c_tname"));
String c_area = Tools.RmNull(request.getParameter("c_area"));
String c_quan = Tools.RmNull(request.getParameter("c_quan"));
String c_mob = Tools.RmNull(request.getParameter("c_mob"));
String c_mail = Tools.RmNull(request.getParameter("c_mail"));
String c_qq = Tools.RmNull(request.getParameter("c_qq"));
String c_sex = Tools.RmNull(request.getParameter("c_sex"));
String c_avatar = Tools.RmNull(request.getParameter("c_avatar"));
String c_id = Tools.RmNull(request.getParameter("c_id"));
String c_address = Tools.RmNull(request.getParameter("c_address"));
String c_jf = Tools.RmNull(request.getParameter("jf"));	//会员积分
String c = Tools.RmNull(request.getParameter("c"));
String Method = Tools.RmNull(request.getMethod());
Method = Method.toLowerCase();

Calendar cal  = Calendar.getInstance();
SimpleDateFormat formatter =new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
String nowtime = formatter.format(cal.getTime());
String c_ip = request.getRemoteAddr();
String sql = "";
//基本信息
	String w_tel = "";
	String w_qun="";
	String w_web="";
	String w_mail = "";
	String w_im ="";
	String w_keyword ="";
	String w_name = "";
	String w_icp = "";
	String w_city = "";
	String w_sheng = "";


	//if (request.getMethod() == "GET") {
		c_nick = new String(c_nick.getBytes("ISO-8859-1"), "utf-8");
		c_tname = new String(c_tname.getBytes("ISO-8859-1"), "utf-8");
		c_area = new String(c_area.getBytes("ISO-8859-1"), "utf-8");
		c_quan = new String(c_quan.getBytes("ISO-8859-1"), "utf-8");
		c_sex = new String(c_sex.getBytes("ISO-8859-1"), "utf-8");
		c_address = new String(c_address.getBytes("ISO-8859-1"), "utf-8");
	//}
	//System.out.println(c_nick);
	

Connection conn = null;
Statement stmt = null;
PreparedStatement pstmt = null;
ResultSet rs = null;
try {
	DBcon dba = new DBcon();
	conn = dba.getConnection();
	stmt = conn.createStatement();
	//c_userid = "dddd";
	if (Method.equals("post")&&c.equals("2")) {
		
		sql = "update t_member set c_nick=?,c_tname=?,c_area=?,c_quan=?,c_mob=?,"
				+"c_mail=?,c_qq=?,c_sex=?,c_address=? where c_userid=?";
		
		pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, c_nick);
		pstmt.setString(2, c_tname);
		pstmt.setString(3, c_area);
		pstmt.setString(4, c_quan);
		pstmt.setString(5, c_mob);
		pstmt.setString(6, c_mail);
		pstmt.setString(7, c_qq);
		pstmt.setString(8, c_sex);
		pstmt.setString(9, c_address);
		pstmt.setString(10, c_userid);
		pstmt.executeUpdate();
		pstmt.close();
		
		//log
		sql = "insert into t_log (c_uid,c_type,c_appdate,c_ip,c_userid,c_enable,c_act) values "
			+"(0,0,'"+nowtime+"','"+c_ip+"','"+c_userid+"',0,'gai')";
		stmt.executeUpdate(sql);
		
		response.sendRedirect("/3g/m.jsp");
		
	}else
	{


		sql = "select c_jf,c_mtype,c_nick,c_tname,c_area,c_quan,c_mob,"
		+"c_mail,c_qq,c_sex,c_avatar,c_id,c_address from t_member where c_userid='"+ c_userid + "'";
		//查询数据库
		rs = stmt.executeQuery(sql);
		if (rs.next()) {
			jf = rs.getInt(1);
			c_mtype = rs.getInt(2);
			c_nick = Tools.RmNull(rs.getString(3));
			c_tname = Tools.RmNull(rs.getString(4));
			c_area = Tools.RmNull(rs.getString(5));
			c_quan = Tools.RmNull(rs.getString(6));
			c_mob = Tools.RmNull(rs.getString(7));
			c_mail = Tools.RmNull(rs.getString(8));
			c_qq = Tools.RmNull(rs.getString(9));
			c_sex = Tools.RmNull(rs.getString(10));
			c_avatar = Tools.RmNull(rs.getString(11));
			c_id = rs.getString(12);
			c_address = rs.getString(13);
			
		}else
		{
			response.sendRedirect("/logout.jsp?rturl=/m/message.jsp");
		}
		rs.close();

		if (c_area.equals("")) {
			//c_area = "涧西区";
		}
		//System.out.println(c_area);

		//取区域，和商圈信息
			String keys[] = {};
			String c_remark = "";
			String c_range = "";
			sql = "select c_remark,c_range,c_tel,c_mobile,c_web,c_email,c_im,c_main,c_address,c_units_no,c_post,c_zip from t_user where c_admin=253 and c_userid='root'";
			rs = stmt.executeQuery(sql);
			if(rs.next())
			{
				c_remark = Tools.RmNull(rs.getString(1));
				c_range = Tools.RmNull(rs.getString(2));

				w_tel = Tools.RmNull(rs.getString(3));	
				w_qun = Tools.RmNull(rs.getString(4));
				w_web = Tools.RmNull(rs.getString(5));
				w_mail = Tools.RmNull(rs.getString(6));
				w_im = Tools.RmNull(rs.getString(7));
				w_keyword = Tools.RmNull(rs.getString(8));
				w_name = Tools.RmNull(rs.getString(9));
				w_icp = Tools.RmNull(rs.getString(10));
				w_city =Tools.RmNull(rs.getString(11));
				w_sheng =Tools.RmNull(rs.getString(12));

				keys = c_remark.split(",");
				for(int jj=0;jj<keys.length;jj++)
				{
					shangquan += "arr["+(jj)+"]='"+c_range+"';\n";
				}
			}
			rs.close();
	}
	
} catch (Exception e){
   	System.out.println("/3g/user_update.jsp error Exception :" + e);
}finally
{
	if (stmt != null) {
		stmt.close();
	}
	if (pstmt!=null) {
		pstmt.close();
	}
	if (conn != null) {
		conn.close();
	}
}

%>

<!DOCTYPE html>
<html>
<head>
<title>修改注册信息_3G</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="author" content="shuidazhe.com">
<meta name="viewport" content="width=device-width,initial-scale=1.0,maximum-scale=1.0,minimum-scale=1.0,user-scalable=0">
<meta name="apple-touch-fullscreen" content="yes">
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-status-bar-style" content="black">
<meta name="format-detection" content="telephone=no">

<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
<link rel="stylesheet" type="text/css" href="images/h5_lottery_pc.20131105.css" />
<link rel="stylesheet" type="text/css" href="images/base.css?v=shuidazhe" />

<script type="text/javascript" src="/js/jquery.min.js"></script>
<script type="text/javascript" src="/js/jquery.validate.min.js"></script>
<script type="text/javascript" src="/js/jquery.cookie.js"></script>
<script type="text/javascript" src="/js/huiduo.js"></script>
<script type="text/javascript" src="/js/area_utf8.js"></script>
<script type="text/javascript" src="/m/js/jq.win.js"></script>
<script type="text/javascript">
      var isIE6=false;
      var isPC = true;
    </script>
    <!--[if lte IE 6]><script type="text/javascript">isIE6=true;</script><![endif]-->

    <!--[if IE]>
    <script src="http://static.518.qq.com/js/html5.js"></script>
    <![endif]-->
    
 <!--[if !IE]>|xGv00|d28af0a4048868ce5256cac58120a57c<![endif]--> 
<!--[if lte IE 9]>
<link rel='stylesheet'  href='http://static.paipaiimg.com/lottery/pbcss/ie_hack.20130417.css' type='text/css' media='all' />
<![endif]-->

<script type="text/javascript">


//vb2ctg对应的导航样式
var navCfg={
  "0":"mode_webapp"
};
  

</script>
</head>

<script language="javascript">
$().ready(function() {

	$("#member").validate({
		/*errorLabelContainer: "#messageBox",		//显示错误信息的容器ID
		wrapper: "li",								//包含每个错误信息的容器*/
		rules:{
			c_nick:{
				required: false,
				minlength: 2,
				maxlength: 20
			},
			c_tname:{
				required: false,
				minlength: 2,
				maxlength: 20
			},
			c_mob:{
				required: false,
				minlength: 8,
				maxlength: 15
			},
			c_mail:{
				required: false,
				maxlength: 30
			},
			c_qq:{
				required: false,
				maxlength: 20
			}
		},
		messages:{
			c_nick:{
				minlength: "　昵称不能小于2个字",
				maxlength: "　昵称不能大于50个字"
			},
			c_tname:{
				minlength: "　真实姓名不能小于2个字",
				maxlength: "　真实姓名不能大于255个字"
			},
			c_mob:{
				minlength: "　电话号码至少是8位",
				maxlength: "　电话号码不能大于15位"
			},
			c_mail:{
				maxlength: "　邮箱长度不能大于30个字"
			},
			c_qq:{
				maxlength: "　qq长度不能大于20个数字"
			}
		}

	});

	$("#c_sex").ready(function(){
		$("#c_sex").val("<%=c_sex%>");
	});

	$("#uploadpic").click(function() {
		dialog("上传头像图片","url:upload.jsp?a=1","450px","200px","window");
	});

	$("#c_pname").ready(function(){
		var p = $("#c_pname").val();
		if(p.length<5) p ="/m/images/avatar.jpg";
		else p = "/pic/"+p.substring(0, 6)+"/"+p.substring(6, 8)+"/thumb_"+p; 
		//alert(p);
		$("#picname").attr("src",p);
	});
});



</script>

<style>
.logbtn {
	margin: 0px 0px 0px; border-radius: 5px; border: 1px solid rgb(186, 172, 157); width: 95px; height: 30px; text-align: center; color: rgb(60, 60, 60); line-height: 30px; font-size: 1em; display: inline-block; cursor: pointer; -webkit-border-radius: 5px; -moz-border-radius: 5px;font-size:15px;
}
</style>

<body>



<%@ include file="header.jsp" %>

  
  <div id="myhd_right" style="margin-left:20px">


  <h3 class="h_h3">修改个人信息<font color="red"></font> </h3>

  <form name="member" id="member" action="user_update.jsp?c=2" method="post">
  <input type=hidden name="c_id" id="c_id"  value="<%=c_id%>">
  <input type=hidden name="jf" id="jf"  value="<%=jf%>">
  <div class="member_in">
  	<ul>
    	<li class="left_a">昵称：</li>
        <li class="right_a"><span class=mes ><input type="text" name="c_nick" id="c_nick" value="<%=c_nick%>" class="intext" />  </span><span class="gri">（昵称会在点评中显示）</span></li>
       	<li class="left_a">真实姓名：</li>
        <li class="right_a"><span class=mes ><input type="text" name="c_tname" id="c_tname" value="<%=c_tname%>" class="intext" /> </span></li>
        <li class="left_a">性别：</li>
        <li class="right_a"><select name="c_sex" id="c_sex" class="sel" style="width:70px;position:relative; top:2px;"><option value="男" selected>男</option><option value="女">女</option></select></li>
        <li class="left_a">所在城市：<%=w_city%></li>
        <li class="right_a" style=""></li>
        <li class="left_a">所在区、商圈：</li>
        <li class="right_a"><select name="c_p" style="display:none"></select><select name="c_city" id="c_city" style="display:none"></select>
        <select name="c_area" id="c_area" class="sel" style="width:100px;position:relative; top:2px;"></select> 　<select name="c_quan" id="c_quan"  class="sel" style="width:120px;position:relative; top:2px;"></select></li>
        
        <script type="text/javascript" language="javascript" defer="defer">
	//new PCAS("province","city","area");
	new PCAS("c_p","c_city","c_area","中南省","中州市","<%=c_area%>")


	//西工区,涧西区,老城区,洛龙区,廛河回族区,吉利区,高新区
	var arr = new Array();
	/**
	手动修改参数
	arr[1]='新都汇,王府井,百货楼,其它';
	arr[2]='南昌路丹尼斯,上海市场,万达广场,广州市场,其它';
	arr[3]='八角楼金街,老城北大街,其它';
	arr[4]='新区盛德美,新区丹尼斯,关林市场,宝龙城市广场,其它';
	*/
	<%=shangquan%>


	$("#c_area").change( function () { 
		//alert($("#area")[0].selectedIndex);
		$("#c_quan").empty();
		
		try
		{
			//alert(arr[$("#c_area")[0].selectedIndex]);
			v = arr[$("#c_area")[0].selectedIndex].split(",");
			for(i=0;i<v.length;i++){
				//alert(v[i]);
				$("#c_quan").append("<option value='"+v[i]+"'>"+v[i]+"</option>"); 
			}
		}
		catch (e)
		{
			$("#c_quan").append("<option value=''></option>"); 
		}
		
	} );
	
	//初始化
	//alert("22");
	//$("#c_quan").ready(function(){
		
			for(j=1;j<5;j++)
			{
				
				if(arr[j].indexOf("<%=c_quan%>")>-1)
				{
					
					//插入到下拉选项第一行默认
					$("#c_quan").append("<option value='<%=c_quan%>'><%=c_quan%></option>");

					//替换掉原有的选项
					var t = arr[j].replace(/<%=c_quan%>,/g,"");
					v = t.split(",");
					for(i=0;i<v.length;i++){
						
						$("#c_quan").append("<option value='"+v[i]+"'>"+v[i]+"</option>"); 
					}
					break;
				}
			}

	//});
	
</script>
        
		<li class="left_a">手机、电话：</li>
        <li class="right_a"><span class=mes ><input type="text" name="c_mob" id="c_mob" value="<%=c_mob%>" class="intext" /> </span></li>

		<li class="left_a">收货地址：</li>
        <li class="right_a"><span class=mes ><input type="text" name="c_address" id="c_address" value="<%=c_address%>" class="intext" style="width:280px" /> </span><span class="gri">（送餐地址）</span></li>

        <li class="left_a">邮箱：</li>
        <li class="right_a"><span class=mes ><input type="text" name="c_mail" id="c_mail" value="<%=c_mail%>" class="intext" /> </span></li>
        <li class="left_a">QQ号码：</li>
        <li class="right_a"><span class=mes ><input type="text" name="c_qq" id="c_qq" value="<%=c_qq%>" class="intext" /> </span></li>


			
        <li class="left_a"></li>

        <li class="right_a"><input type="submit" name="submit2"  class="logbtn" value="保存修改"></li>
    </ul>
  </div>
  <div class="parting-line"></div>
  </form>
  

  </div>
  
<!-- middle end -->

<!-- footer start -->
<%@ include file="footer.jsp" %> 
<!-- footer end -->
<iframe id="zindexDiv" frameborder="0"></iframe>
</body>
</html>
