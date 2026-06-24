<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Forgot Password - MotherCare</title>
<style>
    * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
    }
    
    body {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        display: flex;
        justify-content: center;
        align-items: center;
        min-height: 100vh;
        margin: 0;
        padding: 20px;
    }
    
    .container {
        background: white;
        padding: 40px;
        border-radius: 20px;
        width: 400px;
        max-width: 100%;
        text-align: center;
        box-shadow: 0 20px 40px rgba(0,0,0,0.1);
        animation: fadeIn 0.5s ease;
    }
    
    @keyframes fadeIn {
        from { opacity: 0; transform: translateY(-20px); }
        to { opacity: 1; transform: translateY(0); }
    }
    
    h2 {
        color: #333;
        margin-bottom: 10px;
    }
    
    p {
        color: #666;
        margin-bottom: 20px;
        font-size: 14px;
    }
    
    .input-group {
        margin-bottom: 20px;
        text-align: left;
    }
    
    .input-group label {
        display: block;
        margin-bottom: 8px;
        color: #555;
        font-weight: 500;
    }
    
    input, select {
        width: 100%;
        padding: 12px;
        border: 2px solid #e0e0e0;
        border-radius: 8px;
        font-size: 14px;
        transition: border-color 0.3s;
        font-family: inherit;
    }
    
    input:focus, select:focus {
        outline: none;
        border-color: #667eea;
    }
    
    button {
        width: 100%;
        padding: 12px;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
        border: none;
        border-radius: 8px;
        font-size: 16px;
        font-weight: bold;
        cursor: pointer;
        transition: transform 0.2s;
    }
    
    button:hover {
        transform: translateY(-2px);
    }
    
    button:active {
        transform: translateY(0);
    }
    
    .back-link {
        margin-top: 20px;
        display: block;
        color: #667eea;
        text-decoration: none;
        font-size: 14px;
    }
    
    .back-link:hover {
        text-decoration: underline;
    }
    
    .msg {
        margin-top: 15px;
        padding: 10px;
        border-radius: 8px;
        font-size: 14px;
        display: none;
    }
    
    .msg.success {
        background: #d4edda;
        color: #155724;
        display: block;
    }
    
    .msg.error {
        background: #f8d7da;
        color: #721c24;
        display: block;
    }
    
    .msg.info {
        background: #d1ecf1;
        color: #0c5460;
        display: block;
    }
    
    .delivery-options {
        display: flex;
        gap: 15px;
        margin-bottom: 20px;
    }
    
    .delivery-option {
        flex: 1;
        padding: 10px;
        border: 2px solid #e0e0e0;
        border-radius: 8px;
        cursor: pointer;
        text-align: center;
        transition: all 0.3s;
    }
    
    .delivery-option.selected {
        border-color: #667eea;
        background: #f0f0ff;
    }
    
    .delivery-option:hover {
        border-color: #667eea;
    }
    
    .timer {
        color: #667eea;
        font-weight: bold;
        margin: 10px 0;
    }
</style>
</head>
<body>

<div class="container" id="step1">
    <h2>🔐 Reset Password</h2>
    <p>Enter your registered email or phone to receive OTP</p>
    
    <div class="input-group">
        <label>📧 Email or 📱 Phone</label>
        <input type="text" id="identifier" placeholder="example@email.com or +256123456789">
    </div>
    
    <div class="input-group">
        <label>📨 Receive OTP via</label>
        <div class="delivery-options">
            <div class="delivery-option" data-method="email" onclick="selectMethod('email')">
                📧 Email
            </div>
            <div class="delivery-option" data-method="sms" onclick="selectMethod('sms')">
                📱 SMS
            </div>
        </div>
    </div>
    
    <button onclick="sendOTP()">Send OTP</button>
    <a href="screen1.html" class="back-link">← Back to Login</a>
    <div id="msg" class="msg"></div>
</div>

<div class="container" id="step2" style="display: none;">
    <h2>🔐 Verify OTP</h2>
    <p>Enter the 6-digit code sent to your <span id="deliveryMethod"></span></p>
    
    <div class="input-group">
        <label>📝 OTP Code</label>
        <input type="text" id="otp_code" maxlength="6" placeholder="Enter 6-digit code">
    </div>
    
    <div class="input-group">
        <label>🔑 New Password</label>
        <input type="password" id="new_password" placeholder="Enter new password">
    </div>
    
    <div class="input-group">
        <label>✅ Confirm Password</label>
        <input type="password" id="confirm_password" placeholder="Confirm new password">
    </div>
    
    <button onclick="verifyOTP()">Reset Password</button>
    <button onclick="resendOTP()" style="background: #6c757d; margin-top: 10px;">Resend OTP</button>
    <div id="timer" class="timer"></div>
    <div id="msg2" class="msg"></div>
