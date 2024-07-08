<?php
require("conn.php");
header("Content-Type: application/json");

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $json = file_get_contents('php://input');
    $data = json_decode($json, true);

    if (isset($data["id"])) {
        $id = $data["id"];

        // Execute SQL query
        $sql = mysqli_query($conn, "SELECT ess1, ess2 FROM patient_info WHERE P_id='$id'");
        if (!$sql) {
            // Error occurred, handle it
            echo json_encode(array('status' => 'failure', 'message' => 'MySQL error: ' . mysqli_error($conn)));
        } else {
            // Fetch data from the result
            $row = mysqli_fetch_assoc($sql);
            if ($row) {
                // If data is found, return it as JSON
                echo json_encode(array('status' => 'success', 'data' => $row));
            } else {
                // If no data is found for the given ID
                echo json_encode(array('status' => 'failure', 'message' => 'No data found for the given ID'));
            }
        }
    } else {
        // If ID is not provided in the request
        echo json_encode(array('status' => 'failure', 'message' => 'ID not provided'));
    }
} else {
    // If the request method is not POST
    echo json_encode(array('status' => 'failure', 'message' => 'Invalid request method'));
}
?>
