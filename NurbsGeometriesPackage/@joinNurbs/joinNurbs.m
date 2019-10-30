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

% NURBS geometry
classdef joinNurbs < nurbsGeometry

    methods
        function obj = joinNurbs(varargin)
            constructorData = constructorPreprocessor(varargin{:});
            obj@nurbsGeometry(constructorData{1:2});
            constructorPostprocessor(obj, constructorData{:}, varargin{1});
        end
        
    end
    
    methods (Access = private)
        handlingEvents(obj, varargin);
        addDefaultSignalSlots(obj);
    end
    
    methods (Static)
        function [controlPoints, newKnotVectors] = constructJoinedNurbs(nurbsObjects)
            coords = nurbsObjects(1).ControlPoints.coordinates;
            weights = nurbsObjects(1).ControlPoints.weights;
            switch nurbsObjects(1).ControlPoints.numberOfParametricCoordinates
                case 1
                    for frameIndex = 2:length(nurbsObjects)
                        coords = cat(1, coords, nurbsObjects(frameIndex).ControlPoints.coordinates(2:end, :));
                        weights = cat(1, weights, nurbsObjects(frameIndex).ControlPoints.weights(2:end, :));
                    end
                    
                    controlPoints = rationalControlPointsStructure(nurbsObjects(1).ControlPoints.typeOfCoordinates, coords, weights);
                    
                    numOfPatches = length(nurbsObjects);
                    patchSize = 1/numOfPatches;
                    patchSpan = [0 patchSize];

                    newKnotVectors = knotVector.empty(1, 0);
                    for index = 1:numOfPatches
                        newKnotVectors(1, index) = nurbsObjects(index).KnotVectors.copy;
                        newKnotVectors(index).normalizeKnots(patchSpan+(index-1)*patchSize);
                    end
                    
                    newKnots = newKnotVectors(1).knots(1:end-newKnotVectors(1).order+1);
                    for index = 2:numOfPatches-1
                        shift = newKnotVectors(index).order;
                        newKnots = [newKnots newKnotVectors(index).knots(shift:end-shift+1)];
                    end
%                     if isempty(index); index = 1; end
                    shift = newKnotVectors(index+1).order;
                    newKnots = [newKnots newKnotVectors(index+1).knots(shift:end)];
                    newKnotVectors = knotVector(newKnots);

                case 2
                    
                case 3
                    
            end
        end
        
    end
    
    events
        
    end
    
end


%%
function constructorData = constructorPreprocessor(varargin)

[constructorData{2}, constructorData{1}] = joinNurbs.constructJoinedNurbs(varargin{:});

end

function constructorPostprocessor(obj, varargin)

obj.GeometryProperties.SegmentNurbsObjects = varargin{3};
% obj.addDefaultSignalSlots;

end