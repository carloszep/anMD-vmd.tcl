{
|-condText.pp :
|  -unit condText :
|    -freepascal unit that declares the object obj_condText .
|    -Handling of the Condensed Text format (condText) .
|    -version :-0.1.2 :
|    -version information :
|      -Date :-2014-01-09.Thr ;
|      -to be incorporated in future versions :
|        -incorporate the setPrepertyRecord and setGlobalPropertyRecord
|         _ procedures .
|        -functions getMaxLength, getMaxDepth, getNextLength, getContLength,
|         _ getTitleLength and addContTitle .
|        -printing features :
|          -the posibility of including colors or other formats .
|          -a way to override locally the global print depth option .
|          -print local nodes in alternate output devices .
|          -apply a local output type or level .
|          -printing nodes with their cont trees in a single line (compact) .
|          -the indenting (tabulators) of multiple-CTentries-single-CTlines ;
|        -searching along the title list .
|        -DB capabilities :
|          -includes capturing and retrieving data .
|          -performing statistics .
|          -optimizing the grouping (structure) of the ctDB ;
|      -unfinished features in this version :
|        -a generalized method to perform searches :
|          -will allow to detect in one instruction all of the entries
|           _ matching a given criteria and browse through all of them .
|          -it shall be possible to specify subsets of nodes to include in the
|           _ search such as the number of nodes and depth ;
|        -there seems to be a problem in the print method with the depth
|         _ argument along with the "compact" lines .
|        -to add a method to copy/move nodes from one CT object to another ;
|      -done features and changes in this version :
|        -condText_test updated ;
|        -gotoContStr, gotoNextStr, getFieldValue methods added and tested .
|        -getCurrStr, dbFieldStruct, moveCurrTo added and tested .
|        -dbFieldStruct was updated to add several records to a single record
|         _ entry .
|        -test for dataBases added .
|        -buildLine procedure in print method modified to avoid printing
|         _ cont nodes of propertyRecords ;
|      -unfinished version ;
|    -Created by :-Carlos Z. Gómez Castro ;
|    -interface section :
|      -uses :
|        -ioDrv v.0.0.5* ;
|      -constants :
|        -CTbase :
|          -value :-'|' ;
|          -Character used to identify condText lines ;
|        -condText_name :-name of the unit ;
|        -condText_version :-version of the unit in format #.#.# ;
|        -c_CToutType_plain :
|          -value :-0 ;
|          -only unformatted CTstr is printed ;
|        -c_CToutType_noCtrl :
|          -value :-1 ;
|          -formatted tab space, bullet and CTstr are printed ;
|        -c_CToutType_wCtrl :
|          -value :-2 ;
|          -formatted strBase, CTbase, tab space, bullet, CTstr, control
|           _ characters, endCTbase and strEnd are printed .
|          -the propertyRecord or hidden records are ignored ;
|        -c_CToutType_format :
|          -value :-3 ;
|          -all records are printed with control elements and formatted ;
|        -c_CToutType_unformat :
|          -value :-4 ;
|          -all records are printed with control elements with default
|           _ properties ;;
|      -types :
|        -t_lineTxt :-base string type for text strings ;
|        -rec_CTlineStr :
|          -record of strings with all elements from a particular CTline .
|          -elements :
|            -strBase :-text befor the CTbase ignored in the CT format ;
|            -CTbase :
|              -base character indicating the beginning or end of CTline ;
|            -tabStr :-tabulator spaces before the bullet ;
|            -bullet :-bullet character or string in each CTline ;
|            -CTstr :-User text ;
|            -hideStr :
|              -String added when truncated or hidden nodes are present ;
|            -ctrlSep :
|              -character separating the user text and the control characters ;
|            -ctrlStr :
|              -control characters indicating the type of the next nodes ;
|            -endCTbase :
|              -second CTbase character delimiting the CTline ;
|            -strEnd :
|              -text after the endCTbase ignored in the CT format ;;;
|        -p_CTnode :-pointer to the record rec_CTnode ;
|        -rec_CTnode :
|          -record for a node supporting the condText structure .
|          -record elements :
|            -CTstr :-User text ;
|            -next :-pointer to the next entry in the same level ;
|            -cont :-pointer to the first contents entry or sublevel ;
|            -user :-user pointer ;
|            -title :-pointer to the closest upper-level entry ;;
|        -rec_CTprop .
|          -record containing all properties of a condText structure .
|          -allows a portion or substructure to have its own properties* .
|          -record elements ;
|            -bullet :-string used as bullet ;
|            -tabspace :-number of spaces among each level of condText ;
|            -tabchar :-character to indicate the level or number of tabs ;
|            -ctrlSep :-character to separate ctrlChars from regular text ;
|            -contChar :-character to indicate a continuation line ;
|            -maxLength :-maximum number of characters in a CT line output ;
|            -minLength :-minimum length for a CT line output ;
|            -strBase :-output base string before CTbase character ;
|            -strEnd :-output ending string after a CTline ;
|            -mark :-string containing several flags or keywords .
|              -recognized keywords :
|                -hideTitle :
|                  -the node and its cont nodes will not be displayed .
|                  -it does no apply if the opType of the print method is 3 .
|                  -canceling keyword :-showTitle,showCont ;;
|                -hideCont :
|                  -only the cont nodes will be hidden .
|                  -canceling keyword :-showCont ;;
|                -select :
|                  -used to select or mark multiple nodes .
|                  -canceling keyword :-unselect ;;
|                -compact :
|                  -all single cont nodes with no cont or next nodes will be
|                   _ embeded to their title node in a multiple CTline .
|                  -canceling keyword :-extense ;;;;;;
|        -obj_condText :
|          -private fields :
|            -root :-fist node in the structure .
|              -only when the structure if empty it has the value nil ;
|            -currPos :-Pointer to the current node selected .
|              -several operations apply to the current position .
|              -only when the structure if empty it has the value nil ;
|            -defProp :-record containing default values for conText
|             _ properties .-type rec_CTprop ;;
|          -public methods :
|            -init :-Initialization of the properties of the object ;
|            -empty :-Indicates when the structure has no elements ;
|            -addRoot :-creates the first (root) node ;
|            -addNext :-creates a new node in the next position of currPos ;
|            -addCont :-creates a new node in the cont position of currPos ;
|            -addNextTitle :-Adds a new line one level up from currPos ;
|            -addFirst :-Inserts a new line as first node in the current
|             _ level (same title) ;
|            -addLast :-Appends a new line at the current level (same
|             _ title) ;
|            -addLastCont :-Appends a new line at the end of the cont list of
|             _ the current position ;
|            -addFieldValue :-Appends a new line at the end of the cont list
|             _ as field and includes its own cont node as value ;
|            -gotoRoot :-Moves currPos to the root node ;
|            -gotoNext :-Moves currPos to the current next node ;
|            -gotoCont :-Moves currPos to the current cont node ;
|            -gotoTitle :-Moves currPos to the current title node ;
|            -gotoPrev :-Moves currPos to the previous node ;
|            -gotoFirst :-Moves currPos to the first node of the current list,
|             _ (cont node of the title node or root node for the root list) ;
|            -gotoLast :-Moves currPos to the last node of the current list ;
|            -gotoRootTitle :-Moves currPos to the title of the root list ;
|            -gotoPos :-moves the currPos to a specified position ;
|            -gotoNextStr :-moves currPos to a node with a specific CTstr
|             _ in the next list ;
|            -gotoContStr :-moves currPos to a node with a specific CTstr
|             _ in the cont list ;
|            -del :-Deletes the current node selected ;
|            -delRec :-Deletes the current node and all cont subnodes ;
|            -delLevelRec :-Deletes all the nodes in the current titled
|             _ level recursively .-Only the current title is conserved ;
|            -delNextRec :-Deletes all next nodes recursively ;
|            -delContRec :-Deletes all cont nodes recursively ;
|            -findText :-searches a CTnode containing a specific text ;
|            -findTextRec :-searches a CTnode containing a specific text deep
|             _ inside the structure recursivelly ;
|            -findSubstr :-find the first node including a substring ;
|            -findSubstrRec :-finds a substring recursivelly ;
|            -search :-perform a search of a text with advanced options ;
|            -getRoot :-returns a pointer to the root node ;
|            -getCurrPos :-returns a pointer to the currPos ;
|            -getCurrStr :-return the CTstr of the current node at currPos ;
|            -getFieldValue :-returns a value string corresponding to a field ;
|            -getPropertyRecord :-Searches and extract object properties ;
|            -getTitlePropertyRecord :-search object properties in title list ;
|            -print :-Prints the contents of the structure ;
|            -open :-Reads and decodes condText from a text file ;
|            -moveCurrTo :-move the current node to an external CT object ;
|            -command :-Is a command interpreter to use the object ;
|            -finish :-finalizes the condText object ;;
|          -private methods :
|            -delNodeRec :-Deletes a node and all its subnodes ;
|            -tabStr :-return the prebullet string for a given node ;
|            -ctrlStr :-return the control characters string for a node ;
|            -CTlinePrint :-generates a CTlineStr record for a specific CTnode ;
|            -readStrPropVal :-reads from a string the value of a CTprop ;;;;
|      -public unit variables :
|        -CTlog :-infoMsg object used to manage information and errors ;
|      -unit functions and procedures :
|        -condText_test :-tests and shows the usage of the unit condText ;
|        -dbFieldStruct :-arranges a data base record into a CT structure ;;;
|    -implementation section .
|      -Unit internal procedures :
|        -condText_init :-initializes unit variables ;
|        -condText_finish :-finishes the log file of the unit (CTlog)  ;;;;
|  -Notes :
|    -error flags should be considered inside the object and not only in the
|     _ log object .
|    -Hay que checar la compatibilidad entre ctrlChars del usuario .
|    -en write, strEnd podría o no incluir CTbase .
|    -decidir en que forma almacenar (o leer) las listas numeradas .
|    -Podrían hacerse funciones que chequen si una línea de texto incluye
|     _ CTlines y/o CTentries con o sin errores .
|    -la detección de bullet en open no puede considerar más de un caracter .
|    -ReadStrPropVal podría estar incluida en getPropertyRecord ;
|    -getPropertyRecord podría tomar propiedades de los titles ;
|    -El puntero user de cada nodo podría usarse como un puntero a objetos ;
}

unit condText;

interface

{$H+}  {Ansi strings are used instead short strings}

uses
  ioDrv;

const
  CTbase = '|';

  condText_name = 'condText';
  condText_version = '0.1.2';

  c_CToutType_plain = 0;
  c_CToutType_noCtrl = 1;
  c_CToutType_wCtrl = 2;
  c_CToutType_format = 3;
  c_CToutType_unformat = 4;

type
  t_lineTxt = string;

  rec_CTlineStr = record
      strBase: t_lineTxt;
      CTbase: t_lineTxt;
      tabStr: t_lineTxt;
      bullet: t_lineTxt;
      CTstr: t_lineTxt;
      hideStr: t_lineTxt;
      ctrlSep: t_lineTxt;
      ctrlStr: t_lineTxt;
      endCTbase: t_lineTxt;
      strEnd: t_lineTxt;
    end;

  p_CTnode = ^rec_CTnode;
  rec_CTnode = record
    CTstr: string;
    next: p_CTnode;
    cont: p_CTnode;
    user: p_CTnode;
    title: p_CTnode;
  end;

  rec_CTprop = record
    bullet: t_lineTxt;
    tabSpace: byte;
    tabChar: char;
    ctrlSep: t_lineTxt;
    contChar: char;
    maxLength: byte;   {could be set to be integer type*}
    minLength: byte;
    strBase: t_lineTxt;
    strEnd: t_lineTxt;
    mark: t_lineTxt;
  end;

  p_condText = ^obj_condText;
  obj_condText = object
    private
      root: p_CTnode;
      currPos: p_CTnode;
      defProp: rec_CTprop;
    public
      constructor init;
      function empty: boolean;
      procedure addRoot (newStr: t_lineTxt);
      procedure addNext (newStr: t_lineTxt);
      procedure addCont (newStr: t_lineTxt);
      procedure addNextTitle (newStr: t_lineTxt);
      procedure addFirst (newStr: t_lineTxt);
      procedure addLast (newStr: t_lineTxt);
      procedure addLastCont (newStr: t_lineTxt);
      procedure addFieldValue (field,Value: t_lineTxt);
      procedure gotoRoot;
      procedure gotoNext;
      procedure gotoCont;
      procedure gotoTitle;
      procedure gotoPrev;
      procedure gotoFirst;
      procedure gotoLast;
      procedure gotoRootTitle;
      procedure gotoPos (pPos : p_CTnode);
      function gotoNextStr (nStr : string): boolean;
      function gotoContStr (nStr : string): boolean;
      procedure del;
      procedure delRec;
      procedure delLevelRec;
      procedure delNextRec;
      procedure delContRec;
      function findText (title: p_CTnode; str: string): p_CTnode;
      function findTextRec (title: p_CTnode; str: string): p_CTnode;
      function findSubstr (title: p_CTnode; substr: string): p_CTnode;
      function findSubstrRec (title: p_CTnode; substr: string): p_CTnode;
      function search (start : p_CTnode; lines : byte; depth : integer;
                           sType : byte; var CTfound : obj_condText) : boolean;
      function getRoot : p_CTnode;
      function getCurrPos : p_CTnode;
      function getCurrStr : string;
      function getFieldValue (title : p_CTnode; field : string) : t_lineTxt;
      function getPropertyRecord (title: p_CTnode;
                                  var prop: rec_CTprop): boolean;
      function getTitlePropertyRecord (node: p_CTnode;
                                       var prop: rec_CTprop): boolean;
      procedure print (node: p_CTnode; lines,depth: integer; 
                                   outType,outdev: byte; fileName: string);
      procedure open (fName: string; prevCtrl: t_lineTxt);
      procedure moveCurrTo (var ctTarget : obj_condText; prevCtrl : t_lineTxt);
      function command (input: string): string;
      destructor finish;
    private
      procedure delNodeRec (node: p_CTnode);
      function tabStr (node: p_CTnode): string;
      function ctrlStr (node: p_CTnode): string;
      procedure readStrPropVal (prpStr,valStr: string; var prop: rec_CTprop);
    end;

