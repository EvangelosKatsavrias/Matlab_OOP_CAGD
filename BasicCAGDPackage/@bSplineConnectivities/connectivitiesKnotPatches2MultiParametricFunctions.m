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

function connectivitiesKnotPatches2MultiParametricFunctions(obj, varargin)
%  Mapping global control point numbering to patch control point numbering

positionShifts                                          = cell(1, obj.numberOfParametricCoordinates);
positionShifts{obj.controlPointsCountingSequence(1)}    = obj.KnotVectors(obj.controlPointsCountingSequence(1)).knotPatch2BasisFunctions;
previousShifts                                          = obj.KnotVectors(obj.controlPointsCountingSequence(1)).numberOfBasisFunctions;

for parametricCoordinateIndex = 2:obj.numberOfParametricCoordinates
    parametricCoordinate                    = obj.controlPointsCountingSequence(parametricCoordinateIndex);
    positionShifts{parametricCoordinate}    = (obj.KnotVectors(parametricCoordinate).knotPatch2BasisFunctions-1)*previousShifts;
    previousShifts                          = previousShifts*obj.KnotVectors(parametricCoordinate).numberOfBasisFunctions;
end

obj.knotPatch2MultiParametricFunctions = zeros(obj.numberOfKnotPatches, obj.numberOfFunctionsPerKnotPatch);
for elementIndex = 1:obj.numberOfKnotPatches
    
    elementKnots    = obj.knotPatch2Knots(elementIndex, :);
    firstKnots      = elementKnots(1:2:end);
    
    firstParametricCoordinate   = obj.controlPointsCountingSequence(1);
    elementsControlPoints2      = positionShifts{firstParametricCoordinate}(firstKnots(firstParametricCoordinate), :)';

    for parametricCoordinateIndex = 2:obj.numberOfParametricCoordinates
        
        parametricCoordinate    = obj.controlPointsCountingSequence(parametricCoordinateIndex);
        elementsControlPoints   = positionShifts{parametricCoordinate}(firstKnots(parametricCoordinate), :)';
        elementsControlPoints3  = zeros(length(elementsControlPoints2), size(obj.KnotVectors(parametricCoordinate).knotPatch2BasisFunctions, 2));
        
        for index = 1:size(obj.KnotVectors(parametricCoordinate).knotPatch2BasisFunctions, 2)
            elementsControlPoints3(:, index) = elementsControlPoints2(:, 1) + elementsControlPoints(index);
        end
        elementsControlPoints2 = reshape(elementsControlPoints3, [], 1);
    
    end
    
    obj.knotPatch2MultiParametricFunctions(elementIndex, :) = elementsControlPoints2;
    
end

end