"""Turn Phase1.tex into plain LaTeX that pandoc can read. Usage: prepare.py Phase1.tex Phase1.aux out.tex"""
import re,sys
t=open(sys.argv[1],encoding='utf8').read()
b=t[t.index(r'\printchaptertitle{Project Proposal}'):t.index(r'\end{document}')]
labels=dict(re.findall(r'\\newlabel\{((?:fig|tab):[^}]+)\}\{\{(\d+)\}',open(sys.argv[2]).read()))
b=re.sub(r'\\ref\{((?:fig|tab):[^}]+)\}',lambda m:labels[m[1]],b).replace('~',' ')
b=re.sub(r'\\printchaptertitle\{(.*?)\}',r'\\chapter{\1}',b)
for s in [r'\begin{minipage}{\textwidth}',r'\end{minipage}',r'\medskip',r'\bigskip',r'\centering',r'\tablefont']: b=b.replace(s,'')
fig=lambda m:'\\begin{figure}\n\\includegraphics{%s.png}\n\\caption{%s}\n\\end{figure}'%(m[1],m[2])
b=re.sub(r'\\includegraphics\[[^\]]*\]\{diagrams/([\w-]+)\.pdf\}\s*(?:\\captionof\{figure\}|\\caption)\{((?:[^{}]|\{[^{}]*\})*)\}\s*\\label\{[^}]*\}',fig,b)
b=re.sub(r'\\begin\{figure\}\[H\]\s*(\\begin\{figure\})',r'\1',b)
b=re.sub(r'(\\end\{figure\})\s*\\end\{figure\}',r'\1',b)
b=re.sub(r'\\label\{tab:[^}]*\}','',b)
# pandoc's table reader drops a number that opens a cell, so guard it
b=re.sub(r'(?<=& )(?=\d)','{}',b)
b=re.sub(r'(?m)^(?=\d+ &)','{}',b)
assert 'minipage' not in b and b.count(r'\begin{figure}')==b.count(r'\end{figure}')==9
open(sys.argv[3],'w',encoding='utf8').write('\\documentclass{report}\n\\begin{document}\n'+b+'\\end{document}\n')
