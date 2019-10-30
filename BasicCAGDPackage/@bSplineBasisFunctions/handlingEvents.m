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

function handlingEvents(obj, eventData)

try
    
    if isa(eventData.Source, 'knotVector')
        knotsRefinementEvents(obj, eventData);
    end
    
catch Exception
    rethrow(Exception);
end

end


%%  
function knotsRefinementEvents(obj, eventData)

eventData.Source.refinementHandler;
obj.constructInformation;
plotOptions = {};

switch eventData.EventName
    case 'localKnotsInsertionInduced'
        if ~isempty(obj.evaluationsPerKnotPatch)
            localInsertion(obj, eventData);
            if ~isempty(obj.evaluationsPerFunction)
                obj.evaluatePerFunction('reshape');
            end
            plotOptions = {}; %'HoldPlots'
        end
        
    case 'localKnotsRemovalInduced'
        if ~isempty(obj.evaluationsPerKnotPatch)
            localRemoval(obj, eventData);
            if ~isempty(obj.evaluationsPerFunction)
                obj.evaluatePerFunction('reshape');
            end
            plotOptions = {}; %'HoldPlots'
        end
        
    case 'localKnotsMovementInduced'
        obj.refreshData;
        
    case 'globalKnotsInsertionInduced'
        obj.refreshData;
        
    case 'globalKnotsRemovalInduced'
        obj.refreshData;
        
    case 'orderElevationInduced'
        obj.refreshData;
        
    case 'orderDegradationInduced'
        obj.refreshData;
        
    case 'generalKnotsRefinementInduced'
        obj.refreshData;
        
    case 'knotsRenormalizationInduced'
        tempKnots = obj.evaluationPoints;
        obj.evaluationPoints = (tempKnots-tempKnots(1))/(tempKnots(end)-tempKnots(1));
        obj.evaluationPoints = obj.evaluationPoints*(obj.KnotVector.knotsWithoutMultiplicities(end)-obj.KnotVector.knotsWithoutMultiplicities(1))+obj.KnotVector.knotsWithoutMultiplicities(1);
        evaluationsInKnotPatch = (1:obj.numberOfEvaluationPointsPerKnotPatch);
        for evalKnotPatchIndex = 1:obj.numberOfEvaluatedKnotPatches
            for localSpanIndex = 1:obj.KnotVector.order
                shift                   = (obj.KnotVector.order-localSpanIndex)*obj.numberOfEvaluationPointsPerKnotPatch;
                currentBasisFunctions   = obj.evaluatedFunctions2FunctionsInStructure(obj.KnotVector.knotPatch2BasisFunctions(obj.EvaluationSettings.requestedEvaluationKnotPatches(evalKnotPatchIndex), localSpanIndex));
                obj.evaluationPointsPerFunction(evaluationsInKnotPatch+shift, currentBasisFunctions) = obj.evaluationPoints(:, evalKnotPatchIndex);
            end
        end
    
end

if ~isempty(obj.findprop('plotHandles'))
   obj.plotBasisFunctions(plotOptions{:});
end

end

%%  
function localInsertion(obj, eventData)

