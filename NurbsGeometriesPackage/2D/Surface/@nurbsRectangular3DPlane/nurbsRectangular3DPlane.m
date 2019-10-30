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

classdef nurbsRectangular3DPlane < nurbsGeometry
    
    methods
        function obj = nurbsRectangular3DPlane(varargin)
            [origin, width, height, angles, constructorData] = constructorPreprocessor(varargin{:});
            obj@nurbsGeometry(constructorData{1:2});
            constructorPostprocessor(obj, origin, width, height, angles, constructorData{:});
        end
        
    end
    
end


%%
function [origin, width, height, angles, constructorData] = constructorPreprocessor(varargin)

if nargin == 0; origin = [0 0 0]; width = 1; height = 1;
else origin = varargin{1}; width = varargin{2}(1); height = varargin{2}(2);
end
if nargin > 2; angles = varargin{3}; else angles = [0 0 0]; end

dx = width;   dy = height;

uKnotVector = knotVector([0 0 1 1]);
vKnotVector = knotVector([0 0 1 1]);

x = [-dx -dx
      dx  dx]*0.5;

y = [-dy dy
     -dy dy]*0.5;

coords          = cat(3, x, y, zeros(2, 2));
controlPoints   = rationalControlPointsStructure('Cartesian', coords, ones(2, 2));
constructorData = [{[uKnotVector vKnotVector], controlPoints} varargin];

end


function constructorPostprocessor(obj, origin, width, height, angles, varargin)

obj.GeometryProperties.width = width;
obj.GeometryProperties.height = height;
if length(varargin) > 2; obj.GeometryProperties.thickness = varargin{3};
else obj.GeometryProperties.thickness = 1;
end
obj.rotateInGCS(angles);
obj.moveInGCS(origin);

end