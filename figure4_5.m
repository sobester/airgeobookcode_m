% FIGURE4_5 plots Bezier surface
%
%    FIGURE4_5 uses equation 4.6, calling the beziersurface function to 
%    create the Bezier surface in Figure 4.5. Listing 4.3 has the same
%    result, but does not call beziersurface
%
% -------------------------------------------------------------------------
% Aircraft Geometry Toolbox v0.1.0, Andras Sobester 2014.
%
% Sobester, A, Forrester, A I J, "Aircraft Aerodynamic Design - Geometry 
% and Optimization", Wiley, 2014.
% -------------------------------------------------------------------------
%
% Copyright 2014 A I J Forrester
%
% This program is free software: you can redistribute it and/or modify  it
% under the terms of the GNU Lesser General Public License as published by
% the Free Software Foundation, either version 3 of the License, or any
% later version.
% 
% This program is distributed in the hope that it will be useful, but
% WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser
% General Public License for more details.
% 
% You should have received a copy of the GNU General Public License and GNU
% Lesser General Public License along with this program. If not, see
% <http://www.gnu.org/licenses/>.
P(:,:,1)=[0 0.5 1
    0 0.5 1
    0 0.5 1
    0 0.5 1];
P(:,:,2)=[0 0 0
    0.5 0.5 0.5
    1 1 1
    1.5 1.5 1.5];
P(:,:,3)=[0 1 0
    -1 0 -1
    0 1 0
    -1 0 0.5];
bezierSurfacePoints=beziersurface(P);
m=mesh(bezierSurfacePoints(:,:,1),bezierSurfacePoints(:,:,2),bezierSurfacePoints(:,:,3));
set(m,'FaceAlpha',0,'EdgeColor',[0 0 0]);
axis square
axis off