<?php
require("conn.php");
if($_SERVER["REQUEST_METHOD"] == "POST" ) {
    // Decode the JSON data
    $json = file_get_contents('php://input');//data1["pid"];
    $data1 = json_decode($json, true);
    if(isset($_POST["pid"])){ // Remove the check for password
        $pid = $_POST["pid"];
        $password = $_POST["password"]; // If you have password field in your form, modify accordingly
        $name = $_POST["name"];
        $age = $_POST["age"];
        $sex = $_POST["sex"];
        $cause = $_POST["cause"];
        $sql = "insert into login values('$pid','$password')"; // Make sure to properly hash the password before inserting
        $sql1 = "INSERT INTO patient_info(pid, name, age, sex, cause) VALUES ('$pid', '$name', '$age', '$sex', '$cause')";

        mysqli_query($conn,"INSERT INTO bsmwt(pid, pbp, phr, pso2, pdys, pfat, ebp, ehr, eso2, edys, efat, t1, t2) 
VALUES ('$pid', '', '', '', '', '', '', '', '', '', '', '', '')");
        mysqli_query($conn,"INSERT INTO asmwt(pid, pbp, phr, pso2, pdys, pfat, ebp, ehr, eso2, edys, efat, t1, t2) 
VALUES ('$pid', '', '', '', '', '', '', '', '', '', '', '', '')");

        if(mysqli_query($conn, $sql) && mysqli_query($conn,$sql1)){
            $response = array('status' => 'success', 'message' => 'data inserted successfully');
            echo json_encode($response);
        } else {
            $response = array('status'=> 'fail','message'=>"data not inserted");
            echo json_encode($response);
        }
    }
}
?>
