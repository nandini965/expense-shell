mysql_root_password = $1
func_print_head "disable mysql"
dnf module disable mysql -y &>>$log_file

func_print_head "install mysql"
dnf install mysql-community-server -y &>>$log_file

func_print_head "restart mysql"
systemctl enable mysqld &>>$log_file
systemctl start mysqld &>>$log_file

func_print_head "add user and password"
mysql_secure_installation --set-root-pass ${mysql_root_password} &>>$log_file
mysql -uroot -pExpenseApp@1 &>>$log_file