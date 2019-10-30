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

function defaultConnectivities(obj, varargin)

if nargin == 1
    obj.connectivitiesKnotPatches2Knots;
    obj.connectivitiesKnotPatches2MultiParametricFunctions;
    obj.connectivitiesBoundaries2Closure;
else
    for index = 1:length(varargin)
        connectivitiesSwitcher(obj, varargin{index});
    end
end

end


function connectivitiesSwitcher(obj, type)

    switch type
        case 'none'
        case 'KnotPatches2Knots'
            obj.connectivitiesKnotPatches2Knots;
        case 'KnotPatches2Functions'
            obj.connectivitiesKnotPatches2MultiParametricFunctions;
        case 'Boundaries2Closure'
            obj.connectivitiesBoundaries2Closure;
        otherwise
            throw(MException(obj.ExceptionsData.msgID, 'Not a valid type of connectivities.'));
    end
    
end