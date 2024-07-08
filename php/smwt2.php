<?php
require("conn.php");
header("Content-Type: application/json");

$response = array();

$data = json_decode(file_get_contents("php://input"), true);

if ($_SERVER['REQUEST_METHOD'] === 'POST' &&
    isset($data['P_id']) &&
    isset($data['ebp']) && isset($data['ehr']) &&
    isset($data['edys']) && isset($data['efat'])) {

    $ebp = $data['ebp'];
    $ehr = $data['ehr'];
    $edys = $data['edys'];
    $efat = $data['efat'];
    $id = $data['P_id'];

    $sql = "UPDATE patient_info SET ebp='$ebp', ehr='$ehr', edys='$edys', efat='$efat' WHERE P_id='$id'";

    if ($conn->query($sql) === TRUE) {
        $response['status'] = 'success';
        $response['message'] = 'Post Test data updated successfully';
    } else {
        $response['status'] = 'failure';
        $response['message'] = 'Error: ' . $conn->error;
    }

    $conn->close();
} else {
    $response['status'] = 'failure';
    $response['message'] = 'Missing parameters';
}

echo json_encode($response);
?>
