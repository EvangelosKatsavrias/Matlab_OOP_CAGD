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

classdef viewSettings < handle & hgsetget & dynamicprops & matlab.mixin.Copyable
    
    properties (SetAccess = private)
        viewHandle
        axesHandle
        
        fontSizeScaleFactor = 1
        viewTitle = 'Title'
        titleSettings = {'FontSize' 14 'Interpreter' 'latex' 'HorizontalAlignment', 'center'}

        %%  Axes props
        axesLabels = {'x' 'y' 'z'}
        axesLabelsSettings = {'FontSize' 16 'Interpreter' 'latex'}
        
        %%  View props
        boxFrame = 'on'
        gridPlot = 'off'
        axesRatios = {'equal'}
        viewAngles = [120 30]
        projectionView = {'orthographic'}
        viewLimits = [-2 2; -2 2; -2 2];

        %%  Render props
        materialRender = {'shiny'}
        lightEffects = {'Position',[15 -10 5],'Style','infinite'}
        shadeEffects = {'faceted'}
        
    end
    

    %
    methods
        % constructor
        function obj = viewSettings(varargin)

            if nargin == 2
                obj.viewHandle = varargin{1};
                obj.axesHandle = varargin{2};
            else
                obj.viewHandle = figure;
                obj.axesHandle = gca;
                hold all
            end
            
            obj.fontSizeScaleFactor = 1;
            obj.titleSettings = {'FontSize' 14*obj.fontSizeScaleFactor 'Interpreter' 'latex' 'HorizontalAlignment', 'center'};
            obj.axesLabelsSettings = {'FontSize' 16*obj.fontSizeScaleFactor 'Interpreter' 'latex'};

            set(0,'DefaultAxesColorOrder',[0 0 1;1 0 0;0 1 0;0 1 1;1 0.3 0;0.5 0.5 1]);
            set(0,'DefaultAxesLineStyleOrder',{'-'});
            
            obj.showAxesLabels;
            obj.showTitle;
            obj.showBoxFrame;
            obj.hideGrid;
            obj.setViewAngles([120 30]);
            axis(obj.axesRatios{:});
            
            obj.setMaterialRenderEffects;
            obj.setLightsEffects;
            obj.setShadeEffects;
            obj.setProjectionView;
            obj.setViewLimits;
            
        end
        
        % other methods
        function setFontSizeScaleFactor(obj, factor)
            obj.fontSizeScaleFactor = factor;
            obj.showTitle;
        end
        
        function showTitle(obj, varargin)
            if nargin == 1
            elseif nargin == 2
                obj.viewTitle = varargin{1};
            end
            figure(obj.viewHandle);
            title(obj.viewTitle, obj.titleSettings{:});
        end
        
        function showAxesLabels(obj, varargin)
            if nargin == 1
            elseif nargin == 2 && size(varargin) == 3
                obj.axesLabels = varargin;
            end
            figure(obj.viewHandle);
            xlabel(obj.axesLabels{1}, obj.axesLabelsSettings{:});
            ylabel(obj.axesLabels{2}, obj.axesLabelsSettings{:});
            zlabel(obj.axesLabels{3}, obj.axesLabelsSettings{:});
        end

        function showBoxFrame(obj)
            obj.boxFrame = 'on';
            figure(obj.viewHandle);
            box(obj.boxFrame);
        end
        
        function hideBoxFrame(obj)
            obj.boxFrame = 'off';
            figure(obj.viewHandle);
            box(obj.boxFrame);
        end
        
        function showGrid(obj)
            obj.gridPlot = 'on';
            figure(obj.viewHandle);
            grid(obj.gridPlot);
        end
        
        function hideGrid(obj)
            obj.gridPlot = 'off';
            figure(obj.viewHandle);
            grid(obj.gridPlot);
        end

        function setAxesRatiosOptions(obj, varargin)
            obj.axesRatios = varargin;
            figure(obj.viewHandle);
            axis(obj.axesRatios{:});
        end

        function setViewAngles(obj, varargin)
            if nargin == 1
            elseif nargin == 2 && isvector(varargin{1})
                obj.viewAngles = varargin{1};
            end
            figure(obj.viewHandle);
            view(obj.viewAngles);
        end
        
        function setMaterialRenderEffects(obj, varargin)
            if nargin == 1
            elseif nargin == 2 && iscell(varargin)
                obj.materialRender = varargin;
            end
            figure(obj.viewHandle);
            material(obj.materialRender{:});
        end
        

        function setLightsEffects(obj, varargin)
            if nargin == 1
            elseif nargin == 2 && iscell(varargin)
                obj.lightEffects = varargin;
            end
            figure(obj.viewHandle);
            light(obj.lightEffects{:});
        end
        
        function setShadeEffects(obj, varargin)
            if nargin == 1
            elseif nargin == 2 && iscell(varargin)
                obj.shadeEffects = varargin;
            end
            figure(obj.viewHandle);
            shading(obj.shadeEffects{:});
        end
        
        function xyView(obj)
            obj.setViewAngles([0 90]);
        end
        
        function yzView(obj)
            obj.setViewAngles([90 0]);
        end
        
        function xzView(obj)
            obj.setViewAngles([0 0]);
        end
        
        function isometricView(obj)
            obj.setViewAngles([120 30]);
        end
        
        function setProjectionView(obj)
            camproj(obj.projectionView{:});
        end
        
        function setViewLimits(obj, varargin)
            if nargin > 1
                for index = 1:size(varargin{1}, 1)
                    obj.viewLimits(index, :) = varargin{1}(index, :);
                end
            end
            xlim(obj.viewLimits(1, :));
            ylim(obj.viewLimits(2, :));
            zlim(obj.viewLimits(3, :));
        end

    end
    
end