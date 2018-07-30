<?php
AccountMod::require_sp_uid();
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "_http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta charset="UTF-8">
<title>
	易贷诚金融-贷款计算器
</title>
<meta name="viewport" content="initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no" />
<link type="text/css" href="<?php echo $static_path;?>/css/calc.css" rel="stylesheet" />
<!--<script src="../Scripts/Common.js" type="text/javascript"></script> -->

	
<script>
function changeTwoDecimal(text) {
    var pos = text.indexOf('.');

    if (pos < 0) {
	    text = text + '.' + "00";
	    return text;
    }

    if (text.length >= pos + 2 + 1) {
	    text = text.substring(0, pos + 2 + 1);
    } else {
        text = text + "0";
    }

    return text;
}
</script>
</head>
<body>
	
    
    <div class="fix-props2">
	<img src="<?php echo $static_path;?>/images/logo.jpg" style="height:44px;">	
    </div>
    <div class="head fix-props">
        <div class="menubar">
            <span class="left"></span>
            <span class="mid"><a href="?_easy=form.daikuan.index.formlist">首页</a></span>
            <span class="right"></span>
        </div>
        <span>贷款计算器</span>
    </div>
    <div class="fix-clear fix-default-pos"></div>
    <div class="clearfloat" style="height:44px;"></div>
    <span class="blocktitle">等额还款方式</span>
    <div class="clearfloat"></div>
    
    <div class="options">
        <table cellpadding="0" cellspacing="0" width="100%" border="0" align="center">
            <tbody>
                <tr>
                    <td class="boxtop">
                        <table cellpadding="0" cellspacing="0" align="center" width="100%" border="0">
                            <tr>
                                <td class="text loancaltext leftspace">贷款种类：</td>
                                <td class="inputbox rightspace">
                                    <select id="ddEQLoanType" class="seltype onlyinput" style="height: 26px;">
    		                            <option value="1">个人消费贷款</option>
    		                            <option value="2">个人住房贷款</option>
    		                        </select>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td class="boxmid">
                        <table cellpadding="0" cellspacing="0" align="center" width="100%" border="0">
                            <tr>
                                <td class="text loancaltext leftspace">贷款本金：</td>
                                <td class="inputbox">
                                    <input name="tbEQAmount" id="tbEQAmount" type="number" class="inputtype imedisabled" />
                                </td>
                                <td class="label rightspace">元</td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td class="boxmid">
                        <table cellpadding="0" cellspacing="0" align="center" width="100%" border="0">
                            <tr>
                                <td class="text loancaltext leftspace">贷款期限：</td>
                                <td class="inputbox">
                                    <input name="tbEQTerms" id="tbEQTerms" type="number" class="inputtype imedisabled" onpropertychange="getRightRate(1);" oninput="getRightRate(1);"/>
                                </td>
                                <td class="label rightspace fivewordlabel">月(1-360)</td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td class="boxmid">
                        <table cellpadding="0" cellspacing="0" align="center" width="100%" border="0">
                            <tr>
                                <td class="text loancaltext leftspace">年利率：</td>
                                <td class="inputbox">
                                    <input name="tbEQAPR" id="tbEQAPR" type="number" class="inputtype imedisabled" />
                                </td>
                                <td class="label rightspace">%</td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td class="boxbottom">
                        <table cellpadding="0" cellspacing="0" align="center" width="100%" border="0">
                            <tr>
                                <td class="text loancaltext leftspace">每月偿还本息额：</td>
                                <td class="spanbox">
                                    <span id="tbEQResult">&nbsp;</span>
                                </td>
                                <td class="label rightspace">元</td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </tbody>
        </table>
    </div>
    
    <div class="clearfloat"></div>
    <div id="eqerrormsg" class="checkerror"></div>
    <div class="clearfloat"></div>
    
    <div class="btns">
        <a href="javascript:calculateEQ();" class="btn per50width">计&nbsp;&nbsp;&nbsp;&nbsp;算</a>
    </div>
    
    <div class="clearfloat"></div>
    <span class="blocktitle">按月递减还款方式</span>
    <div class="clearfloat"></div>
    
    <div class="options">
        <table cellpadding="0" cellspacing="0" width="100%" border="0" align="center">
            <tbody>
                <tr>
                    <td class="boxtop">
                        <table cellpadding="0" cellspacing="0" align="center" width="100%" border="0">
                            <tr>
                                <td class="text loancaltext leftspace">贷款种类：</td>
                                <td class="inputbox rightspace">
                                    <select id="ddDecLoanType" class="seltype onlyinput" style="height: 26px;">
    		                            <option value="1">个人消费贷款</option>
    		                            <option value="2">个人住房贷款</option>
    		                        </select>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td class="boxmid">
                        <table cellpadding="0" cellspacing="0" align="center" width="100%" border="0">
                            <tr>
                                <td class="text loancaltext leftspace">贷款本金：</td>
                                <td class="inputbox">
                                    <input name="tbDecAmount" id="tbDecAmount" type="number" class="inputtype imedisabled" />
                                </td>
                                <td class="label rightspace">元</td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td class="boxmid">
                        <table cellpadding="0" cellspacing="0" align="center" width="100%" border="0">
                            <tr>
                                <td class="text loancaltext leftspace">贷款期限：</td>
                                <td class="inputbox">
                                    <input name="tbDecTerms" id="tbDecTerms" type="number" class="inputtype imedisabled" onpropertychange="getRightRate(2);" oninput="getRightRate(2);"/>
                                </td>
                                <td class="label rightspace fivewordlabel">月(1-360)</td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td class="boxmid">
                        <table cellpadding="0" cellspacing="0" align="center" width="100%" border="0">
                            <tr>
                                <td class="text loancaltext leftspace">年利率：</td>
                                <td class="inputbox">
                                    <input name="tbDecAPR" id="tbDecAPR" type="number" class="inputtype imedisabled" />
                                </td>
                                <td class="label rightspace">%</td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td class="boxmid">
                        <table cellpadding="0" cellspacing="0" align="center" width="100%" border="0">
                            <tr>
                                <td class="text loancaltext leftspace">已归还期数：</td>
                                <td class="inputbox">
                                    <input name="tbDecRepayTerms" id="tbDecRepayTerms" type="number" class="inputtype imedisabled" />
                                </td>
                                <td class="label rightspace">月</td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td class="boxbottom">
                        <table cellpadding="0" cellspacing="0" align="center" width="100%" border="0">
                            <tr>
                                <td class="text loancaltext leftspace">下期偿还本息额：</td>
                                <td class="spanbox">
                                    <span id="tbDecResult">&nbsp;</span>
                                </td>
                                <td class="label rightspace">元</td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </tbody>
        </table>
    </div>
    
    <div class="clearfloat"></div>
    <div id="decerrormsg" class="checkerror"></div>
    <div class="clearfloat"></div>
    
    <div class="btns">
        <a href="javascript:calculateDec();" class="btn per50width">计&nbsp;&nbsp;&nbsp;&nbsp;算</a>
    </div>
    
    <div class="clearfloat"></div>
    <span class="blocktitle">按月结息到期还本还款方式</span>
    <div class="clearfloat"></div>
    
    <div class="options">
        <table cellpadding="0" cellspacing="0" width="100%" border="0" align="center">
            <tbody>
                <tr>
                    <td class="boxtop">
                        <table cellpadding="0" cellspacing="0" align="center" width="100%" border="0">
                            <tr>
                                <td class="text loanmonthlycaltext leftspace">贷款本金：</td>
                                <td class="inputbox">
                                    <input name="tbMonAmount" id="tbMonAmount" type="number" class="inputtype imedisabled" />
                                </td>
                                <td class="label rightspace">元</td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td class="boxmid">
                        <table cellpadding="0" cellspacing="0" align="center" width="100%" border="0">
                            <tr>
                                <td class="text loanmonthlycaltext leftspace">计算时间：</td>
                                <td class="inputbox">
                                    <select name="ctl00$bodyContent$ddMonYear" id="ctl00_bodyContent_ddMonYear" class="seltype onlyinput" style="height: 26px;">
	<option selected="selected" value="">年份</option>
	<option value="1985">1985</option>
	<option value="1986">1986</option>
	<option value="1987">1987</option>
	<option value="1988">1988</option>
	<option value="1989">1989</option>
	<option value="1990">1990</option>
	<option value="1991">1991</option>
	<option value="1992">1992</option>
	<option value="1993">1993</option>
	<option value="1994">1994</option>
	<option value="1995">1995</option>
	<option value="1996">1996</option>
	<option value="1997">1997</option>
	<option value="1998">1998</option>
	<option value="1999">1999</option>
	<option value="2000">2000</option>
	<option value="2001">2001</option>
	<option value="2002">2002</option>
	<option value="2003">2003</option>
	<option value="2004">2004</option>
	<option value="2005">2005</option>
	<option value="2006">2006</option>
	<option value="2007">2007</option>
	<option value="2008">2008</option>
	<option value="2009">2009</option>
	<option value="2010">2010</option>
	<option value="2011">2011</option>
	<option value="2012">2012</option>
	<option value="2013">2013</option>
	<option value="2014">2014</option>
	<option value="2015">2015</option>
	<option value="2016">2016</option>
	<option value="2017">2017</option>
	<option value="2018">2018</option>
	<option value="2019">2019</option>
	<option value="2020">2020</option>
	<option value="2021">2021</option>
	<option value="2022">2022</option>
	<option value="2023">2023</option>
	<option value="2024">2024</option>
	<option value="2025">2025</option>
	<option value="2026">2026</option>
	<option value="2027">2027</option>
	<option value="2028">2028</option>
	<option value="2029">2029</option>
	<option value="2030">2030</option>
	<option value="2031">2031</option>
	<option value="2032">2032</option>
	<option value="2033">2033</option>
	<option value="2034">2034</option>
	<option value="2035">2035</option>
	<option value="2036">2036</option>
	<option value="2037">2037</option>
	<option value="2038">2038</option>
	<option value="2039">2039</option>
	<option value="2040">2040</option>
	<option value="2041">2041</option>
	<option value="2042">2042</option>
	<option value="2043">2043</option>
	<option value="2044">2044</option>
	<option value="2045">2045</option>
	<option value="2046">2046</option>
	<option value="2047">2047</option>
	<option value="2048">2048</option>
	<option value="2049">2049</option>
	<option value="2050">2050</option>
	<option value="2051">2051</option>
	<option value="2052">2052</option>
	<option value="2053">2053</option>
	<option value="2054">2054</option>
	<option value="2055">2055</option>
	<option value="2056">2056</option>
	<option value="2057">2057</option>
	<option value="2058">2058</option>
	<option value="2059">2059</option>
	<option value="2060">2060</option>
	<option value="2061">2061</option>
	<option value="2062">2062</option>
	<option value="2063">2063</option>
	<option value="2064">2064</option>
	<option value="2065">2065</option>
	<option value="2066">2066</option>
	<option value="2067">2067</option>
	<option value="2068">2068</option>
	<option value="2069">2069</option>
	<option value="2070">2070</option>
	<option value="2071">2071</option>
	<option value="2072">2072</option>
	<option value="2073">2073</option>
	<option value="2074">2074</option>
	<option value="2075">2075</option>
	<option value="2076">2076</option>
	<option value="2077">2077</option>
	<option value="2078">2078</option>
	<option value="2079">2079</option>
	<option value="2080">2080</option>
	<option value="2081">2081</option>
	<option value="2082">2082</option>
	<option value="2083">2083</option>
	<option value="2084">2084</option>
	<option value="2085">2085</option>
