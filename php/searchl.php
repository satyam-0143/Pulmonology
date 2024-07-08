<?php
require_once "conn.php";
header("Content-Type: application/json");

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Retrieve the search value from the request
    $searchValue = $_POST['searchValue']; // Assuming the search value is sent via POST

    // Prepare the SQL query with a placeholder for the search value
    $q1 = "SELECT userName FROM login WHERE userName = ?";
    
    // Prepare the statement
    $stmt = mysqli_prepare($conn, $q1);

    // Bind the search value parameter
    mysqli_stmt_bind_param($stmt, "s", $searchValue);

    // Execute the statement
    mysqli_stmt_execute($stmt);

    // Get the result set
    $result = mysqli_stmt_get_result($stmt);

    $patientList = array(); // Initialize an array to hold patient IDs

    // Fetch data from the database and store it in the array
    while ($row = mysqli_fetch_assoc($result)) {
        $patientList[] = $row['userName'];
    }

    // Convert the PHP array to JSON format
    $jsonPatientList = json_encode($patientList);

    // Output the JSON data
    echo $jsonPatientList;
}
?>
