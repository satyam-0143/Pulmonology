<?php

require("conn.php");

$result =$conn->query("SELECT * FROM uVideos");
$list=array();
if ($result){
    while ($row = mysqli_fetch_assoc($result)){
        $list[]=$row;
    }
    echo json_decode($list);
}