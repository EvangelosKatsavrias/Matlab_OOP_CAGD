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

function degradeOrder(obj, varargin)

if nargin < 2; orderDegradationDepth = 1;
elseif ~isa(varargin{1}, 'numeric')
    throw(MException('knotVector:degradeOrder', 'The input argument in position ''1'' is not valid, must be of type numeric (i.e. the knots to be removed in a vector array).'));
else orderDegradationDepth = varargin{1};
end

if obj.continuity < orderDegradationDepth
    throw(MException('knotVector:degradeOrder', ['The requested depth of degradation, is not possible. Consider that the current order is ' num2str(obj.order) ' and the current continuity ' num2str(obj.continuity) '.']))
end

obj.RefineData.type                     = 'OrderDegradation';
obj.RefineData.status                   = 'Unprocessed';
obj.RefineData.initialNumOfKnots        = obj.totalNumberOfKnots;
obj.RefineData.depthOfOrderDegradation  = orderDegradationDepth;

obj.notify('orderRefinementNurbsNotification');
obj.notify('orderDegradationInduced');
obj.refinementHandler;
obj.notify('globalKnotRefinementTensorBSplinesNotification');

end