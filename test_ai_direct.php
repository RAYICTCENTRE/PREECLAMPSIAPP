<?php
// test_ai_direct.php - Test AI directly

echo "<h1>Testing AI Directly</h1>";

$python_path = 'C:\\Users\\MAT\\AppData\\Local\\Programs\\Python\\Python314\\python.exe';
$ai_script = 'C:\\xampp\\htdocs\\mothercare\\predict_ai.py';

// Test data
$test_data = [
    'mode' => 'home',
    'symptoms' => 'Headache, Swelling',
    'systolic_bp' => 140,
    'diastolic_bp' => 90,
    'proteinuria' => 'None',
    'gestational_age_weeks' => 30,
    'maternal_age_yrs' => 28,
    'diabetes' => 0,
    'previous_pe' => 0,
    'multiple_pregnancy' => 0,
    'hypertension' => 0
];

$json_input = json_encode($test_data);
$json_base64 = base64_encode($json_input);

$command = $python_path . " " . $ai_script . " " . $json_base64 . " 2>&1";

echo "<h2>Command:</h2>";
echo "<pre>" . htmlspecialchars($command) . "</pre>";

$output = shell_exec($command);

echo "<h2>Raw Output:</h2>";
echo "<pre>" . htmlspecialchars($output) . "</pre>";

$result = json_decode($output, true);
if ($result) {
    echo "<h2>Parsed Result:</h2>";
    echo "<pre>" . print_r($result, true) . "</pre>";
    
    if (isset($result['ai_used']) && $result['ai_used'] === true) {
        echo "<p style='color:green;font-size:20px;'>✅ AI IS WORKING!</p>";
    } else {
        echo "<p style='color:orange;font-size:20px;'>⚠️ AI is using fallback</p>";
    }
} else {
    echo "<p style='color:red;font-size:20px;'>❌ Failed to parse JSON output</p>";
    echo "<p>This usually means Python couldn't run or the script has errors.</p>";
}
?>