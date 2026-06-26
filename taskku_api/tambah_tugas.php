<?php

include "koneksi.php";

$user_id = $_POST['user_id'];
$mata_kuliah = $_POST['mata_kuliah'];
$nama_tugas = $_POST['nama_tugas'];
$deskripsi = $_POST['deskripsi'];
$deadline = $_POST['deadline'];
$status = $_POST['status'];

$query = mysqli_query($conn,
"INSERT INTO tugas
(user_id,mata_kuliah,nama_tugas,deskripsi,deadline,status)
VALUES
('$user_id','$mata_kuliah','$nama_tugas','$deskripsi','$deadline','$status')
");

if($query){
    echo json_encode([
        "success"=>true,
        "message"=>"Tugas berhasil ditambahkan"
    ]);
}else{
    echo json_encode([
        "success"=>false,
        "message"=>"Tugas gagal ditambahkan"
    ]);
}
?>