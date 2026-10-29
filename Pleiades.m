function du = Pleiades(t, u)
%PLEIADES  Right-hand side of the Pleiades problem (Bari IVP Test Set, II.6).
%I think E5 in the problem statement may be a typo.
%   DU = PLEIADES(T, U) evaluates the first-order form (II.6.3)
%
%       z' = w
%       w' = f(z)
%
%   of the seven-body celestial mechanics problem (II.6.1)-(II.6.2), a
%   nonstiff system of 28 ODEs on 0 <= t <= 3.
%
%   State vector (28 x 1), with z = (x', y')' and w = z':
%
%       u( 1: 7) = x1..x7        (positions, horizontal)
%       u( 8:14) = y1..y7        (positions, vertical)
%       u(15:21) = x1'..x7'      (velocities, horizontal)
%       u(22:28) = y1'..y7'      (velocities, vertical)
%
%   The accelerations are
%
%       xi'' = sum_{j~=i} mj (xj - xi) / rij^(3/2)
%       yi'' = sum_{j~=i} mj (yj - yi) / rij^(3/2)
%
%   with masses mi = i (i = 1,...,7), gravitational constant g = 1, and the
%   SQUARED distance
%
%       rij = (xi - xj)^2 + (yi - yj)^2.
%
%   The problem is autonomous; T is accepted only so that the function can
%   be passed directly to ODE45, ODE113, ODE15S and the other solvers of
%   the MATLAB ODE suite.
%
%   Initial values (t = 0):
%       x (0) = ( 3,  3, -1, -3,  2, -2,  2)'
%       y (0) = ( 3, -3,  2,  0,  0, -4,  4)'
%       x'(0) = ( 0,  0,  0,  0,  0,  1.75, -1.5)'
%       y'(0) = ( 0,  0,  0, -1.25, 1, 0,  0)'
%
%   Several quasi-collisions occur (Table II.6.1), the closest being bodies
%   1 and 7 at t ~ 1.68 with squared distance 0.0011, so tight tolerances
%   are needed for an accurate solution at t = 3.
%
%   Reference: Test Set for IVP Solvers, Pleiades problem (Hairer, Norsett
%   & Wanner 1993).

m = (1:7)';                     % masses mi = i

x  = u(1:7);
y  = u(8:14);

%Pairwise differences: DX(i,j) = xj - xi,  DY(i,j) = yj - yi
DX = x.' - x;
DY = y.' - y;

%rij^(3/2), with rij the squared distance; the diagonal (i = j) is set to
%Inf so the self-interaction terms drop out of the sums.
R32 = (DX.^2 + DY.^2).^(3/2);
R32(1:8:end) = Inf;

%Accelerations f(1) and f(2) of (II.6.2)
ax = (DX ./ R32) * m;
ay = (DY ./ R32) * m;

du = [u(15:28); ax; ay];
end