</select>
                                </td>
                                <td class="label loanyearlabel">年</td>
                                <td class="inputbox">
                                    <select name="ctl00$bodyContent$ddMonMonth" id="ctl00_bodyContent_ddMonMonth" class="seltype onlyinput" style="height: 26px;">
	<option selected="selected" value="">月份</option>
	<option value="1">1</option>
	<option value="2">2</option>
	<option value="3">3</option>
	<option value="4">4</option>
	<option value="5">5</option>
	<option value="6">6</option>
	<option value="7">7</option>
	<option value="8">8</option>
	<option value="9">9</option>
	<option value="10">10</option>
	<option value="11">11</option>
	<option value="12">12</option>
</select>
                                </td>
                                <td class="label rightspace loanmonthlabel">月</td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td class="boxmid">
                        <table cellpadding="0" cellspacing="0" align="center" width="100%" border="0">
                            <tr>
                                <td class="text loanmonthlycaltext leftspace">年利率：</td>
                                <td class="inputbox">
                                    <input name="tbMonAPR" id="tbMonAPR" type="number" class="inputtype imedisabled" />
                                </td>
                                <td class="label rightspace">%</td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td class="boxbottom">
                        <table cellpadding="0" cellspacing="0" align="center" width="100%" border="0">
                            <tr>
                                <td class="text loanmonthlycaltext leftspace">月供利息：</td>
                                <td class="spanbox">
                                    <span id="tbMonResult">&nbsp;</span>
                                </td>
                                <td class="label rightspace">元</td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </tbody>
        </table>
    </div>

    <div class="clearfloat"></div>
    <div id="monthlyerrormsg" class="checkerror"></div>
    <div class="clearfloat"></div>
    
    <div class="btns calbtn">
        <a href="javascript:calculateMonthly();" class="btn per50width">计&nbsp;&nbsp;&nbsp;&nbsp;算</a>
    </div>
 
