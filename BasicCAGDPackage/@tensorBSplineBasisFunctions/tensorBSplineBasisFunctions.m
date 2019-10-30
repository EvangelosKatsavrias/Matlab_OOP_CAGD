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

classdef tensorBSplineBasisFunctions < handle & hgsetget & dynamicprops & matlab.mixin.Copyable
    %%
    properties (SetAccess = protected)
        MonoParametricBasisFunctions
        Connectivities
        numberOfParametricCoordinates
        basisFunctionsType
        requestedDerivativesOrder
        tensorBasisFunctions
        numberOfBasisFunctions
        numberOfEvaluationPoints
        SignalSlots
    end
    
    properties (AbortSet)
        ExceptionsData
    end
    
    
    %%
    methods
        function obj = tensorBSplineBasisFunctions(varargin)
            obj.constructorProcesses(varargin{:});
        end
        
        evaluateTensorProducts(obj, varargin);
        plotBiParametricBasisFunctions(obj, varargin);
        controlListeners(obj, varargin);

    end
    
    methods (Access = private)
        constructorProcesses(obj, varargin);
        addDefaultSignalSlots(obj, varargin);
    end
    
    methods (Access = protected)
        handlingEvents(obj, eventData);
    end
    
%     methods (Static)
%         
%     end
    
    
    %%
    events
        basisFunctionsChangeInduced
    end
    
end