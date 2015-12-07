# aliases
alias ttoolic='ttool -ignoreCertificates'
alias ttoolp0='ttool -pathId 0'
alias ttoolicp0='ttool -pathId 0 -ignoreCertificates'

function listTestToolCompletions { 
     reply=(
        -pmKey 
        -fullDomain 'https://' 'https://localhost:10443' 'https://.cloudhub.io'
        -paths 
        -pathId 0
        -ignoreCertificates 
        -iapp
        -name `find $PM_HOME/tools/testtool-configs -type f -name '*.iapp' | sed 's?.*/\([^/]*\)\.iapp?\1?'`
        -f
        -xmlPath `find . -type f -name '*.xml' | sed 's?\./\(.*\)?\1?'`
        -listIapps
    ); 
}

compctl -K listTestToolCompletions ttool
