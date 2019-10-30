%%  OODCAGD Framework
%
%   Copyright 2014-2015 Evangelos D. Katsavrias, Athens, Greece
%
%   This file is part of the OOCAGD Framework.
%
%   OOCAGD Framework is free software: you can redistribute it and/or modify
%   it under the terms of the GNU General Public License version 3 as published by
%   the Free Software Foundation.
%
%   OOCAGD Framework is distributed in the hope that it will be useful,
%   but WITHOUT ANY WARRANTY; without even the implied warranty of
%   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%   GNU General Public License for more details.
%
%   You should have received a copy of the GNU General Public License
%   along with OOCAGD Framework.  If not, see <https://www.gnu.org/licenses/>.
%
%   Contact Info:
%   Evangelos D. Katsavrias
%   email/skype: vageng@gmail.com
% -----------------------------------------------------------------------

function [basisFunctions, varargout] = evaluateInSingleKnotPatch(obj, varargin)

[knotSpanNumber, numberOfEvaluationPoints, evaluationPoints, derivativesOrder, jac] = preprocessor(obj, varargin{:});

basisFunctions = zeros(obj.KnotVector.order, numberOfEvaluationPoints, derivativesOrder+1);

if derivativesOrder ~= 0
    for currentEvaluationPoint = 1:numberOfEvaluationPoints         % scanning the integration points in u-direction
        basisFunctions(:, currentEvaluationPoint, :) = evaluateBasisFunctionsWithDerivatives(obj.KnotVector.order-1, obj.KnotVector.order, obj.KnotVector.knots, knotSpanNumber, evaluationPoints(currentEvaluationPoint), derivativesOrder);
    end
else
    for currentEvaluationPoint = 1:numberOfEvaluationPoints         % scanning the integration points in u-direction
        basisFunctions(:, currentEvaluationPoint, :) = evaluateBasisFunctions(obj.KnotVector.order-1, obj.KnotVector.order, obj.KnotVector.knots, knotSpanNumber, evaluationPoints(currentEvaluationPoint));
    end
end

if nargout > 1; varargout{1} = knotSpanNumber; end
if nargout > 2; varargout{2} = evaluationPoints; end
if nargout > 3; varargout{3} = jac; end
if nargout > 4; varargout{4} = numberOfEvaluationPoints; end

end


%%  
function [knotSpanNumber, numberOfEvaluationPoints, evaluationPoints, derivativesOrder, jac] = preprocessor(obj, varargin)

derivativesOrder = 0;
jac              = 0;
if nargin == 2
    if isvector(varargin{1})
        numberOfEvaluationPoints    = length(varargin{1});
        evaluationPoints            = varargin{1};
        knotSpanNumber              = obj.KnotVector.findSpanOfParametricPoints(varargin{1}(1));
    else throw(MException('CAGD:basisFunctionsInKnotPatch', 'Wrong input data, provide a valid scalar number as the first input argument to indicate the evaluation point.'));
    end
    return
end

if nargin > 3
    if isscalar(varargin{1}); knotSpanNumber = obj.KnotVector.knotPatch2KnotSpanNumber(varargin{1});
    else throw(MException('CAGD:basisFunctionsInKnotPatch', 'Wrong input data, provide a valid scalar number as the first input argument to indicate the knot patch number, or give directly the evaluation points in parametric coordinates that lay in a single knot patch.'));
    end
    
    if isscalar(varargin{2}); derivativesOrder = varargin{2};
    else throw(MException('CAGD:basisFunctionsInKnotPatch', 'Wrong input data, provide a scalar number as the fourth input argument to indicate the maximum order of derivatives to be evaluated.'));
    end
    
    switch varargin{3}
        case 'PointsInParametricDomain'
            if nargin > 4 && isvector(varargin{4}); evaluationPoints = varargin{4};
            else throw(MException('CAGD:basisFunctionsInKnotPatch', 'Wrong input data, provide a valid single dimension array as the third input argument to indicate the evaluation points in the knot patch.'));
            end
            if nargin > 5
                if isscalar(varargin{5}); numberOfEvaluationPoints = varargin{5};
                else throw(MException('CAGD:basisFunctionsInKnotPatch', 'Wrong input data, provide a valid scalar number as the second input argument to indicate the number of evaluation points in the knot patch.'));
                end
            else numberOfEvaluationPoints = length(varargin{4});
            end
            
        case 'PointsInParentDomain'
            if nargin > 5 && isvector(varargin{4}) && isvector(varargin{5})
                parentDomain            = varargin{4};
                mappedResults = obj.KnotVector.affineMapParentDomain2KnotPatches(parentDomain, varargin{1}, varargin{5});
                jac = mappedResults.jacobians;
                evaluationPoints = mappedResults.mappedPoints;
            else throw(MException('CAGD:basisFunctionsInKnotPatch', 'Wrong input data, provide a valid single dimension array as the third input argument to indicate the evaluation points in the knot patch.'));
            end
            if nargin > 6
                if isscalar(varargin{6}); numberOfEvaluationPoints = varargin{6};
                else throw(MException('CAGD:basisFunctionsInKnotPatch', 'Wrong input data, provide a valid scalar number as the second input argument to indicate the number of evaluation points in the knot patch.'));
                end
            else numberOfEvaluationPoints = length(varargin{5});
            end
            
        case 'PointsUniform'
            if nargin > 4 && isscalar(varargin{4})
                numberOfEvaluationPoints    = varargin{4};
                evaluationPoints            = linspace(obj.KnotVector.knotsWithoutMultiplicities(varargin{1}), obj.KnotVector.knotsWithoutMultiplicities(varargin{1}+1), numberOfEvaluationPoints);
            else throw(MException('CAGD:basisFunctionsInKnotPatch', 'Wrong input data, provide a valid scalar number as the fourth input argument to indicate the number of uniformly distributed evaluation points in the knot patch.'));
            end
    end
