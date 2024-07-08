<?php
// Your database connection parameters
require("conn.php");

// SQL query to fetch patient information
$sql = "SELECT P_id, P_name, P_gender, P_phno, img FROM p_profile";

$result = $conn->query($sql);

if ($result->num_rows > 0) {
    $data = array();
    while ($row = $result->fetch_assoc()) {
        $data[] = $row;
    }
    echo json_encode($data); // Return JSON response
} else {
    echo "0 results";
}
$conn->close();
?>
