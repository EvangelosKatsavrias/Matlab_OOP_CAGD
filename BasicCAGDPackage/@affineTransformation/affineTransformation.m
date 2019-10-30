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

classdef affineTransformation < handle & matlab.mixin.Copyable
    
    properties
        typeOfTransformation
        transformationParameters
        numOfCoordinates
        transformationMatrix
        transformationReferenceSystemType = 'GCS';
        transformationReferenceSystemOrigin
        transformationReferenceSystemDirectors
    end
    
    properties (Access = private)
        localRotationMatrix
        localTranslationMatrix
        localTransformationMatix
    end
    
    methods
        function obj = affineTransformation(varargin)
            if nargin == 0
                obj.setReferenceSystem(3, 'GCS');
                obj.transformationMatrix = eye(4, 4);
            elseif nargin > 1 && isa(varargin{1}, 'affineTransformation')
                    obj = varargin{1}.copy;
                    obj.transformationMatrix = varargin{2};
                    obj.typeOfTransformation = 'Mixed';
            else
                obj.setReferenceSystem(varargin{:});
                obj.transformationMatrix = eye(obj.numOfCoordinates+1, obj.numOfCoordinates+1);
            end
        end
        
        setReferenceSystem(obj, systemType, varargin);
        translation(obj, values);
        scale(obj, values);
        shear(obj, values) % (xy, yx, xz, zx, yz, zy)
        rotation(obj, values);
        rotateAroundVector(obj, values, rotationPoint);

        function res = mtimes(leftOperand, rightOperand)
            res = affineTransformation(leftOperand, leftOperand.transformationMatrix*rightOperand.transformationMatrix);
        end
        function plus(varargin)
            throw(MException('affineTransformation:plusOperation', 'The operation is not supported for the objects of class ''affineTransformation''.'));
        end
        
        function pointCoords = transformPoints(obj, pointCoords)
            pointCoords = obj.transformationMatrix(1:3, :)*[pointCoords; ones(1, size(pointCoords, 2))];
        end
        
        function nurbsObj = transformNurbsObject(obj, nurbsObj)
            nurbsObj.ControlPoints.convertTypeOfCoordinates('Homogeneous');
            nurbsObj.ControlPoints.setAllControlPoints((obj.transformationMatrix*nurbsObj.ControlPoints.getAllControlPoints('sequenced')')');
        end

    end

    methods (Access = private)
        function localTransformation(obj)
            if strcmp(obj.transformationReferenceSystemType, 'LCS')
                obj.transformationMatrix = obj.localTransformationMatix*obj.transformationMatrix*obj.localTransformationMatix^-1;
            end
        end
    end
    
    methods(Static)
        transformationMatrix = homogeneousTranslationMatrix(values);
        transformationMatrix = homogeneousScaleMatrix(values);
        transformationMatrix = homogeneousShearMatrix(values);
        transformationMatrix = homogeneousRotationMatrix(values);
    end
    
    events
        notifyNurbsObjectAffineTransformationInduced
    end
end