var
  CTlog: obj_infoMsg;

procedure dbFieldStruct (plEnt, templ, stEnt : obj_condText);
procedure condText_test (opt: string);
procedure condText_finish;

implementation

  type
    t_charSet = set of char;

  var
    bulletSet, ctrlCharSet: t_charSet;

{|-constructor obj_condText.init; :-intialization of the object;|}
  constructor obj_condText.init;
    begin
      root:=NIL;
      currPos:=NIL;
      with defProp do
        begin
          bullet:='-';
          tabSpace:=2;
          tabChar:=' ';
          ctrlSep:=' ';
          contChar:='_';
          maxLength:=80;
          minLength:=8;
          strBase:='';
          strEnd:='';
          mark:='compact';
        end;
      CTlog.infoMsg (0,3,'init: object condText initialized.');
    end;   {obj_condText.init}

{|-function obj_condText.empty: boolean; :
 |  -returns TRUE if the structure has no CTlines ;|}
  function obj_condText.empty: boolean;
    begin
      if (root = NIL) or (currPos = NIL) then
        begin
          CTlog.infoMsg (0,3,'empty: the structure is empty.');
          empty:=TRUE
        end
      else
        begin
          CTlog.infoMsg (0,3,'empty: the structure is not empty.');
          empty:=FALSE
        end
    end;   {obj_condText.empty}

{|-procedure obj_condText.addRoot (newStr: t_lineTxt); :
 |  -Creates the first node of the structure .
 |  -Can be used only when the structure is empty ;|}
  procedure obj_condText.addRoot (newStr : t_lineTxt);
    var
      rootNode : p_CTnode;
    begin
      if empty then
        begin
          new (rootNode);
          rootNode^.CTstr:= newStr;
          rootNode^.next:=NIL;
          rootNode^.cont:=NIL;
          rootNode^.user:=NIL;
          rootNode^.title:=NIL;
          root:=rootNode;
          currPos:=rootNode;
          CTlog.infoMsg (0, 2, 'addRoot: The first entry was created.');
          if newStr = '' then
            CTlog.infoMsg (0, 2, 'addRoot: An empty string was entered.')
        end
      else
        CTlog.infoMsg (4, 1, 'addRoot: The structure is not empty.')
    end;   {obj_condText.addRoot}

{|-procedure obj_condText.addNext (newStr : t_lineTxt); :
 |  -Creates a new node at the next position of currPos with the text newStr ;|}
  procedure obj_condText.addNext (newStr : t_lineTxt);
    var
      newNode: p_CTnode;
    begin
      if empty then
        CTlog.infoMsg (4, 1, 'addNext: The structure is empty.')
      else
        begin
          new (newNode);
          newNode^.CTstr:=newStr;
          newNode^.next:=currPos^.next;
          newNode^.cont:=NIL;
          newNode^.user:=NIL;
          newNode^.title:=currPos^.title;
          currPos^.next:=newNode;
          currPos:=newNode;
          CTlog.infoMsg (0, 2, 'addNext: A new next entry was created.');
          if newStr = '' then
            CTlog.infoMsg (0, 2, 'addNext: An empty string was entered.')
        end
    end;   {obj_condText.addNext}

{|-procedure obj_condText.addCont (newStr : t_lineTxt); :
 |  -Creates a new node at the cont position of currPos with the text newStr .
 |  -if there already are cont nodes, these are displaced to the next
 |   _position of the new node created ;|}
  procedure obj_condText.addCont (newStr : t_lineTxt);
    var
      newNode: p_CTnode;
    begin
      if empty then
        CTlog.infoMsg (4, 1, 'addCont: The structure is empty. ')
      else
        begin
          new (newNode);
          newNode^.CTstr:=newStr;
          newNode^.next:=currPos^.cont;
          newNode^.cont:=NIL;
          newNode^.user:=NIL;
          newNode^.title:=currPos;
          currPos^.cont:=newNode;
          currPos:=newNode;
          CTlog.infoMsg (0, 2, 'addCont: A new cont entry was created.');
          if newStr = '' then
            CTlog.infoMsg (0, 2, 'addCont: An empty string was entered.')
        end
    end;   {obj_condText.addCont}

{|-procedure obj_condText.addNextTitle (newStr: t_lineTxt); :
 |  -Adds a new node to the next position of then current title node ;|}
  procedure obj_condText.addNextTitle (newStr: t_lineTxt);
    begin
      if empty then
        CTlog.infoMsg (4, 1, 'addNextTitle: The structure is empty. ')
      else
        begin
          CTlog.clearError;
          gotoTitle;
          if CTlog.getError then   {root list}
            CTlog.infoMsg(4,1,'addNextTitle: root list, there is no title.')
          else   {currPos at the title}
            begin
              addNext (newStr);
              CTlog.infoMsg(0,2,'addNextTitle: A next entry was created for '
                             + 'the title node.')
            end
        end
    end;   {obj_condText.addNextTitle}

{|-procedure obj_condText.addFirst (newStr: t_lineTxt); :
 |  -Add a node as a first node of the current level list .
 |  -when the structure is empty the root node is created ;|}
  procedure obj_condText.addFirst (newStr: t_lineTxt);
    var
      firstNode: p_CTnode;
    begin
      if empty then
        begin
          addRoot (newStr);
          CTlog.infoMsg (0,1,'addFirst: The structure was empty, the root ' +
                         'entry was created.')
        end
      else   {the structure is not empty}
        begin
          CTlog.clearError;
          gotoTitle;
          if CTlog.getError then   {no title, root list, adding a new root}
            begin
              new (firstNode);
              firstNode^.CTstr:=newStr;
              firstNode^.next:=root;
              firstNode^.cont:=NIL;
              firstNode^.user:=NIL;
              firstNode^.title:=NIL;
              root:=firstNode;
              currPos:=root;
              CTlog.infoMsg (0, 2, 'addFirst: A new root entry was added.')
            end
          else   {currPos at the title}
            begin
              addCont (newStr);
              CTlog.infoMsg (0,3,'addFirst: A new first entry was added.')
            end
        end
    end;   {obj_condText.addFirst}

{|-procedure obj_condText.addLast (newStr: t_lineTxt); :
 |  -Adds the Last node of the current list .
 |  -It is allowed to create the root node when the structure is empty to
 |   _ provide a kind of append feature ;|}
  procedure obj_condText.addLast (newStr: t_lineTxt);
    begin
      if empty then
        begin
          addRoot (newStr);
          CTlog.infoMsg (0,1,'addLast: The structure was empty, the root ' +
                         'entry was created.')
        end
      else
        begin
          gotoLast;
          addNext (newStr);
          CTlog.infoMsg (0,3,'addLast: A last entry was added.')
        end
    end;   {obj_condText.addLast}

{|-procedure obj_condText.addLastCont (newStr: t_lineTxt); :
 |  -Adds a new last node to the cont list ot the current position ;|}
  procedure obj_condText.addLastCont (newStr: t_lineTxt);
    begin
      if empty then
        CTlog.infoMsg (4,1,'addLastCont: The structure is empty.')
      else
        begin
          CTlog.clearError;
          gotoCont;
          if CTlog.getError then
            begin   {there is no cont nodes, adding the first cont}
              addCont (newStr);
              CTlog.infoMsg (0,2,'addLastCont: There was no cont entries, a '
                                  + 'first entry was added as cont entry.')
            end
          else   {currPos at the first cont node}
            begin
              gotoLast;
              addNext (newStr);
              CTlog.infoMsg (0,3,'addLastCont: last entry was added to the '
                                   + 'cont list.')
            end
        end
    end;

{|-procedure obj_condText.addFieldValue (field,value: t_lineTxt); :
 |  -adds a new node at the end of the cont list as field and includes its
 |   _ own cont node as value .
 |  -at the end it will return to the original currPos (to add others
 |   field-value nodes at the same level) ;|}
  procedure obj_condText.addFieldValue (field,value: t_lineTxt);
    begin
      if empty then
        CTlog.infoMsg (4,1,'addFieldValue: The structure is empty.')
      else
        begin
          CTlog.clearError;
          gotoCont;
          if CTlog.getError then   {adding the field node}
            begin   {there is no cont nodes, adding the first cont}
              addCont (field);
              CTlog.infoMsg (0,2,'addFieldValue: field name added as first'
                                  + ' cont entry.')
            end
          else   {currPos at the first cont node}
            begin
              gotoLast;
              addNext (field);
              CTlog.infoMsg (0,2,'addFieldValue: last entry was added to the '
                                   + 'cont list as field: ' + field)
            end;
          addCont (value);
          CTlog.infoMsg (0, 2, 'addFieldValue: cont node added as value: '
                                                            + value);
          gotoTitle;   {currPos at field node}
          gotoTitle;   {currPos at the original position}
          CTlog.infoMsg (0, 2, 'addFieldValue: current position restored.');
          CTlog.infoMsg (0, 2, 'addFieldValue: field-value nodes added.');
        end
    end;   {obj_condText.addFieldValue}
    
{|-procedure obj_condText.gotoRoot; :
 |  -Moves currPos to the root node ;|}
  procedure obj_condText.gotoRoot;
    begin
      if empty then
        CTlog.infoMsg (4,1,'gotoRoot: The structure is empty.')
      else
        begin
          currPos:=root;
          CTlog.infoMsg (0,3,'gotoRoot: currPos pointed to the root entry.')
        end
    end;

{|-procedure obj_condText.gotoNext; :
 |  -Moves currPos to the current next node ;|}
  procedure obj_condText.gotoNext;
    begin
      if empty then
        CTlog.infoMsg (4,1,'gotoNext: The structure is empty.')
      else
        if currPos^.next = NIL then
          CTlog.infoMsg (4,2,'gotoNext: There is no next entry.')
        else
          begin
            currPos := currPos^.next;
            CTlog.infoMsg(0,3,'gotoNext: currPos pointed to the next entry.')
          end
    end;

{|-procedure obj_condText.gotoCont; :
 |  -Moves currPos to the current cont node ;|}
  procedure obj_condText.gotoCont;
    begin
      if empty then
        CTlog.infoMsg (4,1,'gotoCont: The structure is empty.')
      else
        if currPos^.cont = NIL then
          CTlog.infoMsg (4,2,'gotoCont: There is no cont entry.')
        else
          begin
            currPos := currPos^.cont;
            CTlog.infoMsg(0,3,'gotoCont: currPos pointed to the cont entry.')
          end
    end;

{|-procedure obj_condText.gotoTitle; :
 |  -Moves currPos the the current title node ;|}
  procedure obj_condText.gotoTitle;
    begin
      if empty then
        CTlog.infoMsg (4,1,'gotoTitle: The tructure is empty.')
      else
        if currPos^.title = NIL then
          CTlog.infoMsg (4,2,'gotoTitle: There is no title entry.')
        else
          begin
            currPos := currPos^.title;
            CTlog.infoMsg(0,3,'gotoTitle: currPos pointed to the title entry.')
          end
    end;

