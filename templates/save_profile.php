<?php
session_start();

// Redirect if not logged in
if (!isset($_SESSION['user_id'])) {
    header("Location: screen2.html");
    exit();
}

$conn = new mysqli("localhost", "root", "", "mothercare");
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

$user_id = $_SESSION['user_id'];

// ========== GET FORM DATA ==========
// Phone number (goes to users table)
$phone_country_code = $_POST['phoneCountryCode'] ?? '+256';
$phone_number = $_POST['phone'] ?? '';
$full_phone = $phone_country_code . $phone_number;

// Profile data (goes to user_profiles table)
$age = !empty($_POST['age']) ? intval($_POST['age']) : null;
$nationality = $_POST['nationality'] ?? '';
$district = $_POST['district'] ?? '';
$sub_county = $_POST['subCounty'] ?? '';
$parish = $_POST['parish'] ?? '';
$village = $_POST['village'] ?? '';
$nearest_health = $_POST['nearestHealth'] ?? '';
$kin_name = $_POST['kinName'] ?? '';
$kin_relationship = $_POST['kinRelationship'] ?? '';
$kin_country_code = $_POST['kinCountryCode'] ?? '+256';
$kin_contact = $_POST['kinContact'] ?? '';
$full_kin_contact = $kin_country_code . $kin_contact;
$last_period = $_POST['lastPeriod'] ?? null;
$expected_delivery = $_POST['expectedDelivery'] ?? null;

// ========== 1. UPDATE USERS TABLE (PHONE NUMBER) ==========
if (!empty($phone_number)) {
    $update_user = $conn->prepare("UPDATE users SET phone = ? WHERE id = ?");
    $update_user->bind_param("si", $full_phone, $user_id);
    $update_user->execute();
    $update_user->close();
}

// ========== 2. CHECK IF PROFILE EXISTS IN USER_PROFILES ==========
$check = $conn->prepare("SELECT id FROM user_profiles WHERE user_id = ?");
$check->bind_param("i", $user_id);
$check->execute();
$result = $check->get_result();
$profile_exists = $result->num_rows > 0;
$check->close();

// ========== 3. SAVE/UPDATE USER_PROFILES TABLE ==========
if ($profile_exists) {
    // UPDATE existing profile
    $stmt = $conn->prepare("
        UPDATE user_profiles SET 
            age = ?, 
            nationality = ?, 
            district = ?, 
            sub_county = ?, 
            parish = ?, 
            village = ?, 
            nearest_health = ?,
            kin_name = ?, 
            kin_relationship = ?, 
            kin_contact = ?,
            kin_country_code = ?,
            last_period = ?, 
            expected_delivery = ?,
            updated_at = NOW()
        WHERE user_id = ?
    ");
    
    if ($stmt) {
        $stmt->bind_param("issssssssssssi", 
            $age, 
            $nationality, 
            $district, 
            $sub_county, 
            $parish, 
            $village, 
            $nearest_health,
            $kin_name, 
            $kin_relationship, 
            $full_kin_contact, 
            $kin_country_code,
            $last_period, 
            $expected_delivery, 
            $user_id
        );
        $stmt->execute();
        $stmt->close();
    }
} else {
    // INSERT new profile
    $stmt = $conn->prepare("
        INSERT INTO user_profiles (
            user_id, 
            age, 
            nationality, 
            district, 
            sub_county, 
            parish, 
            village, 
            nearest_health,
            kin_name, 
            kin_relationship, 
            kin_contact, 
            kin_country_code, 
            last_period, 
            expected_delivery
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    ");
    
    if ($stmt) {
        $stmt->bind_param("iissssssssssss", 
            $user_id, 
            $age, 
            $nationality, 
            $district, 
            $sub_county, 
            $parish, 
            $village, 
            $nearest_health,
            $kin_name, 
            $kin_relationship, 
            $full_kin_contact, 
            $kin_country_code, 
            $last_period, 
            $expected_delivery
        );
        $stmt->execute();
        $stmt->close();
    }
}

// ========== 4. REDIRECT BACK TO PROFILE PAGE ==========
header("Location: screen4.html");
exit();
?>