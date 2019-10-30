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

function evaluatePerFunction(obj, varargin)

[functionsFlag, funPosition] = searchArguments(varargin, 'Function', 'numeric');

if functionsFlag; evaluateSpecificFunctions(obj, funPosition, varargin{:});
else reshapeAllFunctionsInKnotPatches(obj, varargin{:});
end

end


%% 
function reshapeAllFunctionsInKnotPatches(obj, varargin)

if isempty(obj.evaluationsPerKnotPatch) || ~searchArguments(varargin, 'reshape')
    obj.evaluatePerKnotPatch(varargin{:});
end

if length(obj.EvaluationSettings.requestedEvaluationKnotPatches) == obj.KnotVector.numberOfKnotPatches
    obj.evaluatedBasisFunctions = 0:(obj.KnotVector.totalNumberOfKnots-obj.KnotVector.order-1);
else obj.evaluatedBasisFunctions = reshape(repmat(obj.KnotVector.knotPatch2KnotSpanNumber(obj.EvaluationSettings.requestedEvaluationKnotPatches), obj.KnotVector.order, 1)-repmat(((obj.KnotVector.order:-1:1)-1)', 1, length(obj.EvaluationSettings.requestedEvaluationKnotPatches)), [], 1)';
end
obj.evaluatedBasisFunctions                 = filterUniqueSortedVectorElements(sort(obj.evaluatedBasisFunctions));
obj.numberOfEvaluatedBasisFunctions         = length(obj.evaluatedBasisFunctions);
obj.evaluatedFunctions2FunctionsInStructure = zeros(1, max(obj.evaluatedBasisFunctions)+obj.KnotVector.order);
for index = 1:obj.numberOfEvaluatedBasisFunctions; obj.evaluatedFunctions2FunctionsInStructure(obj.evaluatedBasisFunctions(index)+1) = index; end
    
if ~iscell(obj.evaluationsPerKnotPatch)
    obj.numberOfEvaluationPointsPerFunction = obj.numberOfEvaluationPointsPerKnotPatch*min(obj.KnotVector.order, obj.numberOfEvaluatedKnotPatches);
    obj.evaluationsPerFunction              = zeros(obj.numberOfEvaluationPointsPerFunction, obj.numberOfEvaluatedBasisFunctions, obj.EvaluationSettings.requestedDerivativesOrder+1);
    obj.evaluationPointsPerFunction         = zeros(obj.numberOfEvaluationPointsPerFunction, obj.numberOfEvaluatedBasisFunctions);
    
    evaluationsInKnotPatch = (1:obj.numberOfEvaluationPointsPerKnotPatch);
    for derivativeOrderIndex = 1:obj.EvaluationSettings.requestedDerivativesOrder+1
        for evalKnotPatchIndex = 1:obj.numberOfEvaluatedKnotPatches
            for localSpanIndex = 1:obj.KnotVector.order
                shift                   = (obj.KnotVector.order-localSpanIndex)*obj.numberOfEvaluationPointsPerKnotPatch;
                currentBasisFunctions   = obj.evaluatedFunctions2FunctionsInStructure(obj.KnotVector.knotPatch2BasisFunctions(obj.EvaluationSettings.requestedEvaluationKnotPatches(evalKnotPatchIndex), localSpanIndex));
                obj.evaluationsPerFunction(evaluationsInKnotPatch+shift, currentBasisFunctions, derivativeOrderIndex) = ...
                    obj.evaluationsPerKnotPatch(localSpanIndex, :, evalKnotPatchIndex, derivativeOrderIndex)';
                obj.evaluationPointsPerFunction(evaluationsInKnotPatch+shift, currentBasisFunctions) = obj.evaluationPoints(:, evalKnotPatchIndex);
            end
        end
    end
    
else
    obj.numberOfEvaluationPointsPerFunction = zeros(1, obj.numberOfEvaluatedBasisFunctions);
    obj.evaluationsPerFunction              = cell(1, obj.numberOfEvaluatedBasisFunctions);
    obj.evaluationPointsPerFunction         = cell(1, obj.numberOfEvaluatedBasisFunctions);
    
    for derivativeOrderIndex = 1:obj.EvaluationSettings.requestedDerivativesOrder+1
        for evalKnotPatchIndex = 1:obj.numberOfEvaluatedKnotPatches
            evaluationsInKnotPatch = (1:obj.numberOfEvaluationPointsPerKnotPatch(evalKnotPatchIndex));
            for localSpanIndex = 1:obj.KnotVector.order
                shift                   = (obj.KnotVector.order-localSpanIndex)*obj.numberOfEvaluationPointsPerKnotPatch(evalKnotPatchIndex);
                currentBasisFunctions   = obj.evaluatedFunctions2FunctionsInStructure(obj.KnotVector.knotPatch2BasisFunctions(obj.EvaluationSettings.requestedEvaluationKnotPatches(evalKnotPatchIndex), localSpanIndex));
                obj.evaluationsPerFunction{currentBasisFunctions}(evaluationsInKnotPatch+shift, derivativeOrderIndex) = ...
                    obj.evaluationsPerKnotPatch{evalKnotPatchIndex}(localSpanIndex, :, derivativeOrderIndex)';
                obj.evaluationPointsPerFunction{currentBasisFunctions}(evaluationsInKnotPatch+shift) = obj.evaluationPoints{evalKnotPatchIndex};
                obj.numberOfEvaluationPointsPerFunction(currentBasisFunctions) = obj.numberOfEvaluationPointsPerFunction(currentBasisFunctions)+obj.numberOfEvaluationPointsPerKnotPatch(evalKnotPatchIndex);
            end
        end
    end

end

end


%%  
function evaluateSpecificFunctions(obj, funPosition, varargin)

if isempty(obj.findprop('basisFunctionsPerKnotPatch')); obj.addprop('basisFunctionsPerKnotPatch'); end

obj.evaluatedBasisFunctions         = varargin{funPosition};
obj.numberOfEvaluatedBasisFunctions = length(obj.evaluatedBasisFunctions);
obj.requestedEvaluationKnotPatches = [];
for functionIndex = 1:obj.numberOfEvaluatedBasisFunctions
    obj.requestedEvaluationKnotPatches = cat(2, obj.requestedEvaluationKnotPatches, obj.KnotVector.basisFunction2KnotPatches{obj.evaluatedBasisFunctions(functionIndex)+1});
end
obj.requestedEvaluationKnotPatches = filterUniqueSortedVectorElements(sort(obj.requestedEvaluationKnotPatches));
obj.evaluatePerKnotPatch(varargin{:}, 'KnotSpans', obj.requestedEvaluationKnotPatches);

obj.evaluatedFunctions2FunctionsInStructure = zeros(1, max(obj.evaluatedBasisFunctions)+obj.KnotVector.order);
for index = 1:obj.numberOfEvaluatedBasisFunctions; obj.evaluatedFunctions2FunctionsInStructure(obj.evaluatedBasisFunctions(index)+1) = index; end

obj.basisFunctionsPerKnotPatch = cell(1, obj.numberOfEvaluatedKnotPatches);
for patchIndex = 1:obj.numberOfEvaluatedKnotPatches
    obj.basisFunctionsPerKnotPatch{patchIndex} = find(obj.evaluatedFunctions2FunctionsInStructure(obj.KnotVector.knotPatch2BasisFunctions(obj.requestedEvaluationKnotPatches(patchIndex), :)));
end

if ~iscell(obj.evaluationsPerKnotPatch)
    obj.numberOfEvaluationPointsPerFunction = obj.numberOfEvaluationPointsPerKnotPatch*min(obj.KnotVector.order, obj.numberOfEvaluatedKnotPatches);
    obj.evaluationsPerFunction              = zeros(obj.numberOfEvaluationPointsPerFunction, obj.numberOfEvaluatedBasisFunctions, obj.requestedDerivativesOrder+1);
    obj.evaluationPointsPerFunction         = zeros(obj.numberOfEvaluationPointsPerFunction, obj.numberOfEvaluatedBasisFunctions);
    
    evaluationsInKnotPatch                  = (1:obj.numberOfEvaluationPointsPerKnotPatch);
    for derivativeOrderIndex = 1:obj.requestedDerivativesOrder+1
        for evalKnotPatchIndex = 1:obj.numberOfEvaluatedKnotPatches
            for localSpanIndex = obj.basisFunctionsPerKnotPatch{evalKnotPatchIndex}
                shift                   = (obj.KnotVector.order-localSpanIndex)*obj.numberOfEvaluationPointsPerKnotPatch;
                currentBasisFunctions   = obj.evaluatedFunctions2FunctionsInStructure(obj.KnotVector.knotPatch2BasisFunctions(obj.requestedEvaluationKnotPatches(evalKnotPatchIndex), localSpanIndex));
                obj.evaluationsPerFunction(evaluationsInKnotPatch+shift, currentBasisFunctions, derivativeOrderIndex) = ...
                    obj.evaluationsPerKnotPatch(localSpanIndex, :, evalKnotPatchIndex, derivativeOrderIndex)';
                obj.evaluationPointsPerFunction(evaluationsInKnotPatch+shift, currentBasisFunctions) = obj.evaluationPoints(:, evalKnotPatchIndex);
            end
        end
    end
    
else
    obj.numberOfEvaluationPointsPerFunction = zeros(1, obj.numberOfEvaluatedBasisFunctions);
    obj.evaluationsPerFunction              = cell(1, obj.numberOfEvaluatedBasisFunctions);
    obj.evaluationPointsPerFunction         = cell(1, obj.numberOfEvaluatedBasisFunctions);
    
    for derivativeOrderIndex = 1:obj.requestedDerivativesOrder+1
        for evalKnotPatchIndex = 1:obj.numberOfEvaluatedKnotPatches
            evaluationsInKnotPatch = (1:obj.numberOfEvaluationPointsPerKnotPatch(evalKnotPatchIndex));
            for localSpanIndex = obj.basisFunctionsPerKnotPatch{evalKnotPatchIndex}
                shift                   = (obj.KnotVector.order-localSpanIndex)*obj.numberOfEvaluationPointsPerKnotPatch(evalKnotPatchIndex);
                currentBasisFunctions   = obj.evaluatedFunctions2FunctionsInStructure(obj.KnotVector.knotPatch2BasisFunctions(obj.requestedEvaluationKnotPatches(evalKnotPatchIndex), localSpanIndex));
                obj.evaluationsPerFunction{currentBasisFunctions}(evaluationsInKnotPatch+shift, derivativeOrderIndex) = ...
                    obj.evaluationsPerKnotPatch{evalKnotPatchIndex}(localSpanIndex, :, derivativeOrderIndex)';
                obj.evaluationPointsPerFunction{currentBasisFunctions}(evaluationsInKnotPatch+shift) = obj.evaluationPoints{evalKnotPatchIndex};
                obj.numberOfEvaluationPointsPerFunction(currentBasisFunctions) = obj.numberOfEvaluationPointsPerFunction(currentBasisFunctions)+obj.numberOfEvaluationPointsPerKnotPatch(evalKnotPatchIndex);
            end
        end
    end
    
end

end