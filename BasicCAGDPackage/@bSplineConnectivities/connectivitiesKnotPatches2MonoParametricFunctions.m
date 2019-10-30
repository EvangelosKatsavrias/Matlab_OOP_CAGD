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

function connectivitiesKnotPatches2MonoParametricFunctions(obj, varargin)

knotPatch2MonoParametricFunctions = cell(1, obj.numberOfParametricCoordinates);

for parametricCoordinateIndex = 1:obj.numberOfParametricCoordinates
    
    knotPatch2MonoParametricFunctions{parametricCoordinateIndex} = zeros(obj.basisFunctions(parametricCoordinateIndex).knotVector.numberOfnonZeroKnotSpans, obj.basisFunctions(parametricCoordinateIndex).knotVector.order);
    
    for nonZeroKnotSpanIndex = 1:obj.basisFunctions(parametricCoordinateIndex).knotVector.numberOfnonZeroKnotSpans
             
        knotPatch2MonoParametricFunctions{parametricCoordinateIndex}(nonZeroKnotSpanIndex, :) = ...
            obj.basisFunctions(parametricCoordinateIndex).knotVector.knotSpanNumbers ...
           -obj.basisFunctions(parametricCoordinateIndex).degree +(1:obj.basisFunctions(parametricCoordinateIndex).knotVector.order);

    end
    
end

obj.knotPatch2ControlPolygons = knotPatch2MonoParametricFunctions;

end