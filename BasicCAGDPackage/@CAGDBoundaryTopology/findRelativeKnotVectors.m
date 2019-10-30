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

function relativeKnotVectors = findRelativeKnotVectors(boundaryType, boundaryNumber, totalNumberOfParametricCoordinates, varargin)

switch boundaryType
    case 'VertexBoundary'
        relativeKnotVectors = []; % the vertices are not described by knot vectors
        
    case 'EdgeBoundary'
        edgeNumber = boundaryNumber;
        % check of the edge number validity
        switch totalNumberOfParametricCoordinates
            case 1; throw(MException('CAGDBoundaryTopology:findRelativeKnotVectors', '1D domains cannot possess edge boundaries.'));
            case 2; if edgeNumber > 4;    throw(MException('CAGDBoundaryTopology:findRelativeKnotVectors', 'Not a valid edge boundary number for a 2D domain.')); end;
            case 3; if edgeNumber > 12;   throw(MException('CAGDBoundaryTopology:findRelativeKnotVectors', 'Not a valid edge boundary number for a 3D domain.')); end;
            otherwise;  throw(MException('CAGDBoundaryTopology:findRelativeKnotVectors', 'The constructor of edge boundaries, supports from 2 and up to 3 parametric dimensions.'));
        end
        
        % map edge number to the corresponding knot vector which describes it
        switch edgeNumber
            case 1; relativeKnotVectors = 1;
            case 2; relativeKnotVectors = 1;
            case 3
                if totalNumberOfParametricCoordinates == 2
                     relativeKnotVectors = 2;
                else relativeKnotVectors = 1;
                end
            case 4
                if totalNumberOfParametricCoordinates == 2
                     relativeKnotVectors = 2;
                else relativeKnotVectors = 1;
                end
            case 5;  relativeKnotVectors = 2;
            case 6;  relativeKnotVectors = 2;
            case 7;  relativeKnotVectors = 2;
            case 8;  relativeKnotVectors = 2;
            case 9;  relativeKnotVectors = 3;
            case 10; relativeKnotVectors = 3;
            case 11; relativeKnotVectors = 3;
            case 12; relativeKnotVectors = 3;
        end
        
    case 'FaceBoundary'
        faceNumber = boundaryNumber;
        % check the validity of the face number
        switch totalNumberOfParametricCoordinates
            case 1; throw(MException('CAGDBoundaryTopology:findRelativeKnotVectors', '1D domains cannot possess face boundaries.'));
            case 2; throw(MException('CAGDBoundaryTopology:findRelativeKnotVectors', '2D domains cannot possess face boundaries.'));
            case 3; if faceNumber > 6;   throw(MException('CAGDBoundaryTopology:findRelativeKnotVectors', 'Not a valid face boundary number for a 3D domain.')); end;
            otherwise;  throw(MException('CAGDBoundaryTopology:findRelativeKnotVectors', 'The constructor of face boundaries, supports only 3 parametric dimensions.'));
        end
        
        % map face number to the corresponding knot vectors which describe it
        switch faceNumber
            case 1; relativeKnotVectors = 1:2;
            case 2; relativeKnotVectors = 1:2;
            case 3; relativeKnotVectors = 2:3;
            case 4; relativeKnotVectors = 2:3;
            case 5; relativeKnotVectors = [3 1];
            case 6; relativeKnotVectors = [3 1];
        end
        
    otherwise; throw(MException('CAGDBoundaryTopology:findRelativeKnotVectors', 'The constructor of boundaries, supports up to 3 parametric dimensions and the boundary types: ''VertexBoundary'', ''EdgeBoundary'', ''FaceBoundary''.'));
end

end