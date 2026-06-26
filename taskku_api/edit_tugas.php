<?php

include "koneksi.php";

$id = $_POST['id'];
$mata_kuliah = $_POST['mata_kuliah'];
$nama_tugas = $_POST['nama_tugas'];
$deskripsi = $_POST['deskripsi'];
$deadline = $_POST['deadline'];
$status = $_POST['status'];

$query = mysqli_query($conn, "
UPDATE tugas SET
mata_kuliah='$mata_kuliah',
nama_tugas='$nama_tugas',
deskripsi='$deskripsi',
deadline='$deadline',
status='$status'
WHERE id='$id'
");

if($query){

    echo json_encode([
        "success" => true,
        "message" => "Tugas berhasil diupdate"
    ]);

}else{

    echo json_encode([
        "success" => false,
        "message" => mysqli_error($conn)
    ]);

}

?>