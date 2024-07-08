<?php
require("conn.php");
header("Content-Type: application/json");

// Log received data
file_put_contents('php://stdout', print_r($_POST, true));

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $json = file_get_contents('php://input');
    $data = json_decode($json, true);

    if (isset($data["P_id"])) {
        $id = $data["P_id"];
        $responseMessage = array();

        // Check and update mbds1
        if (isset($data["mbds1"])) {
            $score1 = $data["mbds1"];
            $sql1 = mysqli_query($conn, "UPDATE patient_info SET mbds1='$score1' WHERE P_id='$id'");
            if ($sql1 === false) {
                $responseMessage[] = 'Error executing SQL query for mbds1: ' . mysqli_error($conn);
            } else {
                $responseMessage[] = 'mbds1 updated successfully';
            }
        }

        // Check and update mbds2
        if (isset($data["mbds2"])) {
            $score2 = $data["mbds2"];
            $sql2 = mysqli_query($conn, "UPDATE patient_info SET mbds2='$score2' WHERE P_id='$id'");
            if ($sql2 === false) {
                $responseMessage[] = 'Error executing SQL query for mbds2: ' . mysqli_error($conn);
            } else {
                $responseMessage[] = 'mbds2 updated successfully';
            }
        }

        // Fetch the updated scores
        $sqlFetch1 = mysqli_query($conn, "SELECT mbds1 FROM patient_info WHERE P_id='$id'");
        $sqlFetch2 = mysqli_query($conn, "SELECT mbds2 FROM patient_info WHERE P_id='$id'");

        if ($sqlFetch1 === false || $sqlFetch2 === false) {
            $responseMessage[] = 'Error fetching updated scores: ' . mysqli_error($conn);
        } else {
            $row1 = mysqli_fetch_assoc($sqlFetch1);
            $row2 = mysqli_fetch_assoc($sqlFetch2);

            $valueFromSQL1 = $row1['mbds1'];
            $valueFromSQL2 = $row2['mbds2'];

            $responseMessage[] = 'Scores fetched successfully';
            $response = array(
                'status' => 'success',
                'message' => $responseMessage,
                's1' => $valueFromSQL1,
                's2' => $valueFromSQL2
            );
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