{|-procedure obj_condText.gotoPrev; :
 |  -Moves currPos to the current previous node ;|}
  procedure obj_condText.gotoPrev;
    var
      nextNode: p_CTnode;
    begin
      if empty then
        CTlog.infoMsg (4,1,'gotoPrev: The structure is empty.')
      else
        begin
          nextNode := currPos;
          CTlog.clearError;
          gotoFirst;
          if CTlog.getError then
            CTlog.infoMsg (4,2,'gotoPrev: There is no previous entry.')
          else
            begin
              while currPos^.next <> nextNode do
                currPos := currPos^.next;
              CTlog.infoMsg(0,3,'gotoPrev: currPos pointed to the previous '+
                                 'entry.')
            end
        end
    end;   {obj_condText.gotoPrev}

{|-procedure obj_condText.gotoFirst; :
 |  -Moves currPos to the first node of the current list ;|}
  procedure obj_condText.gotoFirst;
    var
      prevPos: p_CTnode;
      msg: string = 'gotoFirst: ';
    begin
      if empty then
        CTlog.infoMsg (4,1,msg + 'The structure is empty.')
      else
        begin
          prevPos := currPos;
          CTlog.clearError;
          gotoTitle;   {move currPos to the title node}
          if CTlog.getError then   {there is no title node}
            begin
              if currPos = root then
                CTlog.infoMsg(4,2,msg + 'currPos is already the root entry.')
              else
                begin
                 currPos := root;
                 CTlog.infoMsg(0,3,msg + 'currPos pointed to the root entry.')
                end
            end
          else  {currPos in the title}
            if currPos^.cont = prevPos then
              begin
                currPos := prevPos;
                CTlog.infoMsg(4,2,msg + 'currPos is already the first entry.')
              end
            else
              begin
                currPos := currPos^.cont;
                CTlog.infoMsg (0,3,msg + 'currPos pointed to the first ' +
                                     'entry of the current list')
              end
        end
    end;   {obj_condText.gotoFirst}

{|-procedure obj_condText.gotoLast; :
 |  -Moves currPos to the last node of the current list ;|}
  procedure obj_condText.gotoLast;
    begin
      if empty then
        CTlog.infoMsg (4,1,'gotoLast: The structure is empty.')
      else
        begin
          if currPos^.next = NIL then
            CTlog.infoMsg(4,2,'gotoLast: currPos is already the last entry.')
          else
            begin
              while currPos^.next <> NIL do
                currPos := currPos^.next;
              CTlog.infoMsg(0,3,'gotoLast: currPos pointed to the last entry.')
            end
        end
    end;   {obj_condText.gotoLast}

{|-procedure obj_condText.gotoRootTitle; :
 |  -Moves currPos to the title in the root list. The most external title ;|}
  procedure obj_condText.gotoRootTitle;
    begin
      if empty then
        CTlog.infoMsg (4,1,'gotoRootTitle: The structure is empty.')
      else
        if currPos^.title = NIL then
          CTlog.infoMsg (4,2,'gotoRootTitle: There are no title entries.')
        else
          begin
            while currPos^.title <> NIL do
              currPos := currPos^.title;
            CTlog.infoMsg (0,3,'gotoRootTitle: currPos pointed to the ' +
                                  'root title.')
          end
    end;   {obj_condText.gotoRootTitle}

{|-procedure obj_condText.gotoPos (pPos : p_CTnode); :
 |  -moves the currPos ponter to the node specified by the pointer pPos ;|}
  procedure obj_condText.gotoPos (pPos : p_CTnode);
    begin
      if pPos = NIL then
        CTlog.infoMsg (5, 1, 'gotoPos: A NIL node was specified.')
      else
        begin
          currPos := pPos;
          CTlog.infoMsg (0, 2, 'gotoPos: The currPos pointed to the specified'
                                         + ' position.')
        end
    end;   {obj_condText.gotoPos}

{|-function obj_condText.gotoNextStr (nStr : string): boolean; :
 |  -points currPos to the first node with a specified text in the next list
 |   _ after the currPos .
 |  -returns true if the text was found and thus currPos was updated ;|}
  function obj_condText.gotoNextStr (nStr : string): boolean;
    var
      cPos : p_CTnode;
    begin
      gotoNextStr := FALSE;   {initialization}
      if currPos = NIL then
        CTlog.infoMsg (4, 1, 'gotoNextStr: the structure is empty')
      else
        begin
          cPos := currPos^.next;
          if cPos = NIL then
            CTlog.infoMsg (4, 2, 'gotoNextStr: no next nodes in currPos.');
          while cPos <> NIL do
            begin
              if cPos^.CTstr = nStr then
                begin
                  currPos := cPos;
                  CTLog.infoMsg (0, 2, 'gotoNextStr: currPos pointed to a' +
                           'node in the current next list with text: ' + nStr);
                  gotoNextStr := TRUE;
                  exit;
                end;
              cPos := cPos^.next
            end;
          CTlog.infoMsg (1, 2, 'gotoNextStr: node not found: ' + nStr)
        end
    end;   {obj_condText.gotoNextStr}

{|-function obj_condText.gotoContStr (nStr : string): boolean; :
 |  -points currPos to the first node with a specified text in the cont tree
 |   _ of the current position .
 |  -returns true if the text was found and thus currPos was updated .
 |  -the current position is not included in the search .
 |  -note that if the text is found in the title node the funtion  ;|}
  function obj_condText.gotoContStr (nStr : string): boolean;
    var
      cPos, fPos : p_CTnode;
    begin
      gotoContStr := FALSE;   {initialization}
      if empty then
        CTLog.infoMsg (4, 1, 'gotoContStr: the structure is empty.')
      else
        begin
          cPos := currPos^.cont;
          if cPos = NIL then
            CTlog.infoMsg (4, 2, 'gotoContStr: no cont nodes in currPos.');
          while cPos <> NIL do   {run over the cont list of currPos}
            begin
              fPos := findTextRec (cPos, nStr);
              if fPos <> NIL then
                begin
                  currPos := fPos;
                  CTlog.infoMsg (0, 2, 'gotoContStr: currPos pointed to a ' +
                          'node in the current cont tree with text: ' + nStr);
                  gotoContStr := TRUE;
                  exit
                end;
              cPos := cPos^.next
            end;
          CTlog.infoMsg (1, 2, 'gotoContStr: node not found: ' + nStr)
        end
    end;   {obj_condText.gotoContStr}

{|-procedure obj_condText.del :
 |  -Deletes the current node if it has no cont nodes ;|}
  procedure obj_condText.del;
    var
      delNode: p_CTnode;
    begin
      if empty then
        CTlog.infoMsg (4,1,'del: The structure is empty.')
      else
        if currPos^.cont <> NIL then
          CTlog.infoMsg (4,1,'del: currPos has to have no cont subentries.')
        else
          begin
            delNode := currPos;
            CTlog.clearError;
            gotoPrev;
            if CTlog.getError then  {there is no previous node}
              if delNode = root then   {deletes the root node}
                begin
                  root := delNode^.next;
                  currPos := root;
                  dispose (delNode);
                  CTlog.infoMsg (0,3,'del: The root entry was deleted.')
                end
              else   {deletes a titled first node}
                begin
                  CTlog.clearError;
                  gotoTitle;
                  if CTlog.getError then   {This case should never occur}
                    CTlog.infoMsg(5,1,'del: No title for a non-root first ' +
                                'entry.')
                  else
                    begin
                      currPos^.cont := delNode^.next;
                      dispose (delNode);
                      if currPos^.cont <> NIL then currPos := currPos^.cont;
                      CTlog.infoMsg (0,3,'del: A list first entry was ' +
                                         'deleted.')
                    end
                end
            else   {currPos is prior to the node to delete}
              begin
                currPos^.next := delNode^.next;
                dispose (delNode);
                if currPos^.next <> NIL then currPos := currPos^.next;
                CTlog.infoMsg (0,3,'del: The entry was deleted.')
              end
          end
    end;   {obj_condText.del}

{|-procedure obj_condText.delRec; :
 |  -deletes the current node and all its cont subnodes ;|}
  procedure obj_condText.delRec;
    var
      delNode: p_CTnode;
    begin
      if empty then
        CTlog.infoMsg (4,1,'delRec: The structure is empty.')
      else
        begin
          delNode:=currPos;
          CTlog.clearError;
          gotoPrev;
          if CTlog.getError then   {no previous node, is a first node}
            begin
              CTlog.clearError;   
              gotoTitle;
              if CTlog.getError then   {delNode is the root node}
                if delNode = root then
                  begin
                    root := delNode^.next;
                    delNode^.next := NIL;
                    delNodeRec (delNode);
                    currPos := root;
                    if root = NIL then
                      CTlog.infoMsg (0,3,'delRec: No more entries left.')
                    else
                      CTlog.infoMsg (0,3,'delRec: root entry deleted.')
                  end
                else   {this case should never occur}
                  CTlog.infoMsg(5,1,'delRec: No title for a non-root first '
                                     + 'entry.')
              else   {currPos at the title}
                begin
                  currPos^.cont:=delNode^.next;
                  delNode^.next:=NIL;
                  delNodeRec (delNode);
                  if currPos^.cont <> NIL then currPos := currPos^.cont;
                  CTlog.infoMsg (0,3,'delRec: first titled entry deleted.')
                end
            end
          else   {currPos at the previous node}
            begin
              currPos^.next:=delNode^.next;
              delNode^.next:=NIL;
              delNodeRec (delNode);
              if currPos^.next <> NIL then currPos := currPos^.next;
              CTlog.infoMsg (0,3,'delRec: entry and subentries deleted.')
            end
        end
    end;  {obj_condText.delRec}

{|-procedure obj_condText.delLevelRec; :
 |  -Deletes all the nodes in the current list .
 |  -In titled lists only the title node is conserved .
 |  -For the root list the whole structure is deleted  ;|}
  procedure obj_condText.delLevelRec;
    begin
      if empty then
        CTlog.infoMsg (4,1,'delLevelRec: The structure is empty.')
      else
        CTlog.clearError;
        gotoTitle;
        if CTlog.getError then   {no title, root list}
          begin
            delNodeRec (root);
            root := NIL;
            currPos := NIL;
            CTlog.infoMsg(0,3,'delLevelRec: The whole structure was deleted.')
          end
        else   {currPos at the title}
          begin
            delNodeRec (currPos^.cont);
            currPos^.cont := NIL;
            CTlog.infoMsg (0,3,'delLevelRec: The whole level was deleted.')
          end
    end;

{|-procedure obj_condText.delNextRec; :
 |  -Deletes all nodes and subnodes starting at the next position ;|}
  procedure obj_condText.delNextRec;
    begin
      if empty then
        CTlog.infoMsg (4,1,'delNextRec: The structure is empty.')
      else
        if currPos^.next = NIL then
          CTlog.infoMsg (4,2,'delNextRec: There is no next entry.')
        else
          begin
            delNodeRec (currPos^.next);
            currPos^.next:=NIL;
            CTlog.infoMsg (0,3,'delNextRec: All next entries were deleted.')
          end;
    end;

{|-procedure obj_condText.delContRec; :
 |  -Deletes the cont node of currPos recursivelly ;|}
  procedure obj_condText.delContRec;
    begin
      if empty then
        CTlog.infoMsg (4,1,'delContRec: The structure is empty.')
      else
        if currPos^.cont = NIL then
          CTlog.infoMsg (4,2,'delContRec: There is no cont entry.')
        else
          begin
            delNodeRec (currPos^.cont);
            currPos^.cont:=NIL;
            CTlog.infoMsg (0,3,'delContRec: All cont entries were deleted.')
          end;
    end;

{|-function obj_condText.findText (title: p_node; str: string): p_node; :
 |  -returns a pointer to the first node found containing a specified text .
 |  -returns NIL if no node contains the text .
 |  -the search runs over the cont list of title and includes title .
 |  -arguments :
 |    -title :-node from which the search will be started .
 |      -If title is nil, the search is made over the root list ;
 |    -str :-text to be searched ;;;
 }
  function obj_condText.findText (title: p_CTnode; str: string): p_CTnode;
    var
      pos: p_CTnode;
    begin
      findText:=nil;   {initialize in the case no node contains the text}
      CTlog.infoMsg (0,2,'findText: searching for text: "'+str+'"');
{error check}
      if empty then   {empty structure}
        begin
          CTlog.infoMsg (4,2,'findText: The structure is empty.');
          exit   {exits from the function}
        end;
{points pos to the first node of the root or cont list}
      if title = nil then   {search on the root list}
        begin
          CTlog.infoMsg (0,3,'findtext: searching in root list.');
          pos:=root
        end
      else   {search in the cont list of the title node}
        begin
          CTlog.infoMsg(0,3,'findText: searching in cont list of title: "'+
                        title^.CTstr+'"');
          if title^.CTstr = str then
            begin   {the searched text is in the title }
              findText := title;
              CTlog.infoMsg (0,2,'findtext: text found as title.');
              exit   {exits from the function}
            end;
          pos := title^.cont
        end;
{search over the current list}
      while pos <> nil do
        begin
          if pos^.CTstr = str then
            begin
              findText := pos;
              CTlog.infoMsg (0,2,'findText: text found.');
              exit   {exits from the function}
            end;
          pos := pos^.next;
        end;
      CTlog.infoMsg (0,2,'findText: text not found.');
    end;   {obj_condText.findText}


