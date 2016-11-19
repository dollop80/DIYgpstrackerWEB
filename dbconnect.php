<?php
const DB_MYSQL = 0;
$dbType = DB_MYSQL;
//connect to mysql database
$con = mysqli_connect("localhost", "user", "password", "tracker_database") or die("Error " . mysqli_error($con));

$dbuser = 'user';
$dbpass = 'password';

$params = array(PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION, 
                PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC);

switch ($dbType) {
    case DB_MYSQL:
        $pdo = new PDO('mysql:host=localhost;dbname=tracker_database;charset=utf8', $dbuser, $dbpass, $params);
        $sqlFunctionCallMethod = 'CALL ';
        break;
}
?>