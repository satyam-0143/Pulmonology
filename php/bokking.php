<?php
require("conn.php");

// Check if the request method is POST and the request contains a JSON payload
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    // Decode the JSON data
    $json = file_get_contents('php://input');
    $data = json_decode($json, true);

    // Check if the required fields are present in the JSON data
    if (isset($data["pid"]) && isset($data["name"]) && isset($data["date"])) {
        $pid = $data["pid"];
        $name = $data["name"];
        $date = $data["date"];
        $status = "pending";

        // Check the number of appointments already booked for the given date
        $checkSql = "SELECT COUNT(*) AS count FROM tempappo WHERE date = '$date'";
        $result = mysqli_query($conn, $checkSql);
        
        if ($result) {
            $row = mysqli_fetch_assoc($result);
            $count = $row['count'];

            if ($count < 5) {
                // If the count is less than 3, proceed with the booking
                $sql = "INSERT INTO tempappo (pid, name, date, status) VALUES ('$pid', '$name', '$date', '$status')";
                if (mysqli_query($conn, $sql)) {
                    // Notify the doctor about the appointment
                    include("notify-doctor.php");
                    $doctorNotification = sendDoctorNotification($pid, $date);

                    $response = array('status' => 'success', 'message' => 'Data inserted successfully', 'doctor_notification' => $doctorNotification);
                } else {
                    $response = array('status' => 'failure', 'message' => 'Data not inserted');
                }
            } else {
                // If the count is 3 or more, do not allow further bookings for that date
                $response = array('status' => 'failure', 'message' => 'Max number of appointments for this date reached');
            }
        } else {
            $response = array('status' => 'failure', 'message' => 'Error executing count query');
        }

        echo json_encode($response);
    } else {
        $response = array('status' => 'failure', 'message' => 'Missing required fields in JSON data');
        echo json_encode($response);
    }
} else {
    $response = array('status' => 'failure', 'message' => 'Invalid request method');
    echo json_encode($response);
}
?>
