<?php

include "koneksi.php";

$username = $_POST['username'];
$password = $_POST['password'];

$cek = mysqli_query($conn, "SELECT * FROM users WHERE username='$username'");

if(mysqli_num_rows($cek) > 0){
    echo json_encode([
        "success" => false,
        "message" => "Username sudah digunakan"
    ]);
}else{

    $insert = mysqli_query($conn,
        "INSERT INTO users(username,password)
        VALUES('$username','$password')"
    );

    if($insert){
        echo json_encode([
            "success" => true,
            "message" => "Registrasi berhasil"
        ]);
    }else{
        echo json_encode([
            "success" => false,
            "message" => "Registrasi gagal"
        ]);
    }
}
?>