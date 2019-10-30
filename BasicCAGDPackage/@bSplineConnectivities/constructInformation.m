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

function constructInformation(obj, varargin)

obj.order                                                   = [obj.KnotVectors.order];
obj.degree                                                  = obj.order-1;
obj.numberOfKnotPatches                                     = prod([obj.KnotVectors.numberOfKnotPatches]);
obj.numberOfFunctionsPerKnotPatch                           = prod(obj.order);
obj.numberOfFunctionsInBSplinePatch                         = prod([obj.KnotVectors.numberOfBasisFunctions]);
obj.numberOfMonoParametricBasisFunctions                    = [obj.KnotVectors.numberOfBasisFunctions];

switch obj.controlPointsCountingSequenceType
    case 'Sorted'; [~, obj.controlPointsCountingSequence]   = sort([obj.KnotVectors.numberOfBasisFunctions]);
    case 'Unsorted'; obj.controlPointsCountingSequence      = 1:obj.numberOfParametricCoordinates;
end

[connFlag, connPosition] = searchArguments(varargin, 'Connectivities', 'cell');
if connFlag; obj.defaultConnectivities(varargin{connPosition}{:});
else obj.defaultConnectivities;
end

end