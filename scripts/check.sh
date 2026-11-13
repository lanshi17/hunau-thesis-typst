#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

typst compile main.typ

pages=$(pdfinfo main.pdf | awk '/Pages/ {print $2}')
echo "pages: $pages"
if [ "$pages" -lt 20 ]; then
  echo "page count looks too small: $pages"
  exit 1
fi

typst fonts > /tmp/hunau-fonts.txt

if grep -qE 'SimSun|Songti SC|Noto Serif CJK SC|Source Han Serif SC' /tmp/hunau-fonts.txt; then
  echo "CJK serif font: ok"
else
  echo "CJK serif font: missing (install SimSun / Songti SC / Noto Serif CJK SC)"
  exit 1
fi

if grep -qE 'SimHei|Heiti SC|Noto Sans CJK SC|Source Han Sans SC' /tmp/hunau-fonts.txt; then
  echo "CJK sans font: ok"
else
  echo "CJK sans font: missing (install SimHei / Heiti SC / Noto Sans CJK SC)"
  exit 1
fi
