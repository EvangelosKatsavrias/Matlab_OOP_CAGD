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

classdef nurbs2DRectangularDomainWithHemisphereBottom < nurbsSurfaceSkin
    methods
        function obj = nurbs2DRectangularDomainWithHemisphereBottom(varargin)
            if nargin == 0; origin = [0 0]; width = 4; height = 3; bottomRadius = 0.5;
            else origin = varargin{1}; width = varargin{2}(1); height = varargin{2}(2); bottomRadius = varargin{3};
            end
            
            bottomLeftLine = nurbsCurveLine([-width/2 0; -width*3/8 0; -bottomRadius 0], [1 1 1]', 2);
            bottomLeftArc = nurbsCircularArc([0 0], bottomRadius, -pi/2, pi);
            bottomRightArc = nurbsCircularArc([0 0], bottomRadius, -pi/2, pi/2);
            bottomRightLine = nurbsCurveLine([bottomRadius 0; width*3/8 0; width/2 0], [1 1 1]', 2);
            
            bottomBoundary  = joinNurbs([bottomLeftLine bottomLeftArc bottomRightArc bottomRightLine]);
            h2              = bottomRadius+(height-bottomRadius)/2;
            middleLine      = nurbsCurveLine([-width/2 h2;-width*3/8 h2;-width/4 h2;-width/8 h2; 0 h2; width/8 h2; width/4 h2; width*3/8 h2; width/2 h2], [1 1 1 1 1 1 1 1 1]', 2);
            topBoundary     = nurbsCurveLine([-width/2 height;-width*3/8 height;-width/4 height;-width/8 height; 0 height; width/8 height; width/4 height; width*3/8 height; width/2 height], [1 1 1 1 1 1 1 1 1]', 2);
            
            obj@nurbsSurfaceSkin([bottomBoundary middleLine topBoundary], knotVector([0 0 0 1 1 1]));
            
            obj.moveInGCS(origin);
            
        end
        
    end
    
end