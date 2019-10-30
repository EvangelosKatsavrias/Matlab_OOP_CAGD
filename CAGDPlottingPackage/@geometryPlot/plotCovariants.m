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

function plotCovariants(obj, varargin)

if ~isempty(obj.covariantsHandles)
    return;
end

closureTopologyIndex = obj.PlotData.closureTopologyIndex;

switch obj.NurbsObject.GeneralInfo.totalNumberOfParametricCoordinates
    case 1
        plot1Parametric(obj, closureTopologyIndex);

    case 2
        plot2Parametric(obj, closureTopologyIndex);
    
    case 3
        plot3Parametric(obj, closureTopologyIndex);

end

end

function plot3Parametric(obj, closureTopologyIndex)

reshapeSizes = [obj.PlotSettings.numOfPlottedPatchPoints, obj.NurbsObject.GeneralInfo.numberOfPhysicalCoordinates];
permuteOrder = [circshift(1:obj.NurbsObject.GeneralInfo.totalNumberOfParametricCoordinates, [0, -1]), 1+obj.NurbsObject.GeneralInfo.totalNumberOfParametricCoordinates];
numOfPoints = obj.PlotSettings.numOfPlottedPatchPoints;

for knotPatchNumber = 1:obj.NurbsObject.Connectivities.numberOfKnotPatches
    
    plotPoints = reshape(obj.NurbsObject.ClosureTopologies(closureTopologyIndex).pointsInPhysicalCoordinates(:, :, knotPatchNumber), reshapeSizes);
    jacs = reshape(shiftdim(obj.NurbsObject.ClosureTopologies(closureTopologyIndex).parametric2PhysicalJacobians(:, :, :, knotPatchNumber), 2), [obj.PlotSettings.numOfPlottedPatchPoints, obj.NurbsObject.GeneralInfo.totalNumberOfParametricCoordinates, 3]);
    
    for surfaceIndex = 1:3
        for parametricIndex = 1:obj.NurbsObject.GeneralInfo.totalNumberOfParametricCoordinates
            obj.covariantsHandles(knotPatchNumber, surfaceIndex, parametricIndex) = ...
            quiver3(plotPoints(:, :, [1 end], 1), ...
                    plotPoints(:, :, [1 end], 2), ...
                    plotPoints(:, :, [1 end], 3), ...
                    jacs(:, :, [1 end], parametricIndex, 1), ...
                    jacs(:, :, [1 end], parametricIndex, 2), ...
                    jacs(:, :, [1 end], parametricIndex, 3), ...
                    obj.PlotSettings.Covariants_PlotSettings.plotSettings{parametricIndex}{:});
        end
        
        plotPoints = permute(plotPoints, permuteOrder);
        numOfPoints = circshift(numOfPoints, [0, -1]);
    end
end

end

function plot2Parametric(obj, closureTopologyIndex)

