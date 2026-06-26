# CV — Ismael Ares Fagil

Latest version: [ismael-ares.github.io/cv](https://ismael-ares.github.io/cv/)

The PDF is automatically compiled and deployed to GitHub Pages on every push to `main` that modifies `cv.tex`.

## Compile manually

**With Docker** (recommended, no local LaTeX required):

```bash
make docker
```

**With a local LaTeX distribution** (TeX Live, MiKTeX, MacTeX...):

```bash
make
```

Output: `cv.pdf`

```bash
make clean  # remove build artifacts
```
