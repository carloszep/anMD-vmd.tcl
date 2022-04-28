{|-unit ioDrv :
 |  -freepascal unit managing different types of inputs and outputs .
 |  -started and improved from infoMsg unit v.0.0.5 ;
 |  -version :-0.0.5 ;
 |  -Author :-Carlos Z. Gómez Castro ;
 |  -Date :-2013-12-26.Thr ;
 |  -version information :
 |    -for implementing in future versions :
 |      -to include time and date information in log messages and in headers .
 |      -to use the newer tools in freepascal to manage file such as the
 |       _ CFileStream class or the FileCreate, fileWrite, etc. functions .
 |      -to include different types of output format .
 |      -to include devices as objects, printers or network destinations ;
 |    -changes to be done in this version :
 |      -implement an external device (object) in infoMsg :
 |        -when a object is used to send info messages, an aditional object
 |         _ can also recieve and print these messages .
 |        -useful to have a single log file for several units or objects ;
 |    -new features incorporated or changed in this version :
 |      -methods linkExtDev and unlinkExtDev added to obj_infoMsg .
 |      -field extDev added ot obj_infoMsg .
 |      -obj_infoMsg.infoMsg and test_infoMsg updated to use extDev .
 |      -definition of outExtDev in obj_output was changed ;
 |    -finished version ;
 |  -interface section (public definitions) :
 |    -constants (const section) :
 |      -inpOutDrv_name :-unit name ;
 |      -inpOutDrv_version :-unit version ;
 |      -c_outDev_none :-no output is sent to any device (= 0) ;
 |      -c_outDev_screen :-device oputput is sent to the screen (= 1) ;
 |      -c_outDev_file :-device output sent to a file (= 2) ;
 |      -c_outDev_screen_file :-output sent to the screen and a file (= 3) ;
 |      -c_outLvl_none :-no log output is displayed (= 0) ;
 |      -c_outLvl_moderated :-only critical information is sent to log (= 1) ;
 |      -c_outLvl_detailed :-most of the information is sent to log (= 2) ;
 |      -c_outLvl_extense :-all log information is displayed (= 3) ;
 |      -c_error_none :-idicates no error has occurried (= 0) ;
 |      -c_error_generic :-generic or unknown error (= 1) ;
 |      -c_error_input :-input error (= 2) ;
 |      -c_error_option :-error in an option (= 3) ;
 |      -c_error_context :-error in context (= 4) ;
 |      -c_error_pointer :-pointer link lost (= 5) ;
 |      -c_error_output :-output error (= 6) ;;
 |    -type definitions (type section) :
 |      -obj_output :
 |        -object to direct output towards different devices .
 |        -private properties :
 |          -outputDevice :-indicates to which device the output is sent .
 |            -acceptable values :
 |              -0 :-no device is used, no output is displayed ;
 |              -1 :-the screen is used as output device ;
 |              -2 :-a file is used as output device ;
 |              -3 :-both the screen and a file are used as output device ;;;
 |          -outputFileName :-filename for the file output device ;
 |          -prefixStr :-prefix string for each line of text output ;
 |          -sufixStr :-sufix string for each line of text output ;
 |          -lastMsg :-stores the last info/error messgage generated ;;
 |        -public properties :
 |          -outputFile :
 |            -file device for output .
 |            -made public to allow external objects to write into this object
 |             _ directly ;;
 |        -public methods :
 |          -init :-initialization precedure ;
 |          -setPrefixStr :-sets the prefix string ;
 |          -setSufixStr :-sets the sufix string ;
 |          -setOutputDevice :-sets the output device and the file name ;
 |          -outDev :-output a string to the current device(s)  ;
 |          -outExtDev :-output a string to a specified file ;
 |          -outPartLine :-output a string to the current device without
 |           _ passing to the next line ;
 |          -outNewLine :-writes a "return line"* in the current device ;
 |          -getOutputStr :-return the string to be sent to the output device ;
 |          -repOutputDevice :-report the current output device ;
 |          -getOutputDevice :-return the current output devices identifier ;
 |          -getPrefixStr :-return the current prefixStr parameter ;
 |          -getSufixStr :-return the current sufixStr parameter ;
 |          -getOutputFileName :-return the current output file name ;
 |          -getLastMsg :-return the value of the property lastMsg ;;;
 |      -obj_infoMsg :
 |        -object intended to manage information and log messages .
 |        -inherited from obj_output .
 |        -it manages different levels of output to help debbuging programs .
 |        -private properties :
 |          -infoMsgName :-name identifying the object ;
 |          -extDev :-pointer to an external obj_infoMsg object ;
 |          -outputLevel :
 |            -controls the quantity and detail of information messages .
 |            -acceptable values :
 |              -0 :-no messages are passed to the output device ;
 |              -1 :-Only critical or important information is displayed ;
 |              -2 :-Detailed information is displayed in the output device ;
 |              -3 :-All information messages are shown ;;;
 |          -userError :-user flag indicating an error ;
 |          -userErrorId :-Identifier of the user error ;;
 |        -public methods :
 |          -init .
 |          -setInfoMsgName :-sets the object name ;
 |          -setOutputLevel :-sets the quantity of information messages ;
 |          -linkExtDev :-Creates a link to an external infoMsg object ;
 |          -unlinkExtDev :-unlinks the external device object ;
 |          -infoMsg :
 |            -send a message to the output device .
 |            -the message will be filtered regarding the current outputLevel ;
 |          -clearError :-turn off the user error flag ;
 |          -getInfoMsgName :-return the name of the object ;
 |          -getError :-return the value of the user error flag ;
 |          -getErrorId :-return the value of the user error identifier ;
 |          -finish :-finalizes the object ;;;;;
 |  -implementation section :
 |    - ;;|}
