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

function insertKnot(obj, varargin)
    
if nargin < 2; return
elseif ~isa(varargin{1}, 'numeric')
    throw(MException('knotVector:insertKnot', 'The input argument in position ''1'' is not valid, must be of type numeric (i.e. the inserted knots in a vector array).'));
elseif max(varargin{1} == obj.knotsWithoutMultiplicities(1)) || max(varargin{1} == length(obj.knotsWithoutMultiplicities(end)))
    throw(MException('knotVector:insertKnot', 'The first and the last knots of a non-periodic knot vector cannot be modified by a knot insertion method, use order elevation method instead.'));
end

refineData(obj, varargin{:});

obj.notify('knotRefinementNurbsNotification');
obj.notify('localKnotsInsertionInduced');
obj.refinementHandler;
obj.notify('localKnotRefinementTensorBSplinesNotification');

end


%%  
function refineData(obj, varargin)

obj.RefineData.type                         = 'KnotInsertion';
obj.RefineData.status                       = 'Unprocessed';
obj.RefineData.initialNumOfKnots            = obj.totalNumberOfKnots;
obj.RefineData.insertionKnots               = sort(varargin{1});
obj.RefineData.insertionRefinedKnotPatches  = find(obj.RefineData.insertionKnots(1) < obj.knotsWithoutMultiplicities, 1, 'first')-1;
ValueTolerance                              = 1e-10;
if ~max((obj.knotsWithoutMultiplicities-ValueTolerance<obj.RefineData.insertionKnots(1))&(obj.RefineData.insertionKnots(1)<obj.knotsWithoutMultiplicities+ValueTolerance))
    obj.RefineData.numberOfNewKnotPatches   = 1;
else
    if obj.continuity == 0
        throw(MException('knotVector:insertKnots', 'The knot insertion procedure degrade the continuity below zero.'))
    end
    obj.RefineData.numberOfNewKnotPatches   = 0;
end

index = 1;
for insertionPointIndex = 2:length(obj.RefineData.insertionKnots)
    refinedKnotPatch = find(obj.RefineData.insertionKnots(insertionPointIndex) < obj.knotsWithoutMultiplicities, 1, 'first')-1;
    if ~(refinedKnotPatch == obj.RefineData.insertionRefinedKnotPatches(index))
        obj.RefineData.insertionRefinedKnotPatches = cat(2, obj.RefineData.insertionRefinedKnotPatches, refinedKnotPatch);
        index = index +1;
        obj.RefineData.numberOfNewKnotPatches = cat(2, obj.RefineData.numberOfNewKnotPatches, 0);
    end
    if ~max((obj.knotsWithoutMultiplicities-ValueTolerance<obj.RefineData.insertionKnots(insertionPointIndex))&(obj.RefineData.insertionKnots(insertionPointIndex)<obj.knotsWithoutMultiplicities+ValueTolerance))
        obj.RefineData.numberOfNewKnotPatches(index) = obj.RefineData.numberOfNewKnotPatches(index) +1;
    end
end

% find new refined spans in the new refined knot vector
numberOfRefinedKnotPatches  = length(obj.RefineData.insertionRefinedKnotPatches);
refinedKnotPatches          = cell(1, numberOfRefinedKnotPatches);
previousInsertedKnotPatches = 0;
newTotalNumberOfKnotPatches = obj.numberOfKnotPatches+sum(obj.RefineData.numberOfNewKnotPatches);
for refineIndex = 1:numberOfRefinedKnotPatches
    leftRefinedKnotPatches          = obj.RefineData.insertionRefinedKnotPatches(refineIndex)-(obj.order-2);
    rightRefinedKnotPatches         = obj.RefineData.insertionRefinedKnotPatches(refineIndex)+(obj.order-2)+obj.RefineData.numberOfNewKnotPatches(refineIndex);
    refinedKnotPatches{refineIndex} = max(1, leftRefinedKnotPatches+previousInsertedKnotPatches):min(newTotalNumberOfKnotPatches, rightRefinedKnotPatches+previousInsertedKnotPatches);
    previousInsertedKnotPatches     = previousInsertedKnotPatches +obj.RefineData.numberOfNewKnotPatches(refineIndex);
end

obj.RefineData.newRefinedKnotPatches    = cell(1);
obj.RefineData.newRefinedKnotPatches{1} = refinedKnotPatches{1};
obj.RefineData.insertedNewKnotPatches   = obj.RefineData.numberOfNewKnotPatches(1);
index                                   = 1;
for refineIndex = 2:numberOfRefinedKnotPatches
    if obj.RefineData.newRefinedKnotPatches{index}(end) >= refinedKnotPatches{refineIndex}(1)-1
        obj.RefineData.newRefinedKnotPatches{index}      = filterUniqueSortedVectorElements(sort(cat(2, obj.RefineData.newRefinedKnotPatches{index}, refinedKnotPatches{refineIndex})));
        obj.RefineData.insertedNewKnotPatches(index)     = obj.RefineData.insertedNewKnotPatches(index) +obj.RefineData.numberOfNewKnotPatches(refineIndex);
    else
        index                                           = index +1;
        obj.RefineData.newRefinedKnotPatches{index}     = refinedKnotPatches{refineIndex};
        obj.RefineData.insertedNewKnotPatches           = cat(2, obj.RefineData.insertedNewKnotPatches, obj.RefineData.numberOfNewKnotPatches(refineIndex));
    end
end

end