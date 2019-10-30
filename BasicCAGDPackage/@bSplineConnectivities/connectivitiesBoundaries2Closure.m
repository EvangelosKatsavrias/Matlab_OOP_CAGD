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

function connectivitiesBoundaries2Closure(obj, varargin)

% Mapping the corresponding controlling points of each boundary to the
% global closure numbering of control points

switch obj.numberOfParametricCoordinates
    case 1
        obj.vertexBoundaries2Closure = [1 obj.numberOfMonoParametricBasisFunctions];
        
    case 2
        %                                        2
        %      4 .-----------. 3            .-----------.
        %        |           |              |           |        v
        %        |           |              |           |       |
        %        |           |            3 |           | 4     |
        %        |           |              |           |       |______ u
        %      1 .-----------. 2            .-----------.       
        %                                         1
        %
        controlPointsNumbering = permute(reshape( 1:obj.numberOfFunctionsInBSplinePatch, obj.numberOfMonoParametricBasisFunctions(obj.controlPointsCountingSequence) ), ...
                                         obj.controlPointsCountingSequence);

        obj.vertexBoundaries2Closure = [controlPointsNumbering(1, 1) controlPointsNumbering(end, 1) controlPointsNumbering(end, end) controlPointsNumbering(1, end)];

        obj.edgeBoundaries2Closure = cell(1, 2);
        permuteOrder = [2 1];
        for parametricCoordinateIndex = 1:2
            obj.edgeBoundaries2Closure{parametricCoordinateIndex} = [controlPointsNumbering(:, 1) controlPointsNumbering(:, end)];
            controlPointsNumbering = permute(controlPointsNumbering, permuteOrder);
        end
        
    case 3
        %     w |
        %       |_____ v
        %      / 
        %     / u
        %                                                                              2      6
        %                                              4                               |     /
        %          8 .-----------. 7             ------|-----                      ----|----/-- 
        %          / |         / |           6-/ |-11      / |                   / |  \|/ |/_/ |   
        %         /  |        /  |            /  | 3      /-8|-12               /  |        /  |   
        %      5 .---|-------. 6 |           ----|-|------   |                 ----|--------   |   
        %        | 4 .-----------. 3         |   ----|---|---             3----|-> --------|--- 
        %        |  /        |  /            |5-/    2   |  /-7                |  /        |<-/-----4
        %        | /         | /           9-| /      10-| /                   | / _       | /  
        %        |/          |/              |/          |/                    |/  /| /|\  |/  
        %      1 .-----------. 2             ------|------                     ---/----|----
        %                                          1                             /     | 
        %                                                                       5      1  
        controlPointsNumbering = permute(reshape( 1:obj.numberOfFunctionsInBSplinePatch, obj.numberOfMonoParametricBasisFunctions(obj.controlPointsCountingSequence) ), ...
                                         obj.controlPointsCountingSequence);

        obj.vertexBoundaries2Closure = [controlPointsNumbering(1, 1, 1)     controlPointsNumbering(end, 1, 1)   controlPointsNumbering(end, end, 1)   controlPointsNumbering(1, end, 1) ...
                                        controlPointsNumbering(1, 1, end)   controlPointsNumbering(end, 1, end) controlPointsNumbering(end, end, end) controlPointsNumbering(1, end, end)];
        
        obj.edgeBoundaries2Closure = cell(1, 3);
        permuteOrder = [2 3 1];
        for parametricCoordinateIndex = 1:3
            obj.edgeBoundaries2Closure{parametricCoordinateIndex} = [controlPointsNumbering(:, 1, 1) controlPointsNumbering(:, end, 1) controlPointsNumbering(:, 1, end) controlPointsNumbering(:, end, end)];
            controlPointsNumbering = permute(controlPointsNumbering, permuteOrder);
        end
        % u1 u2 u3 u4 v1 v2 v3 v4 w1 w2 w3 w4
        obj.faceBoundaries2Closure = cell(1, 3);
        permuteOrder = [2 3 1];
        for parametricCoordinateIndex = 1:3
            obj.faceBoundaries2Closure{parametricCoordinateIndex} = [reshape(controlPointsNumbering(:, :, 1), [], 1) reshape(controlPointsNumbering(:, :, end), [], 1)];
            controlPointsNumbering = permute(controlPointsNumbering, permuteOrder);
        end
        % uv1 uv2 vw1 vw2 wv1 wv2
end

end