<?php
// Include the database connection file
require("conn.php");

// Log the raw POST data to debug
file_put_contents("php://stderr", print_r($_POST, true));

// Check if userId is sent via POST
if (isset($_POST['userId'])) {
    $patient_id = $_POST['userId'];

    // SQL query to fetch notifications
    $sql = "SELECT message FROM notifications WHERE pid = ? ORDER BY created_at DESC LIMIT 1";
    $stmt = $conn->prepare($sql);

    if ($stmt) {
        // Bind the parameter and execute the statement
        $stmt->bind_param("s", $patient_id);
        $stmt->execute();
        $result = $stmt->get_result();

        $notifications = array();
        if ($result->num_rows > 0) {
            while ($row = $result->fetch_assoc()) {
                $notifications[] = $row['message'];
            }
        }

        echo json_encode(array("notifications" => $notifications));

        // Close statement and connection
        $stmt->close();
    } else {
        // Handle prepare statement error
        echo json_encode(array("error" => "Prepare statement failed"));
    }
} else {
    // Handle missing userId parameter
    echo json_encode(array("error" => "Missing userId parameter"));
}

// Close the database connection
$conn->close();
?>
