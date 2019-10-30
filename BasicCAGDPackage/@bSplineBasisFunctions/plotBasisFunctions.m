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

function plotBasisFunctions(obj, varargin)

plotPreprocessor(obj, varargin{:});

plotFunctions(obj, varargin);

if obj.PlotSettings.plotDerivativesFlag
    plotDerivativeFunctions(obj);
end

end


%%  
function plotPreprocessor(obj, varargin)

if isempty(obj.findprop('PlotSettings'))
    obj.addprop('PlotSettings');
    if isempty(obj.findprop('figureHandles')); obj.addprop('figureHandles'); end
    obj.addprop('plotHandles');
    obj.PlotSettings.fontSize               = 16;
    obj.PlotSettings.labelsSwitch           = 1;
    obj.PlotSettings.titleType              = 'Full';
    obj.PlotSettings.plotDerivativesFlag    = 0;
    obj.PlotSettings.clearPlot              = 1;
    if isa(obj, 'rationalBSplineBasisFunctions')
        obj.PlotSettings.functionsName          = 'Rational B-Spline';
        obj.PlotSettings.functionsSymbol        = 'R';
    elseif isa(obj, 'bSplineBasisFunctions')
        obj.PlotSettings.functionsName          = 'B-Spline';
        obj.PlotSettings.functionsSymbol        = 'N';
    end
end

if isempty(obj.evaluationsPerFunction)
    obj.evaluatePerFunction('reshape');
    obj.figureHandles = figure;
end
if isempty(obj.figureHandles)
    obj.figureHandles = figure;
end

obj.PlotSettings.holdFlag   = 'all';
obj.PlotSettings.plotPlane  = '1-2';
obj.PlotSettings.lineWidth  = 1;
obj.PlotSettings.lineColor  = 'b';
if nargin > 1
    [fontFlag, fontPosition]    = searchArguments(varargin, 'FontSize', 'numeric');
    labelsFlag                  = searchArguments(varargin, 'Labels');
    [titleFlag, titlePosition]  = searchArguments(varargin, 'TitleType', 'char');
    [planeFlag, planePosition]  = searchArguments(varargin, 'PlotPlane', 'char');
    [linWdFlag, linWdPosition]  = searchArguments(varargin, 'LineWidth', 'numeric');
    [linClFlag, linClPosition]  = searchArguments(varargin, 'LineColor', 'char');
    [clfFlag, clfPosition]      = searchArguments(varargin, 'ClearPlot', 'numeric');
    
    if searchArguments(varargin, 'HoldPlots'); obj.PlotSettings.holdFlag = 'on';
    else obj.PlotSettings.holdFlag = 'all';
    end
    if fontFlag; obj.PlotSettings.fontSize = varargin{fontPosition}; end
    if labelsFlag; obj.PlotSettings.labelsSwitch = 1; end
    if titleFlag; obj.PlotSettings.titleType = varargin{titlePosition}; end
    if planeFlag; obj.PlotSettings.plotPlane = varargin{planePosition}; end
    if linWdFlag; obj.PlotSettings.lineWidth = varargin{linWdPosition}; end
    if linClFlag; obj.PlotSettings.lineColor = varargin{linClPosition}; end
    if clfFlag;   obj.PlotSettings.clearPlot = varargin{clfPosition}; end
    
    
    if searchArguments(varargin, 'PlotDerivatives')
        if size(obj.evaluationsPerFunction, 3) > 1
            obj.PlotSettings.plotDerivativesFlag = 1;
            if length(obj.figureHandles) == 3
            elseif length(obj.figureHandles) == 1
                for derivativeOrderIndex = 2:size(obj.evaluationsPerFunction, 3)
                    obj.figureHandles(derivativeOrderIndex) = figure;
                end
            else
                for derivativeOrderIndex = 1:size(obj.evaluationsPerFunction, 3)
                    obj.figureHandles(derivativeOrderIndex) = figure;
                end
            end
        else
            if isempty(obj.figureHandles)
                obj.figureHandles = figure;
            else
                obj.figureHandles = obj.figureHandles(1);
            end
            obj.PlotSettings.plotDerivativesFlag = 0;
            warning('No calculated derivatives found.');
        end
    else
        if isempty(obj.figureHandles)
            obj.figureHandles = figure;
        else
            obj.figureHandles = obj.figureHandles(1);
        end
        obj.PlotSettings.plotDerivativesFlag = 0;
    end
