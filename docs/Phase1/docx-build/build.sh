#!/bin/zsh
# Rebuilds ../Phase1_Group102.docx from Phase1.tex. Needs pdflatex, pdftoppm, pandoc, node.
# On macOS with Word installed it also fills in the contents and lists; otherwise press
# Cmd/Ctrl+A then F9 in Word after opening the file.
set -e
HERE=${0:A:h}; P=${HERE:h}; W=$(mktemp -d); mkdir -p $W/img
(cd $W && npm init -y >/dev/null && npm i docx >/dev/null 2>&1)
(cd $P && for i in 1 2; do pdflatex -interaction=nonstopmode -halt-on-error -output-directory=$W Phase1.tex >/dev/null; done)
for f in $P/diagrams/*.pdf; do pdftoppm -r 200 -png -singlefile $f $W/img/${f:t:r}; done
python3 $HERE/prepare.py $P/Phase1.tex $W/Phase1.aux $W/body.tex
pandoc $W/body.tex -f latex -t json --top-level-division=chapter -o $W/doc.json
NODE_PATH=$W/node_modules node $HERE/build.js $W/doc.json $W/img $P/images/ASUNewLogo.png $W/raw.docx
if [[ -d "/Applications/Microsoft Word.app" ]]; then
  C=~/Library/Containers/com.microsoft.Word/Data/Documents/ctrms-build; mkdir -p $C
  cp -f $W/raw.docx $C/in.docx; rm -f $C/out.docx
  osascript <<A
tell application "Microsoft Word"
  set d to open file name "$C/in.docx"
  update fields (text object of d)
  update fields (text object of d)
  save as d file name "$C/out.docx" file format format document
  close active document saving no
end tell
A
  cp -f $C/out.docx $P/Phase1_Group102.docx
else
  cp -f $W/raw.docx $P/Phase1_Group102.docx
fi
echo "Wrote $P/Phase1_Group102.docx"