{|-function obj_condText.findTextRec(title: p_CTnode; str: string): p_CTnode; :
 |  -returns a pointer to the first node found containing a specified text .
 |  -returns NIL if no node contains the text .
 |  -the search includes the title node and run recursivelly over cont nodes .
 |  -arguments :
 |    -title :-node from which the search will be started .
 |      -If title is nil, the search is made over the whole structure ;
 |    -str :-text to be searched ;;;|}
  function obj_condText.findTextRec (title: p_CTnode; str: string): p_CTnode;
    var
      pos: p_CTnode;

    function found (node: p_CTnode): boolean;
      begin
        if node = NIL then
          found:=FALSE
        else
          if node^.CTstr = str then
            begin   {return value assigned}
              found:=TRUE;
              findTextRec:=node;
            end
          else
            if found(node^.cont) then   {searches in the cont nodes}
              found:=TRUE
            else
              found:=found(node^.next);   {searches in the next nodes}
      end;   {found}

    begin   {obj_condText.findTextRec}
      findTextRec:=NIL;   {initialize in the case no node contains the text}
      CTlog.infoMsg (0,2,'findTextRec: searching for text: "'+str+'"');
      if empty then   {error check}
        begin
          CTlog.infoMsg (4,2,'findTextRec: The structure is empty.');
          exit   {exits from the function}
        end;
      if title = NIL then   {seraches from the root node}
        begin
          CTlog.infoMsg (0,2,'findTextRec: searching from the root node.');
          pos:=root
        end
      else
        begin
          if title^.CTstr = str then
            begin
              CTlog.infoMsg (0,2,'findtextRec: text found as title.');
              findTextRec:=title;
              exit
            end;
          CTlog.infoMsg(0,3,'findTextRec: starting search at cont of title: "'+
                             title^.CTstr+'"');
          pos:=title^.cont
        end;
      if found(pos) then   {start the recursive search}
        CTlog.infoMsg (0,2,'findTextRec: Text found.')
      else
        CTlog.infoMsg (0,2,'findTextRec: Text not found.')
    end;   {obj_condText.findTextRec}


{|-function obj_condText.findSubstr (title: p_CTnode;
 |                                 _ substr: string):p_CTnode; :
 |  -return a pointer to a node containing a substring included in the CTstr .
 |  -returns NIL if no node is found including the substring .
 |  -arguments :
 |    -title :
 |      -node from which the search is started .
 |      -the search is performed on the cont list of the title node .
 |      -the title node is included in the search .
 |      -if title is NIL the search is performed on the root list ;
 |    -substr :
 |      -string to be searched as part of a CTstr ;;;|}
  function obj_condText.findSubstr(title: p_CTnode; substr: string): p_CTnode;
    var
      posN: p_CTnode;
      namF: string = 'findSubstr: ';
    begin
      CTlog.infoMsg(0,2,namF+'Searching substring: '+substr);
      findSubstr:=NIL;   {initialization}
      if substr = '' then   {error check}
        begin
          CTlog.infoMsg(2,2,namF+'An empty substring was specified.');
          exit
        end;
      if empty then
        begin
          CTlog.infoMsg(4,2,namF+'The structure is empty.');
        end
      else
        begin   {structure not empty}
          if title = NIL then   {searching in the title}
            begin
              CTlog.infoMsg(2,2,namF+'Searching in the root list.');
              posN:=root
            end
          else   {checking the title node}
            begin
              if (pos(substr,title^.CTstr) > 0) or
                 (pos(upCase(substr),upCase(title^.CTstr)) > 0) then
                begin   {the title contains the substring}
                  CTlog.infoMsg(0,2,namF+'Substring found in title node.');
                  findSubstr:=title;
                  exit
                end;
              posN:=title^.cont
            end;
          while posN <> NIL do
            begin   {searching in the cont list}
	      if (pos(substr,posN^.CTstr) > 0) or
	         (pos(upCase(substr),upCase(posN^.CTstr)) > 0) then
	        begin
	          CTlog.infoMsg(0,2,namF+'Substring found in the cont list.');
	          findSubstr:=posN;
	          exit
	        end;
	      posN:=posN^.next
            end;
          CTlog.infoMsg(0,2,namF+'Substring not found.')
        end
    end;   {obj_condText.findSubstr}

{|-function obj_condText.findSubstrRec (title: p_CTnode; substr: string):
 |                                                             _ p_CTnode; :
 |  -return a pointer to a node containing a substring included in the CTstr .
 |  -returns NIL if no node is found including the substring .
 |  -the search is done recursively .
 |  -arguments :
 |    -title :
 |      -node from which the search is started .
 |      -the search is performed on the cont list of the title node .
 |      -the title node is included in the search .
 |      -if title is NIL the search is performed on the root list ;
 |    -substr :
 |      -string to be searched as part of a CTstr ;;;|}
  function obj_condText.findSubstrRec (title: p_CTnode; substr: string):
                                                                 p_CTnode;
    var
      posN: p_CTnode;
      namF: string = 'findSubstrRec: ';

    function found (node: p_CTnode): boolean;
      begin
        if node = NIL then
          found := FALSE
        else
          if (pos(substr,node^.CTstr) > 0) or
             (pos(upCase(substr),upCase(node^.CTstr)) > 0) then
            begin   {return value assigned}
              found:=TRUE;
              findSubstrRec:=node;
            end
          else
            if found(node^.cont) then   {searches in the cont nodes}
              found:=TRUE
            else
              found:=found(node^.next);   {searches in the next nodes}
      end;   {found}

    begin   {obj_condText.findSubstrRec}
      findSubstrRec:=NIL;   {initialize in the case no node contains the text}
      CTlog.infoMsg (0, 2, namF + 'searching substring: "' + substr + '"');
      if empty then   {error check}
        begin
          CTlog.infoMsg (4, 2, namF + 'the structure is empty.');
          exit   {exits from the function}
        end;
      if title = NIL then   {seraches from the root node}
        begin
          CTlog.infoMsg (0, 2, namF + 'searching from the root node.');
          posN:=root
        end
      else
        begin
          if (pos(substr,title^.CTstr) > 0) or
             (pos(upCase(substr),upCase(title^.CTstr)) > 0) then
            begin
              CTlog.infoMsg (0, 2, namF + 'text found within the title.');
              findSubstrRec:=title;
              exit
            end;
          CTlog.infoMsg(0, 3, namF + 'starting search at cont of title: "'+
                             title^.CTstr+'"');
          posN:=title^.cont
        end;
      if found(posN) then   {start the recursive search}
        CTlog.infoMsg (0, 2, namF + 'Text found.')
      else
        CTlog.infoMsg (0, 2, namF + 'Text not found.')
    end;   {obj_condText.findSubstrRec}

{|-function obj_condText.search (start : p_CTnode; lines : byte;
 |   _ depth : integer; sType : byte; var CTfound : obj_condText) : boolean; :
 |  -performs a recursive text search considering different options and search
 |   _ styles, considering also subsets of the CT structure .
 |  -return a condText object which stores a list of the nodes which contain
 |   _ strings matching the specified criteria .
 |  -arguments :
 |    -start :-pointer to the node used as starting point of the search .
 |      -if NIL, the search will be performed in the whole structure,
 |       _ regardless the values of lines and depth .
 |      -use the getRoot function to start at the root node considering the
 |       _ lines and depth arguments ;
 |    -lines :-number of next nodes considered after the start node .
 |      -will not apply to the cont sublevels considered with the depth arg .
 |      -if 0, all next nodes after the start node will be considered .
 |      -use 1 and depth = 0 to search in the contents of the start node as
 |       _ title ;
 |    -depth :-number of cont nodes considered in the search .
 |      -if 0, all the cont nodes will be cosidered .
 |      -if 1, no cont nodes are considered, only the next list of the start
 |       _ node depending on the value of the line argument .
 |      -if negative, the search will be performed on the title list from the
 |       _ start node .
 |      -the absolute value of a negative number will be taken as the
 |       _ number of title levels to be considered in the search ;
 |    -sType :-type of comparing rule used during the search .
 |      -acceptable values :
 |        -0 :-exact search is performed ;
 |        -1 :-exact search, case insensitive is performed ;
 |        -2 :-substring search is performed ;
 |        -3 :-substring search, case insensitive is performed ;;;
 |    -CTfound :-conText object containing the string(s) to search and
 |     _ used also to return the list of the matches found in the structure
 |     _ according the the criteria specified .
 |      - .
 |      -the object must be already initialized and empty ;;;|}
function obj_condText.search (start : p_CTnode; lines : byte; depth : integer;
                          sType : byte; var CTfound : obj_condText) : boolean;

{compares whether two strings are exactly the same}
  function compExact (str1, str2 : string) : boolean;
    begin
      if str1 = str2 then compExact := TRUE else compExact := FALSE
    end;   {compareExact}

{compares whether two strings are exactly the same, case insensitive}
  function compCI (str1, str2 : string) : boolean;
    begin
      if upCase(str1) = upCase(str2) then compCI := TRUE else compCI := FALSE
    end;   {compCI}

{compares whether str1 is contained in str2}
  function compPartStr (str1, str2 : string) : boolean;
    begin
      if pos (str1, str2) > 0 then
        compPartStr := TRUE else compPartStr := FALSE
    end;   {compPartStr}

{compares whether str1 is contained in str2, case insensitive}
  function compPartStrCI (str1, str2 : string) : boolean;
    begin
      if pos (upCase (str1), upCase (str2)) > 0 then
        compPartStrCI := TRUE else compPartStrCI := FALSE
    end;   {compPartStrCI}

  begin
    search := FALSE;
    
{********************************}    
    
    
  end;   {search}

{|-function obj_condText.getRoot : p_CTnode; :
 |  -returns a ponter to the root node ;|}
  function obj_condText.getRoot : p_CTnode;
    begin
      CTlog.infoMsg (0, 3, 'getRoot: pointer to root node returned.');
      getRoot := root
    end;   {obj_condText.getRoot}

{|-function obj_condText.getCurrPos : p_CTnode; :
 |  -returns a ponter to the currPos node ;|}
  function obj_condText.getCurrPos : p_CTnode;
    begin
      CTlog.infoMsg (0, 3, 'getCurrPos: pointer to the currPos returned.');
      getCurrPos := currPos
    end;   {obj_condText.getCurrPos}

{|-function obj_condText.getCurrStr : string; :
 |  -returns the user CTstr of the node pointed by currPos ;|}
  function obj_condText.getCurrStr : string;
    begin
      getCurrStr := '';   {initialization}
      if currPos = NIL then
        CTlog.infoMsg (4, 1, 'getCurrStr: the structure is empty')
      else
        begin
          CTlog.infoMsg (0, 3, 'getCurrStr: current CT string returned.');
          getCurrStr := currPos^.CTstr
        end
    end;   {obj_condText.getCurrStr}

{|-function obj_condText.getFieldValue (title : p_CTnode; field : string):
 |                                                             _ t_lineTxt; :
 |  -return the CTstr of the cont node of a node with CTstr equal to the
 |   _ field string name .
 |  -arguments :
 |    -title :-node from which the search is started .
 |      -the field node is supposed to be in its cont list ;
 |    -field :-string to be searched in the cont list of the title node .
 |      -it is supposed to have a cont node with the field value;;;|}
  function obj_condText.getFieldValue (title: p_CTnode; field: string):
                                                                    t_lineTxt;
    var
      p_field : p_CTnode;
    begin
      getFieldValue := '';
      if empty then
        CTlog.infoMsg (4, 2, 'getFieldValue: the structure is empty.')
      else
        begin
          p_field := findText (title, field);
          if p_field = NIL then
            CTlog.infoMsg (1, 2, 'getFieldValue: field name not found.')
          else
            if p_field^.cont = NIL then
              CTLog.infoMsg (5, 2, 'getFieldValue: no value node found.')
            else
              begin
                CTlog.infoMsg (0,3,'getFieldValue: value returned for field '+
                                   field + ': ' + p_field^.cont^.CTstr);
                getFieldValue := p_field^.cont^.CTstr
              end
        end
    end;   {obj_condText.getFieldValue}

