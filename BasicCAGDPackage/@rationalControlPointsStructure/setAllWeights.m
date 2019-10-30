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

function setAllWeights(obj, newWeights, varargin)

obj.convertTypeOfCoordinates('Cartesian');

if nargin > 2; notificationFlag = varargin{1};
else notificationFlag = 1;
end

if isnumeric(newWeights)
    if isvector(newWeights) && obj.numberOfParametricCoordinates > 1
        newWeights = reshape(newWeights, obj.numberOfControlPoints);
        numOfContrlPoints = size(newWeights);
    elseif obj.numberOfParametricCoordinates > 1
        numOfContrlPoints = size(newWeights);
    else numOfContrlPoints = size(newWeights, 1);
    end

    if all(numOfContrlPoints == obj.numberOfControlPoints)
        obj.weights = newWeights;
    else throw(MException('rationalControlPoints:setNewWeights', 'The provided weights data are incompatible with the stored coordinates array.'));
    end
    
else
    throw(MException('rationalControlPoints:setNewWeights', 'Provide numeric type data.'));

end

if notificationFlag; obj.notify('notifyAllControlPointsWeightsChanged'); end

end