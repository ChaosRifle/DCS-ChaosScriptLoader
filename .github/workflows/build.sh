#!/bin/bash

apt-get -y update
apt-get -y install git
apt-get -y install git-lfs
apt-get -y install openssh-client

git --version


echo ===========================================================================
echo 'configuring script..'

GIT_SERVER="github.com"
USER_NAME="ChaosRifle"
USER_EMAIL="ChaosBuildScript@CBS.ca"

OUTPUT_REPO="ChaosTheory"
MERGE_REPO=$OUTPUT_REPO

OUTPUT_DIR="output_temp"
REPO_DIR=$PWD
MERGE_DIR="$HOME/git/$MERGE_REPO"

echo 'script configured'
echo ===========================================================================
echo 'configuring github install..'
#get github up and running
mkdir --parents "$HOME/.ssh"
DEPLOY_KEY_FILE="$HOME/.ssh/deploy_key"
echo "${SSH_DEPLOY_KEY}" > "$DEPLOY_KEY_FILE"
chmod 600 "$DEPLOY_KEY_FILE"
SSH_KNOWN_HOSTS_FILE="$HOME/.ssh/known_hosts"
ssh-keyscan -H "$GIT_SERVER" > "$SSH_KNOWN_HOSTS_FILE"
export GIT_SSH_COMMAND="ssh -i "$DEPLOY_KEY_FILE" -o UserKnownHostsFile=$SSH_KNOWN_HOSTS_FILE"



git config --global user.email $USER_EMAIL
git config --global user.name $USER_NAME
# workaround for https://github.com/cpina/github-action-push-to-another-repository/issues/103
git config --global http.version HTTP/1.1

echo 'github configured.'
echo ===========================================================================
echo 'main script begins..'

echo 'cloning output repo to build commit/push'
mkdir "$HOME/git"
mkdir "$HOME/git/outputrepo"
GIT_CMD_REPOSITORY="git@$GIT_SERVER:$USER_NAME/$OUTPUT_REPO.git"
git clone --branch "$BRANCHSELECTION" "$GIT_CMD_REPOSITORY" "$HOME/git/outputrepo"
cp -r "$HOME/git/outputrepo" "$OUTPUT_DIR"
    
echo ===========================================================================

mkdir "$OUTPUT_DIR"
if [ -d "./miz" ]; then
  echo 'miz directory found'
  cp -r "./miz" "$OUTPUT_DIR"
fi
if [ -d "./Saved Games" ]; then
  echo 'Saved Games directory found'
  cp -r "./Saved Games" "$OUTPUT_DIR"
fi
if [ -d "./scripts" ]; then
  echo 'scripts directory found'
  cp -r "./scripts" "$OUTPUT_DIR"
  
  echo ===========================================================================

  if [ -f "./scripts/CONFIG_%MissionName%.lua" ]; then
    echo 'config file needing merging detected..'
    rm -rf $OUTPUT_DIR/scripts/CONFIG_%MissionName%.lua

    # get existing branch config in ChaosTheory
    echo 'cloning repo to get merge file..'
    mkdir "$HOME/git"
    mkdir $MERGE_DIR
    GIT_CMD_REPOSITORY="git@$GIT_SERVER:$USER_NAME/$MERGE_REPO.git"
    git clone --branch "$BRANCHSELECTION" "$GIT_CMD_REPOSITORY" "$MERGE_DIR"
    echo 'merge directory contents:'
    ls $MERGE_DIR
    
    echo 'clone completed'
    echo ===========================================================================
    echo 'atempting merge..'
    MERGE_FILE="$MERGE_DIR/scripts/CONFIG_%MissionName%.lua"
    INJECT_FILE="$REPO_DIR/scripts/CONFIG_%MissionName%.lua"

    STARTLINE='----------------------------------------------------------------- Script Config -----------------------------------------------------------------' #`head -n1 "$INJECT_FILE"`
    ENDLINE='--------------------------------------------------------- ChaosScriptLoader Post-Config ---------------------------------------------------------' #`echo $STARTLINE | sed 's/---- /-- End /'`

    cp $MERGE_FILE ./contents1.lua
    sed -i -ne "0,/^$STARTLINE/{s/^$STARTLINE//p;d;}" -e p ./contents1.lua #everything after a point
    tail -n +2 ./contents1.lua > temp.lua ; mv temp.lua ./contents1.lua         #trim white space that will be added by cat

    cp ./contents1.lua ./contents2.lua
    sed -i "0,/$ENDLINE/!d" ./contents2.lua #all up to point
    sed -i "s/$ENDLINE//" ./contents2.lua
    head -n -1 ./contents2.lua > temp.lua ; mv temp.lua ./contentsfinal.lua     #trim white space that will be added by cat

    cp $INJECT_FILE ./header.lua
    sed -i "0,/$STARTLINE/!d" ./header.lua #all up to point
    #sed -i "s/$STARTLINE//" ./header.lua
    #head -n -1 ./header.lua > temp.lua ; mv temp.lua ./header.lua     #trim white space that will be added by cat

    cp $INJECT_FILE ./footer.lua
    sed -i -ne "0,/^$ENDLINE/{s/^$ENDLINE//p;d;}" -e p ./footer.lua #everything after a point
    tail -n +2 ./footer.lua > temp.lua ; mv temp.lua ./footer.lua         #trim white space that will be added by cat
    echo $ENDLINE > ./footerlineone.lua
    cat ./footerlineone.lua ./footer.lua > temp.lua ; mv temp.lua ./footer.lua
    rm -rf ./footerlineone.lua

    cat ./header.lua ./contentsfinal.lua ./footer.lua > $OUTPUT_DIR/scripts/CONFIG_%MissionName%.lua


    echo ===========================================================================
    echo 'cleaning up savestate files'

    rm -rf ./contents1.lua
    rm -rf ./contents2.lua
    rm -rf ./contentsfinal.lua
    rm -rf ./header.lua
    rm -rf ./footer.lua
  fi
fi


echo ===========================================================================
echo 'stamping time..'
# timestamp the work, script ends, pushes contents to repo via cpina's script
echo "generated_at: $(date)" > variables.yml
date > $REPO_DIR/"$OUTPUT_DIR"/.build_date.txt