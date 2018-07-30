<?php
uct_use_app('su');
$su_uid = SuMod::require_su_uid();
if(!empty($su_uid))
	redirectTo('?_a=shop&_u=user');