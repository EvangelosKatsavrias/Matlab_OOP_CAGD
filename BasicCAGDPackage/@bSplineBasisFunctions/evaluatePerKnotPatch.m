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

function evaluatePerKnotPatch(obj, varargin)

preprocessor(obj, varargin{:});

switch obj.EvaluationSettings.requestedPointsPattern
    case 'RepetitiveUniformInKnotPatches'
        evaluationsRepetitiveUniformInKnotPatch(obj);
        
    case 'RepetitiveGivenInKnotPatches'
        evaluationsRepetitiveGivenInKnotPatch(obj, varargin{:});
        
    case 'ArbitraryGivenInKnotPatches'
        evaluationsArbitraryGivenInKnotPatch(obj, varargin{:});
        
    case 'ArbitraryGivenInDomain'
        evaluationsArbitraryGivenInDomain(obj, varargin{:});
        
end

obj.evaluationsPerFunction = [];
obj.evaluatedKnotPatches2KnotPatchesInStructure = zeros();
for index = 1:obj.numberOfEvaluatedKnotPatches; obj.evaluatedKnotPatches2KnotPatchesInStructure(obj.EvaluationSettings.requestedEvaluationKnotPatches(index)) = index; end

end


%%  
function preprocessor(obj, varargin)

if max(obj.EvaluationSettings.requestedEvaluationKnotPatches) > obj.KnotVector.numberOfKnotPatches
    throw(MException(obj.ExceptionsData.msgID2, obj.ExceptionsData.FunctionsEvaluation.msg5));
end

end

%%  
function evaluationsRepetitiveUniformInKnotPatch(obj, varargin)

if isempty(obj.EvaluationSettings.requestedEvaluationKnotPatches);       obj.EvaluationSettings.setRequestedEvaluationKnotPatches(1:obj.KnotVector.numberOfKnotPatches);
elseif ~isvector(obj.EvaluationSettings.requestedEvaluationKnotPatches); throw(MException(obj.ExceptionsData.msgID2, obj.ExceptionsData.FunctionsEvaluation.msg7));
end

obj.numberOfEvaluatedKnotPatches            = length(obj.EvaluationSettings.requestedEvaluationKnotPatches);
obj.numberOfEvaluationPointsPerKnotPatch    = obj.EvaluationSettings.requestedPoints;
obj.totalNumberOfEvaluationPoints           = obj.numberOfEvaluationPointsPerKnotPatch*obj.numberOfEvaluatedKnotPatches;
obj.evaluationsPerKnotPatch                 = zeros(obj.KnotVector.order, obj.numberOfEvaluationPointsPerKnotPatch, obj.numberOfEvaluatedKnotPatches, obj.EvaluationSettings.requestedDerivativesOrder+1);
obj.evaluationPoints                        = zeros(obj.EvaluationSettings.requestedPoints, obj.numberOfEvaluatedKnotPatches);
obj.EvaluationSettings.setParentDomain([0 1]);
mappedData = obj.KnotVector.affineMapParentDomain2KnotPatches(obj.EvaluationSettings.parentDomain, obj.EvaluationSettings.requestedEvaluationKnotPatches);
obj.parent2ParametricJacobians              = mappedData.jacobians;
% obj.evaluationPoints                        = mappedData.mappedPoints;

knotPatchNumber = 1;
for knotPatch = obj.EvaluationSettings.requestedEvaluationKnotPatches
    [obj.evaluationsPerKnotPatch(:, :, knotPatchNumber, :), ~, obj.evaluationPoints(:, knotPatchNumber)] = obj.evaluateInSingleKnotPatch(knotPatch, obj.EvaluationSettings.requestedDerivativesOrder, 'PointsUniform', obj.EvaluationSettings.requestedPoints);
    knotPatchNumber = knotPatchNumber+1;    
end

end

%%  
function evaluationsRepetitiveGivenInKnotPatch(obj, varargin)

if isempty(obj.EvaluationSettings.requestedEvaluationKnotPatches);       obj.EvaluationSettings.setRequestedEvaluationKnotPatches(1:obj.KnotVector.numberOfKnotPatches);
elseif ~isvector(obj.EvaluationSettings.requestedEvaluationKnotPatches); throw(MException(obj.ExceptionsData.msgID2, obj.ExceptionsData.FunctionsEvaluation.msg7));
end

obj.numberOfEvaluatedKnotPatches            = length(obj.EvaluationSettings.requestedEvaluationKnotPatches);
obj.numberOfEvaluationPointsPerKnotPatch    = length(obj.EvaluationSettings.requestedPoints);
obj.totalNumberOfEvaluationPoints           = obj.numberOfEvaluationPointsPerKnotPatch*obj.numberOfEvaluatedKnotPatches;
obj.evaluationsPerKnotPatch                 = zeros(obj.KnotVector.order, obj.numberOfEvaluationPointsPerKnotPatch, obj.numberOfEvaluatedKnotPatches, obj.EvaluationSettings.requestedDerivativesOrder+1);
mappedData = obj.KnotVector.affineMapParentDomain2KnotPatches(obj.EvaluationSettings.parentDomain, obj.EvaluationSettings.requestedEvaluationKnotPatches, obj.EvaluationSettings.requestedPoints);
obj.parent2ParametricJacobians              = mappedData.jacobians;
obj.evaluationPoints                        = mappedData.mappedPoints;
obj.evaluationPoints                        = obj.evaluationPoints';

