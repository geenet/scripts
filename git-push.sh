#DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )"/.. && pwd )"
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )"/ && pwd )"
cd "$DIR"
git add -A .
git commit -m "$1"
git push

