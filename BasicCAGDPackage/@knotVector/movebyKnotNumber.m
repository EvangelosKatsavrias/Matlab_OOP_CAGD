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

function movebyKnotNumber(obj, varargin)

if nargin < 2; return
elseif ~isa(varargin{1}, 'numeric')
    throw(MException('knotVector:movebyKnotNumber', 'The input argument in position ''1'' is not valid, must be of type numeric (i.e. the new knot vector in a vector array).'));
end

obj.RefineData.type                 = 'KnotMovement';
obj.RefineData.status               = 'Unprocessed';
obj.RefineData.initialNumOfKnots    = obj.totalNumberOfKnots;
obj.RefineData.movedKnots           = varargin{1}(:, 1)';
obj.RefineData.knotMovements        = varargin{1}(:, 2)';
for index = 1:size(varargin{1}, 1)
    obj.RefineData.movementRefinedSpans(index, :) = varargin{1}(index, 1) -obj.order +[1 2];
end

obj.notify('knotRefinementNurbsNotification');
obj.notify('localKnotsMovementInduced');
obj.refinementHandler;
obj.notify('localKnotRefinementTensorBSplinesNotification');

end