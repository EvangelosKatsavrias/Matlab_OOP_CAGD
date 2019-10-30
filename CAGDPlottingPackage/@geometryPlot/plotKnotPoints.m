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

function plotKnotPoints(obj, varargin)

if ~isempty(obj.knotsHandle)
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

for knotPatchNumber = 1:obj.NurbsObject.ClosureTopologies(closureTopologyIndex).Connectivities.numberOfKnotPatches
    plotPoints = reshape(obj.NurbsObject.ClosureTopologies(closureTopologyIndex).pointsInPhysicalCoordinates(:, :, knotPatchNumber), reshapeSizes);
    
    knotPoints = reshape(plotPoints([1, end], [1, end], [1, end], :), 8, 3);
        obj.knotsHandle(knotPatchNumber) = plot3(knotPoints(:, 1), ...
                                       knotPoints(:, 2), ...
                                       knotPoints(:, 3), ...
                                       obj.PlotSettings.Knots_PlotSettings.markersPlotSettings{:});

end

end


function plot2Parametric(obj, closureTopologyIndex)

reshapeSizes = [obj.PlotSettings.numOfPlottedPatchPoints, obj.NurbsObject.GeneralInfo.numberOfPhysicalCoordinates];

switch obj.NurbsObject.GeneralInfo.numberOfPhysicalCoordinates
    case 3
        for knotPatchNumber = 1:obj.NurbsObject.ClosureTopologies(closureTopologyIndex).Connectivities.numberOfKnotPatches
            plotPoints = reshape(obj.NurbsObject.ClosureTopologies(closureTopologyIndex).pointsInPhysicalCoordinates(:, :, knotPatchNumber), reshapeSizes);
            
            knotPoints = reshape(plotPoints([1, end], [1, end], :), 4, 3);
            obj.knotsHandle(knotPatchNumber) = plot3(knotPoints(:, 1), ...
                                           knotPoints(:, 2), ...
                                           knotPoints(:, 3), ...
                                           obj.PlotSettings.Knots_PlotSettings.markersPlotSettings{:});
        end

    case 2
        for knotPatchNumber = 1:obj.NurbsObject.ClosureTopologies(closureTopologyIndex).Connectivities.numberOfKnotPatches
            plotPoints = reshape(obj.NurbsObject.ClosureTopologies(closureTopologyIndex).pointsInPhysicalCoordinates(:, :, knotPatchNumber), reshapeSizes);
            
            knotPoints = reshape(plotPoints([1, end], [1, end], :), 4, 2);
            obj.knotsHandle(knotPatchNumber) = plot(knotPoints(:, 1), ...
                                          knotPoints(:, 2), ...
                                          obj.PlotSettings.Knots_PlotSettings.markersPlotSettings{:});
        end
        
end

end

function plot1Parametric(obj, closureTopologyIndex)

switch obj.NurbsObject.GeneralInfo.numberOfPhysicalCoordinates
    case 3
        for knotPatchNumber = 1:obj.NurbsObject.ClosureTopologies(closureTopologyIndex).Connectivities.numberOfKnotPatches
            plotPoints = obj.NurbsObject.ClosureTopologies(closureTopologyIndex).pointsInPhysicalCoordinates([1, end], :, knotPatchNumber);
            obj.knotsHandle(knotPatchNumber) = plot3(plotPoints(:, 1), ...
                                           plotPoints(:, 2), ...
                                           plotPoints(:, 3), ...
                                           obj.PlotSettings.Knots_PlotSettings.markersPlotSettings{:});
        end

    case 2
        for knotPatchNumber = 1:obj.NurbsObject.ClosureTopologies(closureTopologyIndex).Connectivities.numberOfKnotPatches
            plotPoints = obj.NurbsObject.ClosureTopologies(closureTopologyIndex).pointsInPhysicalCoordinates([1, end], :, knotPatchNumber);
            obj.knotsHandle(knotPatchNumber) = plot(plotPoints(:, 1), ...
                                          plotPoints(:, 2), ...
                                          obj.PlotSettings.Knots_PlotSettings.markersPlotSettings{:});
        end
    case 1
        for knotPatchNumber = 1:obj.NurbsObject.ClosureTopologies(closureTopologyIndex).Connectivities.numberOfKnotPatches
            plotPoints = obj.NurbsObject.ClosureTopologies(closureTopologyIndex).pointsInPhysicalCoordinates([1 end], :, knotPatchNumber);
            obj.knotsHandle(knotPatchNumber) = plot(plotPoints(:), [0 0], ...
                                          obj.PlotSettings.Knots_PlotSettings.markersPlotSettings{:});
        end
        
