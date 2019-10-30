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

function knotRefinement(obj, varargin)

oldTypeOfCoordinates = obj.ControlPoints.typeOfCoordinates;
if strcmp(obj.ControlPoints.typeOfCoordinates, 'Cartesian'); obj.ControlPoints.convertTypeOfCoordinates('Homogeneous'); end

if nargin == 1
else
    switch varargin{1}
        case 'knotVectorHandle'
            if strcmp(varargin{2}.RefineData.type, 'KnotInsertion') || strcmp(varargin{2}.RefineData.type, 'GlobalKnotInsertion')
                singleKnotVectorInsertion(obj, varargin{:}); return
            elseif strcmp(varargin{2}.RefineData.type, 'KnotRemoval') || strcmp(varargin{2}.RefineData.type, 'GlobalKnotRemoval')
                singleKnotVectorRemoval(obj, varargin{:}); return
            end
            
        case 'insertKnots'
            if nargin > 3; coords = varargin{3}; else coords = 1:obj.Connectivities.numberOfParametricCoordinates; end
            disableListeners(obj);
            coordsIndex = 1;
            for parametricCoordinateIndex = coords(1:end-1)
                obj.KnotVectors(parametricCoordinateIndex).insertKnot(varargin{2}{coordsIndex});
                coordsIndex = coordsIndex+1;
            end
            
            enableListeners(obj);
            obj.KnotVectors(coords(end)).insertKnot(varargin{2}{coordsIndex});
            enableTopologyListeners(obj);
            
        case 'removeKnotsbyValue'
            if nargin > 3; coords = varargin{3}; else coords = 1:obj.Connectivities.numberOfParametricCoordinates; end
            disableListeners(obj);
            coordsIndex = 1;
            for parametricCoordinateIndex = coords(1:end-1)
                obj.KnotVectors(parametricCoordinateIndex).removeKnotsbyValue(varargin{2}{coordsIndex});
                coordsIndex = coordsIndex+1;
            end
            
            enableListeners(obj);
            obj.KnotVectors(coords(end)).removeKnotsbyValue(varargin{2}{coordsIndex});
            enableTopologyListeners(obj);
            
        case 'removeKnotsbyNumber'
            if nargin > 3; coords = varargin{3}; else coords = 1:obj.Connectivities.numberOfParametricCoordinates; end
            disableListeners(obj);
            coordsIndex = 1;
            for parametricCoordinateIndex = coords(1:end-1)
                obj.KnotVectors(parametricCoordinateIndex).removeKnotsbyNumber(varargin{2}{coordsIndex});
                coordsIndex = coordsIndex+1;
            end
            
            enableListeners(obj);
            obj.KnotVectors(coords(end)).removeKnotsbyNumber(varargin{2}{coordsIndex});
            enableTopologyListeners(obj);
            
        case 'insertMidSpanKnots'
            if nargin > 2; coords = varargin{2}; else coords = 1:obj.Connectivities.numberOfParametricCoordinates; end
            disableListeners(obj);
            for parametricCoordinateIndex = coords(1:end-1)
                obj.KnotVectors(parametricCoordinateIndex).insertMidSpanKnots;
            end
            enableListeners(obj);
            obj.KnotVectors(coords(end)).insertMidSpanKnots;
            enableTopologyListeners(obj);
            
        case 'degradeContinuity_kRefinement'
            if nargin > 2; coords = varargin{2}; else coords = 1:obj.Connectivities.numberOfParametricCoordinates; end
            if nargin > 3; depth = varargin{2}; else depth = ones(1, length(coords)); end
            disableListeners(obj);
            coordsIndex = 1;
            for parametricCoordinateIndex = coords(1:end-1)
                obj.KnotVectors(parametricCoordinateIndex).degradeContinuity_kRefinement(depth(coordsIndex));
                coordsIndex = coordsIndex+1;
            end
            
            enableListeners(obj);
            obj.KnotVectors(coords(end)).degradeContinuity_kRefinement(depth(coordsIndex));
            enableTopologyListeners(obj);
            
        case 'elevateContinuity_kRefinement'
            if nargin > 2; coords = varargin{2}; else coords = 1:obj.Connectivities.numberOfParametricCoordinates; end
            if nargin > 3; depth = varargin{2}; else depth = ones(1, length(coords)); end
            disableListeners(obj);
            coordsIndex = 1;
            for parametricCoordinateIndex = coords(1:end-1)
                obj.KnotVectors(parametricCoordinateIndex).elevateContinuity_kRefinement(depth(coordsIndex));
                coordsIndex = coordsIndex+1;
            end
            
            enableListeners(obj);
            obj.KnotVectors(coords(end)).elevateContinuity_kRefinement(depth(coordsIndex));
            enableTopologyListeners(obj);
            
        otherwise
            throw(MException('nurbs:knotRefinement', 'Provide a valid string identifier as first argument: ''insertKnots'', ''insertMidSpanKnots'', ''degradeContinuity_kRefinement''.'));
    end
