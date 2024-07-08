<?php
require("conn.php"); 

// Read JSON data from request body
$json = file_get_contents('php://input');

// Check if JSON decoding was successful
$data = json_decode($json, true);
if ($data === null) {
    // JSON decoding failed
    $response = array('status' => 'failure', 'message' => 'Invalid JSON data');
} else {
    // Check if required keys exist
    if (isset($data["P_id"]) && isset($data["password"])) {
        // Username and password from request
        $username = $data["P_id"];
        $password = $data["password"];

        // Query to select data based on username and password
        $sql = "SELECT * FROM p_profile WHERE P_id = '$username' AND password = '$password'";
        $result = $conn->query($sql);

        // Check if any rows were returned
        if ($result->num_rows > 0) {
            // Login successful
            $response = array('status' => 'success', 'message' => 'Login successful');
        } else {
            // Login failed
            $response = array('status' => 'failure', 'message' => 'Invalid username or password');
        }
    } else {
        // Username or password not provided
        $response = array('status' => 'failure', 'message' => 'Username or password not provided');
    }
}

// Send response as JSON
header('Content-Type: application/json');
echo json_encode($response);

// Close connection
$conn->close();
?>