unit ioDrv;

interface

const

  inpOutDrv_name = 'ioDrv';
  inpOutDrv_version = '0.0.5';

  c_outDev_none = 0;
  c_outDev_screen = 1;
  c_outDev_file = 2;
  c_outDev_screen_file = 3;
  c_outLvl_none = 0;
  c_outLvl_moderated = 1;
  c_outLvl_detailed = 2;
  c_outLvl_extense = 3;
  c_error_none = 0;
  c_error_generic = 1;
  c_error_input = 2;
  c_error_option = 3;
  c_error_context = 4;
  c_error_pointer = 5;
  c_error_output = 6;
  c_error_file = 7;

type

  obj_output = object
    private
      outputDevice: byte;
      outputFileName: string;
      prefixStr: string;
      sufixStr: string;
      lastMsg: string;
    public
      outputFile: text;
      constructor init;
      procedure setPrefixStr (pStr: string);
      procedure setSufixStr (sStr: string);
      procedure setOutputDevice (devOption: byte; fileName,openOpt: string);
      procedure outDev (outText: string);
      procedure outExtDev (var extDevTxt: text; outText: string);
      procedure outPartLine (outText: string);
      procedure outNewLine;
      function getOutputStr (outText: string): string;
      function repOutputDevice: string;
      function getOutputDevice: byte;
      function getPrefixStr: string;
      function getSufixStr: string;
      function getOutputFileName: string;
      function getLastMsg: string;
      destructor finish;
    end;

  p_infoMsg = ^obj_infoMsg;
  obj_infoMsg = object (obj_output)
    private
      infoMsgName: string;
      extDev : p_infoMsg;
      outputLevel: byte;
      userError: boolean;
      userErrorId: byte;
    public
      constructor init;
      procedure setInfoMsgName (name: string);
      procedure setOutputLevel (outLvl: byte);
      procedure linkExtDev (var extDevObj: obj_infoMsg);
      procedure unlinkExtDev;
      procedure infoMsg (Id, outLvl: byte; info: string);
      procedure clearError;
      function getInfoMsgName: string;
      function getError: boolean;
      function getErrorId: byte;
      destructor finish;
    end;

  procedure ioDrv_test (testName: string);
  
implementation

{|-procedure obj_output.init :
 |  -initializes the object properties ;|}
