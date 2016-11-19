<?php
    include 'dbconnect.php';

    $username   =  isset($_GET['_username']) ? $_GET['_username'] : '0';

    switch ($dbType) {
        case DB_MYSQL:
            $stmt = $pdo->prepare('CALL prcGetRoutes(:username)');
            break;
    }
    $stmt->bindParam(':username', $username);
    $stmt->execute();

    $json = '{ "routes": [';

    foreach ($stmt as $row) {
        $json .= $row['json'];
        $json .= ',';
    }
   
    $json = rtrim($json, ",");
    $json .= '] }';

    header('Content-Type: application/json');
    echo $json;
    
?>
