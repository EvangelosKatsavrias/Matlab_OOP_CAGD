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

function evaluateAllParametric2PhysicalMappings(obj, varargin)

for index = 1:obj.TopologyInfo.totalNumberOfParametricCoordinates
    if isempty(obj.BasisFunctions.MonoParametricBasisFunctions(index).evaluationsPerKnotPatch)
        obj.BasisFunctions.MonoParametricBasisFunctions(index).evaluatePerKnotPatch;
    end
end

if isempty(obj.BasisFunctions.tensorBasisFunctions); obj.BasisFunctions.evaluateTensorProducts; end
obj.ControlPoints.convertTypeOfCoordinates('Cartesian');
orientedControlPoints = permute(obj.ControlPoints.coordinates, [obj.Connectivities.controlPointsCountingSequence ndims(obj.ControlPoints.coordinates)]);

if iscell(obj.BasisFunctions.tensorBasisFunctions)
	dataInCells(obj, orientedControlPoints);
else
    evaluatePointCoordinatesNJacobians(obj, orientedControlPoints);
    evaluateJacobianDeterminants(obj);
    evaluateInverseJacobians(obj);

end

end


function evaluatePointCoordinatesNJacobians(obj, orientedControlPoints)

obj.pointsInPhysicalCoordinates  = zeros(obj.BasisFunctions.numberOfEvaluationPoints, obj.ControlPoints.numberOfCoordinates, obj.Connectivities.numberOfKnotPatches);
obj.parametric2PhysicalJacobians = zeros(obj.ControlPoints.numberOfCoordinates, obj.ControlPoints.numberOfCoordinates, obj.BasisFunctions.numberOfEvaluationPoints, obj.Connectivities.numberOfKnotPatches);
%     obj.parametric2PhysicalJacobians = zeros(obj.Connectivities.numberOfParametricCoordinates, obj.ControlPoints.numberOfCoordinates, obj.BasisFunctions.numberOfEvaluationPoints, obj.Connectivities.numberOfKnotPatches);

for knotPatchIndex = 1:obj.Connectivities.numberOfKnotPatches
    %% prepare the corresponding data of the current knot patch
    leftKnot        = obj.Connectivities.knotPatch2Knots(knotPatchIndex, 1:2:end);
    controlIndices  = {obj.KnotVectors(obj.Connectivities.controlPointsCountingSequence(1)).knotPatch2BasisFunctions(leftKnot(1), :)};
    for parametricCoordinateIndex = obj.Connectivities.controlPointsCountingSequence(2:end)
        controlIndices  = cat(2, controlIndices, obj.KnotVectors(parametricCoordinateIndex).knotPatch2BasisFunctions(leftKnot(parametricCoordinateIndex), :));
    end
    
    currentControlPoints    = reshape(orientedControlPoints(controlIndices{:}, :), [], obj.ControlPoints.numberOfCoordinates);
    currentBasisFunctions   = obj.BasisFunctions.tensorBasisFunctions(:, :, :, knotPatchIndex);
    
    %% calculate the coordinates of the mapped points in the physical domain, and the map jacobians from the parametric to the physical domain
    for physicalCoordinateIndex = 1:obj.ControlPoints.numberOfCoordinates
        obj.pointsInPhysicalCoordinates(:, physicalCoordinateIndex, knotPatchIndex) = sum(currentBasisFunctions(:, :, 1).*repmat(currentControlPoints(:, physicalCoordinateIndex), 1, obj.BasisFunctions.numberOfEvaluationPoints), 1);
        for parametricCoordinateIndex = 1:obj.Connectivities.numberOfParametricCoordinates
            obj.parametric2PhysicalJacobians(parametricCoordinateIndex, physicalCoordinateIndex, :, knotPatchIndex) ...
                = sum(currentBasisFunctions(:, :, parametricCoordinateIndex+1) ...
                .*repmat(currentControlPoints(:, physicalCoordinateIndex), 1, obj.BasisFunctions.numberOfEvaluationPoints), 1);
        end
    end
    
end

end


function evaluateJacobianDeterminants(obj)

