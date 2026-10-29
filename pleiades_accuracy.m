function [mescd, scd] = pleiades_accuracy(uend, uref, rtol, atol, imescd, iscd)
%PLEIADES_ACCURACY  Mixed and relative significant correct digits.
%
%   [MESCD, SCD] = PLEIADES_ACCURACY(UEND, UREF, RTOL, ATOL) compares the
%   numerical solution UEND at the end of the integration interval with the
%   reference solution UREF, using the definitions given in part (d) of the
%   assignment:
%
%       mescd = -log10( ||uend - uref||_inf / ( atol/rtol + ||uref||_inf ) )
%
%               / -log10( || (uend - uref) ./ uref ||_inf ),
%       scd  = <      if |uref_i| >= 1e-12 for all i
%               \ -log10( || uend - uref ||_inf ),
%                     if |uref_i| < 1e-12 for some i
%
%   where ||.||_inf is the maximum absolute value over the components.
%   Note that mescd scales the WHOLE error vector by a single number built
%   from the norm of the reference solution; it is not a componentwise
%   weighting.  scd, in contrast, divides element by element.
%
%   [MESCD, SCD] = PLEIADES_ACCURACY(UEND, UREF, RTOL, ATOL, IMESCD, ISCD)
%   restricts each measure to the components listed in the index vectors
%   IMESCD and ISCD.  The defaults follow the test set: all 28 components
%   for mescd, and the 14 positions for scd (see PLEIADES_SETUP).

if nargin < 5 || isempty(imescd), imescd = 1:numel(uref); end
if nargin < 6 || isempty(iscd),   iscd   = 1:min(14, numel(uref)); end

% --- mescd: norms of the whole vectors, as written in part (d) -----------
em = uend(imescd) - uref(imescd);
mescd = -log10( norm(em, inf) / (atol/rtol + norm(uref(imescd), inf)) );

% --- scd: componentwise relative error, absolute if any |uref| is tiny ---
es = uend(iscd) - uref(iscd);
rs = uref(iscd);
if all(abs(rs) >= 1e-12)
    scd = -log10(norm(es ./ rs, inf));
else
    scd = -log10(norm(es, inf));
end
end
