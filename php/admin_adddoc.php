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
    $username = $_POST['D_id'] ?? '';
    $name = $_POST['D_name'] ?? '';
    $mobilenumber = $_POST['D_phno'] ?? '';
    $password = $_POST['password'] ?? '';
    $designation = $_POST['D_dep'] ?? '';

    // Initialize image path as null (no image uploaded)
    $imagePath = null;

    // Handle file upload
    if (isset($_FILES['image']) && $_FILES['image']['error'] === UPLOAD_ERR_OK) {
        // Define the image file path
        $imagePath = 'doc/' . $username . '.jpg';

        // Create the 'doc' directory if it doesn't exist
        try {
            createDirectory(dirname($imagePath));
        } catch (Exception $e) {
            error_log($e->getMessage());
            echo json_encode(['status' => 'error', 'message' => $e->getMessage()]);
            exit();
        }

        // Read the binary data of the uploaded image
        $imageFile = $_FILES['image']['tmp_name'];
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

    // Insert the data into the database
    $sql = "INSERT INTO d_profile (D_id, D_name, D_phno, password, D_dep, image) 
            VALUES ('$username', '$name', '$mobilenumber', '$password', '$designation', '$imagePath')";

    // Execute the query and check for success
    if ($conn->query($sql) === TRUE) {
        // Output a success response
        echo json_encode(['status' => 'success', 'message' => 'User registration successful.']);
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
