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

% for sorted vectors only
function [newVector, varargout] = filterUniqueSortedVectorElements(givenVector, varargin)

if nargin > 1
    skipFirstElements = varargin{1};
else
    skipFirstElements = 0;
end
if nargin > 2
    skipLastElements = varargin{2};
else
    skipLastElements = 0;
end

newVector                       = zeros();
newVector(1+skipFirstElements)  = givenVector(1+skipFirstElements);
uniqueElementIndex              = 1+skipFirstElements;

if nargout > 1
    % multiplicities counter
    varargout{1}(uniqueElementIndex) = 1;
end

for examinedElementIndex = 1+skipFirstElements:length(givenVector)-1-skipLastElements
    
    if givenVector(examinedElementIndex+1) ~= givenVector(examinedElementIndex)
        
        newVector(uniqueElementIndex+1)     = givenVector(examinedElementIndex+1);
        uniqueElementIndex                  = uniqueElementIndex+1;
        varargout{1}(uniqueElementIndex)    = 1;
    
    else
        if nargout > 1
            % multiplicities counter
            varargout{1}(uniqueElementIndex) = varargout{1}(uniqueElementIndex)+1;
        end
    end
    
end

newVector(uniqueElementIndex:uniqueElementIndex+skipLastElements-1) = givenVector(end-skipLastElements+1:end);

end