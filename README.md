# Cinema Ticket Reservation and Revenue Management System (CTRMS)

<!-- ## TBD: add proj. description and diagrams and all that pretty stuff -->


## Assembly Development Setup
* **Assembler:** MASM with the Irvine32 library.
* **Environment:** Microsoft Visual Studio. Do not use Godbolt, NASM, or GAS. 
* **Deliverable:** The project must compile as a single `.asm` file.

## LaTeX Documentation Setup
* **Engine:** TeX Live or TinyTeX.
* **Dependencies:** Before compiling the Phase 1 documents, install the required packages via terminal:
  `tlmgr install inputenc fontenc geometry array graphicx float caption fancyhdr titlesec fmtcount setspace tocbibind tocloft xpatch booktabs chngcntr glossaries enumitem lipsum pdfpages pgf standalone lm`
* **Compilation:** Use `latexmk -pdf` via terminal or the LaTeX Workshop extension in VS Code, the VS extension should handle the compilation and dependencies for you on pressing `ctrl + s`.