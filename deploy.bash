#!/usr/bin/env bash

git_current_branch=$(git rev-parse --abbrev-ref HEAD)
git_hash=$(git rev-parse HEAD)
love_file=boboman.love
branch=gh-pages
git_remote=origin

cd game
zip -r ../$love_file .
cd -

tmp_dir=$(mktemp -d 2>/dev/null || mktemp -d -t 'love')
mv $love_file $tmp_dir

git ls-remote --exit-code --heads $git_remote $branch && {
  git checkout $branch
  git branch --set-upstream-to=$git_remote/$branch gh-pages
  git pull $git_remote $branch
} || {
  git checkout --orphan $branch
}

rm -rf *
love.js -c -t Boboman $tmp_dir/$love_file .
rm -rf $tmp_dir

git add .
git commit -m "Deploy Love.js - based on $git_hash"
git push $git_remote $branch
git checkout $git_current_branch
