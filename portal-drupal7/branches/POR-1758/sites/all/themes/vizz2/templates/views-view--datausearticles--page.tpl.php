<?php

/**
 * @file
 * Main view template.
 *
 * Variables available:
 * - $classes_array: An array of classes determined in
 *	 template_preprocess_views_view(). Default classes are:
 *		 .view
 *		 .view-[css_name]
 *		 .view-id-[view_name]
 *		 .view-display-id-[display_name]
 *		 .view-dom-id-[dom_id]
 * - $classes: A string version of $classes_array for use in the class attribute
 * - $css_name: A css-safe version of the view name.
 * - $css_class: The user-specified classes names, if any
 * - $header: The view header
 * - $footer: The view footer
 * - $rows: The results of the view query, if any
 * - $empty: The empty text to display if the view is empty
 * - $pager: The pager next/prev links to display, if any
 * - $exposed: Exposed widget form/info to display
 * - $feed_icon: Feed icon to display, if any
 * - $more: A link to view more, if any
 *
 * @ingroup views_templates
 */
?>
<?php 
	global $user;
	global $base_url ;
	global $base_path ;
	$dataportal_base_url = theme_get_setting( 'vizz2_dataportal_base_url','vizz2' ) ;
	$taxon = get_title_data() ;
?>
	<article class="results light_pane">
		<header></header>
		<div class="content">
		<div class="header">
			<div class="left"><h2>All featured data uses</h2></div>
			<div class="right"><h3>Filter by subject</h3></div>
		</div>
			<div class="left">
			<?php print $rows ; ?>
			<?php print $pager?>
			</div>
			<div class="right">
        <ul class="no_bullets">
          <li><a href="<?php print $base_url ?>/taxonomy/term/635">Invasives</a></li>
          <li><a href="<?php print $base_url ?>/taxonomy/term/639">Climate change</a></li>
          <li><a href="<?php print $base_url ?>/taxonomy/term/638">Conservation</a></li>
          <li><a href="<?php print $base_url ?>/taxonomy/term/636">Agriculture</a></li>
          <li><a href="<?php print $base_url ?>/taxonomy/term/637">Human health</a></li>
          <li><a href="<?php print $base_url ?>/taxonomy/term/640">Species distributions</a></li>
        </ul>
			</div>
		</div>
		<footer></footer>
	</article>