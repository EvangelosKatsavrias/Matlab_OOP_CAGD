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

classdef bSplineBasisFunctions < handle & hgsetget & dynamicprops & matlab.mixin.Copyable
%%
    properties (SetAccess = protected)
        KnotVector
        degree
        EvaluationSettings
        evaluationPoints
        evaluationPointsPerFunction
        evaluationsPerKnotPatch
        evaluationsPerFunction
        evaluatedBasisFunctions
        numberOfEvaluatedKnotPatches
        numberOfEvaluatedBasisFunctions
        numberOfEvaluationPointsPerKnotPatch
        numberOfEvaluationPointsPerFunction
        totalNumberOfEvaluationPoints
        parent2ParametricJacobians
        evaluatedKnotPatches2KnotPatchesInStructure
        evaluatedFunctions2FunctionsInStructure
        SignalSlots
    end
    
    properties (AbortSet)
        ExceptionsData
    end


%%   
    methods
        function obj = bSplineBasisFunctions(varargin)
            constructorProcesses(obj, varargin{:});
        end
        
        varargout = evaluateInSingleKnotPatch(obj, varargin);
        evaluatePerKnotPatch(obj, varargin);
        evaluatePerFunction(obj, varargin);        
        refreshData(obj, varargin);

        plotBasisFunctions(obj, varargin);
        clearPlots(obj, varargin);

        controlListeners(obj, varargin);
    end

    methods (Access = private)
        constructInformation(obj);
        addDefaultSignalSlots(obj);
        handlingEvents(obj, eventData);
        constructorProcesses(obj, varargin);
    end
    
    methods (Static)
        data = setExceptionsData;
    end
    
%%
    events
        localChangeOfBasisFunctionsInduced
        changeOfBasisFunctionsInduced
    end

end