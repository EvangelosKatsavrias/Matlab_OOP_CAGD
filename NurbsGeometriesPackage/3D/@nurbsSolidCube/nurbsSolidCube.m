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
classdef nurbsSolidCube < nurbsSurfaceSweep

    methods
        % Constructors
        function obj = nurbsSolidCube(varargin)
            [origin, length, width, height, angles, constructorData] = constructorPreprocessor(varargin{:});
            obj@nurbsSurfaceSweep(constructorData{1:2});
            constructorPostprocessor(obj, origin, length, width, height, angles, constructorData{:});
        end
    end

end


%%
function [origin, length, width, height, angles, constructorData] = constructorPreprocessor(varargin)

if nargin == 0; origin = [0 0 0]; length = 1; width = 1; height = 1; angles = [0 0 0];
else origin = varargin{1}; length = varargin{2}(1); width = varargin{2}(2); height = varargin{2}(3);
    if nargin > 2; angles = varargin{3}; end
end

dx = length; dy = width; dz = height;

surfaceFrames(1) = nurbsRectangular3DPlane([0 0 0], [dx, dy], [0 0 0]);
surfaceFrames(1).moveInGCS([0 0 -dz/2]);
surfaceFrames(2) = nurbsRectangular3DPlane([0 0 0], [dx, dy], [0 0 0]);
surfaceFrames(2).moveInGCS([0 0 dz/2]);

constructorData = [{surfaceFrames knotVector}, varargin];
                          
end

function constructorPostprocessor(obj, origin, length, width, height, angles, varargin)

obj.GeometryProperties.length   = length;
obj.GeometryProperties.width    = width;
obj.GeometryProperties.height   = height;
obj.rotateInGCS(angles);
obj.moveInGCS(origin);

end