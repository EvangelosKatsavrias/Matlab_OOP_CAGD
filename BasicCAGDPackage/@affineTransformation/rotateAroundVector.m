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

function rotateAroundVector(obj, rotationVector, rotationValue)

obj.typeOfTransformation = 'RotationAroundVector';
obj.transformationParameters = {rotationVector, rotationValue};

obj.transformationMatrix = affineTransformation.homogeneousRotationMatrix([rotationValue 0 0]);

obj.setReferenceSystem(3, 'LCS', [0 0 0], [rotationVector' [zeros(1, 2); eye(2,2)]]);

obj.localTransformation;

end