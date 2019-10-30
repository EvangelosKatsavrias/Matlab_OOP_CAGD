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

function setPartOfCoordinates(obj, coordNumbers, newCoordinates, varargin)

if nargin > 3; notificationFlag = varargin{1};
else notificationFlag = 1;
end

if isnumeric(newCoordinates)
    if ismatrix(newCoordinates) && obj.numberOfParametricCoordinates > 1
        newCoordinates = reshape(newCoordinates, obj.numberOfControlPoints);
    end

else
    throw(MException('controlPointsStructure:setNewSingleCoordinateNumber', 'Provide numeric type data.'));

end

dimns = num2cell(repmat(':', 1, obj.numberOfParametricCoordinates));
obj.coordinates(dimns{:}, coordNumbers) = newCoordinates;

if notificationFlag; notify(obj, 'notifyPartOfCoordinatesChanged', coordNumbers); end

end