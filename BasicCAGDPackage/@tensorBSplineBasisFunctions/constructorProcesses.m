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

function constructorProcesses(obj, varargin)

obj.ExceptionsData.msgID = 'tensorBSplineBasisFunctions:constructor';

obj.basisFunctionsType              = 'BSpline';

if nargin == 1
    obj.MonoParametricBasisFunctions    = [bSplineBasisFunctions(knotVector([0 0 0 1 1 1])) bSplineBasisFunctions(knotVector([0 0 0 1 1 1]))];
    obj.numberOfParametricCoordinates   = 2;
    obj.requestedDerivativesOrder       = [1 1];
    
end

% Constructor provided with input data
if nargin > 1
    if isa(varargin{1}, 'bSplineBasisFunctions')
        obj.MonoParametricBasisFunctions = varargin{1};
    elseif isa(varargin{1}, 'knotVector')
        for index = 1:length(varargin{1})
            obj.MonoParametricBasisFunctions(index) = bSplineBasisFunctions(varargin{1}(index));
        end
    end
end

if nargin > 2
    if isa(varargin{2}, 'bSplineConnectivities')
        obj.Connectivities = varargin{2};
    else throw(MException(obj.ExceptionsData.msgID, 'Wrong input data, provide a valid object of class bSplineConnectivities.'));
    end
else obj.Connectivities = bSplineConnectivities([obj.MonoParametricBasisFunctions.KnotVector], 'ControlPointsCountingSequence', 'Unsorted');
end

obj.numberOfParametricCoordinates = length(obj.MonoParametricBasisFunctions);

for index = 1:obj.numberOfParametricCoordinates
    obj.requestedDerivativesOrder(index) = obj.MonoParametricBasisFunctions(index).EvaluationSettings.requestedDerivativesOrder;
end

obj.addDefaultSignalSlots;

if nargin > 3 && ischar(varargin{3})
    if strcmp(varargin{3}, 'Evaluate'); obj.evaluateTensorProducts; end
end

end