constructor obj_output.init;
  begin
    outputDevice:=c_outDev_screen;   {=1}
    outputFileName:='';
    prefixStr:='';
    sufixStr:='';
    lastMsg:='';
  end;   {obj_output.init}

{|-procedure obj_output.setPrefixStr (pStr: string); :
 |  -set the prefix string .
 |  -arguments :
 |    -pStr :-prefix string ;;;|}
procedure obj_output.setPrefixStr (pStr: string);
  begin
    prefixStr:=pStr;
  end;   {obj_output.setPrefixStr}

{|-procedure obj_output.setSufixStr (sStr: string); :
 |  -set the sufix string .
 |  -arguments :
 |    -sStr :-sufix string ;;;|}
procedure obj_output.setSufixStr (sStr: string);
  begin
    sufixStr:=sStr;
  end;   {obj_output.setSufixStr}

{|-procedure obj_output.setOutputDevice (devOption: byte; fileName,
 |                                                      _openOpt: string); :
 |  -set the output device and the filename .
 |  -arguments :
 |    -devOption :-device used for output ;
 |    -fileName :-name for the device file output ;
 |    -openOpt :
 |      -specifies if the output file should be open to append or rewrite .
 |      -acceptable values :
 |        -'REWRITE','R' :
 |          -if the specified file already exists it will be overwritted .
 |          -any other value will cause the output to be appended ;;;;;|}
procedure obj_output.setOutputDevice (devOption: byte; fileName,
                                                       openOpt: string);
    var
      msg: string = 'setOutputDevice: ';
      msgt: string;

  begin   {obj_output.setOutputDevice}
    if devOption > 3 then   {error checking}
      begin
        lastMsg:=msg+'Allowed values for outputDevice are 0-3.';
        exit
      end;
    if devOption = outputDevice then   {error checking}
      begin
        if (devOption = 0) or (devOption = 1) then
          begin
            str (outputDevice, msgt);
            lastMsg:=msg+'outputDevice was already set to: '+msgt;
            exit
          end
        else   {is correct only if a change in the log file is requested}
          if (fileName = '') or (fileName = outputFileName) then
            begin
              str (outputDevice, msgt);
              lastMsg:=msg+'outputDevice is already: '+msgt+
                       ', and no new name for the log file was specified.';
              exit
            end
      end;
    if (outputDevice = 2) or (outputDevice = 3) then {closing current file}
      if (devOption = 0) or (devOption = 1) then
        begin
          lastMsg:=msg+'Closing the log file currently in use.';
          outputFileName:='';
          flush (outputFile);
          close (outputFile);
        end
      else   {outOp is 2 or 3}
        begin   {closes the file only when a new name is specified}
          if (fileName <> '') and (fileName <> outputFileName) then
            begin
              lastMsg:=msg+'Closing the log file currently in use.';
              outputFileName:='';
              flush (outputFile);
              close (outputFile);
            end;
        end;
    if (devOption = 2) or (devOption = 3) then   {creating a new outputFile}
      if (fileName <> '') and (fileName <> outputFileName) then
        begin   {A new outputFile will be created}
          outputFileName:=fileName;
          assign (outputFile, outputFileName);
          if (upCase(openOpt) = 'R') or (upCase(openOpt) = 'REWRITE') then
            begin
              rewrite (outputFile);
              lastMsg:=msg+'New file created for output.'
            end
          else   {include openOpt = 'A' or 'append'}
            begin
{$I-}         append (outputFile); {$I+}
              if IOResult <> 0 then
                begin
                  lastMsg:=msg+'File not found. Creating a new File.';
                  rewrite (outputFile)
                end
              else
                lastMsg:=msg+'Appending output to the File.'
            end
        end
      else
        if (outputDevice = 0) or (outputDevice = 1) then
          begin
            lastMsg:=msg+'Log file output was requested but no ' +
                                 'file name was specified.';
            exit
          end;
    outputDevice:=devOption
  end;   {obj_output.setOutputDevice}

{|-procedure obj_output.outDev (outText: string); :
 |  -prints a string into one or more devices specified by the object
 |   _ properties .
 |  -arguments :
 |    -outText :-output string ;;;|}
