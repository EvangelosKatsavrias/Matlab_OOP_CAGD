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

function knotVectorValidityCheck(obj)

if ~(obj.knotMultiplicities(1) == obj.knotMultiplicities(end))
    if isfield(obj.RefineData, 'initialKnots')
        obj.knots = obj.RefineData.initialKnots;
        obj.order = obj.RefineData.initialOrder;
    end
    throw(MException('knotVector:validityCheck', 'Please check the knot vector input array, the multiplicity of knots in the right end must be the same with the multiplicity in the left end.'));
end

if obj.continuity < 0
    if isfield(obj.RefineData, 'initialKnots')
        obj.knots = obj.RefineData.initialKnots;
        obj.order = obj.RefineData.initialOrder;
    end
    throw(MException('knotVector:validityCheck', 'Please check the knot vector input array, the multiplicity of inner knots can not be higher than the multiplicity at the end knots minus one (i.e. order-1).'));
end

end