<?php
require("conn.php");
header("Content-Type: application/json");

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $json = file_get_contents('php://input');
    $data = json_decode($json, true);

    if (isset($data["P_id"]) && (isset($data["first_time_score"]) || isset($data["second_time_score"]))) {
        $id = mysqli_real_escape_string($conn, $data["P_id"]);
        
        // Check if data for the patient already exists
        $sql = "SELECT * FROM patient_info WHERE P_id='$id'";
        $result = mysqli_query($conn, $sql);

        if (mysqli_num_rows($result) > 0) {
            // Data for the patient already exists, update it
            if (isset($data["first_time_score"])) {
                $first_time_score = mysqli_real_escape_string($conn, $data["first_time_score"]);
                $sql = "UPDATE patient_info SET `1Qnr1`='$first_time_score' WHERE P_id='$id'";
                mysqli_query($conn, $sql);
            }
            if (isset($data["second_time_score"])) {
                $second_time_score = mysqli_real_escape_string($conn, $data["second_time_score"]);
                $sql = "UPDATE patient_info SET `2Qnr2`='$second_time_score' WHERE P_id='$id'";
                mysqli_query($conn, $sql);
            }
        } else {
            // Data for the patient doesn't exist, insert new data
            if (isset($data["first_time_score"])) {
                $first_time_score = mysqli_real_escape_string($conn, $data["first_time_score"]);
            } else {
                $first_time_score = null;
            }
            if (isset($data["second_time_score"])) {
                $second_time_score = mysqli_real_escape_string($conn, $data["second_time_score"]);
            } else {
                $second_time_score = null;
            }
            $sql = "INSERT INTO patient_info (P_id, `1Qnr1`, `2Qnr2`) VALUES ('$id', '$first_time_score', '$second_time_score')";
            mysqli_query($conn, $sql);
        }

        $response = array('status' => 'success', 'message' => 'Data processed successfully');
        echo json_encode($response);
    } else {
        $response = array('status' => 'failure', 'message' => 'First time score, second time score, or P_id not received in the request');
        echo json_encode($response);
    }
} else {
    $response = array('status' => 'failure', 'message' => 'Invalid request method');
    echo json_encode($response);
}
?>
