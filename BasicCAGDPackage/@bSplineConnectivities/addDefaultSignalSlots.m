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
for knotVectorIndex = 1:length(obj.KnotVectors)
    obj.SignalSlots.KnotVector(knotVectorIndex).localInsertion = addlistener(obj.KnotVectors(knotVectorIndex), 'localKnotsInsertionInduced',        @(src, eventData)obj.handlingEvents(eventData));
    obj.SignalSlots.KnotVector(knotVectorIndex).localRemoval = addlistener(obj.KnotVectors(knotVectorIndex), 'localKnotsRemovalInduced',            @(src, eventData)obj.handlingEvents(eventData));
    obj.SignalSlots.KnotVector(knotVectorIndex).localMovement = addlistener(obj.KnotVectors(knotVectorIndex), 'localKnotsMovementInduced',          @(src, eventData)obj.handlingEvents(eventData));
    obj.SignalSlots.KnotVector(knotVectorIndex).globalInsertion = addlistener(obj.KnotVectors(knotVectorIndex), 'globalKnotsInsertionInduced',      @(src, eventData)obj.handlingEvents(eventData));
    obj.SignalSlots.KnotVector(knotVectorIndex).globalRemoval = addlistener(obj.KnotVectors(knotVectorIndex), 'globalKnotsRemovalInduced',          @(src, eventData)obj.handlingEvents(eventData));
    obj.SignalSlots.KnotVector(knotVectorIndex).orderElevation = addlistener(obj.KnotVectors(knotVectorIndex), 'orderElevationInduced',             @(src, eventData)obj.handlingEvents(eventData));
    obj.SignalSlots.KnotVector(knotVectorIndex).orderDegradation = addlistener(obj.KnotVectors(knotVectorIndex), 'orderDegradationInduced',         @(src, eventData)obj.handlingEvents(eventData));
    obj.SignalSlots.KnotVector(knotVectorIndex).renormalization = addlistener(obj.KnotVectors(knotVectorIndex), 'knotsRenormalizationInduced',      @(src, eventData)obj.handlingEvents(eventData));
    obj.SignalSlots.KnotVector(knotVectorIndex).generalRefinement = addlistener(obj.KnotVectors(knotVectorIndex), 'generalKnotsRefinementInduced',  @(src, eventData)obj.handlingEvents(eventData));
end

end