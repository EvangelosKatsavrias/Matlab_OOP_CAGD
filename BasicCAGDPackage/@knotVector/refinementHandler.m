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

function refinementHandler(obj, varargin)

switch obj.RefineData.status
    
    case 'Unprocessed'
        finalizeRefinement(obj, varargin{:});
        
    case 'Failed'
        failedRefinement(obj, varargin{:});
        
end

end


%%
function finalizeRefinement(obj, varargin)

switch obj.RefineData.type
    
    case 'KnotInsertion'
        obj.knotVectorReconstruction(cat(2, obj.knots, obj.RefineData.insertionKnots));
        
    case 'GlobalKnotInsertion'
        obj.knotVectorReconstruction(cat(2, obj.knots, obj.RefineData.insertionKnots));
        
    case 'KnotRemoval'
        removedKnotNumbers = [];
        for knotIndex = 1:length(obj.RefineData.removedKnots)
            removedKnotNumbers = cat(2, removedKnotNumbers, (sum(obj.knotMultiplicities(1:(obj.RefineData.removedKnots(knotIndex)-1))) +(1:obj.RefineData.removeMultiplicity(knotIndex))));
        end
        obj.knotVectorReconstruction(removeVectorElements(obj.knots, removedKnotNumbers));
        
    case 'GlobalKnotRemoval'
        obj.knotVectorReconstruction(removeVectorElements(obj.knots, obj.RefineData.removedKnots));
        
    case 'KnotMovement'
        obj.knots(obj.RefineData.movedKnots) = obj.knots(obj.RefineData.movedKnots)+obj.RefineData.knotMovements;
        obj.knotVectorReconstruction(obj.knots);
        
    case 'OrderElevation'
        obj.knotVectorReconstruction(varargin{1});
        
    case 'OrderDegradation'
        obj.knotVectorReconstruction(obj.knots(1+obj.RefineData.depthOfOrderDegradation:end-obj.RefineData.depthOfOrderDegradation));
        
    case 'GeneralRefinement'
        obj.knotVectorReconstruction(obj.RefineData.newKnots);
        
end

obj.RefineData.status = 'Succeed';

end


%%
function failedRefinement(obj, varargin)

switch obj.RefineData.type
    case 'KnotInsertion'
        
    case 'KnotRemoval'

    case 'KnotMovement'

    case 'OrderElevation'

    case 'OrderDegradation'

    case 'GeneralRefinement'

end

rethrow(obj.RefineData.Exception);

end