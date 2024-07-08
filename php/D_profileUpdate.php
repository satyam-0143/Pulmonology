<?php
require("conn.php");

// Set the correct content type header
header('Content-Type: application/json');

// Check if the request method is POST
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Check if the necessary fields are set
    if (isset($_POST['P_id']) && isset($_POST['P_name']) && isset($_POST['P_gender']) && isset($_POST['P_phno'])) {
        $pid = $_POST['P_id'];
        $name = $_POST['P_name'];
        $gender = $_POST['P_gender'];
        $phno = $_POST['P_phno'];

        // Check if an image file was uploaded
        if (isset($_FILES['image'])) {
            // File upload directory
            $targetDir = "uploads/";
            $fileName = $pid . ".jpg"; // Constructing the filename as P_id.jpg
            $targetFilePath = $targetDir . $fileName;
            $fileType = pathinfo($targetFilePath, PATHINFO_EXTENSION);

            // Allow certain file formats
            $allowTypes = array('jpg', 'jpeg', 'png', 'gif');
            if (in_array($fileType, $allowTypes)) {
                // Upload file to server
                if (move_uploaded_file($_FILES['image']['tmp_name'], $targetFilePath)) {
                    // Update profile with image
                    $imagePath = "uploads/" . $fileName; // Constructing the image path
                    $query = "UPDATE P_profile SET P_name='$name', P_gender='$gender', P_phno='$phno', img='$imagePath' WHERE P_id='$pid'";
                    $result = mysqli_query($conn, $query);
                    if ($result) {
                        echo json_encode(array("status" => true, "message" => "Profile updated successfully."));
                    } else {
                        echo json_encode(array("status" => false, "message" => "Failed to update profile."));
                    }
                } else {
                    echo json_encode(array("status" => false, "message" => "Failed to upload image."));
                }
            } else {
                echo json_encode(array("status" => false, "message" => "Only JPG, JPEG, PNG, and GIF files are allowed."));
            }
        } else {
            // Update profile without image
            $query = "UPDATE P_profile SET P_name='$name', P_gender='$gender', P_phno='$phno' WHERE P_id='$pid'";
            $result = mysqli_query($conn, $query);
            if ($result) {
                echo json_encode(array("status" => true, "message" => "Profile updated successfully."));
            } else {
                echo json_encode(array("status" => false, "message" => "Failed to update profile."));
            }
        }
    } else {
        echo json_encode(array("status" => false, "message" => "Required fields are missing."));
    }
} else {
    echo json_encode(array("status" => false, "message" => "Invalid request method."));
}
?>
