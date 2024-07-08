<?php
// Include the database connection file
require("conn.php");

// Function to send notification
function sendNotification($pid, $title, $body) {
    global $conn; // Access the global connection variable

    // Set the timezone to Indian Standard Time (IST)
    date_default_timezone_set('Asia/Kolkata');

    // Construct the notification message with IST timestamp
    $message = "Doctor accepted your appointment on " . date('Y-m-d H:i:s');

    // Insert the notification into the database
    $sql = "INSERT INTO notifications (pid, message) VALUES (?, ?)";
    $stmt = $conn->prepare($sql);

    // Bind the parameters
    $stmt->bind_param("ss", $pid, $message);

    // Execute the query
    if ($stmt->execute()) {
        // Success: return the message
        return $message;
    } else {
        // Failure: return an error message
        return "Failed to send notification";
    }

    // Close the prepared statement
    $stmt->close();
}
?>
