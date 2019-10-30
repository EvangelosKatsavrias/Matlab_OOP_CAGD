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

classdef controlPointsPlotSettings < handle & hgsetget & dynamicprops
    
    properties
        markerStyle         = '.';
        markerSize          = 20;
        markerColor         = 'b';
        linesStyle          = '-';
        linesWidth          = 1;
        linesColor          = 'b';
        plotSettingsWithMarkers
        plotSettingsOnlyLines
        labelsFontScaleFactor = 1
        labelsPlotSettings
    end
    
    methods
        function obj = controlPointsPlotSettings(varargin)
            obj.plotSettingsWithMarkers = {'MarkerSize', obj.markerSize, ...
              'Marker', obj.markerStyle, ...
              'MarkerFaceColor', obj.markerColor, ...
              'LineStyle', obj.linesStyle, ...
              'Color', obj.linesColor, ...
              'LineWidth', obj.linesWidth};
            obj.plotSettingsOnlyLines = {'LineStyle', obj.linesStyle, ...
                                         'Color', obj.linesColor, ...
                                         'LineWidth', obj.linesWidth};
            obj.labelsPlotSettings  = {'FontSize' 12*obj.labelsFontScaleFactor 'Interpreter' 'latex', 'VerticalAlignment' 'Bottom' 'HorizontalAlignment' 'Right'};
            
        end
        
    end
    
end