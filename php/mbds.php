<?php
require("conn.php");
header("Content-Type: application/json");

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $json = file_get_contents('php://input');
    $data = json_decode($json, true);

    if (isset($_POST["score"]) && isset($_POST["pid"])) {
        $score = $_POST["score"];
        $id = $_POST["pid"];

        $sql1 = mysqli_query($conn, "SELECT mbds1 FROM patient_info where pid='$id' ");
        $sql2 = mysqli_query($conn, "SELECT mbds2 FROM patient_info where  pid ='$id' ");
        $row = mysqli_fetch_assoc($sql1);
        $row1= mysqli_fetch_assoc($sql2);

        // Access the value of 1Qnr1 column from the fetched row
        $valueFromSQL1 = $row['mbds1'];
        $valueFromSQL2 = $row1['mbds2'];

        // Print or use the value obtained from SQL1
        // echo "Value from SQL1: " . $valueFromSQL1;
        // echo "Value from SQL2: " . $valueFromSQL2;
      
    
        if (  $valueFromSQL1 === "") {
            // If sql1 result is empty, perform an insert or update
            mysqli_query($conn, "update patient_info set mbds1='$score' where pid='$id'  ");
        } elseif ($valueFromSQL2 === "") {
            // If sql2 result is empty, perform another insert or update
            mysqli_query($conn, "update patient_info set mbds2='$score' where pid='$id'  ");
        }

        // Perform additional operations based on your requirements
        
        // Assuming you want to send a success message as a response
        $response = array('status' => 'success', 'message' => 'Data processed successfully');
        echo json_encode($response);
    } else {
        $response = array('status' => 'failure', 'message' => 'Score not received in the request');
        echo json_encode($response);
    }
} else {
    $response = array('status' => 'failure', 'message' => 'Invalid request method');
    echo json_encode($response);
}
?>
