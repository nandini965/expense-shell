script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

if [ -z "${mysql_root_password}" ]; then
  echo Input mysql root password is missing
  fi
func_print_head "disable mysql"
dnf module disable mysql -y &>>$log_file
func_stat_check $?

func_print_head "install mysql"
dnf install mysql-community-server -y &>>$log_file
func_stat_check $?

func_print_head "restart mysql"
systemctl enable mysqld &>>$log_file
systemctl start mysqld &>>$log_file
func_stat_check $?

func_print_head "add user and password"
mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$log_file
func_stat_check $?