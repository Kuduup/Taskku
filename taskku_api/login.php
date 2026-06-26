<?php

include "koneksi.php";

$username = $_POST['username'];
$password = $_POST['password'];

$query = mysqli_query($conn,
    "SELECT * FROM users
    WHERE username='$username'
    AND password='$password'"
);

if(mysqli_num_rows($query) > 0){

    $data = mysqli_fetch_assoc($query);

    echo json_encode([
        "success" => true,
        "message" => "Login berhasil",
        "id" => $data['id'],
        "username" => $data['username']
    ]);

}else{

    echo json_encode([
        "success" => false,
        "message" => "Username atau password salah"
    ]);

}
?>