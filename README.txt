COMP626 Applied Math for Scientists - Project 1
Pleiades problem (University of Bari IVP Test Set, problem II.6)

--------------------------------------------------------------------------
FILES
--------------------------------------------------------------------------
Pleiades.m             (a) right-hand side of the Pleiades problem in first
                           order form (II.6.3), 28 equations
pleiades_setup.m           problem data: initial values, interval, reference
                           solution at t = 3 (Table II.6.2), solver list and
                           the three (rtol, atol, h0) triples
pleiades_accuracy.m        mescd and scd as defined in part (d)
pleiades_parsestats.m      reads the counters printed by odeset('Stats','on')
run_pleiades.m         (b) runs the 7 solvers x 3 tolerance triples and
                           collects the run characteristics
pleiades_figure.m      (c) plot of x1 and y1 over [0, 3]
pleiades_table.m       (d) formats and writes the table of run characteristics
project1.m                 runs (b), (c) and (d) in one go

Generated output:
pleiades_results.mat       all results as a MATLAB table
pleiades_table.txt     (d) the table of run characteristics
pleiades_x1y1.png/.fig (c) the figure
Pleiades.txt           (e,f) comments on the table columns and on the
                           results, with a copy of the table appended
Report.tex / Report.pdf    report: an introduction on the Pleiades in human
                           history, then the assignment, the method and the
                           answer to each part. Compile with
                               pdflatex Report
                               bibtex   Report
                               pdflatex Report
                               pdflatex Report
references.bib             bibliography for the introduction (BibTeX, cited in
                           order of appearance via ibliographystyle{unsrt})
make_report_table.py       turns pleiades_table.txt into report_table.tex, so
                           the numbers in the report are never retyped
report_table.tex           generated: the results table as a LaTeX tabular

--------------------------------------------------------------------------
HOW TO RUN
--------------------------------------------------------------------------
Everything at once (takes roughly two to three minutes; ode23s at
rtol = 1e-10 dominates the running time):

    >> cd <folder containing these files>
    >> project1

Interactive use, piece by piece:

  1. Evaluate the right-hand side at the initial point:

        >> P = pleiades_setup();
        >> du = Pleiades(0, P.u0)

  2. Solve once with a solver and tolerance of your choice:

        >> opts = odeset('RelTol',1e-7,'AbsTol',1e-7,'InitialStep',1e-9);
        >> [t, u] = ode113(@Pleiades, [0 3], P.u0, opts);
        >> [mescd, scd] = pleiades_accuracy(u(end,:).', P.uref, 1e-7, 1e-7)

     The component sets of the two measures default to those of the test
     set (mescd on all 28 components, scd on the 14 positions) and can be
     overridden per call or changed once in pleiades_setup.m:

        >> [m14, s14] = pleiades_accuracy(u(end,:).', P.uref, 1e-7, 1e-7, 1:14, 1:14)

  3. Full sweep of part (b). Use fewer timing repeats for a quick look:

        >> R = run_pleiades();                  % 5 repeats, as required
        >> R = run_pleiades('Repeats', 1);      % quick version
        >> R = run_pleiades('Save', false);     % do not overwrite the .mat

     R is a MATLAB table, so single runs can be inspected directly:

        >> R(strcmp(R.solver,'ode15s'), :)
        >> sortrows(R, 'CPU')

  4. The end-point solution of every run is stored in the .mat file as the
     21 x 28 matrix UEND, so the accuracy measures can be recomputed under
     a different convention without repeating any integration:

        >> S = load('pleiades_results.mat');
        >> pleiades_accuracy(S.UEND(1,:).', S.P.uref, S.R.rtol(1), S.R.atol(1), 1:14, 1:14)

  5. Table of part (d), printed and written to pleiades_table.txt:

        >> pleiades_table(R)
        >> pleiades_table()          % reloads pleiades_results.mat

  6. Figure of part (c), written to pleiades_x1y1.png and .fig:

        >> pleiades_figure()                    % ode113, rtol = 1e-7
        >> pleiades_figure('ode45', 3)          % any solver / triple 1,2,3

--------------------------------------------------------------------------
NOTES
--------------------------------------------------------------------------
* The state vector is u = [x(1:7); y(1:7); x'(1:7); y'(1:7)], so component 1
  is x1 and component 8 is y1.
* mescd uses the norm form required by part (d) and all 28 components; scd
  is componentwise relative on the 14 positions, following the test set.
  Pleiades.txt explains both, and warns that the test set's own mescd is a
  different formula, so only the scd columns may be compared with
  Table II.6.3.
* The table carries both #LU (LU decompositions) and #solve (linear systems
  solved), since the assignment's "#LU (number of LU systems solved)" admits
  either reading.
* CPU is the minimum of five runs of the solver alone, with statistics off
  and no counting wrapper, so the instrumentation does not affect the timing.
* The number of function evaluations is counted by a wrapper around the
  right-hand side rather than read from the printed statistics, because
  MATLAB prints large counters in %g format and loses digits.
* No analytic Jacobian is supplied, so the stiff solvers difference their
  own. This is what inflates #f for ode23s, which forms a Jacobian at every
  step.
