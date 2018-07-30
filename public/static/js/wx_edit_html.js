document.writeln("<div class=\"wx_err_info\">最多能添加8条图文消息</div>");
document.writeln("<div class=\"wx_mask\"></div>");
document.writeln("<div class=\"wx_edit_close\">&times</div>");
document.writeln("<div class=\"wx_edit_box\">");
document.writeln("			<ul class=\"wx_edit_nav\">");
document.writeln("				<li class=\"select\">回复消息</li>");
document.writeln("				<li>单图文</li>");
document.writeln("				<li>多图文</li>");
document.writeln("			</ul>");
document.writeln("			<div class=\"wx_edit_cont\">");
document.writeln("				<!-- 回复消息 -->");
document.writeln("				<div  class=\"wx_edit_cont_face\">");
document.writeln("					<div style=\"position:relative;\">");
document.writeln("		               <div id=\"show\" contenteditable=\"true\"></div>");
document.writeln("		               <div class=\"comment\">");
document.writeln("		                  <div class=\"com_form\">");
document.writeln("		                    <textarea id=\"showtext\" name=\"showtext\" style=\"display:none;\"></textarea>");

document.writeln("		                    <textarea class=\"input\" id=\"saytext\" name=\"saytext\" style=\"display:none;\"></textarea>");
document.writeln("		                    <p><span class=\"emotion\"></span></p>");
document.writeln("		                  </div>");
document.writeln("		               </div>  ");
document.writeln("<button class=\"wx_edit_face am-btn am-btn-primary\">保存</button>");

document.writeln("		            </div>");

document.writeln("				</div>");

document.writeln("				<!-- 单图文 -->");
document.writeln("				<div style=\"display:none;\" class=\"wx_edit_cont_sigle\">");
document.writeln("					");
document.writeln("					 <div class=\"s_main_bd\">");
document.writeln("			            <div class=\"s_preview_area\">");
document.writeln("			              <h4 class=\"s_appmsg_title\">");
document.writeln("			                <a onclick=\"return false;\" href=\"javascript:void(0);\" class=\"s_title\" target=\"_blank\">标题</a>");
document.writeln("			              </h4>");
document.writeln("			              <div class=\"s_appmsg_thumb_wrp\">");
document.writeln("			                      <img class=\"s_appmsg_thumb\" src=\"\">");
document.writeln("			                  </div>");
document.writeln("			                  <p class=\"s_appmsg_desc\"></p>");
document.writeln("			            </div>");
document.writeln("			            <div class=\"s_edit_area\" style=\"position:relative;\">");
document.writeln("			              <div class=\"s_appmsg_edit_item bt_h\">");
document.writeln("			                <label for=\"\" class=\"s_frm_label\">标题</label>");
document.writeln("			                      <span class=\"s_frm_input_box\">");
document.writeln("			                          <input type=\"text\" class=\"s_frm_input s_frm_input_tit\" value=\"\" max-length=\"64\">");
document.writeln("			                          <!-- <em class=\"frm_counter_bt\">0/64</em> -->");
document.writeln("			                      </span>");
document.writeln("			                      <div class=\"frm_msg fail js_title_error\" style=\"display: none;\">标题不能为空且长度不能超过64字</div>");
document.writeln("			              </div>");
document.writeln("			              <div class=\"s_appmsg_edit_item zz_h\">");
document.writeln("			                <label for=\"\" class=\"s_frm_label\">作者<span class=\"sl_enter\">（选填）</span></label>");
document.writeln("			                      <span class=\"s_frm_input_box\">");
document.writeln("			                          <input type=\"text\" class=\"s_frm_input s_frm_input_author\" max-length=\"8\">");
document.writeln("			                          <!-- <em class=\"frm_counter_zz\">0/8</em> -->");
document.writeln("			                      </span>");
document.writeln("			                      <div class=\"frm_msg fail js_title_error\" style=\"display: none;\">标题不能为空且长度不能超过64字</div>");
document.writeln("			              </div>");
document.writeln("			              <div class=\"s_appmsg_edit_item s_fm_h\">");
document.writeln("			                <label for=\"\" class=\"s_frm_label\">封面<span class=\"sl_enter\">（大图片建议尺寸：900像素 * 500像素）</span></label>");
document.writeln("");
document.writeln("			                      <div id=\"s_codeImgBox\" style=\"margin:15px 0;\">");
document.writeln("			                          <img id=\"s_codeImg\" src=\"\" style=\"width:100px;height:75px;margin-left:8px;z-index:999;\"><a href=\"javascript:;\" class=\"delete_img\">删除</a>");
document.writeln("			                      </div>");
document.writeln("");
document.writeln("");
document.writeln("			                      <div class=\"frm_msg fail js_title_error\" style=\"display: none;\">标题不能为空且长度不能超过64字</div>");
document.writeln("			              </div>");
document.writeln("			              <!-- 单图文btn -->");
document.writeln("			              <button class=\"btn\" id=\"btn\">从图片库选择</button>");
document.writeln("");
document.writeln("			              <div class=\"s_appmsg_edit_item zy_h\">");
document.writeln("			                <label for=\"\" class=\"s_frm_label\">摘要<span class=\"sl_enter\">（选填）</span></label>");
document.writeln("			                      <textarea class=\"s_frm_textarea\" max-length=\"120\"></textarea>");
document.writeln("			                     <!--  <em class=\"frm_counter zy_counter\">0/120</em> -->");
document.writeln("			                      <div class=\"frm_msg fail js_title_error\" style=\"display: none;\">标题不能为空且长度不能超过64字</div>");
document.writeln("			              </div>");
document.writeln("			              <div class=\"s_appmsg_edit_item zz_h\">");
document.writeln("			                <label for=\"\" class=\"s_frm_label\">原文链接<span class=\"sl_enter\">（选填）</span></label>");
document.writeln("			                      <span class=\"s_frm_input_box\">");
document.writeln("			                          <input type=\"text\" class=\"s_frm_input s_frm_input_link\">   ");
document.writeln("			                      </span>");
document.writeln("			                      <div class=\"frm_msg fail js_title_error\" style=\"display: none;\">标题不能为空且长度不能超过64字</div>");
document.writeln("			              </div>");
document.writeln("			            </div>");
document.writeln("");
document.writeln("			          </div>");
document.writeln("<button class=\"wx_edit_sigle am-btn am-btn-primary\">保存</button>");
document.writeln("");
document.writeln("				</div>");

