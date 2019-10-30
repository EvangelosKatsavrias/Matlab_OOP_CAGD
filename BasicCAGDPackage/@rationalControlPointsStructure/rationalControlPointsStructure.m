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

classdef rationalControlPointsStructure < controlPointsStructure

    properties (SetAccess = private)
        weights
        typeOfCoordinates
    end

    methods
        function obj = rationalControlPointsStructure(varargin)
            varargin = constructorPreprocessor(varargin{:});
            obj@controlPointsStructure(varargin{2:end});
            obj.constructorPostprocessor(varargin{:});
        end
        
        varargin = constructorPreprocessor(varargin);
        constructorPostprocessor(obj, constr, varargin);
        convertTypeOfCoordinates(obj, varargin);
        
        controlPoints = getAllControlPoints(obj, varargin);
        controlPoints = getControlPoints(obj, controlPointsIndices);
        weights = getAllWeights(obj, varargin);
        weights = getControlPointsWeights(obj, controlPointsIndices);
        
        setNewControlPoints(obj, coordsType, newControlPoints, varargin);
        setAllControlPoints(obj, controlPointsNewCoordsNWeights, varargin);
        setControlPoints(obj, controlPointsIndices, controlPointsNewCoordsNWeights, varargin);
        setAllWeights(obj, newWeights, varargin);
        setControlPointsWeights(obj, controlPointsIndices, newWeights, varargin);
        
    end
    
    
    methods (Static)
        [coordinates, weights] = homogeneousArraySplitter(controlPointsInHomogeneous);
        [newControlPoints, varargout] = checkRationalControlPointsInputValidity(coordsType, newControlPoints, varargin);
    end
    
    events
        notifyAllControlPointsWeightsChanged
        notifyPartOfControlPointsWeightsChanged
    end
    
end


%%  
function varargin = constructorPreprocessor(varargin)

if nargin == 0
    return;
elseif nargin == 2
    [varargin{2}, varargin{3}] = rationalControlPointsStructure.checkRationalControlPointsInputValidity(varargin{:});
else
    varargin{2} = rationalControlPointsStructure.checkRationalControlPointsInputValidity(varargin{:});
end

end