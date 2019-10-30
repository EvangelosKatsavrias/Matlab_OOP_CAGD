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

function movebyKnotValue(obj, varargin)

if nargin < 2; return
elseif ~isa(varargin{1}, 'numeric')
    throw(MException('knotVector:movebyKnotValue', 'The input argument in position ''1'' is not valid, must be of type numeric (i.e. the new knot vector in a vector array).'));
end

positions   = [];
values      = varargin{1}(:, 2);
for index = 1:size(varargin{1}, 1)
    position = find(varargin{1}(index, 1) == obj.knots);
    if ~isempty(position)
        positions = cat(1, positions, position');
        if length(position)>1
            if length(values)>1
                values = cat(1, values(1:index), varargin{1}(index, 2)*ones(length(position)-1, 1), values(index+1:end));
            else
                values = cat(1, values(1:index), varargin{1}(index, 2)*ones(length(position)-1, 1));
            end
        end            
    else throw(MException('knotVector:movebyKnotValue', 'Unable to to find some or all of the given knots to move.'));
    end
end

obj.movebyKnotNumber([positions values]);

end