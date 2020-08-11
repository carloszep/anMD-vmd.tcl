{
|-mmLogInfo.pp :
|  -molecular modeling log info extractor .
|  -description :
|    -free pascal program source code .
|    -extracts log information from output files of different molecular
|     _ modeling programs .
|    -creates tcl scripts used by libraries anMD and anMol in VMD .
|    -started from namdLogInfo v-0.0.1 to also include output log files from
|     _ other programs besides namd ;
|  -written by :-Carlos Z. Gómez Castro ;
|  -date :-2019-04-08.Mon ;
|  -version :-0.1.6 ;
|  -version information :
|    -changes in this version :
|      -done :
|        -included loading anMD library in the trajInfo script ;
|    -to do in future versions :
|      -to declare data structure to admit deMon2k output information .
|      -scheme for input/configuration format (input driver) ;
|    -finished version ;
|  -information and description :
|    -information to be specified as trajInfo or molInfo array keys :
|      -name :
|        -short simuailtion name (~5-10 chars) with no whitespaces .
|        -common to all fragments .
|        -associated to a single VMD molid and a single psf structure ;
|      -psf :
|        -path/name of the base .psf file ;
|      -coord :
|        -path/name of the initial coordinates file (i.e. pdb) ;
|      -desc :
|        -description text for the structure and simulation as a whole ;
|      -fragments, trajFrag, sections :
|        - ;
|      -selections :
|        - ;
|      -representations :
|        - ;;
|    -information to be extracted and stored from namd log (example) :
|      -Info: Configuration file is bam5di-s11.namd .
|      -Info: TIMESTEP               2 .
|      -Info: DCD FILENAME           out/bam5di-s11.dcd .
|      -Info: DCD FREQUENCY          5000 .
|      -Info: DCD FIRST STEP         5000 .
|      -Info: OUTPUT FILENAME        out/bam5di-s11 .
|      -Info: COORDINATE PDB         /home/carlos/DinMolec/amyloid/olig/
|       _struct/bam5di.pdb .
|      -Info: STRUCTURE FILE         /home/carlos/DinMolec/amyloid/olig/
|       _struct/bam5di.psf .
|      -Info: Benchmark time: 8 CPUs 0.421183 s/step 2.4374 days/ns
|       _ 171.34 MB memory .
|      -WRITING EXTENDED SYSTEM TO RESTART FILE AT STEP 5000 .
|      -WRITING COORDINATES TO DCD FILE AT STEP 5000 .
|      -WRITING COORDINATES TO RESTART FILE AT STEP 5000 .
|      -WRITING VELOCITIES TO RESTART FILE AT STEP 5000 .
|      -FINISHED WRITING RESTART COORDINATES .
|      -FINISHED WRITING RESTART VELOCITIES .
|      -ETITLE:      TS           BOND          ANGLE          DIHED
|       _          IMPRP               ELECT            VDW       BOUNDARY
|       _           MISC        KINETIC               TOTAL           TEMP
|       _      POTENTIAL         TOTAL3        TEMPAVG            PRESSURE
|       _      GPRESSURE         VOLUME       PRESSAVG      GPRESSAVG .
|      -ENERGY:       0      4580.3145     11918.3880      6136.9755
|       _       765.5800        -819166.9011     67982.7069         0.0000
|       _         0.0000    148176.0960        -579606.8402       308.5341
|       _   -727782.9362   -579128.0306       308.5341           -106.9660
|       _       -53.4137   2347904.2491      -106.9660       -53.4137 ;
|    -objective :
|      -the idea is to be able to append all the information for several
|       _ fragments of information in a single trajInfo script .
|      -this may include initial structure, equilibration runs, and production
|       _ simulation ;
|    -command-line parameters :
|      -for version 0.0.1 only a single parameter is acceptable .
|      -parameter 1 :
|        -name of the output log file assigned to mmLogFile .
|        -obligatory parameter .
|        -'-h' or '--help' may be used to show help info ;;;
|  -uses :
|    -ioDrv v-0.0.5 .
|    -condText v-0.1.2 .
|    -strutils .
|    -sysutils ;
|  -constants :
|    -mmLogInfo_name :-string with the name of program ;
|    -mmLogInfo_version :-string with the program version number ;
|    -maxDcdSizeGB :-maximum namd traj size to be loaded into RAM ;;
|  -types :
|    -strLogLine :- ;
|    -strToken :- ;
|    -realTime :- ;
|    -t_timeStep :- ;
|    -intStep :- ;
|    -t_logType :-identifies the type of input log file processed ;
|    -rec_namdLogInfo :
|      -record to store the information extracted from a namd log file .
|      -fields :
|        -pwd :-path returned by the environment ;
|        -simFolder :-folder where configuration and output files are stored ;
|        -altSimFolder :
|          -alternative folder to search for log files .
|          -is specified at runtime through file mmLogInfo_userOpts.ct ;
|        -simName :-directory name where config files and out dir is located ;
|        -prevSimName :-previous simName in the sequence of simulations ;
|        -config :-name of the namd configuration file ;
|        -timeStep :-timestep used in the simulation ;
|        -dcd :-trajectory in dcd format ;
|        -dcdFreq :-frequency in which the trajectory was saved ;
|        -dcdFirst :-first timestep written ;
|        -dcdLast :-last step where the dcd coordinates were saved ;
|        -coord :-coordinates file (i.e. pdb) ;
|        -psf :-protein structure file ;
|        -eTitle :-titles for the different energies reported by namd ;
|        -energy :-single line with energies reported by namd ;
|        -benchmark :-last benchmark reported ;
|        -timimg :-first timing report ;
|        -iniTimeNs :-Initial simulation time in ns ;
|        -finTimeNs :-final simulation time in ns ;
|        -wallClock :-final wallClock and CPUTime info reported ;
|        -extSyst :-extended system file (restart.xsc) ;;;
|    -rec_demonOut :
|      -record to store information extracted from deMon2k out file .
|      -NOTE: for the moment only extraction of lattice data is considered .
|      -fields :
|        -pwd :-path returned by the environment ;
|        -outFolder :-folder where the output files are located ;
|        -outName :-name of the deMon2k output file ;
|        -demon_version :-version of deMon2k ;
|        -plotFunc :-plot function option calculated ('PLOT' keyword) ;
|        - ;;;
|  -variables :
|    -logFile :-name of the output log file ;
|    -iml :-object for managing the output log messages ;
|    -userOpts :-condText object managing user-defined options read at
|     _ runtime from a condText file mmLogInfo_userOpts.ct ;
|    -userOptsFile :-name of the condText file for external user options ;
|    -functionOpt :-flag indicating which program/funtion to execute :
|      -valid options :
|        -'namdLog' :-will process a NAMD log file ;
|        -'demonOut' :-will process a deMon2k out file ;;;;;
|  -functions and procedures :
|    -mmLogInfo_finish :-finishes the global variables ;
|    -mmLogInfo_init :-initializes program variables and objects ;
|    -secBasePath :-return a file path combaining two different paths ;
|    -namdRecInit :-sets default values to a namdLogInfo record ;
|    -namdHeader :-extracts log information (from the header only) ;
|    -namdEnergies :-extracts energies along trajectory log ;
|    -namdLogTrajInfo :-return the list trajFrag from a .log file ;
|    -commandInt :-command-line interpreter ;;
|  - ;
}
program mmLogInfo;

