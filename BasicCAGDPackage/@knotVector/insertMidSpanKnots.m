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

function insertMidSpanKnots(obj, varargin)

if nargin < 2; successiveMidSpanInserts = 1;
elseif ~isa(varargin{1}, 'numeric')
    throw(MException('knotVector:insertMidSpanKnots', 'As the first argument of the function, provide the number of successive mid-span knot insertions are required.'));
else
    successiveMidSpanInserts = varargin{1};
end

obj.RefineData.type                 = 'GlobalKnotInsertion';
obj.RefineData.status               = 'Unprocessed';
obj.RefineData.initialNumOfKnots    = obj.totalNumberOfKnots;
obj.RefineData.insertionKnots       = reshape((1:2^successiveMidSpanInserts-1)'*diff(obj.knotsWithoutMultiplicities)/2^successiveMidSpanInserts + repmat(obj.knotsWithoutMultiplicities(1:end-1), 2^successiveMidSpanInserts-1, 1), 1, []);

obj.notify('knotRefinementNurbsNotification');
obj.notify('globalKnotsInsertionInduced');
obj.refinementHandler;
obj.notify('globalKnotRefinementTensorBSplinesNotification');

end
