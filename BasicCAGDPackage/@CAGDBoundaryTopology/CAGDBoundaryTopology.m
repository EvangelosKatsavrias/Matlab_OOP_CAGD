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

% CAGDTopology's Boundary Class
classdef CAGDBoundaryTopology < CAGDTopology
    properties (SetAccess = private)
        boundaryType   = 'FaceBoundary';
        boundaryNumber = 1;
        relativeParametricCoordinates
        relativeBasisFunctions
        relativeControlPoints
    end
    
    %% 
    methods
        function obj = CAGDBoundaryTopology(varargin)
            constructorData = constructorPreprocesses(varargin{:});
            obj@CAGDTopology(constructorData{:});
            constructorPostprocesses(obj, varargin{:});
        end
    end

    methods (Static)
        handlingEvents(obj, eventData);
        relativeKnotVectors = findRelativeKnotVectors(boundaryType, boundaryNumber, totalNumberOfParametricCoordinates, varargin);
        relativeControlPoints = findRelativeControlPoints(boundaryType, boundaryNumber, ClosureConnectivities, varargin);
    end
    
    %%
    events
    end

end


%%
function constructorData = constructorPreprocesses(varargin)

% constructorData = {}; % leave empty data, so that the default closure topology would be constructed (a plane surface topology)

if nargin == 0
    varargin{3} = [bSplineBasisFunctions([0 0 1 1]), bSplineBasisFunctions([0 0 1 1])];
    varargin{4} = rationalControlPointsStructure('Cartesian', shiftdim(reshape([0 0 0 1; 1 0 0 1; 0 1 0 1; 1 1 0 1]', 4, 2, 2), 1));
elseif nargin < 4
    throw(MException('CAGDBoundaryTopology:constructor', 'Provide as input: the boundary type, the boundary number, the relavant basis functions objects and the relevant control points object.'));
end

constructorData = {varargin{3}, varargin{4}}; %{basisFunctions, controlPoints}

end

function constructorPostprocesses(obj, varargin)

if nargin > 1 % use the given boundary type and number
    obj.boundaryType    = varargin{1};
    obj.boundaryNumber  = varargin{2};
end

if nargin > 5
    obj.relativeParametricCoordinates = varargin{5};
    obj.relativeBasisFunctions = varargin{6};
    obj.relativeControlPoints = varargin{7};
end

end