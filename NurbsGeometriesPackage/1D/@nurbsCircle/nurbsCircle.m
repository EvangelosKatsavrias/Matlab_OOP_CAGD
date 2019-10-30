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

% NURBS geometry of a circle
classdef nurbsCircle < nurbsPlaneCircle
    
    methods
        function obj = nurbsCircle(varargin) % (origin, radius, angles, circleType) || % (planeCircleObj, origin, angles, circleType)
            constructorData = constructorPreprocessor(varargin{:});
            obj@nurbsPlaneCircle(constructorData{:});
            constructorPostprocessor(obj, varargin{:});
        end
    end
    
end


%%
function constructorData = constructorPreprocessor(varargin)

if nargin == 0
    constructorData = {}; return;    
end

if isa(varargin{1}, 'nurbsPlaneCircle') 
    radius = varargin{1}.GeometryProperties.radius;
else 
    radius = varargin{2};
end

if isa(varargin{1}, 'nurbsPlaneCircle') && nargin == 4
    circleType = varargin{1}.GeometryProperties.type;
elseif nargin == 4
    circleType = varargin{4};
else circleType = 1;
end

constructorData = {[0 0], radius, 0, circleType};

end


%%
function constructorPostprocessor(obj, varargin)

obj.GeometryProperties.LCS_origin = [0 0 0];

if nargin == 1
    LCS_originCoords = [0 0 0];
    obj.GeometryProperties.angles = [0 0 obj.GeometryProperties.angle];
elseif isa(varargin{1}, 'nurbsPlaneCircle')
    LCS_originCoords = varargin{2};
    if nargin > 3
        obj.GeometryProperties.angles = varargin{3};
    else obj.GeometryProperties.angles = [0 0 0];
    end
else
    LCS_originCoords = varargin{1};
    if nargin > 3
        obj.GeometryProperties.angles = varargin{3};
    else obj.GeometryProperties.angles = [0 0 0];
    end
end

obj.GeometryProperties = rmfield(obj.GeometryProperties, 'angle');
obj.addNewPhysicalDimension;
obj.GeometryProperties.LCS_Directors = eye(3, 3);

obj.rotateInGCS(obj.GeometryProperties.angles);
obj.moveInGCS(LCS_originCoords);

end