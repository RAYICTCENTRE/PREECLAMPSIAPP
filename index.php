<?php
// Redirect to login or dashboard based on session
session_start();

// If user is logged in, go to dashboard
if (isset($_SESSION['user_id'])) {
    header('Location: templates/dashboard.php');
    exit;
} else {
    // Otherwise go to login
    header('Location: templates/login.php');
    exit;
}
?>