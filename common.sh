app_user=expense
script=$(realpath "$0")
script_path=$(dirname "$script")
log_file=/tmp/expense.log

func_print_head() {
echo -e "\e[36m>>>>>>>>>>>>> $* <<<<<<<<<<<<<<<<<<\e[0m"
echo -e "\e[36m>>>>>>>>>>>>> $1 <<<<<<<<<<<<<<<<<<\e[0m" &>>$log_file
}
 func_stat_check() {
if [ $1 -eq 0 ]; then
   echo -e "\e[32mSUCCESS\e[0m"
else
   echo -e "\e[31mFAILURE\e[0m"
   echo "refer log_file /tmp/expense.log/ for more information"
   exit 1
fi
}
func_app_prereq() {

}