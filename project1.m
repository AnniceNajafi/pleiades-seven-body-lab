%PROJECT1  Reproduce every deliverable of Project 1 (parts b, c, d).
%
%   Run this script from the folder that contains the project files:
%
%       >> project1
%
%   It performs the full solver sweep (part b), writes the table of run
%   characteristics (part d) to pleiades_table.txt, and produces the plot of
%   x1 and y1 (part c) as pleiades_x1y1.png.  Expect the sweep to take a
%   couple of minutes; ode23s at rtol = 1e-10 is by far the slowest run.
%
%   See README.txt for how to run the individual pieces interactively.

R = run_pleiades();             % part (b): 7 solvers x 3 tolerance triples
pleiades_table(R);              % part (d): run characteristics table
pleiades_figure('ode113', 2);   % part (c): x1 and y1 over [0, 3]
