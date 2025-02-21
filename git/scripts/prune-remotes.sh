#! /bin/sh
#
# Remove all local branches that have been removed from the remote repository.
git fetch -p
BRANCHES="$(
  git for-each-ref --format '%(refname) %(upstream:track)' refs/heads |
    awk '$2 == "[gone]" {sub("refs/heads/", "", $1); print $1}'
)"
for branch in $BRANCHES; do
  echo "Pruning: $branch"
  git branch -D $branch
done

