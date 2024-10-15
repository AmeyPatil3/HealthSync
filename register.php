<?php
$servername = "localhost";  // Your database host
$username = "root";         // Your MySQL username
$password = "@Amey2005";             // Your MySQL password
$dbname = "ermiadb";        // The database you created

// Create connection
$conn = new mysqli('localhost','root', '@Amey2005','ermiadb');

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Check if the form is submitted
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    // Identify if it's a Normal User or Doctor registration
    $user_type = $_POST['user-type'];

    // Hash the password for security
    $password = password_hash($_POST['password'], PASSWORD_DEFAULT);

    if ($user_type == "normal") {
        // Normal User registration
        $user_id = $_POST['username'];
        $first_name = $_POST['first-name'];
        $middle_name = $_POST['middle-name'];
        $last_name = $_POST['last-name'];
        $dob = $_POST['dob'];
        $gender = $_POST['gender'];
        $mobile = $_POST['mobile'];
        $address_street = $_POST['street'];
        $address_city = $_POST['city'];
        $address_state = $_POST['state'];
        $address_zipcode = $_POST['zipcode'];
        $aadhaar = $_POST['aadhaar'];

        // Prepare SQL statement
        $sql = "INSERT INTO normal_users (user_id, first_name, middle_name, last_name, dob, gender, mobile, address_street, address_city, address_state, address_zipcode, aadhaar, password)
                VALUES ('$user_id', '$first_name', '$middle_name', '$last_name', '$dob', '$gender', '$mobile', '$address_street', '$address_city', '$address_state', '$address_zipcode', '$aadhaar', '$password')";

        // Execute the query
        if ($conn->query($sql) === TRUE) {
            echo "New normal user registered successfully!";
        } else {
            echo "Error: " . $sql . "<br>" . $conn->error;
        }

    } elseif ($user_type == "doctor") {
        // Doctor registration
        $first_name = $_POST['first-name'];
        $middle_name = $_POST['middle-name'];
        $last_name = $_POST['last-name'];
        $mobile = $_POST['mobile'];
        $nmr_id = $_POST['nmr-id'];
        $aadhaar = $_POST['aadhaar'];

        // Prepare SQL statement
        $sql = "INSERT INTO doctors (first_name, middle_name, last_name, mobile, nmr_id, aadhaar, password)
                VALUES ('$first_name', '$middle_name', '$last_name', '$mobile', '$nmr_id', '$aadhaar', '$password')";

        // Execute the query
        if ($conn->query($sql) === TRUE) {
            echo "New doctor registered successfully!";
        } else {
            echo "Error: " . $sql . "<br>" . $conn->error;
        }
    }
}

// Close the connection
$conn->close();
?>
