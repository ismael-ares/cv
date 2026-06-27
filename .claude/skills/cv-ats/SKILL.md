---
name: cv-ats
description: Audit and optimize a LaTeX CV (cv.tex) for ATS (Applicant Tracking System) compatibility — quantified achievements, clean single-column structure, standard section headings, keyword coverage, a dedicated certifications section, and single-page export. Use when reviewing or improving a resume/CV to pass ATS filters.
---

# CV ATS Optimizer

Audit and improve a CV for **ATS (Applicant Tracking System)** compatibility against a
research-backed checklist. ~75% of resumes are filtered out by software before a human ever
reads them, and 97%+ of Fortune 500 companies use an ATS — so structure and wording matter as
much as content.

This skill is tuned for this repository (`cv.tex`, compiled via `make` / `make docker`), but the
checklist is generic and applies to any resume.

## When to use

- "Review/audit my CV for ATS" or "optimize my resume".
- Before applying to a specific role (pass the job description to tune keyword coverage).
- After editing `cv.tex`, to confirm it still meets the standards and compiles to one page.

## Workflow

1. **Read** `cv.tex`. If the user provides a target **job description**, read it too and use it
   to drive the keyword-coverage check.
2. **Audit** against the checklist below. Produce findings grouped by priority
   **HIGH → MEDIUM → LOW**. For each finding give:
   - the specific location (`cv.tex:<line>`),
   - what's wrong and why it hurts ATS parsing or recruiter scanning,
   - a concrete rewrite or fix.
   - Skip items that are **already compliant** (note them briefly as ✅ so the user sees they
     were checked) — never propose redundant changes.
3. **Apply** fixes with `Edit` **only when the user asks**. Audit-only by default.
4. **Verify** after any edit: run `make docker` (or `make` if a local LaTeX install is present),
   then confirm the PDF still builds and stays **one page** with selectable text.

## ATS standards checklist

### HIGH — Quantify impact with the XYZ formula
Every experience bullet should follow Google's XYZ pattern (Laszlo Bock):
**"Accomplished [X] as measured by [Y] by doing [Z]"** — an action verb + a quantified result
+ the method/tools. Numbers (%, time saved, count, $, throughput) are what make achievements
credible. If exact figures are unknown, use ranges or before/after states.

- Bad: *"Managed Docker images for microservices."*
- Good: *"Cut deployment time ~20% by optimizing Docker layer caching and GitHub Actions
  pipelines."*

Audit the responsibility-style bullets in the Experience section and rewrite them as measurable
outcomes.

### HIGH — Keyword coverage
ATS rank resumes by how well they match the job description's terms.
- Mirror the **exact** wording from the target job posting for skills and titles.
- Include both the **full term and the acronym** (e.g. "CI/CD" *and* "Continuous Integration",
  "Kubernetes" *and* "K8s") — ATS often don't equate synonyms or abbreviations.
- Embed keywords inside achievement bullets, not just a skills list.
- **Never keyword-stuff** — modern ATS flag unnatural repetition. Aim for natural density
  (~10–15%).

### MEDIUM — Dedicated certifications section
Certifications buried inside a skills list are easy to miss. Give them their own section with the
**certification name first**, in a scannable list (Name — Issuer, Year).

### MEDIUM — Results over tasks
Convert task descriptions ("Managed…", "Was responsible for…") into outcomes about security,
efficiency, reliability, or resource savings. Lead with the impact.

### LOW — Skill prioritization
List skills in order of relevance to the target role. Put your specialty first (e.g. DevOps /
CI-CD) and demote general/background skills (sysadmin/networking) and markup languages
(HTML/CSS) to the end so they don't dilute the headline expertise.

### LOW — Clean, standard structure
- Use **standard ALL-CAPS section headings** the parser recognizes: EXPERIENCE, EDUCATION,
  SKILLS, CERTIFICATIONS, SUMMARY/PROFILE. (Localized equivalents are fine if the CV is not in
  English, but keep them conventional.)
- Avoid special characters, em-dashes (—), or decorative symbols in **headings** — they can
  break section mapping.
- Keep spacing between sections uniform; remove stray blank lines.

### LOW — Single-column layout & parsing risks
ATS parse best in a **single column**. Multi-column blocks, tables, text boxes, images, icons,
and skill-rating bars can be dropped or scrambled (turned into `[NULL]`/gibberish).
- Flag any two-column header (e.g. name beside a photo) and embedded **photos** as parsing
  risks. Note this is a **tradeoff**: a photo may be a deliberate design/regional choice, so
  surface it rather than silently removing it.
- Keep contact details in the document **body**, never in PDF headers/footers (often ignored).

### LOW — Dates
Use a consistent, parseable format: `Month YYYY` or `MM/YYYY`. Avoid apostrophe abbreviations
like `'25`. Make sure date ranges are unambiguous so the ATS can compute tenure.

### LOW — Contact & links
- LinkedIn/GitHub should be **live hyperlinks** and the email **selectable text**.
- Include **City + Country** for geographic filters; a full street address is unnecessary.

### LOW — Export hygiene
Export as a **PDF with selectable text** (not a scanned image / not flattened), so OCR isn't
required. Avoid graphics-based skill meters.

## Notes on this repo's CV (`cv.tex`)

Already compliant (don't re-flag unless changed):
- ALL-CAPS headings via `\cvsection` + `\MakeUppercase`.
- LinkedIn/GitHub as `\href` hyperlinks; email is selectable; "A Coruña, España" present.
- Single page; standard margins (`geometry`); `lmodern` font.

Known tradeoff to surface: the header uses a two-column `minipage` with `\includegraphics`
(photo). That is an ATS parsing risk but also a deliberate design choice — mention it, let the
user decide.

After applying changes, always recompile with `make docker` and confirm the output is still one
page.

## Sources

- UC Irvine — Mastering ATS Career Guide (2025)
- Columbia University — Optimizing Your Resume for ATS
- Indeed — How To Write an ATS Resume
- Jobscan — ATS resume formatting mistakes / ATS-friendly format checklist
- Google XYZ bullet formula (Laszlo Bock) — via Teal, Wonsulting
