function TwistAngle = twistangle_linear(TwistParameters, Epsilon)
%TWISTANGLE_LINEAR Linearly twisted wing.
%   Returns the wing spanwise local twist angle vector corresponding to a 
%   linear twist variation. TwistParameters is a vector containing the
%   setting angle and the final (tip) twist angle in this case. 
%   Use this as a template for user-defined dihedral functions.
%   INPUTS: TwistParameters(1) - setting angle (at root)
%           TwistParameters(2) - additional twist at the tip
%           Epsilon - vector of spanwise stations (along the
%           non-dimensional spanwise variable Epsilon).
%   OUTPUT: TwistAngle - vector (same length as Epsilon) of spanwise
%           local twist angles.

TwistAngle = TwistParameters(1) + TwistParameters(2)*Epsilon;