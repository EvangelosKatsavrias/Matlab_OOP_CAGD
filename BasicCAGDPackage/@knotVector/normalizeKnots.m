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

function normalizeKnots(obj, varargin)
%% Check of the input data
if     nargin == 1; leftVal = 0; rightVal = 1;
elseif isnumeric(varargin{1})
    if isscalar(varargin{1})
        throw(MException('knotVector:normalizeKnots', 'Two values must be given to define the target knot vector span.'))
    else
        leftVal     = varargin{1}(1);
        rightVal    = varargin{1}(2);
        
        if leftVal == rightVal; throw(MException('knotVector:normalizeKnots', 'The left and right knot values must be dinstinct.')); end
        
        if leftVal > rightVal
            temp        = leftVal;
            leftVal     = rightVal;
            rightVal    = temp;
        end
        
        if obj.knots(1) == leftVal && obj.knots(end) == rightVal; return; end
    end
    
else throw(MException('knotVector:normalizeKnots', 'Provide a vector with two elements, corresponding to the two new end knots of the knot vector.'))
end

%%  Normalization process
tempKnots = obj.knots;
obj.knots = (tempKnots-tempKnots(1))/(tempKnots(end)-tempKnots(1));
obj.knots = obj.knots*(rightVal-leftVal)+leftVal;
obj.storeUniqueKnots;

if nargin > 1
    obj.RefineData.status       = 'Unprocessed';
    obj.RefineData.type         = 'Normalization';
    obj.RefineData.oldEndKnots  = [tempKnots(1) tempKnots(end)];
%     obj.knotVectorValidityCheck('normalized');
    obj.notify('knotsRenormalizationInduced');
end

end