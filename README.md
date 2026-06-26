# 📚 TaskKu - Manajemen Tugas Kuliah

TaskKu adalah aplikasi mobile berbasis Flutter yang dibuat untuk membantu mahasiswa dalam mengelola tugas kuliah agar lebih terorganisir. Aplikasi ini memungkinkan pengguna mencatat tugas, melihat daftar tugas, mengubah informasi tugas, menghapus tugas, serta memantau status penyelesaian tugas melalui dashboard yang sederhana dan mudah digunakan.

## ✨ Fitur

- 🔐 Login dan Registrasi
- 📋 Dashboard Tugas
- ➕ Tambah Tugas
- ✏️ Edit Tugas
- 🗑️ Hapus Tugas
- 📊 Statistik Total, Belum Selesai, dan Selesai
- 🔍 Filter Tugas berdasarkan Status

## 🛠️ Teknologi yang Digunakan

- Flutter
- Dart
- PHP Native
- MySQL
- XAMPP
- HTTP Package

## 📂 Struktur Database

### Tabel Users
- id
- username
- password

### Tabel Tugas
- id
- user_id
- mata_kuliah
- nama_tugas
- deskripsi
- deadline
- status

## 📱 Tampilan Aplikasi

- Login
- Registrasi
- Dashboard
- Tambah Tugas
- Edit Tugas

## 🚀 Cara Menjalankan

1. Clone repository ini.
2. Jalankan XAMPP (Apache dan MySQL).
3. Import database MySQL.
4. Letakkan folder `taskku_api` di dalam folder `htdocs`.
5. Jalankan perintah:

```bash
flutter pub get
flutter run
```

## 👨‍💻 Developer

**IMRON ROSADI**

Project Akhir Semester - Mobile Programming
