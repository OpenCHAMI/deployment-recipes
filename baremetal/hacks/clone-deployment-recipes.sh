REMOTE="https://github.com/t-h2o/deployment-recipes"
BRANCH="baremetal-quickstart-pcs"
FOLDER="quickstart-pcs"

ssh admin -t "
git clone \
	--branch '${BRANCH}' \
	--depth 1 \
	'${REMOTE}'
ln -s deployment-recipes/quickstart-pcs
"

# do not work :(
#
# git archive \
# 	--remote="${REMOTE}" \
# 	"${BRANCH}:${FOLDER}" | tar -x
