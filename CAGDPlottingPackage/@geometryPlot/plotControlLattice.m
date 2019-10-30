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

function plotControlLattice(obj, varargin)

if ~isempty(obj.controlLatticeHandle)
    return;
end

obj.NurbsObject.ControlPoints.convertTypeOfCoordinates('Cartesian');

switch obj.NurbsObject.GeneralInfo.totalNumberOfParametricCoordinates
    case 1
        plot1Parametric(obj);

    case 2
        plot2Parametric(obj);
    
    case 3
        plot3Parametric(obj);

end

end


%%
function plot1Parametric(obj)

switch obj.NurbsObject.GeneralInfo.numberOfPhysicalCoordinates
    case 3
        obj.controlLatticeHandle = plot3(obj.NurbsObject.ControlPoints.coordinates(:, 1), ...
              obj.NurbsObject.ControlPoints.coordinates(:, 2),  ...
              obj.NurbsObject.ControlPoints.coordinates(:, 3),  ...
              obj.PlotSettings.ControlPoints_PlotSettings.plotSettingsWithMarkers{:});
        
        % for controlPolygonIntex1 = 1:size(obj.ControlPoints.coordinates, 1)
        %     %Forming the label text
        %     label = ['$P_{' num2str(controlPolygonIntex1-1) '}$'];
        %     text(obj.ControlPoints.coordinates(controlPolygonIntex1, 1), ...
        %         obj.ControlPoints.coordinates(controlPolygonIntex1, 2), ...
        %         obj.ControlPoints.coordinates(controlPolygonIntex1, 3), ...
        %         label, obj.PlotProperties.PlotSettings.ControlPoints.Labels.plotSettings{:});
        % end
    case 2
        obj.controlLatticeHandle = plot(obj.NurbsObject.ControlPoints.coordinates(:, 1), ...
             obj.NurbsObject.ControlPoints.coordinates(:, 2),  ...
             obj.PlotSettings.ControlPoints_PlotSettings.plotSettingsWithMarkers{:});
        
    case 1
        obj.controlLatticeHandle = plot(obj.NurbsObject.ControlPoints.coordinates(:, 1), zeros(1, obj.NurbsObject.ControlPoints.numberOfControlPoints),  ...
             obj.PlotSettings.ControlPoints_PlotSettings.plotSettingsWithMarkers{:});
        
end

end


function plot2Parametric(obj)

switch obj.NurbsObject.GeneralInfo.numberOfPhysicalCoordinates
    case 3
        % control polygons in direction u
        for controlPolygonIndex2 = 1:size(obj.NurbsObject.ControlPoints.coordinates, 2)
            obj.controlLatticeHandle(controlPolygonIndex2) = ...
            plot3(obj.NurbsObject.ControlPoints.coordinates(:, controlPolygonIndex2, 1), ...
                  obj.NurbsObject.ControlPoints.coordinates(:, controlPolygonIndex2, 2),  ...
                  obj.NurbsObject.ControlPoints.coordinates(:, controlPolygonIndex2, 3),  ...
                  obj.PlotSettings.ControlPoints_PlotSettings.plotSettingsWithMarkers{:});
        end
        
        % control polygons in direction v
        for controlPolygonIndex1 = 1:size(obj.NurbsObject.ControlPoints.coordinates, 1)
            obj.controlLatticeHandle(controlPolygonIndex1+size(obj.NurbsObject.ControlPoints.coordinates, 2)) = ...
            plot3(obj.NurbsObject.ControlPoints.coordinates(controlPolygonIndex1, :, 1), ...
                  obj.NurbsObject.ControlPoints.coordinates(controlPolygonIndex1, :, 2),  ...
                  obj.NurbsObject.ControlPoints.coordinates(controlPolygonIndex1, :, 3),  ...
                  obj.PlotSettings.ControlPoints_PlotSettings.plotSettingsOnlyLines{:});
        end
        
        % if obj.PlotProperties.PlotSettings.ControlPoints.Labels.visualizationSwitch
        %     for controlPolygonIntex2 = 1:size(obj.ControlPoints.coordinates, 2)
        %         for controlPolygonIntex1 = 1:size(obj.ControlPoints.coordinates, 1)
        %             %Forming the label text
        %             label = ['$P_{' num2str(controlPolygonIntex1-1) ',' num2str(controlPolygonIntex2-1) '}$'];
        %             text(obj.ControlPoints.coordinates(controlPolygonIntex1, controlPolygonIntex2, 1), ...
        %                 obj.ControlPoints.coordinates(controlPolygonIntex1, controlPolygonIntex2, 2), ...
        %                 obj.ControlPoints.coordinates(controlPolygonIntex1, controlPolygonIntex2, 3), ...
        %                 label, obj.PlotProperties.PlotSettings.ControlPoints.Labels.plotSettings{:});
        %         end
        %     end
        % end

    case 2
        % control polygons in direction u
        for controlPolygonIndex2 = 1:size(obj.NurbsObject.ControlPoints.coordinates, 2)
            obj.controlLatticeHandle(controlPolygonIndex2) = ...
            plot(obj.NurbsObject.ControlPoints.coordinates(:, controlPolygonIndex2, 1), ...
                 obj.NurbsObject.ControlPoints.coordinates(:, controlPolygonIndex2, 2), ...
                 obj.PlotSettings.ControlPoints_PlotSettings.plotSettingsWithMarkers{:});
        end
        
        % control polygons in direction v
        for controlPolygonIndex1 = 1:size(obj.NurbsObject.ControlPoints.coordinates, 1)
            obj.controlLatticeHandle(controlPolygonIndex1+size(obj.NurbsObject.ControlPoints.coordinates, 2)) = ...
            plot(obj.NurbsObject.ControlPoints.coordinates(controlPolygonIndex1, :, 1), ...
                 obj.NurbsObject.ControlPoints.coordinates(controlPolygonIndex1, :, 2),  ...
                 obj.PlotSettings.ControlPoints_PlotSettings.plotSettingsOnlyLines{:});
        end
        
        % if obj.PlotProperties.PlotSettings.ControlPoints.Labels.visualizationSwitch
        %     for controlPolygonIntex2 = 1:size(obj.ControlPoints.coordinates, 2)
        %         for controlPolygonIntex1 = 1:size(obj.ControlPoints.coordinates, 1)
        %             %Forming the label text
        %             label = ['$P_{' num2str(controlPolygonIntex1-1) ',' num2str(controlPolygonIntex2-1) '}$'];
        %             text(obj.ControlPoints.coordinates(controlPolygonIntex1, controlPolygonIntex2, 1), ...
        %                  obj.ControlPoints.coordinates(controlPolygonIntex1, controlPolygonIntex2, 2), ...
        %                  label, obj.PlotProperties.PlotSettings.ControlPoints.Labels.plotSettings{:});
        %         end
        %     end
        % end
        
