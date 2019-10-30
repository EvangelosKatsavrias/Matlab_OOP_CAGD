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

if nargin == 1
    throw(MException('geometryPlot:constructor', 'Provide input data, (nurbsObject).'));
elseif nargin > 1
    if isa(varargin{1}, 'nurbs')
        obj.NurbsObject = varargin{1};
    else throw(MException('geometryPlot:constructor', 'Provide appropriate input data (nurbsObject).'));
    end
end
if nargin > 2
    if isa(varargin{2}, 'CAGDPlotSettings')
        obj.PlotSettings = varargin{2};
    else throw(MException('geometryPlot:constructor', 'Provide appropriate input data (nurbsObject, CAGDPlotSettingsObject).'));
    end
else
    switch obj.NurbsObject.GeneralInfo.totalNumberOfParametricCoordinates
        case 3
            obj.PlotSettings = CAGDPlotSettings('3D');
        case 2
            switch obj.NurbsObject.GeneralInfo.numberOfPhysicalCoordinates
                case 3
                    obj.PlotSettings = CAGDPlotSettings('2D');
                case 2
                    obj.PlotSettings = CAGDPlotSettings('2DPlane');
            end
        case 1
            obj.PlotSettings = CAGDPlotSettings('1D');
    end
end

if nargin > 3; obj.PlotViews = varargin{3};
else obj.PlotViews = plotView;
end

switch obj.NurbsObject.ControlPoints.numberOfCoordinates
    case 2; obj.PlotViews.ViewSettings.xyView;
    case 1; obj.PlotViews.ViewSettings.xyView;
end

maxCoords = ones(1, 3);
minCoords = zeros(1, 3);
maxCoords(1:obj.NurbsObject.ControlPoints.numberOfCoordinates) = max(obj.NurbsObject.ControlPoints.getAllControlPointsCoordinates('sequenced'));
minCoords(1:obj.NurbsObject.ControlPoints.numberOfCoordinates) = min(obj.NurbsObject.ControlPoints.getAllControlPointsCoordinates('sequenced'));
maxCoords(3) = maxCoords(3)+1;
obj.PlotViews.ViewSettings.setViewLimits(1.2*[minCoords; maxCoords]');

obj.evaluateClosurePlotPoints;
obj.addDefaultSignalSlots;
            
end