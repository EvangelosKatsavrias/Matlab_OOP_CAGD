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

function degreeRefinement(obj, varargin)

oldTypeOfCoordinates = obj.ControlPoints.typeOfCoordinates;
if strcmp(obj.ControlPoints.typeOfCoordinates, 'Cartesian')
    obj.ControlPoints.convertTypeOfCoordinates('Homogeneous');
end

if nargin == 1
else
    switch varargin{1}
        case 'knotVectorHandle'
            singleKnotVectorElevation(obj, varargin{:}); return
            
        case 'elevateOrder'
            if nargin > 3; coords = varargin{3}; else coords = 1:obj.Connectivities.numberOfParametricCoordinates; end
            if nargin > 2; depth = varargin{2}; else depth = ones(1, length(coords)); end
            disableListeners(obj);
            coordsIndex = 1;
            for parametricCoordinateIndex = coords(1:end-1)
                obj.KnotVectors(parametricCoordinateIndex).elevateOrder(depth(coordsIndex));
                coordsIndex = coordsIndex+1;
            end
            
            enableListeners(obj);
            obj.KnotVectors(coords(end)).elevateOrder(depth(coordsIndex));
            enableTopologyListeners(obj);
            
        otherwise
            throw(MException('nurbs:degreeRefinement', 'Provide a valid string identifier as first argument: ''elevateOrder''.'));

    end
end

if strcmp(oldTypeOfCoordinates, 'Cartesian')
    obj.ControlPoints.convertTypeOfCoordinates('Cartesian')
end

end


%%
function disableListeners(obj)

obj.Connectivities.controlListeners('Disable');

for index = 1:length(obj.BoundaryTopologies)
    obj.BoundaryTopologies(index).BasisFunctions.controlListeners('Disable');
end
for index = 1:length(obj.InteriorTopologies)
    obj.InteriorTopologies(index).BasisFunctions.controlListeners('Disable');
end
for index = 1:length(obj.ClosureTopologies)
    obj.ClosureTopologies(index).BasisFunctions.controlListeners('Disable');
end

for index = 1:length(obj.ClosureTopologies)
    obj.ClosureTopologies(index).controlListeners('Disable');
end
for index = 1:length(obj.BoundaryTopologies)
    obj.BoundaryTopologies(index).controlListeners('Disable');
end
for index = 1:length(obj.InteriorTopologies)
    obj.InteriorTopologies(index).controlListeners('Disable');
end

end

function enableListeners(obj)

obj.Connectivities.controlListeners('Enable');

% notify tensor basis functions
for index = 1:length(obj.BoundaryTopologies)
    obj.BoundaryTopologies(index).BasisFunctions.controlListeners('Enable');
end
for index = 1:length(obj.InteriorTopologies)
    obj.InteriorTopologies(index).BasisFunctions.controlListeners('Enable');
end
for index = 1:length(obj.ClosureTopologies)
    obj.ClosureTopologies(index).BasisFunctions.controlListeners('Enable');
end

end

function enableTopologyListeners(obj)

% notify topologies
for index = 1:length(obj.InteriorTopologies)
    obj.InteriorTopologies(index).controlListeners('Enable');
end
for index = 1:length(obj.BoundaryTopologies)
    obj.BoundaryTopologies(index).controlListeners('Enable');
end
for index = 1:length(obj.ClosureTopologies)
    obj.ClosureTopologies(index).controlListeners('Enable');
end
obj.ControlPoints.notify('notifyNewControlPointsSetted');

end

function newControlPoints = singleKnotVectorElevation(obj, varargin)

newControlPoints    = obj.ControlPoints.getAllControlPoints;
permuteOrder        = linspace(1, obj.ControlPoints.numberOfParametricCoordinates+1, obj.ControlPoints.numberOfParametricCoordinates+1);
dimensionsOrder     = [obj.ControlPoints.numberOfControlPoints obj.ControlPoints.numberOfCoordinates+1];
modifiedKnotVector  = varargin{2};

for parametricCoordinateIndex = 1:obj.ControlPoints.numberOfParametricCoordinates
    if modifiedKnotVector == obj.KnotVectors(parametricCoordinateIndex); break; end
    permuteOrder    = circshift(permuteOrder, [0 -1]);
    dimensionsOrder = circshift(dimensionsOrder, [0 -1]);
end

