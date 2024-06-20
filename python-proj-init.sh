#! /bin/zsh

echo "Starting to create python environment..."

if [[ -f .git ]]
then 
    git init
else
    echo "Git already initialized"
fi

echo "Enter the python version you want to use for this project: (Skip to default to 3.9.18)" 
read pver
PYVER=${pver:-"3.9.18"} 

if [[ -f .python-version ]]
then
    echo "python version by pyenv already set"
    pyenv version
else
    if pyenv local $PYVER
    then 
        echo "Set python version to ${PYVER}"
    else
        echo "Downloading python version ${PYVER} [this may take some time]"
        pyenv install $PYVER
        pyenv local $PYVER
    fi 
fi

python3 --version
pip3 --version

if [[ -f venv ]]
then
    echo "venv already found"
else
    python3 -m venv venv
fi

echo "Initializing virtual environment"
eval source ./venv/bin/activate

echo "Updating pip to latest version"
eval pip install --upgrade pip

if [[ -f .gitignore ]]
then
    echo ".gitignore already exists"
else
    echo ".vscode/" >> .gitignore
    echo ".idea/" >> .gitignore
    echo ".python-version" >> .gitignore
    echo "__pycache__" >> .gitignore
    echo ".tox" >> .gitignore
    echo "*venv*" >> .gitignore
    echo ".DS_Store" >> .gitignore
    echo ".env" >> .gitignore
fi

if [[ -f requirements.txt ]]
then
    echo "requirements.txt file found"
    echo "Installing from requiremnts.txt"
    eval pip3 install -r requirements.txt
else
    echo "Creating requirements.txt file"
    echo "--extra-index-url https://repo-art.cisco.com/artifactory/api/pypi/gis-ngcs-pip/simple" >> requirements.txt
    echo "--trusted-host=repo-art.cisco.com" >> requirements.txt
    touch requirements.txt
fi 