document.writeln("				<!-- 多图文 -->");
document.writeln("				<div style=\"display:none;\" class=\"wx_edit_cont_dabble\">");
document.writeln("					");
document.writeln("					<div style='overflow: hidden'>");
document.writeln("					<div class='msg_navLeft' style='float: left'>");
document.writeln("    ");
document.writeln("      <div id=\"appmsgItem1\" data-fileid data-id=\"1\">");
document.writeln("        ");
document.writeln("        <a onclick=\"return false;\" href=\"javascript:void(0);\" class=\"title\" target=\"_blank\">标题</a>");
document.writeln("        ");
document.writeln("        <div class=\"appmsg_thumb_wrp\">");
document.writeln("                <img class=\"appmsg_thumb\" src=\"\">");
document.writeln("            </div>");
document.writeln("            <a href=\"#\" class=\"msg_edit_b\"></a>");
document.writeln("      </div>");
document.writeln("");
document.writeln("");

document.writeln("      <div class='small-msg' id=\"appmsgItem2\" data-fileid data-id=\"2\">");
document.writeln("          ");
document.writeln("        <a href=\"#\" class=\"title_s\">标题</a>");
document.writeln("      ");
document.writeln("        <img src=\"\" class=\"msg_img\">");
document.writeln("          <a href=\"javascript:;\" class=\"msg_edit_s\"><img class=\"edit_img\" src=\"/app/sp/static/images/edit.png\"></a>");
document.writeln("        <!-- <a href=\"javascript:;\"></a> -->");
document.writeln("      </div>");
document.writeln("");
document.writeln("          <div id=\"addItems\"></div></div>");

document.writeln("      <div class=\"edit_area_b\">");
document.writeln("          <div class=\"appmsg_edit_item bt_h\">");
document.writeln("            <label for=\"\" class=\"frm_label\">标题</label>");
document.writeln("                  <span class=\"frm_input_box\">");
document.writeln("                      <input type=\"text\" class=\"frm_input frm_input_tit\" value=\"\" max-length=\"64\">");
document.writeln("                      <!-- <em class=\"frm_counter\">0/64</em> -->");
document.writeln("                  </span>");
document.writeln("                  <div class=\"frm_msg fail js_title_error\" style=\"display: none;\">标题不能为空且长度不能超过64字</div>");
document.writeln("          </div>");
document.writeln("");
document.writeln("          ");
document.writeln("");
document.writeln("          <div class=\"appmsg_edit_item zz_h\">");
document.writeln("            <label for=\"\" class=\"frm_label\">作者<span class=\"sl_enter\">（选填）</span></label>");
document.writeln("                  <span class=\"frm_input_box\">");
document.writeln("                      <input type=\"text\" class=\"frm_input frm_input_author\" max-length=\"8\">");
document.writeln("                      <!-- <em class=\"frm_counter zz\">0/8</em> -->");
document.writeln("                  </span>");
document.writeln("                  <div class=\"frm_msg fail js_title_error\" style=\"display: none;\">标题不能为空且长度不能超过64字</div>");
document.writeln("          </div>");
document.writeln("          <div class=\"appmsg_edit_item fm_h\">");
document.writeln("            <label for=\"\" class=\"frm_label\">封面<span class=\"sl_enter\">（大图片建议尺寸：900像素 * 500像素）</span></label>");
document.writeln("                  ");
document.writeln("");
document.writeln("                  <div id=\"codeImgBox\" style=\"margin:15px 0;\">");
document.writeln("                      <img id=\"codeImg\" src=\"\" style=\"width:100px;height:75px;margin-left:8px;z-index:999;\"><a href=\"javascript:;\" class=\"delete_img\">删除</a>");
document.writeln("                  </div>");
document.writeln("");
document.writeln("                  <div class=\"frm_msg fail js_title_error\" style=\"display: none;\">标题不能为空且长度不能超过64字</div>");
document.writeln("          </div>");
document.writeln("          <!-- 多图文btn -->");
document.writeln("          <button class=\"btn\" id=\"btn1\">从图片库选择</button>          ");
document.writeln("");
document.writeln("          <div class=\"appmsg_edit_item zz_h\">");
document.writeln("            <label for=\"\" class=\"frm_label\">原文链接<span class=\"sl_enter\">（选填）</span></label>");
document.writeln("                  <span class=\"frm_input_box\">");
document.writeln("                      <input type=\"text\" class=\"frm_input frm_input_link\">   ");
document.writeln("                  </span>");
document.writeln("                  <div class=\"frm_msg fail js_title_error\" style=\"display: none;\">标题不能为空且长度不能超过64字</div>");
document.writeln("          </div>");
document.writeln("        </div>");
document.writeln("");



