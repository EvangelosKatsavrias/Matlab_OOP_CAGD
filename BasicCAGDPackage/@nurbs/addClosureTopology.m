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

function stackedClosureNumber = addClosureTopology(obj, varargin)

[BasisFunctions, BasisFunctionsIndices] = preprocessor(obj, varargin{:});

obj.ClosureTopologies = cat(2, obj.ClosureTopologies, CAGDClosureTopology(BasisFunctions, obj.ControlPoints, obj.Connectivities));
obj.TopologiesInfo.numberOfStackedClosureTopologies = obj.TopologiesInfo.numberOfStackedClosureTopologies +1;
stackedClosureNumber = obj.TopologiesInfo.numberOfStackedClosureTopologies;
obj.TopologiesInfo.relevantMonoParamBasisFunctions(stackedClosureNumber, :) = BasisFunctionsIndices;

end


%%
function [BasisFunctions, BasisFunctionsIndices] = preprocessor(obj, varargin)

if nargin == 1
    evalSettings = bSplineBasisFunctionsEvaluationSettings.empty(1, 0);
    for index = 1:obj.GeneralInfo.totalNumberOfParametricCoordinates
        evalSettings(index) = bSplineBasisFunctionsEvaluationSettings;
    end
else
    if isa(varargin{1}, 'bSplineBasisFunctionsEvaluationSettings')
        evalSettings = varargin{1};
    else throw(MException('nurbs:addClosureTopology', 'Provide basis functions evaluation settings, by ''bSplineBasisFunctionsEvaluationSettings'' objects.'));
    end
end

BasisFunctionsIndices = zeros(1, obj.GeneralInfo.totalNumberOfParametricCoordinates);
BasisFunctions = bSplineBasisFunctions.empty(1, 0);
for index = 1:obj.GeneralInfo.totalNumberOfParametricCoordinates
    BasisFunctionsIndices(index) = obj.requestBasisFunctions(index, evalSettings(index));
    BasisFunctions(index) = obj.MonoParametricBasisFunctions(index).BasisFunctions(BasisFunctionsIndices(index));
end

end