end



end


%%  
function plotFunctions(obj, varargin)

figure(obj.figureHandles(1)); if obj.PlotSettings.clearPlot; clf; end; hold(obj.PlotSettings.holdFlag);

switch obj.PlotSettings.plotPlane
    case '1-2'
        if iscell(obj.evaluationPoints)
            for functionIndex = 1:obj.numberOfEvaluatedBasisFunctions
                obj.plotHandles = plot3(obj.evaluationPointsPerFunction{functionIndex}, obj.evaluationsPerFunction{functionIndex}(:, 1), zeros(1, length(obj.evaluationPointsPerFunction{functionIndex})), 'LineWidth', obj.PlotSettings.lineWidth, 'Color', obj.PlotSettings.lineColor);
            end
        else
            positionsPerKnotPatch = (1:obj.numberOfEvaluationPointsPerKnotPatch);
            for functionIndex = 1:obj.KnotVector.order
                shift = (functionIndex-1)*obj.numberOfEvaluationPointsPerKnotPatch;
                obj.plotHandles = plot3(obj.evaluationPointsPerFunction(shift+positionsPerKnotPatch, :), obj.evaluationsPerFunction(shift+positionsPerKnotPatch, :, 1), zeros(1, length(positionsPerKnotPatch)), 'LineWidth', obj.PlotSettings.lineWidth, 'Color', obj.PlotSettings.lineColor);
            end
        end
    case '2-3'
        if iscell(obj.evaluationPoints)
            for functionIndex = 1:obj.numberOfEvaluatedBasisFunctions
                obj.plotHandles = plot3(zeros(1, length(obj.evaluationPointsPerFunction{functionIndex})), obj.evaluationPointsPerFunction{functionIndex}, obj.evaluationsPerFunction{functionIndex}(:, 1), 'LineWidth', obj.PlotSettings.lineWidth, 'Color', obj.PlotSettings.lineColor);
            end
        else
            positionsPerKnotPatch = (1:obj.numberOfEvaluationPointsPerKnotPatch);
            for functionIndex = 1:obj.KnotVector.order
                shift = (functionIndex-1)*obj.numberOfEvaluationPointsPerKnotPatch;
                obj.plotHandles = plot3(zeros(1, length(positionsPerKnotPatch)), obj.evaluationPointsPerFunction(shift+positionsPerKnotPatch, :), obj.evaluationsPerFunction(shift+positionsPerKnotPatch, :, 1), 'LineWidth', obj.PlotSettings.lineWidth, 'Color', obj.PlotSettings.lineColor);
            end
        end
    case '1-3'
        if iscell(obj.evaluationPoints)
            for functionIndex = 1:obj.numberOfEvaluatedBasisFunctions
                obj.plotHandles = plot3(obj.evaluationPointsPerFunction{functionIndex}, zeros(1, length(obj.evaluationPointsPerFunction{functionIndex})), obj.evaluationsPerFunction{functionIndex}(:, 1), 'LineWidth', obj.PlotSettings.lineWidth, 'Color', obj.PlotSettings.lineColor);
            end
        else
            positionsPerKnotPatch = (1:obj.numberOfEvaluationPointsPerKnotPatch);
            for functionIndex = 1:obj.KnotVector.order
                shift = (functionIndex-1)*obj.numberOfEvaluationPointsPerKnotPatch;
                obj.plotHandles = plot3(obj.evaluationPointsPerFunction(shift+positionsPerKnotPatch, :), zeros(1, length(positionsPerKnotPatch)), obj.evaluationsPerFunction(shift+positionsPerKnotPatch, :, 1), 'LineWidth', obj.PlotSettings.lineWidth, 'Color', obj.PlotSettings.lineColor);
            end
        end
end


xlabel('u', 'Interpreter', 'latex', 'FontSize', obj.PlotSettings.fontSize);
ylabel('N(u)', 'Interpreter', 'latex', 'FontSize', obj.PlotSettings.fontSize);
switch obj.PlotSettings.titleType
    case 'Short'
        title(['\makebox[4in][c]{' obj.PlotSettings.functionsName ' functions of degree ' num2str(obj.degree) '}'], ...
            'Interpreter', 'latex', 'FontSize', obj.PlotSettings.fontSize, 'HorizontalAlignment', 'center');
    case 'Full'
        title({['\makebox[4in][c]{' obj.PlotSettings.functionsName ' functions of degree ' num2str(obj.degree) '}']
            ['\makebox[4in][c]{U = [ ' num2str(obj.KnotVector.knots) ' ]}']}, ...
            'Interpreter', 'latex', 'FontSize', obj.PlotSettings.fontSize, 'HorizontalAlignment', 'center');
