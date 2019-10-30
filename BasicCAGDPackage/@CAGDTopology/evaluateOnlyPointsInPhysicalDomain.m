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

function evaluateOnlyPointsInPhysicalDomain(obj, varargin)

for index = 1:obj.TopologyInfo.totalNumberOfParametricCoordinates
    if isempty(obj.BasisFunctions.MonoParametricBasisFunctions(index).evaluationsPerKnotPatch)
        obj.BasisFunctions.MonoParametricBasisFunctions(index).evaluatePerKnotPatch;
    end
end

if isempty(obj.BasisFunctions.tensorBasisFunctions)
    obj.BasisFunctions.evaluateTensorProducts;
end

obj.ControlPoints.convertTypeOfCoordinates('Cartesian');

orientedControlPoints = permute(obj.ControlPoints.coordinates, [obj.Connectivities.controlPointsCountingSequence, ndims(obj.ControlPoints.coordinates)]);

if iscell(obj.BasisFunctions.tensorBasisFunctions)
    obj.pointsInPhysicalCoordinates  = cell(1, length(obj.BasisFunctions.tensorBasisFunctions));
    for knotPatchIndex = 1:length(obj.BasisFunctions.tensorBasisFunctions)
        
        leftKnot        = obj.Connectivities.knotPatch2Knots(knotPatchIndex, 1:2:end);
        controlIndices  = {obj.KnotVectors(obj.Connectivities.controlPointsCountingSequence(1)).knotPatch2BasisFunctions(leftKnot(1), :)};
        for parametricCoordinateIndex = obj.Connectivities.controlPointsCountingSequence(2:end)
            controlIndices  = cat(2, controlIndices, obj.KnotVectors(parametricCoordinateIndex).knotPatch2BasisFunctions(leftKnot(parametricCoordinateIndex), :));
        end
        
        currentControlPoints    = reshape(orientedControlPoints(controlIndices{:}, :), [], obj.ControlPoints.numberOfCoordinates);
        currentBasisFunctions   = obj.BasisFunctions.tensorBasisFunctions{knotPatchIndex}(:, :, :);
        
        for physicalCoordinateIndex = 1:obj.ControlPoints.numberOfCoordinates
            obj.pointsInPhysicalCoordinates{knotPatchIndex}(physicalCoordinateIndex, :) = sum(currentBasisFunctions(:, :, 1).*repmat(currentControlPoints(:, physicalCoordinateIndex), 1, obj.BasisFunctions.numberOfEvaluationPoints(knotPatchIndex)), 1);
        end
        
    end
else
    obj.pointsInPhysicalCoordinates = zeros(obj.BasisFunctions.numberOfEvaluationPoints, obj.ControlPoints.numberOfCoordinates, obj.Connectivities.numberOfKnotPatches);
    for knotPatchIndex = 1:obj.Connectivities.numberOfKnotPatches
        
        leftKnot        = obj.Connectivities.knotPatch2Knots(knotPatchIndex, 1:2:end);
        controlIndices  = {obj.KnotVectors(obj.Connectivities.controlPointsCountingSequence(1)).knotPatch2BasisFunctions(leftKnot(1), :)};
        for parametricCoordinateIndex = obj.Connectivities.controlPointsCountingSequence(2:end)
            controlIndices  = cat(2, controlIndices, obj.KnotVectors(parametricCoordinateIndex).knotPatch2BasisFunctions(leftKnot(parametricCoordinateIndex), :));
        end
        
        currentControlPoints    = reshape(orientedControlPoints(controlIndices{:}, :), [], obj.ControlPoints.numberOfCoordinates);
        currentBasisFunctions   = obj.BasisFunctions.tensorBasisFunctions(:, :, :, knotPatchIndex);
        
        for physicalCoordinateIndex = 1:obj.ControlPoints.numberOfCoordinates
            obj.pointsInPhysicalCoordinates(:, physicalCoordinateIndex, knotPatchIndex) = sum(currentBasisFunctions(:, :, 1).*repmat(currentControlPoints(:, physicalCoordinateIndex), 1, obj.BasisFunctions.numberOfEvaluationPoints), 1);
        end
        
    end

end

end