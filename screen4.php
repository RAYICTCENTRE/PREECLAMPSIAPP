<?php
session_start();
include "db_connect.php";

// Ensure user is logged in
if(!isset($_SESSION['user_id'])){
    header("Location: screen2.html");
    exit();
}

$user_id = $_SESSION['user_id'];

// --------------------
// FETCH USER DATA
$user = [];
$stmt = $conn->prepare("SELECT firstname, lastname, email, phone FROM users WHERE id=?");
$stmt->bind_param("i", $user_id);
$stmt->execute();
$res = $stmt->get_result();
$user = $res->fetch_assoc() ?? [];

// --------------------
// FETCH PROFILE DATA
$profile = [];
$stmt2 = $conn->prepare("SELECT * FROM user_profiles WHERE user_id=?");
$stmt2->bind_param("i", $user_id);
$stmt2->execute();
$res2 = $stmt2->get_result();
$profile = $res2->fetch_assoc() ?? [];

// --------------------
// SAFE VALUES (NO ERRORS)
function val($arr, $key){
    return htmlspecialchars($arr[$key] ?? '');
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Profile Setup</title>

<style>
body { background:#E0FFFF; font-family:Arial; padding:15px; }

.profile-container {
    background:#FFFACD;
    padding:20px;
    border-radius:10px;
    max-width:700px;
    margin:auto;
}

h1 { text-align:center; color:#4B0082; }

.form-row {
    display:flex;
    flex-wrap:wrap;
    gap:10px;
    margin-bottom:12px;
    align-items:center;
}

label { width:35%; font-weight:bold; }

input, select {
    width:65%;
    max-width:400px;
    padding:8px;
    border-radius:5px;
    border:1px solid #ccc;
}

.contact-row {
    display:flex;
    gap:8px;
    width:65%;
}

.contact-row select { width:35%; }
.contact-row input { width:65%; }

/* Progress */
.progress {
    background:#ddd;
    height:20px;
    border-radius:10px;
    margin-bottom:15px;
}

.progress-bar {
    height:100%;
    background:#4CAF50;
    border-radius:10px;
    text-align:center;
    color:white;
    line-height:20px;
    font-size:12px;
}

/* Buttons */
.button-group {
    display:flex;
    flex-wrap:wrap;
    gap:10px;
    margin-top:15px;
}

button {
    flex:1;
    padding:12px;
    border:none;
    border-radius:6px;
    background:#4CAF50;
    color:white;
    cursor:pointer;
    font-size:14px;
}

button:hover { background:#45a049; }

#clear-btn { background:orange; }
#cancel-btn { background:red; }

/* MOBILE */
@media (max-width:600px){
    .form-row { flex-direction:column; align-items:flex-start; }
    label { width:100%; }
    input, select { width:100%; max-width:100%; }
    .contact-row { width:100%; }
}
</style>
</head>

<body>

<div class="profile-container">

<h1>Profile Setup</h1>

<!-- PROGRESS -->
<div class="progress">
<div class="progress-bar" id="progressBar">0%</div>
</div>

<form id="profileForm" action="save_profile.php" method="POST">

<h3>Basic Info</h3>

<div class="form-row">
<label>First Name:</label>
<input type="text" value="<?= val($user,'firstname') ?>" readonly>
</div>

<div class="form-row">
<label>Last Name:</label>
<input type="text" name="lastname" value="<?= val($user,'lastname') ?>">
</div>

<div class="form-row">
<label>Phone:</label>
<input type="text" name="phone" value="<?= val($user,'phone') ?>">
</div>

<div class="form-row">
<label>Email:</label>
<input type="text" value="<?= val($user,'email') ?>" readonly>
</div>

<h3>Address</h3>

<div class="form-row"><label>Nationality:</label>
<input type="text" name="nationality" value="<?= val($profile,'nationality') ?>"></div>

<div class="form-row"><label>District:</label>
<input type="text" name="district" value="<?= val($profile,'district') ?>"></div>

<div class="form-row"><label>Sub County:</label>
<input type="text" name="subCounty" value="<?= val($profile,'sub_county') ?>"></div>

<div class="form-row"><label>Parish:</label>
<input type="text" name="parish" value="<?= val($profile,'parish') ?>"></div>

<div class="form-row"><label>Village:</label>
<input type="text" name="village" value="<?= val($profile,'village') ?>"></div>

<div class="form-row"><label>Nearest Health:</label>
<input type="text" name="nearestHealth" value="<?= val($profile,'nearest_health') ?>"></div>

<h3>Next of Kin</h3>

<div class="form-row"><label>Name:</label>
<input type="text" name="kinName" value="<?= val($profile,'kin_name') ?>"></div>

<div class="form-row"><label>Relationship:</label>
<input type="text" name="kinRelationship" value="<?= val($profile,'kin_relationship') ?>"></div>

<div class="form-row">
<label>Contact:</label>
<div class="contact-row">
<select name="countryCode">
<option value="+256">+256</option>
<option value="+254">+254</option>
<option value="+255">+255</option>
</select>
<input type="text" name="kinContact" value="<?= val($profile,'kin_contact') ?>">
</div>
</div>

<h3>Other</h3>

<div class="form-row">
<label>DOB:</label>
<input type="date" name="dob" value="<?= val($profile,'dob') ?>">
</div>

<div class="form-row">
<label>Last Period:</label>
<input type="date" id="lastPeriod" name="lastPeriod" value="<?= val($profile,'last_period') ?>">
</div>

<div class="form-row">
<label>Expected Delivery:</label>
<input type="date" id="expectedDelivery" name="expectedDelivery" value="<?= val($profile,'expected_delivery') ?>" readonly>
</div>

<!-- BUTTONS -->
<div class="button-group">
<button type="submit">Save Profile</button>
<button type="button" id="clear-btn">Clear</button>
<button type="button" id="cancel-btn">Cancel</button>
</div>

</form>
</div>

<script>
const form = document.getElementById('profileForm');
const progressBar = document.getElementById('progressBar');

// Calculate EDD
document.getElementById("lastPeriod").addEventListener("change", function () {
    const d = new Date(this.value);
    d.setDate(d.getDate()+280);
    document.getElementById("expectedDelivery").value = d.toISOString().split('T')[0];
    updateProgress();
});

// Clear
document.getElementById('clear-btn').onclick = () => {
    form.reset();
    updateProgress();
};

// Cancel → LOGIN
document.getElementById('cancel-btn').onclick = () => {
    window.location.href='screen2.html';
};

// Progress calculation
function updateProgress(){
    const inputs = form.querySelectorAll('input, select');
    let filled = 0;

    inputs.forEach(i=>{
        if(i.value && i.type !== "hidden") filled++;
    });

    const percent = Math.round((filled/inputs.length)*100);
    progressBar.style.width = percent + '%';
    progressBar.textContent = percent + '%';
}

// Listen changes
form.querySelectorAll('input, select').forEach(i=>{
    i.addEventListener('input', updateProgress);
    i.addEventListener('change', updateProgress);
});

// Initial run
updateProgress();
</script>

</body>
</html>