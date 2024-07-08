<?php
// Include your database connection code here
require_once('conn.php');

// Enable error reporting for debugging purposes
error_reporting(E_ALL);
ini_set('display_errors', 1);

// Define the function to create a directory if it does not exist
function createDirectory($path) {
    if (!is_dir($path)) {
        if (!mkdir($path, 0777, true)) {
            throw new Exception('Failed to create directory: ' . $path);
        }
    }
}

// Check if the request is a POST request
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Retrieve form data from $_POST
    $username = $_POST['P_id'] ?? '';
    $name = $_POST['P_name'] ?? '';
    $mobilenumber = $_POST['P_phno'] ?? '';
    $password = $_POST['password'] ?? '';
    $gender = $_POST['P_gender'] ?? '';
    $cause = $_POST['cause'] ?? '';
    $age = $_POST['P_age'] ?? ''; // Add age field


    // Initialize image path as null (no image uploaded)
    $imagePath = null;

    // Handle file upload
    if (isset($_FILES['img']) && $_FILES['img']['error'] === UPLOAD_ERR_OK) {
        // Define the image file path
        $imagePath = 'uploads/' . $username . '.jpg';

        // Create the 'doc' directory if it doesn't exist
        try {
            createDirectory(dirname($imagePath));
        } catch (Exception $e) {
            error_log($e->getMessage());
            echo json_encode(['status' => 'error', 'message' => $e->getMessage()]);
            exit();
        }

        // Read the binary data of the uploaded image
        $imageFile = $_FILES['img']['tmp_name'];
        $imageData = file_get_contents($imageFile);

        // Check if file_get_contents was successful
        if ($imageData === false) {
            echo json_encode(['status' => 'error', 'message' => 'Failed to read image data.']);
            exit();
        }

        // Attempt to write the image data to the file
        if (file_put_contents($imagePath, $imageData) === false) {
            echo json_encode(['status' => 'error', 'message' => 'Failed to write image data to file.']);
            exit();
        }

        error_log("Image data successfully written to file: $imagePath");
    }

    // Insert the data into the p_profile table
    $sql1 = "INSERT INTO p_profile (P_id, P_name,P_gender, P_phno, password,img, cause) 
            VALUES ('$username', '$name','$gender', '$mobilenumber', '$password','$imagePath','$cause')";

    // Insert data into the patient_info table
    $sql2 = "INSERT INTO patient_info (P_id, P_name,  P_gender, cause,P_age) 
             VALUES ('$username', '$name',  '$gender', '$cause',$age)";

    // Execute the queries and check for success
    if ($conn->query($sql1) === TRUE && $conn->query($sql2) === TRUE) {
        // Output a combined success response
        echo json_encode(['status' => 'success', 'message' => 'User registration successful.', 'data' => ['patient_info' => $sql2]]);
    } else {
        // Output an error response
        echo json_encode(['status' => 'error', 'message' => 'Error: ' . $conn->error]);
        error_log("Database insertion error: " . $conn->error);
    }
} else {
    // Return an error response for non-POST requests
    echo json_encode(['status' => 'error', 'message' => 'Invalid request method.']);
}

// Close the database connection
$conn->close();
error_log("Database connection closed.");
?>
