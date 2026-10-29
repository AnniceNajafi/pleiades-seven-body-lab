# Pleiades Seven-Body Lab

COMP626 Applied Math for Scientists, Project 1: the Pleiades problem (University of Bari IVP Test Set, problem II.6), solved with the MATLAB ODE suite.

**Live site:** https://annicenajafi.github.io/pleiades-seven-body-lab/

The site has two parts:

- **Simulator.** The seven-body problem integrated in the browser with the same Dormand–Prince and Bogacki–Shampine step-size control as MATLAB's `ode45` and `ode23`. Change the solver, tolerance, end time or starting state and watch the orbits. For the unchanged problem it reproduces the steps, `#f`, mescd and scd of the MATLAB `ode45`/`ode23` runs exactly.
- **Assignment guide.** An illustrated literature review, then parts (a)–(f), each with the question, the answer, the results and the MATLAB code that produced them.

## Contents

| Path | What it is |
|---|---|
| `Pleiades.m` | (a) right-hand side of the 28-equation first-order system |
| `pleiades_setup.m` | initial values, reference solution at t = 3, solvers and tolerance triples |
| `run_pleiades.m` | (b) 7 solvers × 3 tolerance triples, run statistics and timings |
| `pleiades_parsestats.m`, `pleiades_accuracy.m` | counter parsing; mescd and scd |
| `pleiades_figure.m` | (c) plot of x₁ and y₁ → `pleiades_x1y1.png` / `.fig` |
| `pleiades_table.m` | (d) results table → `pleiades_table.txt` |
| `project1.m` | runs (b), (c) and (d) in one go |
| `Pleiades.txt` | (e, f) comments on the table and its columns |
| `README.txt` | how to run the MATLAB code interactively |
| `Report.tex`, `Report.pdf`, `references.bib` | the written report |
| `web/pleiades_lab.html` | source of the web page |
| `docs/index.html` | the published page (generated) |

## Running the MATLAB code

From MATLAB, in this folder:

```matlab
>> project1
```

See `README.txt` for running the pieces one at a time.

## Rebuilding the web page

```sh
node web/build_guide.js   # re-embed the .m files, table, figure and Pleiades.txt
node web/build_site.js    # write docs/index.html for GitHub Pages
```