{|-function obj_condText.getPropertyRecord (title: p_CTnode;
 |                                   _ var prop: rec_CTprop): boolean; :
 |  -searches the local propertyRecord .
 |  -returns TRUE if the property record is found and FALSE otherwise .
 |  -if no property record is found returns the default properties .
 |  -the property record must not be in the title but in its cont nodes .
 |  -arguments :
 |    -title :-node for which the propertyRecord is searched in its cont list ;
 |    -prop :-returns the properties either by default or from the search ;;;|}
  function obj_condText.getPropertyRecord (title: p_CTnode;
                                    var prop: rec_CTprop): boolean;
    var
      sName: string = 'getPropertyRecord: ';
      PRnode: p_CTnode;   {pointer to the propertyRecord}
      prpNode,valNode: p_CTnode;   {pointer to a especific property and value}
    begin
      prop:=defProp;   {initializes the record}
      getPropertyRecord:=FALSE;
      CTlog.clearError;	
      PRnode:=findText(title,'{propertyRecord}');
      if PRnode = NIL then
        if CTlog.getError then   {propertyRecord not found}
          CTlog.infoMsg (4,2,sName+'The structure is empty.')
        else
          CTlog.infoMsg (0,2,sName+'Returning default properties.')
      else   {local propertyRecord found}
        begin
          if title = PRnode then
            begin
              CTlog.infoMsg (0,1,sName+'The title is a property record. ' +
                                       'Returning default properties.');
              exit
            end;
          prpNode:=PRnode^.cont;
          while prpNode <> NIL do
            begin
              valNode:=prpNode^.cont;
              if valNode = NIL then
                begin
                  CTlog.infoMsg(5,1,sName+'Property value missed.');
                  exit
                end;
              readStrPropVal (prpNode^.CTstr,valNode^.CTstr,prop);
              prpNode:=prpNode^.next
            end;
          CTlog.infoMsg (0,2,sName+'Local propertyRecord returned.');
          getPropertyRecord:=TRUE;
        end;
    end;   {obj_condText.getPropertyRecord}


{|-function obj_condText.getTitlePropertyRecord (node: p_CTnode;
                                       _ var prop: rec_CTprop): boolean; :
 |  -searches a propertyRecord in the title list of a specific node .
 |  -returns TRUE if the property record is found and FALSE otherwise .
 |  -if no property record is found returns the default properties .
 |  -arguments :
 |    -node :-node from which the search is performed .
 |      -it is not included in the search of the propertyRecord ;
 |    -prop :-returns the properties either by default or from the search ;;;|}
  function obj_condText.getTitlePropertyRecord (node: p_CTnode;
                                         var prop: rec_CTprop): boolean;
    var
      sName: string = 'getTitlePropertyRecord: ';
    begin   {obj_condText.getTitlePropertyRecord}
      prop:=defProp;   {initializes the record}
      getTitlePropertyRecord:=FALSE;
      while node <> NIL do
        begin
          node:=node^.title;
          if getPropertyRecord(node,prop) then
            begin
              CTlog.infoMsg(0,2,sName+'property record found in title list.');
              getTitlePropertyRecord:=TRUE;
              exit
            end;
        end;
      CTlog.infoMsg(0,2,sName+'Returning default properties.');
    end;   {obj_condText.getTitlePropertyRecord}

{|-procedure obj_condText.print (node: p_CTnode; lines, depth: integer;
 |                               outType, outDev: byte; fileName: string); :
 |  -prints the contents of the structure to different devices farmatting
 |   _ according the CT properties .
 |  -arguments :
 |    -node :-starting node for printing ;
 |    -lines :
 |      -Number of CTlines or node to print in the list containing the node .
 |      -a value of 0 will print all lines in the next list .
 |      -use 1 to print only one node with its contents ;
 |    -depth :
 |      -Number of cont levels to consider from the node .
 |      -a value of 0 will consider all levels ;
 |    -outType :
 |      -Output type indicating which elements are included in the output .
 |      -Acceptable values :
 |        -0 :-prints only user text as plain text ;
 |        -1 :-Includes tab spaces, bullet and CT lines ;
 |        -2 :-Includes baseStr, tabs, bullets, CTlines, ctrlChars and endStr ;
 |        -3 :-same as 2 plus property or hidden records ;
 |        -4 :-All elements with default properties suitable for reading ;;
 |      -Default value is 4 ;
 |    -outdev :-output device .
 |      -acceptable values :
 |        -1 :-writes output to the screen ;
 |        -2 :-writes output to a file ;
 |        -3 :-writes output to both the screen and a file ;;
 |      -if option 2 or 3 are used a filename must be specified ;
 |    -fileName :-file name of the output file ;;
 |  -internal variables :
 |    -out :-infoMsg object to manage the output device ;;
 |  -Internal functions or procedures :|}
procedure obj_condText.print (node: p_CTnode; lines, depth: integer;
                              outType, outDev: byte; fileName: string);
  var
    valS: string;   {string used to print numeric values}
    out: obj_output;   {object managing the output device declared in ioDrv}
    propI: rec_CTprop;   {title or default properties of the node}
    lct: rec_CTlineStr;
    CTline,restL,bullSpace,tab: t_lineTxt;
    hideCont: boolean;   {flag}

{prints the pre-built CT line into the output device}
  procedure printLine (preStr: t_lineTxt; prop: rec_CTprop);
    var
      linelen,prelen,ctrlen,i: integer;   {string length}

    procedure cutLine;
      var
        tl: string;   {temporal line}
        tp: integer;   {temporal position}
        posb: integer = 0;   {position of the last space (blank)}
      begin
        tl:=copy (CTline, 1,
                  prop.maxLength - length(lct.endCTbase + lct.strEnd));
        repeat;   {finds the last space (blank) before the maxLength}
          tp:=pos(' ',tl);
          if (tp <> 0) and (tp <= linelen - ctrlen) then
            begin   {considers only spaces before ctrlStr}
              tl:=copy (tl, tp + 1, length(tl) - tp);
              posb:=posb + tp
            end;
        until (tp = 0) or (tp > linelen - ctrlen);
        if posb <= prelen then   {no space in the CTstr}
          if prop.maxLength >= linelen - ctrlen then   {cut is in ctrlstr}
             tp:=linelen - ctrlen   {cuts the line in the ctrlChar}
          else   {cuts in the maxLength position}
            tp:=prop.maxLength
        else   {space between the bullet and the ctrlChar}
          tp:=posb - 1;
        restL:=copy (CTline, tp + 1, linelen - tp); {space included in restL}
        CTline:=copy (CTline, 1, tp);
        CTlog.infoMsg (0,2,'printRec: line cutted into a continuation line.')
      end;   {cutLine}

    begin   {printLine}
      CTlog.infoMsg (0,3,'printLine: printing CTline to the output device.');
      if outType >= 1 then
        begin
          prelen:=length(lct.strBase + lct.CTbase + lct.tabStr + lct.bullet);
          ctrlen:=length(lct.hideStr + lct.ctrlSep + lct.ctrlStr +
                     lct.endCTbase + lct.strEnd);
          if prop.maxLength - prelen - ctrlen >= prop.minLength then
            repeat;
              linelen:=length(CTline);
              if linelen > prop.maxLength then
                begin   {multiple (continuation) lines}
                  cutLine;   {cuts CTline and stores the rest in restL}
                  out.outDev (CTline + lct.endCTbase + lct.strEnd);
                  bullSpace:='';
                  for i:=1 to length(lct.bullet)-1 do
                    bullSpace:=bullSpace + ' ';
                  if outType >= 2 then
                    CTline:=lct.strBase + lct.CTbase + preStr + ' ' +
                            bullSpace + prop.contChar + restL
                  else
                    CTline:=lct.strBase + lct.CTbase + preStr + bullSpace +
                            restL
                end
              else
                begin   {single line}
                  out.outDev (CTline);
                  CTline:=''
                end;
              CTlog.infoMsg(0,3,'print: CT line printed: "'+lct.CTstr+'"');
            until CTline = ''
          else
            begin
              CTlog.infoMsg(6,1,'print: not enough space to print the line. '
                              + 'Modify output properties.');
              out.outDev(copy(CTline,1,prop.maxLength - prelen - ctrlen - 4) +
                         ' ...' + lct.hideStr + lct.ctrlSep + lct.ctrlStr +
                         lct.endCTbase + lct.strEnd);
              CTlog.infoMsg(6,1,'print: CT line truncated: ' + lct.CTstr)
            end
        end
      else
        out.outDev(lct.CTstr)   {printing only plain text}
    end;  {printLine}

  procedure printRec (node: p_CTnode; preStr: t_lineTxt; prop: rec_CTprop;
                                                  lines, depth: integer);
    var
      intProp: rec_CTprop;   {local properties for the node}
      i: integer;	

{build the whole output line and checks whether it has to be printed}
    function buildLine (node: p_CTnode; noPreStr: string): string;
      var
        cNode: p_CTnode;   {cont node of the node}
      begin
        buildLine:='';
        hideCont:=FALSE;
        lct.strBase:='';   lct.CTbase:='';  lct.tabStr:='';  lct.bullet:='';
        lct.CTstr:='';     lct.hideStr:=''; lct.ctrlSep:=''; lct.ctrlStr:='';
        lct.endCTbase:=''; lct.strEnd:='';
        if node = NIL then   {error check}
          CTlog.infoMsg (5,2,'printRec: the specified node is NIL.')
        else
          begin
            CTlog.infoMsg (0,3,'printRec: building CTline string.');
            cNode:=node^.cont;
            if outType < 3 then   {determine whether the line shall be printed}
              begin
                if (node^.CTstr = '{propertyRecord}') or
                   (pos('HIDETITLE',upCase(intProp.mark)) <> 0) then
                  begin
                    CTlog.infoMsg (0,2,'printRec: hidden title or ' +
                                           'propertyRecord skipped.');
                    hideCont := True;
                    exit
                  end;
                if (pos('HIDECONT',upCase(intProp.mark)) <> 0) and
                   (cNode <> NIL) then
                  begin   {hiding cont}
                    CTlog.infoMsg (0,2,'printRec: cont list will be hidden.');
                    lct.hideStr:=' ...';
                    hideCont:=TRUE
                  end
              end;
            if depth = 0 then
              begin
                CTlog.infoMsg (0,2,'printRec: cont level limit requested ' +
                                   'reached.');
                lct.hideStr:=' ...';
                hideCont:=TRUE
              end;
            lct.CTstr:=node^.CTstr;   {collect CTline elements}
            lct.tabStr:='';
            if outType >= 1 then
              begin   {set the tab space and bullet}
                lct.tabStr:=preStr;
                lct.bullet:=intProp.bullet
              end;
            if outType >= 2 then
              begin
                lct.strBase:=intProp.strBase;
                lct.CTbase:=CTbase;
                lct.ctrlSep:=intProp.ctrlSep;
                lct.ctrlStr:=ctrlStr(node);
                if intProp.strEnd <> '' then
                  lct.endCTbase:=CTbase;
                lct.strEnd:=intProp.strEnd
              end;
            with lct do
              begin
                buildLine:=strBase + CTbase + tabStr + bullet + CTstr +
                           hideStr + ctrlSep + ctrlStr + endCTbase + strEnd;
                if (node^.next = NIL) and (node^.cont = NIL) and
                   (noPreStr <> '') then {only in cont part of a compact line}
                  if outType = 1 then
                    buildLine:=' ' + bullet + CTstr + ctrlSep + ctrlStr +
                               endCTbase + strEnd
                  else
                    buildLine:=bullet + CTstr + ctrlSep + ctrlStr + endCTbase +
                             strEnd;
                if (pos('COMPACT',upCase(prop.mark)) <> 0) and
                   (cNode <> NIL) and (outType > 0) then
                  if (cNode^.next = NIL) and (cNode^.cont = NIL) then
                    begin
                      CTlog.infoMsg (0,2,'printRec: compacting title and ' +
                                        'cont CTentry into a single CTline.');
                      buildLine:=strBase + CTbase + tabStr + bullet + CTstr +
                            ctrlSep + ctrlStr + buildLine(cNode,'noPS');
                      hideCont:=TRUE
                    end
              end
          end
      end;   {buildLine}

    begin   {printRec}
      if node = NIL then
        CTlog.infoMsg (5,3,'printRec: the node is NIL.')
      else
        begin
          CTlog.infoMsg (0,3,'printRec: printing node.');
          if outType = 4 then   {choosing properties}
            intProp:=defProp
          else
            if getPropertyRecord (node, intProp) then
              CTlog.infoMsg(0,3,'printRec: local properties found.')
            else
              begin
                intProp:=prop;
                CTlog.infoMsg (0,3,
                  'printRec: using title or default properties.');
              end;
          CTline:=buildLine(node, '');
          if CTline <> '' then   {printing the line}
            begin
              printLine (preStr, intProp);
              dec(lines)
            end;
          if not hideCont then   {printing cont node}
            begin
              tab:='';
              for i:=1 to intProp.tabSpace - 1 do tab:=tab + ' ';
              printRec (node^.cont, preStr + intProp.tabChar + tab, intProp,
                        0, depth - 1)
            end;
          if lines <> 0 then   {printing next node}
            printRec (node^.next, preStr, prop, lines, depth)
          else
            CTlog.infoMsg (0,2,'print: all requested CTlines printed.')
        end
    end;   {printRec}
    
  begin   {obj_condText.print}
    CTlog.infoMsg (0,3,'print: *** Print condText structure ***');
    if empty then
      CTlog.infoMsg (4,1,'print: The structure is empty.')
    else
      begin
        if outType = 0 then   {error check and info output}
          CTlog.infoMsg (0,2,'print: output type 0: plain text.')
        else if outType = 1 then
          CTlog.infoMsg (0,2,'print: output type 1: CT lines.')
        else if outType = 2 then
          CTlog.infoMsg (0,2,'print: output type 2: CT lines w/ctrl chars.')
        else if outType = 3 then
          CTlog.infoMsg (0,2,'print: output type 3: CT structure formatted.')
        else if outType = 4 then
          CTlog.infoMsg(0,2,'print: output type 3: CT structure unformatted.')
        else
          begin
            CTlog.infoMsg (3,2,'print: Acceptable values for outType are '+
                               '1 - 4. Setting by default to 4.');
            outType:=4
          end;
        str (lines,valS);
        if lines <> 0 then
          CTlog.infoMsg (0,2,'print: printing only '+valS+' CTlines.');
        str (depth,valS);
        if depth <> 0 then
          CTlog.infoMsg (0,2,'print: printing up to '+valS+' levels depth.');
        out.init;   {setting up output device}
        out.setOutputDevice (outDev,filename,'R'); {rewrite output device}
        CTlog.infoMsg (0,2,'print: ' + out.getLastMsg);
        CTlog.infoMsg (0,2,'print: ' + out.repOutputDevice);
        if node = NIL then
          begin
            node:=root;
            CTlog.infoMsg(0,2,'print: printing from the root node.')
          end;
        if getTitlePropertyRecord(node,propI) then
          CTlog.infoMsg (0,2,'print: taking properties from title list.');
        printRec (node, tabStr(node), propI, lines, depth - 1);
        out.finish;
        CTlog.infoMsg (0,2,'print: ' + out.getLastMsg);
        CTlog.infoMsg (0,3,'print: *** done ***')
      end
  end;   {obj_condText.print}

