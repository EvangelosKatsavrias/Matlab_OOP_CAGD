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

obj.SignalSlots.BasisFunctions.tensorBasisFunctionsChanged      = addlistener(obj.BasisFunctions, 'basisFunctionsChangeInduced',                @(src, eventData)obj.handlingEvents(eventData));
obj.SignalSlots.ControlPoints.newControlPoints                  = addlistener(obj.ControlPoints, 'notifyNewControlPointsSetted',                @(src, eventData)obj.handlingEvents(eventData));
obj.SignalSlots.ControlPoints.allControlPointsResetted          = addlistener(obj.ControlPoints, 'notifyAllControlPointsResetted',                @(src, eventData)obj.handlingEvents(eventData));
obj.SignalSlots.ControlPoints.partOfControlPointsResetted       = addlistener(obj.ControlPoints, 'notifyPartOfControlPointsResetted',                @(src, eventData)obj.handlingEvents(eventData));
obj.SignalSlots.ControlPoints.allControlPointsCoordinates       = addlistener(obj.ControlPoints, 'notifyAllControlPointsCoordinatesChanged',    @(src, eventData)obj.handlingEvents(eventData));
obj.SignalSlots.ControlPoints.partOfControlPointsCoordinates    = addlistener(obj.ControlPoints, 'notifyPartOfControlPointsCoordinatesChanged', @(src, eventData)obj.handlingEvents(eventData));
obj.SignalSlots.ControlPoints.partOfCoordinates                 = addlistener(obj.ControlPoints, 'notifyPartOfCoordinatesChanged',              @(src, eventData)obj.handlingEvents(eventData));

end