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

classdef knotVector < handle & hgsetget & dynamicprops & matlab.mixin.Copyable
    %%  Properties
    
    properties (SetAccess = private)
        knots = [0 0 1 1];
        knotsWithoutMultiplicities
        knotMultiplicities
        order
        continuity
        totalNumberOfKnots
        numberOfKnotPatches
        numberOfBasisFunctions
        knotPatch2KnotSpanNumber
        knotPatch2BasisFunctions
        basisFunction2KnotPatches
    end
    
    properties (SetAccess = {?nurbs, ?knotVector, ?bSplineBasisFunctions}, SetObservable)
        RefineData
    end
    
    properties (AbortSet)
        ExceptionsData
    end
    
    %%  Methods
    methods
        % Constructor
        function obj = knotVector(varargin)
            constructorProcesses(obj, varargin{:});
        end
        
        normalizeKnots(obj, varargin);

        spanNumbers = findSpanOfParametricPoints(obj, varargin);
        outputStruct = affineMapParentDomain2KnotPatches(obj, varargin);
        outputStruct = affineMapParentDomain2ParametricDomain(obj, varargin);
        
        insertKnot(obj, varargin);
        insertMidSpanKnots(obj, varargin);
        removeKnotsbyNumber(obj, varargin);
        removeKnotsbyValue(obj, varargin);
        movebyKnotNumber(obj, varargin);
        movebyKnotValue(obj, varargin);
        generalKnotsRefinement(obj, varargin);
        
        degradeContinuity_kRefinement(obj, varargin);
        elevateContinuity_kRefinement(obj, varargin);
        degradeOrder(obj, varargin);
        elevateOrder(obj, varargin);
    end

    methods (Access = {?nurbs, ?knotVector, ?bSplineBasisFunctions, ?bSplineConnectivities})
        function knotVectorReconstruction(obj, varargin)
            constructorProcesses(obj, varargin{:});
        end
        refinementHandler(obj, varargin);
        exceptionsHandler(obj, varargin);
    end

    methods (Access = private)
        constructorProcesses(obj, varargin); % arguments sequence (knots, ...)
    end
    
    methods (Access = protected)
        sortKnots(obj);
        storeUniqueKnots(obj);
        findContinuity(obj);
        knotVectorValidityCheck(obj);
        findKnotSpanNumbers(obj);
        connectivitiesKnotPatch2BasisFunctions(obj);
        connectivitiesBasisFunction2KnotPatches(obj);
        validateNmetaprocess(obj);
    end

    
    %%  Events
    events
        localKnotsInsertionInduced
        localKnotsRemovalInduced
        localKnotsMovementInduced
        globalKnotsInsertionInduced
        globalKnotsRemovalInduced
        orderElevationInduced
        orderDegradationInduced
        knotRefinementNurbsNotification
        orderRefinementNurbsNotification
        localKnotRefinementTensorBSplinesNotification
        globalKnotRefinementTensorBSplinesNotification
        generalKnotsRefinementInduced
        knotsRenormalizationInduced
%         boundaryTopologiesNotification
    end

end