
<div class="am-cf am-padding">
    <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">视频管理</strong> / <small>总计 <?php echo $videos['count'];?> 篇</small></div>
</div>

<div class="am-g am-padding">
  <div class="am-fl am-cf">
    <a  href="?_a=site&_u=sp.addvideo" type="button" class="am-btn am-btn-success"><span class="am-icon-plus"></span> 添加视频</a>
  </div>  
</div>

<table class="am-table am-table-striped am-table-hover table-main">
  <thead>
    <tr>
      <th class="table-check">
        <input type="checkbox" class="vcheckall">
        <a href="javascript:;" class="am-text-danger am-text-lg vdeleteall" style="margin-left:10px;"><span class="am-icon-trash"></span></a>
      </th>
      <th class="table-title">视频图片</th>
      <th class="table-parent">视频描述</th>
      <th class="table-image">视频地址</th>
      <th class="table-order">排序</th>
      <th class="table-time">编辑时间</th>
      <th class="table-status">状态</th>
      <th class="table-set">操作</th>
    </tr>
  </thead>
  <tbody>
  <?php
    if(empty($videos['list'])){
      echo '<tr class="am-danger"><td>暂无数据！</td></tr>';
    }else{
      $html = '';
      foreach ($videos['list'] as $v) {
        $html .= '<tr';
        if($v['status']){
          $html .= ' class="am-danger wrap_video"';
        }else{
          $html .= ' class="wrap_video"';
        }
        $html .= 'data-id="'.$v['uid'].'"><td><input type="checkbox" class="check_video" /></td><td><img width="100" height="100" src="'.$v['image'].'" /></td><td style="width:150px;">'.$v['describle'].'</td><td>'.substr($v['address'],0,20)."...".'</td>     <td>'.$v['sort'].'</td><td>'.date('Y-m-d H:i:s', $v['create_time']).'</td>
        <td>'.($v['status'] ? '<a data-status="'.$v['status'].'" class="vstatus am-btn am-btn-xs am-btn-danger">已禁用</a>':
          '<a data-status="'.$v['status'].'" class="vstatus am-btn am-btn-xs am-btn-success">已显示</a>').'</td>      <td><a href="?_a=site&_u=sp.addvideo&uid='.$v['uid'].'" target="_blank" class="am-btn am-btn-default am-btn-xs am-text-primary"><span class="am-icon-trash-o"></span> 编辑</a><button class="am-btn am-btn-default am-btn-xs am-text-danger delete_video" name="'.$v['uid'].'"><span class="am-icon-trash-o"></span> 删除</button></td><tr>';
      }
      echo $html;
    }
  ?>
  </tbody>
</table>  


<div class="am-u-sm-12">
<?php
  echo $pagination;
?>
</div>
<?php
        $extra_js =  array( 
          '/app/site/static/js/video.js',
    );
?>


