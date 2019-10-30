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

function stackedData = preprocessor(obj, varargin)


% geometry points
closureTopologyIndex = obj.requestClosureTopology([settings_u_geom, settings_v_geom, settings_w_geom]);
obj.ClosureTopologies(closureTopologyIndex).evaluateOnlyPointsInPhysicalDomain;
obj.PlotProperties.PlotData(stackedData).Closure.pointsStackedData = closureTopologyIndex;

% points of covariants evaluations
if obj.PlotProperties.PlotSettings.Derivatives.visualizationSwitch
    derivClosureIndex = obj.addClosureTopology([settings_u_deriv, settings_v_deriv, settings_w_deriv]);
    obj.ClosureTopologies(derivClosureIndex).evaluateAllDomainMappings;
    obj.PlotProperties.PlotData(stackedData).Closure.jacobiansStackedData = derivClosureIndex;
end

if obj.PlotProperties.PlotSettings.Knots.Lines.visualizationSwitch
    % u-v knot lines
    knotLinesTopologyIndex_w = obj.addClosureTopology([settings_u_knotLines settings_v_knotLines settings_w_geom]); %[obj.ClosureTopologies(obj.PlotProperties.PlotData(stackedData).Closure.jacobiansStackedData).MonoParametricBasisFunctions(1) obj.ClosureTopologies(obj.PlotProperties.PlotData(stackedData).Closure.pointsStackedData).MonoParametricBasisFunctions(2).evaluationPoints]
    obj.ClosureTopologies(knotLinesTopologyIndex_w).evaluateOnlyPointsInPhysicalDomain;
    obj.PlotProperties.PlotData(stackedData).Closure.uknotLinesStackedData = knotLinesTopologyIndex_w;
    
    % u-w knot lines
    knotLinesTopologyIndex_v = obj.addClosureTopology([settings_u_knotLines settings_v_geom settings_w_knotLines]); %[obj.ClosureTopologies(obj.PlotProperties.PlotData(stackedData).Closure.jacobiansStackedData).MonoParametricBasisFunctions(1) obj.ClosureTopologies(obj.PlotProperties.PlotData(stackedData).Closure.pointsStackedData).MonoParametricBasisFunctions(2).evaluationPoints]
    obj.ClosureTopologies(knotLinesTopologyIndex_v).evaluateOnlyPointsInPhysicalDomain;
    obj.PlotProperties.PlotData(stackedData).Closure.vknotLinesStackedData = knotLinesTopologyIndex_v;
    
    % v-w knot lines
    knotLinesTopologyIndex_u = obj.addClosureTopology([settings_u_geom settings_v_knotLines settings_w_knotLines]); %[obj.ClosureTopologies(obj.PlotProperties.PlotData(stackedData).Closure.jacobiansStackedData).MonoParametricBasisFunctions(1) obj.ClosureTopologies(obj.PlotProperties.PlotData(stackedData).Closure.pointsStackedData).MonoParametricBasisFunctions(2).evaluationPoints]
    obj.ClosureTopologies(knotLinesTopologyIndex_u).evaluateOnlyPointsInPhysicalDomain;
    obj.PlotProperties.PlotData(stackedData).Closure.uknotLinesStackedData = knotLinesTopologyIndex_u;
end

% knot points
if obj.PlotProperties.PlotSettings.Knots.Markers.visualizationSwitch
    knotsTopologyIndex = obj.addClosureTopology([settings_u_knots settings_v_knots settings_w_knots]);
    obj.ClosureTopologies(knotsTopologyIndex).evaluateOnlyPointsInPhysicalDomain;
    obj.PlotProperties.PlotData(stackedData).Closure.knotPointsStackedData = knotsTopologyIndex;
end

