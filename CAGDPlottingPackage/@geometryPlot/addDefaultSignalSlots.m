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

function addDefaultSignalSlots(obj)

obj.SignalSlots.Geometry = addlistener(obj.NurbsObject.ClosureTopologies(obj.PlotData.closureTopologyIndex), 'notifyCAGDTopologyChanged', @(src, eventData)obj.handlingEvents(eventData));

for index = 1:length(obj.PlotSettings.Faces_PlotSettings)
    obj.SignalSlots.FaceColorSettings(index) = addlistener(obj.PlotSettings.Faces_PlotSettings(index), 'notifyFaceColorChanged', @(src, eventData)obj.handlingEvents(eventData));
    obj.SignalSlots.FaceAlphaSettings(index) = addlistener(obj.PlotSettings.Faces_PlotSettings(index), 'notifyFaceAlphaChanged', @(src, eventData)obj.handlingEvents(eventData));
    obj.SignalSlots.FaceEdgesColorSettings(index) = addlistener(obj.PlotSettings.Faces_PlotSettings(index), 'notifyFaceEdgesColorChanged', @(src, eventData)obj.handlingEvents(eventData));
    obj.SignalSlots.FaceEdgesAlphaSettings(index) = addlistener(obj.PlotSettings.Faces_PlotSettings(index), 'notifyFaceEdgesAlphaChanged', @(src, eventData)obj.handlingEvents(eventData));
    obj.SignalSlots.FaceEffectsSettings(index) = addlistener(obj.PlotSettings.Faces_PlotSettings(index), 'notifyFaceEffectsChanged', @(src, eventData)obj.handlingEvents(eventData));
    obj.SignalSlots.FaceEdgesEffectsSettings(index) = addlistener(obj.PlotSettings.Faces_PlotSettings(index), 'notifyFaceEdgesEffectsChanged', @(src, eventData)obj.handlingEvents(eventData));
end

end