end

end

function plot3Parametric(obj)

% control polygons in direction u
for controlPolygonIndex3 = 1:size(obj.NurbsObject.ControlPoints.coordinates, 3)
    for controlPolygonIndex2 = 1:size(obj.NurbsObject.ControlPoints.coordinates, 2)
        obj.controlLatticeHandle(controlPolygonIndex2+size(obj.NurbsObject.ControlPoints.coordinates, 2)*(controlPolygonIndex3-1)) = ...
        plot3(obj.NurbsObject.ControlPoints.coordinates(:, controlPolygonIndex2, controlPolygonIndex3, 1), ...
              obj.NurbsObject.ControlPoints.coordinates(:, controlPolygonIndex2, controlPolygonIndex3, 2),  ...
              obj.NurbsObject.ControlPoints.coordinates(:, controlPolygonIndex2, controlPolygonIndex3, 3),  ...
              obj.PlotSettings.ControlPoints_PlotSettings.plotSettingsWithMarkers{:});        
    end
end

for controlPolygonIndex3 = 1:size(obj.NurbsObject.ControlPoints.coordinates, 3)
    for controlPolygonIndex1 = 1:size(obj.NurbsObject.ControlPoints.coordinates, 1)
        obj.controlLatticeHandle(controlPolygonIndex1+size(obj.NurbsObject.ControlPoints.coordinates, 1)*(controlPolygonIndex3-1)+size(obj.NurbsObject.ControlPoints.coordinates, 3)*size(obj.NurbsObject.ControlPoints.coordinates, 2)) = ...
        plot3(obj.NurbsObject.ControlPoints.coordinates(controlPolygonIndex1, :, controlPolygonIndex3, 1), ...
              obj.NurbsObject.ControlPoints.coordinates(controlPolygonIndex1, :, controlPolygonIndex3, 2),  ...
              obj.NurbsObject.ControlPoints.coordinates(controlPolygonIndex1, :, controlPolygonIndex3, 3),  ...
              obj.PlotSettings.ControlPoints_PlotSettings.plotSettingsOnlyLines{:});
        
    end
end

for controlPolygonIndex2 = 1:size(obj.NurbsObject.ControlPoints.coordinates, 2)
    for controlPolygonIndex1 = 1:size(obj.NurbsObject.ControlPoints.coordinates, 1)
        obj.controlLatticeHandle(controlPolygonIndex1+size(obj.NurbsObject.ControlPoints.coordinates, 1)*(controlPolygonIndex2-1)+size(obj.NurbsObject.ControlPoints.coordinates, 3)*size(obj.NurbsObject.ControlPoints.coordinates, 2)+size(obj.NurbsObject.ControlPoints.coordinates, 3)*size(obj.NurbsObject.ControlPoints.coordinates, 1)) = ...
        plot3(squeeze(obj.NurbsObject.ControlPoints.coordinates(controlPolygonIndex1, controlPolygonIndex2, :, 1)), ...
              squeeze(obj.NurbsObject.ControlPoints.coordinates(controlPolygonIndex1, controlPolygonIndex2, :, 2)),  ...
              squeeze(obj.NurbsObject.ControlPoints.coordinates(controlPolygonIndex1, controlPolygonIndex2, :, 3)),  ...
              obj.PlotSettings.ControlPoints_PlotSettings.plotSettingsOnlyLines{:});
        
    end
end

% for controlPolygonIndex3 = 1:size(obj.NurbsObject.ControlPoints.coordinates, 3)
%     for controlPolygonIndex2 = 1:size(obj.NurbsObject.ControlPoints.coordinates, 2)
%         for controlPolygonIndex1 = 1:size(obj.NurbsObject.ControlPoints.coordinates, 1)
%             %Forming the label text
%             label = ['$P_{' num2str(controlPolygonIndex1-1) ',' num2str(controlPolygonIndex2-1) ',' num2str(controlPolygonIndex3-1) '}$'];
%             text(obj.NurbsObject.ControlPoints.coordinates(controlPolygonIndex1, controlPolygonIndex2, controlPolygonIndex3, 1), ...
%                  obj.NurbsObject.ControlPoints.coordinates(controlPolygonIndex1, controlPolygonIndex2, controlPolygonIndex3, 2), ...
%                  obj.NurbsObject.ControlPoints.coordinates(controlPolygonIndex1, controlPolygonIndex2, controlPolygonIndex3, 3), ...
%                  label, obj.PlotSettings.ControlPoints_PlotSettings.labelsPlotSettings{:});
%         end
%     end
% end

end