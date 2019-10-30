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

function [controlPointsInHomogeneous, weights] = homogeneousArraySplitter(controlPointsInHomogeneous)

sizes               = size(controlPointsInHomogeneous);
numOfControlPoints  = sizes(1:end-1);
numOfCoordinates    = sizes(end)-1;
controlPointsInHomogeneous = reshape(controlPointsInHomogeneous, [], 1);
% weights
weights = reshape(controlPointsInHomogeneous((end-prod(numOfControlPoints)+1):end), [numOfControlPoints 1]);
% weighted physical coordinates
controlPointsInHomogeneous = reshape(controlPointsInHomogeneous(1:prod(numOfControlPoints)*numOfCoordinates), [numOfControlPoints numOfCoordinates 1]);

end