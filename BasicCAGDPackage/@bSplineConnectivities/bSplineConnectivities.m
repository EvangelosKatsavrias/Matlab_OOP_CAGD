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

classdef bSplineConnectivities < handle & hgsetget & dynamicprops & matlab.mixin.Copyable
    
    properties (SetAccess = private)
        KnotVectors
        order
        degree
        numberOfParametricCoordinates
        numberOfMonoParametricBasisFunctions
        numberOfKnotPatches
        numberOfFunctionsPerKnotPatch
        numberOfFunctionsInBSplinePatch
        controlPointsCountingSequenceType
        controlPointsCountingSequence
        knotPatch2Knots
        knotPatch2MultiParametricFunctions
        vertexBoundaries2Closure
        edgeBoundaries2Closure
        faceBoundaries2Closure
        SignalSlots
        ExceptionsData
    end
    
    %%
    methods
        function obj = bSplineConnectivities(varargin)
            obj.constructorProcesses(varargin{:});
        end
        defaultConnectivities(obj, varargin);
        connectivitiesKnotPatches2Knots(obj, varargin);
        connectivitiesKnotPatches2MultiParametricFunctions(obj, varargin);
        connectivitiesBoundaries2Closure(obj, varargin);
        controlListeners(obj, varargin);
        constructInformation(obj, varargin);
    end
    
    methods (Access = private)
        constructorProcesses(obj, varargin);
        addDefaultSignalSlots(obj, varargin);
        handlingEvents(obj, eventData);
        refreshData(obj, varargin);
    end
    
    
    %%
    events
        connectivitiesDataChangeInduced
    end
    
end