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

for objectIndex = 1:length(obj.GeometryProperties.FrameNurbsObjects)
    obj.SignalSlots.NurbsSurfaceSkin.FrameObjects(objectIndex).allWeightsChanged = addlistener(obj.GeometryProperties.FrameNurbsObjects(objectIndex).ControlPoints, 'notifyAllControlPointsWeightsChanged',       @(src, eventData)obj.handlingEvents(eventData));
    obj.SignalSlots.NurbsSurfaceSkin.FrameObjects(objectIndex).partOfWeightsChanged = addlistener(obj.GeometryProperties.FrameNurbsObjects(objectIndex).ControlPoints, 'notifyPartOfControlPointsWeightsChanged',    @(src, eventData)obj.handlingEvents(eventData));
    obj.SignalSlots.NurbsSurfaceSkin.FrameObjects(objectIndex).newControlPointsSetted = addlistener(obj.GeometryProperties.FrameNurbsObjects(objectIndex).ControlPoints, 'notifyNewControlPointsSetted',               @(src, eventData)obj.handlingEvents(eventData));
    obj.SignalSlots.NurbsSurfaceSkin.FrameObjects(objectIndex).allControlPointsResetted = addlistener(obj.GeometryProperties.FrameNurbsObjects(objectIndex).ControlPoints, 'notifyAllControlPointsResetted',             @(src, eventData)obj.handlingEvents(eventData));
    obj.SignalSlots.NurbsSurfaceSkin.FrameObjects(objectIndex).partOfControlPointsResetted = addlistener(obj.GeometryProperties.FrameNurbsObjects(objectIndex).ControlPoints, 'notifyPartOfControlPointsResetted',          @(src, eventData)obj.handlingEvents(eventData));
    obj.SignalSlots.NurbsSurfaceSkin.FrameObjects(objectIndex).allControlPointsCoordinatesChanged = addlistener(obj.GeometryProperties.FrameNurbsObjects(objectIndex).ControlPoints, 'notifyAllControlPointsCoordinatesChanged',   @(src, eventData)obj.handlingEvents(eventData));
    obj.SignalSlots.NurbsSurfaceSkin.FrameObjects(objectIndex).partOfControlPointsCoordinatesChanged = addlistener(obj.GeometryProperties.FrameNurbsObjects(objectIndex).ControlPoints, 'notifyPartOfControlPointsCoordinatesChanged',@(src, eventData)obj.handlingEvents(eventData));
    obj.SignalSlots.NurbsSurfaceSkin.FrameObjects(objectIndex).partOfCoordinatesChanged = addlistener(obj.GeometryProperties.FrameNurbsObjects(objectIndex).ControlPoints, 'notifyPartOfCoordinatesChanged',             @(src, eventData)obj.handlingEvents(eventData));
    obj.GeometryProperties.FrameNurbsObjects(objectIndex).SignalSlots.KnotVector.knotRefinement.Enabled = 0;
    obj.GeometryProperties.FrameNurbsObjects(objectIndex).SignalSlots.KnotVector.orderRefinement.Enabled = 0;

end

obj.SignalSlots.NurbsSurfaceSkin.ControlPoints.partOfControlPointsResetted = addlistener(obj.ControlPoints, 'notifyPartOfControlPointsResetted',          @(src, eventData)obj.handlingEvents(eventData));
% obj.ClosureTopologies(obj.).NurbsSurfaceSkin.ControlPoints.partOfControlPointsResetted = addlistener(obj.ControlPoints, 'notifyPartOfControlPointsResetted',          @(src, eventData)obj.handlingEvents(eventData));


end