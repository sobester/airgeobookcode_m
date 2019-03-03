function TwistAngle = twistanglefunct(Epsilon, Funct, Parameters)
%TWISTANGLEFUNCT Local twist at given spanwise stations.
%   It determines the variation of the local twist angle of the lifting 
%   surface as a function of the spanwise coordinate Epsilon. It calls the
%   specified 'Funct' with 'Parameters' and the Epsilon vector as input 
%   arguments. This main function simply checks the inputs and the outputs.

% Are all the elements of Epsilon in the correct range [0,1]?

if sum(Epsilon>1)>0 || sum(Epsilon<0)>0
    error('Wing-attached coordinate value must be within [0,1].')
end

TwistAngle = feval(Funct, Parameters, Epsilon);

% Has the function specified a dihedral angle at each station?
if length(TwistAngle)~=length(Epsilon)
    error(['The specified twist angle function ',Funct,...
        ' returns an incorrect twist angle vector']);
end