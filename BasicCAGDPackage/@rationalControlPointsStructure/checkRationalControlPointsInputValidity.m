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

function [newControlPoints, varargout] = checkRationalControlPointsInputValidity(coordsType, newControlPoints, varargin)

if ischar(coordsType) && (strcmp(coordsType, 'Homogeneous') || strcmp(coordsType, 'Cartesian')) % if homogeneous the coordinates are weighted
else throw(MException('rationalControlPoints:constructor', 'Give the type of the provided data as the first argument, valid string values: ''Homogeneous'', ''Cartesian''.'));
end

if nargin == 2 && isnumeric(newControlPoints) % provide the coordinates (weighted or not) and the weights in the same array, the weights are appended as an extra coordinate in the array
    [newControlPoints, varargout{1}] = rationalControlPointsStructure.homogeneousArraySplitter(newControlPoints);
    
elseif nargin == 3 && isnumeric(newControlPoints) && isnumeric(varargin{1}) % provide the coordinates and the weights in two separate arrays
    coordsArraySize  = size(newControlPoints);
    if isvector(varargin{1}); weightsArraySize = length(varargin{1}); else weightsArraySize = size(varargin{1}); end
    if (numel(coordsArraySize)-1) ~= numel(weightsArraySize)
        throw(MException('rationalControlPoints:constructor', 'The provided coordinates array and weights array are not compatible in sizes.'));
    end
    if any(coordsArraySize(1:end-1) ~= weightsArraySize)
        throw(MException('rationalControlPoints:constructor', 'The provided coordinates array and weights array are not compatible in sizes.'));
    end
    
else
    throw(MException('rationalControlPoints:setNewControlPoints', 'No valid data given, provide a single array containing physical coordinates and weights, or two arrays with the latter data being in separate arrays.'));
end

end