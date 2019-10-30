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

function coordinates = getPartOfCoordinates(obj, coordNumbers, varargin)

if nargin == 2
    dimns = num2cell(repmat(':', 1, obj.numberOfParametricCoordinates));
    coordinates = obj.coordinates(dimns{:}, coordNumbers);
    
elseif ~(strcmp(varargin{1}, 'structured') || strcmp(varargin{1}, 'sequenced'))
    throw(MException('controlPointsStructure:getAllControlPointsCoordinates', 'As first input argument, provide a string identifier for the output form of the coordinates: ''structured'', ''sequenced''.'));

elseif strcmp(varargin{1}, 'structured')
    dimns = num2cell(repmat(':', 1, obj.numberOfParametricCoordinates));
    coordinates = obj.coordinates(dimns{:}, coordNumbers);

elseif strcmp(varargin{1}, 'sequenced')
    coordinates = reshape(obj.coordinates, prod(obj.numberOfControlPoints), obj.numberOfCoordinates);
    coordinates = coordinates(:, coordNumbers);

end

end