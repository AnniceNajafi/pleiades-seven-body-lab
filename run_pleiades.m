function R = run_pleiades(varargin)
%RUN_PLEIADES  Parts (b) and (d): solve Pleiades with the MATLAB ODE suite.
%
%   R = RUN_PLEIADES() integrates the Pleiades problem on [0, 3] with the
%   seven solvers ode45, ode23, ode113 (non-stiff) and ode15s, ode23s,
%   ode23t, ode23tb (stiff), for each of the three (rtol, atol, h0) triples
%
%       rtol = 1e-4,  atol = rtol,  h0 = 1e-6
%       rtol = 1e-7,  atol = rtol,  h0 = 1e-9
%       rtol = 1e-10, atol = rtol,  h0 = 1e-12
%
%   and returns a 21-row table R with the columns required in part (d):
%   solver, rtol, atol, h0, mescd, scd, steps, accept, nf, nJac, nLU, CPU,
%   plus nSolve.  The assignment describes the #LU column as "number of LU
%   systems solved", which MATLAB reports as two separate counters, so both
%   are recorded: nLU is the number of LU decompositions (the quantity in
%   Table II.6.3 of the test set) and nSolve the number of linear systems
%   solved with those factorizations.
%
%   The end-point solution of every run is saved in pleiades_results.mat as
%   the 21 x 28 matrix UEND, so the accuracy measures can be recomputed with
%   PLEIADES_ACCURACY without repeating the integrations.
%
%   R = RUN_PLEIADES('Repeats', K) times each run K times and reports the
%   minimum (default K = 5, as required by part (d)).
%   R = RUN_PLEIADES('Save', false) skips writing pleiades_results.mat.
%
%   Each configuration is run twice over and above the timing repeats: once
%   with 'Stats' on to collect the step/Jacobian/LU counters, and once more
%   through a counting wrapper that records the exact number of right-hand
%   side evaluations (MATLAB prints large counters in %g format, so the
%   printed value loses digits). The timing repeats call the plain
%   right-hand side with statistics off, so the counters never inflate CPU.
%   All solver calls request output arguments: called without them, a MATLAB
%   ODE solver invokes ODEPLOT at every step, which would dominate the
%   measured time.
%
%   See also PLEIADES, PLEIADES_SETUP, PLEIADES_TABLE, PLEIADES_FIGURE.

ip = inputParser;
ip.addParameter('Repeats', 5, @(v) isnumeric(v) && isscalar(v) && v >= 1);
ip.addParameter('Save', true, @(v) islogical(v) || isnumeric(v));
ip.parse(varargin{:});
repeats = ip.Results.Repeats;

P = pleiades_setup();
nfev = 0;                       % counter shared with the nested wrapper

nrows = numel(P.solvers) * numel(P.rtol);
solver = cell(nrows, 1);
[rtol, atol, h0, mescd, scd, steps, accept, nf, nJac, nLU, nSolve, CPU] = ...
    deal(zeros(nrows, 1));
UEND = zeros(nrows, numel(P.u0));   % end-point solutions, saved for reuse

row = 0;
for is = 1:numel(P.solvers)
    solverFcn = str2func(P.solvers{is});

    for it = 1:numel(P.rtol)
        row = row + 1;
        rt = P.rtol(it);  at = P.atol(it);  hh = P.h0(it);

        optsStats = odeset('RelTol', rt, 'AbsTol', at, ...
                           'InitialStep', hh, 'Stats', 'on');
        optsPlain = odeset('RelTol', rt, 'AbsTol', at, ...
                           'InitialStep', hh, 'Stats', 'off');

        fprintf('%-8s rtol=%-8.1e ', P.solvers{is}, rt);

        % --- accuracy and solver statistics -------------------------------
        u = [];   % assigned inside evalc; declared here so the parser sees it
        statsTxt = evalc('[~, u] = solverFcn(@Pleiades, P.tspan, P.u0, optsStats);');
        st = pleiades_parsestats(statsTxt);
        uend = u(end, :).';

        % --- exact count of right-hand side evaluations -------------------
        nfev = 0;
        [~, ~] = solverFcn(@countedRHS, P.tspan, P.u0, optsPlain);

        % --- CPU time: minimum over 'Repeats' runs ------------------------
        best = inf;
        for k = 1:repeats
            tstart = tic;
            [~, ~] = solverFcn(@Pleiades, P.tspan, P.u0, optsPlain);
            best = min(best, toc(tstart));
        end

        [m, s] = pleiades_accuracy(uend, P.uref, rt, at, P.imescd, P.iscd);

        solver{row} = P.solvers{is};
        rtol(row)   = rt;
        atol(row)   = at;
        h0(row)     = hh;
        mescd(row)  = m;
        scd(row)    = s;
        accept(row) = st.accept;
        steps(row)  = st.accept + st.failed;   % attempted = accepted + failed
        nf(row)     = nfev;
        nJac(row)   = st.njac;
        nLU(row)    = st.nlu;
        nSolve(row) = st.nsolve;
        CPU(row)    = best;
        UEND(row,:) = uend.';

        fprintf('mescd=%5.2f scd=%5.2f steps=%7d  CPU=%7.4f s\n', ...
                m, s, steps(row), best);
    end
end

R = table(solver, rtol, atol, h0, mescd, scd, steps, accept, nf, nJac, ...
          nLU, nSolve, CPU);
R.Properties.VariableNames = {'solver','rtol','atol','h0','mescd','scd', ...
                              'steps','accept','nf','nJac','nLU','nSolve','CPU'};
R.Properties.Description = sprintf( ...
    'Pleiades problem, t in [0 3], CPU = min of %d runs, %s', repeats, char(datetime('now')));

if ip.Results.Save
    save('pleiades_results.mat', 'R', 'P', 'UEND');
    fprintf('\nResults saved to pleiades_results.mat\n');
end

    function du = countedRHS(t, u)
        % Wrapper that counts every right-hand side evaluation, including
        % those made by the stiff solvers when differencing a Jacobian.
        nfev = nfev + 1;
        du = Pleiades(t, u);
    end
end
