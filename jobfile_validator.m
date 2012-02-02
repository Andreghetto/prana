function [Data] = jobfile_validator(Data)
%Attempt to make backwards-compatible with older

%is the version variable present in the job file.
if ~isfield(Data,'version')
    if ~isfield(Data,'par')
        Data.par='0';
        Data.parprocessors='1';
        Data.version='1.5';
    else
        handles.data.version='1.9';
    end
end
%does the job file have the zero mean option
if ~isfield(Data.PIV0,'zeromean')
    for pass=0:str2double(Data.passes)
        eval(['Data.PIV',num2str(pass),'.zeromean=''0'';']);
        eval(['Data.PIV',num2str(pass),'.peaklocator=''1'';']);
    end
end
%does the job file have infromation about the color channels
if ~isfield(Data,'channel')
    Data.channel = '1';
end
%does the job file have a variable for fractionally weighted correlations
if ~isfield(Data.PIV0,'frac_filt')
    for pass=0:str2double(Data.passes)
        eval(['Data.PIV',num2str(pass),'.frac_filt=''1'';']);
        %SPC has been moved to '5' so check to see if SPC was used and
        %reset it to '5'.
        if str2double(eval(['Data.PIV' num2str(pass) '.corr'])) == 3
            eval(['Data.PIV',num2str(pass),'.corr=''5'';']);
        end
    end
end
%does the job file have infromation about interative window deformation
if ~isfield(Data.PIV0,'deform_min')
    for pass=0:str2double(Data.passes)
        eval(['Data.PIV',num2str(pass),'.deform_min=''1'';']);
        eval(['Data.PIV',num2str(pass),'.deform_max=''1'';']);
        eval(['Data.PIV',num2str(pass),'.deform_conv=''0.1'';']);
    end
end
if ~isfield(Data,'runPIV')
    Data.runPIV = '1';
end
%does the job file have the ability to save correlation planes
if ~isfield(Data.PIV0,'saveplane')
    for pass=0:str2double(Data.passes)
        eval(['Data.PIV',num2str(pass),'.saveplane=''0'';']);
    end
end

% This performs a check to see if the job files
% contains the field 'outputpassbase' if not then it
% used the output name from the final pass.
if ~isfield(Data,'outputpassbase')
    eval(['Data.outputpassbase = Data.PIV' Data.passes '.outbase;']);
end

%does the job file have tracking infromation.
if ~isfield(Data,'ID')
    Data.runPIV = '1';
    
    Data.ID.runid        = '0';
    Data.ID.method       = '2';
    Data.ID.imthresh     = '10';
    Data.ID.savebase     = 'ID_';
    % Sizing Default values
    Data.Size.runsize    = '0';
    Data.Size.method     = '1';
    Data.Size.std        = '4';
    Data.Size.savebase   = 'SIZE_';
    % Tracking Default values
    Data.Track.runtrack  = '0';
    Data.Track.method    = '1';
    Data.Track.prediction= '1';
    Data.Track.PIVweight = '0.5';
    Data.Track.radius    = '15';
    Data.Track.disweight = '1.0';
    Data.Track.sizeweight= '0.5';
    Data.Track.intensityweight = '0.5';
    Data.Track.estradius = '15';
    Data.Track.estweight = '.1';
    Data.Track.savebase  = 'Track_';
    Data.Track.vectors   = '3';
    Data.Track.iterations= '3';    
    % Tracking Validation Values
    Data.Track.valprops.run   = '1';
    Data.Track.valprops.valcoef = '0,0,0.2';
    Data.Track.valprops.valrad = '20,20,0';
    Data.Track.valprops.MAD_U = '1,0.75,0';
    Data.Track.valprops.MAD_V = '1,0.75,0';
    
    if ispc
%         Data.loaddirec=[pwd '\'];
        Data.ID.save_dir        = [pwd,'\ID\'];
        Data.Size.save_dir      = [pwd,'\Size\'];
        Data.Track.save_dir     = [pwd,'\Track\'];
        Data.Track.PIVprops.load_dir= [pwd,'\'];
    else
%         Data.loaddirec=[pwd '/'];
        Data.ID.save_dir        = [pwd,'/ID/'];
        Data.Size.save_dir      = [pwd,'/Size/'];
        Data.Track.save_dir     = [pwd,'/Track/'];
        Data.Track.PIVprops.load_dir= [pwd,'/'];
    end
end
end
