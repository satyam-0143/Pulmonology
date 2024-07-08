<?php
// Include the database connection file
require("conn.php");

// Include the sendNotification function file
include("notify.php");

// Specify the content type header
header('Content-Type: application/json');

// Function to approve the appointment and send a notification
function approveAppointment($pid) {
    global $conn; // Access the global connection variable

    // Update the appointment status in the database
    $sql = "UPDATE tempappo SET status='Approved' WHERE pid=?";
    $stmt = $conn->prepare($sql);

    // Bind the 'pid' parameter to the SQL query
    $stmt->bind_param("s", $pid);

    // Execute the query
    if ($stmt->execute()) {
        // Send the notification after updating the status
        $title = 'Appointment Approved';
        $body = 'Doctor accepted your appointment on ' . date('Y-m-d H:i:s');
        $response = sendNotification($pid, $title, $body);

        // Success: return a JSON response indicating success
        echo json_encode(['status' => 'success', 'message' => 'Appointment updated successfully and notification sent', 'response' => $response]);
    } else {
        // Failure: return a JSON response indicating failure
        $response = ['status' => 'failure', 'message' => 'Failed to update appointment'];
        echo json_encode($response);
    }

    // Close the prepared statement
    $stmt->close();
}

// Check if the request method is POST
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    // Read and decode the JSON data from the request body
    $json = file_get_contents('php://input');
    $data = json_decode($json, true);

    // Check if 'pid' is present in the request data
    if (isset($data['pid'])) {
        // Retrieve the 'pid' value from the request data
        $pid = $data['pid'];

        // Call the function to approve the appointment
        approveAppointment($pid);
    } else {
        // Missing 'pid' in request data
        $response = ['status' => 'failure', 'message' => 'Missing pid in request data'];
        echo json_encode($response);
    }
} else {
    // Invalid request method
    $response = ['status' => 'failure', 'message' => 'Invalid request method'];
    echo json_encode($response);
}

// Close the database connection
$conn->close();
?>
