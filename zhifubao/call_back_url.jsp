<%
/* *
 功能：支付宝页面跳转同步通知页面
 版本：3.2
 日期：2011-03-17
 说明：
 以下代码只是为了方便商户测试而提供的样例代码，商户可以根据自己网站的需要，按照技术文档编写,并非一定要使用该代码。
 该代码仅供学习和研究支付宝接口使用，只是提供一个参考。

 //***********页面功能说明***********
 该页面可在本机电脑测试
 可放入HTML等美化页面的代码、商户业务逻辑程序代码
 TRADE_FINISHED(表示交易已经成功结束，并不能再对该交易做后续操作);
 TRADE_SUCCESS(表示交易已经成功结束，可以对该交易做后续操作，如：分润、退款等);
 //********************************
 * */
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="java.util.Map"%>
<%@ page import="alipay.util.*"%>
<%@ page import="alipay.config.*"%>
<%@ page import="java.text.SimpleDateFormat"%><%@ page language="java" import="java.util.*"%><%@ page language="java" import="java.io.*"%><%@ page language="java" import="java.sql.*"%><%@ page language="java" import="com.wsu.basic.util.Tools"%><%@ page language="java" import="com.wsu.basic.dbsconnect.*"%><%@ page import = "java.text.SimpleDateFormat" %><%@ page import = "java.util.Date" %><%@ page import="java.net.HttpURLConnection"%><%@ page import="java.net.URL"%><%@ page import="java.net.URLEncoder"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GBK" />
<title>结算中心</title>
<meta name="viewport" content="width=device-width,initial-scale=1.0,maximum-scale=1.0,minimum-scale=1.0,user-scalable=0">
<meta name="apple-touch-fullscreen" content="yes">
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-status-bar-style" content="black">
<meta name="format-detection" content="telephone=no">
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
<link rel="stylesheet" type="text/css" href="/3g/images/h5_lottery_pc.20131105.css" />
<link rel="stylesheet" type="text/css" href="/3g/images/base.css?v=shuidazhe" />
<link rel="stylesheet" type="text/css" href="/3g/images/iehack.css" />
<script type="text/javascript" src="/js/jquery.min.js"></script>
<script type="text/javascript" src="/js/jquery.cookie.js"></script>



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

<body>
<header>
	<a href="/3g/" class="fl">返回</a>
	<h1 class="logo" style="display: inline-block;margin:0 auto"><img src="/3g/images/logosj.png" /></h1>
	 <a href="/3g/index.html" class="fr"><img src="/3g/images/home.png" /></a> <a href="/3g/m.jsp" class="fr"><img src="/3g/images/cust_icon.png" /></a>
</header>
<div class="good-detail sift-mg">
	<h3 class="h_h3">在线支付成功<font color="red"></font> </h3>
	<div class="parting-line"></div>

<p>

<%
	//获取支付宝GET过来反馈信息
	Map<String,String> params = new HashMap<String,String>();
	Map requestParams = request.getParameterMap();
	for (Iterator iter = requestParams.keySet().iterator(); iter.hasNext();) {
		String name = (String) iter.next();
		String[] values = (String[]) requestParams.get(name);
		String valueStr = "";
		for (int i = 0; i < values.length; i++) {
			valueStr = (i == values.length - 1) ? valueStr + values[i]
					: valueStr + values[i] + ",";
		}
		//乱码解决，这段代码在出现乱码时使用。如果mysign和sign不相等也可以使用这段代码转化
		valueStr = new String(valueStr.getBytes("ISO-8859-1"), "utf-8");
		params.put(name, valueStr);
	}

	//获取支付宝的通知返回参数，可参考技术文档中页面跳转同步通知参数列表(以下仅供参考)//
	///商户订单号	
	String out_trade_no = new String(request.getParameter("out_trade_no").getBytes("ISO-8859-1"),"UTF-8");

	//支付宝交易号	
	String trade_no = new String(request.getParameter("trade_no").getBytes("ISO-8859-1"),"UTF-8");

	//交易状态
	String result = new String(request.getParameter("result").getBytes("ISO-8859-1"),"UTF-8");

	//获取支付宝的通知返回参数，可参考技术文档中页面跳转同步通知参数列表(以上仅供参考)//
	
	//计算得出通知验证结果
	boolean verify_result = AlipayNotify.verifyReturn(params);
	

	/*
	if(verify_result){//验证成功
		//////////////////////////////////////////////////////////////////////////////////////////
		//请在这里加上商户的业务逻辑程序代码

		//——请根据您的业务逻辑来编写程序（以下代码仅作参考）——
		
	
		//该页面可做页面美工编辑
		out.println("验证成功<br />");
		//——请根据您的业务逻辑来编写程序（以上代码仅作参考）——

		//////////////////////////////////////////////////////////////////////////////////////////
	}else{
		//该页面可做页面美工编辑
		out.println("验证失败");
	}
	*/

	//System.out.println("sjc_out_trade_no=="+out_trade_no);
	//System.out.println("sjc_trade_status=="+result);