procedure obj_output.outDev (outText: string);
  begin
    case outputDevice of
      1: writeln (getOutputStr(outText));
      2: writeln (outputFile, getOutputStr(outText));
      3: begin
           writeln (getOutputStr(outText));
           writeln (outputFile, getOutputStr(outText))
         end
      end;
    lastMsg:='outMsg: printed: "' + getOutputStr(outText) + '" ' +
             repOutputDevice;
  end;   {obj_output.outDev}

{|-procedure outExtDev (var extDevTxt: text; outText: string); :
 |  -print a string in a specified text file (external device) .
 |  -arguments :
 |    -extDevTxt :-already opened and assigned text file ;
 |    -outText :-output string ;;;|}
procedure obj_output.outExtDev (var extDevTxt: text; outText: string);
  begin
    writeln (extDevTxt, getOutputStr(outText));
    lastMsg:='outMsg: printed: "' + getOutputStr(outText) + '" ' +
             ' to a external file.'
  end;   {obj_output.outExtDev}

{|-procedure obj_output.outPartLine (outText: string); :
 |  -prints a string without retuning line (next line character)* to the
 |   _ current device .
 |  -no prefixStr or sufixStr is printed .
 |  -arguments :
 |    -outText :-output string ;;;|}
procedure obj_output.outPartLine (outText: string);
  begin
    case outputDevice of
      1: write (outText);
      2: write (outputFile, outText);
      3: begin
           write (outText);
           write (outputFile, outText)
         end
      end;
    lastMsg:='outMsg: printed: "' + outText + '" ' + repOutputDevice +
             '. No return to the next line printed';
  end;   {obj_output.outPrtLine}

{|-procedure obj_output.outNewLine; :
 |  -prints a writeln in the current device .
 |  -no prefixStr or sufixStr is printed ;|}
procedure obj_output.outNewLine;
  begin
    case outputDevice of
      1: writeln;
      2: writeln (outputFile);
      3: begin
           writeln;
           writeln (outputFile)
         end
      end;
    lastMsg:='outMsg: return to the next line printed: ' + repOutputDevice
  end;   {obj_output.outNewLine}

{|-function obj_output.getOutputStr (outText: string): string; :
 |  -reports the output string to be sent to the output device .
 |  -arguments :
 |    -outText :-output string ;;;|}
function obj_output.getOutputStr (outText: string): string;
  begin
   getOutputStr:=prefixStr + outText + sufixStr
  end;   {obj_output.getOutputStr}

{|-obj_output.repOutputDevice: string; :
 |  -Returns a string reporting the current output device and file name used ;|}
function obj_output.repOutputDevice: string;
  begin
    case outputDevice of
        0: repOutputDevice:='output device: none';
        1: repOutputDevice:='output device: screen';
        2: repOutputDevice:='output device: file; file name: '+outputFileName;
        3: repOutputDevice:='output device: screen and file; file name: ' +
                            outputFileName
      end;
    lastMsg:='repOutputDevice: output device reported.'
  end;   {obj_output.repOutputDevice}

{|-function obj_output.getOutputDevice: byte; :
 |  -return the current output device identifier ;|}
function obj_output.getOutputDevice: byte;
  var
    valStr: string;
  begin
    getOutputDevice:=outputDevice;
    str (outputDevice, valStr);
    lastMsg:='getOutputDevice: output device returned: ' + valStr
  end;   {obj_output.repOutputDevice}

{|-function obj_output.getPrefixStr: string; :
 |  -return the current value of the prefix string parameter ;|}
function obj_output.getPrefixStr: string;
  begin
    getPrefixStr:=prefixStr;
    lastMsg:='getPrefixStr: prefix string returned: ' + prefixStr
  end;   {obj_output.getPrefixStr}

{|-function obj_output.getSufixStr: string; :
 |  -return the current value of the sufix string parameter ;|}
function obj_output.getSufixStr: string;
  begin
    getSufixStr:=sufixStr;
    lastMsg:='getSufixStr: sufix string returned: ' + sufixStr
  end;   {obj_output.getsufixStr}

{|-function obj_output.getOutputFileName: string; :
 |  -return the value of the output file name parameter ;|}
