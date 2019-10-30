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

% knotVector listeners
obj.SignalSlots.KnotVector.localInsertion = addlistener(obj.KnotVector, 'localKnotsInsertionInduced',       @(src, eventData)obj.handlingEvents(eventData));
obj.SignalSlots.KnotVector.globalInsertion = addlistener(obj.KnotVector, 'globalKnotsInsertionInduced',     @(src, eventData)obj.handlingEvents(eventData));
obj.SignalSlots.KnotVector.localKnotRemoval = addlistener(obj.KnotVector, 'localKnotsRemovalInduced',       @(src, eventData)obj.handlingEvents(eventData));
obj.SignalSlots.KnotVector.globalKnotRemoval = addlistener(obj.KnotVector, 'globalKnotsRemovalInduced',     @(src, eventData)obj.handlingEvents(eventData));
obj.SignalSlots.KnotVector.localKnotMovement = addlistener(obj.KnotVector, 'localKnotsMovementInduced',     @(src, eventData)obj.handlingEvents(eventData));
obj.SignalSlots.KnotVector.renormalization = addlistener(obj.KnotVector, 'knotsRenormalizationInduced',     @(src, eventData)obj.handlingEvents(eventData));
obj.SignalSlots.KnotVector.generalRefinement = addlistener(obj.KnotVector, 'generalKnotsRefinementInduced', @(src, eventData)obj.handlingEvents(eventData));
obj.SignalSlots.KnotVector.orderElevation = addlistener(obj.KnotVector, 'orderElevationInduced',            @(src, eventData)obj.handlingEvents(eventData));
obj.SignalSlots.KnotVector.orderDegradation = addlistener(obj.KnotVector, 'orderDegradationInduced',        @(src, eventData)obj.handlingEvents(eventData));

end