<?php
    include 'dbconnect.php';
    
    $sessionid   = isset($_GET['sessionid']) ? $_GET['sessionid'] : '0';

    switch ($dbType) {
        case DB_MYSQL:
            $stmt = $pdo->prepare($sqlFunctionCallMethod.'prcDeleteRoute(:sessionID)');     
            break;
    }

    $stmt->execute(array(':sessionID' => $sessionid));

?>
