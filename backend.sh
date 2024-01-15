script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
mysql_root_password=$1

func_print_head "disable nodejs"
dnf module disable nodejs -y
func_stat_check $?

func_print_head "install nodejs"
dnf module enable nodejs:18 -y &>>$log_file
dnf install nodejs -y &>>$log_file
func_stat_check $?

if [ $? -ne 0 ]; then
func_print_head "add  application user"
useradd ${app_user} &>>$log_file
fi
func_stat_check $?

func_print_head "create application directory"
mkdir /app &>>$log_file
curl -o /tmp/backend.zip https://expense-artifacts.s3.amazonaws.com/backend.zip &>>$log_file
func_stat_check $?

func_print_head "create application user "
cd /app &>>$log_file
func_stat_check $?

func_print_head "unzip app directory"
unzip /tmp/backend.zip
cd /app &>>$log_file
npm install &>>$log_file
func_stat_check $?

func_print_head "restart backend"
systemctl daemon-reload
systemctl enable backend &>>$log_file
systemctl start backend &>>$log_file
func_stat_check $?

func_print_head "install mysql"
dnf install mysql -y &>>$log_file
func_stat_check $?

func_print_head "load schema"
mysql -h 172.31.42.166 -uroot -p"${mysql_root_password}" < /app/schema/backend.sql &>>$log_file
func_stat_check $?