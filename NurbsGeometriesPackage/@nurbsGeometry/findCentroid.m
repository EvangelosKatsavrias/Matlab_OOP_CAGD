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

function findCentroid(obj)

switch obj.Connectivities.numberOfParametricCoordinates

    case 1
        numOfEvalPoints = obj.BasisFunctions.MonoParametricBasisFunctions.numberOfEvaluationPointsPerKnotPatch;
        parentPatchDiffVolume = 1/(numOfEvalPoints-1);
        
        patchVolume = zeros(1, obj.Connectivities.numberOfKnotPatches);
        obj.TopologyInfo.firstMoments = zeros(obj.Connectivities.numberOfKnotPatches, obj.ControlPoints.numberOfCoordinates);
        obj.TopologyInfo.patchCentroids = zeros(obj.Connectivities.numberOfKnotPatches, obj.ControlPoints.numberOfCoordinates);
        obj.TopologyInfo.topologyCentroid = zeros(1, obj.ControlPoints.numberOfCoordinates);
        for patchIndex = 1:obj.Connectivities.numberOfKnotPatches
            jacsTemp = obj.parametric2PhysicalDetOfJacobians(:, patchIndex);
            pointsTemp = obj.pointsInPhysicalCoordinates(:, :, patchIndex);
            
            for index1 = 1:numOfEvalPoints(1)-1
                jacVal = mean(jacsTemp(index1:index1+1));
                pointVal = squeeze(mean(pointsTemp(index1:index1+1, :)));
                
                diffVolume = parentPatchDiffVolume*obj.parent2ParametricDetOfJacobians(patchIndex)*jacVal;
                patchVolume(patchIndex) = patchVolume(patchIndex)+ diffVolume;
                
                for coordinateIndex = 1:obj.ControlPoints.numberOfCoordinates
                    obj.TopologyInfo.firstMoments(patchIndex, coordinateIndex) = ...
                        obj.TopologyInfo.firstMoments(patchIndex, coordinateIndex)...
                        +pointVal(coordinateIndex)*diffVolume;
                end
                
            end
            obj.TopologyInfo.patchCentroids(patchIndex, :) = obj.TopologyInfo.firstMoments(patchIndex, :)/patchVolume(patchIndex);
            
        end
        
        obj.TopologyInfo.topologyCentroid = sum(obj.TopologyInfo.firstMoments, 1)/sum(patchVolume);
        
    case 2
        parentPatchDiffVolume = 1;
        numOfEvalPoints = zeros(1, 2);
        for parametricIndex = 1:2
            parentPatchDiffVolume = parentPatchDiffVolume*(obj.BasisFunctions.MonoParametricBasisFunctions(parametricIndex).numberOfEvaluationPointsPerKnotPatch-1);
            numOfEvalPoints(parametricIndex) = obj.BasisFunctions.MonoParametricBasisFunctions(parametricIndex).numberOfEvaluationPointsPerKnotPatch;
        end
        parentPatchDiffVolume = 1/parentPatchDiffVolume;

        patchVolume = zeros(1, obj.Connectivities.numberOfKnotPatches);
        obj.TopologyInfo.firstMoments = zeros(obj.Connectivities.numberOfKnotPatches, obj.ControlPoints.numberOfCoordinates);
        obj.TopologyInfo.patchCentroids = zeros(obj.Connectivities.numberOfKnotPatches, obj.ControlPoints.numberOfCoordinates);
        obj.TopologyInfo.topologyCentroid = zeros(1, obj.ControlPoints.numberOfCoordinates);
        for patchIndex = 1:obj.Connectivities.numberOfKnotPatches
            jacsTemp = reshape(obj.parametric2PhysicalDetOfJacobians(:, patchIndex), numOfEvalPoints);
            pointsTemp = reshape(obj.pointsInPhysicalCoordinates(:, :, patchIndex), [numOfEvalPoints obj.ControlPoints.numberOfCoordinates]);
            
            for index1 = 1:numOfEvalPoints(1)-1
                for index2 = 1:numOfEvalPoints(2)-1
                    jacVal = mean(mean(jacsTemp(index1:index1+1, index2:index2+1)));
                    pointVal = squeeze(mean(mean(pointsTemp(index1:index1+1, index2:index2+1, :))));
                    
                    diffVolume = parentPatchDiffVolume*obj.parent2ParametricDetOfJacobians(patchIndex)*jacVal;
                    patchVolume(patchIndex) = patchVolume(patchIndex)+ diffVolume;
                    
                    for coordinateIndex = 1:obj.ControlPoints.numberOfCoordinates
                        obj.TopologyInfo.firstMoments(patchIndex, coordinateIndex) = ...
                            obj.TopologyInfo.firstMoments(patchIndex, coordinateIndex)...
                            +pointVal(coordinateIndex)*diffVolume;
                    end
                    
                end
            end
            obj.TopologyInfo.patchCentroids(patchIndex, :) = obj.TopologyInfo.firstMoments(patchIndex, :)/patchVolume(patchIndex);
            
        end
        
        obj.TopologyInfo.topologyCentroid = sum(obj.TopologyInfo.firstMoments, 1)/sum(patchVolume);
        
    case 3
        parentPatchDiffVolume = 1;
        numOfEvalPoints = zeros(1, 3);
        for parametricIndex = 1:3
            parentPatchDiffVolume = parentPatchDiffVolume*(obj.BasisFunctions.MonoParametricBasisFunctions(parametricIndex).numberOfEvaluationPointsPerKnotPatch-1);
            numOfEvalPoints(parametricIndex) = obj.BasisFunctions.MonoParametricBasisFunctions(parametricIndex).numberOfEvaluationPointsPerKnotPatch;
        end
        parentPatchDiffVolume = 1/parentPatchDiffVolume;

        patchVolume = zeros(1, obj.Connectivities.numberOfKnotPatches);
        obj.TopologyInfo.firstMoments = zeros(obj.Connectivities.numberOfKnotPatches, obj.ControlPoints.numberOfCoordinates);
        obj.TopologyInfo.patchCentroids = zeros(obj.Connectivities.numberOfKnotPatches, obj.ControlPoints.numberOfCoordinates);
        obj.TopologyInfo.topologyCentroid = zeros(1, obj.ControlPoints.numberOfCoordinates);
        for patchIndex = 1:obj.Connectivities.numberOfKnotPatches
            jacsTemp = reshape(obj.parametric2PhysicalDetOfJacobians(:, patchIndex), numOfEvalPoints);
            pointsTemp = reshape(obj.pointsInPhysicalCoordinates(:, :, patchIndex), [numOfEvalPoints obj.ControlPoints.numberOfCoordinates]);
            
            for index1 = 1:numOfEvalPoints(1)-1
                for index2 = 1:numOfEvalPoints(2)-1
                    for index3 = 1:numOfEvalPoints(3)-1
                        jacVal = mean(mean(mean(jacsTemp(index1:index1+1, index2:index2+1, index3:index3+1))));
                        pointVal = squeeze(mean(mean(mean(pointsTemp(index1:index1+1, index2:index2+1, index3:index3+1, :)))));
                        
                        diffVolume = parentPatchDiffVolume*obj.parent2ParametricDetOfJacobians(patchIndex)*jacVal;
                        patchVolume(patchIndex) = patchVolume(patchIndex)+ diffVolume;
                        
                        for coordinateIndex = 1:obj.ControlPoints.numberOfCoordinates
                            obj.TopologyInfo.firstMoments(patchIndex, coordinateIndex) = ...
                                obj.TopologyInfo.firstMoments(patchIndex, coordinateIndex)...
                               +pointVal(coordinateIndex)*diffVolume;
                        end
                        
                    end
                end
            end
            obj.TopologyInfo.patchCentroids(patchIndex, :) = obj.TopologyInfo.firstMoments(patchIndex, :)/patchVolume(patchIndex);
            
        end
        
        obj.TopologyInfo.topologyCentroid = sum(obj.TopologyInfo.firstMoments, 1)/sum(patchVolume);
        
end

end