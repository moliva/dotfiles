# Studio aliases
export STUDIO_EXEC_NAME=AnypointStudio
export STUDIO_BUILD_PATH=$MULE_TOOLING/org.mule.tooling.products/org.mule.tooling.studio.product/target/products/studio.product/macosx/cocoa/x86_64/AnypointStudio

export OPEN_STUDIO_EXEC_PATH=$STUDIO_BUILD_PATH/$STUDIO_EXEC_NAME
alias openstudio="open $STUDIO_BUILD_PATH/$STUDIO_EXEC_NAME"
alias setdebugforstudio="echo '-agentlib:jdwp=transport=dt_socket,server=y,suspend=y,address=5005\n' >> $STUDIO_BUILD_PATH/$STUDIO_EXEC_NAME.app/Contents/MacOS/$STUDIO_EXEC_NAME.ini"