else
    throw(MException('bSplineBasisFunctions:evaluateInSingleKnotPatch', 'Provide as minimum input arguments, a vector of the required evaluation parametric points. Or, with the following sequence: the knot patch number, the derivatives order (default:0), the given points type (''PointsInParametricDomain'', ''PointsInParentDomain'', ''PointsUniform''), and the corresponding point data.'));
end

end

%%  
function basisFunctions = evaluateBasisFunctions(basisDegree, basisOrder, knotVector, knotSpanNumber, knotValue)
% Computes the nonvanishing basis functions
% input : basisDegree, basisOrder, knotVector, knotSpanNumber, knotValue
% output : basisFunctions

basisFunctions      = zeros(basisOrder, 1);
basisFunctions(1)   = 1;  % zero degree basis function (unit step heaviside function)

left            = zeros(basisOrder, 1);
right           = zeros(basisOrder, 1);
knotSpanNumber  = knotSpanNumber+1;   % Transforming the base of spans from zero to 1

for index1 = 1:basisDegree   % Scanning the degrees of functions  1-p
    
    left(index1+1)  = knotValue -knotVector(knotSpanNumber+1-index1);
    right(index1+1) = knotVector(knotSpanNumber+index1)-knotValue;
    saved           = 0;

    for index2 = 0:index1-1   % Scanning the functions for each degree
        temp                        = basisFunctions(index2+1)/(right(index2+2)+left(index1-index2+1));
        basisFunctions(index2+1)    = saved + right(index2+2)*temp;  % The r-first function of the current degree of functions
        saved                       = left(index1-index2+1)*temp;
    end
    
    basisFunctions(index1+1) = saved;  % The last function of the current degree

end

end

%%  
function basisFunctions = evaluateBasisFunctionsWithDerivatives(basisDegree, basisOrder, knotVector, knotSpanNumber, knotValue, derivativesOrder)

basisFunctions  = zeros(basisOrder, derivativesOrder+1);  % storing efficient for matlab, should be inverted for C

left    = zeros(basisOrder);
right   = zeros(basisOrder);
knotSpanNumber = knotSpanNumber+1; %% convert to base-1 numbering of knot spans

ndu             = zeros(basisOrder, basisOrder);
a               = zeros(2, basisOrder);
ndu(1,1) = 1;

for j = 1:basisDegree
    
    left(j+1)   = knotValue -knotVector(knotSpanNumber+1-j);
    right(j+1)  = knotVector(knotSpanNumber+j) -knotValue;
    saved       = 0;
    
    for r = 0:j-1
        
        ndu(j+1,r+1)    = right(r+2) + left(j-r+1);
        temp            = ndu(r+1,j)/ndu(j+1,r+1);
        ndu(r+1,j+1)    = saved + right(r+2)*temp;
        saved           = left(j-r+1)*temp;
    
    end
    ndu(j+1,j+1) = saved;

end

% zero order derivative, the basis functions themself
basisFunctions(1:basisDegree+1, 1) = ndu(1:basisDegree+1, basisOrder);

for r = 0:basisDegree
    s1 = 0;
    s2 = 1;
    a(1,1) = 1;
    for k = 1:derivativesOrder %compute kth derivative
        d = 0;
        rk = r-k;
        pk = basisDegree-k;
        if (r >= k)
            a(s2+1,1) = a(s1+1,1)/ndu(pk+2,rk+1);
            d = a(s2+1,1)*ndu(rk+1,pk+1);
        end
        if (rk >= -1)
            j1 = 1;
        else 
            j1 = -rk;
        end
        if ((r-1) <= pk)
            j2 = k-1;
        else 
            j2 = basisDegree-r;
        end
        for j = j1:j2
            a(s2+1,j+1) = (a(s1+1,j+1) - a(s1+1,j))/ndu(pk+2,rk+j+1);
            d = d + a(s2+1,j+1)*ndu(rk+j+1,pk+1);
        end
        if (r <= pk)
            a(s2+1,k+1) = -a(s1+1,k)/ndu(pk+2,r+1);
            d = d + a(s2+1,k+1)*ndu(r+1,pk+1);
        end
        basisFunctions(r+1, k+1) = d;
        j = s1;
        s1 = s2;
        s2 = j;
    end
end

r = basisDegree;
for k = 1:derivativesOrder
    for j = 0:basisDegree
        basisFunctions(j+1, k+1) = basisFunctions(j+1, k+1)*r;
    end
    r = r*(basisDegree-k);
end

end