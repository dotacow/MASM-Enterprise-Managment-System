% thesis-library.cls - ASU Master's Thesis class
% Based on the provided Masters.sty file

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{thesis-library}[2023/02/15 ASU Master's Thesis class]

\LoadClass[12pt,a4paper]{report}


% Required packages
\usepackage[T1]{fontenc}
\usepackage{mathptmx}
\usepackage{titlesec}
\usepackage{graphicx}
\usepackage{fmtcount}

\usepackage{fancyhdr}
%\usepackage{etoolbox}
\usepackage{setspace}

\usepackage{geometry}
\usepackage{hyperref}

\usepackage{tocbibind}
\usepackage{tocloft}
\usepackage{xpatch}
\usepackage{booktabs}

\RequirePackage{amsmath}
\usepackage{chngcntr}

% \usepackage[acronym]{glossaries}
\usepackage[nopostdot,nonumberlist,acronym]{glossaries}

\usepackage{caption}
\usepackage{pdflscape}
\usepackage{enumitem}
\usepackage{pifont}
\usepackage[table]{xcolor}
%\definecolor{lightgray}{gray}{0.9}
\usepackage{float}
\usepackage{multicol}

\usepackage{pdflscape}
\usepackage{enumitem}
\usepackage{pifont}

\usepackage[table]{xcolor}
%\definecolor{lightgray}{gray}{0.9}

\usepackage{lipsum}


\usepackage{caption}
\usepackage{float}
\usepackage{multicol}

\usepackage{pdfpages}

\hypersetup{
    colorlinks=true,    % set true if you want colored links
    linkcolor=blue,    % choose some suitable color
    citecolor=blue,    % choose some suitable color
    urlcolor=blue,     % choose some suitable color
    linktoc=all        % make table of contents links clickable
}



% Add the set space package and enable double spacing
\doublespacing

% Discourage word splitting
%\hyphenpenalty=10000
%\exhyphenpenalty=10000

% Margins
\setlength{\headheight}{28.61798pt}
\setlength{\textwidth}{16cm}
\setlength{\textheight}{23cm}
\setlength{\oddsidemargin}{0.5cm}
\setlength{\evensidemargin}{0.5cm}
\setlength{\topmargin}{-1cm}


% Section headings
\titleformat{\chapter}[display]
{\normalfont\huge\bfseries\filcenter}{\chaptertitlename\ \thechapter}{20pt}{\Huge}


\titlespacing*{\chapter}{0pt}{-80pt}{40pt}
\titleformat{\section}
{\normalfont\large\bfseries}{\thesection}{1em}{}
\titleformat{\subsection}
{\normalfont\normalsize\bfseries}{\thesubsection}{1em}{}



% Table of contents
\renewcommand{\contentsname}{} %Table of Contents}
\setlength{\cftbeforetoctitleskip}{-4.5em}
\setcounter{tocdepth}{2}
\setcounter{secnumdepth}{3}
\renewcommand{\cftchapleader}{\cftdotfill{\cftdotsep}}

% Reduce space before chapters in ToC
\setlength{\cftbeforechapskip}{0.5em}
%\setlength{\cftbeforesecskip}{0.3em} 
% Reduce space before subsections in ToC
%\setlength{\cftbeforesubsecskip}{0.2em} 



% List of Figures
\renewcommand{\cftfigpresnum}{Figure }
\renewcommand{\cftfigaftersnum}{} % Optional: Adds a colon : after the figure number
\setlength{\cftfigindent}{0pt} % Remove indentation for the list of figures entries
\setlength{\cftfignumwidth}{2.5em} % Adjust according to the width of "Figure XX" if needed

\newlength{\mylen} % A new length for adjusting space
\settowidth{\mylen}{\bfseries ------} % Assume "Figure 999" is the widest label
\addtolength{\cftfignumwidth}{\mylen} % Adjust the width for the figure number in the list

\renewcommand{\listfigurename}{} % Empty the list of figures name if needed
\newcommand{\listoffiguresname}{
  \cleardoublepage
  \phantomsection
  \addcontentsline{toc}{chapter}{List of Figures} % Add to table of contents
  \chapter*{\centering \Huge List of Figures} % Customize the header

 \noindent
  \begin{tabular*}{\textwidth}{@{\extracolsep{\fill}} p{0cm} p{0cm} r}
    \textbf{Figure} & \textbf{Description} & \textbf{Page} \\
    \bottomrule
  \end{tabular*}

  \vspace*{-3.2cm}
  \addtocontents{toc}{\protect\setcounter{tocdepth}{-1}}
  \listoffigures
  \addtocontents{toc}{\protect\setcounter{tocdepth}{2}}
}% This sets the numbering counter to start from 1
\counterwithout{figure}{chapter} 



