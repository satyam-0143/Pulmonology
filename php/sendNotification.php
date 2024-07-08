<?php
require("conn.php");

function sendNotification($token, $message) {
    $url = 'https://fcm.googleapis.com/fcm/send';
    $fields = array(
        'to' => $token,
        'notification' => array(
            'title' => 'Appointment Status',
            'body' => $message,
        ),
    );

    $headers = array(
        'Authorization: key=-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCxFqQuVHCTrdf6\nRzX+Kg2bhUNMU6BgzEupwQvgR+c+TMQBKS5O8sOPbXpCyJa2AicePYRU4NY9YUU8\nvnZZd2poRxnZHi14MnqNz6dNCnzdOmCmAdsuS2BcSfWOIud9W46gqWhlafVVIilg\nAVDLS47BsNnXpCFG1/WpUMGIisWQzPI44G8hJarUegLlXNqb2YbqIXIjhCUtnD/Y\nJG6sXGxHZ/GWmidjnuXglqHO1pnwAgtMYNItWeiJeFV+2J8XxJoP18XMwUy9euEj\nzaQNjCOvuLRayNMw/8uK70ya2vqnLN00kSUflUmLMsQdCkoI3ueI7Aozcsakf8U8\n+wD6FgkFAgMBAAECggEACdlT0N0F+wiobuh//CTgzd0uN+c2XIijZ3HWB1rB/yjs\nBV6B3CBluCsWdiYyAs+a1yeeHc34mSa5Eyt9z8Fm+La5NsyWKpp86DjI04cssgcg\nC4uMSGzAk4SfgUPqspuhePw2OXgYdDj3d4a+Z7GwYyn2Htqngrxz34wfJckGCBgH\ns4rpX7fZjQFB2GjbHguAFXwgBw8FGpOo0Y3yiiaVUsRpIP2bqEHEqfHi45yvMcLU\n7tkplhSZa6Oc3g90M1pTGO9vm1YgtKAqG+vhrF+uAcjwz9iDq4MBLrBt0U9utoc7\nKeM+Ot3nHzSVmUVzlcV8XlN96IQe033j+3WXGia77wKBgQDrr/269jgAHEBBIOOx\n1h/jRtjxkDDT3VgU/j8Hnv8kf6LTeVM8FYnNm/K6Y1DhquhXiqC6B0m5TZjK/omZ\nr07My6hbVPlGFkkafSm816HGAkuSxNYVejIJh33TyUQ3mZRq2EpYr1yIlq6UNHq1\nozWNjfeIEYaldvpaFke0eIAy7wKBgQDAWcVbvyE+Id2ectT2MiyI6hYrvyRODD8D\nMDtD8RmjhmK/INemOWV4bRXLfNSEIZZye1Gj4OH0p7Pue5gqrm03Lwj681RcHlRQ\nr102PgfsFrLImUogYrS7xunwUi3LPP58IPvM34Vfv8iL9GYjEjXP2Rj41E20TGjO\nfPx1XbazSwKBgQDZVuKhTTqZB3RNWtn9/ZpMSOH36OLODPiT610OVxWrf7QUVXZn\nGumH3H56WOmWILe/Oow64EuhAKic0RrsyRfejRPEnVh9xEFHlxItHaAF68nrH27Y\nQWXxGavz6E7rAso1uRzeKWAoaOO2sapS452X2sngBWFoJo55EsCu8MwvqwKBgEZd\nEIs9YcW+0blyvGDLfesf5rheFcPPSwW5kRSLkBt3v4u3Uevmty3UidKEeaFUQBrk\n7bqLO10qM/IbmFCUujMjq59RgByqo6FYZTrAells/D3RhYJPWVoPq+hTx5i/WUDD\nOBl78uhR2eUIpIxTzweXnUD5OOupv/U5V4j/nSP9AoGAEm/5D5xzOVc83gvto1Ga\n+YqbosfS8wFzTPi8KG2mZsRuuTtGgKYe8vq3bg1KphsmVCyN9htGO1GC+n2W4wpl\n+ioMaBJUT7Fhi1YRTeMINfxItESc71yQ6tpLdsGAY1PBCh1evxcqkduz2WiPJBNr\n1Em5keZD8udvCzS9unAQJPY=\n-----END PRIVATE KEY-----\n",', // Replace YOUR_SERVER_KEY with your Firebase server key
        'Content-Type: application/json'
    );

    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $url);
    curl_setopt($ch, CURLOPT_POST, true);
    curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
    curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($fields));

    $result = curl_exec($ch);
    if ($result === FALSE) {
        die('Curl failed: ' . curl_error($ch));
    }

    curl_close($ch);
    return $result;
}

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    // Decode the JSON data
    $json = file_get_contents('php://input');
    $data1 = json_decode($json, true);
    
    $pid = $data1["pid"];
    $sql = "SELECT * FROM tempappo WHERE pid='$pid'";
    $result = mysqli_query($conn, $sql);
    if (mysqli_num_rows($result) > 0) {
        $data = array();
        while ($row = mysqli_fetch_assoc($result)) {
            $data = $row;
        }

        // Send notification if status is approved
        if ($data['status'] == 'approved') {
            // Assuming you have the FCM token stored in the database
            $token = $data['fcm_token'];
            $message = "Your appointment has been approved.";
            sendNotification($token, $message);
        }

        echo json_encode($data);
    } else {
        echo json_encode(array("message" => "data not found"));
    }
}
?>