end

% if obj.PlotProperties.PlotSettings.Knots.Labels.visualizationSwitch
%     for index1 = 1:obj.KnotVectors(1).numberOfKnotPatches+1
%         label = ['$U_{' num2str(index1-1) '}$'];
%         text(obj.PlotProperties.PlotData(stackedData).Closure.knotPoints(1, index1), ...
%              obj.PlotProperties.PlotData(stackedData).Closure.knotPoints(2, index1), ...
%              obj.PlotProperties.PlotData(stackedData).Closure.knotPoints(3, index1), ...
%              label, obj.PlotProperties.PlotSettings.Knots.Labels.plotSettings{:});
%     end
% end

end


% if obj.PlotProperties.PlotSettings.Knots.Labels.visualizationSwitch
%     for index3 = 1:obj.KnotVectors(3).numberOfKnotPatches-1
%         for index2 = 1:obj.KnotVectors(2).numberOfKnotPatches-1
%             positionShift2 = (index2-1)*(obj.KnotVectors(1).numberOfKnotPatches+1);
%             for index1 = 1:obj.KnotVectors(1).numberOfKnotPatches+1
%                 positionShift3 = (index3-1)*(obj.KnotVectors(2).numberOfKnotPatches+1)*(obj.KnotVectors(1).numberOfKnotPatches+1);
%                 label = ['$U_{' num2str(index1-1) ...
%                     ',' num2str(index2-1) ...
%                     ',' num2str(index3-1) '}$'];
%                 text(obj.PlotProperties.PlotData(stackedData).Closure.knotPoints(1, positionShift3 +positionShift2 +index1), ...
%                     obj.PlotProperties.PlotData(stackedData).Closure.knotPoints(2, positionShift3 +positionShift2 +index1), ...
%                     obj.PlotProperties.PlotData(stackedData).Closure.knotPoints(3, positionShift3 +positionShift2 +index1), ...
%                     label, obj.PlotProperties.PlotSettings.Knots.Labels.plotSettings{:});
%             end
%         end
%     end
%     
%     positionShift2 = index2*(obj.KnotVectors(1).numberOfKnotPatches+1);
%     for index3 = 1:obj.KnotVectors(3).numberOfKnotPatches-1
%         positionShift3 = (index3-1)*(obj.KnotVectors(2).numberOfKnotPatches+1)*(obj.KnotVectors(1).numberOfKnotPatches+1);
%         for index1 = 1:obj.KnotVectors(1).numberOfKnotPatches-1
%             label = ['$U_{' num2str(index1-1) ...
%                 ',' num2str(obj.KnotVectors(2).numberOfKnotPatches-1) ...
%                 ',' num2str(index3-1) '}$'];
%             text(obj.PlotProperties.PlotData(stackedData).Closure.knotPoints(1, positionShift3 +positionShift2 +(index1-1)*2 +1), ...
%                 obj.PlotProperties.PlotData(stackedData).Closure.knotPoints(2, positionShift3 +positionShift2 +(index1-1)*2 +1), ...
%                 obj.PlotProperties.PlotData(stackedData).Closure.knotPoints(3, positionShift3 +positionShift2 +(index1-1)*2 +1), ...
%                 label, obj.PlotProperties.PlotSettings.Knots.Labels.plotSettings{:});
%             
%             label = ['$U_{' num2str(index1-1) ...
%                 ',' num2str(obj.KnotVectors(2).numberOfKnotPatches) ...
%                 ',' num2str(index3-1) '}$'];
%             text(obj.PlotProperties.PlotData(stackedData).Closure.knotPoints(1, positionShift3 +positionShift2 +(index1-1)*2 +2), ...
%                 obj.PlotProperties.PlotData(stackedData).Closure.knotPoints(2, positionShift3 +positionShift2 +(index1-1)*2 +2), ...
%                 obj.PlotProperties.PlotData(stackedData).Closure.knotPoints(3, positionShift3 +positionShift2 +(index1-1)*2 +2), ...
%                 label, obj.PlotProperties.PlotSettings.Knots.Labels.plotSettings{:});
%         end
%         
%         index1 = obj.KnotVectors(1).numberOfKnotPatches;
%         label = ['$U_{' num2str(index1-1) ...
%             ',' num2str(obj.KnotVectors(2).numberOfKnotPatches-1) ...
%             ',' num2str(index3-1) '}$'];
%         text(obj.PlotProperties.PlotData(stackedData).Closure.knotPoints(1, positionShift3 +positionShift2 +(index1-1)*2 +1), ...
%             obj.PlotProperties.PlotData(stackedData).Closure.knotPoints(2, positionShift3 +positionShift2 +(index1-1)*2 +1), ...
%             obj.PlotProperties.PlotData(stackedData).Closure.knotPoints(3, positionShift3 +positionShift2 +(index1-1)*2 +1), ...
%             label, obj.PlotProperties.PlotSettings.Knots.Labels.plotSettings{:});
%         
%         label = ['$U_{' num2str(index1) ...
%             ',' num2str(obj.KnotVectors(2).numberOfKnotPatches-1) ...
%             ',' num2str(index3-1) '}$'];
%         text(obj.PlotProperties.PlotData(stackedData).Closure.knotPoints(1, positionShift3 +positionShift2 +(index1-1)*2 +2), ...
%             obj.PlotProperties.PlotData(stackedData).Closure.knotPoints(2, positionShift3 +positionShift2 +(index1-1)*2 +2), ...
%             obj.PlotProperties.PlotData(stackedData).Closure.knotPoints(3, positionShift3 +positionShift2 +(index1-1)*2 +2), ...
%             label, obj.PlotProperties.PlotSettings.Knots.Labels.plotSettings{:});
%         
%         label = ['$U_{' num2str(index1-1) ...
%             ',' num2str(obj.KnotVectors(2).numberOfKnotPatches) ...
%             ',' num2str(index3-1) '}$'];
%         text(obj.PlotProperties.PlotData(stackedData).Closure.knotPoints(1, positionShift3 +positionShift2 +(index1-1)*2 +3), ...
%             obj.PlotProperties.PlotData(stackedData).Closure.knotPoints(2, positionShift3 +positionShift2 +(index1-1)*2 +3), ...
%             obj.PlotProperties.PlotData(stackedData).Closure.knotPoints(3, positionShift3 +positionShift2 +(index1-1)*2 +3), ...
%             label, obj.PlotProperties.PlotSettings.Knots.Labels.plotSettings{:});
%         
%         label = ['$U_{' num2str(index1) ...
%             ',' num2str(obj.KnotVectors(2).numberOfKnotPatches) ...
%             ',' num2str(index3-1) '}$'];
%         text(obj.PlotProperties.PlotData(stackedData).Closure.knotPoints(1, positionShift3 +positionShift2 +(index1-1)*2 +4), ...
%             obj.PlotProperties.PlotData(stackedData).Closure.knotPoints(2, positionShift3 +positionShift2 +(index1-1)*2 +4), ...
%             obj.PlotProperties.PlotData(stackedData).Closure.knotPoints(3, positionShift3 +positionShift2 +(index1-1)*2 +4), ...
%             label, obj.PlotProperties.PlotSettings.Knots.Labels.plotSettings{:});
%         
%     end
%     
%     positionShift = (obj.KnotVectors(3).numberOfKnotPatches-1)*(obj.KnotVectors(2).numberOfKnotPatches+1)*(obj.KnotVectors(1).numberOfKnotPatches+1);
%     for index2 = 1:obj.KnotVectors(2).numberOfKnotPatches-1
%         positionShift2 = (index2-1)*(obj.KnotVectors(1).numberOfKnotPatches+1)*2;
%         for index1 = 1:obj.KnotVectors(1).numberOfKnotPatches-1
%             for index3 = 0:1
%                 label = ['$U_{' num2str(index1-1) ...
%                     ',' num2str(index2-1) ...
%                     ',' num2str(obj.KnotVectors(3).numberOfKnotPatches-1+index3) '}$'];
%                 text(obj.PlotProperties.PlotData(stackedData).Closure.knotPoints(1, positionShift +positionShift2 +index1*2 +index3 -1), ...
%                     obj.PlotProperties.PlotData(stackedData).Closure.knotPoints(2, positionShift +positionShift2 +index1*2 +index3 -1), ...
%                     obj.PlotProperties.PlotData(stackedData).Closure.knotPoints(3, positionShift +positionShift2 +index1*2 +index3 -1), ...
%                     label, obj.PlotProperties.PlotSettings.Knots.Labels.plotSettings{:});
%             end
%         end
%         for index3 = 0:1
%             for index1 = 0:1
%                 positionShift1 = (obj.KnotVectors(1).numberOfKnotPatches -1)*2;
%                 label = ['$U_{' num2str(obj.KnotVectors(1).numberOfKnotPatches -1 +index1) ...
%                     ',' num2str(index2-1) ...
%                     ',' num2str(obj.KnotVectors(3).numberOfKnotPatches-1+index3) '}$'];
%                 text(obj.PlotProperties.PlotData(stackedData).Closure.knotPoints(1, positionShift +positionShift2 +positionShift1 +index1 +index3*2 +1), ...
%                     obj.PlotProperties.PlotData(stackedData).Closure.knotPoints(2, positionShift +positionShift2 +positionShift1 +index1 +index3*2 +1), ...
%                     obj.PlotProperties.PlotData(stackedData).Closure.knotPoints(3, positionShift +positionShift2 +positionShift1 +index1 +index3*2 +1), ...
%                     label, obj.PlotProperties.PlotSettings.Knots.Labels.plotSettings{:});
%             end
%         end
%     end
%     
%     for index2 = obj.KnotVectors(2).numberOfKnotPatches
%         positionShift2 = (index2-1)*(obj.KnotVectors(1).numberOfKnotPatches+1)*2;
%         for index1 = 1:obj.KnotVectors(1).numberOfKnotPatches-1
%             for index3 = 0:1
%                 label = ['$U_{' num2str(index1-1) ...
%                     ',' num2str(index2-1) ...
%                     ',' num2str(obj.KnotVectors(3).numberOfKnotPatches-1+index3) '}$'];
%                 text(obj.PlotProperties.PlotData(stackedData).Closure.knotPoints(1, positionShift +positionShift2 +index1*4 +index3*2 -3), ...
%                     obj.PlotProperties.PlotData(stackedData).Closure.knotPoints(2, positionShift +positionShift2 +index1*4 +index3*2 -3), ...
%                     obj.PlotProperties.PlotData(stackedData).Closure.knotPoints(3, positionShift +positionShift2 +index1*4 +index3*2 -3), ...
%                     label, obj.PlotProperties.PlotSettings.Knots.Labels.plotSettings{:});
%                 label = ['$U_{' num2str(index1-1) ...
%                     ',' num2str(index2) ...
%                     ',' num2str(obj.KnotVectors(3).numberOfKnotPatches-1+index3) '}$'];
%                 text(obj.PlotProperties.PlotData(stackedData).Closure.knotPoints(1, positionShift +positionShift2 +index1*4 +index3*2 -2), ...
%                     obj.PlotProperties.PlotData(stackedData).Closure.knotPoints(2, positionShift +positionShift2 +index1*4 +index3*2 -2), ...
%                     obj.PlotProperties.PlotData(stackedData).Closure.knotPoints(3, positionShift +positionShift2 +index1*4 +index3*2 -2), ...
%                     label, obj.PlotProperties.PlotSettings.Knots.Labels.plotSettings{:});
%             end
%         end
%     end
%     
%     positionShift = (obj.KnotVectors(3).numberOfKnotPatches+1)*(obj.KnotVectors(2).numberOfKnotPatches+1)*(obj.KnotVectors(1).numberOfKnotPatches+1)-8;
%     for index3 = 1:2
%         positionShift3 = (index3-1)*4;
%         for index2 = 1:2
%             positionShift2 = (index2-1)*2;
%             for index1 = 1:2
%                 label = ['$U_{' num2str(obj.KnotVectors(1).numberOfKnotPatches-2+index1) ...
%                     ',' num2str(obj.KnotVectors(2).numberOfKnotPatches-2+index2) ...
%                     ',' num2str(obj.KnotVectors(3).numberOfKnotPatches-2+index3) '}$'];
%                 text(obj.PlotProperties.PlotData(stackedData).Closure.knotPoints(1, positionShift +positionShift3 +positionShift2 +index1), ...
%                     obj.PlotProperties.PlotData(stackedData).Closure.knotPoints(2, positionShift +positionShift3 +positionShift2 +index1), ...
%                     obj.PlotProperties.PlotData(stackedData).Closure.knotPoints(3, positionShift +positionShift3 +positionShift2 +index1), ...
%                     label, obj.PlotProperties.PlotSettings.Knots.Labels.plotSettings{:});
%             end
%         end
%     end
% end