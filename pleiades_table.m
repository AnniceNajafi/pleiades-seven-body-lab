function txt = pleiades_table(R, fname)
%PLEIADES_TABLE  Part (d): format the run characteristics as a text table.
%
%   TXT = PLEIADES_TABLE(R) formats the table returned by RUN_PLEIADES in
%   the layout of Table II.6.3 of the test set, prints it, and returns it as
%   a character array.  With no argument the results are loaded from
%   pleiades_results.mat.
%
%   TXT = PLEIADES_TABLE(R, FNAME) also writes the table to FNAME
%   (default pleiades_table.txt).
%
%   A dash in the #Jac, #LU or #solve column means the solver does not
%   report that counter: ode45, ode23 and ode113 are explicit and form no
%   Jacobian.  #LU counts LU decompositions and #solve counts the linear
%   systems solved with them; both are shown because the assignment's
%   phrase "#LU (number of LU systems solved)" admits either reading, while
%   Table II.6.3 of the test set tabulates decompositions.

if nargin < 1 || isempty(R)
    S = load('pleiades_results.mat', 'R');
    R = S.R;
end
if nargin < 2, fname = 'pleiades_table.txt'; end

hdr = sprintf('%-8s %7s %7s %7s %7s %7s %8s %8s %10s %6s %7s %8s %9s', ...
              'solver', 'rtol', 'atol', 'h0', 'mescd', 'scd', ...
              'steps', 'accept', '#f', '#Jac', '#LU', '#solve', 'CPU');
rule = repmat('-', 1, numel(hdr));

lines = {'Table: Pleiades problem run characteristics, t in [0, 3]', ...
         R.Properties.Description, '', hdr, rule};

for k = 1:height(R)
    if R.nJac(k)   > 0, jac = sprintf('%6d', R.nJac(k));   else, jac = sprintf('%6s', '-'); end
    if R.nLU(k)    > 0, lu  = sprintf('%7d', R.nLU(k));    else, lu  = sprintf('%7s', '-'); end
    if R.nSolve(k) > 0, sl  = sprintf('%8d', R.nSolve(k)); else, sl  = sprintf('%8s', '-'); end

    lines{end+1} = sprintf('%-8s %7.0e %7.0e %7.0e %7.2f %7.2f %8d %8d %10d %s %s %s %9.4f', ...
        R.solver{k}, R.rtol(k), R.atol(k), R.h0(k), R.mescd(k), R.scd(k), ...
        R.steps(k), R.accept(k), R.nf(k), jac, lu, sl, R.CPU(k)); %#ok<AGROW>

    % blank line between solvers to group the three tolerance triples
    if mod(k, 3) == 0 && k < height(R)
        lines{end+1} = ''; %#ok<AGROW>
    end
end

lines{end+1} = rule;
lines{end+1} = 'mescd = -log10( ||u-uref||_inf / (atol/rtol + ||uref||_inf) ), all 28 components.';
lines{end+1} = 'scd   = -log10( ||(u-uref)./uref||_inf ), the 14 positions x1..x7, y1..y7.';
lines{end+1} = 'steps = accepted + failed attempts;  CPU in seconds (minimum of 5 runs).';
lines{end+1} = '#Jac  = Jacobian evaluations. #LU = LU decompositions (the quantity in';
lines{end+1} = '        Table II.6.3); #solve = linear systems solved with those factors,';
lines{end+1} = '        both given because "#LU (number of LU systems solved)" is ambiguous.';
lines{end+1} = 'A dash marks a counter the solver does not report: ode45, ode23 and ode113';
lines{end+1} = 'are explicit and form no Jacobian and no linear systems.';

txt = strjoin(lines, newline);
disp(txt)

if ~isempty(fname)
    fid = fopen(fname, 'w');
    fprintf(fid, '%s\n', txt);
    fclose(fid);
    fprintf('\nTable written to %s\n', fname);
end
end
