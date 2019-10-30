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

classdef CAGDPlotSettings < handle & hgsetget & dynamicprops & matlab.mixin.Copyable

    properties (Access = private)
        numOfParametricCoords = 3;
        geometryType
    end
    
    properties (SetAccess = private)
        plotTitle = { '\makebox[4in][c]{Rational BSpline Geometry}'}
        
        % Geometry plot settings
        lowerDomainPlotBounds = [0 0 0]
        upperDomainPlotBounds = [1 1 1]
        numOfPlottedPatchPoints = [11 11 11]
        knotPatchPoints
        GeometryBasisFunctionsEvaluationSettings
        KnotsBasisFunctionsEvaluationSettings
        
        Covariants_PlotSettings
        Knots_PlotSettings
        ControlPoints_PlotSettings = controlPointsPlotSettings
        Faces_PlotSettings
        
    end
    
    methods
        function obj = CAGDPlotSettings(varargin)

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
            else
                obj.defaultSettings_3D;
            end

            obj.GeometryBasisFunctionsEvaluationSettings = bSplineBasisFunctionsEvaluationSettings.empty(1, 0);
            for index = 1:obj.numOfParametricCoords
                obj.knotPatchPoints(index, :) = linspace(obj.lowerDomainPlotBounds(index), obj.upperDomainPlotBounds(index), obj.numOfPlottedPatchPoints(index));
                obj.GeometryBasisFunctionsEvaluationSettings(index) = bSplineBasisFunctionsEvaluationSettings('RepetitiveGivenInKnotPatches', obj.knotPatchPoints(index, :), 1);
            end

        end
        
        function defaultSettings_3D(obj)
            obj.numOfParametricCoords = 3;
            obj.lowerDomainPlotBounds = [0 0 0];
            obj.upperDomainPlotBounds = [1 1 1];
            obj.numOfPlottedPatchPoints = [11 11 11];
            obj.Covariants_PlotSettings = covariantsPlotSettings('3D');
            obj.Knots_PlotSettings = knotsPlotSettings('3D');
            obj.geometryType = 'Solid';
            obj.Faces_PlotSettings = [facesPlotSettings facesPlotSettings facesPlotSettings];
            obj.plotTitle = { '\makebox[4in][c]{Rational BSpline Solid}'};
        end
        
        function defaultSettings_2D(obj)
            obj.numOfParametricCoords = 2;
            obj.lowerDomainPlotBounds = [0 0];
            obj.upperDomainPlotBounds = [1 1];
            obj.numOfPlottedPatchPoints = [11 11];
            obj.Covariants_PlotSettings = covariantsPlotSettings('2D');
            obj.Knots_PlotSettings = knotsPlotSettings('2D');
            obj.geometryType = 'Surface';
            obj.Faces_PlotSettings = facesPlotSettings;
            obj.plotTitle = { '\makebox[4in][c]{Rational BSpline Surface}'};
        end
        
        function defaultSettings_2DPlane(obj)
            obj.numOfParametricCoords = 2;
            obj.lowerDomainPlotBounds = [0 0];
            obj.upperDomainPlotBounds = [1 1];
            obj.numOfPlottedPatchPoints = [11 11];
            obj.Covariants_PlotSettings = covariantsPlotSettings('2DPlane');
            obj.Knots_PlotSettings = knotsPlotSettings('2D');
            obj.Faces_PlotSettings = facesPlotSettings;
            obj.geometryType = 'Plane Surface';
            obj.plotTitle = { '\makebox[4in][c]{Rational BSpline Plane Surface}'};
        end

        
        function defaultSettings_1D(obj)
            obj.numOfParametricCoords = 1;
            obj.lowerDomainPlotBounds = 0;
            obj.upperDomainPlotBounds = 1;
            obj.numOfPlottedPatchPoints = 11;
            obj.Covariants_PlotSettings = covariantsPlotSettings('1D');
            obj.Knots_PlotSettings = knotsPlotSettings('1D');
            obj.geometryType = 'Curve';
            obj.plotTitle = { '\makebox[4in][c]{Rational BSpline Curve}'};
        end

        function setLowerDomainPlotBounds(obj, domainBounds)
            obj.lowerDomainPlotBounds = domainBounds;
        end
        
    end
    
end


% (3, [0 0 0], [1 1 1], [11 11 11], covariantsPlotSettings.settings_3D, knotsPlotSettings.settings_3D);
% obj.HomogeneousCoordinates.ProjectionLines.visualizationSwitch = 0;
%                 ['\makebox[4in][c]{U = ' mat2str(obj.KnotVectors(1).knots, 3) ', p = ' num2str(obj.KnotVectors(1).order-1) '}']
%                 ['\makebox[4in][c]{V = ' mat2str(obj.KnotVectors(2).knots, 3) ', q = ' num2str(obj.KnotVectors(2).order-1) '}']
%                 ['\makebox[4in][c]{W = ' mat2str(obj.KnotVectors(3).knots, 3) ', r = ' num2str(obj.KnotVectors(3).order-1) '}']};