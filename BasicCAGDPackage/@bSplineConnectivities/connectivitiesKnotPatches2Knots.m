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

function connectivitiesKnotPatches2Knots(obj, varargin)

obj.knotPatch2Knots = zeros(2*obj.numberOfParametricCoordinates, obj.numberOfKnotPatches);

previousKnotsRepetition = 1;
for parametricCoordinateIndex = 1:obj.numberOfParametricCoordinates

    parametricCoordinate            = obj.controlPointsCountingSequence(parametricCoordinateIndex);
    followingParametricCoordinates  = obj.controlPointsCountingSequence(parametricCoordinateIndex+1:end);

    if isempty(followingParametricCoordinates)
        numberOfFollowingKnots = 1;
    else
        numberOfFollowingKnots = prod(cell2mat({obj.KnotVectors(followingParametricCoordinates).numberOfKnotPatches}));
    end
    knotsTemp = zeros(2, obj.KnotVectors(parametricCoordinate).numberOfKnotPatches);

    knotsTemp(1, :) = 1:obj.KnotVectors(parametricCoordinate).numberOfKnotPatches;
    knotsTemp(2, :) = 2:obj.KnotVectors(parametricCoordinate).numberOfKnotPatches+1;
    knotsTemp       = repmat(knotsTemp, [1, 1, previousKnotsRepetition]);
    knotsTemp       = permute(knotsTemp, [1 3 2]);
    knotsTemp       = reshape(knotsTemp, 2, []);
    
    knotsTemp       = repmat(knotsTemp, [1, 1, numberOfFollowingKnots]);
    
    knotsTemp       = reshape(knotsTemp, 2, []);
    
    obj.knotPatch2Knots((parametricCoordinate-1)*2+(1:2), :) = knotsTemp;
    
    previousKnotsRepetition = previousKnotsRepetition*obj.KnotVectors(parametricCoordinate).numberOfKnotPatches;
    
end

obj.knotPatch2Knots = obj.knotPatch2Knots';

end