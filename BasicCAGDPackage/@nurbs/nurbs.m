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

% General NURBS Class
classdef nurbs < handle & hgsetget & dynamicprops & matlab.mixin.Copyable
    
    properties (SetAccess = private)
        GeneralInfo
        TopologiesInfo
    end
    
    properties (SetAccess = protected)
        KnotVectors
        Connectivities
        ControlPoints
        MonoParametricBasisFunctions
        ClosureTopologies
        InteriorTopologies
        BoundaryTopologies
    end
    
    properties
        SignalSlots
    end
    
    properties (AbortSet)
        ExceptionsData
    end

    
    %%
    methods
        function obj = nurbs(varargin)
            constructorProcesses(obj, varargin{:});
        end
        
        knotRefinement(obj, varargin);
        degreeRefinement(obj, varargin);
        stackedFunctions = addMonoParametricBasisFunctions(obj, varargin);
        numberOfStackedClosure = addClosureTopology(obj, varargin);
        addInteriorTopology(obj, varargin);
        numberOfStackedBoundaryTopology = addBoundaryTopology(obj, varargin);
        
        relativeKnotVectors = findBoundaryRelativeKnotVectors(obj, boundaryType, boundaryNumber, varargin);
        relativeControlPoints = findRelativeControlPoints(obj, boundaryType, boundaryNumber);
        relevantStackedBasisFunctions = requestBasisFunctions(obj, relevantParametricCoordinate, EvaluationSettings, varargin);
        relevantStackedClosureTopology = requestClosureTopology(obj, EvaluationSettings, varargin);
        
        addNewPhysicalDimension(obj, varargin);
        removePhysicalDimension(obj, varargin);

    end
    
    methods (Access = private)
        constructorProcesses(obj, varargin);
        constructInformation(obj);
        addDefaultSignalSlots(obj);
        handlingEvents(obj, eventData);
    end
    
    methods (Static)
        data = setExceptionsData;
    end

    
    %%
    events
    end

end