obj.PlotProperties.PlotData(stackedData).Closure.points = reshape(permute(obj.ClosureTopologies(obj.PlotProperties.PlotData(stackedData).Closure.pointsStackedData).DomainMappings.pointsInPhysicalCoordinates, [2 1 3]), ...
    obj.ClosureTopologies(obj.PlotProperties.PlotData(stackedData).Closure.pointsStackedData).BasisFunctions.MonoParametricBasisFunctions(1).numberOfEvaluationPointsPerKnotPatch, ...
    obj.ClosureTopologies(obj.PlotProperties.PlotData(stackedData).Closure.pointsStackedData).BasisFunctions.MonoParametricBasisFunctions(2).numberOfEvaluationPointsPerKnotPatch, ...
    obj.ClosureTopologies(obj.PlotProperties.PlotData(stackedData).Closure.pointsStackedData).BasisFunctions.MonoParametricBasisFunctions(3).numberOfEvaluationPointsPerKnotPatch, ...
    obj.ControlPoints.numberOfCoordinates, obj.ClosureTopologies(obj.PlotProperties.PlotData(stackedData).Closure.pointsStackedData).Connectivities.numberOfKnotPatches);

if obj.PlotProperties.PlotSettings.Knots.Markers.visualizationSwitch
    obj.PlotProperties.PlotData(stackedData).Closure.knotPoints             = [obj.ClosureTopologies(obj.PlotProperties.PlotData(stackedData).Closure.knotPointsStackedData).DomainMappings.pointsInPhysicalCoordinates{:}];
end

if obj.PlotProperties.PlotSettings.Knots.Lines.visualizationSwitch
    obj.PlotProperties.PlotData(stackedData).Closure.vKnotLines             = reshape(permute(reshape(obj.ClosureTopologies(obj.PlotProperties.PlotData(stackedData).Closure.vknotLinesStackedData).DomainMappings.pointsInPhysicalCoordinates, 3, 2, [], 2, obj.TopologiesInfo.Connectivities.numberOfKnotPatches), [1 2 4 3 5]), 3, 4, [], obj.TopologiesInfo.Connectivities.numberOfKnotPatches); %reshape(permute(obj.ClosureTopologies(knotLineStackedDataNumber1).DomainMappings.pointsInPhysicalCoordinates, [2 3 1]), 2, length(vKnotPatchPoints), 2)
    obj.PlotProperties.PlotData(stackedData).Closure.uKnotLines             = reshape(obj.ClosureTopologies(obj.PlotProperties.PlotData(stackedData).Closure.uknotLinesStackedData).DomainMappings.pointsInPhysicalCoordinates, 3, 4, [], obj.TopologiesInfo.Connectivities.numberOfKnotPatches); %reshape(permute(obj.ClosureTopologies(knotLineStackedDataNumber1).DomainMappings.pointsInPhysicalCoordinates, [2 3 1]), 2, length(vKnotPatchPoints), 2)
    obj.PlotProperties.PlotData(stackedData).Closure.wKnotLines             = reshape(obj.ClosureTopologies(obj.PlotProperties.PlotData(stackedData).Closure.wknotLinesStackedData).DomainMappings.pointsInPhysicalCoordinates, 3, [], 4, obj.TopologiesInfo.Connectivities.numberOfKnotPatches); %reshape(permute(obj.ClosureTopologies(knotLineStackedDataNumber1).DomainMappings.pointsInPhysicalCoordinates, [2 3 1]), 2, length(vKnotPatchPoints), 2)
end

if obj.PlotProperties.PlotSettings.Derivatives.visualizationSwitch
    obj.PlotProperties.PlotData(stackedData).Closure.jacobianPoints         = reshape(obj.ClosureTopologies(obj.PlotProperties.PlotData(stackedData).Closure.jacobiansStackedData).DomainMappings.pointsInPhysicalCoordinates, 3, []);
    obj.PlotProperties.PlotData(stackedData).Closure.jacobianCovariants     = permute(reshape(obj.ClosureTopologies(obj.PlotProperties.PlotData(stackedData).Closure.jacobiansStackedData).DomainMappings.parametric2PhysicalJacobians, 3, 3, []), [3 1 2]);
end

end