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
classdef nurbsSolidPipe < nurbsSurfaceSweep

    methods
        % Constructors
        function obj = nurbsSolidPipe(varargin) %(origin, outerRadius, thickness, length, angles(optional))
            [origin, outerRadius, thickness, length, angles, constructorData] = constructorPreprocessor(varargin{:});
            obj@nurbsSurfaceSweep(constructorData{:});
            constructorPostprocessor(obj, origin, outerRadius, thickness, length, angles, varargin{:});
        end

    end

end


%%
function [origin, outerRadius, thickness, length, angles, constructorData] = constructorPreprocessor(varargin)

if nargin == 0; origin = [0 0 0]; outerRadius = 1; thickness = 0.2; length = 1; angles = [0 0 0];
else origin = varargin{1}; outerRadius = varargin{2}; thickness = varargin{3}; length = varargin{4};
    if nargin > 4; angles = varargin{5}; end
end

surfaceFrames(1) = nurbsSurfaceDisk([0 0 0], outerRadius, 1, [0 0 0], 2, outerRadius-thickness);
surfaceFrames(1).moveInGCS([0 0 -length/2]);
surfaceFrames(2) = nurbsSurfaceDisk([0 0 0], outerRadius, 1, [0 0 0], 2, outerRadius-thickness);
surfaceFrames(2).moveInGCS([0 0 length/2]);

constructorData = {surfaceFrames knotVector};
                          
end

function constructorPostprocessor(obj, origin, outerRadius, thickness, length, angles, varargin)

obj.GeometryProperties.outerRadius  = outerRadius;
obj.GeometryProperties.thickness    = thickness;
obj.GeometryProperties.length       = length;
obj.rotateInGCS(angles);
obj.moveInGCS(origin);

end