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

classdef covariantsPlotSettings < handle & hgsetget & dynamicprops & matlab.mixin.Copyable

    properties (Access = private)
        numOfParametricCoords = 3
    end
    
    properties
        plotLowerBounds  = [0 0 0]
        plotUpperBounds  = [1 1 1]
        numOfPlotPoints  = [2 2 2]
        arrowsScaleFactor = [0.2 0.2 0.2]
        arrowsColor       = {'r' 'g' 'b'}
        arrowsLineWidth   = [2 2 2];
        arrowsLineStyle   = {'-' '-' '-'}
        plotSettings
        knotPatchPoints
        BasisFunctionsEvaluationSettings
        
    end
    
    methods
        
        function obj = covariantsPlotSettings(varargin)

            if nargin > 0
                switch varargin{1}
                    case '3D'
                        obj.defaultSettings_3D;
                    case '2D'
                        obj.defaultSettings_2D;
                    case '2DPlane'
                        obj.defaultSettings_2DPlane;
                    case '1D'
                        obj.defaultSettings_1D;
                end
            end
            
        end
        
        function defaultSettings_3D(obj)
            obj.numOfParametricCoords = 3;
            obj.plotLowerBounds  = [0 0 0];
            obj.plotUpperBounds  = [1 1 1];
            obj.numOfPlotPoints  = [2 2 2];
            obj.arrowsScaleFactor = [0.2 0.2 0.2];
            obj.arrowsColor       = {'r' 'g' 'b'};
            obj.arrowsLineWidth   = [2 2 2];
            obj.arrowsLineStyle   = {'-' '-' '-'};
            obj.setBasisFunctionsSettings;
            obj.buildPlotSettingsStruct;
        end
        
        function defaultSettings_2D(obj)
            obj.numOfParametricCoords = 2;
            obj.plotLowerBounds  = [0 0];
            obj.plotUpperBounds  = [1 1];
            obj.numOfPlotPoints  = [2 2];
            obj.arrowsScaleFactor = [0.2 0.2 0.2];
            obj.arrowsColor       = {'r' 'g' 'b'};
            obj.arrowsLineWidth   = [2 2 2];
            obj.arrowsLineStyle   = {'-' '-' '-'};
            obj.setBasisFunctionsSettings;
            obj.buildPlotSettingsStruct;
        end
        
        function defaultSettings_2DPlane(obj)
            obj.numOfParametricCoords = 2;
            obj.plotLowerBounds  = [0 0];
            obj.plotUpperBounds  = [1 1];
            obj.numOfPlotPoints  = [2 2];
            obj.arrowsScaleFactor = [0.2 0.2];
            obj.arrowsColor       = {'r' 'g'};
            obj.arrowsLineWidth   = [2 2];
            obj.arrowsLineStyle   = {'-' '-'};
            obj.setBasisFunctionsSettings;
            obj.buildPlotSettingsStruct;
        end
        
        function defaultSettings_1D(obj)
            obj.numOfParametricCoords = 1;
            obj.plotLowerBounds  = 0;
            obj.plotUpperBounds  = 1;
            obj.numOfPlotPoints  = 2;
            obj.arrowsScaleFactor = 0.2;
            obj.arrowsColor       = {'r'};
            obj.arrowsLineWidth   = 2;
            obj.arrowsLineStyle   = {'-'};
            obj.setBasisFunctionsSettings;
            obj.buildPlotSettingsStruct;
        end
        
        function buildPlotSettingsStruct(obj)
            if obj.numOfParametricCoords == 2 && length(obj.arrowsColor) == 3
                numOfSets = obj.numOfParametricCoords+1;
            else
                numOfSets = obj.numOfParametricCoords;
            end
            for covariantIndex = 1:numOfSets
                obj.plotSettings{covariantIndex} = ...
                    {obj.arrowsScaleFactor(covariantIndex), ...
                    'Color', obj.arrowsColor{covariantIndex}, ...
                    'LineWidth', obj.arrowsLineWidth(covariantIndex), ...
                    'LineStyle', obj.arrowsLineStyle{covariantIndex}};
            end
        end

        function setBasisFunctionsSettings(obj)
            obj.BasisFunctionsEvaluationSettings = bSplineBasisFunctionsEvaluationSettings.empty(1, 0);
            for index = 1:obj.numOfParametricCoords
                obj.knotPatchPoints(index, :)  = linspace(obj.plotLowerBounds(index), obj.plotUpperBounds(index), obj.numOfPlotPoints(index));
                obj.BasisFunctionsEvaluationSettings(index) = bSplineBasisFunctionsEvaluationSettings('RepetitiveGivenInKnotPatches', obj.knotPatchPoints(index, :), 1);
            end
        end
        
    end
    
end