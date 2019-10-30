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

classdef nurbsSurfacePlateWithHole < nurbsSurfaceSkin

    methods
        function obj = nurbsSurfacePlateWithHole(varargin)
            constructorData = constructorPreprocessor(varargin{:});
            obj@nurbsSurfaceSkin(constructorData{:});
            constructorPostprocessor(obj, varargin{:});
        end
    end
    
end


%%
function constructorData = constructorPreprocessor(varargin)

origin = [0 0 0]; dimensions = [2 2]; innerRadius = 0.5; rectType = 2; circleType = 2;
if nargin == 0
else
    origin = varargin{1}; dimensions = varargin{2};
    if nargin > 3; circleType = varargin{4}; end
    if nargin > 4; innerRadius = varargin{5}; end
end

frameNurbs(1) = nurbsRectangle(origin, dimensions, [0 0 0], rectType);
frameNurbs(2) = nurbsCircle(origin, innerRadius, [0 0 pi/4], circleType);

VKnotVector     = knotVector([0 0 1 1]);
constructorData = {frameNurbs, VKnotVector};

end


%%
function constructorPostprocessor(obj, varargin)

if length(varargin) > 2; obj.GeometryProperties.thickness = varargin{3};
else obj.GeometryProperties.thickness = 1;
end
obj.GeometryProperties.width        = obj.GeometryProperties.FrameNurbsObjects(1).GeometryProperties.width;
obj.GeometryProperties.height       = obj.GeometryProperties.FrameNurbsObjects(1).GeometryProperties.height;
obj.GeometryProperties.holeRadius   = obj.GeometryProperties.FrameNurbsObjects(2).GeometryProperties.radius;

end