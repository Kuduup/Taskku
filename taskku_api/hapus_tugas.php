<?php

include "koneksi.php";

$id = $_POST['id'];

$query = mysqli_query($conn,
"DELETE FROM tugas WHERE id='$id'");

if($query){
    echo json_encode([
        "success"=>true,
        "message"=>"Tugas berhasil dihapus"
    ]);
}else{
    echo json_encode([
        "success"=>false,
        "message"=>"Tugas gagal dihapus"
    ]);
}
?>