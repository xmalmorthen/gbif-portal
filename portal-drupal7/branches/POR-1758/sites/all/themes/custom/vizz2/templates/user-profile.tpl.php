<?php
global $user;
global $base_url ;
global $base_path ;
$dataportal_base_url = theme_get_setting( 'vizz2_dataportal_base_url','vizz2' ) ;
?>
    <div class="content">
    <br/>
	<?php if ($logged_in) { ?>
		<div class="header">
			<div class="left">
				<h2>Your GBIF Account</h2>
			</div>
		</div>    
	<?php } ?>
		
	<?php // print $messages ?>
     
			
	<div class="left">
		<?php if ($user->name) { ?>

		<a href="<?php print $base_url;?>/user/<?php print ($user->uid) ?>/edit">... edit your GBIF account</a>

		<?php } ?>

		<br/>
		<br/>

		<?php print render($user_profile); ?>
				<br/>
		<br/>

	</div>
	</div>


