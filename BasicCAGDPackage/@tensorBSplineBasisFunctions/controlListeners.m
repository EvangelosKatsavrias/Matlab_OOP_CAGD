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

function controlListeners(obj, varargin)
%% control knotVector slots
if strcmp(varargin{1}, 'Enable'); setValue = 1; elseif strcmp(varargin{1}, 'Disable'); setValue = 0; end
if nargin > 2; fieldNames = varargin{2}; else fieldNames = fieldnames(obj.SignalSlots.KnotVector); end
if nargin > 3 && isvector(varargin{3}); parametricCoordinatesIndices = varargin{3};
else parametricCoordinatesIndices = 1:obj.Connectivities.numberOfParametricCoordinates;
end

for fieldIndex = 1:length(fieldNames)
    for paramCoordIndex = parametricCoordinatesIndices
        obj.SignalSlots.KnotVector(paramCoordIndex).(fieldNames{fieldIndex}).Enabled = setValue;
    end
end

end