
<?php
require_once('conn.php');

function jsonResponse($status, $message, $data = null) {
    $response = array('status' => $status, 'message' => $message);
    if ($data !== null) {
        $response['doctorDetails'] = $data;
    }
    echo json_encode($response);
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Check if 'userid' is set
    if (isset($_POST['userid'])) {
        // Get the Userid from the POST data
        $userid = trim($_POST['userid']);

        // SQL query to retrieve doctor information based on dr_userid
        $sql = "SELECT * FROM d_profile WHERE D_id = ?";
        $stmt = $conn->prepare($sql);
        $stmt->bind_param("s", $userid);
        $stmt->execute();
        $result = $stmt->get_result();

        if ($result->num_rows > 0) {
            // Fetch doctor details as an associative array
            $doctorDetails = $result->fetch_assoc();

            // Return doctor details as JSON with proper Content-Type header
            jsonResponse(true, "Doctor details retrieved successfully.", $doctorDetails);
        } else {
            // No doctor found with the provided dr_userid
            jsonResponse(false, "No doctor found with the provided Userid.");
        }
    } else {
        // 'userid' not provided
        jsonResponse(false, "Please provide a userid.");
    }
} else {
    // Handle non-POST requests (e.g., return an error response)
    jsonResponse(false, "Invalid request method.");
}

// Close the database connection
$conn->close();
?>