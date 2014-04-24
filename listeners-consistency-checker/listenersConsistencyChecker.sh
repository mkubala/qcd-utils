#!/bin/sh

function checkMethod() {
    echo "/"$5"/ || print \"MISSING METHOD "$3" ("$2") in "$4" (XML: "$1")\n\"" > tmp.pl
    cat $4 | tr "\n" " " | perl -n tmp.pl
    rm tmp.pl
}

classes=`find mes mes-commercial -name "*.java" -path "*/src/main/*" | tr " " "\n"`
xmls=`find mes mes-commercial -name "*.xml" -path "*/src/main/*" | grep -v -e 'pom.xml' -e 'root-context.xml' -e 'web-context.xml' -e 'web.xml'`
xpathSel='//validatesWith|//model:validatesWith|//onView|//model:onView|//onCreate|//model:onCreate|//onUpdate|//model:onUpdate|//onSave|//model:onSave|//onDelete|//model:onDelete|//listener|//criteriaModifier|//rowStyleResolver|//beforeInitialize|//beforeRender|//afterInitialize'
for file in ${xmls}
do
    xpath ${file} ${xpathSel}  2>/dev/null | tr "\n" " " | tr "><" ">\n<" | perl -n -e 'print if /\S/' | while read element
    do
        type=`echo ${element} | perl -n -e '/([^> ]*:){0,1}([^> ]*).*/g && print $2'`
        class=`echo ${element} | perl -n -e '/.*class="([^"]*)".*/g && print $1'`
        method=`echo ${element} | perl -n -e '/.*method="([^"]*)".*/g && print $1'`

        classRelPath=`echo ${class} | tr "." "/"`

        if [ -n "${classRelPath}" ]
        then
            classFile=`echo ${classes} | tr " " "\n" | grep ${classRelPath}`

            if [ -z ${classFile} ]
            then
                echo "MISSING CLASS ${class} in ${file}@${type}"
            else
                case ${type} in
                    "onView"|"onCreate"|"onUpdate"|"onSave") regex="public(\s)*(final(\s)*){0,1}void(\s)*"${method}"(\s)*\(([^,)])*DataDefinition([^,)])*,([^,)])*Entity([^),])*\)";;
                    "onDelete"|"validatesWith" ) regex="public(\s)*(final(\s)*){0,1}boolean(\s)*"${method}"(\s)*\(([^,)])*DataDefinition([^,)])*,([^,)])*Entity([^),])*\)";;
                    "beforeInitialize"|"beforeRender"|"afterInitialize") regex="public(\s)*(final(\s)*){0,1}void(\s)*"${method}"(\s)*\(([^,)])*ViewDefinitionState([^,)])*\)";;
                    "listener") regex="public(\s)*(final(\s)*){0,1}void(\s)*"${method}"(\s)*\(([^,)])*ViewDefinitionState([^,)])*,([^,)])*ComponentState([^),])*,([^,)])*String\[\]([^),])*\)";;
                    "rowStyleResolver") regex="public(\s)*(final(\s)*){0,1}Set<String>(\s)*"${method}"(\s)*\(([^,)])*Entity([^,)])*\)";;
                    "criteriaModifier") regex="public(\s)*(final(\s)*){0,1}void(\s)*"${method}"(\s)*\(([^,)])*SearchCriteriaBuilder([^,)])*(,([^,)])*FilterValueHolder([^),])*){0,1}\)";;
                    *) echo "ERROR - unsupported type ${type}" ;;
                esac
                checkMethod ${file} ${type} ${method} ${classFile} ${regex}
            fi
        fi

    done
done
