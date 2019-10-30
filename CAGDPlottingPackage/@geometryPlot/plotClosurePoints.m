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

function plotClosurePoints(obj, varargin)

if ~isempty(obj.geometryPlotHandle)
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


%%
function plot3Parametric(obj, closureTopologyIndex)

reshapeSizes = [obj.PlotSettings.numOfPlottedPatchPoints, obj.NurbsObject.GeneralInfo.numberOfPhysicalCoordinates];
permuteOrder = [circshift(1:obj.NurbsObject.GeneralInfo.totalNumberOfParametricCoordinates, [0, -1]), 1+obj.NurbsObject.GeneralInfo.totalNumberOfParametricCoordinates];
numOfFacesPerPatch = nchoosek(obj.NurbsObject.GeneralInfo.totalNumberOfParametricCoordinates, 2);
numOfPoints = obj.PlotSettings.numOfPlottedPatchPoints;

if isempty(obj.geometryPlotHandle)
    obj.geometryPlotHandle = zeros(2, numOfFacesPerPatch, obj.NurbsObject.ClosureTopologies(closureTopologyIndex).Connectivities.numberOfKnotPatches);
end

for knotPatchNumber = 1:obj.NurbsObject.ClosureTopologies(closureTopologyIndex).Connectivities.numberOfKnotPatches
    plotPoints = reshape(obj.NurbsObject.ClosureTopologies(closureTopologyIndex).pointsInPhysicalCoordinates(:, :, knotPatchNumber), reshapeSizes);
    
    for facesIndex = 1:numOfFacesPerPatch
        
%             onesMat = ones(numOfPoints(1:2));
%             C1 = cat(3, obj.PlotSettings.Faces_PlotSettings(facesIndex).faceColor(1)* onesMat, ...
%                 obj.PlotSettings.Faces_PlotSettings(facesIndex).faceColor(2)* onesMat, ...
%                 obj.PlotSettings.Faces_PlotSettings(facesIndex).faceColor(3)* onesMat);
            
            posIndex = 1;
            for surfaceIndex = [1 obj.PlotSettings.numOfPlottedPatchPoints(facesIndex)]
                obj.geometryPlotHandle(posIndex, facesIndex, knotPatchNumber) ...
                    = surf(plotPoints(:, :, surfaceIndex, 1), ...
                    plotPoints(:, :, surfaceIndex, 2), ...
                    plotPoints(:, :, surfaceIndex, 3), ...
                    'FaceColor', obj.PlotSettings.Faces_PlotSettings(facesIndex).faceColor, ...
                    obj.PlotSettings.Faces_PlotSettings(facesIndex).plotSettings{:});
                posIndex = posIndex+1;
            end
            
%             posIndex = 1;
%             for surfaceIndex = [1 obj.PlotSettings.numOfPlottedPatchPoints(facesIndex)]
%                 set(obj.geometryPlotHandle(posIndex, facesIndex, knotPatchNumber), 'XData', plotPoints(:, :, surfaceIndex, 1));
%                 set(obj.geometryPlotHandle(posIndex, facesIndex, knotPatchNumber), 'YData', plotPoints(:, :, surfaceIndex, 2));
%                 set(obj.geometryPlotHandle(posIndex, facesIndex, knotPatchNumber), 'ZData', plotPoints(:, :, surfaceIndex, 3));
%                 posIndex = posIndex+1;
%             end
            
        
        plotPoints = permute(plotPoints, permuteOrder);
        numOfPoints = circshift(numOfPoints, [0, -1]);
        
    end
    
end

drawnow

end

function plot2Parametric(obj, closureTopologyIndex)

reshapeSizes = [obj.PlotSettings.numOfPlottedPatchPoints, obj.NurbsObject.GeneralInfo.numberOfPhysicalCoordinates];
numOfPoints = obj.PlotSettings.numOfPlottedPatchPoints;

onesMat = ones(numOfPoints(1:2));
C1 = cat(3, obj.PlotSettings.Faces_PlotSettings.faceColor(1)* onesMat, ...
            obj.PlotSettings.Faces_PlotSettings.faceColor(2)* onesMat, ...
            obj.PlotSettings.Faces_PlotSettings.faceColor(3)* onesMat);

switch obj.NurbsObject.GeneralInfo.numberOfPhysicalCoordinates
    case 2
        surfHeight = zeros(numOfPoints(1:2));
        for knotPatchNumber = 1:obj.NurbsObject.ClosureTopologies(closureTopologyIndex).Connectivities.numberOfKnotPatches
            plotPoints = reshape(obj.NurbsObject.ClosureTopologies(closureTopologyIndex).pointsInPhysicalCoordinates(:, :, knotPatchNumber), reshapeSizes);
            obj.geometryPlotHandle(knotPatchNumber) = ...
                surf(plotPoints(:, :, 1), ...
                     plotPoints(:, :, 2), surfHeight, ...
                     C1, obj.PlotSettings.Faces_PlotSettings.plotSettings{:});
        end

    case 3
        for knotPatchNumber = 1:obj.NurbsObject.ClosureTopologies(closureTopologyIndex).Connectivities.numberOfKnotPatches
            plotPoints = reshape(obj.NurbsObject.ClosureTopologies(closureTopologyIndex).pointsInPhysicalCoordinates(:, :, knotPatchNumber), reshapeSizes);
            obj.geometryPlotHandle(knotPatchNumber) = ...
                surf(plotPoints(:, :, 1), ...
                     plotPoints(:, :, 2), ...
                     plotPoints(:, :, 3), ...
                     C1, obj.PlotSettings.Faces_PlotSettings.plotSettings{:});
        end
end

end

function plot1Parametric(obj, closureTopologyIndex)

reshapeSizes = [obj.PlotSettings.numOfPlottedPatchPoints, obj.NurbsObject.GeneralInfo.numberOfPhysicalCoordinates];

switch obj.NurbsObject.GeneralInfo.numberOfPhysicalCoordinates
    case 1
        for knotPatchNumber = 1:obj.NurbsObject.ClosureTopologies(closureTopologyIndex).Connectivities.numberOfKnotPatches
            plotPoints = reshape(obj.NurbsObject.ClosureTopologies(closureTopologyIndex).pointsInPhysicalCoordinates(:, :, knotPatchNumber), reshapeSizes);
            obj.geometryPlotHandle(knotPatchNumber) = ...
                plot(plotPoints(:), zeros(1, obj.PlotSettings.numOfPlottedPatchPoints));
        end
        
    case 2
        for knotPatchNumber = 1:obj.NurbsObject.ClosureTopologies(closureTopologyIndex).Connectivities.numberOfKnotPatches
            plotPoints = reshape(obj.NurbsObject.ClosureTopologies(closureTopologyIndex).pointsInPhysicalCoordinates(:, :, knotPatchNumber), reshapeSizes);
            obj.geometryPlotHandle(knotPatchNumber) = ...
                plot(plotPoints(:, 1), plotPoints(:, 2));
        end

    case 3
        for knotPatchNumber = 1:obj.NurbsObject.ClosureTopologies(closureTopologyIndex).Connectivities.numberOfKnotPatches
            plotPoints = reshape(obj.NurbsObject.ClosureTopologies(closureTopologyIndex).pointsInPhysicalCoordinates(:, :, knotPatchNumber), reshapeSizes);
            obj.geometryPlotHandle(knotPatchNumber) = ...
                plot3(plotPoints(:, 1), plotPoints(:, 2), plotPoints(:, 3));
        end
end

end