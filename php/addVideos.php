<?php
// Database connection details
require("conn.php");
// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Directory where uploaded videos will be saved
$uploadDir = "videos/";

if ($_SERVER['REQUEST_METHOD'] == 'POST' && isset($_FILES['uploaded_file'])) {
    $file = $_FILES['uploaded_file'];
    $fileName = basename($file['name']);
    $uploadPath = $uploadDir . $fileName;

    if (move_uploaded_file($file['tmp_name'], $uploadPath)) {
        // File uploaded successfully, insert path into database
        $sql = "INSERT INTO videos VALUES ('$uploadPath')";

        if ($conn->query($sql) === TRUE) {
            echo "Video path inserted into the database successfully";
        } else {
            echo "Error inserting video path into the database: " . $conn->error;
        }
    } else {
        echo "Error uploading the file";
    }
} else {
    echo "Invalid request";
}

$conn->close();
?>
