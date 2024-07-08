<?php
// Check if the form was submitted
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Check if a file was uploaded
    if (isset($_FILES['file'])) {
        $uploadDir = 'uploads/'; // Specify the upload directory
        $uploadFile = $uploadDir . basename($_FILES['file']['name']); // Specify the path to save the file

        // Move the uploaded file to the specified directory
        if (move_uploaded_file($_FILES['file']['tmp_name'], $uploadFile)) {
            echo "File uploaded successfully.";
        } else {
            echo "Failed to upload file.";
        }
    } else {
        echo "No file uploaded.";
    }
}
?>
