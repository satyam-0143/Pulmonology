<?php
require("conn.php");
header("Content-Type: application/json");

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $json = file_get_contents('php://input');
    $data = json_decode($json, true);

    if (isset($data["P_id"])) {
        $id = $data["P_id"];
        $bpr = $data["bpr"];
        $bprfvc = $data["bprfvc"];
        $bprfev1 = $data["bprfev1"];
        $bprfef = $data["bprfef"];
        $bpo = $data["bpo"];
        $bpofvc = $data["bpofvc"];
        $bpofev1 = $data["bpofev1"];
        $bpofef = $data["bpofef"];

        // Update the database with the entered details
        $updateSql = "UPDATE patient_info SET bpr='$bpr', bprfvc='$bprfvc', bprfev1='$bprfev1', bprfef='$bprfef', bpo='$bpo', bpofvc='$bpofvc', bpofev1='$bpofev1', bpofef='$bpofef' WHERE P_id='$id'";
        if (mysqli_query($conn, $updateSql)) {
            $response = array('status' => 'success', 'message' => 'Data updated successfully');
        } else {
            $response = array('status' => 'failure', 'message' => 'Error updating data: ' . mysqli_error($conn));
        }

        echo json_encode($response);
    } else {
        $response = array('status' => 'failure', 'message' => 'P_id not received in the request');
        echo json_encode($response);
    }
} else {
    $response = array('status' => 'failure', 'message' => 'Invalid request method');
    echo json_encode($response);
}
?>
