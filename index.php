<?php
session_start();
include_once 'dbconnect.php';
?>
<!DOCTYPE html>
<html>
<head>
	<title>Home | GPS Tracker</title>
	<meta content="width=device-width, initial-scale=1.0" name="viewport" >
	<link rel="stylesheet" href="css/bootstrap.min.css" type="text/css" />
	<meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script src="//code.jquery.com/jquery-1.11.1.min.js"></script>
    <script src="//maps.google.com/maps/api/js?v=3&sensor=false&libraries=adsense"></script>
    <script src="js/maps.js"></script>
    <script src="js/leaflet-0.7.5/leaflet.js"></script>
    <script src="js/leaflet-plugins/google.js"></script>
    <script src="js/leaflet-plugins/bing.js"></script>
	<link rel="stylesheet" href="js/leaflet-0.7.5/leaflet.css">    
</head>
<body>

<nav class="navbar navbar-default" role="navigation">
	<div class="container-fluid">	
		<div class="navbar-header">		
			<button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#navbar1">
				<span class="sr-only">Toggle navigation</span>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
			</button>
			<img id="halimage" src="images/gpstracker-man-blue-37.png">
			<a class="navbar-brand" href="index.php">GPS Tracker</a>
		</div>
		<div class="collapse navbar-collapse" id="navbar1">
			<ul class="nav navbar-nav navbar-right">
				<?php if (isset($_SESSION['usr_id'])) { ?>
				<p class="navbar-text" id="messages"></p>
				<li><p class="navbar-text">Signed in as <?php echo $_SESSION['usr_name']; ?></p></li>
				<li><a href="logout.php">Log Out</a></li>
				<?php } else { ?>
				<li><a href="login.php">Login</a></li>
				<li><a href="register.php">Sign Up</a></li>
				<?php } ?>
			</ul>
		</div>
	</div>
</nav>
	
	
<?php if (isset($_SESSION['usr_id'])) {	?>	
	<link rel="stylesheet" href="css/styles.css">
	    <div class="container-fluid">

        <div class="row">
            <div class="col-sm-10" id="mapdiv">
                <div id="map-canvas"></div>
            </div>
			<div class="col-sm-2">
				<div class="row">
					<input type="button" id="delete" value="Delete" tabindex="2" class="btn btn-primary">
				</div>
				<div class="row">
					<input type="button" id="autorefresh" value="Auto Refresh Off" tabindex="3" class="btn btn-primary">
				</div>
				<div class="row">
					<input type="button" id="refresh" value="Refresh" tabindex="4" class="btn btn-primary">
				</div>
				<div class="row">
					<input type="button" id="viewall" value="View All" tabindex="5" class="btn btn-primary">
				</div>				
				
			</div>
        </div>
        <div class="row">
            <div class="col-sm-10" id="selectdiv">
                <select id="routeSelect" tabindex="1"></select>
            </div>
        </div>
		<!--
        <div class="row">
            <div class="col-sm-3 deletediv">
                <input type="button" id="delete" value="Delete" tabindex="2" class="btn btn-primary">
            </div>
            <div class="col-sm-3 autorefreshdiv">
                <input type="button" id="autorefresh" value="Auto Refresh Off" tabindex="3" class="btn btn-primary">
            </div>
            <div class="col-sm-3 refreshdiv">
                <input type="button" id="refresh" value="Refresh" tabindex="4" class="btn btn-primary">
            </div>
            <div class="col-sm-3 viewalldiv">
                <input type="button" id="viewall" value="View All" tabindex="5" class="btn btn-primary">
            </div>
        </div>
		-->
    </div>  
<?php } else {	?>
		<div class="container-fluid">
			<div class="col-sm-12">
				<center> You need to <a href="login.php">login</a> first to use the system </center>
			</div>
			<div class="col-sm-12">
		 		<center><img id="halimage" src="images/gpstracker.png" style="width:256px;height:256px;"> </center>
			</div>
		</div>
<?php } ?>
	
<script src="js/jquery-1.10.2.js"></script>
<script src="js/bootstrap.min.js"></script>
 
	
</body>
</html>

