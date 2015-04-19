function listAvailableMuleVersions { 
     reply=(
     	`ls /Applications | grep mule-enterprise-standalone- | sed 's?.*mule-enterprise-standalone-\([^/]*\)?\1?'`
    ); 
}

compctl -K listAvailableMuleVersions setmulehome
