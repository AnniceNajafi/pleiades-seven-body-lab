function pleiades_intro_figures()
%PLEIADES_INTRO_FIGURES  The two figures of the introduction of Report.tex.
%
%   PLEIADES_INTRO_FIGURES() writes
%
%     pleiades_sky.png            the sky survey image of the cluster with the
%                                 nine traditionally named stars labelled
%     pleiades_atlas_pleione.png  the reconstruction of the Atlas-Pleione
%                                 separation over the last 150 000 years
%
%   The background image pleiades_dss.jpg is a Digitized Sky Survey cutout
%   obtained from NASA SkyView (2.2 degrees on a side, centred on
%   RA 56.75, Dec +24.12, J2000). The star positions and proper motions come
%   from SIMBAD via PLEIADES_STARS.
%
%   The image is in the standard astronomical orientation, north up and east
%   to the left; this was verified by checking that all nine catalogue
%   positions fall on bright pixels (worst peak 221 against a background
%   median of 136) while the mirrored hypothesis does not.

S = pleiades_stars();

% ---------------------------------------------------------------- figure 1
% Sky survey image with the named stars marked.

I  = imread('pleiades_dss.jpg');
n  = size(I, 1);
a0 = 56.75 * pi/180;         % SkyView field centre
d0 = 24.12 * pi/180;
scale = (2.2 / n) * pi/180;  % radians per pixel
c0 = (n + 1) / 2;

fig = figure('Color', 'w', 'Position', [100 100 820 820], 'Visible', 'off');
imshow(I, 'Border', 'tight'); hold on

% Labels are nudged away from the star so they do not cover it; the offsets
% are in pixels and were chosen so that no two labels collide.
off = [ 0 -34; 26 22; -30 -26; 0 -32; 0 30; -10 -30; 34 20; -26 24; 0 -30];

for k = 1:numel(S)
    [col, row] = radec2pix(S(k).ra, S(k).dec, a0, d0, scale, c0);
    plot(col, row, 'o', 'MarkerSize', 22 - 2.2*S(k).V, ...
         'MarkerEdgeColor', [1 0.85 0.2], 'LineWidth', 1.4);
    text(col + off(k,1), row + off(k,2), ...
         sprintf('%s', S(k).name), 'Color', [1 0.9 0.35], ...
         'FontSize', 12, 'FontWeight', 'bold', ...
         'HorizontalAlignment', 'center');
end

% Scale bar: half a degree, drawn in the lower left corner.
halfdeg = 0.5 * pi/180 / scale;
x0 = 60; y0 = n - 60;
plot([x0 x0+halfdeg], [y0 y0], 'w-', 'LineWidth', 2.5);
text(x0 + halfdeg/2, y0 - 22, '0.5 deg', 'Color', 'w', ...
     'FontSize', 12, 'HorizontalAlignment', 'center');
text(n - 60, 60, 'N', 'Color', 'w', 'FontSize', 13, 'FontWeight', 'bold');
text(n - 110, 105, 'E', 'Color', 'w', 'FontSize', 13, 'FontWeight', 'bold');
plot([n-60 n-60], [80 130], 'w-', 'LineWidth', 1.5);
plot([n-60 n-110], [130 130], 'w-', 'LineWidth', 1.5);
hold off

exportgraphics(fig, 'pleiades_sky.png', 'Resolution', 150);
close(fig);
fprintf('wrote pleiades_sky.png\n');

% ---------------------------------------------------------------- figure 2
% Atlas and Pleione: separation now and in the past, from proper motions.

A = S(strcmp({S.name}, 'Atlas'));
P = S(strcmp({S.name}, 'Pleione'));

% Offset of Pleione from Atlas, in arcseconds, east and north.
de0 = (P.ra - A.ra) * cosd(A.dec) * 3600;
dn0 = (P.dec - A.dec) * 3600;

% Relative proper motion, arcseconds per year.
dpe = (P.pmra  - A.pmra ) / 1000;
dpn = (P.pmdec - A.pmdec) / 1000;

t   = linspace(-150000, 50000, 2001);      % years from the present
de  = de0 + dpe * t;
dn  = dn0 + dpn * t;
sep = hypot(de, dn) / 60;                  % arcminutes

fig = figure('Color', 'w', 'Position', [100 100 900 380]);

subplot(1,2,1)
plot(de/60, dn/60, '-', 'Color', [0.55 0.6 0.7], 'LineWidth', 1.2); hold on
plot(0, 0, 'p', 'MarkerSize', 16, 'MarkerFaceColor', [0.95 0.75 0.1], ...
     'MarkerEdgeColor', 'k');
text(0.25, 0, 'Atlas', 'FontSize', 10);
inow = find(t >= 0, 1);
ipast = find(t >= -100000, 1);
plot(de(inow)/60,  dn(inow)/60,  'o', 'MarkerSize', 9, ...
     'MarkerFaceColor', [0.2 0.45 0.8], 'MarkerEdgeColor', 'k');
plot(de(ipast)/60, dn(ipast)/60, 's', 'MarkerSize', 9, ...
     'MarkerFaceColor', [0.85 0.35 0.25], 'MarkerEdgeColor', 'k');
text(de(inow)/60 + 0.25,  dn(inow)/60,  'Pleione, today', 'FontSize', 10);
text(de(ipast)/60 + 0.25, dn(ipast)/60, 'Pleione, 100 000 yr ago', 'FontSize', 10);
hold off
axis equal; grid on
xlabel('offset east (arcmin)'); ylabel('offset north (arcmin)')
xlim([-2.2 4.2]); ylim([-0.6 8.4])
title('Position of Pleione relative to Atlas')

subplot(1,2,2)
plot(t/1000, sep, '-', 'LineWidth', 1.6, 'Color', [0.2 0.45 0.8]); hold on
plot(0, sep(inow), 'o', 'MarkerSize', 8, ...
     'MarkerFaceColor', [0.2 0.45 0.8], 'MarkerEdgeColor', 'k');
plot(-100, sep(ipast), 's', 'MarkerSize', 8, ...
     'MarkerFaceColor', [0.85 0.35 0.25], 'MarkerEdgeColor', 'k');
text(2, sep(inow) - 0.45, sprintf('today: %.1f arcmin', sep(inow)), 'FontSize', 10);
text(-98, sep(ipast) + 0.35, sprintf('%.1f arcmin', sep(ipast)), 'FontSize', 10);
hold off
grid on
xlabel('time from the present (thousands of years)')
ylabel('Atlas-Pleione separation (arcmin)')
title('Separation over time')
ylim([4.5 8.5])

exportgraphics(fig, 'pleiades_atlas_pleione.png', 'Resolution', 200);
close(fig);
fprintf('wrote pleiades_atlas_pleione.png\n');
fprintf('separation today %.2f arcmin, 100 kyr ago %.2f arcmin (ratio %.2f)\n', ...
        sep(inow), sep(ipast), sep(ipast)/sep(inow));
end

% -------------------------------------------------------------------------
function [col, row] = radec2pix(ra, dec, a0, d0, scale, c0)
%RADEC2PIX  Gnomonic (tangent plane) projection, north up and east left.
a  = ra  * pi/180;
d  = dec * pi/180;
cosc = sin(d0)*sin(d) + cos(d0)*cos(d)*cos(a - a0);
x = cos(d)*sin(a - a0) / cosc;                          % east positive
y = (cos(d0)*sin(d) - sin(d0)*cos(d)*cos(a - a0)) / cosc;   % north positive
col = c0 - x/scale;      % east to the left
row = c0 - y/scale;      % north up
end