uses
  sysutils, strutils, ioDrv, condText;

const
  mmLogInfo_name = 'mmLogInfo';
  mmLogInfo_version = '0.1.6';
  maxDcdSizeGB = 10.0;

type
  strLogLine = AnsiString;
  strToken = string;
  realTime = real;
  t_timeStep = 0..2;
  intStep = longWord;
  t_logType = (namd_min,namd_md,namd_sa,ad3_dlg,ad3_glg);
  rec_namdLogInfo = record
    pwd : strLogLine;
    simFolder : strLogLine;
    altSimFolder : strLogLine;
    simName : strToken;
    config : strToken;
    timeStep : t_timeStep;
    dcd : strToken;
    dcdFreq : intStep;
    dcdFirst : intStep;
    dcdLast : intStep;
    coord : strToken;
    psf : strToken;
    eTitle : strLogLine;
    energy : strLogLine;
    benchmark : strLogLine;
    timing : strLogLine;
    iniTimeNs : realTime;
    finTimeNs : realTime;
    wallClock : strLogLine;
    extSyst : strLogLine;
  end;

var
  logFile : string;
  iml : obj_infoMsg;
  userOpts : obj_condText;
  userOptsFile : string;
  functionOpt : string;


{|-procedure mmLogInfo_finish; :
 |  -finalizes the program ;|}
procedure mmLogInfo_finish;
  begin
    iml.infoMsg (0,2,'mmLoginfo_finish: finalizing userOpts object.');
    userOpts.finish;
    iml.infoMsg (0,2,'mmLoginfo_finish: unlinking condText log file.');
    CTlog.unlinkExtDev;
    iml.infoMsg (0,1,'mmLogInfo_finish: ending program...');
    iml.finish;
    halt
  end;   {mmLogInfo_finish}


{|-procedure mmLogInfo_init; :
 |  -initialization of the program ;|}
procedure mmLogInfo_init;
  const
    name = 'mmLogInfo_init: ';

  procedure printHelp;
    begin
      writeln;
      writeln (mmLogInfo_name + '-v.' + mmLogInfo_version +
               ': molecular modeling log info extractor.');
      writeln;
      writeln ('usage: mmLogInfo <filename>');
      writeln ('Valid options: -h, --help');
      writeln ('Notes:');
      writeln ('  -for namd, specify the log file of the last run in a');
      writeln ('   sequence of simulation (equilibration) runs.');
      writeln ('    -the log file name must be consistent with the rest');
      writeln ('     of namd output files for each simulation run.');
      writeln ('    -the namd output files are supposed to be located a');
      writeln ('     folder inside the simulation folder:'); 
      writeln ('       i.e. .../sim/out/<.log and other output files>');
      writeln ('  -use condText file '+userOptsFile+' for external options');
      writeln ('   at the simulation folder or at the running folder.');
    end;   {printHelp}

  begin   {mmLogInfo_init}
{initializing log file}
    iml.init;
    iml.setInfoMsgName (mmLogInfo_name + '-v.' + mmLogInfo_version);
    iml.setOutputDevice (c_outDev_file,
                         'log_' + mmLogInfo_name + '.txt', 'rewrite');
    iml.infoMsg (0,2,name+'Unit log file '+'log_'+mmLogInfo_name
                      + '.txt initialized.');
    iml.setOutputLevel (c_outLvl_detailed);
{linking condText log file to iml}
    iml.infoMsg (0,2,name+'sending info messages from condText ' +
                     'unit to the current log file');
    CTlog.setOutputDevice (c_outdev_none,'','');
    CTlog.linkExtDev (iml);
{checking external file for user options}
    iml.infoMsg (0,1,name + 'Searching for external user options.');
    userOptsFile := 'mmLogInfo_userOpts.ct';
    userOpts.init;
    if FileExists(userOptsFile) then
      begin
        iml.infoMsg (0,1,name + userOptsFile + ' file found ' +
                         'for external user options');
        userOpts.open (userOptsFile, 'I')
        {note: the contents of userOptsFile could be printed to the log file}
      end
    else
      iml.infoMsg (0,1,name + userOptsFile + ' file not found.');
{checking command line parameters}
    if ParamCount = 1 then
      begin
        if (ParamStr(1) = '-h') or (ParamStr(1) = '--help') then
          begin
            printHelp;
            mmLogInfo_finish
          end
        else
          begin
            LogFile := ParamStr(1);
            functionOpt := 'namdLog';
            iml.infoMsg(0,1,'mmLogInfo_init: input NAMD log file: ' + logFile)
          end
      end
    else if ParamCount = 2 then
      begin
        if (UpCase(ParamStr(1)) = 'DEMON') or
           (UpCase(ParamStr(1)) = 'DEMON2K') or
           (UpCase(ParamStr(1)) = 'DEMONOUT') then
          begin
            logFile := ParamStr(2);
            functionOpt := 'demonOut';
            iml.infoMsg(0,1,'mmLogInfo_init: input deMon2k out file: '+logFile)
          end
      end
    else
      begin
        iml.infoMsg (1,1,'mmLogInfo_init: Invalid number of parameters.');
        writeln ('Error: Invalid number of parameters.');
        printHelp;
        mmLogInfo_finish
      end;
  end;   {mmLogInfo_init}


{|-function secBasePath (basePath, finPath: strLogLine): strLogLine; :
 |  -return an absolute path formed by combining basePath and finPath .
 |  -the function will search the first common intermediate directory and will
 |   _ concatenate the base path with the final path from each argument .
 |  -if no common directory name in both paths finPath is returned .
 |  -example :
 |    -basePath=/a/b/c/d/e, finPath=/f/g/c/d/h, secBasePath=/a/b/c/d/h ;;|}
