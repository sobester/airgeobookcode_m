function SweepAngle = sweepanglefunct(Funct, Parameters, Epsilon)
%SWEEPANGLEFUNCT Leading edge sweep at given spanwise stations.
%   It determines the variation of the local sweep angle of the lifting 
%   surface as a function of the spanwise coordinate Epsilon. It calls the
%   specified 'Funct' with 'Parameters' and the Epsilon vector as input 
%   arguments. This main function simply checks the inputs and the outputs.

% Are all the elements of Epsilon in the correct range [0,1]?

if sum(Epsilon>1)>0 || sum(Epsilon<0)>0
    error('Wing-attached coordinate value must be within [0,1].')
end

SweepAngle = feval(Funct, Parameters, Epsilon);

% Has the function specified a dihedral angle at each station?
if length(SweepAngle)~=length(Epsilon)
    error(['The specified sweep angle function ',Funct,...
        ' returns an incorrect sweep angle vector']);
end