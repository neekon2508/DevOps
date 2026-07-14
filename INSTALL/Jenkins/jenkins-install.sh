#!/bin/bash
# =============================================================
# jenkins-install.sh
# Cài đặt Jenkins trên Ubuntu (Noble/24.04+)
# Xử lý GPG key cũ + key mới (rotate tháng 12/2024)
# =============================================================

set -e  # Dừng ngay nếu có lỗi

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log()  { echo -e "${GREEN}[INFO]${NC}  $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC}  $1"; }
err()  { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

# -------------------------------------------------------------
# 1. Kiểm tra quyền root
# -------------------------------------------------------------
if [[ $EUID -ne 0 ]]; then
  err "Script phải chạy với quyền root. Dùng: sudo bash jenkins-install.sh"
fi

# -------------------------------------------------------------
# 2. Kiểm tra Java (Jenkins yêu cầu Java 17+)
# -------------------------------------------------------------
log "Kiểm tra Java..."
if ! java -version &>/dev/null; then
  warn "Java chưa được cài. Đang cài OpenJDK 17..."
  apt-get install -y openjdk-17-jdk
else
  JAVA_VER=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}' | cut -d. -f1)
  if [[ "$JAVA_VER" -lt 17 ]]; then
    warn "Java $JAVA_VER quá cũ. Đang cài OpenJDK 17..."
    apt-get install -y openjdk-17-jdk
  else
    log "Java $JAVA_VER OK."
  fi
fi

# -------------------------------------------------------------
# 3. Xóa key/repo Jenkins cũ (tránh xung đột)
# -------------------------------------------------------------
log "Dọn dẹp cấu hình Jenkins cũ (nếu có)..."
rm -f /etc/apt/sources.list.d/jenkins.list \
      /etc/apt/keyrings/jenkins* \
      /usr/share/keyrings/jenkins*

# -------------------------------------------------------------
# 4. Import GPG key cũ (2023) qua URL chính thức
# -------------------------------------------------------------
log "Tải GPG key Jenkins 2023 (EF5975CA)..."
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key \
  | gpg --dearmor -o /usr/share/keyrings/jenkins-keyring.gpg \
  || err "Không tải được key từ pkg.jenkins.io. Kiểm tra kết nối mạng."

chmod 644 /usr/share/keyrings/jenkins-keyring.gpg

# -------------------------------------------------------------
# 5. Import GPG key mới (2025) – rotate tháng 12/2024
#    Key ID: 7198F4B714ABFC68  (hết hạn 2028-12-21)
# -------------------------------------------------------------
log "Import GPG key Jenkins 2025 (7198F4B714ABFC68)..."
gpg --keyserver keyserver.ubuntu.com \
    --recv-keys 7198F4B714ABFC68 2>/dev/null \
  || gpg --keyserver hkps://keys.openpgp.org \
         --recv-keys 7198F4B714ABFC68 2>/dev/null \
  || err "Không import được key mới từ keyserver. Kiểm tra firewall/proxy."

gpg --export 7198F4B714ABFC68 \
  | tee -a /usr/share/keyrings/jenkins-keyring.gpg > /dev/null

log "Xác nhận keyring:"
gpg --show-keys /usr/share/keyrings/jenkins-keyring.gpg

# -------------------------------------------------------------
# 6. Thêm Jenkins repository
# -------------------------------------------------------------
log "Thêm Jenkins repository..."
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.gpg] \
https://pkg.jenkins.io/debian-stable binary/" \
  | tee /etc/apt/sources.list.d/jenkins.list > /dev/null

# -------------------------------------------------------------
# 7. Cập nhật apt và cài Jenkins
# -------------------------------------------------------------
log "Cập nhật danh sách package..."
apt-get update

log "Cài đặt Jenkins..."
apt-get install -y jenkins

# -------------------------------------------------------------
# 8. Khởi động Jenkins
# -------------------------------------------------------------
log "Kích hoạt và khởi động Jenkins..."
systemctl enable jenkins
systemctl start jenkins

# Chờ Jenkins khởi động (tối đa 30s)
for i in {1..6}; do
  sleep 5
  if systemctl is-active --quiet jenkins; then
    break
  fi
  warn "Đang chờ Jenkins khởi động... ($((i*5))s)"
done

# -------------------------------------------------------------
# 9. Kết quả
# -------------------------------------------------------------
if systemctl is-active --quiet jenkins; then
  SERVER_IP=$(hostname -I | awk '{print $1}')
  INIT_PASS=$(cat /var/lib/jenkins/secrets/initialAdminPassword 2>/dev/null || echo "(chưa có)")

  echo ""
  echo -e "${GREEN}=============================================${NC}"
  echo -e "${GREEN}  Jenkins đã cài đặt thành công!${NC}"
  echo -e "${GREEN}=============================================${NC}"
  echo -e "  URL:            http://${SERVER_IP}:8080"
  echo -e "  Mật khẩu admin: ${YELLOW}${INIT_PASS}${NC}"
  echo -e "  Kiểm tra:       systemctl status jenkins"
  echo -e "${GREEN}=============================================${NC}"
else
  err "Jenkins khởi động thất bại. Xem log: journalctl -u jenkins -n 50"
fi