function obj_output.getOutputFileName: string;
  begin
    getOutputFileName:=outputFileName;
    lastMsg:='getOutputFileName: output file name returned: ' + outputFileName
  end;   {obj_output.getOutputFileName: string;}

{|-function obj_output.getLastMsg: string; :
 |  -return the value of the last message generated ;|}
function obj_output.getLastMsg: string;
  begin
    getLastMsg:=lastMsg;
    lastMsg:='getLastMsg: last message returned: ' + lastMsg
  end;   {obj_output.getLastMsg}

{|-destructor obj_output.finish; :
 |  -finalizes the object ;|}
destructor obj_output.finish;
  begin
    setOutputDevice (c_outDev_none,'','');
    lastMsg:='finish: output object finalized.'
  end;   {obj_output.finish}

{|-procedure obj_infoMsg.init; :-initializes the object ;|}
constructor obj_infoMsg.init;
  begin
    obj_output.init;
    infoMsgName:='infoMsg';
    extDev := NIL;
    outputLevel:=c_outLvl_moderated;   {= 1}
    userError:=FALSE;
    userErrorId:=0;
  end;   {obj_infoMsg.init}

{|-procedure obj_infoMsg.setInfoMsgName (name: string); :
 |  -sets the name of the object identifying the particular object .
 |  -this name will be prepended in all output messages ;|}
procedure obj_infoMsg.setInfoMsgName (name: string);
  begin
    infoMsgName:=name;
    lastMsg:='setInfoMsgName: setting infoMsg name to: ' + name;
  end;   {obj_infoMsg.setInfoMsgName}

{|-procedure obj_infoMsg.setOutputLevel (outLvl: byte); :
 |  -sets the value for outputLevel which specifies the amount of output .
 |  -arguments :
 |    -outLvl :
 |      -Acceptable values :
 |        -0 :-No output is sent to any of the output destinations ;
 |        -1 :-Only elemental output is displayed (Infos and Errors) ;
 |        -2 :-Detailed and non-crucial output is displayed ;
 |        -3 :-All messages are included in output ;;
 |      -Default Value :-1 ;;;;|}
procedure obj_infoMsg.setOutputLevel (outLvl: byte);
  var
    msgt: string;
  begin
    if outLvl > 3 then
      infoMsg (3,1,'setOutputLevel: Allowed values for outputLevel are 0 - 3.')
    else
      begin
        str (outLvl, msgt);
        infoMsg (0,1,'setOutputLevel: Setting outputLevel to: ' + msgt);
        outputLevel:=outLvl;
      end;
  end;   {obj_infoMsg.setOutputLevel}

{|-procedure obj_infoMsg.linkExtDev (var extDevObj: obj_infoMsg); :
 |  -link an external infoMsg object as external device for output .
 |  -the external object is supposed to be already initializated .
 |  -arguments :
 |    -extDevObj :-infoMsg object ;;;|}
procedure obj_infoMsg.linkExtDev (var extDevObj: obj_infoMsg);
  begin
    extDev := @extDevObj;
  end;   {obj_infoMsg.linkExtDev}
  
procedure obj_infoMsg.unlinkExtDev;
  begin
    extDev := NIL;
  end;   {obj_infoMsg.unlinkExtDev}

{|-procedure obj_infoMsg.infoMsg (Id, outLvl: byte; info: string); :
 |  -generates output messages and activates error flags .
 |  -Arguments :
 |    -Id :-error type .-used to perform additional error-specific actions ;
 |    -outLvl :-output level of the message .
 |      -the message is displayed only if outLvl is smaller or equal than the
 |       _object property outputLevel ;
 |    -info :-message to be output ;;|}
