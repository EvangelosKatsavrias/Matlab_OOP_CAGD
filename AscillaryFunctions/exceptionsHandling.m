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

switch Exception.identifier
    %% 
    case 'MATLAB:CancelButton'
        
        choice = questdlg('Would you like to interrupt the process?', ...
            'Confirmation dialog', 'Yes', 'No', 'No');
        switch choice
            case 'Yes'
                set(0,'ShowHiddenHandles','on'); delete(get(0,'Children'))
                rmpath(genpath(Input.path));
                rethrow(Exception);
            case 'No'
        end
    
        
    %% 
    case 'nonLinearSol:convergence'
        set(0,'ShowHiddenHandles','on'); delete(get(0,'Children'))
        rmpath(genpath(Input.path));
        throw(Exception);
    
        
    %% 
    case 'CAGD:DataStructure'
        rmpath(genpath(Input.path));
        throw(Exception);
        
        %     % 2) Construct an MException object to represent the error.
        %     msgID = 'MYFUN:BadIndex';
        %     msg = 'Unable to index into array.';
        %     baseException = MException(msgID,msg);
        %
        %     % 3) Store any information contributing to the error.
        %     try
        %         assert(islogical(idx),'MYFUN:notLogical',...
        %             'Indexing array is not logical.')
        %     catch causeException
        %         baseException = addCause(baseException,causeException);
        %     end
        %
        %     if any(size(idx) > size(A))
        %         msgID = 'MYFUN:incorrectSize';
        %         msg = 'Indexing array is too large.';
        %         causeException2 = MException(msgID,msg);
        %         baseException = addCause(baseException,causeException2);
        %     end
        %
        %     % 4) Throw the exception to stop execution and display an error
        %     % message.
        %     throw(baseException)
        %
        %     end
        
        
    %%
    otherwise
        rmpath(genpath(Input.path));
        rethrow(Exception);
        
end
