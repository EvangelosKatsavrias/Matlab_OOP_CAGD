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

function degradeContinuity_kRefinement(obj, varargin)

if nargin < 2; degradationDepth = 1;
elseif ~isa(varargin{1}, 'numeric')
    throw(MException('knotVector:degradeContinuity_kRefinement', 'The input argument in position ''1'' is not valid, must be of type numeric (i.e. the knots to be removed in a vector array).'));
else degradationDepth = varargin{1};
end

if obj.numberOfKnotPatches == 1
    throw(MException('knotVector:degradeContinuity_kRefinement', 'The requested depth of continuity degradation, is not possible. Please consider that the current CAGD object is a bezier patch.'))
end
if obj.continuity < degradationDepth
    throw(MException('knotVector:degradeContinuity_kRefinement', ['The requested depth of continuity degradation, is not possible. Please consider that the current continuity degree is ' num2str(obj.continuity) '.']))
end

obj.RefineData.type                 = 'GlobalKnotInsertion';
obj.RefineData.status               = 'Unprocessed';
obj.RefineData.initialNumOfKnots    = obj.totalNumberOfKnots;
obj.RefineData.insertionKnots       = reshape(repmat(obj.knotsWithoutMultiplicities(2:end-1), degradationDepth, 1), [], 1)';

obj.notify('knotRefinementNurbsNotification');
obj.notify('globalKnotsInsertionInduced');
obj.refinementHandler;
obj.notify('globalKnotRefinementTensorBSplinesNotification');

end