% List of Tables
\renewcommand{\cfttabpresnum}{Table\ } % Add space after "Table" for separation
\renewcommand{\cfttabaftersnum}{} % Optional: Adds a colon : after the table number
\setlength{\cfttabindent}{0pt} % Remove indentation for the list of tables entries
\setlength{\cfttabnumwidth}{2.5em} % Adjust according to the width of "Table XX" if needed

% Calculate space needed for the "Table X" text
\newlength{\mylentab} % A new length for adjusting space
\settowidth{\mylentab}{\bfseries ------} % Assume "Table 999:" is the widest label
\addtolength{\cfttabnumwidth}{\mylentab} % Adjust the width for the table number in the list

\renewcommand{\listtablename}{}
\newcommand{\listoftablesname}{
  \cleardoublepage
  \phantomsection
  \addcontentsline{toc}{chapter}{List of Tables} % Add to table of contents
  \chapter*{\centering \Huge List of Tables} % Center and enlarge header

  \noindent
  \begin{tabular*}{\textwidth}{@{\extracolsep{\fill}} p{0cm} p{0cm} r}
    \textbf{Table} & \textbf{Description} & \textbf{Page} \\
    \bottomrule
  \end{tabular*}
  
  \vspace*{-3.2cm}
  \addtocontents{toc}{\protect\setcounter{tocdepth}{-1}}
  \listoftables
  \addtocontents{toc}{\protect\setcounter{tocdepth}{2}}
}
% This sets the numbering counter to start from 1
\counterwithout{table}{chapter} 



