function P = pleiades_setup()
%PLEIADES_SETUP  Problem data for the Pleiades problem (Bari IVP Test Set, II.6).
%
%   P = PLEIADES_SETUP() returns a struct with
%       P.u0       28 x 1 initial state [x; y; x'; y']  at t = 0
%       P.tspan    integration interval [0 3]
%       P.uref     28 x 1 reference solution at t = 3 (Table II.6.2)
%       P.nscd     number of leading components used for scd/mescd (14)
%       P.solvers  cell array of the seven solver names required in part (b)
%       P.rtol     the three relative tolerances
%       P.atol     the three absolute tolerances (atol = rtol)
%       P.h0       the three initial step sizes

% Initial values (Section II.6.2)
x0  = [ 3;  3; -1; -3;  2; -2;    2  ];
y0  = [ 3; -3;  2;  0;  0; -4;    4  ];
dx0 = [ 0;  0;  0;  0;  0;  1.75; -1.5];
dy0 = [ 0;  0;  0; -1.25; 1;  0;   0  ];

P.u0    = [x0; y0; dx0; dy0];
P.tspan = [0 3];

% Reference solution at t = 3, Table II.6.2 (computed on a Cray C90 with
% PSIDE, atol = rtol = 1e-16).  Table II.6.2 lists x1..x7 down its left
% column and y1..y7 down its right column, and likewise x1'..x7' and
% y1'..y7' in its second block, so the ordering below matches the state
% vector of Pleiades.m: positions first, then velocities.
P.uref = [ 0.3706139143970502      % x1
           0.3237284092057233e1    % x2
          -0.3222559032418324e1    % x3
           0.6597091455775310      % x4
           0.3425581707156584      % x5
           0.1562172101400631e1    % x6
          -0.7003092922212495      % x7
          -0.3943437585517392e1    % y1
          -0.3271380973972550e1    % y2
           0.5225081843456543e1    % y3
          -0.2590612434977470e1    % y4
           0.1198213693392275e1    % y5
          -0.2429682344935824      % y6
           0.1091449240428980e1    % y7
           0.3417003806314313e1    % x1'
           0.1354584501625501e1    % x2'
          -0.2590065597810775e1    % x3'
           0.2025053734714242e1    % x4'
          -0.1155815100160448e1    % x5'
          -0.8072988170223021      % x6'
           0.5952396354208710      % x7'
          -0.3741244961234010e1    % y1'
           0.3773459685750630      % y2'
           0.9386858869551073      % y3'
           0.3667922227200571      % y4'
          -0.3474046353808490      % y5'
           0.2344915448180937e1    % y6'
          -0.1947020434263292e1];  % y7'

% Component sets used by the two accuracy measures.  The test set states
% that mescd takes all components of the solution into account (page II-ii),
% while for this problem "the computation of the scd values is based on the
% first 14 components, since they refer to the physically important
% quantities" (page II-6-3).  Both index sets are exposed here so the
% convention can be changed in one place.
P.imescd = 1:28;        % all components
P.iscd   = 1:14;        % positions x1..x7, y1..y7 only

% Part (b): three non-stiff solvers followed by four stiff solvers
P.solvers = {'ode45', 'ode23', 'ode113', 'ode15s', 'ode23s', 'ode23t', 'ode23tb'};

% Part (b): the three (rtol, atol, h0) triples
P.rtol = [1e-4,  1e-7,  1e-10];
P.atol = P.rtol;
P.h0   = [1e-6,  1e-9,  1e-12];
end
