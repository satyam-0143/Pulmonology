<?php

// Database connection parameters
$servername = "localhost"; // Change this if your database is hosted on a different server
$username = "root"; // Replace with your MySQL username
$password = ""; // Replace with your MySQL password
$database = "pulmonary_rehabilitation"; // Replace with your database name

// Create connection
$conn = new mysqli($servername, $username, $password, $database);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}




// if(!$conn){
//     echo mysqli_error($conn);
// }
// else{
//     //echo "connected successfull";
// }


?>