% List of Equations
\newcommand{\listequationsname}{
%  \cleardoublepage
  \phantomsection
  \chapter*{\centering \Huge List of Equations} % Center and enlarge header
  \addcontentsline{toc}{chapter}{List of Equations} % Add to table of contents
  \vspace*{-0.75cm}

 \noindent
  \begin{tabular*}{\textwidth}{@{\extracolsep{\fill}} l l r}
    \textbf{\normalsize Equation} & \textbf{\normalsize Description} & \textbf{\normalsize Page} \\
    \addlinespace[-3mm]
    \bottomrule
  \end{tabular*}

  \vspace*{-1.3cm}
}
\newlistof{myequations}{equ}{\listequationsname}
\newcommand{\myequations}[1]{
  % Adds 10 explicit spaces before the description
  \addcontentsline{equ}{myequations}{\protect\numberline{Equation \theequation}\hspace*{4em}#1}\par
}
% Change the equation numbering format
\makeatletter
\def\tagform@#1{\maketag@@@{(Equation \ignorespaces#1\unskip\@@italiccorr)}}
\makeatother

% This sets the numbering counter to start from 1
\renewcommand{\theequation}{\arabic{equation}}




% List of Abbreviations
\newcommand{\listofabbreviations}{
  \printglossary[type=\acronymtype, style=customStyle, title=List of Abbreviations, toctitle=List of Abbreviations]
}
\makeglossaries
% Define a new glossary style
\newglossarystyle{customStyle}{
  \renewenvironment{theglossary}%
    {
    \begin{tabular}{l p{\dimexpr\textwidth-2cm}}
    } % Adjust Description column width
    {\end{tabular}}
  \renewcommand*{\glossaryheader}{\textbf{\underline{Symbol}} & \textbf{\underline{Description}} \\}
  \renewcommand*{\glsgroupheading}[1]{}
  \renewcommand*{\glossaryentryfield}[5]{\glstarget{##1}{##2} & ##3 \\}
  \renewcommand*{\glossarysubentryfield}[6]{\glstarget{##2}{\quad ##3} & ##4 \\}
  \renewcommand*{\glsgroupskip}{}
}

% Redefine glossary term formatting commands
\renewcommand*{\glstextformat}[1]{\textcolor{black}{#1}}




% Document information
\newcommand{\universitylogo}{\includegraphics[width=5.5cm]{images/ASUNewLogo.png}}
\newcommand{\titleA}{\thesisTitle}
\newcommand{\titleB}{\subtitle}
\newcommand{\by}{\byLabel}
\newcommand{\authorname}{\studentName}
\newcommand{\supervisor}{\supervisorLabel}
\newcommand{\supervisorNameStyle}{\supervisorName}
\newcommand{\cosupervisor}{\coSupervisorLabel}
\newcommand{\cosupervisorNameStyle}{\coSupervisorName}
\newcommand{\degreeLineA}{\degreeLineALabel}
%\newcommand{\degreeLineB}{\degreeLineBLabel}
%\newcommand{\major}{\majorName}
\newcommand{\university}{\universityName}
\newcommand{\deanship}{\deanshipName}
\newcommand{\region}{\regionName}
\newcommand{\degreeyear}{\degreeyearName}
\newcommand{\degreemonth}{\degreemonthName}


% Cover page (first page)
\newcommand{\makecoverpage}{
\newgeometry{left=2cm,right=2cm,top=2cm,bottom=-2cm}
\begin{titlepage}
\begin{center}
    {\universitylogo}\\[0.75cm] %0.5
    %Huge
    %%% {\Large \textbf{\titleA}}\\[0.5cm]
    {\Large \textbf{\fontsize{20pt}{24pt}\selectfont \titleA}}\\[1.25cm]
    %%% {\Large \textbf{\titleB}}\\[0.75cm] %1.25
    %{\Large \textbf{\fontsize{20pt}{24pt}\selectfont \titleB}}\\[0.75cm]

    {\fontsize{17pt}{22pt}\selectfont \by}\\[0.0cm]
    {\fontsize{17pt}{22pt}\selectfont \textbf{\authorname}}\\[0.75cm]
        {\fontsize{17pt}{22pt}\selectfont \supervisor}\\[0.0cm]
    {\fontsize{17pt}{22pt}\selectfont \textbf{\supervisorNameStyle}}\\[1.5cm]
    
    {\fontsize{17pt}{22pt}\selectfont \degreeLineA}\\[0.75cm]
    %{\fontsize{17pt}{22pt}\selectfont \textbf{\degreeLineB}}\\[0.0cm]
    %{\fontsize{17pt}{22pt}\selectfont \textbf{\major}}\\[1.0cm]
    {\fontsize{17pt}{22pt}\selectfont \university}\\[0.0cm]
    {\fontsize{17pt}{22pt}\selectfont \deanship}\\[0.75cm]
    {\fontsize{17pt}{22pt}\selectfont \region}\\[0.0cm]
    {\fontsize{17pt}{22pt}\selectfont \degreemonth~\degreeyear}

\end{center}
\end{titlepage}
\restoregeometry
}

% Approval page
 \newcommand{\makeapprovalpage}{
    \begin{titlepage}
    \begin{center}
% {\LARGE \university}\\[1cm]
% {\universitylogo}\\[1.5cm]
    \end{center}
    \end{titlepage}
}

% Print Chapter Title
\newcommand{\printchaptertitle}[1]{
  \cleardoublepage
  \pagestyle{empty}
  \refstepcounter{chapter}
  \edef\currentchapternumber{\thechapter}
  \edef\currentchaptertitle{\chaptername\ \Numberstring{chapter}: #1}
  \vspace*{\fill}
  \begin{center}
    \huge\textbf{\chaptername\ \Numberstring{chapter}\\[1ex] #1}
  \end{center}
  \vspace*{\fill}
  \cleardoublepage
  \thispagestyle{firstcontentpage}
  \addcontentsline{toc}{chapter}{\chaptername\ \Numberstring{chapter}: #1}

  \pagestyle{fancy}
  \fancyhf{}
  \cfoot{\thepage}
}

\fancypagestyle{firstcontentpage}{
  \fancyhf{}
  \chead{\textbf{\currentchaptertitle} \\\vspace{1.5pt}}
  \cfoot{\thepage}
  \renewcommand{\headrulewidth}{0.4pt}
}


\fancypagestyle{fancy}{
  \fancyhf{}
  \cfoot{\thepage}
  \renewcommand{\headrulewidth}{0pt}
}





% Cover page (last page)
\newcommand{\titleBFa}{\subtitleFa}
\newcommand{\titleBFb}{\subtitleFb}
\newcommand{\byF}{\byLabelF}
\newcommand{\authornameF}{\studentNameF}
\newcommand{\supervisorF}{\supervisorLabelF}
\newcommand{\supervisorNameStyleF}{\supervisorNameF}
\newcommand{\cosupervisorF}{\coSupervisorLabelF}
\newcommand{\cosupervisorNameStyleF}{\coSupervisorNameF}

% Define a new Cover Page command for the last page
\newcommand{\makefinalcoverpage}{
  \newgeometry{left=2cm,right=2cm,top=2cm,bottom=3.5cm}
  \thispagestyle{plain} % Ensure page numbering continues
  \begin{center}
      {\universitylogo}\\[1.25cm] %0.5
      {\Large \textbf{\fontsize{20pt}{24pt}\selectfont \titleBFa}}\\[0.25cm]
      {\Large \textbf{\fontsize{20pt}{24pt}\selectfont \titleBFb}}\\[1.25cm]
      {\fontsize{17pt}{22pt}\selectfont \byF}\\[0.0cm]
      {\fontsize{17pt}{22pt}\selectfont \textbf{\authornameF}}\\[0.05cm]
      {\fontsize{16pt}{22pt}\selectfont \authornumberF}\\[0.75cm]
      {\fontsize{17pt}{22pt}\selectfont \supervisorF}\\[0.0cm]
      {\fontsize{17pt}{22pt}\selectfont \textbf{\supervisorNameStyleF}}\\[0.75cm]
      {\fontsize{17pt}{22pt}\selectfont \cosupervisorF}\\[0.0cm]
      {\fontsize{17pt}{22pt}\selectfont \textbf{\cosupervisorNameStyleF}}\\[1.5cm]
  \end{center}
  \restoregeometry
}