end

if strcmp(oldTypeOfCoordinates, 'Cartesian'); obj.ControlPoints.convertTypeOfCoordinates('Cartesian'); end

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

function singleKnotVectorInsertion(obj, varargin)

newControlPoints    = obj.ControlPoints.getAllControlPoints;
permuteOrder        = linspace(1, obj.ControlPoints.numberOfParametricCoordinates+1, obj.ControlPoints.numberOfParametricCoordinates+1);
dimensionsOrder     = [obj.ControlPoints.numberOfControlPoints obj.ControlPoints.numberOfCoordinates+1];
modifiedKnotVector  = varargin{2};

for parametricCoordinateIndex = 1:obj.ControlPoints.numberOfParametricCoordinates
    if modifiedKnotVector == obj.KnotVectors(parametricCoordinateIndex); break; end
    permuteOrder    = circshift(permuteOrder, [0 -1]);
    dimensionsOrder = circshift(dimensionsOrder, [0 -1]);
end

newControlPoints        = reshape(permute(newControlPoints, permuteOrder), dimensionsOrder(1), [])';
[newControlPoints, ~]   = bSplineKnotInsertion(modifiedKnotVector.order-1, newControlPoints, modifiedKnotVector.knots, modifiedKnotVector.RefineData.insertionKnots);                                       % the control points array is reshaped to a two dimensional array (matrix dim*num1*num2 x num3), which results a fictitious curve's control polygon with num3 number of control points in a 4*num1*num2 dimensional space
dimensionsOrder(1)      = size(newControlPoints, 2);                                                           % the new number of control points in w direction of the control net
newControlPoints        = ipermute(reshape(newControlPoints', dimensionsOrder), permuteOrder);                             % reshaped back to a 4 dimensional array with the new control points number in the w direction

obj.ControlPoints.setNewControlPoints('Homogeneous', newControlPoints);
modifiedKnotVector.refinementHandler;
obj.constructInformation;

end

function singleKnotVectorRemoval(obj, varargin)

newControlPoints    = obj.ControlPoints.getAllControlPoints;
permuteOrder        = linspace(1, obj.ControlPoints.numberOfParametricCoordinates+1, obj.ControlPoints.numberOfParametricCoordinates+1);
dimensionsOrder     = [obj.ControlPoints.numberOfControlPoints obj.ControlPoints.numberOfCoordinates+1];
modifiedKnotVector  = varargin{2};

for parametricCoordinateIndex = 1:obj.ControlPoints.numberOfParametricCoordinates
    if modifiedKnotVector == obj.KnotVectors(parametricCoordinateIndex); break; end
    permuteOrder    = circshift(permuteOrder, [0 -1]);
    dimensionsOrder = circshift(dimensionsOrder, [0 -1]);
end

newControlPoints            = reshape(permute(newControlPoints, permuteOrder), dimensionsOrder(1), [])';
[~, newControlPoints, ~]    = bSplineKnotRemoval(modifiedKnotVector.order-1, newControlPoints, modifiedKnotVector.knots, modifiedKnotVector.RefineData.removedKnotValues, modifiedKnotVector.RefineData.removeMultiplicity, 1);
dimensionsOrder(1)          = size(newControlPoints, 2);                                              % the new number of control points in w direction of the control net
newControlPoints            = ipermute(reshape(newControlPoints', dimensionsOrder), permuteOrder);    % reshaped back to a 4 dimensional array with the new control points number in the w direction

obj.ControlPoints.setNewControlPoints('Homogeneous', newControlPoints);
modifiedKnotVector.refinementHandler;
obj.constructInformation;
   
end

function [newControlPoints, newKnotVector] = bSplineKnotInsertion(pDegree, controlPoints, knotVector, insertedKnots)

[numOfCoordinates, numOfInitialControlPoints] = size(controlPoints);

insertedKnots       = sort(insertedKnots);
numOfNewKnots       = numel(insertedKnots);
numOfInitialKnots   = numel(knotVector);

newControlPoints    = zeros(numOfCoordinates, numOfInitialControlPoints+numOfNewKnots);
newKnotVector       = zeros(1, numOfInitialKnots+numOfNewKnots);

firstInsKnotSpanNumber  = FindSpan(pDegree+1, knotVector, insertedKnots(1));
lastInsKnotSpanNumber   = FindSpan(pDegree+1, knotVector, insertedKnots(numOfNewKnots)) +1;

%  Copy non-modified control points
newControlPoints(:, 1:(firstInsKnotSpanNumber-pDegree+1)) = controlPoints(:, 1:(firstInsKnotSpanNumber-pDegree+1));
newControlPoints(:, (lastInsKnotSpanNumber:numOfInitialControlPoints)+numOfNewKnots) = controlPoints(:, (lastInsKnotSpanNumber:numOfInitialControlPoints));

%  Copy non-modified knots
newKnotVector(1:(firstInsKnotSpanNumber+1)) = knotVector(1:(firstInsKnotSpanNumber+1));
newKnotVector((lastInsKnotSpanNumber:numOfInitialControlPoints)+pDegree+1+numOfNewKnots) = knotVector((lastInsKnotSpanNumber:numOfInitialControlPoints)+pDegree+1);

lastModifiedControlPoint    = lastInsKnotSpanNumber +pDegree -1;
newLastModifiedControlPoint = lastInsKnotSpanNumber +pDegree -1 +numOfNewKnots;

for newKnotIndex = numOfNewKnots:-1:1
    
    while insertedKnots(newKnotIndex) <= knotVector(lastModifiedControlPoint+1) && lastModifiedControlPoint > firstInsKnotSpanNumber
        newControlPoints(:, newLastModifiedControlPoint-pDegree)    = controlPoints(:, lastModifiedControlPoint-pDegree);
        newKnotVector(newLastModifiedControlPoint+1)                = knotVector(lastModifiedControlPoint+1);
        newLastModifiedControlPoint                                 = newLastModifiedControlPoint -1;
        lastModifiedControlPoint                                    = lastModifiedControlPoint -1;
    end
    
    newControlPoints(:, newLastModifiedControlPoint-pDegree) = newControlPoints(:, newLastModifiedControlPoint-pDegree+1);
    
    for modifiedControlPointIndex = 1:pDegree
        index   = newLastModifiedControlPoint -pDegree +modifiedControlPointIndex;
        alfa    = newKnotVector(newLastModifiedControlPoint+modifiedControlPointIndex+1) -insertedKnots(newKnotIndex);
        if abs(alfa) == 0
            newControlPoints(:, index) = newControlPoints(:, index+1);
        else
            alfa    = alfa/(newKnotVector(newLastModifiedControlPoint+modifiedControlPointIndex+1) -knotVector(lastModifiedControlPoint-pDegree+modifiedControlPointIndex+1));
            tmp     = (1-alfa)*newControlPoints(:, index+1);
            newControlPoints(:, index) = alfa*newControlPoints(:, index) + tmp;
        end
    end
    
    newKnotVector(newLastModifiedControlPoint+1)    = insertedKnots(newKnotIndex);
    newLastModifiedControlPoint                     = newLastModifiedControlPoint -1;
    
end

end

function [numberOfRemovedKnots, newKnotVector, newControlPoints] = bSplineKnotRemoval(degree, controlPoints, knotVector, removedKnotValues, removalMultiplicities, numOfRemovals)

order   = degree+1;

removedKnotIndices = FindSpan(order, knotVector, removedKnotValues);

% m=n+p+1;
fcpout  = (2*removedKnotIndices-removalMultiplicities-degree)/2; % first control point out
last    = removedKnotIndices-removalMultiplicities;
first   = removedKnotIndices-degree;
TOL     = 1e-7;

for numberOfRemovedKnots = 1:numOfRemovals
    % this loop os Eq 5.28
    off                 = first-1; % difference in index between temp and P
    temp(1,:)           = controlPoints(off+1,:);
    temp(last+1-off+1,:)= controlPoints(last+1+1,:);
    i                   = first;
    j                   = last;
    ii                  = 1;
    jj                  = last-off;
    removedFlag         = 0;
    while j-i>numberOfRemovedKnots
        % compute new control points for one removal step
        alfi        =(removedKnotValues-knotVector(i+1))/(knotVector(i+order+numberOfRemovedKnots+1)-knotVector(i+1));
        alfj        =(removedKnotValues-knotVector(j-numberOfRemovedKnots+1))/(knotVector(j+order+1)-knotVector(j-numberOfRemovedKnots+1));
        temp(ii+1,:)=(controlPoints(i,:)-(1-alfi)*temp(ii-1+1))/alfi;
        temp(jj+1,:)=(controlPoints(j,:)-alfj*temp(jj+1+1))/(1-alfj);
        i=i+1; ii=ii+1;
        j=j-1; jj=jj-1;
    end % end of while loop
    if j-i<numberOfRemovedKnots % check if knot removable
        if norm(temp(ii-1+1,:)-temp(jj+1+1,:), 2)<=TOL
            removedFlag=1;
        end
    else
        alfi = (removedKnotValues-knotVector(i+1))/(knotVector(i+order+numberOfRemovedKnots+1)-knotVector(i+1));
        if norm(controlPoints(i+1,:)-alfi*temp(ii+numberOfRemovedKnots+1+1,:)+(1-alfi)*temp(ii-1+1,:), 2)<=TOL
            removedFlag=1;
        end
    end
    if removedFlag==0 % cannot remove any more knots
        break;    % get out of for-loop
    else
        % successful removal. Save new control points
        i=first;
        j=last;
        while j-i>numberOfRemovedKnots
            controlPoints(i+1,:)=temp(i-off+1,:);
            controlPoints(j+1,:)=temp(j-off+1,:);
            i=i+1;
            j=j-1;
        end
    end
    first=first-1;
    last=last+1;
end % end of for-loop
if numberOfRemovedKnots==0, return; end
for k=removedKnotIndices+1:length(knotVector)
    knotVector(k-numberOfRemovedKnots)=knotVector(k); % shift knots
end
j=fcpout;
i=j; % Pj through Pi will be overwritten
for k=1:numberOfRemovedKnots-1
    if mod(k,2)==1
        i=i+1;
    else
        j=j-1;
    end
end
for k=i+1:length(knotVector)-degree-1 % shift
    controlPoints(j,:) = controlPoints(k,:);
    j = j+1;
end

for iPu = 1:length(knotVector)-degree-1-numberOfRemovedKnots
	newControlPoints(iPu,:) = controlPoints(iPu,:);
end
for iU = 1:length(knotVector)-numberOfRemovedKnots
    newKnotVector(iU) = knotVector(iU);
end

newControlPoints = newControlPoints';

end

function uspans = FindSpan(order, knotVector, knotValues)
% Determine the knot span index
% Input: order, knotValue, knotVector
% Return: the knot span index

uspans = zeros(1, length(knotValues));

for knotValueIndex = 1:length(knotValues)
    
    knotValue = knotValues(knotValueIndex);
    
    n = length(knotVector)-order-1;  % n=m-p-1=(length(U)-1)-p-1=length(U)-p-2
    
    if (knotValue == knotVector(n+2))     % Check the equality with the last knot of the last non-zero span, the position of it is the last element of the knot vector subtracting the multiplicity of the last knot minus one.  length(U)-p
        
        uspan = n;    % The last non-zero span is indexed as length(U)-p-1
        
    else
        
        low     = order;      % Setting the bounds of the initial interval
        high    = n+2;
        mid     = floor((low+high)/2);   % Applying the midsection method
        iter    = 0;
        
        while (knotValue<knotVector(mid) || knotValue>=knotVector(mid+1)) % Checking if u is in [mid,mid+1] span
            
            if (knotValue<knotVector(mid)); high = mid;
            else                            low  = mid;
            end
            
            mid     = floor((low+high)/2);
            iter    = iter+1;
            
            if iter == n; throw(MException('CAGD:knotVectorFindSpan', 'Incosistent bspline data, verify the data')); end
            
        end
        
        uspan = mid-1;           % The final result if u is in [mid,mid+1] span
        
    end
    
    uspans(knotValueIndex) = uspan;
    
end

end
