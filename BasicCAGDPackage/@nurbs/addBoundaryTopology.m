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

function numberOfStackedBoundaryTopology = addBoundaryTopology(obj, boundaryType, boundaryNumber, EvaluationSettings, varargin)

if nargin < 4
    throw(MException('nurbs:addBoundaryTopology', 'Insufficient input data, provide the boundary type and the boundary number as the first two input arguments, and the evaluation settings as third.'));
end

relevantParametricCoordinates = CAGDBoundaryTopology.findRelativeKnotVectors(boundaryType, boundaryNumber, obj.GeneralInfo.totalNumberOfParametricCoordinates);
relevantStackedBasisFunctionsIndices = zeros(1, length(relevantParametricCoordinates));
numOfFuns = zeros(1, length(relevantParametricCoordinates));
relevantStackedBasisFunctions = bSplineBasisFunctions.empty(1, 0);
for parameterIndex = 1:length(relevantParametricCoordinates)
    relevantStackedBasisFunctionsIndices(parameterIndex) = requestBasisFunctions(obj, relevantParametricCoordinates(parameterIndex), EvaluationSettings(parameterIndex));
    relevantStackedBasisFunctions(parameterIndex) = obj.MonoParametricBasisFunctions(relevantParametricCoordinates(parameterIndex)).BasisFunctions(relevantStackedBasisFunctionsIndices(parameterIndex));
    numOfFuns(parameterIndex) = relevantStackedBasisFunctions(parameterIndex).KnotVector.numberOfBasisFunctions;
end

relevantControlPointsIndices = CAGDBoundaryTopology.findRelativeControlPoints(boundaryType, boundaryNumber, obj.Connectivities);
if isa(obj.ControlPoints, 'rationalControlPointsStructure')
    relevantControlPoints = obj.ControlPoints.getControlPointsCoordinates(relevantControlPointsIndices);
    relevantControlPoints = reshape(relevantControlPoints, [numOfFuns, obj.ControlPoints.numberOfCoordinates]);
    relevantControlPointsWeights = obj.ControlPoints.getControlPointsWeights(relevantControlPointsIndices);
    if numel(numOfFuns)>1; relevantControlPointsWeights = reshape(relevantControlPointsWeights, numOfFuns); end
    relevantControlPoints = rationalControlPointsStructure('Cartesian', relevantControlPoints, relevantControlPointsWeights);
elseif isa(obj.ControlPoints, 'controlPointsStructure')
    relevantControlPoints = obj.ControlPoints.getControlPointsCoordinates(relevantControlPointsIndices);
    relevantControlPoints = shiftdim(reshape(relevantControlPoints, [obj.ControlPoints.numberOfCoordinates, numOfFuns]), 1);
    relevantControlPoints = controlPointsStructure(relevantControlPoints);
end

obj.BoundaryTopologies = cat(2, obj.BoundaryTopologies, CAGDBoundaryTopology(boundaryType, boundaryNumber, relevantStackedBasisFunctions, relevantControlPoints, relevantParametricCoordinates, relevantStackedBasisFunctionsIndices, relevantControlPointsIndices));
numberOfStackedBoundaryTopology = obj.TopologiesInfo.numberOfStackedBoundaryTopologies+1;
obj.TopologiesInfo.numberOfStackedBoundaryTopologies = numberOfStackedBoundaryTopology;

end