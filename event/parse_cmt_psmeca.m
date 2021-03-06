function [cmt]=parse_cmt_psmeca(file,hlines)
%PARSE_CMT_PSMECA    Parses PSMECA input from the GlobalCMT project
%
%    Usage:    cmt=parse_cmt_psmeca(file)
%              cmt=parse_cmt_psmeca(file,hlines)
%
%    Description:
%     CMT=PARSE_CMT_PSMECA(FILE) reads in a PSMECA-formatted text file
%     produced by the Global CMT project (www.globalcmt.org).  All the info
%     from the file is imported into the struct CMT (see the Notes section
%     below for more details).  If FILE is not given or set to '' then a
%     graphical file selection menu is presented.
%
%     CMT=PARSE_CMT_PSMECA(FILE,HLINES) allows skipping HLINES lines at the
%     top of the text file.  HLINES should be a scalar integer.
%
%    Notes:
%     - CMT is a scalar struct with several fields (but far less than from
%       an NDK file -- see READNDK for more details).  All fields are
%       column vectors either of double or cellstr type with as many rows
%       as cmts in the PSMECA file.  The fields:
%           latitude
%           longitude
%           depth
%           mrr
%           mtt
%           mpp
%           mrt
%           mrp
%           mtp
%           exponent
%           name
%
%    Examples:
%     % Read in a psmeca file selected graphically that has 3 header lines:
%     cmts=parse_cmt_psmeca([],3);
%
%     % Now get all the associated info using the names:
%     cmts=findcmts('name',strcat('^.',cmts.name,'$'));
%
%    See also: PARSE_ISC_ORIGIN, PLOT_MLOCATE_ELLIPSOIDS, READNDK, FINDCMTS

%     Version History:
%        July 12, 2011 - initial version
%        Aug.  5, 2011 - code cleaned up
%        Aug. 25, 2011 - added example for connection with FINDCMTS
%        Jan. 27, 2014 - abs path exist fix
%
%     Written by Erica Emry (ericae at wustl dot edu)
%                Garrett Euler (ggeuler at wustl dot edu)
%     Last Updated Jan. 27, 2014 at 13:35 GMT

% check nargin
error(nargchk(0,2,nargin));

% directory separator
fs=filesep;

% graphical isc file selection if no file given
if(nargin<1 || isempty(file))
    [file,path]=uigetfile(...
        {'*.txt;*.TXT' 'TXT Files (*.txt,*.TXT)';
        '*.*' 'All Files (*.*)'},...
        'Select TXT File');
    if(isequal(0,file))
        error('seizmo:parse_cmt_psmeca:noFileSelected',...
            'No input file selected!');
    end
    file=[path fs file];
else % file given so check it exists
    % check file
    if(~isstring(file))
        error('seizmo:parse_cmt_psmeca:fileNotString',...
            'FILE must be a string!');
    end
    if(~isabspath(file)); file=[pwd fs file]; end
    if(~exist(file,'file'))
        error('seizmo:parse_cmt_psmeca:fileDoesNotExist',...
            'File: %s\nDoes Not Exist!',file);
    elseif(exist(file,'dir'))
        error('seizmo:parse_cmt_psmeca:dirConflict',...
            'File: %s\nIs A Directory!',file);
    end
end

% default/check header lines
if (nargin==1); hlines=0; end
if(~isreal(hlines) || ~isscalar(hlines) || hlines~=fix(hlines) || hlines<0)
    error('seizmo:parse_cmt_psmeca:badInput',...
        'HEADERLINES must be a positive scalar interger!');
end

% read in isc file
txt=readtxt(file);

% separate all fields
fields=getwords(txt)';

% push into a struct
% - should we make this meet the minimum ndk struct requirements?
%   'scalarmoment' 'exponent' 'year' 'month' 'day' 'hour'
%   'minute' 'seconds' 'centroidtime' 'centroidlat' 'centroidlon'
%   'centroiddep'
cmt.latitude=str2double(fields(2:13:end));
cmt.longitude=str2double(fields(1:13:end));
cmt.depth=str2double(fields(3:13:end));
cmt.mrr=str2double(fields(4:13:end));
cmt.mtt=str2double(fields(5:13:end));
cmt.mpp=str2double(fields(6:13:end));
cmt.mrt=str2double(fields(7:13:end));
cmt.mrp=str2double(fields(8:13:end));
cmt.mtp=str2double(fields(9:13:end));
cmt.exponent=str2double(fields(10:13:end));
cmt.name=fields(13:13:end);

end
