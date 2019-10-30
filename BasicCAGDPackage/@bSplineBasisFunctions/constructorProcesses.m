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

% obj.ExceptionsData = obj.setExceptionsData;

if nargin == 1
    obj.KnotVector = knotVector([0 0 0 1 1 1]);
else
    if isa(varargin{1}, 'knotVector');  obj.KnotVector = varargin{1};
    elseif isvector(varargin{1}); obj.KnotVector = knotVector(varargin{1});
    elseif isempty(varargin{1}); obj.KnotVector = knotVector([0 0 0 1 1 1]);
    else throw(MException(obj.ExceptionsData.msgID1, obj.ExceptionsData.Constructor.msg1));
    end
end

obj.constructInformation;
obj.addDefaultSignalSlots;

% Optional input arguments
if nargin > 2
    if ischar(varargin{2})
        if strcmp(varargin{2}, 'Evaluate')   % sequence of input arguments: 'Evaluate', {'Default'} or cell('EvaluationMethod', [givenPoints](Occasionally optional), derivativeOrder(optional))
            if nargin > 3
                if isa(varargin{3}, 'bSplineBasisFunctionsEvaluationSettings')
                    obj.EvaluationSettings = varargin{3};
                    obj.evaluatePerKnotPatch;
                else
                    throw(MException('bSplineBasisFunctions:constructor', 'Provide an object of the class ''bSplineBasisFunctionsEvaluationSettings'' as third argument, when non-default settings are desired for the evaluation.'));
                end
            else
                obj.EvaluationSettings = bSplineBasisFunctionsEvaluationSettings;
                obj.evaluatePerKnotPatch; % evaluate with default settings
            end
        else
            throw(MException('bSplineBasisFunctions:constructor', 'Provide the string value ''Evaluate'' as second optional argument, if the evaluation of the basis functions is desired.'));
        end
    elseif isa(varargin{2}, 'bSplineBasisFunctionsEvaluationSettings')
        obj.EvaluationSettings = varargin{2};
    else
        obj.EvaluationSettings = bSplineBasisFunctionsEvaluationSettings;
    end
else
    obj.EvaluationSettings = bSplineBasisFunctionsEvaluationSettings;
end

end