<?php
require("conn.php");
header("Content-Type: application/json");

$response = array();

$data = json_decode(file_get_contents("php://input"), true);

if ($_SERVER['REQUEST_METHOD'] === 'POST' &&
    isset($data['P_id']) &&
    isset($data['pbp']) && isset($data['phr']) &&
    isset($data['pdys']) && isset($data['pfat'])) {

    $pbp = $data['pbp'];
    $phr = $data['phr'];
    $pdys = $data['pdys'];
    $pfat = $data['pfat'];
    $id = $data['P_id'];

    $sql = "UPDATE patient_info SET pbp='$pbp', phr='$phr', pdys='$pdys', pfat='$pfat' WHERE P_id='$id'";

    if ($conn->query($sql) === TRUE) {
        $response['status'] = 'success';
        $response['message'] = 'Pre Test data updated successfully';
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
