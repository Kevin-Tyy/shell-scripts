# Script hosted here: https://gist.github.com/gianlucaparadise/10286e0b1c5409bd1049d67640fb7c03

# A repository bigger than 1 GB can't be cloned normally.
# In order to clone it, you need to follow the instructions from:
# https://stackoverflow.com/a/53068021/6155481

# To execute:
# sh big-repo-cloner.sh <repo_uri> <repo_destination_folder> [<checkout_branch_name>]
# repo_uri and repo_destination_folder are mandatory
# checkout_branch_name is optional

# To run from web
# curl -sL https://git.io/JvtZ5 | sh -s repo_uri repo_folder

URL="https://github.com/Kevin-Tyy/host_buddy.git"        # mandatory
FOLDER=""D:\shell""     # mandatory
BRANCH="$3"     # optional

if [ -z "$URL" ]
  then
    echo "No Repository URL supplied"
    exit 1
fi

if [ -z "$FOLDER" ]
  then
    echo "No Repository folder supplied"
    exit 1
fi

set -e # exit if some part as exit != 0

# Shallow Clone
# First, turn off compression:

echo
echo "⏬ Cloning master without compression"
echo
git config --global core.compression 0

# Next, let's do a partial clone to truncate the amount of info coming down:

git clone --depth 1 "$URL" "$FOLDER"

# When that works, go into the new directory:

cd "$FOLDER"

echo
echo "⏬ Fixing git config"
echo

# Then to solve the problem of your local branch only tracking master
# open your git config file (.git/config) in the editor of your choice
# where it says:

# [remote "origin"]
#     url=<git repo url>
#     fetch = +refs/heads/master:refs/remotes/origin/master

# change the line

# fetch = +refs/heads/master:refs/remotes/origin/master
# to
# fetch = +refs/heads/*:refs/remotes/origin/*

sed -i '' -e 's/refs\/heads\/master/refs\/heads\/\*/g' .git/config
sed -i '' -e 's/refs\/remotes\/origin\/master/refs\/remotes\/origin\/\*/g' .git/config

echo
echo "⏬ Fetching the first level of the branches"
echo

git fetch --depth 1

echo
echo "⏬ Fetching rest of the clone"
echo

git fetch --unshallow

# or, alternately,
# git fetch --depth=2147483647

# I checkout the input branch only when supplied
if [ ! -z "$BRANCH" ]
  then
    echo
    echo "⏬ Checking out $BRANCH"
    echo

    # Now I checkout our default branch
    git checkout "$BRANCH"
fi

echo "If you are in detached HEAD state, you can run something like the following to fix it:"
echo "git branch --set-upstream-to=origin/master"