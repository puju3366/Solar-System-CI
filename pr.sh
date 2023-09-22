echo "Opening a Pull Request"

curl -u bob:bob@123 -X 'POST' \
  'http://controlplane:3000/api/v1/repos/bob/gitops-argocd/pulls' \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{
  "assignee": "bob",
  "assignees": [
    "bob"
  ],
  "base": "master",
  "body": "Updated deployment specification with a new image version.",
  "head": "feature-gitea",
  "title": "Updated Solar System Image"
}'

echo "Success"
