<?php
    session_start();
    echo json_encode($_SESSION['usr_name']);
?>