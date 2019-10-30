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
classdef nurbsSurfaceSkin < nurbsGeometry

    methods
        function obj = nurbsSurfaceSkin(varargin)
            constructorData = constructorPreprocessor(varargin{:});
            obj@nurbsGeometry(constructorData{1:2});
            constructorPostprocessor(obj, constructorData{:}, varargin{1});
        end
        
    end
    
    methods (Access = private)
        handlingEvents(obj, varargin);
        addDefaultSignalSlots(obj);
    end
    
    methods (Static)
        function [controlPoints, knotVectors] = constructSkinSurface(nurbs_1DFrameObjects, knotVector_V)
            coords = nurbs_1DFrameObjects(1).ControlPoints.coordinates;
            weights = nurbs_1DFrameObjects(1).ControlPoints.weights;
            for frameIndex = 2:length(nurbs_1DFrameObjects)
                coords = cat(3, coords, nurbs_1DFrameObjects(frameIndex).ControlPoints.coordinates);
                weights = cat(2, weights, nurbs_1DFrameObjects(frameIndex).ControlPoints.weights);
            end
            coords = permute(coords, [1 3 2]);
            
            controlPoints   = rationalControlPointsStructure(nurbs_1DFrameObjects(1).ControlPoints.typeOfCoordinates, coords, weights);
            knotVectors     = [nurbs_1DFrameObjects(1).KnotVectors knotVector_V];

        end
        
    end
    
    events
        
    end
    
end


%%
function constructorData = constructorPreprocessor(varargin)

[constructorData{2}, constructorData{1}] = nurbsSurfaceSkin.constructSkinSurface(varargin{:});

end

function constructorPostprocessor(obj, varargin)

obj.GeometryProperties.FrameNurbsObjects = varargin{3};
obj.addDefaultSignalSlots;

end