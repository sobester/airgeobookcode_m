function DihedralAngle = dihedral_constant(DihedralParameters, Epsilon)
%DIHEDRAL_CONSTANT Generate constant wing (spanwise) slope angle vector.
%   Returns the wing spanwise slope angle vector corresponding to a basic, 
%   spanwise constant dihedral angle. DihedralParameters is simply that 
%   constant dihedral angle in this case. Use this as a template for 
%   user-defined dihedral functions.
%   INPUTS: DihedralParameters - dihedral angle (constant)
%           Epsilon - vector of spanwise stations (along the
%           non-dimensional spanwise variable Epsilon).
%   OUTPUT: DihedralAngle - vector (same length as Epsilon) of spanwise
%           wing slopes.

DihedralAngle = DihedralParameters(1)*ones(size(Epsilon));