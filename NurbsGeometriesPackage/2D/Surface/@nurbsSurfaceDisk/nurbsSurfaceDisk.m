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

classdef nurbsSurfaceDisk < nurbsSurfaceSkin

    methods
        function obj = nurbsSurfaceDisk(varargin) % (origin, outerRadius, thickness(optional), angles(optional), circleType(optional), innerRadius(optional))
            [constructorData, angles] = constructorPreprocessor(varargin{:});
            obj@nurbsSurfaceSkin(constructorData{:});
            constructorPostprocessor(obj, angles, varargin{:});
        end
    end
    
end


%%
function [constructorData, angles] = constructorPreprocessor(varargin)

origin = [0 0 0]; outerRadius = 1; innerRadius = 0.001; circleType = 2; angles = [0 0 0];
if nargin == 0
else
    origin = varargin{1}; outerRadius = varargin{2};
    if nargin > 3; angles = varargin{4}; end
    if nargin > 4; circleType = varargin{5}; end
    if nargin > 5; innerRadius = varargin{6}; end
    
end

frameCircles(1) = nurbsCircle(origin, innerRadius, [0 0 0], circleType);
frameCircles(2) = nurbsCircle(origin, outerRadius, [0 0 0], circleType);

VKnotVector     = knotVector([0 0 1 1]);
constructorData = {frameCircles, VKnotVector};

end


%%
function constructorPostprocessor(obj, angles, varargin)

if length(varargin) > 2; obj.GeometryProperties.thickness = varargin{3};
else obj.GeometryProperties.thickness = 1;
end
obj.GeometryProperties.outerRadius = obj.GeometryProperties.FrameNurbsObjects(1).GeometryProperties.radius;
obj.GeometryProperties.innerRadius = obj.GeometryProperties.FrameNurbsObjects(2).GeometryProperties.radius;
obj.rotateInGCS(angles);

end