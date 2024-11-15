script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

func_print_head "install nginx"
dnf install nginx -y &>>$log_file
func_stat_check $?

func_print_head " copy configuration file "
cp roboshop.conf /etc/nginx/default.d/roboshop.conf &>>$log_file
 func_stat_check $?

 func_print_head "remove application user"
 rm -rf /usr/share/nginx/html/* &>>$log_file

 func_print_head "download application file"
 curl -o /tmp/frontend.zip https://expense-artifacts.s3.amazonaws.com/expense-frontend-v2.zip  &>>$log_file

 func_print_head "create application user"
 cd /usr/share/nginx/html &>>$log_file

 func_print_head "unzip file"
 unzip /tmp/frontend.zip &>>$log_file

 func_print_head "restart nginx"
  systemctl enable nginx &>>$log_file
  systemctl start nginx &>>$log_file