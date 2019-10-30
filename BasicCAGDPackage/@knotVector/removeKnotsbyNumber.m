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

function removeKnotsbyNumber(obj, varargin)
%%  Check input validity
if nargin < 2; return
elseif ~isa(varargin{1}, 'numeric');
    throw(MException('knotVector:removeKnotsbyNumber', 'The input argument in position ''1'' is not valid, must be of type positive integers, i.e. the knots to be removed in a vector array.'));
elseif max(varargin{1} > length(obj.knots));
    throw(MException('knotVector:removeKnotsbyNumber', 'The requested knot positions to remove, exceeds the total number of knots.'));
elseif max(varargin{1} == 1) || max(varargin{1} == length(obj.knotsWithoutMultiplicities))
    throw(MException('knotVector:removeKnotsbyNumber', 'The first and the last knots of a non-periodic knot vector cannot be modified by a knot removal method, use order degradation method instead.'));
end


%%  Refine the knot vector or notify before or after other interested objects on that event
refinedData(obj, varargin{:});

obj.notify('knotRefinementNurbsNotification');
obj.notify('localKnotsRemovalInduced');
obj.refinementHandler;
obj.notify('localKnotRefinementTensorBSplinesNotification');

end


%%  
function refinedData(obj, varargin)

obj.RefineData.type                 = 'KnotRemoval';
obj.RefineData.status               = 'Unprocessed';
obj.RefineData.initialNumOfKnots    = obj.totalNumberOfKnots;
obj.RefineData.removedKnots         = sort(varargin{1});
obj.RefineData.initialMultiplicities= zeros(1, length(obj.RefineData.removedKnots));
for removedKnotIndex = 1:length(obj.RefineData.removedKnots)
    obj.RefineData.initialMultiplicities(removedKnotIndex) = obj.knotMultiplicities(obj.RefineData.removedKnots(removedKnotIndex));
end

obj.RefineData.removeMultiplicity = 1;
removedKnotIndex = 1;
while removedKnotIndex < length(obj.RefineData.removedKnots)
    if obj.RefineData.removedKnots(removedKnotIndex) == obj.RefineData.removedKnots(removedKnotIndex+1)
        obj.RefineData.removeMultiplicity(removedKnotIndex)     = obj.RefineData.removeMultiplicity(removedKnotIndex)+1;
        obj.RefineData.initialMultiplicities                    = cat(2, obj.RefineData.initialMultiplicities(1:removedKnotIndex), obj.RefineData.initialMultiplicities(removedKnotIndex+2:end));
        obj.RefineData.removedKnots                             = cat(2, obj.RefineData.removedKnots(1:removedKnotIndex), obj.RefineData.removedKnots(removedKnotIndex+2:end));
    else
        obj.RefineData.removeMultiplicity   = cat(2, obj.RefineData.removeMultiplicity, 1);
        removedKnotIndex                    = removedKnotIndex+1;
    end
end

if max(obj.RefineData.initialMultiplicities-obj.RefineData.removeMultiplicity < 0)
    throw(MException('knotVector:removeKnotsbyNumber', 'Excessive knot removal emereged, check the knots multiplicities and the requested knots removals.'));
end

obj.RefineData.mergedKnotPatches = zeros(1, length(obj.RefineData.removedKnots));
for removedKnotIndex = 1:length(obj.RefineData.removedKnots)
    if obj.RefineData.initialMultiplicities-obj.RefineData.removeMultiplicity == 0
        obj.RefineData.mergedKnotPatches(removedKnotIndex) = 1;
    end
end


% new refined spans with new knotvector
numberOfRefinedKnots        = length(obj.RefineData.removedKnots);
refinedKnotPatches          = cell(1, numberOfRefinedKnots);
previousMergedKnotPatches   = 0;
newTotalNumberOfKnotPatches = obj.numberOfKnotPatches-sum(obj.RefineData.mergedKnotPatches);
for refineIndex = 1:numberOfRefinedKnots
    leftRefinedKnotPatches          = obj.RefineData.removedKnots(refineIndex)-(obj.order-1);
    rightRefinedKnotPatches         = obj.RefineData.removedKnots(refineIndex)+(obj.order-2)-obj.RefineData.mergedKnotPatches(refineIndex);
    refinedKnotPatches{refineIndex} = (max(1, leftRefinedKnotPatches-previousMergedKnotPatches):min(newTotalNumberOfKnotPatches, rightRefinedKnotPatches-previousMergedKnotPatches));
    previousMergedKnotPatches       = previousMergedKnotPatches +obj.RefineData.mergedKnotPatches(refineIndex);
end

obj.RefineData.newRefinedKnotPatches        = cell(1);
obj.RefineData.newRefinedKnotPatches{1}     = refinedKnotPatches{1};
obj.RefineData.contiguousMergedKnotPatches  = obj.RefineData.mergedKnotPatches(1);
index                                       = 1;
for refineIndex = 2:numberOfRefinedKnots
    if obj.RefineData.newRefinedKnotPatches{index}(end) >= refinedKnotPatches{refineIndex}(1)-1
        obj.RefineData.newRefinedKnotPatches{index}         = filterUniqueSortedVectorElements(sort(cat(2, obj.RefineData.newRefinedKnotPatches{index}, refinedKnotPatches{refineIndex})));
        obj.RefineData.contiguousMergedKnotPatches(index)   = obj.RefineData.contiguousMergedKnotPatches(index) +obj.RefineData.mergedKnotPatches(refineIndex);
    else
        index                                       = index +1;
        obj.RefineData.newRefinedKnotPatches{index} = refinedKnotPatches{refineIndex};
        obj.RefineData.contiguousMergedKnotPatches  = cat(2, obj.RefineData.contiguousMergedKnotPatches, obj.RefineData.mergedKnotPatches(refineIndex));
    end
end

end