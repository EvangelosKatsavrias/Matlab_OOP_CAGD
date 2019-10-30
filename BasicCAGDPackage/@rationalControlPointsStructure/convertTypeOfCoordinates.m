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

function convertTypeOfCoordinates(obj, typeOfCoordinates)

if strcmp(obj.typeOfCoordinates, typeOfCoordinates)
else
    
    if ~(strcmp(typeOfCoordinates, 'Homogeneous')||strcmp(typeOfCoordinates, 'Cartesian'))
        throw(MException('rationalControlPoints:convertTypeOfCoordinates', 'Wrong input data, please provide a proper type of coordinates, valid options are ''Homogeneous'' and ''Cartesian''.'));
    else
        
        if strcmp(typeOfCoordinates, 'Homogeneous')
            obj.typeOfCoordinates = 'Homogeneous';
            obj.setAllControlPointsCoordinates(obj.coordinates.*repmat(obj.weights, [ones(1, obj.numberOfParametricCoordinates) obj.numberOfCoordinates]), 0);

        else
            obj.typeOfCoordinates = 'Cartesian';
            obj.setAllControlPointsCoordinates(obj.coordinates./repmat(obj.weights, [ones(1, obj.numberOfParametricCoordinates) obj.numberOfCoordinates]), 0);
            
        end
        
    end
    
end

end