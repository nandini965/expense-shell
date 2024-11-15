script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
mysql_root_password=$1

if [ -z "$mysql_root_password" ]; then
echo input mysql_root_password is missing
exit 1
fi

func_print_head "disable nodejs"
dnf module disable nodejs -y &>>$log_file
func_stat_check $?

func_print_head "install nodejs"
dnf module enable nodejs:20 -y &>>$log_file
dnf install nodejs -y &>>$log_file
func_stat_check $?

 func_print_head "add application user"
 id ${app_user} &>>/tmp/expense.log
if [ $? -ne 0 ]; then
   useradd ${app_user} &>>/tmp/expense.log
 fi
 func_stat_check $?

func_print_head "create application directory"
mkdir /app &>>$log_file
curl -o /tmp/backend.zip https://expense-artifacts.s3.amazonaws.com/backend.zip &>>$log_file
func_stat_check $?

func_print_head "unzip app directory"
cd /app &>>$log_file
func_stat_check $?

func_print_head "unzip app directory"
unzip /tmp/backend.zip
func_stat_check $?

func_print_head "create app directory"
cd /app &>>$log_file
func_stat_check $?

func_print_head "install npm"
npm install &>>$log_file
func_stat_check $?

func_print_head "copy service file"
cp ${script_path}/backend.service /etc/systemd/system/backend.service &>>$log_file
func_stat_check $?

func_print_head "restart backend"
systemctl daemon-reload
systemctl enable backend &>>$log_file
systemctl restart backend &>>$log_file
func_stat_check $?


func_print_head "install mysql"
dnf install mysql-server -y &>>$log_file
func_stat_check $?

func_print_head "load schema"
mysql -h 172.31.40.169 -uroot -p"$mysql_root_password" < /app/schema/backend.sql &>>$log_file
func_stat_check $?


