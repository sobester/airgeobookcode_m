function metric=regpredictor(x)
% metric=predictor(x)
%
% Calculates the regressing Kriging prediction, RMSE, -log(E[I(x)]) or -log(P[I(x)])
%
% Inputs:
%	x - 1 x k vetor of design variables
%
% Global variables used:
%	ModelInfo.X - n x k matrix of sample locations
%	ModelInfo.y - n x 1 vector of observed data
%   ModelInfo.Theta - 1 x k vector of log(theta)
%   ModelInfo.Lambda - scalar regulrization parameter
%   ModelInfo.U - n x n Cholesky factorisation of Psi
%   ModelInfo.option - string: 'Pred', 'RMSE', 'NegLogExpImp' or 'NegProbImp'
%
% Outputs:
%	metric - prediction, RMSE, -log(E[I(x)]) or -log(P[I(x)]), determined
%	by ModelInfo.option
%
% Copyright 2007 A I J Forrester
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

global ModelInfo
X=ModelInfo.X;
y=ModelInfo.y;
theta=10.^ModelInfo.Theta;
lambda=10.^ModelInfo.Lambda;
p=2;  % added p definition (February 10)
U=ModelInfo.U;
n=size(X,1);
one=ones(n,1);
mu=(one'*(U\(U'\y)))/(one'*(U\(U'\one)));
SigmaSqr=((y-one*mu)'*(U\(U'\(y-one*mu))))/n;
psi=ones(n,1);
for i=1:n
	psi(i)=exp(-sum(theta.*abs(X(i,:)-x).^p));
end
f=mu+psi'*(U\(U'\(y-one*mu)));
if strcmp(ModelInfo.Option,'Pred')==0
    SSqr=SigmaSqr*(1+lambda-psi'*(U\(U'\psi)));
    s=abs(SSqr)^0.5;
    if strcmp(ModelInfo.Option,'RMSE')==0
        if isfield(ModelInfo,'ConstraintLimit')==0
            yBest=min(y);
        else
            yBest=ModelInfo.ConstraintLimit;
        end
        if strcmp(ModelInfo.Option,'NegProbImp')==1
            ProbImp=0.5+0.5*erf((1/sqrt(2))*((yBest-f)/s));
        else
            EITermOne=(yBest-f)*(0.5+0.5*erf((1/sqrt(2))*((yBest-f)/s)));
            EITermTwo=s*(1/sqrt(2*pi))*exp(-(1/2)*((yBest-f)^2/SSqr));
            ExpImp=log10(EITermOne+EITermTwo+realmin); % changed from "ExpImp=log10(EITermOne+EITermTwo+eps);" (September 2009)
        end
    end
end


if strcmp(ModelInfo.Option,'Pred')==1
metric=f;
elseif strcmp(ModelInfo.Option,'RMSE')==1
metric=s;
elseif strcmp(ModelInfo.Option,'NegLogExpImp')==1
metric=-ExpImp;
elseif strcmp(ModelInfo.Option,'NegProbImp')==1
metric=-ProbImp;
end


