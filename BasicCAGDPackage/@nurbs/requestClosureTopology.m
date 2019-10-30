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

function relevantStackedClosureTopology = requestClosureTopology(obj, EvaluationSettings, varargin)

if nargin < 2 || ~isa(EvaluationSettings, 'bSplineBasisFunctionsEvaluationSettings')
    throw(MException('nurbs:requestClosureTopology', 'Provide the required ''bSplineBasisFunctionsEvaluationSettings'' objects as first argument.'));
end

for topologyIndex = 1:length(obj.ClosureTopologies)
    checkVec = zeros(1, obj.GeneralInfo.totalNumberOfParametricCoordinates);
    
    for parameterIndex = 1:obj.GeneralInfo.totalNumberOfParametricCoordinates
        
        if isequal(EvaluationSettings(parameterIndex), obj.ClosureTopologies(topologyIndex).BasisFunctions.MonoParametricBasisFunctions(parameterIndex).EvaluationSettings)
            checkVec(parameterIndex) = 1;
        end
        
    end
    
    if all(checkVec)
        relevantStackedClosureTopology = topologyIndex;
        return
    end
end

relevantStackedClosureTopology = obj.addClosureTopology(EvaluationSettings);

end


% (strcmp(EvaluationSettings(parameterIndex).requestedPointsPattern, currentSettings.requestedPointsPattern) && ...
%             ~any(EvaluationSettings(parameterIndex).requestedPoints ~= currentSettings.requestedPoints) && ...
%             EvaluationSettings(parameterIndex).requestedDerivativesOrder == currentSettings.requestedDerivativesOrder && ...
%             ~any(EvaluationSettings(parameterIndex).requestedEvaluationKnotPatches ~= currentSettings.requestedEvaluationKnotPatches) && ...
%             ~any(EvaluationSettings(parameterIndex).parentDomain ~= currentSettings.parentDomain))