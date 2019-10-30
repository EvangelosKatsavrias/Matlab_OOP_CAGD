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

function relevantStackedBasisFunctions = requestBasisFunctions(obj, relevantParametricCoordinate, EvaluationSettings, varargin)

if nargin < 2 || ~(isnumeric(relevantParametricCoordinate) && isscalar(relevantParametricCoordinate))
    throw(MException('nurbs:requestBasisFunctions', 'Provide the relevant parametric coordinate number as first argument, and the ''bSplineBasisFunctionsEvaluationSettings'' object as second argument.'));
elseif nargin < 3 || ~isa(EvaluationSettings, 'bSplineBasisFunctionsEvaluationSettings')
    throw(MException('nurbs:requestBasisFunctions', 'Provide a ''bSplineBasisFunctionsEvaluationSettings'' object to the second argument.'));
end

if ~isempty(obj.MonoParametricBasisFunctions(relevantParametricCoordinate).BasisFunctions)
    for index = 1:length(obj.MonoParametricBasisFunctions(relevantParametricCoordinate).BasisFunctions)
        if isequal(EvaluationSettings, obj.MonoParametricBasisFunctions(relevantParametricCoordinate).BasisFunctions(index).EvaluationSettings)
            relevantStackedBasisFunctions = index;
            return
        end
    end
end

relevantStackedBasisFunctions = obj.addMonoParametricBasisFunctions(relevantParametricCoordinate, EvaluationSettings);

end

% 
% (strcmp(EvaluationSettings.requestedPointsPattern, obj.MonoParametricBasisFunctions(relevantParametricCoordinate).BasisFunctions(index).EvaluationSettings.requestedPointsPattern) && ...
%             ~any(EvaluationSettings.requestedPoints ~= obj.MonoParametricBasisFunctions(relevantParametricCoordinate).BasisFunctions(index).EvaluationSettings.requestedPoints) && ...
%             EvaluationSettings.requestedDerivativesOrder == obj.MonoParametricBasisFunctions(relevantParametricCoordinate).BasisFunctions(index).EvaluationSettings.requestedDerivativesOrder && ...
%             ~any(EvaluationSettings.requestedEvaluationKnotPatches ~= obj.MonoParametricBasisFunctions(relevantParametricCoordinate).BasisFunctions(index).EvaluationSettings.requestedEvaluationKnotPatches) && ...
%             ~any(EvaluationSettings.parentDomain ~= obj.MonoParametricBasisFunctions(relevantParametricCoordinate).BasisFunctions(index).EvaluationSettings.parentDomain))