document.writeln("        <div class=\"edit_area_s appmsgItem\">");
document.writeln("          <div class=\"appmsg_edit_item bt_h\">");
document.writeln("            <label for=\"\" class=\"frm_label\">标题</label>");
document.writeln("                  <span class=\"frm_input_box\">");
document.writeln("                      <input type=\"text\" class=\"frm_input frm_input_tit\" id=\"title_txt\" value=\"\" max-length=\"64\">");
document.writeln("                      <!-- <em class=\"frm_counter\">0/64</em> -->");
document.writeln("                  </span>");
document.writeln("                  <div class=\"frm_msg fail js_title_error\" style=\"display: none;\">标题不能为空且长度不能超过64字</div>");
document.writeln("          </div>");
document.writeln("          <div class=\"appmsg_edit_item zz_h\">");
document.writeln("            <label for=\"\" class=\"frm_label\">作者<span class=\"sl_enter\">（选填）</span></label>");
document.writeln("                  <span class=\"frm_input_box\">");
document.writeln("                      <input type=\"text\" class=\"frm_input frm_input_author\" max-length=\"8\">");
document.writeln("                      <!-- <em class=\"frm_counter zz\">0/8</em> -->");
document.writeln("                  </span>");
document.writeln("                  <div class=\"frm_msg fail js_title_error\" style=\"display: none;\">标题不能为空且长度不能超过64字</div>");
document.writeln("          </div>");
document.writeln("          <div class=\"appmsg_edit_item fm_h_s\">");
document.writeln("            <label for=\"\" class=\"frm_label\">封面<span class=\"sl_enter\">（大图片建议尺寸：200像素 * 200像素）</span></label>");
document.writeln("                  <div id=\"codeImgBox\" style='margin: 15px 0'>");
document.writeln("                          <img id=\"codeImg\" src=\"\" style=\"width:100px;height:75px;margin-left:8px;z-index:999;\"><a href=\"javascript:;\" class=\"delete_img_s\">删除</a>");
document.writeln("                      </div>");
document.writeln("                  <div class=\"frm_msg fail js_title_error\" style=\"display: none;\">标题不能为空且长度不能超过64字</div>");
document.writeln("          </div>");
document.writeln("");
document.writeln("          <button class=\"btn\" id=\"btn11\">从图片库选择</button>");
document.writeln("          ");
document.writeln("          <div class=\"appmsg_edit_item zz_h\">");
document.writeln("            <label for=\"\" class=\"frm_label\">原文链接<span class=\"sl_enter\">（选填）</span></label>");
document.writeln("                  <span class=\"frm_input_box\">");
document.writeln("                      <input type=\"text\" class=\"frm_input frm_input_link\">   ");
document.writeln("                  </span>");
document.writeln("                  <div class=\"frm_msg fail js_title_error\" style=\"display: none;\">标题不能为空且长度不能超过64字</div>");
document.writeln("          </div>");
document.writeln("        </div>");






document.writeln("");
document.writeln(" ");
document.writeln("  </div>");
document.writeln("");
document.writeln("					");
document.writeln("<button class=\"wx_edit_dabble am-btn am-btn-primary\">保存</button>");
document.writeln("				</div>");

document.writeln("			</div>");
document.writeln("		</div>");
document.writeln('<button id="AMalert" style="display: none" data-am-modal="{target: \'#my-alert\'}" ></button>' +
'<div class="am-modal am-modal-alert" tabindex="-1" id="my-alert">' +
'<div class="am-modal-dialog">' +
'<div class="am-modal-bd">' +
'保存成功' +
'</div>' +
'<div class="am-modal-footer">' +
'<span class="am-modal-btn">确定</span>' +
'</div>' +
'</div>' +
'</div>');