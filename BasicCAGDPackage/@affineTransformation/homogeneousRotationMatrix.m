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

function transformationMatrix = homogeneousRotationMatrix(values)
switch length(values)
    case 1
        transformationMatrix = [cos(values(1)) -sin(values(1))  0
                                sin(values(1))  cos(values(1))  0
                                0               0               1];
    case 3
        transformationMatrix = [];
        if values(1)
            transformationMatrix = [1   0                   0           0
                                    0   cos(values(1))  -sin(values(1)) 0
                                    0   sin(values(1))   cos(values(1)) 0
                                    0               0       0           1];
        end
        if values(2)
            R  = [cos(values(2))    0    sin(values(2))  0
                  0                 1       0           0
                 -sin(values(2))    0   cos(values(2))  0
                  0                 0       0           1];
            if isempty(transformationMatrix)
                transformationMatrix = R;
            else transformationMatrix = R*transformationMatrix;
            end
        end
        if values(3)
            R  = [cos(values(3)) -sin(values(3))    0   0
                  sin(values(3))  cos(values(3))    0   0
                  0                 0               1   0
                  0                 0               0   1];
            if isempty(transformationMatrix)
                transformationMatrix = R;
            else transformationMatrix = R*transformationMatrix;
            end
        end
end
end