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

classdef knotsPlotSettings < handle & hgsetget & dynamicprops & matlab.mixin.Copyable

    properties (Access = private)
        numOfParametricCoords = 3
    end
    
    properties
        linesStyle = {'-' '-' '-'}
        linesWidth = [2 2 2]
        linesColor = {[0 0 0] [0 0 0] [0 0 0]}
        linesPlotSettings
        markersStyle = 'd'
        markersSize  = 8
        markersColor = 'g'
        markersEdgeColor = 'g'
        markersPlotSettings
        markersLabels = {'U' 'V' 'W'}
        labelsFontScaleFactor = 1
        labelsPlotSettings
        BasisFunctionsEvaluationSettings
        
    end
    
    methods
        
        function obj = knotsPlotSettings(varargin)

            if nargin > 0
                switch varargin{1}
                    case '3D'
                        obj.defaultSettings_3D;
                    case '2D'
                        obj.defaultSettings_2D;
                    case '1D'
                        obj.defaultSettings_1D;
                end
            end

            for knotIndex = 1:length(obj.linesWidth)
                obj.linesPlotSettings{knotIndex} = ...
                    {'Color', obj.linesColor{knotIndex}, ...
                     'LineStyle', obj.linesStyle{knotIndex}, ...
                     'LineWidth', obj.linesWidth(knotIndex)};
            end
            
            obj.markersPlotSettings = ...
                    {'MarkerSize', obj.markersSize, ...
                     'Marker', obj.markersStyle, ...
                     'MarkerFaceColor', obj.markersColor, ...
                     'MarkerEdgeColor', obj.markersEdgeColor, ...
                     'LineStyle', 'none'};
            obj.labelsPlotSettings = {'FontSize' 12*obj.labelsFontScaleFactor 'Interpreter' 'latex' 'VerticalAlignment', 'Bottom', 'HorizontalAlignment', 'Left'};
            
            obj.setBasisFunctionsSettings;

        end

        function defaultSettings_3D(obj)
            obj.numOfParametricCoords = 3;
            obj.linesStyle = {'-' '-' '-'};
            obj.linesWidth = [2 2 2];
            obj.linesColor = {[0 0 0] [0 0 0] [0 0 0]};
            obj.markersLabels = {'U' 'V' 'W'};
        end
        
        function defaultSettings_2D(obj)
            obj.numOfParametricCoords = 2;
            obj.linesStyle = {'-' '-'};
            obj.linesWidth = [2 2];
            obj.linesColor = {[0 0 0] [0 0 0]};
            obj.markersLabels = {'U' 'V'};
        end
        
        function defaultSettings_1D(obj)
            obj.numOfParametricCoords = 1;
            obj.linesStyle = {'-'};
            obj.linesWidth = 2;
            obj.linesColor = {[0 0 0]};
            obj.markersLabels = {'U'};
        end
        
        function setBasisFunctionsSettings(obj)
            obj.BasisFunctionsEvaluationSettings = bSplineBasisFunctionsEvaluationSettings.empty(1, 0);
            for index = 1:obj.numOfParametricCoords
                obj.BasisFunctionsEvaluationSettings(index) = bSplineBasisFunctionsEvaluationSettings('RepetitiveGivenInKnotPatches', [0 1], 0);
            end
        end
        
    end
    
    methods(Static)
        function evaluationSettings = knotPointsEvaluationSettings(KnotVectors)
            evaluationSettings = bSplineBasisFunctionsEvaluationSettings.empty(1, 0);
            for index = 1:length(KnotVectors)
                evaluationSettings(index) = bSplineBasisFunctionsEvaluationSettings('ArbitraryGivenInDomain', KnotVectors(index).knotsWithoutMultiplicities, 0);
            end
        end
    end

    
end