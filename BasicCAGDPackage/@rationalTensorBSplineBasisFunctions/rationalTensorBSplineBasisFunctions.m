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

classdef rationalTensorBSplineBasisFunctions < tensorBSplineBasisFunctions
    properties
        rationalControlPoints
    end
    
    %%
    methods
        function obj = rationalTensorBSplineBasisFunctions(varargin)
            obj@tensorBSplineBasisFunctions(varargin{:});
            obj = constructorPostProcesses(obj, varargin{:});
        end
        
    end
    
    methods (Access = private)
        function addDefaultSignalSlots(obj)
            obj.SignalSlots.ControlPoints.allWeightsChanged             = addlistener(obj.rationalControlPoints, 'notifyAllControlPointsWeightsChanged',       @(src, eventData)obj.handlingEvents(eventData));
            obj.SignalSlots.ControlPoints.partOfWeightsChanged          = addlistener(obj.rationalControlPoints, 'notifyPartOfControlPointsWeightsChanged',    @(src, eventData)obj.handlingEvents(eventData));
            obj.SignalSlots.ControlPoints.allControlPointsChanged       = addlistener(obj.rationalControlPoints, 'notifyPartOfControlPointsResetted',          @(src, eventData)obj.handlingEvents(eventData));
            obj.SignalSlots.ControlPoints.partOfControlPointsChanged    = addlistener(obj.rationalControlPoints, 'notifyAllControlPointsResetted',             @(src, eventData)obj.handlingEvents(eventData));
        end
        
    end
        
    
end


%%
function obj = constructorPostProcesses(obj, varargin)

obj.basisFunctionsType = 'NURBS';

if nargin > 3
    if isa(varargin{3}, 'rationalControlPointsStructure')
        if varargin{3}.numberOfParametricCoordinates == obj.numberOfParametricCoordinates || (isvector(varargin{3}.weights) && obj.numberOfParametricCoordinates==1)
            obj.rationalControlPoints = varargin{3};
        else throw(MException(obj.ExceptionsData.msgID, 'Wrong input data, the given weights array is not consistent with the number of parametric coordinates of the given basis functions.'));
        end
    elseif isnumeric(varargin{3})
        if ndims(varargin{3}) == obj.numberOfParametricCoordinates || (isvector(varargin{3}) && obj.numberOfParametricCoordinates==1)
            obj.rationalControlPoints = rationalControlPointsStructure('Cartesian', cat(obj.numberOfParametricCoordinates+1, ones([obj.Connectivities.numberOfMonoParametricBasisFunctions, obj.Connectivities.numberOfParametricCoordinates]), varargin{3}));
        else throw(MException(obj.ExceptionsData.msgID, 'Wrong input data, the given weights array is not consistent with the number of parametric coordinates of the given basis functions.'));
        end
    end
else
    obj.rationalControlPoints = rationalControlPointsStructure('Cartesian', ones([obj.Connectivities.numberOfMonoParametricBasisFunctions, obj.Connectivities.numberOfParametricCoordinates+1]));
end

obj.addDefaultSignalSlots;

end