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

function handlingEvents(obj, eventData)

switch eventData.EventName
    case 'notifyFaceAlphaChanged'
        changeSettingsMethod(obj, eventData, 'faceAlpha');
        
    case 'notifyFaceColorChanged'
        changeSettingsMethod(obj, eventData, 'faceColor');
        
    case 'notifyFaceEffectsChanged'
        changeSettingsMethod(obj, eventData, 'faceAlpha');
        
    case 'notifyFaceEdgesAlphaChanged'
        changeSettingsMethod(obj, eventData, 'edgeAlpha');
        
    case 'notifyFaceEdgesColorChanged'
        changeSettingsMethod(obj, eventData, 'edgeColor');
        
    case 'notifyFaceEdgesEffectsChanged'
        changeSettingsMethod(obj, eventData, 'faceAlpha');
        
    case 'notifyCAGDTopologyChanged'
        if ~isempty(obj.geometryPlotHandle); for index = 1:size(obj.geometryPlotHandle, 3); delete(squeeze(obj.geometryPlotHandle(:, :, index))); end; end
        if ~isempty(obj.controlLatticeHandle); delete(obj.controlLatticeHandle); end
        if ~isempty(obj.covariantsHandles); delete(squeeze(obj.covariantsHandles)); end
        if ~isempty(obj.knotLinesHandles); for index = 1:size(obj.knotLinesHandles, 3); delete(squeeze(obj.knotLinesHandles(:, :, index))); end; end
        if ~isempty(obj.knotsHandle); delete(obj.knotsHandle); end
        
        if ~isempty(obj.geometryPlotHandle)
            obj.geometryPlotHandle = [];
            obj.plotClosurePoints;
        end
        if ~isempty(obj.controlLatticeHandle)
            obj.controlLatticeHandle = [];
            obj.plotControlLattice;
        end
        if ~isempty(obj.covariantsHandles)
            obj.covariantsHandles = [];
            obj.plotCovariants;
        end
        if ~isempty(obj.knotLinesHandles)
            obj.knotLinesHandles = [];
            obj.plotKnotLines;
        end
        if ~isempty(obj.knotsHandle)
            obj.knotsHandle = [];
            obj.plotKnotPoints;
        end
end

drawnow

end


function changeSettingsMethod(obj, eventData, settingStringName)

numOfFacesPerPatch = nchoosek(obj.NurbsObject.GeneralInfo.totalNumberOfParametricCoordinates, 2);
faceNum = size(obj.geometryPlotHandle, 1);
for facesIndex = 1:numOfFacesPerPatch
    if obj.PlotSettings.Faces_PlotSettings(facesIndex) == eventData.Source; break; end
end

for knotPatchNumber = 1:obj.NurbsObject.ClosureTopologies(obj.PlotData.closureTopologyIndex).Connectivities.numberOfKnotPatches
    for surfaceIndex = 1:faceNum
        set(obj.geometryPlotHandle(surfaceIndex, facesIndex, knotPatchNumber), settingStringName, obj.PlotSettings.Faces_PlotSettings(facesIndex).(settingStringName));
    end
end

end