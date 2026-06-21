<?php
session_start();

// Check if user is logged in
if(!isset($_SESSION['user_id']) || strtolower($_SESSION['user_type']) !== 'client'){
    header("Location: screen1.html");
    exit();
}

// Database connection
$conn = new mysqli("localhost", "root", "", "mothercare");

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

$user_id = $_SESSION['user_id'];

// Get user details
$user_query = $conn->query("SELECT firstname, lastname, email, phone FROM users WHERE id = $user_id");
$user = $user_query->fetch_assoc();

// Get profile details
$profile_query = $conn->query("SELECT age, last_period, expected_delivery FROM user_profiles WHERE user_id = $user_id");
$profile = $profile_query->fetch_assoc();

// Get symptoms history
$symptoms_query = $conn->query("
    SELECT * FROM symptoms_records 
    WHERE user_id = $user_id 
    ORDER BY created_at DESC 
    LIMIT 10
");

// Get statistics
$total_visits = $conn->query("SELECT COUNT(*) as count FROM symptoms_records WHERE user_id = $user_id")->fetch_assoc()['count'];

// Calculate average risk
$risk_avg = $conn->query("
    SELECT AVG(risk) as avg_risk, COUNT(*) as count 
    FROM symptoms_records 
    WHERE user_id = $user_id AND risk IS NOT NULL
")->fetch_assoc();

$avg_risk = $risk_avg['avg_risk'] ? number_format($risk_avg['avg_risk'], 1) : 'No Data';
$risk_count = $risk_avg['count'] ?? 0;

// Get latest risk level
$latest = $conn->query("
    SELECT risk_level, created_at, risk 
    FROM symptoms_records 
    WHERE user_id = $user_id 
    ORDER BY created_at DESC 
    LIMIT 1
")->fetch_assoc();

$latest_risk = $latest['risk_level'] ?? 'No Data';
$latest_risk_color = 'gray';
if($latest_risk == 'Low') $latest_risk_color = '#2e7d32';
elseif($latest_risk == 'Moderate') $latest_risk_color = '#ffc107';
elseif($latest_risk == 'High') $latest_risk_color = '#fd7e14';
elseif($latest_risk == 'Critical') $latest_risk_color = '#dc3545';

// Get expected delivery date
$edd = $profile['expected_delivery'] ?? 'Not Set';
$edd_display = $edd !== 'Not Set' ? date('M d, Y', strtotime($edd)) : 'Not Set';

// Handle logout
if(isset($_GET['action']) && $_GET['action'] == 'logout'){
    session_destroy();
    header("Location: screen1.html");
    exit();
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MotherCare - Health Analytics</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
            background: #f5f7fb;
            display: flex;
            min-height: 100vh;
        }

        /* ========== LEFT SIDEBAR ========== */
        .sidebar {
            width: 280px;
            background: linear-gradient(180deg, #1a472a 0%, #0e2a1a 100%);
            color: white;
            display: flex;
            flex-direction: column;
            position: fixed;
            height: 100vh;
            overflow-y: auto;
            box-shadow: 2px 0 10px rgba(0,0,0,0.1);
        }

        .sidebar-header {
            padding: 30px 20px;
            text-align: center;
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }

        .sidebar-header h2 {
            font-size: 24px;
            margin-bottom: 5px;
        }

        .sidebar-header p {
            font-size: 12px;
            opacity: 0.7;
        }

        .sidebar-nav {
            flex: 1;
            padding: 20px 0;
        }

        .nav-item {
            padding: 12px 25px;
            margin: 5px 15px;
            border-radius: 12px;
            cursor: pointer;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            gap: 12px;
            text-decoration: none;
            color: white;
        }

        .nav-item i {
            width: 24px;
            font-size: 18px;
        }

        .nav-item:hover {
            background: rgba(255,255,255,0.1);
            transform: translateX(5px);
        }

        .nav-item.active {
            background: #2e7d32;
            color: white;
            box-shadow: 0 4px 12px rgba(46,125,50,0.3);
        }

        .stats-mini {
            padding: 20px;
            margin-top: auto;
            border-top: 1px solid rgba(255,255,255,0.1);
        }

        .stat-mini-item {
            display: flex;
            justify-content: space-between;
            margin-bottom: 12px;
            font-size: 13px;
        }

        /* ========== MAIN CONTENT ========== */
        .main-content {
            flex: 1;
            margin-left: 280px;
            padding: 25px 30px;
            overflow-y: auto;
        }

        .top-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
            background: white;
            padding: 15px 25px;
            border-radius: 15px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
        }

        .page-title h1 {
            font-size: 24px;
            color: #1a472a;
        }

        .user-info {
            display: flex;
            align-items: center;
            gap: 20px;
        }

        .session-timer {
            background: #f8f9fa;
            padding: 6px 14px;
            border-radius: 20px;
            font-size: 13px;
            display: flex;
            align-items: center;
            gap: 8px;
            color: #2c3e50;
        }

        .session-timer i {
            color: #2e7d32;
        }

        .session-timer.warning {
            background: #fff3cd;
            color: #856404;
            animation: pulse 1s ease-in-out infinite;
        }

        .session-timer.danger {
            background: #f8d7da;
            color: #721c24;
            animation: pulse 0.5s ease-in-out infinite;
        }

        @keyframes pulse {
            0%, 100% { opacity: 1; }
            50% { opacity: 0.6; }
        }

        .btn-logout {
            background: #dc3545;
            color: white;
            padding: 8px 20px;
            border-radius: 8px;
            text-decoration: none;
            transition: all 0.3s;
            border: none;
            cursor: pointer;
            font-size: 14px;
        }

        .btn-logout:hover {
            background: #c82333;
        }

        .welcome-badge {
            background: #2e7d32;
            color: white;
            padding: 6px 15px;
            border-radius: 20px;
            font-size: 13px;
        }

        /* Stats Cards */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: white;
            padding: 20px;
            border-radius: 15px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
            transition: transform 0.3s;
            border-left: 4px solid #2e7d32;
        }

        .stat-card:hover {
            transform: translateY(-3px);
        }

        .stat-card .stat-icon {
            font-size: 32px;
            margin-bottom: 10px;
        }

        .stat-card .stat-number {
            font-size: 28px;
            font-weight: bold;
            color: #1a472a;
        }

        .stat-card .stat-label {
            color: #6c757d;
            font-size: 14px;
            margin-top: 5px;
        }

        /* Section */
        .section {
            background: white;
            border-radius: 15px;
            padding: 20px;
            margin-bottom: 30px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
        }

        .section h3 {
            margin-bottom: 15px;
            color: #1a472a;
            font-size: 18px;
            border-left: 4px solid #2e7d32;
            padding-left: 12px;
        }

        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }

        .section-header h3 {
            margin-bottom: 0;
        }

        .btn-view-all {
            color: #2e7d32;
            text-decoration: none;
            font-size: 14px;
            font-weight: 600;
        }

        .btn-view-all:hover {
            text-decoration: underline;
        }

        /* Table */
        .table-wrapper {
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ecf0f1;
        }

        th {
            background: #f8f9fa;
            font-weight: 600;
            color: #2c3e50;
        }

        tr:hover {
            background: #f8f9fa;
        }

        .badge {
            padding: 4px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }

        .badge-low { background: #d4edda; color: #155724; }
        .badge-moderate { background: #fff3cd; color: #856404; }
        .badge-high { background: #f8d7da; color: #721c24; }
        .badge-critical { background: #f8d7da; color: #dc3545; }

        .risk-dot {
            display: inline-block;
            width: 12px;
            height: 12px;
            border-radius: 50%;
            margin-right: 8px;
        }

        .risk-dot.low { background: #28a745; }
        .risk-dot.moderate { background: #ffc107; }
        .risk-dot.high { background: #fd7e14; }
        .risk-dot.critical { background: #dc3545; }

        /* Chart placeholders */
        .chart-container {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-top: 20px;
        }

        .chart-box {
            background: #f8f9fa;
            border-radius: 12px;
            padding: 20px;
            text-align: center;
            min-height: 200px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
        }

        .chart-box h4 {
            color: #2c3e50;
            margin-bottom: 10px;
        }

        .chart-box .chart-placeholder {
            width: 100%;
            max-width: 300px;
        }

        .chart-bar {
            display: flex;
            align-items: flex-end;
            justify-content: center;
            gap: 20px;
            height: 150px;
            padding-top: 20px;
        }

        .bar-item {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 5px;
        }

        .bar {
            width: 40px;
            border-radius: 4px 4px 0 0;
            transition: height 0.5s ease;
            min-height: 20px;
        }

        .bar-label {
            font-size: 12px;
            color: #6c757d;
        }

        .bar-value {
            font-size: 12px;
            font-weight: 600;
        }

        .risk-level-item {
            display: flex;
            justify-content: space-between;
            padding: 8px 0;
            border-bottom: 1px solid #ecf0f1;
        }

        .risk-level-item:last-child {
            border-bottom: none;
        }

        .empty-state {
            text-align: center;
            padding: 40px 20px;
            color: #6c757d;
        }

        .empty-state i {
            font-size: 48px;
            margin-bottom: 15px;
            color: #d1d5db;
        }

        /* Idle Warning Modal */
        .idle-modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.6);
            z-index: 9999;
            justify-content: center;
            align-items: center;
            animation: fadeIn 0.3s ease;
        }

        .idle-modal.show {
            display: flex;
        }

        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }

        .idle-modal-content {
            background: white;
            padding: 40px;
            border-radius: 20px;
            max-width: 400px;
            width: 90%;
            text-align: center;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            animation: slideUp 0.3s ease;
        }

        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .idle-modal-content i {
            font-size: 48px;
            color: #ff8c42;
            margin-bottom: 16px;
        }

        .idle-modal-content h2 {
            color: #2c3e50;
            margin-bottom: 10px;
        }

        .idle-modal-content p {
            color: #6c757d;
            margin-bottom: 20px;
            font-size: 14px;
        }

        .countdown-timer {
            font-size: 48px;
            font-weight: bold;
            color: #ff8c42;
            margin: 10px 0;
        }

        .btn-stay {
            background: #2e7d32;
            color: white;
            padding: 10px 30px;
            border: none;
            border-radius: 10px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            margin-right: 10px;
        }

        .btn-stay:hover {
            background: #1a472a;
            transform: scale(1.05);
        }

        .btn-logout-modal {
            background: #dc3545;
            color: white;
            padding: 10px 30px;
            border: none;
            border-radius: 10px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
        }

        .btn-logout-modal:hover {
            background: #c82333;
            transform: scale(1.05);
        }

        @media (max-width: 768px) {
            .sidebar {
                width: 80px;
            }
            .sidebar-header h2, .sidebar-header p, .nav-item span, .stats-mini {
                display: none;
            }
            .nav-item {
                justify-content: center;
            }
            .main-content {
                margin-left: 80px;
                padding: 15px;
            }
            .chart-container {
                grid-template-columns: 1fr;
            }
            .stats-grid {
                grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            }
        }
    </style>
</head>
<body>

<!-- IDLE WARNING MODAL -->
<div class="idle-modal" id="idleModal">
    <div class="idle-modal-content">
        <i class="fas fa-clock"></i>
        <h2>Session Expiring Soon</h2>
        <p>You have been inactive for a while. Your session will expire in:</p>
        <div class="countdown-timer" id="countdownTimer">60</div>
        <p style="font-size: 12px; color: #94a3b8;">seconds</p>
        <br>
        <button class="btn-stay" onclick="stayLoggedIn()">
            <i class="fas fa-check-circle"></i> Stay Logged In
        </button>
        <button class="btn-logout-modal" onclick="logoutNow()">
            <i class="fas fa-sign-out-alt"></i> Logout Now
        </button>
    </div>
</div>

<!-- LEFT SIDEBAR -->
<div class="sidebar">
    <div class="sidebar-header">
        <h2>🏥 MotherCare</h2>
        <p>Patient Portal</p>
    </div>
    
    <div class="sidebar-nav">
        <a href="dashboard.html" class="nav-item">
            <i class="fas fa-tachometer-alt"></i>
            <span>Dashboard</span>
        </a>
        <a href="screen6.html" class="nav-item">
            <i class="fas fa-stethoscope"></i>
            <span>Check Symptoms</span>
        </a>
        <a href="consult_doctor.php" class="nav-item">
            <i class="fas fa-user-md"></i>
            <span>Consult Doctor</span>
        </a>
        <a href="screen4.html" class="nav-item">
            <i class="fas fa-edit"></i>
            <span>Update Profile</span>
        </a>
        <a href="patient_dashboard.php" class="nav-item active">
            <i class="fas fa-chart-line"></i>
            <span>Health Analytics</span>
        </a>
    </div>
    
    <div class="stats-mini">
        <div class="stat-mini-item">
            <span><i class="fas fa-calendar-check"></i> Visits</span>
            <strong><?= $total_visits ?></strong>
        </div>
        <div class="stat-mini-item">
            <span><i class="fas fa-heartbeat"></i> Risk Level</span>
            <strong style="color: <?= $latest_risk_color ?>"><?= $latest_risk ?></strong>
        </div>
        <div class="stat-mini-item">
            <span><i class="fas fa-baby"></i> Due Date</span>
            <strong><?= $edd_display ?></strong>
        </div>
    </div>
</div>

<!-- MAIN CONTENT -->
<div class="main-content" id="mainContent">
    <div class="top-bar">
        <div class="page-title">
            <h1>📊 Health Analytics</h1>
        </div>
        <div class="user-info">
            <div class="session-timer" id="sessionTimer">
                <i class="fas fa-hourglass-half"></i>
                <span>Session: </span>
                <strong id="timerDisplay">5:00</strong>
            </div>
            <span class="welcome-badge"><i class="fas fa-user-circle"></i> <?= htmlspecialchars($user['firstname'] ?? 'Patient') ?></span>
            <a href="?action=logout" class="btn-logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
        </div>
    </div>

    <!-- Stats Cards -->
    <div class="stats-grid" id="overview">
        <div class="stat-card">
            <div class="stat-icon">📋</div>
            <div class="stat-number"><?= $total_visits ?></div>
            <div class="stat-label">Total Health Visits</div>
        </div>
        <div class="stat-card">
            <div class="stat-icon">⚠️</div>
            <div class="stat-number"><?= $avg_risk ?></div>
            <div class="stat-label">Average Risk Score</div>
        </div>
        <div class="stat-card">
            <div class="stat-icon">❤️</div>
            <div class="stat-number" style="color: <?= $latest_risk_color ?>"><?= $latest_risk ?></div>
            <div class="stat-label">Latest Risk Level</div>
        </div>
        <div class="stat-card">
            <div class="stat-icon">👶</div>
            <div class="stat-number"><?= $edd_display ?></div>
            <div class="stat-label">Expected Delivery</div>
        </div>
    </div>

    <!-- Risk Distribution Chart -->
    <div class="section">
        <h3>📈 Risk Distribution</h3>
        <div class="chart-container">
            <div class="chart-box">
                <h4>Risk Levels Overview</h4>
                <?php
                // Get risk distribution
                $risk_dist = $conn->query("
                    SELECT risk_level, COUNT(*) as count 
                    FROM symptoms_records 
                    WHERE user_id = $user_id AND risk_level IS NOT NULL
                    GROUP BY risk_level
                ");
                
                $risk_data = ['Low' => 0, 'Moderate' => 0, 'High' => 0, 'Critical' => 0];
                while($row = $risk_dist->fetch_assoc()) {
                    $risk_data[$row['risk_level']] = $row['count'];
                }
                $max_count = max($risk_data) ?: 1;
                ?>
                
                <div class="chart-bar">
                    <?php foreach($risk_data as $level => $count): ?>
                    <div class="bar-item">
                        <div class="bar-value"><?= $count ?></div>
                        <div class="bar" style="height: <?= ($count / $max_count) * 120 + 20 ?>px; background: <?= 
                            $level == 'Low' ? '#28a745' : 
                            ($level == 'Moderate' ? '#ffc107' : 
                            ($level == 'High' ? '#fd7e14' : '#dc3545')) 
                        ?>;"></div>
                        <div class="bar-label"><?= $level ?></div>
                    </div>
                    <?php endforeach; ?>
                </div>
            </div>
            
            <div class="chart-box">
                <h4>Risk Level Summary</h4>
                <?php if(array_sum($risk_data) > 0): ?>
                    <?php foreach($risk_data as $level => $count): ?>
                    <div class="risk-level-item">
                        <span>
                            <span class="risk-dot <?= strtolower($level) ?>"></span>
                            <?= $level ?>
                        </span>
                        <span><?= $count ?> visit<?= $count != 1 ? 's' : '' ?></span>
                    </div>
                    <?php endforeach; ?>
                <?php else: ?>
                    <div class="empty-state">
                        <i class="fas fa-info-circle"></i>
                        <p>No risk data available yet</p>
                    </div>
                <?php endif; ?>
            </div>
        </div>
    </div>

    <!-- Symptoms History Table -->
    <div class="section">
        <div class="section-header">
            <h3>📋 Recent Symptoms Records</h3>
            <a href="full_history.php" class="btn-view-all">View All →</a>
        </div>
        
        <?php if($symptoms_query && $symptoms_query->num_rows > 0): ?>
        <div class="table-wrapper">
            <table>
                <thead>
                    <tr>
                        <th>Date</th>
                        <th>Symptoms</th>
                        <th>Blood Pressure</th>
                        <th>Risk Level</th>
                        <th>Risk Score</th>
                    </tr>
                </thead>
                <tbody>
                    <?php while($record = $symptoms_query->fetch_assoc()): ?>
                    <tr>
                        <td><?= date('M d, Y H:i', strtotime($record['created_at'])) ?></td>
                        <td><?= htmlspecialchars(substr($record['symptoms'], 0, 50)) ?><?= strlen($record['symptoms']) > 50 ? '...' : '' ?></td>
                        <td><?= $record['blood_pressure'] ?? 'N/A' ?></td>
                        <td>
                            <span class="badge badge-<?= strtolower($record['risk_level'] ?? 'low') ?>">
                                <?= $record['risk_level'] ?? 'N/A' ?>
                            </span>
                        </td>
                        <td><?= $record['risk'] ?? 'N/A' ?>%</td>
                    </tr>
                    <?php endwhile; ?>
                </tbody>
            </table>
        </div>
        <?php else: ?>
        <div class="empty-state">
            <i class="fas fa-clipboard-list"></i>
            <p>No symptoms records found. Start by checking your symptoms!</p>
            <br>
            <a href="screen6.html" class="btn-stay" style="display: inline-block; text-decoration: none; padding: 10px 30px; border-radius: 10px;">
                Check Symptoms Now
            </a>
        </div>
        <?php endif; ?>
    </div>

    <!-- Quick Stats -->
    <div class="section">
        <h3>📊 Quick Insights</h3>
        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 15px; margin-top: 15px;">
            <div style="background: #f8f9fa; padding: 15px; border-radius: 10px; text-align: center;">
                <div style="font-size: 24px; font-weight: bold; color: #2e7d32;"><?= $total_visits ?></div>
                <div style="color: #6c757d; font-size: 13px;">Total Assessments</div>
            </div>
            <div style="background: #f8f9fa; padding: 15px; border-radius: 10px; text-align: center;">
                <div style="font-size: 24px; font-weight: bold; color: <?= $latest_risk_color ?>;"><?= $latest_risk ?></div>
                <div style="color: #6c757d; font-size: 13px;">Current Risk Level</div>
            </div>
            <div style="background: #f8f9fa; padding: 15px; border-radius: 10px; text-align: center;">
                <div style="font-size: 24px; font-weight: bold; color: #17a2b8;"><?= $avg_risk ?>%</div>
                <div style="color: #6c757d; font-size: 13px;">Average Risk Score</div>
            </div>
            <div style="background: #f8f9fa; padding: 15px; border-radius: 10px; text-align: center;">
                <div style="font-size: 24px; font-weight: bold; color: #ffc107;"><?= $risk_count ?></div>
                <div style="color: #6c757d; font-size: 13px;">Total Records</div>
            </div>
        </div>
    </div>
</div>

<script>
// ============================================
// AUTO SIGN-OUT AFTER 5 MINUTES INACTIVITY
// ============================================

// Configuration
const SESSION_TIMEOUT = 5; // minutes
const WARNING_TIME = 60; // seconds before logout

// State variables
let idleTimer;
let countdownTimer;
let secondsLeft = SESSION_TIMEOUT * 60;
let warningShown = false;

// DOM elements
const timerDisplay = document.getElementById('timerDisplay');
const sessionTimer = document.getElementById('sessionTimer');
const idleModal = document.getElementById('idleModal');
const countdownDisplay = document.getElementById('countdownTimer');

// ============================================
// RESET IDLE TIMER
// ============================================
function resetIdleTimer() {
    secondsLeft = SESSION_TIMEOUT * 60;
    warningShown = false;
    idleModal.classList.remove('show');
    
    clearInterval(idleTimer);
    clearInterval(countdownTimer);
    
    updateTimerDisplay();
    sessionTimer.className = 'session-timer';
    
    idleTimer = setInterval(checkIdleTime, 1000);
}

// ============================================
// CHECK IDLE TIME
// ============================================
function checkIdleTime() {
    secondsLeft--;
    updateTimerDisplay();
    
    if (secondsLeft <= WARNING_TIME && !warningShown) {
        warningShown = true;
        showWarningModal();
    }
    
    if (secondsLeft <= 0) {
        logoutNow();
    }
}

// ============================================
// UPDATE TIMER DISPLAY
// ============================================
function updateTimerDisplay() {
    const minutes = Math.floor(secondsLeft / 60);
    const seconds = secondsLeft % 60;
    timerDisplay.textContent = `${minutes}:${seconds.toString().padStart(2, '0')}`;
    
    if (secondsLeft <= 60) {
        sessionTimer.className = 'session-timer danger';
    } else if (secondsLeft <= 120) {
        sessionTimer.className = 'session-timer warning';
    }
}

// ============================================
// SHOW WARNING MODAL
// ============================================
function showWarningModal() {
    idleModal.classList.add('show');
    let countdown = WARNING_TIME;
    countdownDisplay.textContent = countdown;
    
    countdownTimer = setInterval(() => {
        countdown--;
        countdownDisplay.textContent = countdown;
        if (countdown <= 0) {
            clearInterval(countdownTimer);
        }
    }, 1000);
}

// ============================================
// STAY LOGGED IN
// ============================================
function stayLoggedIn() {
    resetIdleTimer();
    showToast('Session extended!', 'success');
}

// ============================================
// LOGOUT NOW
// ============================================
function logoutNow() {
    clearInterval(idleTimer);
    clearInterval(countdownTimer);
    showToast('Logging out due to inactivity...', 'info');
    setTimeout(() => {
        window.location.href = '?action=logout';
    }, 1000);
}

// ============================================
// TOAST NOTIFICATION
// ============================================
function showToast(message, type = 'info') {
    const oldToast = document.getElementById('toast');
    if (oldToast) oldToast.remove();
    
    const toast = document.createElement('div');
    toast.id = 'toast';
    const colors = { success: '#2e7d32', error: '#dc3545', info: '#17a2b8' };
    toast.style.cssText = `
        position: fixed;
        top: 20px;
        right: 20px;
        padding: 16px 24px;
        border-radius: 12px;
        color: white;
        font-weight: 500;
        box-shadow: 0 10px 30px rgba(0,0,0,0.15);
        transform: translateX(400px);
        transition: transform 0.3s ease;
        z-index: 1000;
        max-width: 350px;
        background: ${colors[type] || colors.info};
    `;
    toast.textContent = message;
    document.body.appendChild(toast);
    
    setTimeout(() => { toast.style.transform = 'translateX(0)'; }, 100);
    setTimeout(() => { toast.style.transform = 'translateX(400px)'; }, 4000);
}

// ============================================
// RESET TIMER ON USER ACTIVITY
// ============================================
document.addEventListener('mousemove', resetIdleTimer);
document.addEventListener('keypress', resetIdleTimer);
document.addEventListener('click', resetIdleTimer);
document.addEventListener('scroll', resetIdleTimer);

// ============================================
// INITIALIZE
// ============================================
resetIdleTimer();

console.log('Health Analytics Dashboard loaded. Session timeout: ' + SESSION_TIMEOUT + ' minutes');
</script>

</body>
</html>