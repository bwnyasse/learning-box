TAG='dart-functions-framework-moviesdb-backend'

git tag -d $TAG
git push --delete origin refs/tags/$TAG
git checkout main
git tag $TAG
git push origin $TAG