newControlPoints        = reshape(permute(newControlPoints, permuteOrder), dimensionsOrder(1), prod(dimensionsOrder(2:end)))';
[newControlPoints, newKnots]   = bsplineDegreeElevation(obj.GeneralInfo.degree(parametricCoordinateIndex), newControlPoints, modifiedKnotVector.knots, modifiedKnotVector.RefineData.depthOfOrderElevation);                                         % univariate bspline degree elevation of the fictitious bspline curve with num_n number of control points in a dim*num1*num2*... dimensional space, and the coresponding knot vector
dimensionsOrder(1)      = size(newControlPoints, 2);                                                           % the new number of control points in w direction of the control net
newControlPoints        = ipermute(reshape(newControlPoints', dimensionsOrder), permuteOrder);                             % reshaped back to a 4 dimensional array with the new control points number in the w direction

obj.ControlPoints.setNewControlPoints('Homogeneous', newControlPoints);
modifiedKnotVector.refinementHandler(newKnots);
obj.constructInformation;

end

function [newControlPoints, newKnotVector] = bsplineDegreeElevation(pDegree, controlPoints, knotVector, degreeElev)

[numOfCoordinates, numOfInitialControlPoints] = size(controlPoints);

bezierAlfaCoeffs                = zeros(pDegree+1, pDegree+degreeElev+1);
bezierControlPoints             = zeros(numOfCoordinates, pDegree+1);
elevatedBezierControlPoints     = zeros(numOfCoordinates, pDegree+degreeElev+1);
nextDegreeBezierControlPoints   = zeros(numOfCoordinates, pDegree+1);
alfaCoeffs                      = zeros(pDegree, 1);

numOfInitialKnotSpans           = numOfInitialControlPoints +pDegree;
newpDegree                      = pDegree +degreeElev;
newHalfpDegree                  = floor(newpDegree / 2);

% compute bezier degree elevation coefficeients
bezierAlfaCoeffs(1, 1)                      = 1;
bezierAlfaCoeffs(pDegree+1, newpDegree+1)   = 1;

for i = 1:newHalfpDegree
    inv = 1/bincoeff(newpDegree, i);
    mpi = min(pDegree, i);
    
    for j = max(0, i-degreeElev):mpi
        bezierAlfaCoeffs(j+1, i+1) = inv*bincoeff(pDegree,j)*bincoeff(degreeElev, i-j);
    end
end

for i = newHalfpDegree+1:newpDegree-1
    mpi = min(pDegree, i);
    for j = max(0, i-degreeElev):mpi
        bezierAlfaCoeffs(j+1, i+1) = bezierAlfaCoeffs(pDegree-j+1, newpDegree-i+1);
    end
end

mh              = newpDegree;
kind            = newpDegree +1;
r               = -1;
a               = pDegree;
knotSpanNumber  = pDegree+1;
cind            = 1;
firstKnot       = knotVector(1);

newControlPoints(1:numOfCoordinates, 1) = controlPoints(1:numOfCoordinates, 1);
newKnotVector(1:newpDegree+1)           = firstKnot;

bezierControlPoints(1:numOfCoordinates, 1:pDegree+1) = controlPoints(1:numOfCoordinates, 1:pDegree+1);

while knotSpanNumber < numOfInitialKnotSpans
    
    i = knotSpanNumber;
    while knotSpanNumber < numOfInitialKnotSpans && knotVector(knotSpanNumber+1) == knotVector(knotSpanNumber+2)
        knotSpanNumber = knotSpanNumber +1;
    end
    
    mul = knotSpanNumber - i + 1;
    mh = mh + mul + degreeElev;
    ub = knotVector(knotSpanNumber+1);
    oldr = r;
    r = pDegree -mul;
    
    % insert knot u(b) r times
    if oldr > 0
        lbz = floor((oldr+2)/2);
    else
        lbz = 1;
    end
    
    if r > 0
        rbz = newpDegree - floor((r+1)/2);
    else
        rbz = newpDegree;
    end
    
    if r > 0        
        % insert knot to get bezier segment
        numer = ub - firstKnot;
        for q = pDegree:-1:mul+1
            alfaCoeffs(q-mul) = numer / (knotVector(a+q+1)-firstKnot);
        end
        
        for j = 1:r
            save = r - j;
            s = mul + j;
            
            for q = pDegree:-1:s
                tmp1 = alfaCoeffs(q-s+1)*bezierControlPoints(1:numOfCoordinates, q+1);
                tmp2 = (1-alfaCoeffs(q-s+1))*bezierControlPoints(1:numOfCoordinates,q);
                bezierControlPoints(1:numOfCoordinates,q+1) = tmp1 + tmp2;
            end
            
            nextDegreeBezierControlPoints(1:numOfCoordinates, save+1) = bezierControlPoints(1:numOfCoordinates, pDegree+1);
        end
    end
    % end of insert knot
    
    % degree elevate bezier
    for i = lbz:newpDegree
        elevatedBezierControlPoints(1:numOfCoordinates, i+1) = 0;
        mpi = min(pDegree, i);
        for j = max(0, i-degreeElev):mpi
            tmp1 = elevatedBezierControlPoints(1:numOfCoordinates, i+1);
            tmp2 = bezierAlfaCoeffs(j+1,i+1)*bezierControlPoints(1:numOfCoordinates, j+1);
            elevatedBezierControlPoints(1:numOfCoordinates, i+1) = tmp1 + tmp2;
        end
    end
    % end of degree elevating bezier
    
    if oldr > 1
        
        % must remove knot u=k[a] oldr times
        first   = kind - 2;
        last    = kind;
        den     = ub - firstKnot;
        bet     = floor((ub-newKnotVector(kind)) / den);
        
        % knot removal loop
        for tr = 1:oldr-1
            i = first;
            j = last;
            kj = j - kind + 1;
            while j-i > tr
                
                % loop and compute the new control points, for one removal step
                if i < cind
                    alf     = (ub-newKnotVector(i+1))/(firstKnot-newKnotVector(i+1));
                    tmp1    = alf*newControlPoints(1:numOfCoordinates, i+1);
                    tmp2    = (1-alf)*newControlPoints(1:numOfCoordinates, i);
                    newControlPoints(1:numOfCoordinates, i+1) = tmp1 + tmp2;
                end
                if j >= lbz
                    if j-tr <= kind-newpDegree+oldr
                        gam = (ub-newKnotVector(j-tr+1)) / den;
                        tmp1 = gam*elevatedBezierControlPoints(:, kj+1);
                        tmp2 = (1-gam)*elevatedBezierControlPoints(:, kj+2);
                        elevatedBezierControlPoints(:, kj+1) = tmp1 + tmp2;
                    else
                        tmp1 = bet*elevatedBezierControlPoints(:, kj+1);
                        tmp2 = (1-bet)*elevatedBezierControlPoints(:, kj+2);
                        elevatedBezierControlPoints(:, kj+1) = tmp1 + tmp2;
                    end
                end
                i = i + 1;
                j = j - 1;
                kj = kj - 1;
            end
            
            first = first - 1;
            last = last + 1;
        
        end
    end
    % end of removing knot n=k[a]
    
    
    % load the knot ua
    if a ~= pDegree
        for i = 0:newpDegree-oldr-1
            newKnotVector(kind +1) = firstKnot;
            kind = kind + 1;
        end
    end
    
    
    % load ctrl pts into ic
    for j = lbz:rbz
        newControlPoints(:, cind+1) = elevatedBezierControlPoints(:, j+1);
        cind = cind + 1;
    end
    
    if knotSpanNumber < numOfInitialKnotSpans

        % setup for next pass thru loop
        for j = 0:r-1
            bezierControlPoints(:, j+1) = nextDegreeBezierControlPoints(:, j+1);
        end
        
        for j = r:pDegree
            bezierControlPoints(:, j+1) = controlPoints(:, knotSpanNumber-pDegree+j+1);
        end
        
        a               = knotSpanNumber;
        knotSpanNumber  = knotSpanNumber+1;
        firstKnot       = ub;

    else
        % end knot
        newKnotVector((1:newpDegree+1)+kind) = ub;
    end
    
end
% End big while loop

end

function b = bincoeff(n, k)
%  Computes the binomial coefficient.
%
%      ( n )      n!
%      (   ) = --------
%      ( k )   k!(n-k)!
%
%  b = bincoeff(n,k)
% double bincoeff(int n, int k)
% {
%   return floor(0.5+exp(factln(n)-factln(k)-factln(n-k)));
% }
%  Algorithm from 'Numerical Recipes in C, 2nd Edition' pg215.

b = floor( 0.5 +exp(factln(n)-factln(k)-factln(n-k)) );

end                                                       

function f = factln(n)
% computes ln(n!)
if n <= 1, f = 0; return, end

%log(factorial(n));
f = gammaln(n+1);

end
