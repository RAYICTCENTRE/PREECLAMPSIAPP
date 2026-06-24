<?php
header('Content-Type: application/json');
echo json_encode([
    'status' => 'OK',
    'message' => 'Preeclampsia App is running',
    'timestamp' => date('Y-m-d H:i:s')
]);
?>