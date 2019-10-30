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

function handlingEvents(obj, eventData)

try
    
    refinementEvents(obj, eventData);
    
catch Exception
    throw(Exception);
end

end


%%  
function refinementEvents(obj, eventData)
    

switch eventData.EventName
%     case 'connectivitiesDataChangeInduced'
%         obj.findBoundaryControlPointsInClosure;
    case 'localKnotRefinementTensorBSplinesNotification'
    case 'globalKnotRefinementTensorBSplinesNotification'
        
end

obj.ClosureConnectivities.constructInformation('Connectivities', {'Boundaries2Closure'});
obj.findBoundaryControlPointsInClosure;
if ~isempty(obj.Connectivities)
    obj.Connectivities = bSplineConnectivities(obj.KnotVectors);
    obj.constructInformation;
end
obj.BasisFunctions = tensorBSplineBasisFunctions('NURBS', obj.MonoParametricBasisFunctions, 'DerivativesOrder', obj.TopologyInfo.derivativesOrder, 'Evaluate', 'Weights', obj.controlPointsWeights, 'Connectivities', obj.Connectivities);
obj.BasisFunctions.controlListeners('Disable');
if ~isempty(obj.DomainMappings)
    if isfield(obj.DomainMappings, 'parametric2PhysicalJacobians'); obj.evaluateDomainMappings; else obj.evaluatePointCoordinates; end
end
end