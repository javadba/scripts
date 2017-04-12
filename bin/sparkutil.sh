ns() { netstat -an | grep LISTEN | grep tcp | egrep ${1:-".*"} ; }
nss() { ns | grep -v 127. | grep -v tcp6 ; }
jup() { jupyter-notebook --port ${1:-8182} --notebook-dir=${2:-/shared/jup/py} "${@:2}" ; }
jups() { jupyter-notebook --port 8183 --notebook-dir=/shared/jup/scala "$@" ; }
startjup() { jup ; }
startjups() { jups ; }
stopjuppy() { kill -9 $(ps -ef | grep jupyt | grep [p]y | awk '{print $2}') ; }
stopjups() { kill -9 $(ps -ef | grep jupyt | grep [s]cala | awk '{print $2}') ; }
stopjup() { stopjuppy && stopjups ; }
checkhdfs() {
bold=$(tput bold)
normal=$(tput sgr0)
echo "${bold}HDFS NameNode${normal}: $(ps -ef | grep [N]ameNode) ;"
echo "${bold}HDFS DataNode${normal}: $(ps -ef | grep [D]ataNode) ;"
echo "${bold}HDFS Health${normal}: $(hdfs dfsadmin -report);"
 }
checkspark() {
bold=$(tput bold)
normal=$(tput sgr0)
echo "${bold}Spark Master${normal}: $(ps -ef | grep spark | grep [M]aster) ;"
echo "${bold}Spark Worker${normal}: $(ps -ef | grep spark | grep [W]orker) ;"
 }
checkjup() {
bold=$(tput bold)
normal=$(tput sgr0)
echo "${bold}Jupyter${normal}: $(ps -ef | grep [j]upyt) ;"
}
checkall() {
 checkspark
 checkhdfs
  checkjup
}
restarthdfs() {
 stophdfs.sh; starthdfs
hdfs dfsadmin -safemode leave
}
restartspark() {
  stopspark; startspark
}
stopspark() {  stop-all.sh ; }
startspark() { start-all.sh ; }
stophdfs() {  stop-dfs.sh ; }
starthdfs() { start-dfs.sh ; }
restartjup() {
        stopjup # kill -9 $(ps -ef | grep [j]upyt | awk '{print $2}')
        jup
}
restartall() {
        if [ $# -ne 1 ]; then
          echo "Usage: restartall [home|office]"
          return 1
        fi

        stopjup
        stoplivy
        stopspark
        stophdfs

        if [ "$1" == "home" ]; then
                homefull
        else
                officefull
        fi

        starthdfs
	        startspark
        startlivy
        startjup
}
export ZEPHOME=/git/zeppelin
startzep() { $ZEPHOME/bin/zeppelin-daemon.sh --conf $ZEPHOME/conf start ; }
stopzep() { kill -9 $(ps -ef | grep [z]epp | awk '{print $2}') ; }
restartzep() { stopzep && restartzep ; }
startlivy() { cd /git/livy;
    echo "tail -n 70 -f /tmp/livy.log" >> /tmp/xyz && chmod u+x /tmp/xyz && open -a /Applications/utilities/Terminal.app /tmp/xyz
   # nohup bin/livy-server > /tmp/livy.log 2>&1 &
 }
stoplivy() { kill -9 $(ps -ef | grep [l]ivy | awk '{print $2}') ; }
restartlivy() { stoplivy && startlivy ; }
