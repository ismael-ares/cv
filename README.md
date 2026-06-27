# CV — Ismael Ares Fagil

Source for my CV, written in LaTeX and continuously built, deployed, and **scored for ATS
compatibility** on every change.

**Live version:** [ismael-ares.github.io/cv](https://ismael-ares.github.io/cv/)

---

## Contents

- [Overview](#overview)
- [Repository layout](#repository-layout)
- [Building the CV](#building-the-cv)
- [Continuous deployment](#continuous-deployment)
- [ATS report (automated)](#ats-report-automated)
- [The `cv-ats` skill](#the-cv-ats-skill)
- [Setup](#setup)

---

## Overview

The CV is a single LaTeX source (`cv.tex`). Every push to `main` that changes it triggers a
GitHub Actions pipeline that:

1. **Builds** the PDF from LaTeX.
2. **Deploys** it to GitHub Pages.
3. **Scores** it for ATS (Applicant Tracking System) compatibility with Claude Code and
   publishes a markdown report to the run's step summary.

~75% of resumes are filtered out by ATS software before a human reads them, so the CV is
optimized — and continuously checked — against ATS best practices.

## Repository layout

| Path | Purpose |
| --- | --- |
| `cv.tex` | The CV source (LaTeX). |
| `foto.jpg` | Profile photo embedded in the header. |
| `Makefile` | Build targets (`make`, `make docker`, `make clean`). |
| `.github/workflows/deploy.yml` | CI: build → deploy → ATS report. |
| `.claude/skills/cv-ats/SKILL.md` | The `cv-ats` Claude Code skill (audit + scoring). |

## Building the CV

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

## Continuous deployment

`.github/workflows/deploy.yml` runs on every push to `main` that modifies `cv.tex`:

```
push (cv.tex) ─► build ─┬─► deploy   (GitHub Pages)
                        └─► report   (ATS score → step summary)
```

| Job | Depends on | What it does |
| --- | --- | --- |
| `build` | — | Compiles `cv.tex` with `xu-cheng/latex-action` and uploads the Pages artifact. |
| `deploy` | `build` | Publishes the PDF to GitHub Pages. |
| `report` | `build` | Runs Claude Code to score the CV and write the report to the step summary. |

`deploy` and `report` run in parallel after `build`.

## ATS report (automated)

The `report` job uses the official
[`anthropics/claude-code-action`](https://github.com/anthropics/claude-code-action) to run the
[`cv-ats` skill](#the-cv-ats-skill) in **report mode** against `cv.tex`. It produces a
`cv-ats-report.md` and prints it to the **Summary** tab of the workflow run — so each CV change
gets a fresh, scored review without committing anything to the repo.

The report includes:

- An **overall score out of 100** with a rating band.
- A **score breakdown table** by category.
- **Findings grouped by priority** (🔴 HIGH · 🟡 MEDIUM · 🟢 LOW), each tied to a `cv.tex` line
  with a concrete rewrite.
- A list of standards the CV **already meets**.

The job is locked down to `Read,Write,Glob,Skill` tools and never modifies `cv.tex`.

**Where to see it:** open the latest run under the repo's **Actions** tab → the run **Summary**.

## The `cv-ats` skill

`.claude/skills/cv-ats/SKILL.md` is a reusable [Claude Code skill](https://docs.claude.com/en/docs/claude-code/skills)
that audits and optimizes a LaTeX CV for ATS compatibility. It is auto-discovered in any Claude
Code session opened in this repo, and it powers the CI `report` job.

**Invoke it interactively:**

```text
/cv-ats             # audit the CV and list prioritized findings
/cv-ats report      # write a full scored report to cv-ats-report.md
```

Pass a target job description to tune the keyword-coverage check against a specific role.

**What it checks** — a research-backed checklist (sources: UC Irvine, Columbia, Indeed, Jobscan,
and Google's XYZ bullet formula):

- **Quantified achievements** using the XYZ formula — *"Accomplished [X] as measured by [Y] by
  doing [Z]"*.
- **Keyword coverage** — exact terms + acronyms from the job description, no keyword stuffing.
- **Results over tasks**, a **dedicated certifications section**, and sensible **skill
  prioritization**.
- **ATS-safe structure** — single column, standard ALL-CAPS headings, clean dates, live links,
  selectable-text PDF, single page.

**Scoring rubric** (sums to 100):

| Category | Weight |
| --- | --- |
| Quantified achievements / XYZ formula | 25 |
| Keyword coverage & relevance | 20 |
| Results over tasks | 10 |
| Structure & standard headings | 10 |
| Single-column / parsing safety | 10 |
| Certifications presentation | 5 |
| Skill prioritization | 5 |
| Date formatting | 5 |
| Contact & links | 5 |
| Export hygiene / single page | 5 |

Rating bands: **90–100 Excellent · 75–89 Good · 60–74 Fair · <60 Needs work**.

## Setup

The `report` job authenticates Claude Code with an OAuth token. To enable it, add a repository
secret:

1. Generate a token locally (uses your Claude Pro/Max subscription):

   ```bash
   claude setup-token
   ```

2. In the repo: **Settings → Secrets and variables → Actions → New repository secret**
   - **Name:** `CLAUDE_CODE_OAUTH_TOKEN`
   - **Value:** the token from step 1.

Without this secret the `report` job fails at the Claude step; `build` and `deploy` are
unaffected.
