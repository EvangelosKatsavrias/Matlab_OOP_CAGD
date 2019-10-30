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

% General CAGD Topology Class
classdef CAGDTopology < handle & hgsetget & dynamicprops & matlab.mixin.Copyable
    
    properties (SetAccess = protected, AbortSet)
        KnotVectors
        Connectivities
        BasisFunctions
        TopologyInfo
        ControlPoints
        pointsInPhysicalCoordinates
        parametric2PhysicalJacobians
        parametric2PhysicalDetOfJacobians
        parametric2PhysicalInverseJacobians
        parent2ParametricDetOfJacobians
        parent2PhysicalDetOfJacobians
        topologyGradients
        
        SignalSlots
    end
    
    properties (AbortSet)
        ExceptionsData
    end


    %%
    methods
        function obj = CAGDTopology(varargin)
            constructorProcesses(obj, varargin{:});
        end
        
        evaluateParent2ParametricMappings(obj, varargin);
        evaluateAllParametric2PhysicalMappings(obj, varargin);
        evaluateOnlyPointsInPhysicalDomain(obj, varargin);
        function evaluateAllDomainMappings(obj, varargin)
            obj.evaluateParent2ParametricMappings(varargin{:});
            obj.evaluateAllParametric2PhysicalMappings(varargin{:});
            obj.evaluateParent2PhysicalMappings(varargin{:});
        end
        
        function evaluateParent2PhysicalMappings(obj, varargin)
            obj.parent2PhysicalDetOfJacobians = repmat(obj.parent2ParametricDetOfJacobians, obj.BasisFunctions.numberOfEvaluationPoints, 1).*obj.parametric2PhysicalDetOfJacobians;
        end
        
        function evaluateTopologyGradients(obj, varargin)
            if 0% obj.Connectivities.numberOfParametricCoordinates==1
                obj.topologyGradients = zeros(obj.BasisFunctions.numberOfBasisFunctions, obj.BasisFunctions.numberOfEvaluationPoints, obj.Connectivities.numberOfKnotPatches);
                for functIndex = 1:obj.BasisFunctions.numberOfBasisFunctions
                    obj.topologyGradients(functIndex, :, :) = squeeze(obj.BasisFunctions.tensorBasisFunctions(functIndex, :, 2, :)).*obj.parametric2PhysicalInverseJacobians';
                end
                
            else
                obj.topologyGradients = zeros(obj.BasisFunctions.numberOfBasisFunctions, obj.ControlPoints.numberOfCoordinates, obj.BasisFunctions.numberOfEvaluationPoints, obj.Connectivities.numberOfKnotPatches);
                for knotPatchIndex = 1:obj.Connectivities.numberOfKnotPatches
                    for pointIndex = 1:obj.BasisFunctions.numberOfEvaluationPoints
                        obj.topologyGradients(:, :, pointIndex, knotPatchIndex) = ...
                            squeeze(obj.BasisFunctions.tensorBasisFunctions(:, pointIndex, 2:obj.TopologyInfo.totalNumberOfParametricCoordinates+1, knotPatchIndex))...
                            *obj.parametric2PhysicalInverseJacobians(1:obj.TopologyInfo.totalNumberOfParametricCoordinates, :, pointIndex, knotPatchIndex);
                    end
                end
            end
            
        end
        
        controlListeners(obj, varargin);
    end

    methods(Access = private)
        addDefaultSignalSlots(obj)
        handlingEvents(obj, varargin);
    end

    methods (Access = protected)
        constructorProcesses(obj, varargin);
        constructInformation(obj);
    end
    
    methods (Static)
        data = setExceptionsData;
    end

    
    %%
    events
        notifyCAGDTopologyChanged
    end

end