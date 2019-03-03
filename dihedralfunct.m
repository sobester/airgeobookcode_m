function DihedralAngle = dihedralfunct(Funct, Parameters, Epsilon)
%DIHEDRALFUNCT Wing spanwise slope at given spanwise stations.
%   It determines the variation of the slope of the wing (local 
%   dihedral) as a function of the spanwise coordinate Epsilon. It calls the
%   specified 'Funct' with 'Parameters' and the Epsilon vector as input 
%   arguments. This main function simply checks the inputs and the outputs.


% Are all the elements of Epsilon in the correct range [0,1]?

if sum(Epsilon>1)>0 || sum(Epsilon<0)>0
    error('Wing-attached coordinate value must be within [0,1].')
end

DihedralAngle = feval(Funct, Parameters, Epsilon);

% Has the function specified a dihedral angle at each station?
if length(DihedralAngle)~=length(Epsilon)
    error(['The specified dihedral function ',Funct,...
        ' returns an incorrect dihedral angle vector']);
end