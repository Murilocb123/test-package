## Variaveis configuraveis

_DEPENDENCIES_PATH="${DEPENDENCIES_PATH:-./lib/}"
_POM_PATH="${POM_PATH:-./pom.xml}"
_MODEL_VERSION="${MODEL_VERSION:-4.0.0}"
_GROUP_ID="${GROUP_ID:-org.eclipse.birt.runtime}"
_ARTIFACT_ID="${ARTIFACT_ID:-birt-runtime-libs}"
_VERSION="${VERSION:-1.0.0}"
_PACKAGING="${PACKAGING:-pom}"
_LIBS_GZ_PATH="${LIBS_GZ_PATH:-./lib.tar.gz}"
_REPOSITORY_PATH="${REPOSITORY_PATH:-./repo}"

mkdir -p "$_DEPENDENCIES_PATH"

tar -xzf "$_LIBS_GZ_PATH"

touch "$_POM_PATH"

#Limpa o arquivo
echo "" > $_POM_PATH

echo -e "Initializing repo with:
- Model version: $_MODEL_VERSION 
- Group id: $_GROUP_ID
- Ertifact id: $_ARTIFACT_ID
- Version $_VERSION 
- Packaging $_PACKAGING"

echo -e "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" >$_POM_PATH
echo -e "<project xmlns=\"http://maven.apache.org/POM/4.0.0z\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:schemaLocation=\"http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd\">" >>$_POM_PATH
echo -e "    <modelVersion>$_MODEL_VERSION</modelVersion>" >>$_POM_PATH
echo -e "    <groupId>$_GROUP_ID</groupId>" >>$_POM_PATH
echo -e "    <artifactId>$_ARTIFACT_ID</artifactId>" >>$_POM_PATH
echo -e "    <version>$_VERSION</version>" >>$_POM_PATH
echo -e "    <packaging>$_PACKAGING</packaging>" >>$_POM_PATH
echo "Installing dependencies from $_DEPENDENCIES_PATH"
echo -e "    <dependencies>" >>$_POM_PATH

for file in $_DEPENDENCIES_PATH/*.jar; do
    echo "---------------------------------------------------"
    echo "---Installing $file --------------"
    #Pega a versao do arquivo após o _ e antes do .jar
    version=$(echo $file | grep -oP '(?<=_)(.*)(?=.jar)')
    [[ -z $version ]] && version=$(echo "1.0") || echo $version
    #Pega o nome do arquivo sem a versao
    artifactId=$(echo $file | grep -oP '[^/]*.(?=_)')
    [[ -z $artifactId ]] && artifactId=$(echo $(echo $file | grep -oP '[^/]*.(?=.jar)')) || echo $artifactId

    echo -e "        <dependency>" >>$_POM_PATH
    echo -e "           <groupId>org.eclipse.birt.runtime</groupId>" >>$_POM_PATH
    echo -e "            <artifactId>$artifactId</artifactId>" >>$_POM_PATH
    echo -e "            <version>$version</version>" >>$_POM_PATH
    echo -e "        </dependency>" >>$_POM_PATH
    echo "artifactid: $artifactId"
    echo "version: $version"
    mvn install:install-file -Dfile=$file -DlocalRepositoryPath=$_REPOSITORY_PATH -DgroupId=org.eclipse.birt.runtime -DartifactId=$artifactId -Dversion=$version -Dpackaging=jar
    echo "---------------------------------------------------"
done

echo -e "    </dependencies>" >>$_POM_PATH
echo -e "</project>" >>$_POM_PATH
