script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
mysql_root_password=$1

if [ -z "$mysql_root_password" ]; then
echo input mysql_root_password is missing
exit 1
fi
func_print_head "install mysql"
dnf install mysql-server -y &>>$log_file
func_stat_check $?

func_print_head "restart mysql"
systemctl enable mysqld &>>$log_file
systemctl start mysqld &>>$log_file
func_stat_check $?

#func_print_head "add user and password"
#mysql_secure_installation --set-root-pass "$mysql_root_password" &>>$log_file
func_print_head "set root password"
mysql --user=root --execute="ALTER USER 'root'@'localhost' IDENTIFIED WITH 'mysql_native_password' BY '${mysql_root_password}'; FLUSH PRIVILEGES;" &>>$log_file
func_stat_check $?

