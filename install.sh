depencenciespath="${DEPENDENCIES_PATH:-./lib}"
echo "Installing dependencies from $depencenciespath"
for file in $depencenciespath/*.jar; do
    echo "---------------------------------------------------"
    echo "---Installing $file --------------"
    #Pega a versao do arquivo após o _ e antes do .jar
    version=$(echo $file | grep -oP '(?<=_)(.*)(?=.jar)')
    [[ -z $version ]] && version=$(echo "1.0") || echo $version
    #Pega o nome do arquivo sem a versao
    artifactId=$(echo $file | grep -oP '[^/]*.(?=_)')
    [[ -z $artifactId ]] && artifactId=$(echo $(echo $file | grep -oP '[^/]*.(?=.jar)')) || echo $artifactId

    echo "artifactid: $artifactId"
    echo "version: $version"
    mvn install:install-file -Dfile=$file -DgroupId=org.eclipse.birt.runtime -DartifactId=$artifactId -Dversion=$version -Dpackaging=jar
    echo "---------------------------------------------------"
done
