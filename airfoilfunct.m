function Airfoils = airfoilfunct(Epsilon, NP, Fidelity, Funct, Parameters)
%AIRFOILFUNCT Spanwise variation of airfoil.
%   It determines the variation of the airfoil as a function of the 
%   spanwise coordinate Epsilon. It calls the specified 'Funct' with 
%   'Parameters',the Epsilon vector, the number of points that make up the 
%   airfoil and a 'Fidelity' as input arguments. 
%   This main function simply checks the inputs and the outputs.

% Are all the elements of Epsilon in the correct range [0,1]?

if sum(Epsilon>1)>0 || sum(Epsilon<0)>0
    error('Wing-attached coordinate value must be within [0,1].')
end


Airfoils = feval(Funct, Parameters, Epsilon, NP, Fidelity);

% Has the function specified an airfoil at each station?
if length(Airfoils)~=length(Epsilon)
    error(['The specified airfoil function ',Funct,...
        ' returns an incorrect airfoil vector']);
end