<?php

require 'vendor/autoload.php';

use Kreait\Firebase\Factory;
use Kreait\Firebase\ServiceAccount;

// Replace with the actual path to your Firebase service account JSON file
$serviceAccountPath = 'C:\Users\SATAM KUMAR\Downloads\push-notification-ad070-firebase-adminsdk-roxbj-68e744fd8d.json';

// Create a new Firebase factory instance
$factory = (new Factory)->withServiceAccount($serviceAccountPath);

// Create a Firebase instance
$firebase = $factory->create();

// You can now use the Firebase instance to interact with Firebase services
// For example, to get the database instance:
$database = $firebase->getDatabase();

echo "Firebase has been initialized successfully.";