{
|-procedure obj_condText.open (fName: string; prevCtrl: t_lineTxt); :
|  -Reads a condText structure from a file .
|  -Any text line not in condText format will be ignored .
|  -The first condText line found must contain inmediatelly after the
|   _ baseChar a bullet character included in the bulletSet, and optionally
|   _ a bulletSpace .
|  -arguments :
|    -fName :-Name of the text file from where the condText will be read ;
|    -prevCtrl :
|      -indicates wich node (pointer) of the currentPos should be used .
|      -acceptable values :
|        -'.' :-the next node of the currentPos is used ;
|        -':' :-the cont node ot the currentPos is used ;
|        -'I' :-opens in an empty structure ;;;;
|  -notes :-avoid empty CT lines (CTsrt='') in multiple CT entries ;;
}
  procedure obj_condText.open (fName: string; prevCtrl: t_lineTxt);
    var
      i: integer;
      inpF: text;
      line, lineCT, lineTxt, ctrlTxt: t_lineTxt;
      CTfound, contl: boolean;

{extractCT: returns a string enclosed by CTbase characters.}
    function extractCT (ltxt: t_lineTxt; var rest: t_lineTxt): t_lineTxt;
      var
        ip: integer;
      begin
        rest:='';   {rest is the rest of the line after the condText string}
        ip:=pos(CTbase, ltxt);   {searches openning CTbase}
        if ip > 0 then
          begin
            ltxt:=copy(ltxt, ip + 1, length(ltxt) - ip);
            ip:=pos(CTbase, ltxt);   {searches closing CTbase}
            if ip > 0 then
              begin
                extractCT:=copy(ltxt, 1, ip - 1);
                rest:=copy(ltxt, ip + 1, length(ltxt) - ip)
              end
            else
              extractCT:=ltxt;
            CTlog.infoMsg (0,3,'open: extractCT: CTline detected.')
          end
        else
          begin
            CTLog.infoMsg (0,3,'open: extractCT: No CTline found. ' + 
                               'Text line ignored.');
            extractCT:=''
          end
      end;   {extractCT}

{extractTxt: Returns the text of a condText line and the control chars string
 in ctrlTxt. cont indicates ltxt is a continuation line. rest returns other
 aditional CT statements optionally included in the line ltxt}
    function extractTxt (ltxt: t_lineTxt; var cont: boolean;
                         var ctrlTxt, rest: t_lineTxt): t_lineTxt;
      var
        cp: integer;
        fnam: string; 
      begin
        fnam:='open: extractTxt: ';
{first searches the bullet char or the contChar}
        ctrlTxt := '';
        rest := '';
        extractTxt := '';
        if not cont then   {ltxt is not a continuation line}
          begin   {finds the first bulletChar }
            cp := pos (defProp.bullet, ltxt);
            if cp > 0 then   {eliminates prebullet, bullet and bulletSpace}
              begin
                cp:=cp + length(defProp.bullet);
                if cp > length(ltxt) then
                  begin   {only the bulletChar was included in the line}
                    CTlog.infoMsg(2,1,fnam+'CT text and ctrlChars missing.');
                    exit
                  end;
                ltxt:=copy (ltxt, cp, length(ltxt) - cp + 1);
                CTlog.infoMsg(0,3,fnam+'CT entry line detected.')
              end
            else
              begin
                CTlog.infoMsg (0,3,fnam+'No CT entry found.');
                exit
              end
          end
        else   {cotinuation line, cont char will be used rather than bullet}
          begin
            cp:=pos (defProp.contChar, ltxt);
            if cp > 0 then
              ltxt:=copy (ltxt, cp + 1, length(ltxt) - cp)
            else   {will report if the line has bulletChar, possible error}
              begin
                cp:=pos (defProp.bullet, ltxt);
                if cp > 0 then
                  CTlog.infoMsg(0,1,fnam+'Warning: CT entry was detected '+
                          'instead a continuation line. Possible error.');
                exit;
              end;
            CTlog.infoMsg(0,3,fnam+'continuation line detected.')
          end;
{searches for a second bulletChar to split aditional CondText sentences.
 The bullet of the aditional sentences must be consecutive to ctrlChars }
        cp:=pos (defProp.bullet, ltxt);
        if (cp > 1) then
          if ltxt[cp - 1] in ctrlCharSet then
            begin   {split multiple condText statements}
              rest:=copy (ltxt, cp, length(ltxt) - cp + 1);
              ltxt:=copy (ltxt, 1, cp - 1);
              CTlog.infoMsg (0,3,fnam+'Multiple CT entries detected.')
            end;
{searches control characters, now cp will point to the ctrlChar}
        while ltxt[length(ltxt)] = ' ' do
          delete (ltxt, length(ltxt), 1);   {deletes blanks}
        if ltxt[length(ltxt)] in ctrlCharSet then
          begin   {ctrlChars at the end of the line, no cont lines needed}
            if (not (ltxt[length(ltxt) - 1] in ctrlCharSet)) and
                    (ltxt[length(ltxt) - 1] <> defProp.ctrlSep) then
              begin   {exception: the last character is not a ctrlChar}
                extractTxt:=ltxt;
                cont:=true;
                CTlog.infoMsg (0,3,fnam+'Incomplete CTentry found.');
                exit
              end;
            for cp:=length(ltxt) downto 1 do
              if ltxt[cp] = defProp.ctrlSep then
                break;   {searches the ctrlSep}
            if (cp = 1) and (ltxt[1] in ctrlCharSet) then
              ctrlTxt:=ltxt
            else
              begin
                ctrlTxt:=copy (ltxt, cp + 1, length(ltxt) - cp);
                extractTxt:=copy (ltxt, 1, cp - 1)
              end;
            cont:=false;
            CTlog.infoMsg (0,3,fnam+'Complete CTentry found.')
          end
        else   {The next will be a continuation line. No ctrlChars at the end}
          begin
            extractTxt:=ltxt;
            cont:=true;
            CTlog.infoMsg (0,3,fnam+'Incomplete CTentry found.')
          end;
      end;   {extractTxt}

{decode: incorporates a condText line considering the previous ctrlTxt}
    procedure decode (ltxt, ctrl: t_lineTxt);
      var
        i: integer;
      begin
        if (ltxt = '') and (ctrl = '') then exit;
        CTlog.infoMsg (0,3,'open: decode: adding CTline: ' + ltxt);
        if ctrl = '' then   {ltxt is a continuation line}
          currPos^.CTstr := currPos^.CTstr + ltxt
        else
          case ctrl[1] of
            'I': addRoot (ltxt);
            '.': addNext (ltxt);
            ':': addCont (ltxt);
            ';':
              begin
                CTlog.clearError;
                for i:=1 to length(ctrl) do
                  gotoTitle;
                if not CTlog.getError then
                  addNext (ltxt)
                else
                  CTlog.infoMsg (2,1,'open: decode: error in control' +
                                     ' characters.');
              end;
            else
              CTlog.infoMsg (2,1,'open: decode: Unknown control character.')
          end; 
      end;   {decode}

    begin   {obj_condText.open}
      if prevCtrl = 'I' then   {checking for errors and open mode}
        begin
          if not empty then
            begin
              CTlog.infoMsg (3,1,'open: The structure is not empty.');
              exit
            end
        end
      else if prevCtrl = '.' then
        CTlog.infoMsg (0,2,'open: inserting condText to next node.')
      else if prevCtrl = ':' then
        CTlog.infoMsg (0,2,'open: inserting condText to cont node.')
      else
        begin
          CTlog.infoMsg (3,1,'open: acceptable values are "I", "." or ":".');
          exit
        end;
      assign (inpF, fName);
{$I-} reset (inpF);   {$I+}
      if IOResult <> 0 then
        begin
          CTlog.infoMsg (7,1,'open: error reading file: ' + fName);
          Exit;
        end
      else
        CTlog.infoMsg (0,2,'open: reading file: ' + fName);
      contl:=false;
      CTfound:=false;
      ctrlTxt:='';
      while not EoF(inpF) do
        begin
          readln (inpF, line);
          while line <> '' do
            begin   {loop for multiple CT entries in a single line}
              lineCT := extractCT(line, line);   {line will be reduced}
              while lineCT <> '' do   {loop for multiple CT text entries}
                begin
                  if not CTfound then   {detects the bulletChar used}
                    if lineCT[1] in bulletSet then
                      begin   {searches bulletChar}
                        defProp.bullet:=lineCT[1];
                        if lineCT[2] = ' ' then {adds space to the bullet}
                          defProp.bullet:=defProp.bullet + ' ';
                        CTfound := true;
                        CTlog.infoMsg(0,2,'open: bullet char detected.');
                      end
                    else
                      lineCT := ''   {it is not a CT line}
                  else
                    begin
                      lineTxt := extractTxt(lineCT,contl,ctrlTxt,lineCT);
                      decode (lineTxt, prevCtrl);
                      prevCtrl := ctrlTxt;
                    end;
                end;
            end;
        end;
      CTlog.infoMsg (0,2,'open: finished reading the file. File closed.');
      if CTfound then   {processes the ctrlChars of the last line}
        if prevCtrl <> '' then
          for i:=1 to length(prevCtrl) do
            if prevCtrl[i] = ';' then gotoTitle;
      close (inpF);
    end;   {obj_condText.open}

