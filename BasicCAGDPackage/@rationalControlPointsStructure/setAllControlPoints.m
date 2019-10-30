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

function setAllControlPoints(obj, newControlPoints, varargin)

if nargin < 3 && ismatrix(newControlPoints) && obj.numberOfParametricCoordinates>1
    varargin{1} = newControlPoints(:, obj.numberOfCoordinates+1);
    newControlPoints = newControlPoints(:, 1:obj.numberOfCoordinates);
    
elseif nargin < 3
    allElem = num2cell(repmat(':', 1, obj.numberOfParametricCoordinates));
    varargin{1} = newControlPoints(allElem{:}, obj.numberOfCoordinates+1);
    newControlPoints = newControlPoints(allElem{:}, 1:obj.numberOfCoordinates);
    
end

obj.setAllControlPointsCoordinates(newControlPoints, 0);
obj.setAllWeights(varargin{1}, 0);

notify(obj, 'notifyAllControlPointsResetted');

end