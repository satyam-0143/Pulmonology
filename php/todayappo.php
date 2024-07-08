<?php
// Establish connection to your database
require("conn.php");

// Get today's date in YYYY-MM-DD format
$currentDate = date("Y-m-d");

// SQL query to retrieve patients for the current date
$sql = "SELECT t.pid,t.name,t.date,p.P_phno,p.img FROM  p_profile p join tempappo t on p.P_id = t.pid  WHERE t.date = '$currentDate' and t.status= 'Approved'";

$result = $conn->query($sql);

if ($result->num_rows > 0) {
    // Output data of each row
    $patients = array();
    while ($row = $result->fetch_assoc()) {
        // Prepend base URL to the image path
        $row['img'] = 'http://192.168.148.130:80/test/' . $row['img'];
        // Add patient details to the array
        $patients[] = $row;
    }
    // Output the patient details in JSON format
    echo json_encode($patients);
} else {
    echo "0 results";
}

$conn->close();
?>
