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

classdef (Abstract) nurbsGeometry < nurbs & matlab.mixin.Heterogeneous
    
    properties (SetAccess = protected)
        GeometryProperties
        LCSDirectors
    end
    
    methods
        function obj = nurbsGeometry(varargin)
            obj@nurbs(varargin{:})
            obj.GeometryProperties.LCS_Directors = eye(obj.ControlPoints.numberOfCoordinates, obj.ControlPoints.numberOfCoordinates);
            obj.GeometryProperties.LCS_origin = zeros(1, obj.ControlPoints.numberOfCoordinates);
            obj.LCSDirectors = CSDirectors;
            obj.LCSDirectors.setPosition(obj.GeometryProperties.LCS_origin);
            obj.LCSDirectors.setOrientation(obj.GeometryProperties.LCS_Directors);
        end
        
        findCentroid(obj);
        
        function rotateInLCS(obj, angleValues)
            rotateTransf = affineTransformation(obj.ControlPoints.numberOfCoordinates, 'LCS', obj.GeometryProperties.LCS_origin, obj.GeometryProperties.LCS_Directors);
            rotateTransf.rotation(angleValues);
            rotateTransf.transformNurbsObject(obj);
            obj.GeometryProperties.LCS_Directors = rotateTransf.transformationMatrix(1:obj.ControlPoints.numberOfCoordinates, 1:obj.ControlPoints.numberOfCoordinates);
            obj.LCSDirectors.setOrientation(obj.GeometryProperties.LCS_Directors);
        end
        
        function moveInLCS(obj, displacementVector)
            moveTransf = affineTransformation(obj.ControlPoints.numberOfCoordinates, 'LCS', obj.GeometryProperties.LCS_origin, obj.GeometryProperties.LCS_Directors);
            moveTransf.translation(displacementVector);
            moveTransf.transformNurbsObject(obj);
            obj.GeometryProperties.LCS_origin = obj.GeometryProperties.LCS_origin +rotateTransf.transformationMatrix(1:obj.ControlPoints.numberOfCoordinates, obj.ControlPoints.numberOfCoordinates+1);
            obj.LCSDirectors.setPosition(obj.GeometryProperties.LCS_origin);
        end
        
        function rotateInGCS(obj, angleValues)
            rotateTransf = affineTransformation(obj.ControlPoints.numberOfCoordinates, 'GCS');
            rotateTransf.rotation(angleValues);
            rotateTransf.transformNurbsObject(obj);
            obj.GeometryProperties.LCS_Directors = rotateTransf.transformationMatrix(1:obj.ControlPoints.numberOfCoordinates, 1:obj.ControlPoints.numberOfCoordinates)*obj.GeometryProperties.LCS_Directors;
            obj.LCSDirectors.setOrientation(obj.GeometryProperties.LCS_Directors);
        end
        
        function moveInGCS(obj, displacementVector)
            moveTransf = affineTransformation(obj.ControlPoints.numberOfCoordinates, 'GCS');
            moveTransf.translation(displacementVector);
            moveTransf.transformNurbsObject(obj);
            obj.GeometryProperties.LCS_origin = obj.GeometryProperties.LCS_origin +displacementVector;
            obj.LCSDirectors.setPosition(obj.GeometryProperties.LCS_origin);
        end
        
        function scaleInGCS(obj, scaleFactors)
            moveTransf = affineTransformation(obj.ControlPoints.numberOfCoordinates, 'GCS');
            moveTransf.scale(scaleFactors);
            moveTransf.transformNurbsObject(obj);
%             obj.GeometryProperties.LCS_origin = obj.GeometryProperties.LCS_origin +scaleFactors;
%             obj.LCSDirectors.setPosition(obj.GeometryProperties.LCS_origin);
        end
        
        function showGeometrysLCS(obj)
            obj.LCSDirectors.showDirectors;
            obj.LCSDirectors.showLabels;
        end
        
        function hideGeometryLCS(obj)
            obj.LCSDirectors.hideDirectors;
        end
        
    end
    
end