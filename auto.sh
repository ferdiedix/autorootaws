#!/bin/bash

# Fungsi untuk menampilkan animasi
function animate() {
    echo -e "\e[36m"
    echo "╔══════════════════════════════════════════╗"
    echo "║    Root Access Configuration Script      ║"
    echo "╚══════════════════════════════════════════╝"
    echo -e "\e[0m"
    
    local i=0
    local spin='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
    while :; do
        printf "\r[%s] ${1}" "${spin:$i:1}"
        i=$(( (i+1) % 10 ))
        sleep 0.1
    done
}

# Fungsi untuk menampilkan status
function show_status() {
    echo -e "\n\e[32m✓ ${1}\e[0m"
}

# Fungsi untuk menampilkan error
function show_error() {
    echo -e "\n\e[31m✗ Error: ${1}\e[0m"
    exit 1
}

# Cek root privileges
if [ "$EUID" -ne 0 ]; then
    show_error "Silakan jalankan script ini dengan sudo atau sebagai root"
fi

# Mulai animasi
animate "Memulai proses konfigurasi..." &
ANIMATE_PID=$!

# Langkah 1: Pindahkan authorized_keys
mv /root/.ssh/authorized_keys /home/ubuntu/ > /dev/null 2>&1 || {
    kill $ANIMATE_PID
    show_error "Gagal memindahkan authorized_keys"
}
kill $ANIMATE_PID && show_status "Berhasil memindahkan authorized_keys")

# Langkah 2: Ubah permission
animate "Mengubah permissions..." &
ANIMATE_PID=$!
chmod 777 /home/ubuntu/authorized_keys > /dev/null 2>&1 || {
    kill $ANIMATE_PID
    show_error "Gagal mengubah permissions ke 777"
}
kill $ANIMATE_PID && show_status "Berhasil mengubah permissions"

# Langkah 3: Edit file dengan regex yang diperbaiki
animate "Memodifikasi authorized_keys..." &
ANIMATE_PID=$!
sed -i -E 's/(,?no-port-forwarding|,?no-agent-forwarding|,?no-X11-forwarding|,?command="echo '"'"'Please login as the user \\"ubuntu\\" rather than the user \\"root\\".'"'"';echo;sleep 10;exit 142")//g' /home/ubuntu/authorized_keys > /dev/null 2>&1 || {
    kill $ANIMATE_PID
    show_error "Gagal memodifikasi authorized_keys"
}
kill $ANIMATE_PID && show_status "Berhasil memodifikasi authorized_keys"

# Langkah 4: Kembalikan permission
animate "Mengembalikan permissions..." &
ANIMATE_PID=$!
chmod 600 /home/ubuntu/authorized_keys > /dev/null 2>&1 || {
    kill $ANIMATE_PID
    show_error "Gagal mengubah permissions ke 600"
}
kill $ANIMATE_PID && show_status "Berhasil mengembalikan permissions"

# Langkah 5: Pindahkan kembali
animate "Mengembalikan file ke lokasi semula..." &
ANIMATE_PID=$!
mv /home/ubuntu/authorized_keys /root/.ssh/ > /dev/null 2>&1 || {
    kill $ANIMATE_PID
    show_error "Gagal mengembalikan authorized_keys"
}
kill $ANIMATE_PID && show_status "Berhasil mengembalikan file ke lokasi semula"

# Tampilkan pesan akhir
echo -e "\e[36m"
echo "╔══════════════════════════════════════════╗"
echo "║    Proses Konfigurasi Berhasil!          ║"
echo "║    Anda bisa login sebagai root sekarang ║"
echo "╚══════════════════════════════════════════╝"
echo -e "\e[0m"