switch obj.NurbsObject.GeneralInfo.numberOfPhysicalCoordinates
    case 3
        for knotPatchNumber = 1:obj.NurbsObject.Connectivities.numberOfKnotPatches
            for parametricIndex = 1:obj.NurbsObject.GeneralInfo.totalNumberOfParametricCoordinates+1
                obj.covariantsHandles(knotPatchNumber, parametricIndex) = ...
                quiver3(obj.NurbsObject.ClosureTopologies(closureTopologyIndex).pointsInPhysicalCoordinates(:, 1, knotPatchNumber), ...
                        obj.NurbsObject.ClosureTopologies(closureTopologyIndex).pointsInPhysicalCoordinates(:, 2, knotPatchNumber), ...
                        obj.NurbsObject.ClosureTopologies(closureTopologyIndex).pointsInPhysicalCoordinates(:, 3, knotPatchNumber), ...
                        squeeze(obj.NurbsObject.ClosureTopologies(closureTopologyIndex).parametric2PhysicalJacobians(parametricIndex, 1, :, knotPatchNumber)), ...
                        squeeze(obj.NurbsObject.ClosureTopologies(closureTopologyIndex).parametric2PhysicalJacobians(parametricIndex, 2, :, knotPatchNumber)), ...
                        squeeze(obj.NurbsObject.ClosureTopologies(closureTopologyIndex).parametric2PhysicalJacobians(parametricIndex, 3, :, knotPatchNumber)), ...
                        obj.PlotSettings.Covariants_PlotSettings.plotSettings{parametricIndex}{:});
            end
        end

    case 2
        for knotPatchNumber = 1:obj.NurbsObject.Connectivities.numberOfKnotPatches
            for parametricIndex = 1:obj.NurbsObject.GeneralInfo.totalNumberOfParametricCoordinates
                obj.covariantsHandles(knotPatchNumber, parametricIndex) = ...
                quiver(obj.NurbsObject.ClosureTopologies(closureTopologyIndex).pointsInPhysicalCoordinates(:, 1, knotPatchNumber), ...
                       obj.NurbsObject.ClosureTopologies(closureTopologyIndex).pointsInPhysicalCoordinates(:, 2, knotPatchNumber), ...
                       squeeze(obj.NurbsObject.ClosureTopologies(closureTopologyIndex).parametric2PhysicalJacobians(parametricIndex, 1, :, knotPatchNumber)), ...
                       squeeze(obj.NurbsObject.ClosureTopologies(closureTopologyIndex).parametric2PhysicalJacobians(parametricIndex, 2, :, knotPatchNumber)), ...
                       obj.PlotSettings.Covariants_PlotSettings.plotSettings{parametricIndex}{:});
            end
        end

end

end

function plot1Parametric(obj, closureTopologyIndex)

switch obj.NurbsObject.GeneralInfo.numberOfPhysicalCoordinates
    case 3
        for knotPatchNumber = 1:obj.NurbsObject.Connectivities.numberOfKnotPatches
            obj.covariantsHandles(knotPatchNumber) = ...
            quiver3(obj.NurbsObject.ClosureTopologies(closureTopologyIndex).pointsInPhysicalCoordinates(:, 1, knotPatchNumber), ...
                    obj.NurbsObject.ClosureTopologies(closureTopologyIndex).pointsInPhysicalCoordinates(:, 2, knotPatchNumber), ...
                    obj.NurbsObject.ClosureTopologies(closureTopologyIndex).pointsInPhysicalCoordinates(:, 3, knotPatchNumber), ...
                    squeeze(obj.NurbsObject.ClosureTopologies(closureTopologyIndex).parametric2PhysicalJacobians(1, 1, :, knotPatchNumber)), ...
                    squeeze(obj.NurbsObject.ClosureTopologies(closureTopologyIndex).parametric2PhysicalJacobians(1, 2, :, knotPatchNumber)), ...
                    squeeze(obj.NurbsObject.ClosureTopologies(closureTopologyIndex).parametric2PhysicalJacobians(1, 3, :, knotPatchNumber)), ...
                    obj.PlotSettings.Covariants_PlotSettings.plotSettings{1}{:});
        end

    case 2
        for knotPatchNumber = 1:obj.NurbsObject.Connectivities.numberOfKnotPatches
            obj.covariantsHandles(knotPatchNumber) = ...
            quiver(obj.NurbsObject.ClosureTopologies(closureTopologyIndex).pointsInPhysicalCoordinates(:, 1, knotPatchNumber), ...
                   obj.NurbsObject.ClosureTopologies(closureTopologyIndex).pointsInPhysicalCoordinates(:, 2, knotPatchNumber), ...
                   squeeze(obj.NurbsObject.ClosureTopologies(closureTopologyIndex).parametric2PhysicalJacobians(1, 1, :, knotPatchNumber)), ...
                   squeeze(obj.NurbsObject.ClosureTopologies(closureTopologyIndex).parametric2PhysicalJacobians(1, 2, :, knotPatchNumber)), ...
                   obj.PlotSettings.Covariants_PlotSettings.plotSettings{1}{:});
        end
        
    otherwise

end

end