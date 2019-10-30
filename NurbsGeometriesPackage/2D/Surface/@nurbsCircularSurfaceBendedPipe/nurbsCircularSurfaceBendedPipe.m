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

% NURBS geometry
classdef nurbsCircularSurfaceBendedPipe < nurbsSurfaceBended

    methods
        function obj = nurbsCircularSurfaceBendedPipe(varargin)
            constructorData = constructorPreprocessor(varargin{:});
            obj@nurbsSurfaceBended(constructorData{:});
            obj.GeometryProperties.pipeRadius = constructorData{4};
        end
                
    end
    
end

%%
function constructorData = constructorPreprocessor(varargin)

if nargin == 0
    bendRadius = 1;
    bendArcAngle = pi/2;
    pipeRadius = 0.5*[1 1 1];
else
    bendRadius = varargin{2};
    bendArcAngle = varargin{3};
    if isscalar(varargin{4}); pipeRadius = repmat(varargin{4}, 1, 3);
    else pipeRadius = varargin{4}; end
end

circles(1) = nurbsCircle([0 0 0], pipeRadius(1), [0 0 0], 2);
circles(2) = nurbsCircle([0 0 0], pipeRadius(2), [0 0 0], 2);
circles(3) = nurbsCircle([0 0 0], pipeRadius(3), [0 0 0], 2);

constructorData = {circles, bendRadius, bendArcAngle, pipeRadius};

end