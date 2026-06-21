<?php
session_start();
$conn = new mysqli("localhost","root","","mothercare");

$message_id = intval($_POST['message_id'] ?? 0);
$new_msg = trim($_POST['message'] ?? '');
$patient_id = $_SESSION['user_id'];

if(!$message_id || !$new_msg){
    echo json_encode(["success"=>false,"message"=>"Invalid input"]);
    exit();
}

$stmt = $conn->prepare("UPDATE chat_messages SET message=? WHERE id=? AND patient_id=?");
$stmt->bind_param("sis",$new_msg, $message_id, $patient_id);
$stmt->execute();

echo json_encode(["success"=>true,"message"=>"Message updated"]);
?>