knotPatchNumber = 1;
for knotPatch = obj.EvaluationSettings.requestedEvaluationKnotPatches
    obj.evaluationsPerKnotPatch(:, :, knotPatchNumber, :) = obj.evaluateInSingleKnotPatch(knotPatch, obj.EvaluationSettings.requestedDerivativesOrder, 'PointsInParametricDomain', obj.evaluationPoints(:, knotPatchNumber), obj.numberOfEvaluationPointsPerKnotPatch);
    knotPatchNumber = knotPatchNumber+1;
end

end

%%  
function evaluationsArbitraryGivenInKnotPatch(obj, varargin)

if isempty(obj.EvaluationSettings.requestedEvaluationKnotPatches);       obj.EvaluationSettings.setRequestedEvaluationKnotPatches(1);
elseif ~isvector(obj.EvaluationSettings.requestedEvaluationKnotPatches); throw(MException(obj.ExceptionsData.msgID2, obj.ExceptionsData.FunctionsEvaluation.msg7));
end

obj.numberOfEvaluatedKnotPatches            = length(obj.EvaluationSettings.requestedEvaluationKnotPatches);
obj.numberOfEvaluationPointsPerKnotPatch    = zeros(1, length(obj.EvaluationSettings.requestedPoints));
for index = 1:length(obj.EvaluationSettings.requestedPoints); obj.numberOfEvaluationPointsPerKnotPatch(index) = length(obj.EvaluationSettings.requestedPoints{index}); end
obj.totalNumberOfEvaluationPoints           = sum(obj.numberOfEvaluationPointsPerKnotPatch);
[obj.parent2ParametricJacobians, obj.evaluationPoints] = obj.KnotVector.affineMapParentDomain2KnotPatches(obj.EvaluationSettings.parentDomain, obj.EvaluationSettings.requestedEvaluationKnotPatches, obj.EvaluationSettings.requestedPoints);
obj.evaluationsPerKnotPatch                 = cell(1, obj.numberOfEvaluatedKnotPatches);

knotPatchNumber = 1;
for knotPatch = obj.EvaluationSettings.requestedEvaluationKnotPatches
    obj.evaluationsPerKnotPatch{knotPatchNumber} = obj.evaluateInSingleKnotPatch(knotPatch, obj.EvaluationSettings.requestedDerivativesOrder, 'PointsInParametricDomain', obj.evaluationPoints{knotPatchNumber}, obj.numberOfEvaluationPointsPerKnotPatch(knotPatchNumber));
    knotPatchNumber = knotPatchNumber+1;
end

end

%%
function evaluationsArbitraryGivenInDomain(obj, varargin)

obj.EvaluationSettings.setRequestedPoints(sort(obj.EvaluationSettings.requestedPoints));
obj.totalNumberOfEvaluationPoints       = length(obj.EvaluationSettings.requestedPoints);
mappedData                              = obj.KnotVector.affineMapParentDomain2ParametricDomain(obj.EvaluationSettings.parentDomain, obj.EvaluationSettings.requestedPoints);
obj.parent2ParametricJacobians          = mappedData.jacobian;
obj.evaluationPoints                    = mappedData.mappedPoints;

% map evaluation points in bSpline patch to knot patches
knotPatches = [];
for evalPointIndex = 1:length(obj.evaluationPoints)
    knotPatch = find(obj.evaluationPoints(evalPointIndex) < obj.KnotVector.knotsWithoutMultiplicities, 1, 'first')-1;
    if isempty(knotPatch); knotPatch = obj.KnotVector.numberOfKnotPatches; end
    knotPatches = cat(2, knotPatches, knotPatch);
end
[obj.EvaluationSettings.requestedEvaluationKnotPatches, obj.numberOfEvaluationPointsPerKnotPatch] = filterUniqueSortedVectorElements(knotPatches);
obj.numberOfEvaluatedKnotPatches = length(obj.EvaluationSettings.requestedEvaluationKnotPatches);

% separate evaluation points and collect to knot patch evaluations
tempPoints              = obj.evaluationPoints;
evalPointsShift         = 0;
obj.evaluationPoints    = cell(1, obj.numberOfEvaluatedKnotPatches);
for knotPatchIndex = 1:obj.numberOfEvaluatedKnotPatches
    obj.evaluationPoints{knotPatchIndex} = tempPoints(evalPointsShift+1:evalPointsShift+obj.numberOfEvaluationPointsPerKnotPatch(knotPatchIndex));
    evalPointsShift = evalPointsShift +obj.numberOfEvaluationPointsPerKnotPatch(knotPatchIndex);
end

obj.evaluationsPerKnotPatch = cell(1, obj.numberOfEvaluatedKnotPatches);
knotPatchNumber             = 1;
for knotPatch = obj.EvaluationSettings.requestedEvaluationKnotPatches
    obj.evaluationsPerKnotPatch{knotPatchNumber} = obj.evaluateInSingleKnotPatch(knotPatch, obj.EvaluationSettings.requestedDerivativesOrder, 'PointsInParametricDomain', obj.evaluationPoints{knotPatchNumber}, obj.numberOfEvaluationPointsPerKnotPatch(knotPatchNumber));
    knotPatchNumber = knotPatchNumber+1;
end

end