end

if iscell(obj.evaluationPoints)
    if obj.PlotSettings.labelsSwitch
        for functionIndex = 1:obj.numberOfEvaluatedBasisFunctions
            % Setting the arrow label at the maximum absolute value of the function
            [~, positionOfMaxValue] = max(obj.evaluationsPerFunction{functionIndex}(:, 1));

            % Forming the label text
            label = ['$\downarrow$' ' $' obj.PlotSettings.functionsSymbol '_{' num2str(obj.evaluatedBasisFunctions(functionIndex)) ', ' num2str(obj.degree) '}$'];
            switch obj.PlotSettings.plotPlane
                case '1-2'
                    text(obj.evaluationPointsPerFunction{functionIndex}(positionOfMaxValue), obj.evaluationsPerFunction{functionIndex}(positionOfMaxValue, 1), 0, ...
                        label,'VerticalAlignment','bottom', 'Interpreter', 'latex', 'FontSize', obj.PlotSettings.fontSize-2);
                case '2-3'
                    text(0, obj.evaluationPointsPerFunction{functionIndex}(positionOfMaxValue), obj.evaluationsPerFunction{functionIndex}(positionOfMaxValue, 1), ...
                        label,'VerticalAlignment','bottom', 'Interpreter', 'latex', 'FontSize', obj.PlotSettings.fontSize-2);
                case '1-3'
                    text(obj.evaluationPointsPerFunction{functionIndex}(positionOfMaxValue), 0, obj.evaluationsPerFunction{functionIndex}(positionOfMaxValue, 1), ...
                        label,'VerticalAlignment','bottom', 'Interpreter', 'latex', 'FontSize', obj.PlotSettings.fontSize-2);
            end
        end
    end
else
    if obj.PlotSettings.labelsSwitch
        for functionIndex = 1:obj.numberOfEvaluatedBasisFunctions
            % Setting the arrow label at the maximum absolute value of the function
            [~, positionOfMaxValue] = max(obj.evaluationsPerFunction(:, functionIndex, 1));
            
            % Forming the label text
            label = ['$\downarrow$' ' $' obj.PlotSettings.functionsSymbol '_{' num2str(obj.evaluatedBasisFunctions(functionIndex)) ', ' num2str(obj.degree) '}$'];
            switch obj.PlotSettings.plotPlane
                case '1-2'
                    text(obj.evaluationPointsPerFunction(positionOfMaxValue, functionIndex), obj.evaluationsPerFunction(positionOfMaxValue, functionIndex, 1), 0, label,'VerticalAlignment','bottom', 'Interpreter', 'latex', 'FontSize', obj.PlotSettings.fontSize-2);
                case '2-3'
                    text(0, obj.evaluationPointsPerFunction(positionOfMaxValue, functionIndex), obj.evaluationsPerFunction(positionOfMaxValue, functionIndex, 1), label,'VerticalAlignment','bottom', 'Interpreter', 'latex', 'FontSize', obj.PlotSettings.fontSize-2);
                case '1-3'
                    text(obj.evaluationPointsPerFunction(positionOfMaxValue, functionIndex), 0, obj.evaluationsPerFunction(positionOfMaxValue, functionIndex, 1), label,'VerticalAlignment','bottom', 'Interpreter', 'latex', 'FontSize', obj.PlotSettings.fontSize-2);
            end
        end
    end
end

axesHandle = gca;
grid on
set(axesHandle, 'YGrid', 'off', 'XTickMode', 'manual', 'Xtick', obj.KnotVector.knotsWithoutMultiplicities, 'LineWidth', 2, 'LineStyleOrder', '-');
xlim([obj.KnotVector.knotsWithoutMultiplicities(1) obj.KnotVector.knotsWithoutMultiplicities(end)]);

end


%%  
function plotDerivativeFunctions(obj)

