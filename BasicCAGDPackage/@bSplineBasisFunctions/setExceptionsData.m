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

function ExceptionsData = setExceptionsData

ExceptionsData.msgID1 = 'CAGD:monoParametricBasisFunctions';
ExceptionsData.msgID2 = 'CAGD:monoParametricBasisFunctionsEvaluation';

ExceptionsData.Constructor.msg1 = 'Wrong input data, please provide an object of class ''knotVector'' in the first input argument.';

ExceptionsData.FunctionsEvaluation.msg1 = 'Wrong input data, provide a valid string as the first input argument to indicate the form of the requested evaluation points. The argument can be omitted, so that the default option is selected. Valid options are: ''RepetitiveUniformInKnotPatches''(default), ''RepetitiveGivenInKnotPatches'', ''ArbitraryGivenInKnotPatches'', ''ArbitraryGivenInDomain''.';
ExceptionsData.FunctionsEvaluation.msg2 = 'Wrong input data, provide an appropriate type of data as the second input argument to indicate the requested evaluation points. The argument can be omitted, so that the default values to be used. Valid options are: ''RepetitiveUniformInKnotPatches'' -> a scalar number, ''RepetitiveGivenInKnotPatches'' -> a single dimensional array, ''ArbitraryGivenInKnotPatches'' -> a single dimensional cell with single dimensional arrays, where the first element in each array indicates the knot span number, ''ArbitraryGivenInDomain'' -> a single dimensional array';
ExceptionsData.FunctionsEvaluation.msg3 = 'Wrong input data, provide a single scalar number as the third input argument to indicate the maximum order of derivatives to be evaluated. The input argument is optional, the default value is preset to zero.';
ExceptionsData.FunctionsEvaluation.msg4 = 'Wrong input data, provide a single dimensional array as the fourth input argument to indicate the knot spans to evaluate points. The input argument is optional and valid only for the repetitive point forms and not the arbitrary.';
ExceptionsData.FunctionsEvaluation.msg5 = 'Wrong input data, provide valid knot span numbers that do no exceed the total number of them.';

ExceptionsData.FunctionsEvaluation.msg6 = 'Wrong input data, provide a single scalar number as the number of uniform evaluation points in a knot span.';
ExceptionsData.FunctionsEvaluation.msg7 = 'Wrong input data, provide a single dimension array to indicate the knot spans of evaluation.';
ExceptionsData.FunctionsEvaluation.msg8 = 'Wrong input data, provide a single dimensional array to indicate the evaluation points in a knot span. The values should be given in the interval (0, 1)';

end