for refineIndex = 1:length(eventData.Source.RefineData.newRefinedKnotPatches)
            
    evalSettings = obj.EvaluationSettings.copy;
    evalSettings.setRequestedEvaluationKnotPatches(eventData.Source.RefineData.newRefinedKnotPatches{refineIndex});
    newEvaluations = bSplineBasisFunctions(knotVector(obj.KnotVector.knots), 'Evaluate', evalSettings);

    leftOldKnotPatches                  = eventData.Source.RefineData.newRefinedKnotPatches{refineIndex}(1)-1;
    rightOldKnotPatches                 = eventData.Source.RefineData.newRefinedKnotPatches{refineIndex}(end)-eventData.Source.RefineData.insertedNewKnotPatches(refineIndex)+1;
    
    leftOldEvaluatedKnotPatches         = obj.evaluationsPerKnotPatch(:, :, 1:leftOldKnotPatches, :);
    rightOldEvaluatedKnotPatches        = obj.evaluationsPerKnotPatch(:, :, rightOldKnotPatches:end, :);
    obj.evaluationsPerKnotPatch         = cat(3, leftOldEvaluatedKnotPatches, newEvaluations.evaluationsPerKnotPatch, rightOldEvaluatedKnotPatches);
    
    leftOldEvaluationPoints             = obj.evaluationPoints(:, 1:leftOldKnotPatches);
    rightOldEvaluationPoints            = obj.evaluationPoints(:, rightOldKnotPatches:end);
    obj.evaluationPoints                = cat(2, leftOldEvaluationPoints, newEvaluations.evaluationPoints, rightOldEvaluationPoints);
    
    if ~isempty(obj.parent2ParametricJacobians)
        leftOldparent2ParametricJacobians   = obj.parent2ParametricJacobians(1:leftOldKnotPatches);
        rightOldparent2ParametricJacobians  = obj.parent2ParametricJacobians(rightOldKnotPatches:end);
        obj.parent2ParametricJacobians      = cat(2, leftOldparent2ParametricJacobians, newEvaluations.parent2ParametricJacobians, rightOldparent2ParametricJacobians);
    end
end

obj.EvaluationSettings.setRequestedEvaluationKnotPatches(1:size(obj.evaluationsPerKnotPatch, 3));
obj.numberOfEvaluatedKnotPatches    = length(obj.EvaluationSettings.requestedEvaluationKnotPatches);
obj.totalNumberOfEvaluationPoints   = obj.numberOfEvaluationPointsPerKnotPatch*obj.numberOfEvaluatedKnotPatches;

end

%%  
function localRemoval(obj, eventData)

for refineIndex = 1:length(eventData.Source.RefineData.newRefinedKnotPatches)

    evalSettings = obj.EvaluationSettings.copy;
    evalSettings.setRequestedEvaluationKnotPatches(eventData.Source.RefineData.newRefinedKnotPatches{refineIndex});
    newEvaluations = bSplineBasisFunctions(knotVector(obj.KnotVector.knots), 'Evaluate', evalSettings);
    
    leftOldKnotPatches                  = eventData.Source.RefineData.newRefinedKnotPatches{refineIndex}(1)-1;
    rightOldKnotPatches                 = eventData.Source.RefineData.newRefinedKnotPatches{refineIndex}(end)+eventData.Source.RefineData.contiguousMergedKnotPatches(refineIndex)+1;
    
    leftOldEvaluatedKnotPatches         = obj.evaluationsPerKnotPatch(:, :, 1:leftOldKnotPatches, :);
    rightOldEvaluatedKnotPatches        = obj.evaluationsPerKnotPatch(:, :, rightOldKnotPatches:end, :);
    obj.evaluationsPerKnotPatch         = cat(3, leftOldEvaluatedKnotPatches, newEvaluations.evaluationsPerKnotPatch, rightOldEvaluatedKnotPatches);
    
    leftOldEvaluationPoints             = obj.evaluationPoints(:, 1:leftOldKnotPatches);
    rightOldEvaluationPoints            = obj.evaluationPoints(:, rightOldKnotPatches:end);
    obj.evaluationPoints                = cat(2, leftOldEvaluationPoints, newEvaluations.evaluationPoints, rightOldEvaluationPoints);
    
    leftOldparent2ParametricJacobians   = obj.parent2ParametricJacobians(1:leftOldKnotPatches);
    rightOldparent2ParametricJacobians  = obj.parent2ParametricJacobians(rightOldKnotPatches:end);
    obj.parent2ParametricJacobians      = cat(2, leftOldparent2ParametricJacobians, newEvaluations.parent2ParametricJacobians, rightOldparent2ParametricJacobians);
    
end

obj.EvaluationSettings.setRequestedEvaluationKnotPatches(1:size(obj.evaluationsPerKnotPatch, 3));
obj.numberOfEvaluatedKnotPatches    = length(obj.EvaluationSettings.requestedEvaluationKnotPatches);
obj.totalNumberOfEvaluationPoints   = obj.numberOfEvaluationPointsPerKnotPatch*obj.numberOfEvaluatedKnotPatches;

end