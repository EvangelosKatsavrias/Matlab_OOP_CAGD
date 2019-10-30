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

function newVector = removeVectorElements(oldVector, positions)

if ~isempty(positions)
    diffpos = diff(positions)-1;
    diffpos = [1 find(diffpos)+1];

    newVector = oldVector;
    removeShifter = 0;
    for index = 1:length(diffpos)
        startRemPos = positions(diffpos(index))-1 -removeShifter;
        if length(diffpos) > index
            endRemPos = positions(diffpos(index+1)-1) +1 -removeShifter;
        else
            endRemPos = min(length(newVector), positions(end)+1 -removeShifter);
        end
        newVector = [newVector(1:startRemPos) newVector(endRemPos:end)];
        removeShifter = removeShifter +endRemPos -startRemPos -1;

    end

end

end


% if ~isempty(positions)
%     positionIndex = 1;
%     newVector = zeros();
%     for index = 1:length(oldVector)
%         if min(index ~= positions)
%             newVector(positionIndex) = oldVector(index);
%             positionIndex = positionIndex +1;
%         end
%     end
% end