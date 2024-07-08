<?php
require("conn.php");
header("Content-Type: application/json");

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $json = file_get_contents('php://input');
    $data = json_decode($json, true);

    if (isset($_POST["pid"])) {
       
        $id = $_POST["pid"];

        $sql1 = mysqli_query($conn, "SELECT pbp FROM bsmwt where pid='$id' ");
        $sql2 = mysqli_query($conn, "SELECT phr FROM bsmwt where  pid ='$id' ");
        $sql3 = mysqli_query($conn, "SELECT pso2 FROM bsmwt where pid='$id' ");
        $sql4 = mysqli_query($conn, "SELECT pdys FROM bsmwt where  pid ='$id' ");
        $sql5 = mysqli_query($conn, "SELECT pfat FROM bsmwt where pid='$id' ");
        $sql6 = mysqli_query($conn, "SELECT ebp FROM bsmwt where  pid ='$id' ");
        $sql7 = mysqli_query($conn, "SELECT ehr FROM bsmwt where pid='$id' ");
        $sql8 = mysqli_query($conn, "SELECT eso2 FROM bsmwt where  pid ='$id' ");
        $sql9 = mysqli_query($conn, "SELECT edys FROM bsmwt where pid='$id' ");
        $sql10 = mysqli_query($conn, "SELECT efat FROM bsmwt where  pid ='$id' ");
        $sql11= mysqli_query($conn, "SELECT t1 FROM bsmwt where pid='$id' ");
        $sql12= mysqli_query($conn, "SELECT t2 FROM bsmwt where  pid ='$id' ");




        $row = mysqli_fetch_assoc($sql1);
        $row1= mysqli_fetch_assoc($sql2);
        $row2 = mysqli_fetch_assoc($sql3);
        $row3= mysqli_fetch_assoc($sql4);
        $row4= mysqli_fetch_assoc($sql5);
        $row5= mysqli_fetch_assoc($sql6);
        $row6= mysqli_fetch_assoc($sql7);
        $row7= mysqli_fetch_assoc($sql8);
        $row8= mysqli_fetch_assoc($sql9);
        $row9= mysqli_fetch_assoc($sql10);
        $row10= mysqli_fetch_assoc($sql11);
        $row11= mysqli_fetch_assoc($sql12);

        // Access the value of 1Qnr1 column from the fetched row
        $s1 = $row['pbp'];
        $s2 = $row1['phr'];
        $s3 = $row2['pso2'];
        $s4 = $row3['pdys'];
        $s5 = $row4['pfat'];
        $s6 = $row5['ebp'];
        $s7 = $row6['ehr'];
        $s8 = $row7['eso2'];
        $s9 = $row8['edys'];
        $s10 = $row9['efat'];
        $s11 = $row10['t1'];
        $s12 = $row11['t2'];

        // Print or use the value obtained from SQL1
        // echo "Value from SQL1: " . $valueFromSQL1;
        // echo "Value from SQL2: " . $valueFromSQL2;
      
    
      

        // Perform additional operations based on your requirements
        
        // Assuming you want to send a success message as a response
        $response = array('status' => 'success', 's1' => $s1 , 's2' => $s2,'s3' => $s3 , 's4' => $s4,'s5' => $s5 , 's6' => $s6,'s7' => $s7 , 's8' => $s8,'s9' => $s9,'s10' => $s10 , 's11' => $s11,'s12'=>$s12);
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
