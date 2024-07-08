<?php
require("conn.php");
header("Content-Type: application/json");

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $json = file_get_contents('php://input');
    $data = json_decode($json, true);

    if (isset($data["P_id"])) {
        $id = $data["P_id"];

        $stmt = $conn->prepare("SELECT Stques1, Stques2 FROM patient_info WHERE P_id = ?");
        $stmt->bind_param("s", $id);
        $stmt->execute();
        $result = $stmt->get_result();
        $row = $result->fetch_assoc();

        if ($row) {
            // Convert the string values to integers
            $row['Stques1'] = (int)$row['Stques1'];
            $row['Stques2'] = (int)$row['Stques2'];
            echo json_encode(array('status' => 'success', 'data' => $row));
        } else {
            echo json_encode(array('status' => 'failure', 'message' => 'No data found for the given ID'));
        }

        $stmt->close();
    } else {
        echo json_encode(array('status' => 'failure', 'message' => 'ID not provided'));
    }
} else {
    echo json_encode(array('status' => 'failure', 'message' => 'Invalid request method'));
}
?>
