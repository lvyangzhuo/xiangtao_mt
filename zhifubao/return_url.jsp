<%
/* *
 ���ܣ�֧����ҳ����תͬ��֪ͨҳ��
 �汾��3.2
 ���ڣ�2011-03-17
 ˵����
 ���´���ֻ��Ϊ�˷����̻����Զ��ṩ���������룬�̻����Ը����Լ���վ����Ҫ�����ռ����ĵ���д,����һ��Ҫʹ�øô��롣
 �ô������ѧϰ���о�֧�����ӿ�ʹ�ã�ֻ���ṩһ���ο���

 //***********ҳ�湦��˵��***********
 ��ҳ����ڱ������Բ���
 �ɷ���HTML������ҳ��Ĵ��롢�̻�ҵ���߼��������
 TRADE_FINISHED(��ʾ�����Ѿ��ɹ��������������ٶԸý�������������);
 TRADE_SUCCESS(��ʾ�����Ѿ��ɹ����������ԶԸý����������������磺�����˿��);
 //********************************
 * */
%>
<%@ page language="java" contentType="text/html; charset=gbk" pageEncoding="gbk"%>
<%@ page import="java.util.*"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.alipay.util.*"%>
<%@ page import="com.alipay.config.*"%>
<%@ page import="java.text.SimpleDateFormat"%><%@ page language="java" import="java.util.*"%><%@ page language="java" import="java.io.*"%><%@ page language="java" import="java.sql.*"%><%@ page language="java" import="com.wsu.basic.util.Tools"%><%@ page language="java" import="com.wsu.basic.dbsconnect.*"%>
<html>
  <head>
		<meta http-equiv="Content-Type" content="text/html; charset=gbk">
		<title>֧����ҳ����תͬ��֪ͨҳ��</title>
  </head>
  <body>
<%
	//��ȡ֧����GET����������Ϣ
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
		//����������δ����ڳ�������ʱʹ�á����mysign��sign�����Ҳ����ʹ����δ���ת��
		valueStr = new String(valueStr.getBytes("ISO-8859-1"), "utf-8");
		params.put(name, valueStr);
	}
	
	//��ȡ֧������֪ͨ���ز������ɲο������ĵ���ҳ����תͬ��֪ͨ�����б�(���½����ο�)//
	//�̻�������
	String out_trade_no = new String(request.getParameter("out_trade_no").getBytes("ISO-8859-1"),"GBK");

	//֧�������׺�
	String trade_no = new String(request.getParameter("trade_no").getBytes("ISO-8859-1"),"GBK");

	//����״̬
	String trade_status = new String(request.getParameter("trade_status").getBytes("ISO-8859-1"),"GBK");

	//��ȡ֧������֪ͨ���ز������ɲο������ĵ���ҳ����תͬ��֪ͨ�����б�(���Ͻ����ο�)//
	
	//����ó�֪ͨ��֤���
	boolean verify_result = AlipayNotify.verify(params);
	
	/*
	if(verify_result){//��֤�ɹ�
		//////////////////////////////////////////////////////////////////////////////////////////
		//������������̻���ҵ���߼��������

		//�������������ҵ���߼�����д�������´�������ο�������
		if(trade_status.equals("TRADE_FINISHED") || trade_status.equals("TRADE_SUCCESS")){
			//�жϸñʶ����Ƿ����̻���վ���Ѿ���������
				//���û�������������ݶ����ţ�out_trade_no�����̻���վ�Ķ���ϵͳ�в鵽�ñʶ�������ϸ����ִ���̻���ҵ�����
				//���������������ִ���̻���ҵ�����
		}
		
		//��ҳ�����ҳ�������༭
		out.println("��֤�ɹ�<br />");
		//�������������ҵ���߼�����д�������ϴ�������ο�������
		System.out.println("r_out_trade_no=="+out_trade_no);
		System.out.println("r_trade_status=="+trade_status);
		//////////////////////////////////////////////////////////////////////////////////////////
	}else{
		//��ҳ�����ҳ�������༭
		out.println("��֤ʧ��");
	}
	*/

	out.println("��֤�ɹ�<br />");
		//�������������ҵ���߼�����д�������ϴ�������ο�������
		System.out.println("r_out_trade_no=="+out_trade_no);
		System.out.println("r_trade_status=="+trade_status);



request.setCharacterEncoding("GBK");
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

String userid = Tools.RmNull((String)session.getAttribute("userid"));
if(userid.equals("")&&c_userid.equals(""))
{
	response.sendRedirect("/do/login.html");
	return;
}
int j =0;
enable = Tools.isNumber(c);

		try {
	DBcon dbcon = new DBcon(); //���ݿ�����
	con = dbcon.getConnection();
	stmt = con.createStatement();
	ArrayList s = new ArrayList();
	// update 
	if(trade_status.equals("TRADE_SUCCESS"))
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
		
		
		
		out.println("������֧���ɹ���&nbsp;<input type=\"button\" name=\"Submit\" value=\"ȷ�Ϲرմ���\" onclick=\"window.close();\"  />");
	}
	
	
	
} catch (Exception e) {
	System.out.println("return_url.jsp error :" + e);
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
  </body>
</html>