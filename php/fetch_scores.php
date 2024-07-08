<?php
require("conn.php");
header("Content-Type: application/json");

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $json = file_get_contents('php://input');
    $data = json_decode($json, true);

    if (isset($data["P_id"])) {
        $id = mysqli_real_escape_string($conn, $data["P_id"]);

        $sql = "SELECT `1Qnr1`, `2Qnr2` FROM patient_info WHERE P_id='$id'";
        $result = mysqli_query($conn, $sql);

        if ($result) {
            $row = mysqli_fetch_assoc($result);
            $first_time_score = json_decode($row['1Qnr1']);
            $second_time_score = json_decode($row['2Qnr2']);

            $response = array('status' => 'success', 'scores' => json_encode(array('first_time_score' => $first_time_score, 'second_time_score' => $second_time_score)));
            echo json_encode($response);
        } else {
            $response = array('status' => 'failure', 'message' => 'Error fetching scores');
            echo json_encode($response);
        }
    } else {
        $response = array('status' => 'failure', 'message' => 'P_id not received in the request');
        echo json_encode($response);
    }
} else {
    $response = array('status' => 'failure', 'message' => 'Invalid request method');
    echo json_encode($response);
}
?>
