# Studio aliases
MULE_TOOLING_DEFAULT=mule-tooling
export MULE_TOOLING=$WS_HOME/$MULE_TOOLING_DEFAULT

STUDIO_EXEC_NAME=AnypointStudio
STUDIO_BUILD_PATH=$MULE_TOOLING/$PATH_TO_PRODUCT

function studioproductpath {
	if [ -z $1 ]; then REPO_NAME=$MULE_TOOLING_DEFAULT; else REPO_NAME=$1; fi
	local PATH_TO_PRODUCT=org.mule.tooling.products/org.mule.tooling.studio.product/target/products/studio.product/macosx/cocoa/x86_64/AnypointStudio
	echo $WS_HOME/$REPO_NAME/$PATH_TO_PRODUCT
}

function studioproductini {
	local PRODUCT_PATH=$(studioproductpath $1)
	echo $PRODUCT_PATH/$STUDIO_EXEC_NAME.app/Contents/MacOS/$STUDIO_EXEC_NAME.ini
}

function openstudio {
	local PRODUCT_PATH=$(studioproductpath $1)
	open $PRODUCT_PATH/$STUDIO_EXEC_NAME
}

DEBUG_LINE="-agentlib:jdwp=transport=dt_socket,server=y,suspend=y,address=5005"

function setdebugforstudio {
	local STUDIO_INI=$(studioproductini $1)
	echo $DEBUG_LINE >> $STUDIO_INI
}

function unsetdebugforstudio {
	local STUDIO_INI=$(studioproductini $1)
	sed -i.ini "/^$DEBUG_LINE/d" $STUDIO_INI
}

