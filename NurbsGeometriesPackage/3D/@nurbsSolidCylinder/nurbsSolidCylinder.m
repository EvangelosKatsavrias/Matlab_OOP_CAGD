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

% NURBS geometry of a solid cube
classdef nurbsSolidCylinder < nurbsSurfaceSweep

    methods
        % Constructors
        function obj = nurbsSolidCylinder(varargin)
            [origin, radius, height, angles, constructorData] = constructorPreprocessor(varargin{:});
            obj@nurbsSurfaceSweep(constructorData{:});
            constructorPostprocessor(obj, origin, radius, height, angles, constructorData{:});
        end

    end

end


%%
function [origin, radius, height, angles, constructorData] = constructorPreprocessor(varargin)

if nargin == 0; origin = [0 0 0]; radius = 1; height = 1; angles = [0 0 0];
else origin = varargin{1}; radius = varargin{2}; height = varargin{3};
    if nargin > 3; angles = varargin{4}; end
end

surfaceFrames(1) = nurbsSurfaceDisk([0 0 0], radius);
surfaceFrames(1).moveInGCS([0 0 -height/2]);
surfaceFrames(2) = nurbsSurfaceDisk([0 0 0], radius);
surfaceFrames(2).moveInGCS([0 0 height/2]);

constructorData = [{surfaceFrames knotVector}, varargin];
                          
end

function constructorPostprocessor(obj, origin, radius, height, angles, varargin)

obj.GeometryProperties.radius   = radius;
obj.GeometryProperties.height   = height;
obj.rotateInGCS(angles);
obj.moveInGCS(origin);

end