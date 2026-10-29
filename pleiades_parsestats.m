function s = pleiades_parsestats(txt)
%PLEIADES_PARSESTATS  Parse the output of ODESET('Stats','on').
%
%   S = PLEIADES_PARSESTATS(TXT) turns the text printed by a MATLAB ODE
%   solver when 'Stats' is 'on' into a struct with the fields
%
%       accept   number of successful steps
%       failed   number of failed attempts
%       nfevals  number of function evaluations (as printed by MATLAB)
%       njac     number of Jacobian ("partial derivatives") evaluations
%       nlu      number of LU decompositions
%       nsolve   number of solutions of linear systems
%
%   Fields that a solver does not report (the non-stiff solvers report no
%   Jacobian, LU or linear-solve counts) are returned as zero.
%
%   Note: MATLAB prints the counters in %g format, so counts above 1e5 are
%   rounded to about six significant digits. RUN_PLEIADES therefore counts
%   function evaluations itself and uses the parsed value only as a check.

s = struct('accept', 0, 'failed', 0, 'nfevals', 0, ...
           'njac', 0, 'nlu', 0, 'nsolve', 0);

keys = {'successful steps',            'accept'
        'failed attempts',             'failed'
        'function evaluations',        'nfevals'
        'partial derivatives',         'njac'
        'LU decompositions',           'nlu'
        'solutions of linear systems', 'nsolve'};

lines = strsplit(strtrim(txt), newline);
for k = 1:numel(lines)
    tok = regexp(strtrim(lines{k}), '^([\d.eE+\-]+)\s+(.*)$', 'tokens', 'once');
    if isempty(tok), continue; end
    idx = find(strcmpi(keys(:,1), strtrim(tok{2})), 1);
    if ~isempty(idx)
        s.(keys{idx,2}) = str2double(tok{1});
    end
end
end
