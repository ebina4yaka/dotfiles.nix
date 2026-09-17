#!/usr/bin/env bash
# meiseki の PostToolUse hook を C ロケールで起動するラッパー。
#
# meiseki-lint-core.sh は日本語判定に grep の多バイト範囲式 [ぁ-んァ-ヶ一-龯] を使う。
# GNU grep + glibc の UTF-8 ロケールではこれが "Invalid collation character" になり、
# 判定が必ず失敗して対象外(exit 3)へ落ちる。textlint は一度も起動しない。
# C ロケールならバイト列として一致するため、ロケールだけ固定して本体へ委譲する。
# upstream が範囲式をやめたら、このラッパーごと hook 登録を削除してよい。
set -u

# ponytail: バージョンは辞書順で最後を取るだけ。複数バージョンが同居したら見直す。
script=$(ls -d "$HOME"/.claude/plugins/cache/bamboo-nova-ja-tools/meiseki/*/scripts/meiseki-check.sh 2>/dev/null | tail -1)
[ -n "$script" ] || exit 0

exec env LC_ALL=C "$script"