procedure obj_infoMsg.infoMsg (Id, outLvl: byte; info: string);
  var
    msg: string;
  begin
    userError:=true; {activates the error indicator}
    userErrorId:=Id; {updates the error Id status}
    case Id of {checks error type and performs additional actions}
        0: begin
             msg:=infoMsgName + ': Info: ';
             userError := false; {no error, information message instead}
           end;
        1: msg:=infoMsgName + ': Error: ';
        2: msg:=infoMsgName + ': Error: Input error: ';
        3: msg:=infoMsgName + ': Error: Invalid option: ';
        4: msg:=infoMsgName + ': Error: Invalid procedure context: ';
        5: msg:=infoMsgName + ': Error: Pointer link lost: ';
        6: msg:=infoMsgName + ': Error: Output error: ';
        7: msg:=infoMsgName + ': Error: I/O file error: ';
      else
        msg:=infoMsgName + ': Unknown Error: ';
      end;
    msg:=msg + info;
    lastMsg:=msg;
    if (outLvl <= outputLevel) and (outputLevel <> 0) and (outLvl <> 0) then
      outDev (msg);
    if extDev <> NIL then
      extDev^.infoMsg (Id, outLvl, infoMsgName + ': ' + info)
  end;   {obj_infoMsg.infoMsg}

{|-procedure obj_infoMsg.clearError; :-turn off user error flags ;|}
procedure obj_infoMsg.clearError;
  begin
    userError:=false;
    userErrorId:=0;
    lastMsg:='clearError: user error flag turned off.'
  end;   {obj_infoMsg.clearError}

{|-procedure obj_infoMsg.getInfoMsgName: string; :
 |  -retun the name assigned to the object ;|}
function obj_infoMsg.getInfoMsgName: string;
  begin
    getInfoMsgName:=infoMsgName;
    lastMsg:='getInfoMsgName: Info message name returned: ' + infoMsgName;
  end;   {obj_infoMsg.getInfoMsgName}

{|-function obj_infoMsg.getError: boolean; :
 |  -returns the value of variable userError ;|}
function obj_infoMsg.getError: boolean;
  var
    valstr: string;
  begin
    if userError then valstr:='TRUE' else valstr:='FALSE';
    lastMsg:='getError: value of usrError returned: ' + valstr;
    getError:=userError
  end;   {obj_infoMsg.getError}

{|-function obj_infoMsg.getErrorId: byte; :
 |  -returns the value of variable userErrorId ;|}
function obj_infoMsg.getErrorId: byte;
  var
    valstr: string;
  begin
    str (userErrorId,valstr);
    lastMsg:='getErrorId: value of userErrorId returned: ' + valstr;
    getErrorId:=userErrorId
  end;   {obj_infoMsg.getErrorId}

{|-destructor obj_infoMsg.finish; :
 |  -finalizes the onject infoMsg .-closes the log file if it is open ;|}
destructor obj_infoMsg.finish;
  begin
    obj_output.finish;
    extDev := NIL;
    lastmsg:='finish: infoMsg object finalized.';
  end;   {obj_infoMsg.finish}


{|-procedure ioDrv_test (testName: string); :
 |  -public procedure for unit tests .
 |  -arguments :
 |    -testName :-name of the test to perform .
 |      -acceptable values :
 |        -'outDev' :-calls the test_outDev procedure ;;;;
 |  -internal procedures :
 |    -test_outDev :-test for setting up different output devices ;;;|}
