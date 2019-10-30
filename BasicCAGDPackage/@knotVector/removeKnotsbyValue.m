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

function removeKnotsbyValue(obj, varargin)

if nargin < 2; return
elseif ~isa(varargin{1}, 'numeric')
    throw(MException('knotVector:removeKnotsbyValue', 'The input argument in position ''1'' is not valid, must be of type numeric (i.e. the removed knots in a vector array).'));
end

obj.RefineData.removedKnotValues = varargin{1};
positions = [];
ValueTolerance = 1e-10;
for index = 1:length(varargin{1})
    position = find((obj.knotsWithoutMultiplicities -ValueTolerance < varargin{1}(index))&(varargin{1}(index) < obj.knotsWithoutMultiplicities +ValueTolerance));
    if ~isempty(position); positions = cat(2, positions, position);
    else throw(MException('knotVector:removeKnotsbyValue', 'Unable to find some or all of the given knots to remove.'));
    end
end

obj.removeKnotsbyNumber(positions);

end