</div>

<script>
let selectedMethod = 'email';
let userIdentifier = '';
let otpTimer = null;
let timeLeft = 0;

function selectMethod(method) {
    selectedMethod = method;
    document.querySelectorAll('.delivery-option').forEach(opt => {
        opt.classList.remove('selected');
    });
    document.querySelector(`[data-method="${method}"]`).classList.add('selected');
}

async function sendOTP() {
    const identifier = document.getElementById('identifier').value.trim();
    
    if(!identifier) {
        showMsg('Please enter email or phone', 'error');
        return;
    }
    
    userIdentifier = identifier;
    
    showMsg('Sending OTP...', 'info');
    
    try {
        const res = await fetch('send_otp.php', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: new URLSearchParams({ 
                identifier: identifier, 
                method: selectedMethod 
            })
        });
        
        const data = await res.json();
        
        if(data.success) {
            showMsg(data.message, 'success');
            // Show step 2
            document.getElementById('step1').style.display = 'none';
            document.getElementById('step2').style.display = 'block';
            document.getElementById('deliveryMethod').innerText = selectedMethod === 'email' ? 'email' : 'phone';
            
            // Start timer
            startTimer(300); // 5 minutes
        } else {
            showMsg(data.message, 'error');
        }
    } catch(err) {
        showMsg('Network error: ' + err.message, 'error');
    }
}

async function verifyOTP() {
    const otp = document.getElementById('otp_code').value.trim();
    const newPassword = document.getElementById('new_password').value;
    const confirmPassword = document.getElementById('confirm_password').value;
    
    if(!otp || otp.length !== 6) {
        showMsg2('Please enter valid 6-digit OTP', 'error');
        return;
    }
    
    if(!newPassword || newPassword.length < 6) {
        showMsg2('Password must be at least 6 characters', 'error');
        return;
    }
    
    if(newPassword !== confirmPassword) {
        showMsg2('Passwords do not match', 'error');
        return;
    }
    
    showMsg2('Verifying...', 'info');
    
    try {
        const res = await fetch('verify_otp.php', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: new URLSearchParams({ 
                identifier: userIdentifier,
                otp: otp,
                new_password: newPassword
            })
        });
        
        const data = await res.json();
        
        if(data.success) {
            showMsg2('Password reset successful! Redirecting...', 'success');
            setTimeout(() => {
                window.location.href = 'screen1.html';
            }, 2000);
        } else {
            showMsg2(data.message, 'error');
        }
    } catch(err) {
        showMsg2('Network error: ' + err.message, 'error');
    }
}

async function resendOTP() {
    showMsg2('Resending OTP...', 'info');
    
    try {
        const res = await fetch('send_otp.php', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: new URLSearchParams({ 
                identifier: userIdentifier, 
                method: selectedMethod,
                resend: true
            })
        });
        
        const data = await res.json();
        
        if(data.success) {
            showMsg2('OTP resent successfully!', 'success');
            startTimer(300);
        } else {
            showMsg2(data.message, 'error');
        }
    } catch(err) {
        showMsg2('Network error: ' + err.message, 'error');
    }
}

function startTimer(seconds) {
    if(otpTimer) clearInterval(otpTimer);
    timeLeft = seconds;
    
    const timerElement = document.getElementById('timer');
    
    otpTimer = setInterval(() => {
        if(timeLeft <= 0) {
            clearInterval(otpTimer);
            timerElement.innerHTML = 'OTP expired. Please request again.';
            timerElement.style.color = 'red';
        } else {
            const minutes = Math.floor(timeLeft / 60);
            const seconds = timeLeft % 60;
            timerElement.innerHTML = `OTP expires in: ${minutes}:${seconds.toString().padStart(2, '0')}`;
            timerElement.style.color = '#667eea';
            timeLeft--;
        }
    }, 1000);
}

function showMsg(message, type) {
    const msgDiv = document.getElementById('msg');
    msgDiv.innerHTML = message;
    msgDiv.className = 'msg ' + type;
    setTimeout(() => {
        msgDiv.style.display = 'none';
        msgDiv.className = 'msg';
    }, 5000);
}

function showMsg2(message, type) {
    const msgDiv = document.getElementById('msg2');
    msgDiv.innerHTML = message;
    msgDiv.className = 'msg ' + type;
    setTimeout(() => {
        msgDiv.style.display = 'none';
        msgDiv.className = 'msg';
    }, 5000);
}
</script>

</body>
</html>