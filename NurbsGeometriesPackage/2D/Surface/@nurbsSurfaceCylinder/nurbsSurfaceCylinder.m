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

% NURBS geometry of a surface cylinder
classdef nurbsSurfaceCylinder < nurbsSurfaceSkin
        
    methods
        function obj = nurbsSurfaceCylinder(varargin) % (baseOrigin, radius, length, (angles), (circlesType:1, 2))
            [constructorData, baseOrigin, radius, length, angles] = constructorPreprocessor(varargin{:});
            obj@nurbsSurfaceSkin(constructorData{:});
            constructorPostprocessor(obj, baseOrigin, radius, length, angles);
        end
    end
    
end


%%
function [constructorData, baseOrigin, radius, length, angles] = constructorPreprocessor(varargin)

if nargin == 0
    baseOrigin = [0 0 0]; radius = 1; length = 4;

elseif nargin > 2
    baseOrigin = varargin{1}; radius = varargin{2}; length = varargin{3};

end

if nargin > 3; angles = varargin{4};
else angles = [0 0 0]; end
if nargin > 4; circlesType = varargin{5};
else circlesType = 2; end

circles(1) = nurbsCircle([0 0 0], radius, 0, circlesType);
circles(2) = nurbsCircle([0 0 length], radius, 0, circlesType);

knotVec_V = knotVector([0 0 1 1]);

constructorData = {circles knotVec_V};

end

%%
function constructorPostprocessor(obj, baseOrigin, radius, length, angles)

obj.GeometryProperties.radius = radius;
obj.GeometryProperties.length = length;
obj.rotateInGCS(angles);
obj.moveInGCS(baseOrigin);

end