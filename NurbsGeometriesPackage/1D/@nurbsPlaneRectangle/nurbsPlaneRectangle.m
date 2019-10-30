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

% NURBS circular domain
classdef nurbsPlaneRectangle < nurbsGeometry

    methods
        function obj = nurbsPlaneRectangle(varargin) %(origin, dimensions, rotationAngleInPlane)
            [origin, dimensions, angle, type, constructorData] = constructorPreprocessor(varargin{:});
            obj@nurbsGeometry(constructorData{1:2});
            constructorPostprocessor(obj, origin, dimensions, angle, type, constructorData{:});
        end

        function obj = convert2Rectangle3D(obj, varargin)
            obj = nurbsRectangle(obj, varargin{:});
        end
        
    end

end


%%
function [origin, dimensions, angle, type, constructorData] = constructorPreprocessor(varargin)

if nargin == 0 || ~isa(varargin{1}, 'numeric')
      origin = [0 0]; dimensions = [1 1];
else origin = varargin{1}; dimensions = varargin{2};
end

if nargin > 2; angle = varargin{3};
else angle = 0;
end
if nargin > 3; type = varargin{4};
else type = 1; end
if nargin > 4; cornerWeightFactor = varargin{5};
else cornerWeightFactor = 10; end

switch type
    case 1
        x = dimensions(1)*[1 -1 -1  1 1]*0.5;
        y = dimensions(2)*[1  1 -1 -1 1]*0.5;
        weights = ones(5, 1);
        uKnotVector = knotVector([0 0 0.25 0.5 0.75 1 1]);

    case 2
        x = dimensions(1)*[1 1 -1 -1 -1 -1  1  1 1]*0.5;
        y = dimensions(2)*[1 1  1  1 -1 -1 -1 -1 1]*0.5;
        weights = ones(9,1);
        uKnotVector = knotVector([0 0 0 0.25 0.25 0.5 0.5 0.75 0.75 1 1 1]);

    case 3
        x = dimensions(1)*[1 1 0 -1 -1 -1  0  1 1]*0.5;
        y = dimensions(2)*[0 1 1  1  0 -1 -1 -1 0]*0.5;
        weights = [1 cornerWeightFactor 1 cornerWeightFactor 1 cornerWeightFactor 1 cornerWeightFactor 1]';
        uKnotVector = knotVector([0 0 0 0.25 0.25 0.5 0.5 0.75 0.75 1 1 1]);
        
end

coords          = cat(2, x', y');
controlPoints   = rationalControlPointsStructure('Cartesian', coords, weights);
constructorData = [{uKnotVector, controlPoints} varargin];

end

function constructorPostprocessor(obj, origin, dimensions, angle, type, varargin)

obj.GeometryProperties.width    = dimensions(1);
obj.GeometryProperties.height   = dimensions(2);
obj.GeometryProperties.angle    = angle;
obj.GeometryProperties.type     = type;

obj.rotateInGCS(angle);
obj.moveInGCS(origin);

end