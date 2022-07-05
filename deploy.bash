#!/bin/bash

git_hash=$(git rev-parse HEAD)
love_file=boboman.love
branch=gh-pages

cd game
zip -r ../$love_file .
cd -

tmp_dir=$(mktemp /tmp/love.XXXXXXX)
mv $love_file $tmp_dir

git ls-remote --heads origin $branch && {
  git checkout $branch
  git pull
} || {
  git checkout --orphan $branch
}

rm -rf *
unzip $tmp_dir/$love_file

git add .
git commit -m "Deploy Love.js - based on $git_hash"
git push origin $branch
