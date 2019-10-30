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

obj.ExceptionsData.msgID = 'NURBS:nurbsConstructor';

if nargin == 1    
    obj.KnotVectors     = [knotVector([0 0 1 1]) knotVector([0 0 1 1]) knotVector([0 0 1 1])];
    obj.ControlPoints   = rationalControlPointsStructure;
    obj.TopologiesInfo.sortingCoordinates = 'Unsorted';
    
else
    if isa(varargin{1}, 'knotVector'); obj.KnotVectors = varargin{1};
    elseif isa(varargin{1}, 'cell')
        for index = 1:length(varargin{1})
            obj.KnotVectors(index) = knotVector(varargin{1}{index});
        end
    end
    
    if isa(varargin{2}, 'rationalControlPointsStructure'); obj.ControlPoints = varargin{2};
    elseif isa(varargin{2}, 'cell'); obj.ControlPoints = rationalControlPointsStructure(varargin{2}{:});
    end
    
    if nargin > 3;   obj.TopologiesInfo.sortingCoordinates = varargin{3};
    else             obj.TopologiesInfo.sortingCoordinates = 'Unsorted';
    end

end

obj.GeneralInfo.totalNumberOfParametricCoordinates = length(obj.KnotVectors);
obj.Connectivities = bSplineConnectivities(obj.KnotVectors, 'ControlPointsCountingSequence', obj.TopologiesInfo.sortingCoordinates);
obj.constructInformation;
obj.addDefaultSignalSlots;

for parametricCoordinateIndex = 1:obj.GeneralInfo.totalNumberOfParametricCoordinates
    obj.MonoParametricBasisFunctions(parametricCoordinateIndex).BasisFunctions          = [];
    obj.MonoParametricBasisFunctions(parametricCoordinateIndex).numberOfStackedCases    = 0;
end
obj.TopologiesInfo.numberOfStackedClosureTopologies     = 0;
obj.TopologiesInfo.numberOfStackedInteriorTopologies    = 0;
obj.TopologiesInfo.numberOfStackedBoundaryTopologies    = 0;

end