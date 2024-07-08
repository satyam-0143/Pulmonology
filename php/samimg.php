<?php
// Include the database connection file (replace with your actual database connection code)
require("conn.php");

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (isset($_POST['image'])) {
        $encodedImage = $_POST['image'];

        // Decode the base64 encoded string
        $decodedImage = base64_decode($encodedImage);

        // Generate a unique name for the image or use any desired naming convention
        $imageFileName = uniqid() . '.jpg';

        // Path to store images on the server
        $imagePath = 'img/' . $imageFileName;

        // Save image to the server
        $file = fopen($imagePath, 'wb');
        fwrite($file, $decodedImage);
        fclose($file);

        // Insert image path into the database
        $sql = "INSERT INTO samimg  VALUES ('$imagePath')";
        $stmt = mysqli_query($conn, $sql);

        if ($stmt) {
            echo json_encode(array("status" => "success", "message" => "Image inserted into the database"));
        } else {
            echo json_encode(array("status" => "error", "message" => "Failed to insert image into the database"));
        }
    } else {
        echo json_encode(array("status" => "error", "message" => "Image data not received"));
    }
} else {
    echo json_encode(array("status" => "error", "message" => "Invalid request method"));
}
?>
