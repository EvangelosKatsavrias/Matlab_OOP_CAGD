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

function stackedFunctions = addMonoParametricBasisFunctions(obj, varargin)

evaluateFuncs = 1;

if nargin == 1 % default basis functions generator, it generates basis functions for all the parametric coordinates with default settings for the bspline functions evaluation and order of derivatives 1
    evaluationSettings = repmat(bSplineBasisFunctionsEvaluationSettings, 1, obj.GeneralInfo.totalNumberOfParametricCoordinates);
    parametricCoordinateIndices = 1:obj.GeneralInfo.totalNumberOfParametricCoordinates;

elseif isa(varargin{2}, 'bSplineBasisFunctions') % store the given bSplineBasisFunctions object
    evaluateFuncs       = 0;
    parametricCoords    = varargin{1};
    basisFuns           = varargin{2};
    stackedFunctions    = zeros(1, parametricCoords);
    for index = 1:length(varargin{1})
        if ~(basisFuns.KnotVector == obj.KnotVectors(parametricCoords(index)))
            throw(MException('nurbs:addMonoParametricBasisFunctions', ['The given basis functions instance is not based on the same knot vector that corresponds to the specific parametric coordinate (' num2str(parametricCoords(index)) ') of the current nurb instance.']));
        end
        obj.MonoParametricBasisFunctions(parametricCoords(index)).BasisFunctions = cat(2, obj.MonoParametricBasisFunctions(parametricCoords(index)).BasisFunctions, basisFuns(index));
        obj.MonoParametricBasisFunctions(parametricCoords(index)).numberOfStackedCases = obj.MonoParametricBasisFunctions(parametricCoords(index)).numberOfStackedCases +1;
        stackedFunctions(index) = obj.MonoParametricBasisFunctions(parametricCoords(index)).numberOfStackedCases;
    end

else % provide by input, the parametric coordinates and the corresponding settings, to evaluate the basis functions and then add them to the stack
    parametricCoordinateIndices = varargin{1};
    if isa(varargin{2}, 'bSplineBasisFunctionsEvaluationSettings')
        evaluationSettings = varargin{2};
    end

end

if evaluateFuncs
    index = 1;
    stackedFunctions = zeros(1, length(parametricCoordinateIndices));
    for parametricCoordinateIndex = parametricCoordinateIndices
        newBasisFunctions = bSplineBasisFunctions(obj.KnotVectors(parametricCoordinateIndex), 'Evaluate', evaluationSettings(index));
        obj.MonoParametricBasisFunctions(parametricCoordinateIndex).BasisFunctions = cat(2, obj.MonoParametricBasisFunctions(parametricCoordinateIndex).BasisFunctions, newBasisFunctions);
        obj.MonoParametricBasisFunctions(parametricCoordinateIndex).numberOfStackedCases = obj.MonoParametricBasisFunctions(parametricCoordinateIndex).numberOfStackedCases +1;
        stackedFunctions(index) = obj.MonoParametricBasisFunctions(parametricCoordinateIndex).numberOfStackedCases;
        index = index +1;
    end

end

end