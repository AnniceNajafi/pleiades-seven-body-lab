function pleiades_figure(solverName, itol)
%PLEIADES_FIGURE  Part (c): evolution of x1 and y1 over the interval [0, 3].
%
%   PLEIADES_FIGURE() reproduces Figure II.6.2 of the test set using ode113
%   with the middle triple (rtol = atol = 1e-7, h0 = 1e-9), and writes
%   pleiades_x1y1.png and pleiades_x1y1.fig.
%
%   PLEIADES_FIGURE(SOLVER, ITOL) uses the named solver (e.g. 'ode45') and
%   tolerance triple ITOL (1, 2 or 3) from PLEIADES_SETUP instead.

if nargin < 1 || isempty(solverName), solverName = 'ode113'; end
if nargin < 2 || isempty(itol),       itol       = 2;        end

P = pleiades_setup();
rt = P.rtol(itol);  at = P.atol(itol);  hh = P.h0(itol);

opts = odeset('RelTol', rt, 'AbsTol', at, 'InitialStep', hh);

% Dense output grid so the quasi-collisions are resolved in the picture
tout = linspace(P.tspan(1), P.tspan(2), 3001);
[t, u] = feval(str2func(solverName), @Pleiades, tout, P.u0, opts);

x1 = u(:, 1);        % first body, horizontal coordinate
y1 = u(:, 8);        % first body, vertical coordinate

fig = figure('Color', 'w', 'Position', [100 100 760 420]);
plot(t, x1, '-', 'LineWidth', 1.2); hold on
plot(t, y1, '--', 'LineWidth', 1.2); hold off
grid on
xlabel('t')
ylabel('solution components')
legend({'x_1(t)', 'y_1(t)'}, 'Location', 'best')
title(sprintf('Pleiades problem: x_1 and y_1 on [0, 3]  (%s, rtol = atol = %g, h_0 = %g)', ...
              solverName, rt, hh))
xlim(P.tspan)
ax = gca; ax.Toolbar.Visible = 'off';   % keep the toolbar out of the export

exportgraphics(fig, 'pleiades_x1y1.png', 'Resolution', 200);
savefig(fig, 'pleiades_x1y1.fig');
fprintf('Figure written to pleiades_x1y1.png and pleiades_x1y1.fig\n');
end
