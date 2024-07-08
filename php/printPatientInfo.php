<?php
require("conn.php");

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    // Decode the JSON data
    $json = file_get_contents('php://input');
    $data1 = json_decode($json, true);

    if (isset($_POST['P_id'])) {
        $pid = $_POST['P_id'];

        // Fetch data from the database based on $pid
        $sql = "SELECT * FROM patient_info WHERE P_id='$pid'";
        $result = mysqli_query($conn, $sql);

        if ($result) {
            $data = array();

            while ($row = mysqli_fetch_assoc($result)) {
                $data[] = $row; // Add fetched rows to the $data array
            }

            // Convert fetched data to JSON format
            $jsonResponse = json_encode($data);

            // Output the JSON response
            header('Content-Type: application/json');
            echo $jsonResponse;
        } else {
            // Handle query execution errors
            echo "Error executing the query: " . mysqli_error($conn);
        }
    } else {
        // Handle if 'pid' is not set in the received JSON data
        echo "PID not found in the received data";
    }
} else {
    // Handle if the request method is not POST
    echo "Invalid request method";
}
?>
