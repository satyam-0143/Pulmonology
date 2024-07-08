<?php
require("conn.php");
header("Content-Type: application/json");

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $json = file_get_contents('php://input');
    $data = json_decode($json, true);

    if (isset($data["P_id"])) {
        $id = $data["P_id"];
        $apr = $data["apr"];
        $aprfvc = $data["aprfvc"];
        $aprfev1 = $data["aprfev1"];
        $aprfef = $data["aprfef"];
        $apo = $data["apo"];
        $apofvc = $data["apofvc"];
        $apofev1 = $data["apofev1"];
        $apofef = $data["apofef"];

        // Update the database with the entered details
        $updateSql = "UPDATE patient_info SET apr='$apr', aprfvc='$aprfvc', aprfev1='$aprfev1', aprfef='$aprfef', apo='$apo', apofvc='$apofvc', apofev1='$apofev1', apofef='$apofef' WHERE P_id='$id'";
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
