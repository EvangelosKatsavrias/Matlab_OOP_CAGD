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

function elevateOrder(obj, varargin)
    
if nargin < 2; orderElevationDepth = 1;
elseif ~isa(varargin{1}, 'numeric')
    throw(MException('knotVector:elevateOrder', 'The input argument in position ''1'' is not valid, must be of type numeric (i.e. the inserted knots in a vector array).'));
else orderElevationDepth = varargin{1};    
end

obj.RefineData.type                     = 'OrderElevation';
obj.RefineData.status                   = 'Unprocessed';
obj.RefineData.initialNumOfKnots        = obj.totalNumberOfKnots;
obj.RefineData.depthOfOrderElevation    = orderElevationDepth;

obj.notify('orderRefinementNurbsNotification');
obj.notify('orderElevationInduced');
if strcmp(obj.RefineData.status, 'Unprocessed')
    newknots = [repmat(obj.knots(1), 1, orderElevationDepth) obj.knots repmat(obj.knots(end), 1, orderElevationDepth)];
    obj.refinementHandler(newknots);
end
obj.notify('globalKnotRefinementTensorBSplinesNotification');

end