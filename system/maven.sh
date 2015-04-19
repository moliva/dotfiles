# maven related
export M2_HOME=/usr/local/Cellar/maven/3.2.2/libexec
export M2=$M2_HOME/bin
export MAVEN_OPTS="-Xmx1G -XX:MaxPermSize=512m -Djava.awt.headless=true"

export PATH=$M2:$PATH