request.setCharacterEncoding("utf-8");
String c = Tools.RmNull(request.getParameter("c")); 

String []cid = request.getParameterValues("cid");
//c_text = new String(c_text.getBytes("utf-8"), "GBK");
//c_fee = new String(c_fee.getBytes("utf-8"), "GBK");


String callback = request.getParameter("jsonpCallback"); 
String r = Tools.RmNull(request.getParameter("r")); //r

Connection con = null;
Statement stmt = null;
ResultSet rs = null;
PreparedStatement pstmt = null;
String sql = "";
String msg = "";
String whereSql = "";
int enable = 1;
Calendar cal  = Calendar.getInstance();
SimpleDateFormat formatter =new SimpleDateFormat("yyyy-MM-dd HH:mm");
SimpleDateFormat formatter2 =new SimpleDateFormat("E");
String c_appdate = formatter.format(cal.getTime());
String week = formatter2.format(cal.getTime());
int hour = Tools.isNumber(c_appdate.substring(11,13));
String c_ip = request.getRemoteAddr();

String c_userid = Tools.RmNull((String)session.getAttribute("c_userid"));

String userid = c_userid;
if(userid.equals("")&&c_userid.equals(""))
{
	response.sendRedirect("/login.jsp?rturl=/waimai/shopping.jsp");
	return;
}
int j =0;
enable = Tools.isNumber(c);

		try {
	DBcon dbcon = new DBcon(); //数据库连接
	con = dbcon.getConnection();
	stmt = con.createStatement();
	ArrayList s = new ArrayList();
	// update 
	if(result.equals("TRADE_SUCCESS")||result.equals("success"))
	{
		sql = "update t_dingdan set enable=? where rid=?";
		pstmt = con.prepareStatement(sql);
		int i =0;



				pstmt.setInt(1, 7);
				pstmt.setInt(2, Tools.isNumber(out_trade_no));
				pstmt.addBatch();
				
				//whereSql += " or c_id="+cid[i];
				//System.out.println(i+"_"+cid[i]);
				j++;	


		pstmt.executeBatch(); 
		
		//支付成功,给商家发送短信

		String name = "";
		String c_tel = "";
		String tel = "";
		String mobile = "";
		String content2 = "";
		String address = "";
		String dtime = "";
		String bz = "";
		String caiming = "";	//获得菜名和数量
		String shopname = "";
		String cpid[] = {};
		String num = "";
		
		String tday =  c_appdate;	
		String ssid = "";
		String appip = request.getRemoteAddr();
		int count = 0;	


		sql = "select name,mobile,address,dtime,bz,tel from t_dingdan where rid="+Tools.isNumber(out_trade_no)+"";
		//System.out.println(sqlstr);
		rs = stmt.executeQuery(sql);
		if (rs.next()){
			name = Tools.RmNull(rs.getString(1));
			mobile = Tools.RmNull(rs.getString(2));
			address = Tools.RmNull(rs.getString(3));
			dtime = Tools.RmNull(rs.getString(4));
			bz = Tools.RmNull(rs.getString(5));
			tel = Tools.RmNull(rs.getString(6));

			if(dtime.length()>16)dtime=dtime.substring(0,16);
		} 
		rs.close();

		if(tel.indexOf(",")>-1){cpid = tel.split(",");}
		else{tel=tel+",0";cpid = tel.split(",");} 
		for(int jj=0;jj<cpid.length;jj++)
		{
			//获得菜单的菜品份数
			sql = "select num from t_dingass where rid="+cpid[jj];
			rs = stmt.executeQuery(sql);
			if (rs.next()) {
				num = Tools.RmNull(rs.getString(1));
			}
			rs.close();

			//获得商家id
			sql = "select ctype_b,titles from t_news where rid="+cpid[jj];
			rs = stmt.executeQuery(sql);
			if (rs.next()) {
				shopname = Tools.RmNull(rs.getString(1));
				caiming += Tools.RmNull(rs.getString(2))+num+"份,";
			}
			rs.close();
			
			ssid = shopname;
			sql = "select c_sname,c_tel from t_shops where c_id="+Tools.isNumber(shopname);
			rs = stmt.executeQuery(sql);
			if (rs.next()) {
				shopname = Tools.RmNull(rs.getString(1));
				c_tel = Tools.RmNull(rs.getString(2));
			}
			rs.close();
		}

		content2 = "尊敬的商家：新订单:"+caiming+""+name+","+mobile+","+address+","+dtime+","+bz+".(在线支付已付款)请您尽快安排配送【饭宝网】";

		

		StringBuffer sb = new StringBuffer("http://www.smsbao.com/sms?");
		
		sb.append("u=");

		// 向StringBuffer追加密码（密码采用MD5 32位 小写）
		sb.append("&p=");

		// 向StringBuffer追加手机号码
		sb.append("&m="+c_tel+"");

		// 向StringBuffer追加消息内容转URL标准码
		sb.append("&c="+URLEncoder.encode(content2,"utf-8"));

		// 创建url对象
		URL url = new URL(sb.toString());

		// 打开url连接
		HttpURLConnection connection = (HttpURLConnection) url.openConnection();

		// 设置url请求方式 ‘get’ 或者 ‘post’
		connection.setRequestMethod("POST");

		// 发送
		BufferedReader in = new BufferedReader(new InputStreamReader(url.openStream()));

		// 返回发送结果
		String inputline = in.readLine();

		if(inputline.equals("0")||inputline.equals("2")||inputline.equals("3"))
		{
			sql = "insert into t_smslog (c_jid,c_sid,c_text,c_tel,c_appdate,c_ip,c_userid) "
				+"values (?,?,?,?,?,?,?)";
				pstmt = con.prepareStatement(sql);
				pstmt.setInt(1, 0);
				pstmt.setInt(2, Tools.isNumber(ssid));
				pstmt.setString(3, content2);
				pstmt.setString(4, c_tel);
				pstmt.setString(5, tday);
				pstmt.setString(6, appip);
				pstmt.setString(7, userid);
				pstmt.executeUpdate();
				pstmt.close();
				
				//查询短信count
				sql = "select c_zip from t_shops where c_id="+Tools.isNumber(ssid);
				rs = stmt.executeQuery(sql);
				if(rs.next())
				{
					count = Tools.isNumber(rs.getString(1));
					count = count-1;
				}
				rs.close();

				//商家短信条数减1
				sql = "update t_shops set c_zip="+count+" where c_id="+Tools.isNumber(ssid);
				stmt.executeUpdate(sql);
		}
		
		out.println("订单已支付成功！&nbsp;<input type=\"button\" name=\"Submit\" value=\"确认关闭窗口\" onclick=\"window.close();\"");
	}
	
	
	
} catch (Exception e) {
	System.out.println("/3g/zhifubao/call_back_url.jsp error :" + e);
	out.print(callback + "error"); 
} finally {

	if (stmt != null) {
		stmt.close();
	}
	if (pstmt!=null) {
		pstmt.close();
	   }
	if (con != null) {
		con.close();
	}

}

