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
classdef nurbsRectangularSurfaceBendedPipe < nurbsSurfaceBended

    methods
        function obj = nurbsRectangularSurfaceBendedPipe(varargin)
            constructorData = constructorPreprocessor(varargin{:});
            obj@nurbsSurfaceBended(constructorData{:});
            obj.GeometryProperties.pipeDimensions = constructorData{4};
        end
                
    end
    
end

%%
function constructorData = constructorPreprocessor(varargin)

if nargin == 0
    bendRadius = 1;
    bendArcAngle = pi/2;
    pipeDimensions = repmat([0.5 0.5], 3, 1);
    
else
    bendRadius = varargin{2};
    bendArcAngle = varargin{3};
    if isvector(varargin{4}); pipeDimensions = repmat(varargin{4}, 3, 1);
    else pipeDimensions = varargin{4}; end
    
end

rectangles(1) = nurbsRectangle([0 0 0], pipeDimensions(1, :), [0 0 0], 1);
rectangles(2) = nurbsRectangle([0 0 0], pipeDimensions(2, :), [0 0 0], 1);
rectangles(3) = nurbsRectangle([0 0 0], pipeDimensions(3, :), [0 0 0], 1);

constructorData = {rectangles, bendRadius, bendArcAngle, pipeDimensions};

end