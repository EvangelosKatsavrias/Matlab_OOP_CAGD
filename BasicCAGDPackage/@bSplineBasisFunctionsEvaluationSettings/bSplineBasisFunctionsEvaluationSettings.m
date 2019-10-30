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

classdef bSplineBasisFunctionsEvaluationSettings < handle & hgsetget & dynamicprops & matlab.mixin.Copyable
    
    properties (SetAccess = private)
        requestedPointsPattern
        requestedPoints
        requestedDerivativesOrder = 1
        requestedEvaluationKnotPatches
        parentDomain = [0 1]
    end
    
    methods
        
        function obj = bSplineBasisFunctionsEvaluationSettings(varargin) % (pointPatternType, points, derivatives, knotPatches, parentDomain)
            if nargin > 0
                switch varargin{1}
                    case 'RepetitiveUniformInKnotPatches'
                        obj.setRepetitiveUniformInKnotPatches(varargin{2:end});
                    case 'RepetitiveGivenInKnotPatches'
                        obj.setRepetitiveGivenInKnotPatches(varargin{2:end});
                    case 'ArbitraryGivenInKnotPatches'
                        obj.setArbitraryGivenInKnotPatches(varargin{2:end});
                    case 'ArbitraryGivenInDomain'
                        obj.setArbitraryGivenInDomain(varargin{2:end});
                    otherwise
                        throw(MException('bSplineBasisFunctionsEvaluationSettings:constructor', 'Provide valid data.'));
                end
            elseif nargin == 0
                obj.setRepetitiveUniformInKnotPatches;
            end
        end
        
        
        %% set methods
        function setRepetitiveUniformInKnotPatches(obj, varargin)
            obj.setRequestedPointsPattern('RepetitiveUniformInKnotPatches');
            obj.inputSettings(varargin{:});
        end
        
        function setRepetitiveGivenInKnotPatches(obj, varargin)
            obj.setRequestedPointsPattern('RepetitiveGivenInKnotPatches');
            obj.inputSettings(varargin{:});
        end
        
        function setArbitraryGivenInKnotPatches(obj, varargin)
            obj.setRequestedPointsPattern('ArbitraryGivenInKnotPatches');
            obj.inputSettings(varargin{:});
        end
        
        function setArbitraryGivenInDomain(obj, varargin)
            obj.setRequestedPointsPattern('ArbitraryGivenInDomain');
            obj.inputSettings(varargin{:});
        end

        function inputSettings(obj, varargin)
            if nargin > 1
                obj.setRequestedPoints(varargin{1});
            end
            if nargin > 2
                obj.setRequestedDerivativesOrder(varargin{2});
            end
            if nargin > 3
                obj.setRequestedEvaluationKnotPatches(varargin{3});
            end
            if nargin > 4
                obj.setParentDomain(varargin{4});
            end
        end
        
        function obj = setRequestedPointsPattern(obj, value)
            obj.requestedPointsPattern = value;
            switch value
                case 'RepetitiveUniformInKnotPatches'
                    if ~(isnumeric(obj.requestedPoints)&&isscalar(obj.requestedPoints))
                        obj.requestedPoints = 10;
                    end
                case 'RepetitiveGivenInKnotPatches'
                    if ~(isnumeric(obj.requestedPoints)&&length(obj.requestedPoints) > 1)
                        obj.requestedPoints = (0:0.1:1);
                    end
                case 'ArbitraryGivenInKnotPatches'
                    if ~iscell(obj.requestedPoints)
                        obj.requestedPoints = {[1 0.1 0.5 0.9 1]};
                    end
                case 'ArbitraryGivenInDomain'
                    if ~(isnumeric(obj.requestedPoints)&&length(obj.requestedPoints) > 1)
                        obj.requestedPoints = [0.1 0.5 0.9 1];
                    end
                otherwise; throw(MException('bSplineBasisFunctionsEvaluationSettings:mutatorRequestedPoints', ...
                        'Wrong input data, provide a valid string to indicate the form of the requested evaluation points. Valid options are: ''RepetitiveUniformInKnotPatches''(default), ''RepetitiveGivenInKnotPatches'', ''ArbitraryGivenInKnotPatches'', ''ArbitraryGivenInDomain''.'));
            end
        end

        function obj = setRequestedPoints(obj, value)
            
            msgID = 'bSplineBasisFunctionsEvaluationSettings:mutatorRequestedPoints';
            msg = 'Valid options are the following, corresponding to each point pattern case: ''RepetitiveUniformInKnotPatches'' -> a scalar number, ''RepetitiveGivenInKnotPatches'' -> a single dimensional array, ''ArbitraryGivenInKnotPatches'' -> a single dimensional cell with single dimensional arrays, where the first element in each array indicates the knot span number, ''ArbitraryGivenInDomain'' -> a single dimensional array.';
            
            switch obj.requestedPointsPattern
                
                case 'RepetitiveUniformInKnotPatches'
                    if ~(isscalar(value) && isnumeric(value))
                        throw(MException(msgID, ['Wrong input data, provide a single scalar number as the number of uniform evaluation points in a knot span. ' msg]));
                    end
                
                case 'RepetitiveGivenInKnotPatches'
                    if ~isnumeric(value); throw(MException(msgID, msg)); end
%                     if max(value) > 1 || min(value) < 0
%                         throw(MException(msgID, ['Wrong input data, provide a single dimensional array to indicate the evaluation points in a knot span. ' ...
%                             'The values should be given in the interval (0, 1)']));
%                     end
                    
                case 'ArbitraryGivenInDomain'
                    if ~isnumeric(value); throw(MException(msgID, msg)); end
                    
                case 'ArbitraryGivenInKnotPatches'
                    if ~iscell(value)
                        throw(MException(msgID, ['Wrong input data, provide an appropriate type of data to indicate the requested evaluation points. ' msg]));
                    end
                        
                otherwise
                    throw(MException(msgID, ['Wrong input data, provide an appropriate type of data to indicate the requested evaluation points. ' msg]));
                    
            end
            
            obj.requestedPoints = value;

        end

        function obj = setRequestedDerivativesOrder(obj, value)
            if ~isscalar(value); throw(MException('bSplineBasisFunctionsEvaluationSettings:mutatorRequestedPoints', ...
                                                  'Wrong input data, provide a single scalar number to indicate the maximum order of derivatives to be evaluated. The default value is presetted to zero.'));
            end
            obj.requestedDerivativesOrder = value;
        end
        
        function obj = setRequestedEvaluationKnotPatches(obj, value)
            if ~isvector(value) && ~isempty(value);
                throw(MException('bSplineBasisFunctionsEvaluationSettings:mutatorRequestedPoints', ...
                                 ['Wrong input data, provide a single dimensional array to indicate the knot spans of evaluation.'
                                  'This kind of information is not required for the point patterns: ''ArbitraryGivenInKnotPatches'' and ''ArbitraryGivenInDomain''.']));
            end
            obj.requestedEvaluationKnotPatches = value;
        end

        function obj = setParentDomain(obj, value)
            if ~isnumeric(value); throw(MException('bSplineBasisFunctionsEvaluationSettings:mutatorRequestedPoints', ...
                                                   'Wrong input data, provide a vector with two values, indicating the end values of the parent domain.')); end
            obj.parentDomain = value;
        end
        
    end

end