<p style="text-align:center;color:gray;">© 易贷诚金融</p>
<script type="text/javascript" language="javascript">
    var rateList = new Array(new Array('1','0','5','3.87'), new Array('1','5','30','4.59'), new Array('2','0','6','4.35'), new Array('2','6','12','4.35'), new Array('2','12','36','4.75'), new Array('2','36','60','4.75'), new Array('2','60','360','4.90'));
    
    function calculateEQ() {
        var tbEQAmount = document.getElementById("tbEQAmount");
        var tbEQTerms = document.getElementById("tbEQTerms");
        var tbEQAPR = document.getElementById("tbEQAPR");
        var errormsg = document.getElementById("eqerrormsg");
        
        var amount = tbEQAmount.value;
        var terms = tbEQTerms.value;
        var apr = tbEQAPR.value;

        document.getElementById("tbEQResult").innerHTML = "&nbsp;";
        errormsg.innerHTML = "";
        errormsg.style.display = "none";
        
        if (amount == "" || isNaN(amount)) {
            errormsg.innerHTML = "请正确输入贷款本金！";
            errormsg.style.display = "block";
            tbEQAmount.focus();
            return;
        }
        
        if (terms == "" || isNaN(terms)) {
            errormsg.innerHTML = "请正确输入贷款期限！";
            errormsg.style.display = "block";
            tbEQTerms.focus();
            return;
        }
        
        if (terms <= 0 || terms > 360) {
            errormsg.innerHTML = "贷款期限超出范围！";
            errormsg.style.display = "block";
            tbEQTerms.focus();
            return;
        }
        
        if (apr == "") {
            apr = getRate(terms);
            
            if (apr == 0) {
                errormsg.innerHTML = "贷款期限内没有查到相应的年利率，请输入年利率！";
                errormsg.style.display = "block";
                tbEQAPR.focus();
                return;
            }
        }
        
        if (isNaN(apr)) {
            errormsg.innerHTML = "请正确输入年利率！";
            errormsg.style.display = "block";
            tbEQAPR.focus();
            return;
        }
        
        with (Math) {
            var mrate = apr / 1200;
            var result = amount * mrate * pow((1 + mrate), terms);
            result = result / (pow(( 1 + mrate), terms) - 1);
        }
        
        result = Math.round(result * 100);
        result = result / 100;
        document.getElementById("tbEQResult").innerHTML = changeTwoDecimal(result + "");
        tbEQAPR.value = apr;
        
        return;
    }
    
    function calculateDec() {
        var tbDecAmount = document.getElementById("tbDecAmount");
        var tbDecTerms = document.getElementById("tbDecTerms");
        var tbDecAPR = document.getElementById("tbDecAPR");
        var tbDecRepayTerms = document.getElementById("tbDecRepayTerms");
        var errormsg = document.getElementById("decerrormsg");

        var amount = tbDecAmount.value;
        var terms = tbDecTerms.value;
        var apr = tbDecAPR.value;
        var repayTerms = tbDecRepayTerms.value;
        
        document.getElementById("tbDecResult").innerHTML = "&nbsp;";
        errormsg.innerHTML = "";
        errormsg.style.display = "none";
        
        if (amount == "" || isNaN(amount)) {
            errormsg.innerHTML = "请正确输入贷款本金！";
            errormsg.style.display = "block";
            tbDecAmount.focus();
            return;
        }
        
        if (terms == "" || isNaN(terms)) {
            errormsg.innerHTML = "请正确输入贷款期限！";
            errormsg.style.display = "block";
            tbDecTerms.focus();
            return;
        }
        
        if (terms <= 0 || terms > 360) {
            errormsg.innerHTML = "贷款期限超出范围！";
            errormsg.style.display = "block";
            tbDecTerms.focus();
            return;
        }
        
        if (apr == "") {
            apr = getRate(terms);
            
            if (apr == 0) {
                errormsg.innerHTML = "贷款期限内没有查到相应的年利率，请输入年利率！";
                errormsg.style.display = "block";
                tbDecAPR.focus();
                return;
            }
        }
        
        if (isNaN(apr)) {
            errormsg.innerHTML = "请正确输入年利率！";
            errormsg.style.display = "block";
            tbDecAPR.focus();
            return;
        }
        
        if (repayTerms == "" || isNaN(repayTerms)) {
            errormsg.innerHTML = "请正确输入已归还期数！";
            errormsg.style.display = "block";
            tbDecRepayTerms.focus();
            return;
        } else {
            repayTerms = parseInt(repayTerms);
        }
        
        if (repayTerms < 0 || repayTerms >= terms) {
            errormsg.innerHTML = "已归还期数超限！";
            errormsg.style.display = "block";
            tbDecRepayTerms.focus();
            return;
        }
        
        with (Math) {
            var mrate = apr / 1200;
            var payback = amount / terms * repayTerms;
            var result = amount / terms + (amount - payback) * mrate;
        }
        
        result = Math.round(result * 100);
        result = result / 100;
        document.getElementById("tbDecResult").innerHTML = changeTwoDecimal(result + "");
        tbDecAPR.value = apr;

        return;
    }
    
    function calculateMonthly() {
        var tbMonAmount = document.getElementById("tbMonAmount");
        var monYearSel = document.getElementById("ctl00_bodyContent_ddMonYear");
        var monMonthSel = document.getElementById("ctl00_bodyContent_ddMonMonth");
        var tbMonAPR = document.getElementById("tbMonAPR");
        var errormsg = document.getElementById("monthlyerrormsg");
        
        var amount = tbMonAmount.value;
        var year = monYearSel.options[monYearSel.selectedIndex].value;
        var month = monMonthSel.options[monMonthSel.selectedIndex].value;
        var apr = tbMonAPR.value;

        document.getElementById("tbMonResult").innerHTML = "&nbsp;";
        errormsg.innerHTML = "";
        errormsg.style.display = "none";
        
        if (amount == "" || isNaN(amount)) {
            errormsg.innerHTML = "请正确输入贷款本金！";
            errormsg.style.display = "block";
            tbMonAmount.focus();
            return;
        }
        
        if (year == "") {
            errormsg.innerHTML = "请选择年份！";
            errormsg.style.display = "block";
            monYearSel.focus();
            return;
        }
        
        if (month == "") {
            errormsg.innerHTML = "请选择月份！";
            errormsg.style.display = "block";
            monMonthSel.focus();
            return;
        }
        
        if (apr == "" || isNaN(apr)) {
            errormsg.innerHTML = "请正确输入年利率！";
            errormsg.style.display = "block";
            tbMonAPR.focus();
            return;
        }
        
        var days;

        if (month == 2) {
            days = 28;
            
	        if (parseInt(year) % 4 == 0) {
		        days = 29;
	        }
        } else if (month == 4 || month == 6 || month == 9 || month == 11) {
	        days = 30;
        } else {
	        days = 31;
        }
    	
    	// 日利率	
        var dayrate = apr / 360;
        // 月供利息	
        var result = Math.round(amount * dayrate * days) / 100;
        
        document.getElementById("tbMonResult").innerHTML = changeTwoDecimal(result + "");
        
        return;            
    }
    
    
    function getRate(mouth) {
        if(mouth==0){
            return rateList[2][3];
        }
        for (var i = 0 ; i < rateList.length; i++) {
            if (rateList[i][0] == "2") {
                if (mouth > parseInt(rateList[i][1]) && mouth <= parseInt(rateList[i][2])) {
                    return rateList[i][3];
                }   
            }
        }
        return 0;
    }
    
    function initRate(){
        if(document.getElementById("tbEQTerms").value==""){
            document.getElementById("tbEQAPR").value=getRate(0);           
        }
        if(document.getElementById("tbDecTerms").value==""){
            document.getElementById("tbDecAPR").value=getRate(0);    
        } 
    }
    
    initRate();
    ///实时获取所选期数的利率，t表示计算器类型，1是第一个，2是第二个
    function getRightRate(t){
        var term;//期数
        var loanType;//所选类型的值
        var objtbEQAPR = document.getElementById("tbEQAPR");
        var objtbDecAPR = document.getElementById("tbDecAPR");
        if (t==1){
            term = document.getElementById("tbEQTerms").value;
        }
        else if(t==2){
            term = document.getElementById("tbDecTerms").value;
        }
        if (term==""||null==term){
            initRate();
            return ;
        }
        //期数超限则返回
        if(term<=0||term>360){
            if(1==t){
                objtbEQAPR.value="";
            }
            else if(2==t){
                objtbDecAPR.value="";
            }
            return ;
        }
        var rate = getRate(term);//取值
        if(t==1){
            objtbEQAPR.value = rate;
        }
        else if(t==2){
            objtbDecAPR.value=rate;
        }
    }
</script>
<?php 
//计算器不要自定义分享了
//include $tpl_path.'/footer.tpl'; 
?>
	<div class="clearfloat"></div>
</body>
</html>


