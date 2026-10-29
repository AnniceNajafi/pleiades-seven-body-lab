// Wrap web/pleiades_lab.html into a standalone page for GitHub Pages: docs/index.html.
//
//   node web/build_guide.js   # first, if any .m file, the table or Pleiades.txt changed
//   node web/build_site.js
//
// pleiades_lab.html is written as a page body (the artifact host supplies the document
// skeleton), so this adds the doctype, head and the small base reset the host provides.

const fs = require('fs');
const path = require('path');

const here = __dirname;
const src = path.join(here, 'pleiades_lab.html');
const outDir = path.join(here, '..', 'docs');
const out = path.join(outDir, 'index.html');

let body = fs.readFileSync(src, 'utf8');
// the head-level tags at the top of the source move into <head>
const headTags = [];
body = body.replace(/^\s*<meta charset="utf-8">\s*/i, '');
body = body.replace(/<title>[\s\S]*?<\/title>\s*/i, m => { headTags.push(m.trim()); return ''; });
body = body.replace(/<meta name="claude:viewport-fit-sides"[^>]*>\s*/i, '');
body = body.replace(/(<link [^>]*>\s*)+/i, m => { headTags.push(m.trim()); return ''; });

const html = `<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
<meta name="description" content="Interactive seven-body Pleiades simulation (Bari IVP Test Set, problem II.6) with an assignment guide: MATLAB code, results and discussion for COMP626 Project 1.">
${headTags.join('\n')}
<style>
:root { color-scheme: light; padding-top: env(safe-area-inset-top, 0px); padding-bottom: env(safe-area-inset-bottom, 0px); }
body { margin: 0; font: 14px/1.4 system-ui, -apple-system, "Segoe UI", sans-serif; }
img { max-width: 100%; }
[hidden] { display: none !important; }
</style>
</head>
<body>
${body.trim()}
</body>
</html>
`;

fs.mkdirSync(outDir, { recursive: true });
fs.writeFileSync(out, html);
fs.writeFileSync(path.join(outDir, '.nojekyll'), '');
console.log(`Wrote ${path.relative(path.join(here, '..'), out)} (${(html.length / 1024).toFixed(0)} KB)`);
