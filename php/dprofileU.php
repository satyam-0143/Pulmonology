<?php
require_once('conn.php');

function jsonResponse($status, $message, $errorCode = null, $imageUrl = null) {
    $response = array('status' => $status, 'message' => $message);
    if ($errorCode !== null) {
        $response['errorCode'] = $errorCode;
    }
    if ($imageUrl !== null) {
        $response['imageUrl'] = $imageUrl;
    }
    echo json_encode($response);
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Check if 'field1', 'field2', 'field3', 'field4' are set
    if (isset($_POST['field1'], $_POST['field2'], $_POST['field3'], $_POST['field4'])) {
        // Get the field values from the POST data (sanitize and validate if necessary)
        $field1 = trim($_POST['field1']); // Assuming field1 is the D_id
        $field2 = trim($_POST['field2']); // Assuming field2 is the D_name
        $field3 = trim($_POST['field3']); // Assuming field3 is the D_dep
        $field4 = trim($_POST['field4']); // Assuming field4 is the D_phno

        // Check if a file is uploaded
        if (isset($_FILES['image']) && $_FILES['image']['error'] === UPLOAD_ERR_OK) {
            // Define the upload directory as the 'doc' folder
            $upload_dir = 'doc/';
            // Get the uploaded file details
            $file_name = basename($_FILES['image']['name']);
            $temp_name = $_FILES['image']['tmp_name'];

            // Move the uploaded file to the upload directory (doc folder)
            if (move_uploaded_file($temp_name, $upload_dir . $file_name)) {
                // SQL query to update doctor profile including the image field
                $sql = "UPDATE d_profile SET D_name = ?, D_dep = ?, D_phno = ?, image = ? WHERE D_id = ?";
                $stmt = $conn->prepare($sql);
                $stmt->bind_param("sssss", $field2, $field3, $field4, $file_name, $field1);
                
                if ($stmt->execute()) {
                    // Profile updated successfully
                    $imageUrl = 'http://' . $_SERVER['HTTP_HOST'] . '/test/' . $upload_dir . $file_name;
                    jsonResponse(true, "Profile updated successfully.", null, $imageUrl);
                } else {
                    // Error updating profile
                    jsonResponse(false, "Failed to update profile.", 101);
                }
            } else {
                // Error moving uploaded file
                jsonResponse(false, "Failed to move uploaded file.", 102);
            }
        } else {
            // No file uploaded, update profile without changing the image
            $sql = "UPDATE d_profile SET D_name = ?, D_dep = ?, D_phno = ? WHERE D_id = ?";
            $stmt = $conn->prepare($sql);
            $stmt->bind_param("ssss", $field2, $field3, $field4, $field1);
            
            if ($stmt->execute()) {
                // Profile updated successfully
                jsonResponse(true, "Profile updated successfully.");
            } else {
                // Error updating profile
                jsonResponse(false, "Failed to update profile.", 103);
            }
        }
    } else {
        // Required fields not provided
        jsonResponse(false, "Please provide all required fields.", 104);
    }
} else {
    // Handle non-POST requests (e.g., return an error response)
    jsonResponse(false, "Invalid request method.", 105);
}

// Close the database connection
$conn->close();
?>
