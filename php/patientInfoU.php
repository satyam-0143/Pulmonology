<?php
// Include the database connection file (replace with your actual database connection code)
require("conn.php");

// Check if the request is a POST request
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Get the JSON data from the request body
    $json_data = file_get_contents("php://input");

    // Parse the JSON data into an associative array
    $data = json_decode($json_data, true);

    // Check if the JSON data was successfully parsed
    if ($data !== null) {
        // Extract data from the JSON
        $pid = $data['pid'];
        $name = $data['name'];
        $age = $data['age'];
        $sex = $data['sex'];
        $cause = $data['cause'];

        // Perform the database update (replace with your database update code)
        $sql = "UPDATE patient_info SET pid ='$pid', name = '$name', age = '$age', sex = '$sex',cause='$cause' where pid='$pid' ";
        $stmt=mysqli_query($conn, $sql);
        echo json_encode(array("status"=> "success","message"=> "Data updated succesfully"));

        // Check if the update was successful
        // if (my> 0) {
        //     $response = array('message' => 'Data updated successfully');
        //     echo json_encode($response);
        // } else {
        //     $response = array('message' => 'Data not updated');
        //     echo json_encode($response);
        // }
    } else {
        $response = array('message' => 'Invalid JSON data');
        echo json_encode($response);
        
    }
} else {
    $response = array('message' => 'Invalid request method');
    echo json_encode($response);
}
?>