function secBasePath (basePath, finPath: strLogLine): strLogLine;
  var
    ibp, ifp, nwb, nwf : integer;

  begin   {secBasePath}
    iml.infoMsg (0,2,'secBasePath: basePath: ' + basePath);
    iml.infoMsg (0,2,'secBasePath: finPath: ' + finPath);
    nwb := WordCount(basePath,['/']);
    nwf := WordCount(finPath,['/']);
{searches for each directory name in the final path}
    for ibp:=1 to nwb do
      for ifp:=1 to nwf do
        if ExtractWord(ibp,basePath,['/']) = 
           ExtractWord(ifp,finPath,['/']) then
          begin
            secBasePath:=Copy(basePath,1,WordPosition(ibp,basePath,['/']) - 1)
                         + Copy(finPath,WordPosition(ifp,finPath,['/']),
                                Length(finPath));
            iml.infoMsg (0,2,'secBasePath: ' + secBasePath);
            exit
          end;
    secBasePath := finPath;
    iml.infoMsg (0,2,'secBasePath: ' + secBasePath);
  end;   {secBasePath}


{|-procedure namdRecInit (logFile : string; var namdRI : rec_namdLogInfo) :
 |  -initializes the variables in a namdLogInfo record .
 |  -arguments :
 |    -logFile :-name of the log file ;
 |    -namdRI :-namdLogInfo record to be initialized ;;
 |  -notes :
 |    -the path of the log file is used extract the simFolder ;;|}
procedure namdRecInit (logFile : string; var namdRI : rec_namdLogInfo);
  var
    simUserOpts : obj_condText;

  begin
    iml.infoMsg (0,2,'namdRecInit: initializing namdLogInfo record...');
    with namdRI do
      begin
        pwd := GetEnvironmentVariable('PWD');
        iml.infoMsg (0,2,'namdRecInit: Path to working directory: ' + pwd);
        simFolder := ExpandFileName(ExtractFilePath(logFile)+'..')+'/';
        iml.infoMsg (0,1,'namdRecInit: Simulation folder path: ' + simFolder);
        simName := ExtractFileName(ExtractFileDir(simFolder));
        iml.infoMsg (0,1,'namdRecInit: Simulation name: ' + simName);
        config := '';
        timeStep := 0;
        dcd := '';
        dcdFreq := 0;
        dcdFirst := 0;
        dcdLast := 0;
        coord := '';
        psf := '';
        eTitle := '';
        energy := '';
        benchmark := '';
        timing := '';
        iniTimeNs := 0.0;
        finTimeNs := 0.0;
        wallClock := '';
        extSyst := '';
{check for external user options}
        altSimFolder := '';
        if (pwd+'/' <> simFolder) and (FileExists(simFolder+userOptsFile)) then
          begin
            iml.infoMsg (0,2,'namdRecInit: external user options file ' +
                             'found at the simulation folder.');
            simUserOpts.init;
            simUserOpts.open (simFolder + userOptsFile, 'I');
            altSimFolder := simUserOpts.getFieldValue(NIL,'altSimFolder');
            simUserOpts.finish   {for the moment not necessary any more}
          end
        else if not userOpts.empty then
          begin
            altSimFolder := userOpts.getFieldValue(NIL,'altSimFolder');
          end
        else
          iml.infoMsg (0,2,'namdRecInit: external user options file ' +
                           'not found in simulation folder.');
        if altSimFolder <> '' then
          begin
            altSimFolder := ExpandFileName(altSimFolder);
            iml.infoMsg (0,1,'namdRecInit: altern sim folder: '+altSimFolder)
          end
        else
          iml.infoMsg (0,2,'namdRecInit: altern sim folder not found.');
      end
  end;   {namdRecInit}

{|-procedure namdHeader (logFile : string; var namdRI :rec_namdLogInfo); :
 |  -extracts header information from a namd log file .
 |  -arguments :
 |    -logFile :-name of the namd log file ;
 |    -namdRI :-initialized namdLogInfo record ;;;|}
