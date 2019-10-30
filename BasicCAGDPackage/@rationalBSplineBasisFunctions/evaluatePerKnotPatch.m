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

function evaluatePerKnotPatch(obj, varargin)

evaluatePerKnotPatch@bSplineBasisFunctions(obj, varargin{:});
for spanIndex = 1:obj.KnotVector.numberOfKnotPatches
    
    currentWeights                      = obj.weights(1, obj.KnotVector.knotPatch2BasisFunctions(spanIndex, :));
    obj.weightField(:, spanIndex, 1)    = currentWeights*obj.evaluationsPerKnotPatch(:, :, spanIndex, 1);
    invWfield                           = 1./(obj.weightField(:, spanIndex, 1)');
    
    obj.evaluationsPerKnotPatch(:,:, spanIndex, 1) = obj.evaluationsPerKnotPatch(:, :, spanIndex, 1).*(currentWeights'*invWfield);
    
    for derivativeIndex = 2:size(obj.evaluationsPerKnotPatch, 4)

        obj.weightField(:, spanIndex, derivativeIndex) = currentWeights*obj.evaluationsPerKnotPatch(:,:, spanIndex, derivativeIndex);
        obj.evaluationsPerKnotPatch(:,:, spanIndex, derivativeIndex) = ...
            obj.evaluationsPerKnotPatch(:,:, spanIndex, derivativeIndex).*(currentWeights'*invWfield);
        
        comb = zeros(obj.KnotVector.order, size(obj.evaluationsPerKnotPatch, 2));
        for index = 2:derivativeIndex
            comb = comb + nchoosek(derivativeIndex-1, index-1)*repmat(obj.weightField(:, spanIndex, index)', obj.KnotVector.order, 1).*obj.evaluationsPerKnotPatch(:,:, spanIndex, derivativeIndex-index+1);
        end
        
        obj.evaluationsPerKnotPatch(:,:, spanIndex, derivativeIndex) = ...
            obj.evaluationsPerKnotPatch(:,:, spanIndex, derivativeIndex) ...
          - comb.*repmat(invWfield, obj.KnotVector.order, 1);
        
    end
    
end

obj.evaluationsPerFunction = [];

end