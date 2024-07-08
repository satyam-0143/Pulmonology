<?php
require("conn.php");
header("Content-Type: application/json");

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $json = file_get_contents('php://input');
    $data = json_decode($json, true);

    if (isset($_POST["pid"])) {
       
        $id = $_POST["pid"];

        $sql1 = mysqli_query($conn, "SELECT ess1 FROM patient_info where pid='$id' ");
        $sql2 = mysqli_query($conn, "SELECT ess2 FROM patient_info where  pid ='$id' ");
        $row = mysqli_fetch_assoc($sql1);
        $row1= mysqli_fetch_assoc($sql2);

        // Access the value of 1Qnr1 column from the fetched row
        $valueFromSQL1 = $row['ess1'];
        $valueFromSQL2 = $row1['ess2'];

        // Print or use the value obtained from SQL1
        // echo "Value from SQL1: " . $valueFromSQL1;
        // echo "Value from SQL2: " . $valueFromSQL2;
      
    
      

        // Perform additional operations based on your requirements
        
        // Assuming you want to send a success message as a response
        $response = array('status' => 'success', 's1' => $valueFromSQL1 , 's2' => $valueFromSQL2);
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
