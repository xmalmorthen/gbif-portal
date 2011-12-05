
	var map,
      points_layer,
      occurrence_layer,
			diversity_layer,
      distribution_layer,
			features,
			state;
			
			// Necessary things to run these kind of map
			// - class typesmap to body
			// - occurrence/diversity/distribution/points 'a' tags have to be -> <a href="#" title="occurrence">grid</a> -> respect the title, you can change the text
			// - zooms html (example in /content/dataset/detail.html)


	$(function(){
		// If body has typesmap class - search #map and start rendering map
		if ($('body').hasClass('typesmap')) {
	
			// Create zoom controls
			$('a.zoom_in').click(function(ev){
				ev.stopPropagation();
				ev.preventDefault();
				map.zoomIn();					
			});
			$('a.zoom_out').click(function(ev){
				ev.stopPropagation();
				ev.preventDefault();
				map.zoomOut();
			});
			
			//Projection buttons
			$('div.projection a.projection').click(function(ev){
				ev.stopPropagation();
				ev.preventDefault();
				$(this).parent().find('span').show();
				$('body').click(function(ev){
					if (!$(event.target).closest('div.projection').length) {
	          $('div.projection span').hide();
	          $('body').unbind('click');
	        };
				});
			});
			
			$('div.projection span ul li a').click(function(ev){
				ev.stopPropagation();
				ev.preventDefault();
				if (!$(this).parent().hasClass('disabled') && !$(this).hasClass('selected')) {
					$('div.projection span ul li a').each(function(i,ele){$(ele).removeClass('selected')});
					$(this).addClass('selected');
					// TODO -> implement robinson projection
					$(this).closest('span').hide()
					$('body').unbind('click');					
				}
			});
			
			
			
		
			// Change map type
			$('p.maptype a').click(function(ev){
				ev.stopPropagation();
				ev.preventDefault();
				var type_ = $(this).attr('title');
				$('p.maptype a').each(function(i,ele){
					$(ele).removeClass('selected');
				});
				$(this).addClass('selected');
				chooseLayer(type_);
			});
			
			

			// Initialize map
			map = new OpenLayers.Map('map', {controls: [],numZoomLevels: 20});

			// Activate double click
			var dblclick = new OpenLayers.Handler.Click(this, {dblclick: function() {map.zoomIn()}, click: null }, {single: true, 'double': true, stopSingle: false, stopDouble: true});
	    dblclick.setMap(map);
	    dblclick.activate();

			// Drag with mouse
			map.addControl(new OpenLayers.Control.Navigation({zoomWheelEnabled : false}));
			map.addControl(new OpenLayers.Control.MousePosition({element: $('#map')}));

			// Tiles
	    var ol_wms = new OpenLayers.Layer.WMS("OpenLayers WMS","http://vmap0.tiles.osgeo.org/wms/vmap0",{layers: 'basic'});
			map.addLayers([ol_wms]);
			map.setCenter(new OpenLayers.LonLat(0, 0), 3);
		
			// First of all, we need all the data: points, polygons paths and grid layer.
			setUpLayers($("#map").attr("nubid"));
		}
	});


	function setUpLayers(nubId) {

		// Create occurrence tiles layer
 		occurrence_layer = new OpenLayers.Layer.XYZ("EOL","http://140.247.231.188/php/map/getEolTile.php?tile=${x}_${y}_${z}_"+nubId);

		// TODO: create distribution_layer, random polygons for now
		var polygon1 = new OpenLayers.Geometry.LinearRing([new OpenLayers.Geometry.Point(10,20), new OpenLayers.Geometry.Point(40,20), new OpenLayers.Geometry.Point(40,40), new OpenLayers.Geometry.Point(10,40)]);
		var polygon2 = new OpenLayers.Geometry.LinearRing([new OpenLayers.Geometry.Point(-20,0), new OpenLayers.Geometry.Point(-20,5), new OpenLayers.Geometry.Point(0,5), new OpenLayers.Geometry.Point(0,0)]);
		var polygon3 = new OpenLayers.Geometry.LinearRing([new OpenLayers.Geometry.Point(20,0), new OpenLayers.Geometry.Point(20,5), new OpenLayers.Geometry.Point(25,5), new OpenLayers.Geometry.Point(25,0)]);

		var polygonFeature1 = new OpenLayers.Feature.Vector(polygon1, null, polygon_style);
		var polygonFeature2 = new OpenLayers.Feature.Vector(polygon2, null, polygon_style);
		var polygonFeature3 = new OpenLayers.Feature.Vector(polygon3, null, polygon_style);

		distribution_layer = new OpenLayers.Layer.Vector("Polygons Layer");
		distribution_layer.addFeatures([polygonFeature1, polygonFeature2, polygonFeature3]);

		// TODO: create points_layer
		// several random points for the markers
		var dx = 9;
	  var dy = 9;
	  var px, py;
	  features = [];
	  for(var x=-45; x<=45; x+=dx) {
	    for(var y=-22.5; y<=22.5; y+=dy) {
	      px = x + (2 * dx * (Math.random() - 0.5));
	      py = y + (2 * dy * (Math.random() - 0.5));
				features.push(new OpenLayers.Feature.Vector(new OpenLayers.Geometry.Point(px, py)));
	    }
	  }

		// TODO: create diversity_layer
    // use occurrence map for now
    diversity_layer = new OpenLayers.Layer.XYZ("EOL","http://140.247.231.188/php/map/getEolTile.php?tile=${x}_${y}_${z}_"+nubId);

		// Select the correct map type with .selected class
		var type_ = $('p.maptype').find('a.selected').attr('title');
		chooseLayer(type_);
	}



	function chooseLayer(layer) {
		if (layer!=state) {
      if (state=="occurrence") {map.removeLayer(occurrence_layer);}
			if (state=="diversity") {map.removeLayer(diversity_layer);	}
			if (state=="distribution") {map.removeLayer(distribution_layer);}
      if (state=="points") {map.removeLayer(points_layer);}

      if (layer=="occurrence") {map.addLayer(occurrence_layer);  state = 'occurrence'; 		return false;}
			if (layer=="diversity") {map.addLayer(diversity_layer); state = 'diversity'; 	return false;}
			if (layer=="distribution") {map.addLayer(distribution_layer);  state = 'distribution'; return false;}
      if (layer=="points") {map.addLayer(points_layer);  state = 'points'; 		return false;}
		}
	}