for derivativeOrderIndex = 2:length(obj.figureHandles)
    
    figure(obj.figureHandles(derivativeOrderIndex)); if obj.PlotSettings.clearPlot; clf; end; hold(obj.PlotSettings.holdFlag);
    
    if iscell(obj.evaluationPoints)
        for functionIndex = 1:obj.numberOfEvaluatedBasisFunctions
            obj.plotHandles = plot(obj.evaluationPointsPerFunction{functionIndex}, obj.evaluationsPerFunction{functionIndex}(:, derivativeOrderIndex));
        end
    else
        positionsPerKnotPatch = (1:obj.numberOfEvaluationPointsPerKnotPatch);
        for functionIndex = 1:obj.KnotVector.order
            shift = (functionIndex-1)*obj.numberOfEvaluationPointsPerKnotPatch;
            obj.plotHandles = plot(obj.evaluationPointsPerFunction(shift+positionsPerKnotPatch, :), obj.evaluationsPerFunction(shift+positionsPerKnotPatch, :, derivativeOrderIndex));
        end
    end

    xlabel('u', 'Interpreter', 'latex', 'FontSize', obj.PlotSettings.fontSize);
    ylabel(['d' num2str(derivativeOrderIndex-1) 'N(u)'], 'Interpreter', 'latex', 'FontSize', obj.PlotSettings.fontSize);
    switch obj.PlotSettings.titleType
        case 'Short'
            title(['\makebox[4in][c]{Order ' num2str(derivativeOrderIndex-1) ' derivative of ' obj.PlotSettings.functionsName ' functions of degree ' num2str(obj.degree) '}'], ...
                'Interpreter', 'latex', 'FontSize', obj.PlotSettings.fontSize, 'HorizontalAlignment', 'center');
        case 'Full'
            title({['\makebox[4in][c]{Order ' num2str(derivativeOrderIndex-1) ' derivative of ' obj.PlotSettings.functionsName ' functions of degree ' num2str(obj.degree) '}']
                ['\makebox[4in][c]{U = [ ' num2str(obj.KnotVector.knots) ' ]}']}, ...
                'Interpreter', 'latex', 'FontSize', obj.PlotSettings.fontSize, 'HorizontalAlignment', 'center');
    end
    
    if iscell(obj.evaluationPoints)
        if obj.PlotSettings.labelsSwitch
            for functionIndex = 1:obj.numberOfEvaluatedBasisFunctions
                % Setting the arrow label at the maximum absolute value of the function
                [~, positionOfMaxValue] = max(obj.evaluationsPerFunction{functionIndex}(:, derivativeOrderIndex));
                
                % Forming the label text
                label = ['$\downarrow$' ' $' obj.PlotSettings.functionsSymbol '_{' num2str(obj.evaluatedBasisFunctions(functionIndex)) ', ' num2str(obj.degree) '}$'];
                text(obj.evaluationPointsPerFunction{functionIndex}(positionOfMaxValue), obj.evaluationsPerFunction{functionIndex}(positionOfMaxValue, derivativeOrderIndex), ...
                    label,'VerticalAlignment','bottom', 'Interpreter', 'latex', 'FontSize', obj.PlotSettings.fontSize-2);
            end
        end
    else
        if obj.PlotSettings.labelsSwitch
            for functionIndex = 1:obj.numberOfEvaluatedBasisFunctions
                % Setting the arrow label at the maximum absolute value of the function
                [~, positionOfMaxValue] = max(obj.evaluationsPerFunction(:, functionIndex, derivativeOrderIndex));
                
                % Forming the label text
                label = ['$\downarrow$' ' $' obj.PlotSettings.functionsSymbol '_{' num2str(obj.evaluatedBasisFunctions(functionIndex)) ', ' num2str(obj.degree) '}$'];
                text(obj.evaluationPointsPerFunction(positionOfMaxValue, functionIndex), obj.evaluationsPerFunction(positionOfMaxValue, functionIndex, derivativeOrderIndex), label,'VerticalAlignment','bottom', 'Interpreter', 'latex', 'FontSize', obj.PlotSettings.fontSize-2);
            end
        end
    end

    axesHandle = gca;
    grid on
    set(axesHandle, 'YGrid', 'off', 'XTickMode', 'manual', 'Xtick', obj.KnotVector.knotsWithoutMultiplicities, 'LineWidth', 2, 'LineStyleOrder', '-');
    xlim([obj.KnotVector.knotsWithoutMultiplicities(1) obj.KnotVector.knotsWithoutMultiplicities(end)]);

end

end