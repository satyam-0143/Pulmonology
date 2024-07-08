<?php
require("conn.php");

// Set the correct content type header
header('Content-Type: application/json');

// Check if the request method is POST
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Read the JSON input data
    $json = file_get_contents('php://input');
    $data = json_decode($json, true);

    // Check if the P_id field is set
    if (isset($data['D_id'])) {
        $Did = $data['D_id'];

        // Query the database for the patient profile
        $query = "SELECT * FROM d_profile WHERE D_id='$Did'";
        $result = mysqli_query($conn, $query);

        // Check if the query was successful
        if ($result) {
            // Fetch the associative array
            $data = mysqli_fetch_assoc($result);

            // Close the database connection
            mysqli_close($conn);

            // Return the data as JSON
            echo json_encode($data);
        } else {
            // If there is an error fetching data, return an error message
            echo json_encode(['error' => 'Error fetching data']);
        }
    } else {
        // If the P_id field is not set, return an error message
        echo json_encode(['error' => 'P_id not provided']);
    }
} else {
    echo json_encode(['error' => 'Invalid request method']);
}
?>
