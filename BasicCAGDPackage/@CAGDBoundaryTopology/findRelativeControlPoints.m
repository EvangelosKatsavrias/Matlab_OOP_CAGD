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

function relativeControlPoints = findRelativeControlPoints(boundaryType, boundaryNumber, ClosureConnectivities, varargin)

switch boundaryType
    case 'VertexBoundary';  relativeControlPoints = selectVertex(boundaryNumber, ClosureConnectivities, varargin);
    case 'EdgeBoundary';    relativeControlPoints = selectEdge(boundaryNumber, ClosureConnectivities, varargin);
    case 'FaceBoundary';    relativeControlPoints = selectFace(boundaryNumber, ClosureConnectivities, varargin);
    otherwise; throw(MException('CAGDBoundaryTopology:findRelativeControlPoints', 'The constructor of boundaries, supports up to 3 parametric dimensions and the boundary types: ''VertexBoundary'', ''EdgeBoundary'', ''FaceBoundary''.'));
end

end


%%
function relativeControlPoints = selectVertex(vertex, ClosureConnectivities, varargin)

switch ClosureConnectivities.numberOfParametricCoordinates
    case 1; if vertex > 2; throw(MException('CAGDBoundaryTopology:findRelativeControlPoints', 'Not a valid vertex boundary number for a 1D domain.')); end;
    case 2; if vertex > 4; throw(MException('CAGDBoundaryTopology:findRelativeControlPoints', 'Not a valid vertex boundary number for a 2D domain.')); end;
    case 3; if vertex > 8; throw(MException('CAGDBoundaryTopology:findRelativeControlPoints', 'Not a valid vertex boundary number for a 3D domain.')); end;
    otherwise;  throw(MException('CAGDBoundaryTopology:findRelativeControlPoints', 'The constructor of boundaries, supports up to 3 parametric dimensions.'));
end

switch vertex
    case 1; relativeControlPoints = ClosureConnectivities.vertexBoundaries2Closure(1);
    case 2; relativeControlPoints = ClosureConnectivities.vertexBoundaries2Closure(2);
    case 3; relativeControlPoints = ClosureConnectivities.vertexBoundaries2Closure(3);
    case 4; relativeControlPoints = ClosureConnectivities.vertexBoundaries2Closure(4);
    case 5; relativeControlPoints = ClosureConnectivities.vertexBoundaries2Closure(5);
    case 6; relativeControlPoints = ClosureConnectivities.vertexBoundaries2Closure(6);
    case 7; relativeControlPoints = ClosureConnectivities.vertexBoundaries2Closure(7);
    case 8; relativeControlPoints = ClosureConnectivities.vertexBoundaries2Closure(8);
end

end


%%
function relativeControlPoints = selectEdge(edge, ClosureConnectivities, varargin)

switch ClosureConnectivities.numberOfParametricCoordinates
    case 2; if edge > 4;    throw(MException('NURBS:nurbsBoundaryTopology', 'Not a valid edge boundary number for a 2D domain.')); end;
    case 3; if edge > 12;   throw(MException('NURBS:nurbsBoundaryTopology', 'Not a valid edge boundary number for a 3D domain.')); end;
    otherwise;  throw(MException('NURBS:nurbsBoundaryTopology', 'The constructor of boundaries, supports up to 3 parametric dimensions.'));
end

switch edge
    case 1;  relativeControlPoints = ClosureConnectivities.edgeBoundaries2Closure{1}(:, 1);
    case 2;  relativeControlPoints = ClosureConnectivities.edgeBoundaries2Closure{1}(:, 2);
    case 3
        if ClosureConnectivities.numberOfParametricCoordinates == 2
             relativeControlPoints = ClosureConnectivities.edgeBoundaries2Closure{2}(:, 1);
        else relativeControlPoints = ClosureConnectivities.edgeBoundaries2Closure{1}(:, 3);
        end
    case 4
        if ClosureConnectivities.numberOfParametricCoordinates == 2
             relativeControlPoints = ClosureConnectivities.edgeBoundaries2Closure{2}(:, 2);
        else relativeControlPoints = ClosureConnectivities.edgeBoundaries2Closure{1}(:, 4);
        end
    case 5;  relativeControlPoints = ClosureConnectivities.edgeBoundaries2Closure{2}(:, 1);
    case 6;  relativeControlPoints = ClosureConnectivities.edgeBoundaries2Closure{2}(:, 2);
    case 7;  relativeControlPoints = ClosureConnectivities.edgeBoundaries2Closure{2}(:, 3);
    case 8;  relativeControlPoints = ClosureConnectivities.edgeBoundaries2Closure{2}(:, 4);
    case 9;  relativeControlPoints = ClosureConnectivities.edgeBoundaries2Closure{3}(:, 1);
    case 10; relativeControlPoints = ClosureConnectivities.edgeBoundaries2Closure{3}(:, 2);
    case 11; relativeControlPoints = ClosureConnectivities.edgeBoundaries2Closure{3}(:, 3);
    case 12; relativeControlPoints = ClosureConnectivities.edgeBoundaries2Closure{3}(:, 4);
end

end


%%
function relativeControlPoints = selectFace(face, ClosureConnectivities, varargin)

switch ClosureConnectivities.numberOfParametricCoordinates
    case 3; if face > 6;   throw(MException('NURBS:nurbsBoundaryTopology', 'Not a valid face boundary number for a 3D domain.')); end;
    otherwise;  throw(MException('NURBS:nurbsBoundaryTopology', 'The constructor of boundaries, supports up to 3 parametric dimensions.'));
end

switch face
    case 1;  relativeControlPoints = ClosureConnectivities.faceBoundaries2Closure{1}(:, 1);
    case 2;  relativeControlPoints = ClosureConnectivities.faceBoundaries2Closure{1}(:, 2);
    case 3;  relativeControlPoints = ClosureConnectivities.faceBoundaries2Closure{2}(:, 1);
    case 4;  relativeControlPoints = ClosureConnectivities.faceBoundaries2Closure{2}(:, 2);
    case 5;  relativeControlPoints = ClosureConnectivities.faceBoundaries2Closure{3}(:, 1);
    case 6;  relativeControlPoints = ClosureConnectivities.faceBoundaries2Closure{3}(:, 2);
end

end