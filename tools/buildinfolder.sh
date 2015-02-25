#!/bin/sh

#------------------------------------------------------------------------------
# Little script makes the dart-code more readable.
# Was
#   final ProcessResult result = Process.runSync( "sh", [ '-c', '(cd ${folder} && pub build)' ]);
#

FOLDER=$2
if test "${FOLDER}" == ""
then
    FOLDER=`pwd`
#elif [ -d ${FOLDER} ]
#then
#    echo "$FOLDER does not exist!"
#    exit 2
fi

cd ${FOLDER}

#------------------------------------------------------------------------------
# Functions
#

buildCss() {
    echo "Running sassc + autoprefixer in `pwd`"

    SCSSFOUND=0
    ERRORSTATE=1
    if [ -e "web/demo.scss" ]
    then
        echo "sassc demo.scss -> demo.css && autoprefixer demo.css"
        sassc "web/demo.scss" "web/demo.css" && autoprefixer "web/demo.css"
        ERRORSTATE=$?
        SCCSFOUND=1
    fi

    if [ -e "web/assets/scss/styleguide.scss" ]
    then
        echo "sassc styleguide.scss -> styleguide.scss && autoprefixer styleguide.scss"
        sassc "web/assets/scss/styleguide.scss" "web/assets/css/styleguide.css" && autoprefixer "web/assets/css/styleguide.css"
        ERRORSTATE=$?
        SCCSFOUND=1
    fi

    if [ ${SCCSFOUND} -ne 1 ]; then
        echo "No SCSS-File found!"
        exit 1
    fi

    if [ ${ERRORSTATE} -ne 0 ]; then
        exit ${ERRORSTATE}
    fi

}

buildJS() {
    echo "Building sample in `pwd`"
    # Now - run build
    pub build

    ERRORSTATE=$?
    if [ ${ERRORSTATE} -ne 0 ]; then
        exit ${ERRORSTATE}
    fi
}

pubUpdate() {
    echo "'pub update' in `pwd`"
    pub update

    ERRORSTATE=$?
    if [ ${ERRORSTATE} -ne 0 ]; then
        exit ${ERRORSTATE}
    fi
}

#------------------------------------------------------------------------------
# Options
#

usage() {
    echo
    echo "Usage: `basename $0` [ options ] <folder>"
    echo "   --withcss   Calls sassc + autoprefixer and makes a 'pub build'"
    echo "   --jsonly    'pub build' in `pwd`"
    echo "   --cssonly   Calls sassc + autoprefixer"
    echo "   --update    'pub build' in `pwd`"
    echo
}

case "$1" in
    help|-help|--help)
        usage
    ;;

    withcss|-withcss|--withcss)
        buildCss
        buildJS
    ;;

    jsonly|-jsonly|--jsonly)
        buildJS
    ;;

    cssonly|-cssonly|--cssonly)
        buildCss
    ;;

    update|-update|--update)
        pubUpdate
    ;;

    *)
        usage
    ;;

esac
exit 0
