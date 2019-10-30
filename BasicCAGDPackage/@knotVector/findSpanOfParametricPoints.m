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

function spanNumbers = findSpanOfParametricPoints(obj, varargin)

obj.ExceptionsData.msgIDFindSpan = 'knotVector:findSpanMethod';

if isa(varargin{1}, 'numeric')
    numOfPoints = length(varargin{1});
    spanNumbers = zeros(1, numOfPoints);
    for knotValueIndex = 1:numOfPoints
        spanNumbers(knotValueIndex) = newFindSpan(obj, varargin{1}(knotValueIndex));
    end
else
    throw(MException(obj.ExceptionsData.msgIDFindSpan, 'Give the parametric points in a vector of doubles to find their knot spans.'));
end

end

function knotSpanNumber = newFindSpan(obj, knotValue)

knotPatch = find(knotValue < obj.knotsWithoutMultiplicities, 1, 'first')-1;
if isempty(knotPatch); knotPatch = obj.numberOfKnotPatches; end
knotSpanNumber = obj.knotPatch2KnotSpanNumber(knotPatch);

end

% function uspan = FindSpan(order, knotVector, knotValue)
% % Determine the knot span index
% % Input: order, knotValue, knotVector
% % Return: the knot span index
% 
% n = length(knotVector)-order-1;  % n=m-p-1=(length(U)-1)-p-1=length(U)-p-2
% 
% if (knotValue == knotVector(n+2))     % Check the equality with the last knot of the last non-zero span, the position of it is the last element of the knot vector subtracting the multiplicity of the last knot minus one.  length(U)-p
%     
%     uspan = n;    % The last non-zero span is indexed as length(U)-p-1
% 
% else
%     
%     low     = order;      % Setting the bounds of the initial interval
%     high    = n+2;
%     mid     = floor((low+high)/2);   % Applying the midsection method
%     iter    = 0;
%     
%     while (knotValue<knotVector(mid) || knotValue>=knotVector(mid+1)) % Checking if u is in [mid,mid+1] span
%         
%         if (knotValue<knotVector(mid)) 
%             high = mid;
%         else
%             low  = mid; 
%         end
%         
%         mid     = floor((low+high)/2);
%         iter    = iter+1;
%         
%         if iter == n
%             error('CAGD:knotVector', 'Incosistent bspline data, verify the data');
%         end
%         
%     end
%     
%     uspan = mid-1;           % The final result if u is in [mid,mid+1] span
% 
% end
% 
% end