obj.parametric2PhysicalDetOfJacobians = zeros(obj.BasisFunctions.numberOfEvaluationPoints, obj.Connectivities.numberOfKnotPatches);

if obj.ControlPoints.numberOfCoordinates == obj.Connectivities.numberOfParametricCoordinates
    for knotPatchIndex = 1:obj.Connectivities.numberOfKnotPatches
        for evaluationPointIndex = 1:obj.BasisFunctions.numberOfEvaluationPoints
            obj.parametric2PhysicalDetOfJacobians(evaluationPointIndex, knotPatchIndex) = det(obj.parametric2PhysicalJacobians(:, :, evaluationPointIndex, knotPatchIndex));
        end
    end
    
elseif obj.Connectivities.numberOfParametricCoordinates==2 && obj.ControlPoints.numberOfCoordinates==3
    for knotPatchIndex = 1:obj.Connectivities.numberOfKnotPatches
        obj.parametric2PhysicalJacobians(3, 1:3, :, knotPatchIndex) ...
            = cross(squeeze(obj.parametric2PhysicalJacobians(1, :, :, knotPatchIndex)), ...
                    squeeze(obj.parametric2PhysicalJacobians(2, :, :, knotPatchIndex)), 1);
    end
    
    for knotPatchIndex = 1:obj.Connectivities.numberOfKnotPatches
        for evaluationPointIndex = 1:obj.BasisFunctions.numberOfEvaluationPoints
            obj.parametric2PhysicalDetOfJacobians(evaluationPointIndex, knotPatchIndex) = norm(obj.parametric2PhysicalJacobians(3, :, evaluationPointIndex, knotPatchIndex));
        end
    end
    
elseif obj.Connectivities.numberOfParametricCoordinates==1
    for knotPatchIndex = 1:obj.Connectivities.numberOfKnotPatches
        for evaluationPointIndex = 1:obj.BasisFunctions.numberOfEvaluationPoints
            obj.parametric2PhysicalDetOfJacobians(evaluationPointIndex, knotPatchIndex) = norm(obj.parametric2PhysicalJacobians(1, :, evaluationPointIndex, knotPatchIndex), 2);
        end
    end
    
    if  obj.ControlPoints.numberOfCoordinates == 2
        obj.parametric2PhysicalJacobians(2, 1, :, :) = -obj.parametric2PhysicalJacobians(1, 2, :, :);
        obj.parametric2PhysicalJacobians(2, 2, :, :) =  obj.parametric2PhysicalJacobians(1, 1, :, :);
    elseif obj.ControlPoints.numberOfCoordinates == 3
        obj.parametric2PhysicalJacobians(2, 1, :, :) = -obj.parametric2PhysicalJacobians(1, 2, :, :);
        obj.parametric2PhysicalJacobians(2, 2, :, :) =  obj.parametric2PhysicalJacobians(1, 1, :, :);
        for knotPatchIndex = 1:obj.Connectivities.numberOfKnotPatches
            obj.parametric2PhysicalJacobians(3, 1:3, :, knotPatchIndex) ...
                = cross(squeeze(obj.parametric2PhysicalJacobians(1, :, :, knotPatchIndex)), ...
                        squeeze(obj.parametric2PhysicalJacobians(2, :, :, knotPatchIndex)), 1);
        end

    end
    
    %         dxyzdu=P*dRdu';
    %         param2phys_jac=norm(xyz-xyz0)/(u0-elknot(1));
    %         param2phys_jac=norm(dxyzdu,2);
    %         param2phys_jac=(xyz-xyz0)'*dxyzdu/norm(xyz-xyz0);
    
end

end


function evaluateInverseJacobians(obj)

if 0 %obj.Connectivities.numberOfParametricCoordinates==1 && obj.ControlPoints.numberOfCoordinates == 3
    obj.parametric2PhysicalInverseJacobians = 1./obj.parametric2PhysicalDetOfJacobians;
    
