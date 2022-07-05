#!/usr/bin/env bash

git_hash=$(git rev-parse HEAD)
love_file=boboman.love
branch=gh-pages

cd game
zip -r ../$love_file .
cd -

tmp_dir=$(mktemp -d 2>/dev/null || mktemp -d -t 'love')
mv $love_file $tmp_dir

git ls-remote --exit-code --heads origin $branch && {
  git checkout $branch
  git pull
} || {
  git checkout --orphan $branch
}

rm -rf *
love.js -t Boboman $tmp_dir/$love_file .
rm -rf $tmp_dir

git add .
git commit -m "Deploy Love.js - based on $git_hash"
git push origin $branch
