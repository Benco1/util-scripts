# project name from args
GIT_USER=$1
PROJECT_NAME=$2
ASSET_DEST_DIR=$3
echo Building $PROJECT_NAME for production ...

# repo url
REPO_URL=https://github.com/$GIT_USER/$PROJECT_NAME.git
echo Project repo: $REPO_URL

# get latest commit hash of project
echo Getting hash ...
GIT_HEAD=$(git ls-remote $REPO_URL)
GIT_HASH=$(echo $GIT_HEAD | while read a b; do echo "$a"; done)
echo Latest hash: $GIT_HASH

# create unique directory  
BUILD_DIR=$PROJECT_NAME-$GIT_HASH

# clone repo
git clone $REPO_URL $BUILD_DIR

# list contents of cloned repo
echo Found:
ls -a $BUILD_DIR

# cd to project and npm install
cd $BUILD_DIR
npm install

# check for assets stored locally and, if found, transfer assets to ASSET_DEST in root of project 
PROJECT_ASSETS_DIR=~/src/assets/$PROJECT_NAME
if [ -d "$PROJECT_ASSETS_DIR" ]; then
  # Will enter here if assets directory exists for project
  echo "Assets directory found"
  
  PROJ_ASSET_SUB_DIRS=$(ls $PROJECT_ASSETS_DIR)
  echo The following asset directories were found: $PROJ_ASSET_SUB_DIRS 

  # Now, check in project to see that directory with same name exists
  # If found, copy over contents ...
  for SUB_DIR in $PROJ_ASSET_SUB_DIRS 
  do
    CURR_PROJ_ASSET_PATH=~/src/$BUILD_DIR/$ASSET_DEST_DIR/$SUB_DIR
    echo Checking $CURR_PROJ_ASSET_PATH
    if [ -d "$CURR_PROJ_ASSET_PATH" ]; then
      echo "The corresponding directory $CURR_PROJ_ASSET_PATH was found in the project!"
      cp $PROJECT_ASSETS_DIR/$SUB_DIR/* $CURR_PROJ_ASSET_PATH/.
      echo $( ls $CURR_PROJ_ASSET_PATH | wc -l) items moved to asset folder
    fi
  done

fi
