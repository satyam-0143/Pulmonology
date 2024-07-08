<?php
require("conn.php");
header("Content-Type: application/json");

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $json = file_get_contents('php://input');
    $data = json_decode($json, true);

    if (isset($data["P_id"])) {
        $id = $data["P_id"];

        $sql1 = mysqli_query($conn, "SELECT bpr FROM patient_info WHERE P_id='$id'");
        $sql2 = mysqli_query($conn, "SELECT bprfvc FROM patient_info WHERE P_id='$id'");
        $sql3 = mysqli_query($conn, "SELECT bprfev1 FROM patient_info WHERE P_id='$id'");
        $sql4 = mysqli_query($conn, "SELECT bprfef FROM patient_info WHERE P_id='$id'");
        $sql5 = mysqli_query($conn, "SELECT apr FROM patient_info WHERE P_id='$id'");
        $sql6 = mysqli_query($conn, "SELECT aprfvc FROM patient_info WHERE P_id='$id'");
        $sql7 = mysqli_query($conn, "SELECT aprfev1 FROM patient_info WHERE P_id='$id'");
        $sql8 = mysqli_query($conn, "SELECT aprfef FROM patient_info WHERE P_id='$id'");
        
        $row = mysqli_fetch_assoc($sql1);
        $row1 = mysqli_fetch_assoc($sql2);
        $row2 = mysqli_fetch_assoc($sql3);
        $row3 = mysqli_fetch_assoc($sql4);
        $row4 = mysqli_fetch_assoc($sql5);
        $row5 = mysqli_fetch_assoc($sql6);
        $row6 = mysqli_fetch_assoc($sql7);
        $row7 = mysqli_fetch_assoc($sql8);

        // Access the values from the fetched rows
        $s1 = $row['bpr'];
        $s2 = $row1['bprfvc'];
        $s3 = $row2['bprfev1'];
        $s4 = $row3['bprfef'];
        $s5 = $row4['apr'];
        $s6 = $row5['aprfvc'];
        $s7 = $row6['aprfev1'];
        $s8 = $row7['aprfef'];

        // Assuming you want to send a success message as a response
        $response = array('status' => 'success', 's1' => $s1, 's2' => $s2, 's3' => $s3, 's4' => $s4, 's5' => $s5, 's6' => $s6, 's7' => $s7, 's8' => $s8);
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
