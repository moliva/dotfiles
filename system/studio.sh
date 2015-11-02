
PATH_TO_PRODUCT=org.mule.tooling.products/org.mule.tooling.studio.product/target/products/studio.product/macosx/cocoa/x86_64/AnypointStudio
STUDIO_EXEC_NAME=AnypointStudio

function __studioproductpathfromcontext {
	if [ -z $1 ]; then return 1; else
	       	if [ $1 = "/" ]; then __path="Error trying to find path from this context"; else
			if [ -d "$1/$PATH_TO_PRODUCT" ]; then __path=$1; else 
				__dir=$(dirname $1)
				__path=$(__studioproductpathfromcontext $__dir)
			fi
		fi
	fi
	echo $__path
}

function studioproductpath {
	if [ -z $1 ]; then REPO_NAME=$(__studioproductpathfromcontext `pwd`); else REPO_NAME=$WS_HOME/$1; fi
	echo $REPO_NAME/$PATH_TO_PRODUCT
}

function studioproductini {
	local PRODUCT_PATH=$(studioproductpath $1)
	echo $PRODUCT_PATH/$STUDIO_EXEC_NAME.app/Contents/MacOS/$STUDIO_EXEC_NAME.ini
}

function editstudioproductini {
	local ini_file=$(studioproductini $1)
	edit $ini_file
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

