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

function constructorProcesses(obj, varargin)
% default constructor and default values ([0 0 1 1], 'unsorted', 'normalize', [0 1])
% optional arguments sequence (knots, sortingFlag ('sorted', 'unsorted'), 
%                                     normalizationFlag ('normalize', 'normalized'), 
%                                     normalizationValues ([startValue endValue]) )
%%  Store knots
if nargin > 1
    if isa(varargin{1}, 'numeric')
        obj.knots = varargin{1};
    else
        throw(MException('knotVector:knotVectorConstructor', ...
                         'The input argument in position ''1'' is not valid, must be of type numeric (i.e. the new knots in a vector array).'));
    end
end

%%  Post-processing data of stored knots
sortingFlag = 1; normalizationFlag = 1;

if nargin > 2
    if strcmp(varargin{2}, 'sorted')
        sortingFlag = 0;
    elseif strcmp(varargin{2}, 'unsorted')
    else
        throw(MException('knotVector:knotVectorConstructor', ...
                         'The input argument in position ''2'' is not valid, must be of type string, declaring if the given knot values need to be sorted (valid options: ''sorted'' or ''unsorted'').'));
    end
end

if nargin > 3
    if strcmp(varargin{3}, 'normalized')
        normalizationFlag = 0;
    elseif strcmp(varargin{3}, 'normalize')
    else
        thorw(MException('knotVector:knotVectorConstructor', ...
                         'Provide a valid string flag (''normalized'' or ''normalize'') as third input argument, to control the normalization process activity of the knot values.'));
    end
end

if nargin > 4
    if isvector(varargin{4})
        normalizationValues = varargin{4};
    else
        thorw(MException('knotVector:knotVectorConstructor', ...
                         'Provide a vector of doubles as fourth input argument, consisted of two values (the desired end values of the knot vector).'));
    end
else
    normalizationValues = [0 1];
end

if sortingFlag; obj.sortKnots; end
if normalizationFlag; obj.normalizeKnots(normalizationValues); end

obj.validateNmetaprocess;

end