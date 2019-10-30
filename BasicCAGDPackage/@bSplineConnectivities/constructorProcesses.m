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

function constructorProcesses(obj, varargin)

obj.ExceptionsData.msgID = 'CAGD:Connectivities';

if nargin == 1
    obj.numberOfParametricCoordinates       = 2;
    obj.KnotVectors                         = [knotVector knotVector];
    obj.controlPointsCountingSequenceType   = 'Unsorted';
    
else
    obj.numberOfParametricCoordinates = length(varargin{1});
    if isa(varargin{1}, 'knotVector'); obj.KnotVectors = varargin{1};
    elseif isa(varargin{1}, 'cell')
        obj.KnotVectors = knotVector.empty;
        for knotVectorIndex = 1:obj.numberOfParametricCoordinates
            obj.KnotVectors(knotVectorIndex) = knotVector(varargin{1}{knotVectorIndex});
        end
    else throw(MException(obj.ExceptionsData.msgID, 'Wrong input type, a one dimensional array of knotVector objects is expected.'));
    end
    
    [countingFlag, countingPosition] = searchArguments(varargin, 'ControlPointsCountingSequence', 'char');
    if countingFlag
        switch varargin{countingPosition}
            case 'Sorted'
            case 'Unsorted'
        end
        obj.controlPointsCountingSequenceType = varargin{countingPosition};
    else obj.controlPointsCountingSequenceType = 'Unsorted';
    end
end

obj.constructInformation;
obj.addDefaultSignalSlots;

end