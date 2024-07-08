<?php
require("conn.php");
header("Content-Type: application/json");

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $json = file_get_contents('php://input');
    $data = json_decode($json, true);

    if (isset($data["P_id"])) {
        $id = $data["P_id"];

        $sql = mysqli_query($conn, "SELECT mbds1, mbds2 FROM patient_info WHERE P_id='$id'");
        $row = mysqli_fetch_assoc($sql);

        if ($row) {
            echo json_encode(array('status' => 'success', 'data' => $row));
        } else {
            echo json_encode(array('status' => 'failure', 'message' => 'No data found for the given ID'));
        }
    } else {
        echo json_encode(array('status' => 'failure', 'message' => 'ID not provided'));
    }
} else {
    echo json_encode(array('status' => 'failure', 'message' => 'Invalid request method'));
}
?>
