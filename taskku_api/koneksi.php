<?php

$conn = mysqli_connect(
    "localhost",
    "root",
    "",
    "taskku"
);

if(!$conn){
    die("Koneksi gagal");
}

?>