<?php
require("conn.php");
header("Content-Type: application/json");

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $json = file_get_contents('php://input');
    $data = json_decode($json, true);

    if (isset($data["P_id"])) {
        $id = $data["P_id"];
        $responseMessage = array();

        // Check and update mmr1
        if (isset($data["mmr1"])) {
            $score1 = $data["mmr1"];
            $sql1 = mysqli_query($conn, "UPDATE patient_info SET mmr1='$score1' WHERE P_id='$id'");
            if ($sql1 === false) {
                $responseMessage[] = 'Error executing SQL query for mmr1: ' . mysqli_error($conn);
            } else {
                $responseMessage[] = 'mmr1 updated successfully';
            }
        }

        // Check and update mmr2
        if (isset($data["mmr2"])) {
            $score2 = $data["mmr2"];
            $sql2 = mysqli_query($conn, "UPDATE patient_info SET mmr2='$score2' WHERE P_id='$id'");
            if ($sql2 === false) {
                $responseMessage[] = 'Error executing SQL query for mmr2: ' . mysqli_error($conn);
            } else {
                $responseMessage[] = 'mmr2 updated successfully';
            }
        }

        if (empty($responseMessage)) {
            $responseMessage[] = 'No data to update';
        }

        $response = array('status' => 'success', 'message' => $responseMessage);
        echo json_encode($response);

    } else {
        $response = array('status' => 'failure', 'message' => 'Patient ID not received in the request');
        echo json_encode($response);
    }
} else {
    $response = array('status' => 'failure', 'message' => 'Invalid request method');
    echo json_encode($response);
}

?>
