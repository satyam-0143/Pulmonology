<?php
require("conn.php");
header("Content-Type: application/json");

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $json = file_get_contents('php://input');
    $data = json_decode($json, true);

    if (isset($data["id"])) {
        $id = $data["id"];

        // Fetch details from the database based on the user's ID
        $sql = mysqli_query($conn, "SELECT mmr1, mmr2 FROM patient_info WHERE P_id='$id'");
        $row = mysqli_fetch_assoc($sql);

        if ($row) {
            // If data is found, return it as JSON
            echo json_encode(array('status' => 'success', 'data' => $row));
        } else {
            // If no data is found for the given ID
            echo json_encode(array('status' => 'failure', 'message' => 'No data found for the given ID'));
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
