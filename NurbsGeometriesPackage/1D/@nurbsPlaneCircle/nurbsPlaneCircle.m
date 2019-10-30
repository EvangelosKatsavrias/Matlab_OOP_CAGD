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
classdef nurbsPlaneCircle < joinNurbs

    methods
        function obj = nurbsPlaneCircle(varargin) %(origin, radius, rotationAngleInPlane, circleType)
            [origin, radius, numberOfArcSegments, angle, constructorData] = constructorPreprocessor(varargin{:});
            obj@joinNurbs(constructorData{:});
            constructorPostprocessor(obj, origin, radius, numberOfArcSegments, angle, constructorData{:});
        end

        function obj = convert2Circle3D(obj, varargin)
            obj = nurbsCircle(obj, varargin{:});
        end

    end

end


%%
function [origin, radius, numberOfArcSegments, angle, constructorData] = constructorPreprocessor(varargin)

if nargin == 0; origin = [0 0]; radius = 1; angle = 0; numberOfArcSegments = 3;
else origin = varargin{1}; radius = varargin{2};
    if nargin > 2; angle = varargin{3}; else angle = 0; end
    if nargin > 3; numberOfArcSegments = varargin{4}; else numberOfArcSegments = 3; end
end

dtheta = 2*pi/numberOfArcSegments;
segments = nurbsCircularArc.empty(1, 0);
for segmentIndex = 1:numberOfArcSegments
    segments(segmentIndex) = nurbsCircularArc([0 0], radius, dtheta, (segmentIndex-1)*dtheta);
end

constructorData = {segments};

end

function constructorPostprocessor(obj, origin, radius, numberOfArcSegments, angle, varargin)

obj.GeometryProperties.radius = radius;
obj.GeometryProperties.angle = angle;
obj.GeometryProperties.numberOfArcSegments = numberOfArcSegments;

obj.rotateInGCS(angle);
obj.moveInGCS(origin);

end