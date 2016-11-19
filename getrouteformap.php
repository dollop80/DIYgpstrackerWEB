<?php
    include 'dbconnect.php';
    
    $sessionid   = isset($_GET['sessionid']) ? $_GET['sessionid'] : '0';

    switch ($dbType) {
        case DB_MYSQL:
            $stmt = $pdo->prepare('CALL prcGetRouteForMap(:sessionID)');     
            break;
    }

    $stmt->execute(array(':sessionID' => $sessionid));
    
    $json = '{ "locations": [';

    foreach ($stmt as $row) {
        $json .= $row['json'];
        $json .= ',';
    }

    $json = rtrim($json, ",");
    $json .= '] }';

    header('Content-Type: application/json');
    echo $json;

?>