%>

</p> </div>


<script type="text/javascript">
//entra5-5
(function(global){
var g=[],d='http://static.gtimg.com',m={},blankjs="",grays={},mdebug = location.href.indexOf("mdebug=1")!=-1;
m.alias = {};
var a={},p={},c=[];
grays['ahk3'] = "/js/version/201310/ahk3.201310090945.js";
grays['jx11x5'] = "/js/version/201311/jx11x5.201311121033.js";
grays['lssc'] = "/js/version/201311/lssc.201311131219.js";
grays['qxc'] = "/js/version/201310/qxc.201310211940.js";
grays['record.dealrecord'] = "/js/version/201311/record.dealrecord.201311151639.js";
grays['sd'] = "/js/version/201310/sd.201310242047.js";
grays['szc'] = "/js/version/201311/szc.201311110946.js";
grays['tpl_sz_choose'] = "/js/version/201311/tpl_sz_choose.201311111010.js";
g["21"]=["\/js\/version\/201310\/JJC_yh.201310141550.js","\/js\/version\/201310\/tpl_jjcYh_detail.201310091454.js","\/js\/version\/201309\/tpl_jjcYh_tpl.201309271708.js"];
g["0"]=["\/js\/version\/201309\/act518.201309301603.js","\/js\/version\/201311\/ahk3.201311151926.js","\/js\/version\/201309\/consult.201309161012.js","\/js\/version\/201309\/cookie.201309291040.js","\/js\/version\/201309\/date.201309151930.js","\/js\/version\/201310\/exchange.201310311043.js","\/js\/version\/201306\/frame.pc.201306061549.js","\/js\/version\/201307\/guid.201307241603.js","\/js\/version\/201311\/iScrollPc.201311051737.js","\/js\/version\/201311\/ios.201311131545.js","\/js\/version\/201309\/jjc_nvshen.201309061016.js","\/js\/version\/201306\/jquery.201306051525.js","\/js\/version\/201311\/jx11x5.201311151627.js","\/js\/version\/201307\/lottIcons.201307231812.js","\/js\/version\/201311\/lotteryTool.201311041029.js","\/js\/version\/201311\/lssc.201311151956.js","\/js\/version\/201310\/msg.201310121125.js","\/js\/version\/201311\/newcomer.201311141312.js","\/js\/version\/201311\/qxc.201311152053.js","\/js\/version\/201311\/record.dealrecord.201311151757.js","\/js\/version\/201311\/sd.201311152045.js","\/js\/version\/201307\/sms.201307241043.js","\/js\/version\/201311\/sns.201311131256.js","\/js\/version\/201310\/sport.201310311955.js","\/js\/version\/201311\/szc.201311152050.js","\/js\/version\/201311\/testTools.201311111114.js","\/js\/version\/201311\/testTools.reportConfig.201311040959.js","\/js\/version\/201310\/zb.201310311703.js","\/js\/version\/201306\/zepto.201306031845.js","\/js\/version\/201310\/tpl_act518_tpl.201310251048.js","\/js\/version\/201310\/tpl_act908_tpl.201310081151.js","\/js\/version\/201311\/tpl_act_qa.201311021424.js","\/js\/version\/201311\/tpl_bl_sjyz.201311011406.js","\/js\/version\/201311\/tpl_consult_add.201311052012.js","\/js\/version\/201310\/tpl_createJoin_tpl.201310151555.js","\/js\/version\/201311\/tpl_detail_php_tpl.201311151643.js","\/js\/version\/201311\/tpl_dialog_new.201311151140.js","\/js\/version\/201309\/tpl_gzyl_tpl.201309091800.js","\/js\/version\/201311\/tpl_index.201311151233.js","\/js\/version\/201310\/tpl_indexCMS.201310311936.js","\/js\/version\/201309\/tpl_ios_create_tpl.201309041431.js","\/js\/version\/201311\/tpl_item_getAllItemJson_tmpl_v2.201311041800.js","\/js\/version\/201311\/tpl_kjgg_histroyList_kpc_tpl.201311131113.js","\/js\/version\/201311\/tpl_kjgg_list_new.201311131329.js","\/js\/version\/201311\/tpl_lottery.ui.201311121453.js","\/js\/version\/201311\/tpl_my_register_result.201311061113.js","\/js\/version\/201311\/tpl_newcomer_append.201311061601.js","\/js\/version\/201311\/tpl_newcomer_appendFive.201311061605.js","\/js\/version\/201310\/tpl_newcomer_rechange_ten.201310301659.js","\/js\/version\/201310\/tpl_newer_h5act_tpl.201310141713.js","\/js\/version\/201311\/tpl_newer_song_wx.201311061606.js","\/js\/version\/201311\/tpl_open_planlist_planItem_tpl.201311131255.js","\/js\/version\/201310\/tpl_qb_exchange.201310311148.js","\/js\/version\/201311\/tpl_regist_v2_ssq_gift.201311141435.js","\/js\/version\/201309\/tpl_register_v2_verify_phone.201309152201.js","\/js\/version\/201311\/tpl_share_hongbao.201311151642.js","\/js\/version\/201311\/tpl_share_tpl.201311141951.js","\/js\/version\/201310\/tpl_sport_black.201310311949.js","\/js\/version\/201310\/tpl_ssq_ball_tpl.201310211528.js","\/js\/version\/201310\/tpl_ssq_blscj.201310291916.js","\/js\/version\/201311\/tpl_ssq_bzfj.201311061734.js","\/js\/version\/201311\/tpl_submit_deal_info.201311151701.js","\/js\/version\/201311\/tpl_sz_choose.201311151630.js","\/js\/version\/201310\/tpl_sz_datamap.201310211910.js","\/js\/version\/201310\/tpl_szc_reference.201310112022.js","\/js\/version\/201309\/tpl_tpl_consult_detail.201309051116.js","\/js\/version\/201309\/tpl_tpl_consult_list.201309051116.js","\/js\/version\/201309\/tpl_tpl_consult_list_li.201309161012.js","\/js\/version\/201311\/tpl_tpl_ssq_blhm.201311041507.js","\/js\/version\/201310\/tpl_xiaofeisong_tpl.201310151757.js"];
g["13"]=["\/js\/version\/201311\/active.201311141605.js","\/js\/version\/201311\/new3.201311132118.js","\/js\/version\/201310\/tpl_my_active.201310291650.js","\/js\/version\/201310\/tpl_my_active_main.201310301000.js","\/js\/version\/201311\/tpl_my_coupon.201311151021.js"];
g["28"]=["\/js\/version\/201309\/tpl_ks_ball.201309241136.js"];
g["11"]=["\/js\/version\/201309\/cache.201309291036.js","\/js\/version\/201309\/device.201309291443.js","\/js\/version\/201310\/dot.201310172119.js","\/js\/version\/201309\/event.201309291039.js","\/js\/version\/201311\/frame.201311141930.js","\/js\/version\/201306\/frame.h5.201306061550.js","\/js\/version\/201311\/frame.ui.201311151116.js","\/js\/version\/201306\/iScroll.201306031905.js","\/js\/version\/201308\/inf.201308231218.js","\/js\/version\/201309\/myTouch.201309121526.js","\/js\/version\/201309\/remote.201309291040.js","\/js\/version\/201309\/url.201309101641.js"];
g["16"]=["\/js\/version\/201310\/calcu.201310141550.js","\/js\/version\/201311\/fqhm.201311151119.js","\/js\/version\/201311\/xd.201311151657.js","\/js\/version\/201310\/tpl_createDeal_1014.201310171123.js","\/js\/version\/201308\/tpl_create_deal_tpl.201308211546.js"];
g["20"]=["\/js\/version\/201310\/cms.201310312147.js","\/js\/version\/201311\/mRaffle.201311011522.js","\/js\/version\/201310\/tpl_m_raffle_record_tpl.201310161515.js"];
g["12"]=["\/js\/version\/201311\/data.201311141519.js","\/js\/version\/201311\/data.active.201311151640.js","\/js\/version\/201311\/data.cms.201311131528.js","\/js\/version\/201311\/data.deal.201311151641.js","\/js\/version\/201306\/data.fina.201306031538.js","\/js\/version\/201308\/data.live.201308081720.js","\/js\/version\/201311\/data.lottery.201311151232.js","\/js\/version\/201309\/data.msg.201309110946.js","\/js\/version\/201311\/data.user.201311081527.js"];
g["14"]=["\/js\/version\/201311\/info.201311181049.js","\/js\/version\/201311\/info.ui.201311151233.js"];
g["17"]=["\/js\/version\/201311\/jjc.201311151520.js","\/js\/version\/201310\/tpl_JCZQ_BF_odds.201310091450.js","\/js\/version\/201310\/tpl_JCZQ_BF_tap.201310091448.js","\/js\/version\/201310\/tpl_JCZQ_MIX_BF_odds.201310091448.js","\/js\/version\/201310\/tpl_JCZQ_SPF_matchList.201310161857.js","\/js\/version\/201310\/tpl_JCZQ_SPF_payMatchList.201310161857.js","\/js\/version\/201310\/tpl_JCZQ_choose.201310141550.js","\/js\/version\/201310\/tpl_JCZQ_mix_matchList.201310091451.js","\/js\/version\/201310\/tpl_JCZQ_mix_payMatchList.201310091449.js","\/js\/version\/201310\/tpl_JCZQ_payBotMsg.201310291625.js","\/js\/version\/201310\/tpl_JJC_passType.201310091450.js"];
g["18"]=["\/js\/version\/201311\/join.201311151119.js","\/js\/version\/201309\/sfc.201309261635.js"];
g["26"]=["\/js\/version\/201310\/tpl_jx11x5_ball.201310211902.js"];
g["27"]=["\/js\/version\/201310\/tpl_lssc_ball.201310211920.js"];
g["19"]=["\/js\/version\/201311\/my.201311111950.js","\/js\/version\/201311\/my.myLottery.201311151640.js"];
g["30"]=["\/js\/version\/201311\/ns_channel.201311081625.js","\/js\/version\/201311\/tpl_nv_channel_main.201311081640.js"];
g["25"]=["\/js\/version\/201310\/tpl_qxc_ball.201310211934.js"];
g["22"]=["\/js\/version\/201311\/record.201311151821.js","\/js\/version\/201309\/record.append.201309120953.js","\/js\/version\/201311\/tpl_JJC_dealDetail.201311151642.js","\/js\/version\/201310\/tpl_detail_JJC_betContent.201310141551.js","\/js\/version\/201309\/tpl_detail_SFC_betContent.201309112134.js","\/js\/version\/201309\/tpl_detail_SZC_betContent.201309112206.js","\/js\/version\/201310\/tpl_detail_mix_betContent.201310091452.js","\/js\/version\/201310\/tpl_hm_planDetail_php_tpl.201310141551.js"];
g["24"]=["\/js\/version\/201308\/sdSum.201308131538.js","\/js\/version\/201310\/tpl_sd_ball.201310211927.js","\/js\/version\/201310\/tpl_sd_he_tpl.201310211927.js"];
g["7"]=["\/js\/version\/201306\/ssq.201306061601.js"];
g["15"]=["\/js\/version\/201311\/sz.201311181106.js","\/js\/version\/201311\/tpl_kpc_issue_result.201311181123.js","\/js\/version\/201311\/tpl_kpc_lastDrawResult.201311111010.js","\/js\/version\/201310\/tpl_sz_ul_li.201310211539.js"];
g["29"]=[];
c = [['JJC_yh',21,0],['act518',0,0],['active',13,0],['ahk3',0,1],['cache',11,0],['calcu',16,0],['cms',20,0],['consult',0,2],['cookie',0,3],['data',12,0],['data.active',12,1],['data.cms',12,2],['data.deal',12,3],['data.fina',12,4],['data.live',12,5],['data.lottery',12,6],['data.msg',12,7],['data.user',12,8],['date',0,4],['device',11,1],['dot',11,2],['event',11,3],['exchange',0,5],['fqhm',16,1],['frame',11,4],['frame.h5',11,5],['frame.pc',0,6],['frame.ui',11,6],['guid',0,7],['iScroll',11,7],['iScrollPc',0,8],['inf',11,8],['info',14,0],['info.ui',14,1],['ios',0,9],['jjc',17,0],['jjc_nvshen',0,10],['join',18,0],['jquery',0,11],['jx11x5',0,12],['lottIcons',0,13],['lotteryTool',0,14],['lssc',0,15],['mRaffle',20,1],['msg',0,16],['my',19,0],['my.myLottery',19,1],['myTouch',11,9],['new3',13,1],['newcomer',0,17],['ns_channel',30,0],['qxc',0,18],['record',22,0],['record.append',22,1],['record.dealrecord',0,19],['remote',11,10],['sd',0,20],['sdSum',24,0],['sfc',18,1],['sms',0,21],['sns',0,22],['sport',0,23],['ssq',7,0],['sz',15,0],['szc',0,24],['testTools',0,25],['testTools.reportConfig',0,26],['url',11,11],['xd',16,2],['zb',0,27],['zepto',0,28],['tpl_JCZQ_BF_odds',17,1],['tpl_JCZQ_BF_tap',17,2],['tpl_JCZQ_MIX_BF_odds',17,3],['tpl_JCZQ_SPF_matchList',17,4],['tpl_JCZQ_SPF_payMatchList',17,5],['tpl_JCZQ_choose',17,6],['tpl_JCZQ_mix_matchList',17,7],['tpl_JCZQ_mix_payMatchList',17,8],['tpl_JCZQ_payBotMsg',17,9],['tpl_JJC_dealDetail',22,2],['tpl_JJC_passType',17,10],['tpl_act518_tpl',0,29],['tpl_act908_tpl',0,30],['tpl_act_qa',0,31],['tpl_bl_sjyz',0,32],['tpl_consult_add',0,33],['tpl_createDeal_1014',16,3],['tpl_createJoin_tpl',0,34],['tpl_create_deal_tpl',16,4],['tpl_detail_JJC_betContent',22,3],['tpl_detail_SFC_betContent',22,4],['tpl_detail_SZC_betContent',22,5],['tpl_detail_mix_betContent',22,6],['tpl_detail_php_tpl',0,35],['tpl_dialog_new',0,36],['tpl_gzyl_tpl',0,37],['tpl_hm_planDetail_php_tpl',22,7],['tpl_index',0,38],['tpl_indexCMS',0,39],['tpl_ios_create_tpl',0,40],['tpl_item_getAllItemJson_tmpl_v2',0,41],['tpl_jjcYh_detail',21,1],['tpl_jjcYh_tpl',21,2],['tpl_jx11x5_ball',26,0],['tpl_kjgg_histroyList_kpc_tpl',0,42],['tpl_kjgg_list_new',0,43],['tpl_kpc_issue_result',15,1],['tpl_kpc_lastDrawResult',15,2],['tpl_ks_ball',28,0],['tpl_lottery.ui',0,44],['tpl_lssc_ball',27,0],['tpl_m_raffle_record_tpl',20,2],['tpl_my_active',13,2],['tpl_my_active_main',13,3],['tpl_my_coupon',13,4],['tpl_my_register_result',0,45],['tpl_newcomer_append',0,46],['tpl_newcomer_appendFive',0,47],['tpl_newcomer_rechange_ten',0,48],['tpl_newer_h5act_tpl',0,49],['tpl_newer_song_wx',0,50],['tpl_nv_channel_main',30,1],['tpl_open_planlist_planItem_tpl',0,51],['tpl_qb_exchange',0,52],['tpl_qxc_ball',25,0],['tpl_regist_v2_ssq_gift',0,53],['tpl_register_v2_verify_phone',0,54],['tpl_sd_ball',24,1],['tpl_sd_he_tpl',24,2],['tpl_share_hongbao',0,55],['tpl_share_tpl',0,56],['tpl_sport_black',0,57],['tpl_ssq_ball_tpl',0,58],['tpl_ssq_blscj',0,59],['tpl_ssq_bzfj',0,60],['tpl_submit_deal_info',0,61],['tpl_sz_choose',0,62],['tpl_sz_datamap',0,63],['tpl_sz_ul_li',15,3],['tpl_szc_reference',0,64],['tpl_tpl_consult_detail',0,65],['tpl_tpl_consult_list',0,66],['tpl_tpl_consult_list_li',0,67],['tpl_tpl_ssq_blhm',0,68],['tpl_xiaofeisong_tpl',0,69]];
for(var i=0;i<c.length;i++){
	if(typeof(grays[c[i][0]])!="undefined" && gray(c[i][0])){
		g[c[i][1]][c[i][2]]=grays[c[i][0]];
	}
}
if(typeof(JSON)!="undefined" && window.localStorage){
	for(var key in localStorage){
		if(/^_m_/.test(key)){
			var store = JSON.parse(localStorage.getItem(key));
        	var i = key.substr(3);
        	if((new Date()).getTime()>store.cacheTime){
	    		continue;
	    	}
	    	var _m=getModuleMap(i);
	    	if(!_m || _m.group==0){continue;}
	    	var curPath=g[_m.group][_m.groupid];
	    	if((d+curPath)==store.path){
				g["0"].push(curPath);
				g[_m.group][_m.groupid]=blankjs;
				c[_m.index]=[_m.id,0,g[0].length-1];
			}
		}
	}
	}
function getModuleMap(id){
	for(var i=0;i<c.length;i++){
		if(c[i][0]==id){
			return {"id":id,"index":i,"group":c[i][1],"groupid":c[i][2]};
		}
	}
	return "";
}
function getCombUrl(list){
	var a=[];
	for(var i=0;i<list.length;i++){
		if(list[i]){
			a.push(list[i]);
		}
	}
	return a.length>1?(d+"/c/="+a.join(",")):(d+a[0]);
}

for(var i=0;i<c.length;i++){
	var surl=d+g[c[i][1]][c[i][2]];
	var furl=getCombUrl(g[c[i][1]]);//合并包地址
	a[c[i][0]]=surl;
	p[c[i][0]]=(c[i][1]==0)?surl:furl;
}

m.alias=mdebug?a:p;
m.moduleURI=a;

m.vars = {
"jquery":isPC==false?"zepto":"jquery",
"bridge":isPC==false?"frame.h5":"frame.pc",
'iScroll':isPC==false?"iScroll":"iScrollPc"
};

global._moduleConfig = m;

function gray(m){
	if(/^(jx11x5|sz|tpl_sz_choose|record\.dealrecord|ahk3|lssc|sd|szc|qxc)$/.test(m)){
   if(location.href.indexOf("_szgray=1")!=-1){
       return false;
   }
   else{
       return true;
   }
}}

})(this);
</script>
<script src="http://static.gtimg.com/js/version/201311/module.201311141359.js"></script>
<script type="text/javascript">
_mytouchConfig = {
frame:["frame","init"],
index:["item","getAllItemJson"]
}
if(typeof(vb2cTag)!="undefined"&&vb2cTag=="1_67_1_1444"){
    _mytouchConfig.index = ["join","chooseJson"];
}
modulejs("myTouch",function(m){
    m.info.on("new_module_action",function(obj){
        var model = obj.m;
        if(modelRouteMap && typeof modelRouteMap[model]!='undefined'){
            model = modelRouteMap[model];
        }
        obj.m = model;
        return {msgGoon:true};
        //test
    });
    m.init();
    
});</script><!--[if !IE]>|xGv00|874c53f21809d8b0593778ec017a41c2<![endif]-->

<style>
.mode_webapp{
padding-top:0;
}
</style>


</body>
</html>