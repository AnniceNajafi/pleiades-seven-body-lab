function S = pleiades_stars()
%PLEIADES_STARS  Astrometry of the nine traditionally named Pleiades stars.
%
%   S = PLEIADES_STARS() returns a struct array with one entry per star:
%
%       name   common (mythological) name
%       flam   Flamsteed / Bayer designation
%       ra     right ascension at J2000, degrees
%       dec    declination at J2000, degrees
%       pmra   proper motion in RA, mas/yr, already including cos(dec)
%       pmdec  proper motion in declination, mas/yr
%       V      visual magnitude
%
%   Values queried from the SIMBAD astronomical database (CDS, Strasbourg)
%   on 2026-09-28. They are used by PLEIADES_INTRO_FIGURES to label the sky
%   survey image and to reconstruct the Atlas-Pleione separation.

d = { % name        designation   ra            dec           pmra    pmdec     V
      'Alcyone',    'eta Tau',    56.871152303, 24.105135652, 19.340, -43.670, 2.87
      'Atlas',      '27 Tau',     57.290596074, 24.053417133, 19.079, -46.193, 3.63
      'Electra',    '17 Tau',     56.218904541, 24.113337850, 20.542, -46.081, 3.70
      'Maia',       '20 Tau',     56.456700645, 24.367743768, 19.516, -45.527, 3.87
      'Merope',     '23 Tau',     56.581607863, 23.948358938, 13.075, -48.404, 4.18
      'Taygeta',    '19 Tau',     56.302083305, 24.467273762, 16.292, -47.206, 4.30
      'Pleione',    '28 Tau',     57.296735824, 24.136710198, 19.496, -47.650, 5.09
      'Celaeno',    '16 Tau',     56.200895568, 24.289467592, 19.849, -44.966, 5.46
      'Asterope',   '21 Tau',     56.476985212, 24.554509916, 20.331, -46.022, 5.76 };

S = struct('name', d(:,1), 'flam', d(:,2), 'ra', d(:,3), 'dec', d(:,4), ...
           'pmra', d(:,5), 'pmdec', d(:,6), 'V', d(:,7));
end