procedure namdHeader (logFile : string; var namdRI :rec_namdLogInfo);
  const
    name = 'namdHeader: ';
  var
    namdLog : text;
    logLine, secPath : strLogLine;
    numStr : strToken;
    timingRep : boolean;   {the first timing report has been reached}
    code : word;

  begin   {namdHeader}
    assign (namdLog, logFile);
{$I-} reset (namdLog); {$I+}
    if IOresult <> 0 then
      begin
        iml.infoMsg (7,1,name + 'Error reading file: ' + logFile);
        exit;
      end
    else
      iml.infoMsg(0,1,name+'Extracting header information from file: '+logFile);
    timingRep := False;
    while (not EoF(namdLog)) and (not timingRep) do
      begin
        readln (namdLog, logLine);
        if pos('Info: Configuration file is', logLine) > 0 then
          begin
            namdRI.config := copy(logLine, 29, length(logLine) - 28);
            iml.infoMsg (0,1,name + 'Configuration file: ' + namdRI.config);
            if FileExists(namdRI.config) then
              iml.infoMsg (0,2,name+'Config file found in the current dir.')
            else if FileExists(namdRI.simFolder + namdRi.config) then
              begin
                iml.infoMsg (0,2,name+'Config file found in the sim folder.');
              end
            else
              iml.infoMsg (2,1,name+'Configuration file not found.')
          end
        else if pos('Info: TIMESTEP', logLine) > 0 then
          begin
            numStr := ExtractWord(3, logLine, [' ']);
            val(numStr, namdRI.timeStep, code);
            if code = 0 then
              iml.infoMsg (0,1,name+'TimeStep: ' + numStr)
            else
              iml.infoMsg (2,1,name+'Invalid timestep');
          end
        else if pos('Info: DCD FILENAME', logLine) > 0 then
          begin
            namdRI.dcd := ExtractWord(4, logLine, [' ']);
            iml.infoMsg (0,1,name + 'dcd (trajectory) file: ' + namdRI.dcd);
            if FileExists(namdRI.dcd) then
              begin
                namdRI.dcd := ExpandFileName(namdRI.dcd);
                iml.infoMsg(0,1,name+'DCD file expanded to: ' + namdRI.dcd)
              end
            else
              begin
                secPath := secBasePath(namdRI.simFolder,namdRI.dcd);
                if FileExists(namdRI.simFolder + 'out/' +
                     ExtractFileName(namdRI.dcd)) then
                  begin
                    namdRI.dcd:=namdRI.simFolder + 'out/' +
                                  ExtractFileName(namdRI.dcd);
                    iml.infoMsg (0,1,name+'DCD file found: '+namdRI.dcd)
                  end
                else if FileExists(secPath) then
                  begin
                    namdRI.dcd := secPath;
                    iml.infoMsg (0,1,name+'DCD file found: '+namdRI.dcd)
                  end
                else
                  iml.infoMsg (2,1,name+'DCD file not found.')
              end
          end
        else if pos('Info: DCD FREQUENCY', logLine) > 0 then
          begin
            numStr := ExtractWord(4, logLine, [' ']);
            val(numStr, namdRI.dcdFreq, code);
            if code = 0 then
              iml.infoMsg (0,1,name+'dcd frequency: ' + numStr)
            else
              iml.infoMsg (2,1,name + 'Invalid dcd frequency');
          end
        else if pos('Info: DCD FIRST STEP', logLine) > 0 then
          begin
            numStr := ExtractWord(5, logLine, [' ']);
            val(numStr, namdRI.dcdFirst, code);
            if code = 0 then
              iml.infoMsg (0,1,name+'First dcd step: ' + numStr)
            else
              iml.infoMsg (2,1,name + 'Invalid first dcd step');
          end
        else if pos('Info: COORDINATE PDB', logLine) > 0 then
          begin
            namdRI.coord := ExtractWord(4, logLine, [' ']);
            iml.infoMsg (0,1,name + 'Coordinate pdb: ' + namdRI.coord);
            if FileExists(namdRI.coord) then
              begin
                namdRI.coord := ExpandFileName(namdRI.coord);
                iml.infoMsg (0,1,name+'Coordinates file expanded to: ' +
                                   namdRI.coord)
              end
            else
              begin
                secPath := secBasePath(namdRI.simFolder,namdRI.coord);
                if FileExists(ExpandFileName(namdRI.simFolder +
                     '../../struct/' + ExtractFileName(namdRI.coord))) then
                  begin
                    namdRI.coord := ExpandFileName(namdRI.simFolder +
                      '../../struct/' + ExtractFileName(namdRI.coord));
                    iml.infoMsg (0,1,name+'Coordinates file found: ' +
                                       namdRI.coord);
                  end
                else if FileExists(namdRI.simFolder + 'out/' + 
                          ExtractFileName(namdRI.coord)) then
                  begin
                    namdRI.coord := ExpandFileName(namdRI.simFolder + 'out/' +
                                      ExtractFileName(namdRI.coord));
                    iml.infoMsg (0,1,name+'Coordinates file found: ' +
                                       namdRI.coord)
                  end
                else if FileExists(namdRI.simFolder + namdRI.coord) then
                  begin
                    namdRI.coord := namdRI.simFolder + namdRI.coord;
                    iml.infoMsg (0,1,name+'Coord file found in sim folder')
                  end
                else if FileExists(secPath) then
                  begin
                    namdRI.coord := secPath;
                    iml.infoMsg (0,1,name+'Coordinates file found: ' +
                                       namdRI.coord)
                  end
                else
                   iml.infoMsg (2,1,name+'Coordinates file not found.')
              end
          end
        else if pos('Info: STRUCTURE FILE', logLine) > 0 then
          begin
            namdRI.psf := ExtractWord(4, logLine, [' ']);
            iml.infoMsg (0,1,name + 'Structure file: ' + namdRI.psf);
            if FileExists(namdRI.psf) then
              begin
                namdRI.psf := ExpandFileName(namdRI.psf);
                iml.infoMsg (0, 1, name +
                  'Structure filename expanded to: '+namdRI.psf)
              end
            else
              begin
                secPath := secBasePath(namdRI.simFolder,namdRI.psf);
                if FileExists(ExpandFileName(namdRI.simFolder +
                     '../../struct/' + ExtractFileName(namdRI.psf))) then
                  begin
                    namdRI.psf := ExpandFileName(namdRI.simFolder +
                      '../../struct/' + ExtractFileName(namdRI.psf));
                    iml.infoMsg (0,1,name+'Structure file found: '+namdRI.psf)
                  end
                else if FileExists(namdRI.simFolder + namdRI.psf) then
                  begin
                    namdRI.psf := namdRI.simFolder + namdRI.psf;
                    iml.infoMsg (0,1,name+'Structure file found in sim folder')
                  end
                else if FileExists(secPath) then
                  begin
                    namdRI.psf := secPath;
                    iml.infoMsg (0,1,name+'Structure file found: '+namdRI.psf)
                  end
                else
                   iml.infoMsg (2,1,name+'Structure file not found.')
              end
          end
        else if pos('TCL: Minimizing for', logLine) > 0 then
          begin
            namdRI.timeStep := 0;
            iml.infoMsg (0,1,name+'Minimization run, setting TimeStep to 0');
          end
        else if pos('ETITLE:', logLine) = 1 then
          begin
            if namdRI.eTitle = '' then
              begin
                namdRI.eTitle := logLine;
                iml.infoMsg (0,1,name+'First energy title line found: '+logLine)
              end
          end
        else if pos('ENERGY:', logLine) = 1 then
          begin
            if namdRI.energy = '' then
              begin
                namdRI.energy := logLine;
                
                iml.infoMsg (0,1,name + 'First energy line found: ' + logLine)
              end
          end
        else if pos('Info: Benchmark time:', logLine) > 0 then
          begin
            namdRI.benchmark := logLine;
            iml.infoMsg (0,3,name + 'Last bechmark line found: ' + logLine)
          end
        else if pos('TIMING:', logLine) = 1 then
          begin
            timingRep := True;
            if namdRI.timing = '' then
              begin
                namdRI.timing := logLine;
                iml.infoMsg (0,1,name + 'First timing line found: ' + logLine)
              end;
            if namdRI.eTitle = '' then
              timingRep := False   {eTitle not found yet}
          end
        else if pos('Info: EXTENDED SYSTEM FILE', logLine) = 1 then
          begin
            namdRI.extSyst := ExtractWord(5, logLine, [' ']);
            iml.infoMsg (0,1,name+'Extended System File: '+namdRI.extSyst);
            if FileExists(namdRI.extSyst) then
              begin
                namdRI.extSyst := ExpandFileName(namdRI.extSyst);
                iml.infoMsg (0,1,name+
                        'Extended system file expanded to: '+namdRI.extSyst);
              end
            else
              begin
                secPath := secBasePath(namdRI.simFolder,namdRI.extSyst);
                if FileExists(ExpandFileName(namdRI.simFolder +
                     'out/' + ExtractFileName(namdRI.extSyst))) then
                  begin
                    namdRI.extSyst := ExpandFileName(namdRI.simFolder + 'out/'
                                        + ExtractFileName(namdRI.extSyst));
                    iml.infoMsg (0,1,name+'XSC file found: '+namdRI.extSyst)
                  end
                else if FileExists(ExpandFileName(copy(namdRI.simFolder,1,
                      pos('/DinMolec/',namdRI.simFolder))+copy(namdRI.extSyst,
                      pos('DinMolec/',namdRI.extSyst),length(namdRI.extSyst) -
                      pos('DinMolec/',namdRI.extSyst) + 1))) then
                  begin
                    namdRI.extSyst := ExpandFileName(copy(namdRI.simFolder,1,
                      pos('/DinMolec/',namdRI.simFolder))+copy(namdRI.extSyst,
                      pos('DinMolec/',namdRI.extSyst),length(namdRI.extSyst) -
                      pos('DinMolec/',namdRI.extSyst) + 1));
                    iml.infoMsg (0,1,name+'XSC file found: '+namdRI.extSyst)
                  end
                else if FileExists(ExpandFileName(namdRI.simFolder +
                                                  namdRI.extSyst)) then
                  begin
                    namdRI.extSyst := ExpandFileName(namdRI.simFolder +
                                                     namdRI.extSyst);
                    iml.infoMsg (0,1,name+'XSC file found: '+namdRI.extSyst)
                  end
                else if FileExists(secPath) then
                  begin
                    namdRI.extSyst := secPath;
                    iml.infoMsg (0,1,name+'XSC file found: '+namdRI.extSyst)
                  end
                else if FileExists(secBasePath(namdRI.altSimFolder,
                                               namdRI.extSyst)) then
                  begin
                    namdRI.extSyst := secBasePath(namdRI.altSimFolder,
                                                  namdRI.extSyst);
                    iml.infoMsg (0,1,name+'XSC file found at altern ' +
                                          'simulation folder: '+namdRI.extSyst)
                  end
                else
                  begin
                    namdRI.extSyst := '';
                    iml.infoMsg (2,1,name+'XSC file not found.')
                  end
              end
          end
      end;
    Close (namdLog);
    iml.infoMsg (0,1,name + 'Last bechmark line found: ' + namdRI.benchmark)
  end;   {namdHeader}