else
    obj.parametric2PhysicalInverseJacobians = zeros(obj.ControlPoints.numberOfCoordinates, obj.ControlPoints.numberOfCoordinates, obj.BasisFunctions.numberOfEvaluationPoints, obj.Connectivities.numberOfKnotPatches);
    % obj.parametric2PhysicalInverseJacobians = zeros(obj.ControlPoints.numberOfParametricCoordinates, obj.ControlPoints.numberOfCoordinates, obj.BasisFunctions.numberOfEvaluationPoints, obj.Connectivities.numberOfKnotPatches);
    
    for knotPatchIndex = 1:obj.Connectivities.numberOfKnotPatches
        for evaluationPointIndex = 1:obj.BasisFunctions.numberOfEvaluationPoints
            obj.parametric2PhysicalInverseJacobians(:, :, evaluationPointIndex, knotPatchIndex)  = obj.parametric2PhysicalJacobians(:, :, evaluationPointIndex, knotPatchIndex)^-1;
        end
    end

end

end


function dataInCells(obj, orientedControlPoints)

    obj.pointsInPhysicalCoordinates  = cell(1, length(obj.BasisFunctions.tensorBasisFunctions));
    obj.parametric2PhysicalJacobians = cell(1, length(obj.BasisFunctions.tensorBasisFunctions));
    for knotPatchIndex = 1:length(obj.BasisFunctions.tensorBasisFunctions)
        %% prepare the corresponding data of the current knot patch
        leftKnot        = obj.Connectivities.knotPatch2Knots(knotPatchIndex, 1:2:end);
        controlIndices  = {obj.KnotVectors(obj.Connectivities.controlPointsCountingSequence(1)).knotPatch2BasisFunctions(leftKnot(1), :)};
        for parametricCoordinateIndex = obj.Connectivities.controlPointsCountingSequence(2:end)
            controlIndices  = cat(2, controlIndices, obj.KnotVectors(parametricCoordinateIndex).knotPatch2BasisFunctions(leftKnot(parametricCoordinateIndex), :));
        end
        
        currentControlPoints    = reshape(orientedControlPoints(controlIndices{:}, :), [], obj.ControlPoints.numberOfCoordinates);
        currentBasisFunctions   = obj.BasisFunctions.tensorBasisFunctions{knotPatchIndex}(:, :, :);

        %% calculate the coordinates of the mapped points in the physical domain, and the map jacobians from the parametric to the physical domain
        for physicalCoordinateIndex = 1:obj.ControlPoints.numberOfCoordinates
            obj.pointsInPhysicalCoordinates{knotPatchIndex}(physicalCoordinateIndex, :) = sum(currentBasisFunctions(:, :, 1).*repmat(currentControlPoints(:, physicalCoordinateIndex), 1, obj.BasisFunctions.numberOfEvaluationPoints(knotPatchIndex)), 1);
            for parametricCoordinateIndex = 1:obj.Connectivities.numberOfParametricCoordinates
                obj.parametric2PhysicalJacobians{knotPatchIndex}(parametricCoordinateIndex, physicalCoordinateIndex, :) = sum(currentBasisFunctions(:, :, parametricCoordinateIndex+1).*repmat(currentControlPoints(:, physicalCoordinateIndex), 1, obj.BasisFunctions.numberOfEvaluationPoints(knotPatchIndex)), 1);
            end
        end
    end
    
    %% find jacobian determinants of the map
    if obj.ControlPoints.numberOfCoordinates == obj.Connectivities.numberOfParametricCoordinates
        obj.parametric2PhysicalDetOfJacobians    = cell(1, length(obj.BasisFunctions.tensorBasisFunctions));
        obj.parametric2PhysicalInverseJacobians  = cell(1, length(obj.BasisFunctions.tensorBasisFunctions));
        for knotPatchIndex = 1:length(obj.BasisFunctions.tensorBasisFunctions)
            for evaluationPointIndex = 1:obj.BasisFunctions.numberOfEvaluationPoints(knotPatchIndex)
                obj.parametric2PhysicalDetOfJacobians{knotPatchIndex}(evaluationPointIndex)          = det(obj.parametric2PhysicalJacobians{knotPatchIndex}(:, :, evaluationPointIndex));
                obj.parametric2PhysicalInverseJacobians{knotPatchIndex}(:, :, evaluationPointIndex)  = obj.parametric2PhysicalJacobians{knotPatchIndex}(:, :, evaluationPointIndex)^-1;
            end
        end
    end
    
end