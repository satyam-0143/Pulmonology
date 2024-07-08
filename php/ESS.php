<?php
require("conn.php");
header("Content-Type: application/json");

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $json = file_get_contents('php://input');
    $data = json_decode($json, true);

    if (isset($data["score"]) && isset($data["P_id"])) {
        $score = $data["score"];
        $id = $data["P_id"];

        $sql1 = mysqli_query($conn, "SELECT ess1, ess2 FROM patient_info WHERE P_id='$id' ");
        $row = mysqli_fetch_assoc($sql1);
        $valueFromESS1 = $row['ess1'];
        $valueFromESS2 = $row['ess2'];

        if ($valueFromESS1 === "") {
            mysqli_query($conn, "UPDATE patient_info SET ess1='$score' WHERE P_id='$id' ");
        } elseif ($valueFromESS2 === "") {
            mysqli_query($conn, "UPDATE patient_info SET ess2='$score' WHERE P_id='$id' ");
        } else {
            // Both ess1 and ess2 have values, you can decide what to do in this case
            // For example, you can alternate between updating ess1 and ess2
            $sql2 = "SELECT COUNT(*) AS total FROM patient_info WHERE P_id='$id' AND ess1 IS NOT NULL AND ess2 IS NOT NULL";
            $result = mysqli_query($conn, $sql2);
            $data = mysqli_fetch_assoc($result);
            $totalCount = $data['total'];

            if ($totalCount % 2 == 0) {
                mysqli_query($conn, "UPDATE patient_info SET ess1='$score' WHERE P_id='$id' ");
            } else {
                mysqli_query($conn, "UPDATE patient_info SET ess2='$score' WHERE P_id='$id' ");
            }
        }

        $response = array('status' => 'success', 'message' => 'Data processed successfully');
        echo json_encode($response);
    } else {
        $response = array('status' => 'failure', 'message' => 'Score or P_id not received in the request');
        echo json_encode($response);
    }
} else {
    $response = array('status' => 'failure', 'message' => 'Invalid request method');
    echo json_encode($response);
}
?>
