# CV — Ismael Ares Fagil

Latest version: [ismael-ares-netex.github.io/cv](https://ismael-ares-netex.github.io/cv/)

The PDF is automatically compiled and deployed to GitHub Pages on every push to `main` that modifies `cv.tex`.

## Compile manually

Requires a LaTeX distribution (TeX Live, MiKTeX, MacTeX...).

```bash
make
```

Or directly:

```bash
pdflatex cv.tex
pdflatex cv.tex  # second run to resolve references
```

Output: `cv.pdf`

```bash
make clean  # remove build artifacts
```
