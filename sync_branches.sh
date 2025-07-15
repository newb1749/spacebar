#!/bin/bash

set -e  # 오류 발생 시 중단

REPO_DIR="/c/project/webapps/spacebar"

cd "$REPO_DIR"

echo "### base → develop/kjy 병합 시작 ###"
git checkout develop/kjy
git pull origin develop/kjy

git merge origin/base --no-edit || {
  echo "⚠️ 충돌 발생! base → develop/kjy 병합 수동 처리 필요"
  exit 1
}

git push origin develop/kjy

echo "### develop/kjy → feature/ImDelay 병합 시작 ###"
git checkout feature/ImDelay
git pull origin feature/ImDelay

git merge origin/develop/kjy --no-edit || {
  echo "⚠️ 충돌 발생! develop/kjy → feature/ImDelay 병합 수동 처리 필요"
  exit 1
}

git push origin feature/ImDelay

echo "✅ 자동 병합 완료"
