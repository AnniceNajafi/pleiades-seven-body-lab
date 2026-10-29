import io, re, os

os.chdir(r'C:\Users\annic\Downloads\Project_1')
lines = io.open('pleiades_table.txt', encoding='utf-8').read().split('\n')

pat = re.compile(r'^(ode\w+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s*$')
rows = [list(m.groups()) for m in (pat.match(ln) for ln in lines) if m]
assert len(rows) == 21, len(rows)

THIN = '\\,'          # thin space between thousands
BS   = '\\\\'         # LaTeX row terminator

def tol(s):
    return '$10^{%d}$' % int(s.split('e')[1])

def num(s):
    if s == '-':
        return '--'
    return '{:,}'.format(int(s)).replace(',', THIN)

# The complete tabular is generated here, rather than only its rows, so that no
# row terminator ever sits at an \input file boundary (TeX scans past the end of
# the file for the optional argument of \\ and trips over the next \noalign).
out = ['\\begin{tabular}{lcccrrrrrrrrr}',
       '\\toprule',
       ' & '.join(['solver', 'rtol', 'atol', '$h_0$', 'mescd', 'scd', 'steps',
                   'accept', '\\#f', '\\#Jac', '\\#LU', '\\#solve', 'CPU']) + ' ' + BS,
       '\\midrule']

for i, r in enumerate(rows):
    if i and i % 3 == 0:
        out.append('\\addlinespace')
    solver, rt, at, h0, me, sc, st, ac, nf, nj, nlu, ns, cpu = r
    cells = ['\\texttt{%s}' % solver, tol(rt), tol(at), tol(h0), me, sc,
             num(st), num(ac), num(nf), num(nj), num(nlu), num(ns), cpu]
    out.append(' & '.join(cells) + ' ' + BS)

out += ['\\bottomrule', '\\end{tabular}']

io.open('report_table.tex', 'w', encoding='utf-8', newline='\n').write('\n'.join(out) + '\n')
print('rows written:', len(rows))
