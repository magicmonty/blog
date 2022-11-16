#!/bin/bash
rm -rf deploy >/dev/null
git clone git@github.com:magicmonty/blog.git --branch gh-pages --single-branch --depth 1 deploy
cd deploy
git rm -rf .
cd ..
bundle exec jekyll build --destination deploy || exit 1
cd deploy
touch .nojekyll
git add --all
git commit -m "Deployment"
git push origin gh-pages
cd ..
rm -rf deploy
git fetch -p
