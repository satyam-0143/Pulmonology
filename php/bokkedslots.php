<?php
require("conn.php");
if ($_SERVER["REQUEST_METHOD"] == "POST" ) {
    // Decode the JSON data
    $json = file_get_contents('php://input');
    $data1 = json_decode($json, true);
    
   
    $pid = $data1["pid"];
    $sql = "select * from tempappo where pid='$pid'";
    $result = mysqli_query($conn, $sql);
    if(mysqli_num_rows($result) >0){
        $data = array();
        while ($row = mysqli_fetch_assoc($result)) {
            $data= $row;
        }
        echo json_encode($data);
    } 
    else{
        echo json_encode(array("message"=> "data not found"));

    }



}






?>