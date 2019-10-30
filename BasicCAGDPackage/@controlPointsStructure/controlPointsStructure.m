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

classdef controlPointsStructure < handle & hgsetget & dynamicprops & matlab.mixin.Copyable
     
    properties (SetAccess = private)
        coordinates
        numberOfCoordinates
        numberOfParametricCoordinates
        numberOfControlPoints
    end
    
    methods
        function obj = controlPointsStructure(varargin)
            constructorProcesses(obj, varargin{:});
        end
    
        informationConstructor(obj);
        
        setNewCoordinates(obj, newCoords);
        
        controlPoints = getAllControlPoints(obj, varargin);
        controlPoints = getAllControlPointsCoordinates(obj, varargin);
        coords = getPartOfCoordinates(obj, coordNumbers, varargin);
        controlPoints = getControlPoints(obj, controlPointsIndices);
        coords = getControlPointsCoordinates(obj, controlPointsIndices);

        setNewControlPoints(obj, newControlPoints);
        setAllControlPoints(obj, controlPointsNewCoordinates);
        setAllControlPointsCoordinates(obj, controlPointsNewCoordinates, varargin);
        setPartOfCoordinates(obj, coordNumbers, newCoords, varargin);
        setControlPoints(obj, controlPointsIndices, controlPointsNewCoordinates);
        setControlPointsCoordinates(obj, controlPointsIndices, controlPointsNewCoordinates, varargin);
    end
    
    events
        notifyNewControlPointsSetted
        notifyAllControlPointsResetted
        notifyPartOfControlPointsResetted
        notifyAllControlPointsCoordinatesChanged
        notifyPartOfControlPointsCoordinatesChanged
        notifyPartOfCoordinatesChanged
    end
    
end