// Copy the submitted project files into pleiades_lab.html so the assignment
// guide shows exactly the code and results that were handed in.
//
//   node build_guide.js
//
// Run it again after changing any .m file, the table or Pleiades.txt.
// Everything between the @sources markers in the page is regenerated.

const fs = require('fs');
const path = require('path');

const here = __dirname;
const project = path.resolve(here, '..');
const page = path.join(here, 'pleiades_lab.html');

const TEXT_FILES = [
  'Pleiades.m', 'pleiades_setup.m', 'run_pleiades.m', 'pleiades_parsestats.m',
  'pleiades_accuracy.m', 'pleiades_figure.m', 'pleiades_table.m', 'project1.m',
  'pleiades_table.txt', 'Pleiades.txt', 'README.txt'
];
// [path relative to the project folder, key used by the page]
const IMAGE_FILES = [
  ['pleiades_x1y1.png', 'pleiades_x1y1.png'],
  ['web/assets/video_thumb.jpg', 'video_thumb.jpg']   // thumbnail of the literature-review video
];

const blocks = [];
for (const name of TEXT_FILES) {
  // drop control characters other than tab/newline (README.txt holds a stray backspace)
  const text = fs.readFileSync(path.join(project, name), 'utf8').replace(/\r\n/g, '\n').replace(/[\x00-\x08\x0b-\x1f]/g, '');
  if (/<\/script|<!--/i.test(text)) throw new Error(`${name} contains text that cannot be embedded in a script block`);
  blocks.push(`<script type="text/plain" data-src="${name}">\n${text}</script>`);
}
for (const [file, key] of IMAGE_FILES) {
  const b64 = fs.readFileSync(path.join(project, file)).toString('base64');
  blocks.push(`<script type="text/plain" data-src="${key}">${b64}</script>`);
}

const html = fs.readFileSync(page, 'utf8');
const start = html.indexOf('<!-- @sources:start');
const end = html.indexOf('<!-- @sources:end -->');
if (start < 0 || end < 0) throw new Error('source markers not found in pleiades_lab.html');
const headEnd = html.indexOf('-->', start) + 3;
const out = html.slice(0, headEnd) + '\n' + blocks.join('\n') + '\n' + html.slice(end);
fs.writeFileSync(page, out);
console.log(`Embedded ${TEXT_FILES.length} text files and ${IMAGE_FILES.length} image into ${path.basename(page)}`);
