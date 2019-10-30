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

classdef rationalBSplineBasisFunctions < bSplineBasisFunctions

    properties (SetAccess = protected)
        weights
        weightField
    end
    
    methods
        function obj = rationalBSplineBasisFunctions(varargin)
            obj@bSplineBasisFunctions(varargin{:});
            obj = constructorPostprocesses(obj, varargin{:});
        end
        
        evaluatePerKnotPatch(obj, varargin);
        changeWeights(obj, newValues);
        
    end
    
    events
        weightsChangeInduced
    end

end

function obj = constructorPostprocesses(obj, varargin)

if nargin == 1;
    obj.weights = ones(1, obj.KnotVector.numberOfBasisFunctions);
elseif length(varargin) > 1
    if isa(varargin{2}, 'numeric')
        obj.weights = varargin{2};
    elseif isa(varargin{3}, 'numeric')
        obj.weights = varargin{3};
    else
        throw(MException('CAGD:rationalBSplines', 'Provide the weights in the second input argument of the rationalBSplineBasisFunctions constructor.'));
    end
end

end