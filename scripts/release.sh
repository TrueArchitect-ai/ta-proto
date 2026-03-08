#!/usr/bin/env bash
# ta-proto release script
# Usage: ./scripts/release.sh [commit message]
# Auto-increments patch version from latest git tag.
set -euo pipefail

cd "$(dirname "$0")/.."

# Get latest tag and bump patch
LATEST_TAG=$(git tag --sort=-v:refname | head -1)
if [[ -z "$LATEST_TAG" ]]; then
  NEXT_TAG="v0.0.1"
else
  # Strip v prefix, split, bump patch
  VERSION="${LATEST_TAG#v}"
  IFS='.' read -r MAJOR MINOR PATCH <<< "$VERSION"
  PATCH=$((PATCH + 1))
  NEXT_TAG="v${MAJOR}.${MINOR}.${PATCH}"
fi

# Commit message
MSG="${1:-${NEXT_TAG}: proto update}"

echo "Current: ${LATEST_TAG:-none}"
echo "Next:    ${NEXT_TAG}"
echo "Message: ${MSG}"
echo ""

# Stage, commit, push, tag, push tag
git add -A
git commit -m "${MSG}" || { echo "Nothing to commit"; exit 0; }
git push origin main
git tag "${NEXT_TAG}"
git push origin "${NEXT_TAG}"

echo ""
echo "Released ${NEXT_TAG}"
echo "Consumers: update go.mod to github.com/TrueArchitect-ai/ta-proto ${NEXT_TAG}"
