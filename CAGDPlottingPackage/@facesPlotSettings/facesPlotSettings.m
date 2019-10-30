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

classdef facesPlotSettings < handle & hgsetget & dynamicprops & matlab.mixin.Copyable

    properties
        faceColor = 0.9*[1 1 1];
        faceAlpha = 1;
        faceEffects = {'FaceLighting', 'phong'};
        faceEdgesAlpha = 0;
        faceEdgesColor = 'none';
        faceEdgesEffects = {'EdgeLighting', 'phong'};
        plotSettings
        
    end
    
    methods
        function obj = facesPlotSettings(varargin)
            obj.buildPlotSettings;
        end
        
        function setFaceColor(obj, value)
            obj.faceColor = value;
            obj.buildPlotSettings;
            notify(obj, 'notifyFaceColorChanged');
        end
        
        function setFaceAlpha(obj, value)
            obj.faceAlpha = value;
            obj.buildPlotSettings;
            notify(obj, 'notifyFaceAlphaChanged');
        end
        
        function setFaceEffects(obj, value)
            obj.faceEffects = value;
            obj.buildPlotSettings;
            notify(obj, 'notifyFaceEffectsChanged');
        end
        
        function setFaceEdgesAlpha(obj, value)
            obj.faceEdgesAlpha = value;
            obj.buildPlotSettings;
            notify(obj, 'notifyFaceEdgesAlphaChanged');
        end
        
        function setFaceEdgesColor(obj, value)
            obj.faceEdgesColor = value;
            obj.buildPlotSettings;
            notify(obj, 'notifyFaceEdgesColorChanged');
        end
        
        function setFaceEdgesEffects(obj, value)
            obj.faceEdgesEffects = value;
            obj.buildPlotSettings;
            notify(obj, 'notifyFaceEdgesEffectsChanged');
        end
        
        function buildPlotSettings(obj)
            obj.plotSettings = ...
                [{'FaceAlpha', obj.faceAlpha, ...
                  'EdgeAlpha', obj.faceEdgesAlpha, ...
                  'EdgeColor', obj.faceEdgesColor}, ...
                 obj.faceEffects, obj.faceEdgesEffects];
        end
    end
    
    events
        notifyFaceColorChanged
        notifyFaceAlphaChanged
        notifyFaceEffectsChanged
        notifyFaceEdgesAlphaChanged
        notifyFaceEdgesColorChanged
        notifyFaceEdgesEffectsChanged
    end
end        