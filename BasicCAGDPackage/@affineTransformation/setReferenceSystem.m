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

function setReferenceSystem(obj, numOfCoords, systemType, varargin)
% (number of Coordinates, type of coordinate system, system origin, system directors(a vector of angles or a matrix of vectors form))
if strcmp(systemType, 'GCS') || strcmp(systemType, 'LCS')
    obj.transformationReferenceSystemType = systemType;
    obj.numOfCoordinates = numOfCoords;
else
    throw(MException('affineTransformation:setReferenceSystem', 'No valid reference system identifier is given, provide one of the strings: ''GCS'', ''LCS''.'));
end

obj.transformationReferenceSystemOrigin     = zeros(1, numOfCoords);
obj.transformationReferenceSystemDirectors  = eye(numOfCoords, numOfCoords);

if strcmp(systemType, 'LCS')
    if nargin > 3
        obj.transformationReferenceSystemOrigin = varargin{1};
        obj.localTranslationMatrix = obj.homogeneousTranslationMatrix(varargin{1});
        obj.localTransformationMatix = obj.localTranslationMatrix;

    end
    
    if nargin > 4
        if isvector(varargin{2})
            obj.localRotationMatrix = obj.homogeneousRotationMatrix(varargin{2});
            obj.transformationReferenceSystemDirectors = obj.localRotationMatrix(1:numOfCoords, 1:numOfCoords);
            
        else
            obj.transformationReferenceSystemDirectors = varargin{2};
            obj.localRotationMatrix = eye(numOfCoords+1 , numOfCoords+1);
            obj.localRotationMatrix(1:numOfCoords, 1:numOfCoords) ...
                = obj.transformationReferenceSystemDirectors;
            
        end
        obj.localTransformationMatix = obj.localTransformationMatix*obj.localRotationMatrix;
        
    else
        obj.transformationReferenceSystemDirectors = eye(numOfCoords, numOfCoords);
        
    end
    
end

end