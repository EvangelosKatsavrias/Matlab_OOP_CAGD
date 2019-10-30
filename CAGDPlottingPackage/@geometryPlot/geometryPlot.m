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

classdef geometryPlot < handle & hgsetget & dynamicprops & matlab.mixin.Copyable
    
    properties
        NurbsObject
        PlotSettings
        PlotData
        PlotViews
        
        geometryPlotHandle
        controlLatticeHandle
        covariantsHandles
        knotsHandle
        knotLinesHandles

        SignalSlots
        
    end
    
    methods

        function obj = geometryPlot(varargin)
            obj.constructorProcesses(varargin{:});
        end
        
        constructorProcesses(obj, varargin);
        addDefaultSignalSlots(obj);
        handlingEvents(obj, eventData);
        
        plotClosurePoints(obj);
        plotControlLattice(obj);
        plotCovariants(obj);
        plotKnotLines(obj);
        plotKnotPoints(obj);

    end
    
    methods (Access = private)
        function evaluateClosurePlotPoints(obj)
            if ~isfield(obj.PlotData, 'closureTopologyIndex')
                obj.PlotData.closureTopologyIndex = obj.NurbsObject.requestClosureTopology(obj.PlotSettings.GeometryBasisFunctionsEvaluationSettings);
                obj.NurbsObject.ClosureTopologies(obj.PlotData.closureTopologyIndex).evaluateAllDomainMappings;
            end
        end
    end

    
    %%  show and hide methods
    methods
        function showClosure(obj)
            obj.plotClosurePoints;
        end
        
        function hideClosure(obj)
            if ~isempty(obj.geometryPlotHandle)
                for index = 1:size(obj.geometryPlotHandle, 3);
                    delete(obj.geometryPlotHandle(:,:,index));
                end
                obj.geometryPlotHandle = [];
            end
        end
        
        function showControlLattice(obj)
            obj.plotControlLattice;
        end
        
        function hideControlLattice(obj)
            if ~isempty(obj.controlLatticeHandle); delete(obj.controlLatticeHandle); obj.controlLatticeHandle = []; end
        end
        
        function showCovariants(obj)
            obj.plotCovariants;
        end
        
        function hideCovariants(obj)
            if ~isempty(obj.covariantsHandles); delete(squeeze(obj.covariantsHandles)); obj.covariantsHandles = []; end
        end
        
        function showKnotMarkers(obj)
            obj.plotKnotPoints;
        end
        
        function hideKnotMarkers(obj)
            if ~isempty(obj.knotsHandle); delete(obj.knotsHandle); obj.knotsHandle = []; end
        end
        
        function showKnotLines(obj)
            obj.plotKnotLines;
        end
        
        function hideKnotLines(obj)
            if ~isempty(obj.knotLinesHandles);
                for index = 1:size(obj.knotLinesHandles, 3)
                    delete(squeeze(obj.knotLinesHandles(:,:,index)));
                end
                obj.knotLinesHandles = [];
            end
        end

    end
    
end