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

function Output = affineMapParentDomain2KnotPatches(obj, varargin)
%%  Input Polymorphism
parentDomain    = [0 1];
knotPatches     = 1:obj.numberOfKnotPatches;
pointsInParent  = [];

if nargin > 1
    if ~isempty(varargin{1})
        parentDomain = varargin{1};
    end

    if nargin > 2
        if ~isempty(varargin{2})
            knotPatches = varargin{2};
        end

        if nargin > 3
            pointsInParent  = varargin{3};
            shiftPerKnotPatch = obj.knotsWithoutMultiplicities(knotPatches);

            if nargin > 4
                if isscalar(varargin{4})
                    varargin{4} = repmat(varargin{4}, 1, length(shiftPerKnotPatch));
                end
                shiftPerKnotPatch = shiftPerKnotPatch +varargin{4};
            end
        end
    end
end

Output = calculateJacobians(obj, parentDomain, knotPatches);

if ~isempty(pointsInParent)
    Output = mapPointsFromParentDomain(Output, parentDomain, knotPatches, pointsInParent, shiftPerKnotPatch);
end

end


%%
function Output = calculateJacobians(obj, parentDomain, knotPatches)

    multiplier = 1/(parentDomain(2)-parentDomain(1));
    Output.jacobians = multiplier*(obj.knotsWithoutMultiplicities(knotPatches+1)-obj.knotsWithoutMultiplicities(knotPatches));

end


%%
function Output = mapPointsFromParentDomain(Output, parentDomain, knotPatches, pointsInParent, shiftPerKnotPatch)

if isa(pointsInParent, 'numeric')
    Output.mappedPoints = reshape(kron(pointsInParent-parentDomain(1), Output.jacobians(knotPatches)), [], length(pointsInParent)) +repmat(shiftPerKnotPatch', 1, length(pointsInParent));

elseif iscell(pointsInParent)
    for index = 1:length(pointsInParent)
        Output.mappedPoints{index} = (pointsInParent{index}-parentDomain(1))*Output.jacobians(knotPatches(index)) +shiftPerKnotPatch(index);
    end

end

end