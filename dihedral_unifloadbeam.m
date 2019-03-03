function DihedralAngle = dihedral_unifloadbeam(DihedralParameters, Epsilon)
%DIHEDRAL_UNIFLOADBEAM Uniformly loaded cantilever beam lifting surface
%shape.
%   Returns the wing spanwise slope angle vector corresponding to the
%   deformed shape of cantilever beam with a spanwise uniform load
%   distribution. DihedralParameters contains the root slope and the load
%   factor.
%   INPUTS: DihedralParameters(1) - baseline dihedral angle (the cantilever
%           beam shape is added to this).
%           DihedralParameters(2) - load factor (this scales the 'load' -
%           the greater this value, the greater the 'deflection' will be).
%           A positive value means the wing will be bent upwards.
%           Epsilon - vector of spanwise stations (along the
%           non-dimensional spanwise variable Epsilon).
%   OUTPUT: DihedralAngle - vector (same length as Epsilon) of spanwise
%           wing slopes.

    
MainDihedral        = DihedralParameters(1); % baseline value (root dihedral)
K                   = DihedralParameters(2); % slope scaling factor
WingletSpanRatio    = DihedralParameters(3); % winglet starts at this ratio of span
KW                  = DihedralParameters(4); % winglet slope scaling factor


DihedralAngle = MainDihedral + atand(K*(4*Epsilon.^3-12*Epsilon.^2+12*Epsilon));

i = 1; 

while Epsilon(i) ~= WingletSpanRatio, i = i + 1; end

% Reset Epsilon datum to the start of the winglet
Epsilon = Epsilon - Epsilon(i);
Epsilon(1:i-1) = 0;

DihedralAngle = DihedralAngle + atand(KW*(4*Epsilon.^3-12*Epsilon.^2+12*Epsilon));