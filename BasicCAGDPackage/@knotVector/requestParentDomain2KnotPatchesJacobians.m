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

%%  Mapping jacobians of a given parent domain to the requested knot patches
function jacobians = requestParentDomain2KnotPatchesJacobians(obj, varargin)

parentDomain = [0 1];
knotPatches  = 1:obj.numberOfKnotPatches;

if nargin > 1
    if ~isempty(varargin{1})
        parentDomain = varargin{1};
    end

    if nargin > 2
        if ~isempty(varargin{2})
            knotPatches = varargin{2};
        end
    end
end

multiplier = 1/(parentDomain(2)-parentDomain(1));
jacobians = multiplier*(obj.knotsWithoutMultiplicities(knotPatches+1)-obj.knotsWithoutMultiplicities(knotPatches));

end