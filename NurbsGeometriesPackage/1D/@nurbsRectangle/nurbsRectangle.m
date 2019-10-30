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
classdef nurbsRectangle < nurbsPlaneRectangle
    
    methods
        function obj = nurbsRectangle(varargin) % (origin, dimensions, angles) || % (planeCircleObj, origin, angles)
            constructorData = constructorPreprocessor(varargin{:});
            obj@nurbsPlaneRectangle(constructorData{:});
            constructorPostprocessor(obj, varargin{:});
        end
    end
    
end


%%
function constructorData = constructorPreprocessor(varargin)

if nargin == 0
    constructorData = {}; return;    
end

if isa(varargin{1}, 'nurbsPlaneRectangle')
    origin      = varargin{1}.GeometryProperties.LCS_origin;
    dimensions  = [varargin{1}.GeometryProperties.width varargin{1}.GeometryProperties.height];
    angles      = varargin{1}.GeometryProperties.angle;
    type        = varargin{1}.GeometryProperties.type;
    cornerWeightFactor = varargin{1}.ControlPoints.weights(2);

else
    origin      = varargin{1};
    dimensions  = varargin{2};
    if nargin > 2; angles = varargin{3}(3);
    else angles = 0; end
    if nargin > 3; type = varargin{4};
    else type = 1; end
    if nargin > 4; cornerWeightFactor = varargin{5};
    else cornerWeightFactor = 10; end
    
end

constructorData = {origin(1:2), dimensions, angles, type, cornerWeightFactor};

end


%%
function constructorPostprocessor(obj, varargin)

obj.GeometryProperties.angles       = [0 0 obj.GeometryProperties.angle];
if nargin == 1
    obj.GeometryProperties.LCS_origin   = [0 0 0];    
else
    obj.GeometryProperties.LCS_origin   = varargin{1};
    obj.GeometryProperties.dimensions   = varargin{2};
    if nargin > 3; obj.GeometryProperties.angles = varargin{3}; end
end

obj.GeometryProperties = rmfield(obj.GeometryProperties, 'angle');
obj.addNewPhysicalDimension;
obj.GeometryProperties.LCS_Directors = eye(3, 3);

obj.rotateInGCS(obj.GeometryProperties.angles);
obj.moveInGCS(obj.GeometryProperties.LCS_origin);

end