<?php
// Replace these variables with your database connection details
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "pulmonary_rehabilitation";

// Create a connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check the connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Get the current year
$currentYear = date("Y");

// Construct your SQL query with the current year
$sql = "SELECT MONTH(date) AS month, COUNT(*) AS patients FROM tempappo WHERE YEAR(date) = $currentYear GROUP BY MONTH(date) ORDER BY MONTH(date)";

// Execute the query
$result = $conn->query($sql);

// Initialize an array to store the results
$data = array();

// Check if there are any results
if ($result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        $monthNumber = $row['month'];
        $monthName = date("F", mktime(0, 0, 0, $monthNumber, 1, $currentYear)); // Convert month number to month name
        $row['month'] = $monthName; // Replace the month number with month name
        $data[] = $row;
    }
}

// Encode the results as JSON
$json_data = json_encode($data);

// Output the JSON data
header('Content-Type: application/json');
echo $json_data;

// Close the database connection
$conn->close();
?>