{|-procedure namdEnergies (logFile : string; var namdRI : rec_namdLogInfo); :
 |  -extracts all the energies reported by namd in a traj log .
 |  -each energy is stored in a text file named according to the ETITLE list .
 |  -a filder dat will be created to store the output files .
 |  -arguments :
 |    -logFile :-name of the namd log file ;
 |    -namdRI :-initialized namdLogInfo record ;;
 |  -notes :
 |    -this proc has to be called after namdRecInit and namdHeader .
 |    -when a tcl script inside namd is run in repeatedly, the initial energies
 |     _ are output so it may happend that the reported energies appear
 |     _ twice. This was corrected ;;|}
procedure namdEnergies (logFile : string; var namdRI : rec_namdLogInfo);
  const
    name = 'namdEnergies: ';
    maxEnergies = 22;

  type
    outArray = array [1..maxEnergies] of text;
    
  var
    step : intStep;
    outFiles : outArray;
    nEnergies, en : 1..maxEnergies;
    fileName : string;
    logLine : strLogLine;
    code : word;
    ts : realTime;
    namdLog : text;
    strStep, prevStep, strTS : strToken;

  begin
    assign (namdLog, logFile);
{$I-} reset (namdLog); {$I+}
    if IOresult <> 0 then
      begin
        iml.infoMsg (7,1,name + 'Error reading file: ' + logFile);
        exit;
      end
    else
      iml.infoMsg (0, 1, name +
                  'Extracting trajectory energies from file: ' + logFile);
    nEnergies := WordCount(namdRI.eTitle, [' ']);
    if FileExists('dat') then   {creating dat folder}
      iml.infoMsg(0,2,name+'dat folder already exists. Using it for output.')
    else
      begin
        if CreateDir('dat') then
          iml.infoMsg (0,2,name+'dat folder created to write output files.')
        else
          begin
            iml.infoMsg (6,1,name+'Unabe to create output dat folder.');
            exit
          end
      end;
    for en:=3 to nEnergies do
      begin   {create each one of the output files}
        fileName := 'dat/' + copy(namdRI.config,1,length(namdRI.config)-5) +
                     '_' + ExtractWord(en,namdRI.eTitle,[' ']) + '.dat';
        iml.infoMsg (0,2,name+'Creating file: '+fileName);
        assign (outFiles[en], fileName);
        rewrite (outFiles[en])
      end;
    prevStep := '';
    while not EoF(namdLog) do
      begin
        readln (namdLog, logLine);
        if pos('ENERGY:', logLine) = 1 then
          begin   {writes ENERGY data to the corresponding dat files}
            strStep := ExtractWord(2,logLine,[' ']);
            if strStep <> prevStep then prevStep := strStep else continue;
            val (strStep, step, code);
            if code = 0 then
              begin
                if (namdRI.timeStep = 1) OR (namdRI.timeStep = 2) then
                  ts:=step*namdRI.timeStep/1000000
                else
                  ts:=step;
                str (ts:8:6, strTS);
                if code = 0 then
                  iml.infoMsg (0, 3, name+
                    'Writing energies at step: '+strStep+' time step: '+strTS);
                for en:=3 to nEnergies do
                  writeln (outFiles[en],
                    ts:8:5, #9,  ExtractWord(en, logLine, [' ']))
              end
            else
              iml.infoMsg(2,1,name+
                     'Unable to determine step number in log ENERGY line.')
          end
        else if pos('TIMING:',logLine) = 1 then
          begin
            namdRI.timing := logLine;
            iml.infoMsg (0,3,name+'Last TIMING line found: ' + logLine)
          end
        else if  pos('WRITING COORDINATES TO DCD FILE', logLine) = 1 then
          begin
            strStep := ExtractWord(8,logLine,[' ']);
            val (strStep, namdRI.dcdLast, code);
            if code <> 0 then
              begin   {for newer versions of namd}
                strStep := ExtractWord(9,logLine,[' ']);
                val (strStep, namdRI.dcdLast, code)
              end;
            if code = 0 then
              iml.infoMsg (0,3,name+'DCD coord written at step: '+strStep)
            else
              iml.infoMsg (2,1,name+'Unable to read timestep in DCD writing.');
          end
        else if pos('WallClock:',logLine) = 1 then
          begin
            namdRI.wallClock := logLine;
            iml.infoMsg (0,1,name+'WallClock line found: '+logLine)
          end
      end;
    with namdRI do
      begin
        iml.infoMsg (0,1,name+'Last TIMING line found: ' + timing);
        iniTimeNs := dcdFirst*timeStep/1000000;
        finTimeNs := dcdLast*timeStep/1000000;
        if timeStep > 0 then
          begin
            str (iniTimeNs:8:5, strStep);
            iml.infoMsg (0,1,name+'Sim time in first frame: '+strStep+' ns.');
            str (finTimeNs:8:5, strStep);
            iml.infoMsg (0,1,name+'Sim time in last frame: '+strStep+' ns.');
          end
        else
          begin
            str (dcdLast, strStep);
            iml.infoMsg (0,1,name+'Last DCD step written: '+ strStep)
          end
      end;
    iml.infoMsg (0,1,name+'Writting dat energy files');
    for en:=3 to nEnergies do
      Close (outFiles[en]);
    Close (namdLog)
  end;   {namdEnergies}

{|-procedure namdLogTrajInfo; :
 |  -generates tcl code for feeding information to trajInfo or molInfo arrays .
 |  -trajFrag list pos: elements :
 |    -0: fragName :-the name of the configuration/log file is assigned ;
 |    -1: simName :-name of the simulation (taken from the directory name) ;
 |    -2: coordFile :-name of the .dcd file ;
 |    -3: timeStep :-namd timestep used in the simulation .
 |      -0 for a minimization, 1 or 2 (fs/step) for a MD sim ;
 |    -4: dcdFreq :-namd dcdfreq parameter used in the simulation ;
 |    -5: loadStep :
 |      -1 is used if the simulation is a minimization .
 |      -for equil simulation runs ... .
 |      -for a MD simulation 10 is used by default provisionally ;
 |    -6: dcdSize :-dcd file size in GB ;
 |    -7,8: iniTime, finTime :
 |      -time in ns corresponding to the initial and final frames ;
 |    -9,10: iniFrame, finFrame :
 |      -included as "unk" strings, defined after loaded in VMD ;
 |    -11: frameTime :-time increment per frame in ns for the fragment .
 |      -it is determined by vmd after loading the traj fragment .
 |      -its value depends on the loadStep used ;;
 |  -subprocedures :
 |    -addGlobalTrajInfo :-adds trajInfo (header) entries to the tcl script ;
 |    -trajFragTclRec :-performs the recursive generation of the trajFrag
 |     _ lists ;
 |    -addDefSelInfo :-incorporates default selInfo entries to the tcl script ;;
 |  -notes :
 |    -the procedure would try to search previous namd log files that would
 |     _ be expected to be output in the same folder as the namd output .
 |    -the procedure requires the log and output files base name to be
 |     _ the same (i.e. name.log, name.xsc, or name.restart.xsc) ;;|}
procedure namdLogTrajInfo;
  const
    name = 'namdLogTrajInfo: ';

  var
    prevLog, prevSimFolder, coor : strLogLine;
    strTimeStep, strDcdFreq, strDefLoadStep : strToken;
    strDcdSize, strIniTime, strFinTime, strTmp : strToken;
    trajF : file of byte;
    namdRI : rec_namdLogInfo;
    dcdSize : real;
    script : obj_output;
    totDcdSize : real;
    psfGlobal : strToken;
    trajName : string;
    

  procedure addGlobalTrajInfo;
    begin   {addGlobalTrajInfo}
      with script do
        begin
          outDev('### Traj info for MD simulation: ' + trajName + ' ##');
          outDev('# Generated by program: ' + mmLogInfo_name + ' v' +
                             mmLogInfo_version + ' on ' + DateTimeToStr(Now));
          outDev('');
          outDev('menu tkcon on');
          outDev('global trajInfo selInfo ' + trajName + '_id');
          outDev('');
          outDev('# loading library anMD');
          outDev('foreach lib {anMD} {');
          outDev('  if {![info exists "${lib}_version"]} {');
          outDev
            ('    puts "sourcing: ${tclScriptPath}${lib}/latest/${lib}.tcl"');
          outDev('    source ${tclScriptPath}${lib}/latest/${lib}.tcl');
          outDev('  } else {');
          outDev('    puts "working with lib $lib v-[set ${lib}_version]"');
          outDev('    }');
          outDev('  }');
          outDev('');
          outDev('puts "\nSetting up trajInfo array for sim: '+trajName+'"');
          if psfGlobal = '' then psfGlobal := namdRI.psf;
          outDev('puts "loading PSF file: ' + psfGlobal + '"');
          outDev('set id [mol new ' + psfGlobal + ']');
          outDev('puts "VMD mol Id for sim: $id (renamed to: '+trajName+')"');
          outDev('mol rename $id ' + trajName);
          outDev('set ' + trajName + '_id $id');
          outDev('set trajInfo($id,name) ' + trajName);
          outDev('set trajInfo($id,psf) ' + psfGlobal);
          outDev('set trajInfo($id,desc) ""');
          str (totDcdSize:10:8, strTmp);
          outDev('set trajInfo($id,dcdSize) ' + strTmp);
          if Trunc(totDcdSize/maxDcdSizeGB) < totDcdSize/maxDcdSizeGB then
            Str (Trunc(totDcdSize/maxDcdSizeGB) + 1, strTmp)
          else
            Str (Trunc(totDcdSize/maxDcdSizeGB), strTmp);
          outDev('set trajInfo($id,loadStep) ' + strTmp);
          outDev('');
          outDev('# model trajFrag list: {fragName simName dcdFile timeStep '+
                 'dcdFreq loadStep dcdSize iniTime finTime iniFrame '+
                 'finFrame frameTime}');
          outDev('');
          outDev('set trajInfo($id,trajFrag) {}');
        end;   {with}
    end;   {addGlobalTrajInfo}



  procedure trajFragTclRec (logFile: string);
    var
      strList, iniProdList, finProdList : strLogLine;

    begin   {trajFragTclRec}
      namdRecInit (logFile, namdRI);
      namdHeader (logFile, namdRI);
      namdEnergies (logFile, namdRI);
      strList := '';
      iniProdList := '';
      finProdList := '';
      with namdRI do
        begin
          str (timeStep, strTimeStep);
          str (dcdFreq, strDcdFreq);
          if (timeStep = 0) then
            strDefLoadStep:='1'
          else if (pos('equil', simFolder) > 0) and (timeStep > 0) then
            strDefLoadStep:='5'
          else
            strDefLoadStep:='10';
          iml.infoMsg (0,2,name+'Default load step for VMD: '+strDefLoadStep);
          if timestep = 0 then
            begin
              str (dcdFirst, strIniTime);
              str (dcdLast, strFinTime)
            end
          else
            begin
              str (iniTimeNs:8:6, strIniTime);
              str (finTimeNs:8:6, strFinTime)
            end;
          if FileExists(psf) then psfGlobal := psf;
          if FileExists(dcd) then
            begin
              assign (trajF, dcd);
              Reset (trajF);
              dcdSize := FileSize(trajF)/1024/1024/1024;
              totDcdSize := totDcdSize + dcdSize;
              str (totDcdSize:10:8, strDcdSize);
              iml.infoMsg (0,2,name+'Accumulated DCD size: '+strDcdSize+' GB');
              str (dcdSize:10:8, strDcdSize);
              Close (trajF);
              iml.infoMsg (0,1,name+'DCD file size: '+strDcdSize+' GB');
              if Trunc(dcdSize/maxDcdSizeGB) < dcdSize/maxDcdSizeGB then
                Str (Trunc(dcdSize/maxDcdSizeGB) + 1, strDefLoadStep)
              else
                Str (Trunc(dcdSize/maxDcdSizeGB), strDefLoadStep);
              iml.infoMsg (0,2,name+'Min load step for VMD: '+strDefLoadStep)
            end
          else
            strDcdSize := 'unk';
          strList := 'lappend trajInfo($id,trajFrag) [list '
                       + copy(config,1,length(config) - 5)
                       + ' ' + simName + ' ' + dcd + ' ' + strTimeStep + ' '
                       + strDcdFreq  + ' ' + strDefLoadStep + ' ' + strDcdSize
                       + ' ' + strIniTime + ' ' + strFinTime + ' unk unk unk]';
          iml.infoMsg (0,1,name+'NAMD traj fragment tcl list: '+strList); 
{adding a trajFrag for the final structure if the coor file is available}
          if logFile = ParamStr(1) then   {this condition may be improved}
            begin   {this case is only for the last log file}
              coor := ExpandFileName(copy(logFile,1,length(logFile)-4)+'.coor');
              if not FileExists(coor) then
                coor := ExpandFileName(copy(logFile,1,length(logFile)-4)
                                       + '.restart.coor');
              if FileExists(coor) then
                begin
                  Assign (trajF, coor);
                  Reset (trajF);
                  dcdSize := FileSize(trajF)/1024/1024/1024;
                  totDcdSize := totDcdSize + dcdSize;
                  str (totDcdSize:10:8, strDcdSize);
                  iml.infoMsg (0,2,name+'Accumulated DCD size: '
                                       +strDcdSize+' GB');
                  str (dcdSize:10:8, strDcdSize);
                  Close (trajF);
                  iml.infoMsg (0,1,name+'.coor file size: '+strDcdSize+' GB.');
                  finProdList := 'lappend trajInfo($id,trajFrag) [list '
                                 + 'finProdSim finCoord ' + coor
                                 + ' 0 1 1 ' + strDcdSize + ' ' + strFinTime
                                 + ' ' + strFinTime + ' unk unk unk]';
                  iml.infoMsg (0,1,name+
                            'NAMD traj fragment tcl list: ' + finProdList)
                end
              else
                iml.infoMsg (0,2,name+'No final .coor file found.')
            end;
          if FileExists(extSyst) then
            begin   {xsc file used to restart, then find previous log file}
              iml.infoMsg (0,1,name +
                'Searching for previous log file from XSC file name...');
              if FileExists(copy(extSyst,1,length(extSyst) - 12)+'.log') then
                begin
                  prevLog := copy(extSyst,1,length(extSyst) - 12)+'.log';
                  iml.infoMsg (0,1,name +
                           'Previous log file located from restart: '+prevLog)
                end
              else if FileExists(copy(extSyst,1,length(extSyst)-4)+'.log') then
                begin
                  prevLog := copy(extSyst,1,length(extSyst) - 4) + '.log';
                  iml.infoMsg (0,1,name + 'Previous log file found: '+prevLog)
                end
              else if FileExists(altSimFolder + 'out/' + ExtractFileName(
                        copy(extSyst,1,length(extSyst) - 12)) + '.log') then
                begin
                  prevLog := altSimFolder + 'out/' + ExtractFileName(
                               copy(extSyst,1,length(extSyst) - 12)) + '.log';
                  iml.infoMsg (0,1,name + 'Previous log file found: '+prevLog)
                end
              else if FileExists(altSimFolder + 'out/' + ExtractFileName(
                        copy(extSyst,1,length(extSyst) - 4)) + '.log') then
                begin
                  prevLog := altSimFolder + 'out/' + ExtractFileName(
                               copy(extSyst,1,length(extSyst) - 4)) + '.log';
                  iml.infoMsg (0,1,name + 'Previous log file found: '+prevLog)
                end
              else prevLog := '';
              if prevLog <> '' then
                begin
{search previous .coor file}
                  prevSimFolder := ExpandFileName(ExtractFilePath(prevLog) +
                                                  '..')+'/';
                  iml.infoMsg (0,2,name+'previous sim folder name: ' +
                       ExtractFileName(ExtractFileDir(prevSimFolder)));
                  iml.infoMsg (0,2,name+'current sim folder name: ' +
                       ExtractFileName(ExtractFileDir(simFolder)));
                  if ExtractFileName(ExtractFileDir(prevSimFolder)) <>
                     ExtractFileName(ExtractFileDir(simFolder)) then
                    begin
                      coor := copy(prevLog,1,length(prevLog) - 4)+'.coor';
                      if FileExists(coor) then
                        begin
                          iml.infoMsg(0,1,'iniProdSim coordinates file found: '
                                          + coor);
                          Assign (trajF, coor);
                          Reset (trajF);
                          dcdSize := FileSize(trajF)/1024/1024/1024;
                          totDcdSize := totDcdSize + dcdSize;
                          Str (totDcdSize:10:8, strDcdSize);
                          iml.infoMsg (0,2,name+'Accumulated DCD size: ' +
                                           strDcdSize+' GB');
                          Str (dcdSize:10:8, strDcdSize);
                          Close (trajF);
                          iml.infoMsg (0,1,name + 'DCD file size: ' +
                                           strDcdSize+' GB');
                          iniProdList := 'lappend trajInfo($id,trajFrag) [list '
                                    + 'iniProdSim ' + simName + ' ' + coor
                                    + ' 0 1 1 ' + strDcdSize + ' 0.0 0.0 unk '
                                    + 'unk unk]';
                          iml.infoMsg (0,1,name+
                            'NAMD traj fragment tcl list: ' + iniProdList)
                        end
                      else
                        iml.infoMsg (0,1,name+'No previous .coor file found.');
                    end;
                  trajFragTclRec (prevLog);
                end
              else
                begin
                  iml.infoMsg (2,1,name +
                                   'previous log file from restart not found');
                  mmLogInfo_finish
                end
            end
          else
            begin    {no xsc file, try to locate previous log from init coord}
              prevLog := copy(coord,1,length(coord) -
                            length(ExtractFileExt(coord))) + '.log';
              if FileExists(prevLog) and
                  (ExtractFileName(ExtractFileDir(coord)) <> 'struct') then
                begin
                  iml.infoMsg (0,1,name +
                     'Previuos log file located from initial coord: '+prevLog);
                  trajFragTclRec (prevLog)
                end
              else
                begin
                  if FileExists(coord) then
                    begin
                      Assign (trajF, coord);
                      Reset (trajF);
                      dcdSize := FileSize(trajF)/1024/1024/1024;
                      totDcdSize := totDcdSize + dcdSize;
                      str (totDcdSize:10:8, strDcdSize);
                      iml.infoMsg (0,2,name+'Accumulated DCD size: ' +
                        strDcdSize+' GB');
                      str (dcdSize:10:8, strDcdSize);
                      Close (trajF);
                      iml.infoMsg (0,1,name+'DCD file size: '+strDcdSize+' GB')
                    end
                  else
                    strDcdSize := 'unk';
                  addGlobalTrajInfo;   {trajInfo script header}
                  strTmp := ExtractFileName(psf);
                  strTmp := copy(strTmp,1,length(strTmp) - 4);
                  script.outDev ('lappend trajInfo($id,trajFrag) [list '+strTmp+
                                 ' iniCoord '+coord+' 0 1 1 '+strDcdSize+
                                 ' 0 0 unk unk unk]');
                  iml.infoMsg (0,1,name+'no previous namd log file found.')
                end
            end
        end;   {with}
      if iniProdList <> '' then
        script.outDev (iniProdList);
      script.outDev (strList);
      if finProdList <> '' then
        script.outDev (finProdList);
    end;   {trajFragTclRec}

  procedure addDefSelInfo;
    begin   {addDefSelInfo}
      with script do
        begin
          outDev('');
          outDev('# Declaring default atom selections in the selInfo array.');
          outDev('');
          outDev('set selInfo(CA-m$id,molId) $id');
          outDev('set selInfo(CA-m$id,selTxt) "protein and name CA"');
          outDev('set selInfo(CAref-m$id,molId) $id');
          outDev('set selInfo(CAref-m$id,selTxt) "protein and name CA"');
          outDev('set selInfo(CAref-m$id,fragId) iniCoord');
          outDev('set selInfo(prot-m$id,molId) $id');
          outDev('set selInfo(prot-m$id,selTxt) "protein"');
          outDev('set selInfo(protRef-m$id,molId) $id');
          outDev('set selInfo(protRef-m$id,selTxt) "protein"');
          outDev('set selInfo(protRef-m$id,fragId) iniCoord');
          outDev('set selInfo(pnoh-m$id,molId) $id');
          outDev('set selInfo(pnoh-m$id,selTxt) "protein and noh"');
          outDev('set selInfo(pnohRef-m$id,molId) $id');
          outDev('set selInfo(pnohRef-m$id,selTxt) "protein and noh"');
          outDev('set selInfo(pnohRef-m$id,fragId) iniCoord');
          outDev('set selInfo(HBd-m$id,molId) $id');
          outDev('set selInfo(HBd-m$id,selTxt) "(protein within 1.2 of ' +
                    'hydrogen) and (oxygen or nitrogen)"');
          outDev('set selInfo(HBa-m$id,molId) $id');
          outDev('set selInfo(HBa-m$id,selTxt) "protein and ' +
                    '(oxygen or nitrogen)"');
          outDev('');
          outDev('puts "selInfo array: [array names selInfo]"');
          outDev('');
          outDev
            ('# Declaring default VMD molecule representations:');
          outDev('');
          outDev('# default rep 0 for all atoms as lines (hidden)');
          outDev('mol showrep $id 0 0');
          outDev('');
          outDev('# adding rep 1 for water molecules as lines (hidden)');
          outDev('mol color Name');
          outDev('mol representation Lines 1.0');
          outDev('mol selection "water or segname WTC"');
          outDev('mol material Opaque');
          outDev('mol addrep $id');
          outDev('mol showrep $id 1 0');
          outDev('');
          outDev('# adding rep 2 for protein as tube');
          outDev('mol representation Tube 0.3 15.0');
          outDev('mol color Molecule');
          outDev('mol selection protein');
          outDev('mol addrep $id');
          outDev('');
          outDev('# adding rep 3 for protein heavy atoms as lines');
          outDev('mol representation Lines 2.0');
          outDev('mol color Name');
          outDev('mol selection "protein and noh"');
          outDev('mol addrep $id');
          outDev('');
          outDev('# adding rep 4 for ions as VDW spheres');
          outDev('mol representation VDW 0.6 15.0');
          outDev('mol selection ion');
          outDev('mol addrep $id');
          outDev('');
          outDev('# adding rep 5 for non-protein ligands as licorice');
          outDev('mol representation Licorice 0.3 12.0 12.0');
          outDev('mol selection "not (protein or water or ion)"');
          outDev('mol addrep $id');
          outDev(''); 
          outDev('');
          outDev('return $id'); 
          outDev('');
        end;   {with}
    end;   {addDefSelInfo}

  begin   {namdLogTrajInfo}
{initializing variables}
    psfGlobal := '';
    totDcdSize := 0.0;
    trajName := ExtractFileName(ExtractFileDir(ExpandFileName(
                                          ExtractFilePath(logFile)+'..')+'/'));
{initializing output files}
    script.init;
    script.setOutputDevice (c_outDev_screen_file,
                        'trajInfo_' + trajName + '_namdLog.tcl', 'REWRITE');
    iml.infoMsg (0, 1, 'namdLogTrajInfo: Tcl script for VMD: ' +
                       script.getOutputFileName);
{recursive generation of trajFrag lists (including script header)}
    trajFragTclRec (logFile);
{adding default selInfo for the simulation}
    addDefSelInfo;
{terminating scripts}
    script.finish;
  end;   {namdLogTrajInfo}


{|-procedure commandInt; :
 |  -command-line interpreter for choosing diverse types of procedures ;|}
procedure commandInt;
  begin
    
  end;   {commandInt}


begin   {*** program mmLogInfo ***}
  mmLogInfo_init;

  case functionOpt of
      'namdLog' : namdLogTrajInfo;
      'demonOut' : ;
    end;

  mmLogInfo_finish;
end.

