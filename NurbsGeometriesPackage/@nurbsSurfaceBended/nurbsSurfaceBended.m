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

% NURBS geometry
classdef nurbsSurfaceBended < nurbsSurfaceSkin

    methods
        function obj = nurbsSurfaceBended(varargin)
            [constructorData, bendRadius, bendArcAngle] = constructorPreprocessor(varargin{:});
            obj@nurbsSurfaceSkin(constructorData{:});
            constructorPostprocessor(obj, bendRadius, bendArcAngle, constructorData{:});            
        end
        
        function obj = rebendSurface(obj, newBendAngle)
            obj.GeometryProperties.FrameNurbsObjects(2:3) = nurbsSurfaceBended.bendProcessInXZPlane(obj.GeometryProperties.FrameNurbsObjects(2:3), newBendAngle);
        end
        
    end
    
    methods (Static)
        function frameObjects = bendProcessInXZPlane(frameObjects, bendArcAngle)
            shearTransformation = affineTransformation;
            shearTransformation.shear([0 0 tan(bendArcAngle/2) 0 0 0]);
            shearTransformation.transformNurbsObject(frameObjects(1));
            frameObjects(1).ControlPoints.setAllWeights(cos(bendArcAngle/2)*frameObjects(1).ControlPoints.getAllWeights);

            frameObjects(2).rotateInGCS([0 bendArcAngle 0]);
        end

    end
    
end


%%
function [constructorData, bendRadius, bendArcAngle] = constructorPreprocessor(varargin)

if nargin == 0
    bendRadius          = 1;
    bendArcAngle        = pi/2;
    frameGeometries(1)  = nurbsCircle([0 0 0], 1, [0 0 0], 4);
    frameGeometries(2)  = nurbsCircle([0 0 0], 1, [0 0 0], 4);
    frameGeometries(3)  = nurbsCircle([0 0 0], 1, [0 0 0], 4);

else
    frameGeometries = varargin{1};
    bendRadius      = varargin{2};
    bendArcAngle    = varargin{3};    

end

frameGeometries(1).rotateInGCS([0 -pi/2 0]);
frameGeometries(1).moveInGCS([bendRadius 0 0]);

frameGeometries(2).rotateInGCS([0 -pi/2 0]);

frameGeometries(3).rotateInGCS([0 -pi/2 0]);
frameGeometries(3).moveInGCS([-bendRadius 0 0]);

frameGeometries(2:3) = nurbsSurfaceBended.bendProcessInXZPlane(frameGeometries(2:3), bendArcAngle);

knotVect = knotVector([0 0 0 1 1 1]);

constructorData = {frameGeometries, knotVect};

end

%%
function constructorPostprocessor(obj, bendRadius, bendArcAngle, varargin)

obj.GeometryProperties.bendArcAngle = bendArcAngle;
obj.GeometryProperties.bendRadius = bendRadius;

end