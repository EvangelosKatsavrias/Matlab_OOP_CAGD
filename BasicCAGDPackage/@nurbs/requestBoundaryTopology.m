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

function relevantStackedBoundaryTopology = requestBoundaryTopology(obj, boundaryType, boundaryNumber, EvaluationSettings, varargin)

if nargin < 4
    throw(MException('nurbs:requestBoundaryTopology', 'Provide the required boundary type, boundary number and ''bSplineBasisFunctionsEvaluationSettings'' objects.'));
elseif (strcmp(boundaryType, 'EdgeBoundary') && length(EvaluationSettings) ~= 1) || (strcmp(boundaryType, 'FaceBoundary') && length(EvaluationSettings) ~= 2)
    throw(MException('nurbs:requestBoundaryTopology', 'Provide the appropriate number of ''bSplineBasisFunctionsEvaluationSettings'' objects.'));
end

for topologyIndex = 1:length(obj.BoundaryTopologies)
    
    if strcmp(obj.BoundaryTopologies(topologyIndex).boundaryType, boundaryType) && obj.BoundaryTopologies(topologyIndex).boundaryNumber == boundaryNumber
        
        checkVec = zeros(1, length(EvaluationSettings));
        
        for parameterIndex = 1:length(EvaluationSettings)
            
            if isequal(EvaluationSettings(parameterIndex), obj.BoundaryTopologies(topologyIndex).BasisFunctions.MonoParametricBasisFunctions(parameterIndex).EvaluationSettings)
                checkVec(parameterIndex) = 1;
            end
            
        end
        
        if all(checkVec)
            relevantStackedBoundaryTopology = topologyIndex;
            return
        end
        
    end
    
end

relevantStackedBoundaryTopology = obj.addBoundaryTopology(boundaryType, boundaryNumber, EvaluationSettings);

end