{|-procedure obj_condText.moveCurrTo (var ctTarget : obj_condText;
 |                                  _ prevCtrl : t_lineTxt); :
 |  -moves the current node to an external condText object .
 |  -the title and next pointer of the current node will be changed to be
 |   _ part of the target structure .
 |  -the cont pointer of the current node is unchanged, meaning that any cont
 |   _ tree will be also moved to the target structure .
 |  -arguments :
 |    -ctTarget :-CT object receiving the current node .
 |      -the node will be inserted after the current node of the target object
 |       _ depending on the value of prevCtrl ;
 |    -prevCtrl :
 |      -indicates which position from the ctTarget's currentPos should be
 |       _ used to insert the node being moved .
 |      -acceptable values :
 |        -'.' :-the next node of the currPos is used ;
 |        -':' :-the cont node ot the currPos is used ;
 |        -';' :-the next node of the title of the currPos is used ;
 |        -'I' :-an empty structure or the root node is used ;;;;;|}
procedure obj_condText.moveCurrTo (var ctTarget: obj_condText;
                                   prevCtrl: t_lineTxt);
  var
    movingNode : p_CTnode;   {pointer to node to be moved}
  begin
    if prevCtrl = 'I' then   {checking for errors and inserting mode}
      CTlog.infoMsg (0, 2,
        'moveCurrTo: moving CTnode to a root position in target.')
    else if prevCtrl = '.' then
      CTlog.infoMsg (0,2,'moveCurrTo: moving CTnode to next node in target.')
    else if prevCtrl = ':' then
      CTlog.infoMsg (0,2,'moveCurrTo: moving CTnode to cont node in target.')
    else if prevCtrl = ';' then
      CTlog.infoMsg (0, 2,
        'moveCurrTo: moving CTnode to the next-title node in target.')
    else
      begin
        CTlog.infoMsg (3, 1,
          'moveCurrTo: acceptable values are "I", ".", ":" or ";".');
        exit
      end;
    if empty then
      begin
        CTlog.infoMsg (3, 1, 'moveCurrTo: The structure is empty.');
        exit
      end;
{first break title and next connections in the current structure and points
 the currPos to the previous or title node }
    movingNode := currPos;
    CTlog.clearError;
    gotoPrev;
    if not CTlog.getError then   {there is a previous node}
      currPos^.next := movingNode^.next
    else
      begin   {no previous node, checking for title}
        CTlog.clearError;
        gotoTitle;
        if not CTlog.getError then   {there is a title node}
          currPos^.cont := movingNode^.next
        else   {no previous or title node, thus currPos is the root node}
          begin
            root := movingNode^.next;
            currPos := movingNode^.next
          end
      end;
{then connects the movingNode to the target structure}
    if ctTarget.empty then prevCtrl := 'I';
    if prevCtrl = ';' then
      begin
        ctTarget.gotoTitle;
        prevCtrl := '.'
      end;
    if prevCtrl = 'I' then
      begin
        if ctTarget.empty then
          begin   {empty structure}
            ctTarget.root := movingNode;
            ctTarget.currPos := movingNode;
            movingNode^.next := NIL;
            movingNode^.title := NIL
          end
        else   {not empty target, inserting at the root position}
          begin
            movingNode^.next := ctTarget.root;
            movingNode^.title := NIL;
            ctTarget.root := movingNode;
            ctTarget.currPos := movingNode
          end
      end
    else if prevCtrl = '.' then
      begin
        movingNode^.next := ctTarget.currPos^.next;
        ctTarget.currPos^.next := movingNode;
        movingNode^.title := ctTarget.currPos^.title;
        ctTarget.currPos := movingNode
      end
    else if prevCtrl = ':' then
      begin
        movingNode^.next := ctTarget.currPos^.cont;
        ctTarget.currPos^.cont := movingNode;
        movingNode^.title := ctTarget.currPos;
        ctTarget.currPos := movingNode
      end
  end;   {obj_condText.moveCurrTo}

{|-function obj_condText.command (input: string): string; :
 |  -Provides a command interpreter usage for the object .
 |  -Arguments :-input :-text string wich contains one command line ;;
 |  -internal functions and procedures :
 |    -comext :-Extracts from the input string the command (first token),
 |     _returns it and deletes it from the string argument ;;;|}
  function obj_condText.command (input: string): string;
    var
      com: string;
    function comext (linetxt: string): string;
      begin
        comext := '';
      end;
    begin   {obj_condText.command}
      com := comext (input);
      if com = 'addRoot' then
        begin
        end
      else
        begin
        end;
      command := '';
    end;   {obj_condText.command}

{|-destructor obj_condText.finish; :-finalizes the structure ;|}
  destructor obj_condText.finish;
    begin
      CTlog.infoMsg (0,1,'finish: Finalizating the object condText.');
      delNodeRec (root);
{      CTlog.finish; } {the logfile of the unit will continue}
    end;

  procedure obj_condText.delNodeRec (node: p_CTnode);
    begin
      if node <> NIL then
        begin
          delNodeRec (node^.cont);
          delNodeRec (node^.next);
          dispose (node)
        end
      else
        CTlog.infoMsg (2,3,'delNodeRec: The pointer argument is NIL.')
    end;

{|-function obj_condText.tabStr (node: p_CTnode): string; :
 |  -return a string with tab spaces for the node ;|}
  function obj_condText.tabStr (node: p_CTnode): string;
    var 
      prop: rec_CTprop;
      tab: string;

