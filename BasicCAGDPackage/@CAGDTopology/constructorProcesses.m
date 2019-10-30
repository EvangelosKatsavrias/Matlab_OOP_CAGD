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

obj.ExceptionsData = obj.setExceptionsData;

if nargin == 1
    MonoParametricBasisFunctions = [bSplineBasisFunctions([0 0 1 1]) bSplineBasisFunctions([0 0 1 1]) bSplineBasisFunctions([0 0 1 1])];
    obj.ControlPoints = controlPointsStructure;
else
    if nargin > 1
        if isa(varargin{1}, 'bSplineBasisFunctions')
            MonoParametricBasisFunctions = varargin{1};
        else throw(MException('CAGDTopology:constructor', 'Provide valid bSplineBasisFunctions objects as 1st argument.'));
        end
    end

    if nargin > 2
        if isa(varargin{2}, 'controlPointsStructure')
             obj.ControlPoints = varargin{2};
        else throw(MException('CAGDTopology:constructor', 'Provide the relevant control point structure as the second argument.'));
        end
    else throw(MException('CAGDTopology:constructor', 'Provide the relevant control point structure as the second argument.'));
    end
end

obj.KnotVectors = [MonoParametricBasisFunctions.KnotVector];

if nargin > 3
    if isa(varargin{3}, 'bSplineConnectivities')
        obj.Connectivities = varargin{3};
    else throw(MException('CAGDTopology:constructor', 'Provide a valid bSplineConnectivities object as 4th argument, or leave it undefined to be created one by default.'));
    end
else%if length(obj.KnotVectors) > 1
    obj.Connectivities = bSplineConnectivities(obj.KnotVectors);
end

obj.TopologyInfo.totalNumberOfParametricCoordinates = length(obj.KnotVectors);
obj.constructInformation;
if isa(obj.ControlPoints, 'rationalControlPointsStructure')
    obj.BasisFunctions = rationalTensorBSplineBasisFunctions(MonoParametricBasisFunctions, obj.Connectivities, obj.ControlPoints);
else
    obj.BasisFunctions = tensorBSplineBasisFunctions(MonoParametricBasisFunctions, obj.Connectivities);
end
obj.BasisFunctions.controlListeners('Disable');
obj.addDefaultSignalSlots;

end