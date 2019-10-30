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

function elevateContinuity_kRefinement(obj, varargin)

if nargin < 2; elevationDepth = 1;
elseif ~isa(varargin{1}, 'numeric')
    throw(MException('knotVector:elevateContinuity_kRefinement', 'The input argument in position ''1'' is not valid, must be of type numeric (i.e. the knots to be removed in a vector array).'));
else elevationDepth = varargin{1};
end

if obj.order < obj.continuity+2+elevationDepth
    throw(MException('knotVector:elevateContinuity_kRefinement', 'No continuity elevation is possible, please consider degree elevation for further continuity elevation.'))
end

obj.RefineData.type                 = 'GlobalKnotRemoval';
obj.RefineData.status               = 'Unprocessed';
obj.RefineData.initialNumOfKnots    = obj.totalNumberOfKnots;
obj.RefineData.removedKnots         = [];
seqElem                             = 1:elevationDepth;
positionShifter                     = 0;
for index = 1:length(obj.knotMultiplicities)-2
    positionShifter             = positionShifter +obj.knotMultiplicities(index);
    obj.RefineData.removedKnots = cat(2, obj.RefineData.removedKnots, positionShifter+seqElem);
end

obj.notify('knotRefinementNurbsNotification');
obj.notify('globalKnotsRemovalInduced');
obj.refinementHandler;
obj.notify('globalKnotRefinementTensorBSplinesNotification');

end