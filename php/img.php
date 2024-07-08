<!DOCTYPE html>
<html>
<head>
    <title>Display Image from Database</title>
</head>
<body>
    <h1>Display Image</h1>

    <!-- Replace "display.php?id=1" with the appropriate URL to your PHP script -->
    <img src="image 3.jpg" />
   

    <?php
    $i = 1;
    $conn = mysqli_connect("localhost", "root", "", "patient");
    $rows = mysqli_query($conn,"select * from image");

    if(mysqli_num_rows($rows) >0){
    
        while($img = mysqli_fetch_assoc($rows)){
            print_r($img);

?>
    <img src="<?php echo $img['img']; ?>" width="50" height="50">
<?php

        }

    }

    else{
        echo "0";
    }

?>
 
</body>
</html>
