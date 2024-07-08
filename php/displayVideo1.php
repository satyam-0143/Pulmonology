<?php
// Establish connection to your database
require("conn.php");

// Fetch video URLs from your database table
$sql = "SELECT uVideos FROM videos"; // Modify this query according to your database structure
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    $videos = array();

    // Fetch and store video URLs in an array
    while($row = $result->fetch_assoc()) {
        $videos[] = $row["uVideos"];
    }

    // Encode the array into JSON format and send as response
    echo json_encode(array("videos" => $videos));
} else {
    echo "No videos found";
}
$conn->close();
?>