procedure ioDrv_test (testName: string);
  var
    outObj: obj_output;
    infoObj: obj_infoMsg;
    msg: string = 'Hello world!';

  procedure test_outDev;
    var
      extDev: text;
    begin   {test_outDev}
      writeln ('*** test_outDev: Testing output devices in a obj_output. ***');
      writeln ('Initializing the output object...');
      outObj.init;
      writeln ('msg: "' + msg + '"');
      outObj.setPrefixStr ('<<');
      outObj.setSufixStr ('>>');
      writeln ('prefixStr: "' + outObj.getPrefixStr + '";   sufixStr: "' +
               outObj.getSufixStr + '"');
      writeln ('Printed together with the output device.');
      writeln ('setting output device to none and printing');
      outObj.setOutputDevice (c_outDev_none,'','');   {= 0}
      outObj.outDev (msg + ' - ' + outObj.repOutputDevice);
      writeln ('setting output device to screen and printing');
      outObj.setOutputDevice (c_outDev_screen,'','');   {= 1}
      outObj.outDev (msg + ' - ' + outObj.repOutputDevice);
      writeln ('setting output device to file test_outDev.txt and printing.');
      outObj.setOutputDevice (c_outDev_file,'test_outDev.txt','R');   {= 2}
      outObj.outDev (msg + ' - ' + outObj.repOutputDevice);
      writeln ('setting output device to the screen plus the file ' +
               'test_outDev.txt  and printing.');
      outObj.setOutputDevice (c_outDev_screen_file,'test_outDev.txt','R'); {=3}
      outObj.outDev (msg + ' - ' + outObj.repOutputDevice);
      writeln ('setting file test_outDev_extDev.txt as external device and ' +
               'printing.');
      assign (extDev, 'test_outDev_extDev.txt');
      rewrite (extDev);
      outObj.outExtDev (extDev, msg + ' - ' + outObj.repOutputDevice);
      close (extDev);
      writeln ('printing a line in parts in the current device.');
      outObj.outPartLine ('line ');
      outObj.outPartLine ('in ');
      outObj.outPartLine ('parts. ' + msg + ' - ' + outObj.repOutputDevice);
      outObj.outNewLine;
      outObj.outDev ('Other line.');
      writeln ('*** test_outDev: test finished. Closing files. ***');
      outObj.finish;
    end;   {test_outDev}

  procedure test_infoMsg;
    var
      extObj : obj_infoMsg;
    procedure sendLogMsgs;
      begin
        infoObj.infoMsg (0,3,'+++ Sending log messages. Levels 0-4. +++');
        infoObj.infoMsg (0,0,msg + ' Message level 0');
        infoObj.infoMsg (0,1,msg + ' Message level 1');
        infoObj.infoMsg (0,2,msg + ' Message level 2');
        infoObj.infoMsg (0,3,msg + ' Message level 3');
        infoObj.infoMsg (0,4,msg + ' Message level 4');
      end;
    begin   {test_infoMsg}
      writeln ('*** test_infoMsg: testing output levels in obj_infoMsg. ***');
      writeln ('Initializing the object...');
      infoObj.init;
      writeln ('msg: "' + msg + '"');
      infoObj.setInfoMsgName ('infoMsg-tests');
      writeln ('Info message name: ' + infoObj.getInfoMsgName);
      infoObj.setOutputDevice (c_outDev_screen_file,'test_infoMsg.txt','R');
      writeln (infoObj.lastMsg);
      writeln ('setting output level to 0 and printing messages.');
      infoObj.setOutputLevel (c_outLvl_none);
      sendLogMsgs;
      writeln ('setting output level to 1 and printing messages.');
      infoObj.setOutputLevel (c_outLvl_moderated);
      sendLogMsgs;
      writeln ('setting output level to 2 and printing messages.');
      infoObj.setOutputLevel (c_outLvl_detailed);
      sendLogMsgs;
      writeln ('setting output level to 3 and printing messages.');
      infoObj.setOutputLevel (c_outLvl_extense);
      sendLogMsgs;
      writeln ('testing external device object...');
      extObj.init;
      extObj.setInfoMsgName ('extDev-test');
      extObj.setOutputDevice (c_outDev_file,'extDevFile_test.txt','R');
      extObj.setOutputLevel (c_outLvl_extense);
      extObj.setPrefixStr ('+ext+ ');
      infoObj.linkExtDev (extObj);
      infoObj.infoMsg (0, 1, 'Msgs sent by infoObj, also printed by extObj:');
      sendLogMsgs;
      infoObj.unlinkExtDev;
      infoObj.infoMsg (0, 1, 'extObj unlinked. Should not print this msg.');
      writeln ('*** test_infoMsg: test finished. Closing files. ***');
      outObj.finish;
      infoObj.finish;
      extObj.finish;
    end;   {test_infoMsg}

  begin   {ioDrv_test}
    if testName = 'outDev' then
      test_outDev
    else if testName = 'infoMsg' then
      test_infoMsg
    else
      writeln ('ioDrv_test: options are: outDev, infoMsg');
  end;  {ioDrv_test}

begin   {ioDrv}

end.   {ioDrv}