{tabRec: returns title's tab string and properties}
    procedure tabRec(node: p_CTnode; var tab: string; var prop: rec_CTprop);
      var
        i: byte;
        tabsp: string = '';
      begin
        if node = NIL then
          begin
            if getPropertyRecord (node, prop) then
              CTlog.infoMsg (0,3,'tabStr: root properties used.')
            else
              begin
                prop:=defProp;
                CTlog.infoMsg (0,3,'tabStr: default properties used.')
              end;
            tab:=''
          end
        else
          begin
            tabRec (node^.title, tab, prop);
            if getPropertyRecord (node, prop) then
              CTlog.infoMsg (0,3,'tabStr: current node properties used.')
            else
              CTlog.infoMsg (0,3,'tabStr: title properties used.');
            for i:=1 to prop.tabSpace - 1 do tabsp:=tabsp + ' ';
            tab:=tab + prop.tabChar + tabsp;
          end;
      end;   {tabRec}

    begin   {obj_condText.tabStr}
      if node = NIL then
        begin
          CTlog.infoMsg (5,2,'tabStr: Pointer argument is NIL.');
          exit
        end;
      tabRec (node^.title, tab, prop);
      tabStr:=tab;
      CTlog.infoMsg (0,3,'tabStr: tab string for a node returned.')
    end;   {obj_condText.tabStr}

{|-function obj_condText.ctrlStr (node: p_CTnode): string; :
 |  -return a string with the control characters sequence for the node ;|}
  function obj_condText.ctrlStr (node: p_CTnode): string;
    function ctrlRec (node: p_CTnode; cstr: string): string;
      begin
        if node <> nil then
          begin
            if cstr = '' then
              begin
                if node^.cont <> NIL then   {next line is a cont node}
                  ctrlRec:=':'
                else if node^.next <> NIL then   {next line is next node}
                  ctrlRec:='.'
                else   {there is no next or cont node}
                  ctrlRec:=ctrlRec (node^.title, ';')
              end
            else
              if node^.next = NIL then
                ctrlRec:=ctrlRec (node^.title, cstr + ';')
              else
                ctrlRec:=cstr
          end
        else
          ctrlRec:=cstr
      end;   {ctrlRec}
    begin   {obj_condText.ctrlStr}
      ctrlStr:=ctrlRec(node,'');
      CTlog.infoMsg (0,3,'ctrlStr: control characters for a node returned.')
    end;  {obj_condText.ctrlStr} 

{|-procedure obj_condText.readStrPropVal (prpStr,valStr: string;
 |                                        _ var prop: rec_CTprop); :
 |  -Updates the value of a CTproperty from a string ;|}
  procedure obj_condText.readStrPropVal (prpStr,valStr: string;
                                         var prop: rec_CTprop);
    var
      code,ps: integer;
      byteVar: byte;
    begin
      CTlog.infoMsg (0,3,'readStrPropVal: Setting '+prpStr+' to '+valStr+'.');
      if prpStr = 'bullet' then
        prop.bullet:=valStr
      else if prpStr = 'tabSpace' then
        begin
          val (valStr, byteVar, code);
          if code = 0 then
            prop.tabSpace:=byteVar
          else
            CTlog.infoMsg (2,2,'readStrPropVal: error reading tabSpace.')
        end
      else if prpStr = 'tabChar' then
        prop.tabChar:=valStr[1]
      else if prpStr = 'ctrlSep' then
        prop.ctrlSep:=valStr[1]
      else if prpStr = 'contChar' then
        prop.contChar:=valStr[1]
      else if prpStr = 'maxLength' then
        begin
          val (valStr, byteVar, code);
          if code = 0 then
            prop.maxLength:=byteVar
          else
            CTlog.infoMsg (2,2,'readStrPropVal: error reading maxLength.')
        end
      else if prpStr = 'minLength' then
        begin
          val (valStr, byteVar, code);
          if code = 0 then
            prop.minLength:=byteVar
          else
            CTlog.infoMsg (2,2,'readStrPropVal: error reading minLength.')
        end
      else if prpStr = 'strBase' then
        prop.strBase:=valStr
      else if prpStr = 'strEnd' then
        prop.strEnd:=valStr
      else if prpStr = 'mark' then
        begin
          if upCase(valStr) = 'HIDETITLE' then
            begin
              ps:=pos('hideTitle',prop.mark);
              if ps = 0 then   {hide keyword is not included}
                if prop.mark = '' then
                  prop.mark:='hideTitle'
                else
                  prop.mark:=prop.mark+',hideTitle'
            end
          else if upCase(valStr) = 'SHOWTITLE' then
            begin
              ps:=pos('hideTitle',prop.mark);
              if ps <> 0 then    {keyword present, it's deleted then}
                begin
                  delete (prop.mark, ps, 4);
                  ps:=pos(',,', prop.mark);
                  if ps <> 0 then
                    delete (prop.mark, ps, 1);
                end
            end
          else if upCase(valStr) = 'HIDECONT' then
            begin
              ps:=pos('hideCont', prop.mark);
              if ps = 0 then   {including keyword}
                if prop.mark = '' then
                  prop.mark:='hideCont'
                else
                  prop.mark:=prop.mark+',hideCont'
            end
          else if upCase(valStr) = 'SHOWCONT' then
            begin
              ps:=pos('hideCont', prop.mark);
              if ps <> 0 then   {deleting mark}
                begin
                  delete (prop.mark, ps, 8);
                  ps:=pos(',,', prop.mark);
                  if ps <> 0 then
                    delete (prop.mark, ps, 1)
                end;
              ps:=pos('hideTitle',prop.mark);
              if ps <> 0 then    {keyword present, it's deleted then}
                begin
                  delete (prop.mark, ps, 4);
                  ps:=pos(',,', prop.mark);
                  if ps <> 0 then
                    delete (prop.mark, ps, 1);
                end
            end
          else if upCase(valStr) = 'SELECT' then
            begin
              ps:=pos('select', prop.mark);
              if ps = 0 then   {adding keyword}
                if prop.mark = '' then
                  prop.mark:='select'
                else
                  prop.mark:=prop.mark+',select'
            end
          else if upCase(valStr) = 'UNSELECT' then
            begin
              ps:=pos('select', prop.mark);
              if ps <> 0 then   {deleting keyword}
                begin
                  delete (prop.mark, ps, 6);
                  ps:=pos(',,', prop.mark);
                  if ps <> 0 then
                    delete (prop.mark, ps, 1)
                end
            end
          else if upCase(valStr) = 'COMPACT' then
            begin
              ps:=pos('compact', prop.mark);
              if ps = 0 then   {adding keyword}
                if prop.mark = '' then
                  prop.mark:='compact'
                else
                  prop.mark:=prop.mark+',compact'
            end
          else if upCase(valStr) = 'EXTENSE' then
            begin
              ps:=pos('compact', prop.mark);
              if ps <> 0 then   {deleting keyword}
                begin
                  delete (prop.mark, ps, 7);
                  ps:=pos(',,', prop.mark);
                  if ps <> 0 then
                    delete (prop.mark, ps, 1);
                end
            end
          else
            begin
              prop.mark:=valStr;
              CTlog.infoMsg(0,2,'readStrPropVal: mark keyword not recognized: '
                                 + valStr);
            end;
          CTlog.infoMsg (0,2,'readStrPropVal: mark keyword value :'+prop.mark);
        end
      else
        CTlog.infoMsg (3,2,'readStrPropVal: property not found: '+prpStr);
    end;   {obj_condText.readStrPropVal}

{|-procedure dbFieldStruct (plEnt, templ, stEnt : obj_condText); :
 |  -reorganizes plane data base records into a structured one according
 |   _ to an user-defined template .
 |  -all the CT object arguments must be previously initialized .
 |  -arguments :
 |    -plEnt :-CT with the plane DB entries .
 |      -in the root node is the name of the entry and within its cont list
 |       _ all the field-value elements .
 |      -all record entries must be at the same level ;
 |    -templ :-CT entry with the user-defined model or template of the
 |     _ desired structure for all the fields .
 |      -the root node must contain the DB entry name and all the field names
 |       _ would be within its cont tree .
 |      -this structure contain only the field (no values) .
 |      -the fields must correspond with those within plEnt ;
 |    -stEnt :-CT with the output structured DB entry .
 |      -if the db entry name is contained all the fiels will be placed
 |       _ as its cont tree .
 |      -if it does not have the db entry name included, this node title
 |       _ will be created in the las position of the root list ;;;|}
procedure dbFieldStruct (plEnt, templ, stEnt : obj_condText);
  var
    dbEntryName, fieldName, value, num : string;
    p_plEntName, p_stEntName : p_CTnode;
    nRec : integer = 0;

  procedure currFieldRec (node: p_CTnode);
    begin
      if node <> NIL then
        begin
          templ.gotoPos (node);   {current field name from templ}
          fieldName := templ.getCurrStr;
          plEnt.gotoPos (p_plEntName);   {plane record at record name entry}
          if plEnt.gotoContStr (fieldName) then   {find field name at plEnt}
            begin
{              CTlog.clearError;
              plEnt.gotoCont;
              if CTlog.getError then
                begin
                  CTlog.infoMsg(5,1,'dbFieldStruct: value not found for ' +
                               'field: ' + fieldName);
                  exit
                end;
              value := plEnt.getCurrStr;
              if not stEnt.gotoContStr (fieldName) then
                stEnt.addLastCont (fieldName);
              if not stEnt.gotoContStr (value) then
                stEnt.addCont (value);
              CTlog.infoMsg(0,3,'dbFieldStruct: field-value added: ' +
                                fieldName + '-' + value);   }
              if stEnt.gotoContStr (fieldName) then
                begin   {the field is already in stEnt, moving value only}
                  CTlog.clearError;
                  plEnt.gotoCont;
                  if CTlog.getError then
                    begin
                      CTlog.infoMsg (5, 1, 'dbFieldStruct: value not found' +
                                   ' for field: ' + fieldName);
                      exit
                    end;
                  value := plEnt.getCurrStr;
                  if not stEnt.gotoContStr (value) then
                    begin   {the value is not in the field in stEnt}
                      stEnt.gotoCont;
                      stEnt.gotoLast;
                      plEnt.moveCurrTo (stEnt, '.');
                      CTlog.infoMsg(0,3,'dbFieldStruct: value added: ' +
                                         value + ' to field: '+fieldName);
                    end
                end
              else
                begin   {field not in stEnt yet, moving all field}
                  CTlog.clearError;
                  stEnt.gotoCont;
                  if CTlog.getError then
                    begin   {no ther fields as cont}
                      plEnt.moveCurrTo (stEnt, ':');
                      stEnt.gotoCont;   {stEnt.currPos at last value}
                    end
                  else
                    begin
                      stEnt.gotoLast;
                      plEnt.moveCurrTo (stEnt, '.');
                      stEnt.gotoCont;   {stEnt.currPos at last value}
                    end;
                  CTlog.infoMsg(0,3,'dbFieldStruct: field-value added: ' +
                                fieldName)
                end;
              currFieldRec (node^.cont);
              stEnt.gotoTitle;
              stEnt.gotoTitle;
            end
          else
            CTlog.infoMsg (0,1,'dbFieldStruct: field '+fieldName+'not found'+
                                 ' in input plane record, skipping field.');
          currFieldRec (node^.next)
        end
    end;   {currFieldRec}

  begin   {dbFieldStruct}
    CTlog.clearError;
    templ.gotoRoot;
    if CTlog.getError then
      begin
        CTlog.infoMsg (2,1,'dbFieldStruct: Error in the template structure.');
        exit
      end;
    dbEntryName := templ.getCurrStr;   {record entry name}
    p_plEntName := plEnt.findTextRec (NIL, dbEntryName);  {entry name at plEnt}
    if p_plEntName = NIL then
      begin
        CTlog.infoMsg (2,1,'dbFieldStruct: DB entry not found in input CT: '
                           + dbEntryName);
        exit
      end;
    p_stEntName := stEnt.findTextRec (NIL, dbEntryName);  {entry name at stEnt}
    if p_stEntName = NIL then
      begin
        CTlog.infoMsg (0,2,'dbFieldStruct: DB entry ' + dbEntryName +
                      ' not found in output CT, creating node as last root.');
        stEnt.gotoRoot;
        stEnt.addLast (dbEntryName);
        p_stEntName := stEnt.getCurrPos
      end;
    repeat;
      templ.gotoRoot;
      CTlog.clearError;
      templ.gotoCont;
      currFieldRec (templ.getCurrPos);
      if CTlog.getError then
        CTlog.infoMsg(1,1,'dbFieldStruct: DB structured record was not added.')
      else
        CTlog.infoMsg (0,2,'dbFieldStruct: DB structured record added.');
      plEnt.gotoPos (p_plEntName);
      p_plEntName := NIL;   {changing flag to exit if no additional DB entries}
      if plEnt.gotoNextStr (dbEntryName) then
        p_plEntName := plEnt.getCurrPos;
      inc (nRec);
    until p_plEntName = NIL;
    str (nRec, num);
    CTlog.infoMsg (0,1,'dbFieldStruct: ' + num + ' record added.');
  end;   {dbFieldStruct}

{|-procedure condText_test; :-Tests the unit conText .
 |  -Internal procedures :
 |    -addPrint ;;|}
  procedure condText_test (opt: string);

    procedure addPrint;
      var
        ct: obj_condText;
      begin
        CTLog.setOutputDevice (c_outdev_file, 'testCT.log', 'rewrite');
        CTlog.setOutputLevel (3);
        ct.init;
        ct.addRoot ('Root node');
        ct.addNext ('node 2');
        ct.addNext ('node 3');
        ct.addCont ('node 3.1');
        ct.gotoRoot;
        ct.gotoNext;
        ct.addCont ('node 2.1');
        ct.addCont ('node 2.1.1');
        ct.addCont ('{propertyRecord}');
        ct.addCont ('any property with its value...');
        ct.gotoRootTitle;
        ct.gotoCont;
        ct.addNext ('node 2.2');
        ct.addCont ('node 2.2.1');
        ct.addCont ('node 2.2.1.1');
        ct.addNext ('node 2.2.1.2');
        ct.addCont ('node 2.2.1.2.1 - This is a line too long to be printed ' +
                    'in one single line, so it is splitted. ok????????????? ' +
                    'For longer strings more lines will be used.');
        ct.print (ct.root,0,0,1,1,'');
        ct.gotoRootTitle;
        ct.gotoCont;
        ct.gotoLast;
        writeln;
        ct.print (ct.root,0,0,2,1,'');
        writeln;
        ct.print (ct.root,0,0,3,3,'test1.ct');
        CTLog.setOutputDevice (c_outdev_screen,'','');
        ct.finish;
      end;   {addPrint}

    procedure openPrint;
      var
        ct: obj_condText;
      begin
        CTLog.setOutputDevice (c_outdev_file, 'test3.log', 'rewrite');
        CTlog.setOutputLevel (1);
        ct.init;
        ct.open ('/Users/carloszep/Zep/DocuAct/cuentas-oct2011.ct', 'I');
        ct.gotoRoot; ct.gotoCont; ct.gotoCont;
        ct.print (ct.root,0,0,3,3,'test3.ct');
        CTlog.setOutputLevel (3);
        if ct.findTextRec(ct.currPos,'focos (bombillas) 60 Watts') = NIL then
          writeln ('text not found!')
        else
          writeln ('text found!');
        ct.finish;
        condText_finish;  {or CTlog.finish could be used}
      end;   {openPrint}

    procedure openPrintProps;
      var
        ct: obj_condText;
        posN: p_CTnode;
      begin
        CTlog.setOutputLevel (3);
        CTlog.setOutputDevice (c_outdev_file, 'inpTest.log', 'rewrite');
        ct.init;
        ct.open('inpTest.ct','I');
        writeln ('Printing starting with NIL node.');
        ct.print (NIL,0,0,3,1,'');
        writeln ('Printing from the root node.');
        ct.print (ct.root, 0, 3, c_CToutType_format, c_outdev_screen_file, 'outTest.ct');
        writeln;
        ct.print (ct.root, 0, 0, c_CToutType_noCtrl, c_outdev_screen,'');
        writeln;
        posN:=ct.findTextRec(NIL,'nodeSearch');
        if posN <> NIL then writeln ('nodeSearch found');
        ct.print (ct.root, 0, 0, c_CToutType_unformat, c_outdev_screen,'');
        ct.finish;
        condText_finish;
      end;

    procedure findingText;
      var
        ct : obj_condText;
        pos : p_CTnode;
      begin
        CTlog.setOutputLevel (3);
        CTlog.setOutputDevice (c_outdev_file, 'inpTest.log', 'rewrite');
        ct.init;
        ct.open('inpTest.ct','I');
        pos := NIL;
        pos := ct.findText (NIL, 'final');
        if pos <> NIL then
          writeln ('Text found: final')
        else
          writeln ('text not found in the root list: final');
        pos := NIL;
        pos := ct.findText (ct.getRoot,
          'Nodo previo a donde se toman las propiedades locales');
        pos := ct.findTextRec (pos, '{propertyRecord}');
        if pos <> NIL then
          begin
            writeln ('text found recursively.');
            ct.gotoPos (pos);
            ct.addFieldValue ('newField', 'newValue');
            ct.addFieldValue ('newField 2', 'newValue 2');
            ct.print(pos, 0, 0, 4, 1, '');
            writeln ('Field-Value: newField-' +
                     ct.getFieldValue (pos, 'newField'));
            writeln ('Field-Value: newField3-' +
                     ct.getFieldValue (pos, 'newField3'))
          end
        else
          writeln ('recursive search did not work.');
        pos := ct.findSubstr (pos, 'Length');
        if pos <> NIL then
          writeln ('substring found')
        else
          writeln ('substring not found');
        pos := ct.findSubstrRec (NIL, 'Length');
        if pos <> NIL then
          begin
            writeln ('substring found recursively');
            ct.print(pos, 1, 1, 4, 1, '')
          end
        else
          writeln ('substring not found recursively');
        ct.finish;
        condText_finish;
      end;   {findingText}
      
    procedure dataBases;
      var
        recPl, templ, recStr : obj_condText;
      begin
        CTlog.setOutputLevel (2);
        CTlog.setOutputDevice (c_outdev_file, 'DBtest.log', 'rewrite');
        recPl.init;
        recPl.open ('pdbPlaneRecs.ct', 'I');
        templ.init;
        templ.open ('pdbEntryTempl.ct', 'I');
        recStr.init;
        recStr.addRoot ('Molecule');
        recStr.addCont ('pdbAtom');
        writeln ('Registro original:');
        recPl.print (NIL, 0, 0, 3, 1,  '');
        dbFieldStruct (recPl, templ, recStr);
        writeln ('Registro original modificado:');
        recPl.print (NIL, 0, 0, 3, 1,  '');
        writeln ('Estructura de plantilla:');
        templ.print (NIL, 0, 0, 3, 1, '');
        writeln ('Registro final:');
        recStr.print (NIL, 0, 0, 3, 1, '')
      end;   {dataBases}
    
    begin   {condText_test}
      if opt = 'all' then
        begin
        end
      else if opt = 'addPrint' then
        addPrint
      else if opt = 'openPrint' then
        openPrint
      else if opt = 'openPrintProps' then
        openPrintProps
      else if opt = 'findingText' then
        findingText
      else if opt = 'dataBases' then
        dataBases
      else
        CTlog.infoMsg (3, 1, 'condText_test: Valid arguments are: all, ' +
          'addPrint, openPrint, openPrintProps, findingText, dataBases.');
      condText_finish
    end;   {condText_test}

  procedure condText_init;
    begin
      CTlog.init;
      CTlog.setInfoMsgName ('condText');
      CTlog.setOutputDevice (c_outdev_screen,'','');
      bulletSet:=['-', '+', '*', '>', '<', '~', '='];
      ctrlCharSet:=['.', ':', ';'];
    end;   {condText_init}

  procedure condText_finish;
    begin
      CTlog.finish;
    end;

begin   {unit condText}
  condText_init
end.

