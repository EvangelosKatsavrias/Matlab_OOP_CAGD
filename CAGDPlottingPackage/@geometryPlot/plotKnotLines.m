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

function plotKnotLines(obj, varargin)

if ~isempty(obj.knotLinesHandles)
    return;
end

closureTopologyIndex = obj.PlotData.closureTopologyIndex;

switch obj.NurbsObject.GeneralInfo.totalNumberOfParametricCoordinates
    case 2
        plot2Parametric(obj, closureTopologyIndex);
    
    case 3
        plot3Parametric(obj, closureTopologyIndex);

    otherwise

end

end

function plot3Parametric(obj, closureTopologyIndex)

reshapeSizes = [obj.PlotSettings.numOfPlottedPatchPoints, obj.NurbsObject.GeneralInfo.numberOfPhysicalCoordinates];
permuteOrder = [circshift(1:obj.NurbsObject.GeneralInfo.totalNumberOfParametricCoordinates, [0, -1]), 1+obj.NurbsObject.GeneralInfo.totalNumberOfParametricCoordinates];
numOfPoints = obj.PlotSettings.numOfPlottedPatchPoints;

for knotPatchNumber = 1:obj.NurbsObject.ClosureTopologies(closureTopologyIndex).Connectivities.numberOfKnotPatches
    plotPoints = reshape(obj.NurbsObject.ClosureTopologies(closureTopologyIndex).pointsInPhysicalCoordinates(:, :, knotPatchNumber), reshapeSizes);
    
    for parametricCoordinateIndex = 1:obj.NurbsObject.GeneralInfo.totalNumberOfParametricCoordinates
        knotLines = reshape(plotPoints(:, [1, end], [1, end], :), obj.PlotSettings.numOfPlottedPatchPoints(parametricCoordinateIndex), 4, 3);
        for knotLineIndex = 1:4
            obj.knotLinesHandles(knotPatchNumber, parametricCoordinateIndex, knotLineIndex) = ...
                 plot3(knotLines(:, knotLineIndex, 1), ...
                       knotLines(:, knotLineIndex, 2), ...
                       knotLines(:, knotLineIndex, 3), ...
                       obj.PlotSettings.Knots_PlotSettings.linesPlotSettings{parametricCoordinateIndex}{:});
        end
        
        plotPoints = permute(plotPoints, permuteOrder);
        numOfPoints = circshift(numOfPoints, [0, -1]);
        
    end
    
end

end

function plot2Parametric(obj, closureTopologyIndex)

switch obj.NurbsObject.GeneralInfo.numberOfPhysicalCoordinates
    case 2
        reshapeSizes = [obj.PlotSettings.numOfPlottedPatchPoints, obj.NurbsObject.GeneralInfo.numberOfPhysicalCoordinates];
        permuteOrder = [circshift(1:obj.NurbsObject.GeneralInfo.totalNumberOfParametricCoordinates, [0, -1]), 1+obj.NurbsObject.GeneralInfo.totalNumberOfParametricCoordinates];
        numOfPoints = obj.PlotSettings.numOfPlottedPatchPoints;
        
        for knotPatchNumber = 1:obj.NurbsObject.ClosureTopologies(closureTopologyIndex).Connectivities.numberOfKnotPatches
            plotPoints = reshape(obj.NurbsObject.ClosureTopologies(closureTopologyIndex).pointsInPhysicalCoordinates(:, :, knotPatchNumber), reshapeSizes);
            
            for parametricCoordinateIndex = 1:obj.NurbsObject.GeneralInfo.totalNumberOfParametricCoordinates
                knotLines = reshape(plotPoints(:, [1, end], :), obj.PlotSettings.numOfPlottedPatchPoints(parametricCoordinateIndex), 2, 2);
                for knotLineIndex = 1:2
                    obj.knotLinesHandles(knotPatchNumber, parametricCoordinateIndex, knotLineIndex) = ...
                        plot(knotLines(:, knotLineIndex, 1), ...
                             knotLines(:, knotLineIndex, 2), ...
                             obj.PlotSettings.Knots_PlotSettings.linesPlotSettings{parametricCoordinateIndex}{:});
                end
                
                plotPoints = permute(plotPoints, permuteOrder);
                numOfPoints = circshift(numOfPoints, [0, -1]);
                
            end
            
        end
    case 3
        reshapeSizes = [obj.PlotSettings.numOfPlottedPatchPoints, obj.NurbsObject.GeneralInfo.numberOfPhysicalCoordinates];
        permuteOrder = [circshift(1:obj.NurbsObject.GeneralInfo.totalNumberOfParametricCoordinates, [0, -1]), 1+obj.NurbsObject.GeneralInfo.totalNumberOfParametricCoordinates];
        numOfPoints = obj.PlotSettings.numOfPlottedPatchPoints;
        
        for knotPatchNumber = 1:obj.NurbsObject.ClosureTopologies(closureTopologyIndex).Connectivities.numberOfKnotPatches
            plotPoints = reshape(obj.NurbsObject.ClosureTopologies(closureTopologyIndex).pointsInPhysicalCoordinates(:, :, knotPatchNumber), reshapeSizes);
            
            for parametricCoordinateIndex = 1:obj.NurbsObject.GeneralInfo.totalNumberOfParametricCoordinates
                knotLines = reshape(plotPoints(:, [1, end], :), obj.PlotSettings.numOfPlottedPatchPoints(parametricCoordinateIndex), 2, 3);
                for knotLineIndex = 1:2
                    obj.knotLinesHandles(knotPatchNumber, parametricCoordinateIndex, knotLineIndex) = ...
                        plot3(knotLines(:, knotLineIndex, 1), ...
                              knotLines(:, knotLineIndex, 2), ...
                              knotLines(:, knotLineIndex, 3), ...
                              obj.PlotSettings.Knots_PlotSettings.linesPlotSettings{parametricCoordinateIndex}{:});
                end
                
                plotPoints = permute(plotPoints, permuteOrder);
                numOfPoints = circshift(numOfPoints, [0, -1]);
                
            end
            
        end

end

end