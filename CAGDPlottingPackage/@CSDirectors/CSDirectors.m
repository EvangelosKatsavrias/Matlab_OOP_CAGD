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

classdef CSDirectors < handle & hgsetget & dynamicprops & matlab.mixin.Copyable

    properties (SetAccess = private)
        labels = {'X' 'Y' 'Z'};
        color = {'r' 'g' 'b'};
        position = {0 0 0};
        direction = {{1 0 0}; {0 1 0}; {0 0 1}};
        arrowSize = ones(1, 3);
        arrowWidth = 3*ones(1, 3);
        arrowStyle = {'-' '-' '-'};
        globalScaleFactor = 1;
        textScaleFactor = 1;
        labelSettings = { 'Color' 'r' 'FontSize' 10 'Interpreter' 'latex'};
        viewHandle
        directorHandles
        labelHandles
    end
    
    methods
        
        function obj = CSDirectors(varargin)

            if nargin > 0; obj.viewHandle = varargin{1};
%             else throw(MException('CSDirectors:constructor', 'Provide a plotView object''s handle as the first argument of the constructor.'));
            end
            obj.labelSettings = {'Color' 'r' 'FontSize' 10*obj.globalScaleFactor*obj.textScaleFactor 'Interpreter' 'latex'};

        end
        
        function showDirectors(obj)
            if isempty(obj.directorHandles)
                for index = 1:length(obj.direction);
                    obj.directorHandles(index) = quiver3(obj.position{:}, obj.direction{index}{:}, obj.arrowSize(index), ...
                        'Color', obj.color{index}, 'LineWidth', obj.arrowWidth(index), ...
                        'LineStyle', obj.arrowStyle{index});
                end
            else
                for index = 1:length(obj.direction);
                    set(obj.directorHandles(index), ...
                        'Color', obj.color{index}, 'LineWidth', obj.arrowWidth(index), ...
                        'LineStyle', obj.arrowStyle{index});
                end
            end
        end
        
        function hideDirectors(obj)
            if ~isempty(obj.directorHandles)
                delete(obj.directorHandles);
                obj.hideLabels;
            end
            obj.directorHandles = [];
        end
        
        function showLabels(obj)
            if isempty(obj.labelHandles)
                textPos = num2cell(diag(obj.arrowSize) + repmat([obj.position{:}], 3, 1));
                for index = 1:length(obj.direction)
                    obj.labelHandles(index) = text(textPos{:, index}, obj.labels{index}, obj.labelSettings{:});
                end
            else
                for index = 1:length(obj.labelHandles);
                    set(obj.labelHandles(index), obj.labelSettings{:});
                end
            end
        end
        
        function hideLabels(obj)
            if ~isempty(obj.labelHandles)
                delete(obj.labelHandles);
            end
            obj.labelHandles = [];
        end
        
        function setPosition(obj, values)
            for index = 1:size(values, 2)
                obj.position{index} = values(index);
            end
            obj.refresh;
        end
        
        function setOrientation(obj, values)
            vecLen = size(values, 1);
            for index = 1:size(values, 2)
                obj.direction{index}(1:vecLen) = num2cell(values(:, index)');
            end
            obj.refresh;
        end
        
        function refresh(obj)
            if ~isempty(obj.directorHandles)
                obj.showDirectors;
            end
            
        end
        
    end

end