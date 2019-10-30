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

classdef geometryPlotManager < handle & hgsetget & dynamicprops & matlab.mixin.Copyable
    
    properties
        GeometryPlots
        NurbsObjects
    end
    
    methods
        
        function obj = geometryPlotManager(varargin)
            
        end

        function showAllClosures(obj)
            plotClosure(obj);
        end
        
        function hideAllClosures(obj)
            plotClosure(obj);
        end
        
        function showAllControlLattices(obj)
            plotControlLattice(obj);
        end
        
        function hideAllControlLattices(obj)
            plotControlLattice(obj);
        end
        
        function showAllCovariants(obj)
            plotCovariants(obj);
        end
        
        function hideAllCovariants(obj)
            plotCovariants(obj);
        end
        
        function showAllKnotMarkers(obj)
            plotKnotPoints(obj);
        end
        
        function hideAllKnotMarkers(obj)
            plotKnotPoints(obj);
        end
        
        function showAllKnotLines(obj)
            plotKnotLines(obj);
        end
        
        function hideAllKnotLines(obj)
            plotKnotLines(obj);
        end
        
    end

end