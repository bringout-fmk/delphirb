unit delrb;

interface


uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ppClass, ppBands, ppCache, ppCtrls, ppComm, ppReport,
  ppPrnabl, ppDB, ppDBBDE, Db, DBTables, ppStrtch, ppMemo, ExtCtrls,
  ppViewr, Buttons, ppProd, ppRelatv, ADSSET, AdsData, AdsFunc, AdsTable,
  ppDBPipe, Grids, DBGrids, clipfn32, ppVar, ppRichTx,Inifiles, ppTypes,
  ppBarCod, ppDBJIT, jpeg, AppEvnts, ppParameter;

type

   TArgumenti = class
    Print: Boolean;
  end;

  TfrmLabel = class(TForm)
    ppReport: TppReport;
    ppReportPipeline: TppDBPipeline;
    tblReport: TAdsTable;
    AdsSettings: TAdsSettings;
    DSReport: TDataSource;
    Label1: TLabel;
    ppJITPipeline: TppJITPipeline;
    ApplicationEvents1: TApplicationEvents;
    ppHeaderBand1: TppHeaderBand;
    ppDetailBand1: TppDetailBand;
    ppDBText2: TppDBText;
    ppDBText5: TppDBText;
    ppDBMemo1: TppDBMemo;
    ppDBText7: TppDBText;
    ppDBText9: TppDBText;
    ppDBText3: TppDBText;
    ppFooterBand1: TppFooterBand;
    ppGroup2: TppGroup;
    ppGroupHeaderBand2: TppGroupHeaderBand;
    ppShape2: TppShape;
    ppShape3: TppShape;
    ppRichText1: TppRichText;
    ppRichText2: TppRichText;
    ppRichText7: TppRichText;
    ppGroupFooterBand2: TppGroupFooterBand;
    ppGroup1: TppGroup;
    ppGroupHeaderBand1: TppGroupHeaderBand;
    ppShape1: TppShape;
    ppLabel1: TppLabel;
    ppLabel4: TppLabel;
    ppLabel5: TppLabel;
    ppLabel6: TppLabel;
    ppLabel7: TppLabel;
    ppLabel11: TppLabel;
    ppGroupFooterBand1: TppGroupFooterBand;
    ppRichText3: TppRichText;
    ppRichText4: TppRichText;
    ppRichText5: TppRichText;
    ppRichTextUkupno: TppRichText;
    ppLine2: TppLine;
    ppLine3: TppLine;
    ppRichText6: TppRichText;
    ppRichText8: TppRichText;
    ppLine1: TppLine;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ppReportPreviewFormClose(Sender: TObject);
    procedure ppVariable1Calc(Sender: TObject; var Value: Variant);
    procedure FillRichTextIzIni;
    procedure ppDetailBandBeforePrintSetColors(Sender: TObject);
    procedure ppDBTextDrawCommandCreateK1(Sender, aDrawCommand: TObject);
    procedure ppDBTextPrintK1(Sender: TObject);
    procedure ppReportPrintDialogClose(Sender: TObject);
    procedure ppReportAfterPrint(Sender: TObject);
    function KonvertDbPath(cPath: String): String;
    procedure FormShow(Sender: TObject);


  private

    FDirPath: String;
    pipe : TppDataPipeLine;
    ExeIni: TIniFile;


  protected
    //function GetReport: TppProducer; override;
    //procedure Init; override;

  public
    { Public declarations }
    Args: TArgumenti;
  end;

var
  frmLabel: TfrmLabel;


implementation

{$R *.DFM}

{------------------------------------------------------------------------------}
{ Tfrm0031.GetReport }

//function TfrmLabel.GetReport: TppProducer;
//begin
//  Result := ppReport;
//end;


procedure TfrmLabel.FormCreate(Sender: TObject);

var lsReportfile: string;
var cKonverzija: string;
var i,j:integer;
var Ini: TIniFile;

begin

  Args:=TArgumenti.Create;
  lsReportFile:='FINXY.rtm';
  ExeIni:=TIniFile.Create(ExtractFilePath(Application.ExeName)+'fmk.ini');
  cKonverzija:=ExeIni.ReadString('DelphiRB','Konverzija','');




  {get app directory }
  FDirPath := ExtractFilePath(ParamStr(0));
  //+ 'Template\';

  // sintaksa poziva ovog fajla je:
  // Labels  <ImeRTMFajla>  <PathDBF>  <ImeDBF> <TAGNAME>
  if Paramcount=0 then ShowMessage('Nije zadat RTM fajl');

  if paramcount>0 then begin
   lsReportFile := ParamStr(1)+'.rtm';
  end;

  if paramcount>3 then begin
    TblReport.Active:=False;
    TblReport.DatabaseName:=KonvertDbPath(ParamStr(2));
    TblReport.TableName:=ParamStr(3);
    TblReport.IndexName:=ParamStr(4);

    if cKonverzija >= '5'  then
       TblReport.AdsTableOptions.AdsCharType:=ANSI;

    // ne kaci se za dbf
    if ParamStr(3)='DUMMY' then begin
        TblReport.Active:=False;
        TblReport.Name:='';
        pipe := ppJITPipeline;

    end else if not FileExists(ParamStr(2)+ParamStr(3)+'.DBF') then begin
      ShowMessage('DBF '+ParamStr(2)+ParamStr(3)+'.dbf'+' ne postoji !');
      Application.Terminate;
    end else begin
      try
        TblReport.Active:=True;
      except
        ShowMessage('Neuspjesno otvaranje tabele:'+TblReport.DatabaseName+'; '+TblReport.TableName+'#'+TblReport.IndexName);
      end;
      pipe := ppReportPipeline;
    end;

  end;

  Args.Print:=False;

  for j:=1 to paramcount do begin
     if Upper(paramstr(j))='/P' then
         Args.Print:=True;

  end;


  ppReport.Template.FileName := FDirPath + lsReportFile;
  ppReport.Template.LoadFromFile;
  if paramcount>=4 then begin
    for i:=4 to paramcount do begin
     if clipfn32.Left(Paramstr(i),6)='pageh:' then begin
        ppReport.PrinterSetup.PaperHeight := clipfn32.xval(clipfn32.substr(Paramstr(i),7,0));
     end;
     if clipfn32.Left(Paramstr(i),6)='paghm:' then begin
        ppReport.PrinterSetup.PaperHeight :=
           ppReport.PrinterSetup.PaperHeight *
           clipfn32.xval(clipfn32.substr(Paramstr(i),7,0));
     end;
      if clipfn32.Left(Paramstr(i),6)='lmarg:' then begin
        ppReport.PrinterSetup.MarginLeft :=
           clipfn32.xval(clipfn32.substr(Paramstr(i),7,0));
     end;
     if clipfn32.Left(Paramstr(i),6)='tmarg:' then begin
        ppReport.PrinterSetup.MarginTop :=
           clipfn32.xval(clipfn32.substr(Paramstr(i),7,0));
     end;
    end;
  end;

  ppReport.AfterPrint:=ppReportAfterPrint;
  ppReport.OnCancel:=ppReportAfterPrint;
  ppReport.OnPreviewFormClose:=ppReportAfterPrint;
  FillRichTextIzIni;




  ppReport.DataPipeline:=pipe;

  {note: just use 'PrintToDevices' to print to a custom viewer}
  ppReport.ResetDevices;

  ppReport.AllowPrintToArchive := True;
  ppReport.ArchiveFileName := 'c:\sigma\outf.raf';



end;  {procedure, FormCreate}



procedure TfrmLabel.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //Action := caFree;

end; {procedure, FormClose}






procedure TfrmLabel.ppReportPreviewFormClose(Sender: TObject);
begin
  //nepotrebno - ovo je premješteno na FormClose
  //Ini2.WriteString('DelphiRB','Aktivan','0');
  //Ini2.Free;
  //Application.Terminate;
end;

procedure TfrmLabel.ppVariable1Calc(Sender: TObject; var Value: Variant);
begin
  Value:='1';
  if ppReport.DataPipeline.EOF then Value:='x';
end;

procedure TfrmLabel.FillRichTextIzIni;

var i0,i,i2, nObjekata, Variablepos, Variablepos2:integer;
    comp: TppComponent;

    rt: TppRichText;
    me: TppMemo;
    cImeVarijable,cVrijednostVarijable: string;
    nProlaza:integer;
    nBandova:integer;
    ini: TIniFile;
    cPom,cPom2:string;


begin


  Ini:=TIniFile.Create(ExtractFilePath(Application.ExeName)+'proizvj.ini');



  //AttrPos := rt.FindText('#%',0,300,[]);



  nBandova:=ppReport.BandCount;

  for i0:=0 to ppReport.BandCount-1 do begin;


  nObjekata:=ppReport.Bands[i0].ObjectCount;

  //ShowMessage('Konverzija:'+cKonverzija) ;
  for i:=0 to nObjekata-1 do begin
    comp:=ppReport.Bands[i0].Objects[i];
    if comp is TppRichText then begin    // rich text objekti
      rt:=(comp As TppRichText);
      while True  do begin // vrti se dok ne ukloniš tarabe
       VariablePos := rt.FindText('#',0, 16384,[]);
       VariablePos2 := rt.FindText('#',VariablePos+1, 16384,[]);
       if (VariablePos>=0) and (VariablePos2>VariablePos) then begin

         rt.SelStart:=VariablePos;
         rt.SelLength:=VariablePos2-VariablePos+1;
         cImeVarijable:=Strtran(rt.SelText,'#','',0,0);
         if clipfn32.Left(cImeVarijable,1)='0' then
           cVrijednostVarijable:=Ini.ReadString('Varijable0',Substr(cImeVarijable,2,0),'')
         else
           cVrijednostVarijable:=Ini.ReadString('Varijable',cImeVarijable,'');

         cPom:=space(16384);
         OemToAnsi(Pchar(cVrijednostVarijable),Pchar(cPom));

         //rt.Text:=strtran(rt.text,cImeVarijable,cPom,0,0);
         rt.SelText:=cPom;
         rt.RichText:=StrTran(rt.RichText,'####','\par ',0,0);
        end else begin
          Break; // izlazi
        end;
      end; // while true
      rt.RichText := StrTran(rt.RichText,'\fcharset0','',0,0);
      rt.RichText := StrTran(rt.RichText,'\fcharset238','',0,0);
      rt.RichText := StrTran(rt.RichText,'\viewkind4','',0,0);
      rt.RichText := StrTran(rt.RichText,'\fnil','',0,0);

     // \ansicpg1252\deff0\deflang1033

    end; // richtext

    if comp is TppMemo then begin    // memoedit objekti
      me:=(comp As TppMemo);

      //while True  do begin // vrti se dok ne ukloniš tarabe
       for i2:=0 to me.Lines.Count-1 do begin
          cPom2:=me.Lines.Strings[i2];
          VariablePos:=Pos('#',cPom2);
          if VariablePos>0 then
              VariablePos2:=Pos( '#',clipfn32.Substr(cPom2,VariablePos+1,0));

          // nasao sam #xx#
          if ((VariablePos>0) and (VariablePos2>0)) then begin
             cImeVarijable:=clipfn32.substr(cPom2,VariablePos+1,VariablePos2-1);
             if clipfn32.Left(cImeVarijable,1)='0' then
                 cVrijednostVarijable:=Ini.ReadString('Varijable0',Substr(cImeVarijable,2,0),'')
             else
                  cVrijednostVarijable:=Ini.ReadString('Varijable',cImeVarijable,'');

             cPom:=space(16384);
             OemToAnsi(Pchar(cVrijednostVarijable),Pchar(cPom));
             cPom:=clipfn32.Left(cPom,VariablePos-1) +
                   cPom +
                   clipfn32.Substr(cPom,VariablePos+VariablePos+2,0);
             me.Lines.Strings[i2] := cPom;
          end; // Variable pos2>0

       end; // for i2

      //end; // while


    end; // memoedit



   end; // i0

  end;






end;

procedure TfrmLabel.ppDetailBandBeforePrintSetColors(Sender: TObject);
var cK1 : String;
    tppfield: TppCustomGraphic;
    i, nobjekata: integer;
    band: TppDetailBand;
    comp: TppComponent;
begin

  // ShowMessage('odoh se formatirati');
  cK1:=tblReport.FieldByName('K1').AsString;

  band:=Sender As TppDetailBand;
  nObjekata:= band.ObjectCount;

  for i:=0 to nObjekata-1 do begin
    comp:=band.Objects[i];
    // Tag je 10 !!!
    if ( (comp is TppCustomGraphic) and (comp.Tag=10)) then begin
      if cK1='3' then begin
         (comp as  TppCustomGraphic).Brush.Color:=clSilver;
      end else if cK1='2' then begin
         (comp as  TppCustomGraphic).Brush.Color:=clSilver;
      end else begin
         (comp as  TppCustomGraphic).Brush.Color:=clWhite;
      end;

    end;
  end;


end;

procedure TfrmLabel.ppDBTextDrawCommandCreateK1(Sender,
  aDrawCommand: TObject);

var cK1 : String;
    tppfield: TppDBText;

begin

 // ShowMessage('odoh se formatirati');
  tppfield := Sender As TppDBText;

  cK1:=tblReport.FieldByName('K1').AsString;

  if  cK1='1' then begin
    tppfield.Font.Size := 11;
    tppfield.Font.Style:= [fsBold];
  end else if cK1='2' then begin
    tppfield.Font.Size := 12;
    tppfield.Font.Style:= [fsBold];
  end else if cK1='3' then begin
    tppfield.Font.Size := 13;
    tppfield.Font.Style:= [fsBold];
  end else if cK1='0' then begin
    tppfield.Font.Size := 10;
    tppfield.Font.Style:= [];


  end;

end;

procedure TfrmLabel.ppDBTextPrintK1(Sender: TObject);
var cK1 : String;
    tppfield: TppDBText;

begin

 // ShowMessage('odoh se formatirati');
  tppfield := Sender As TppDBText;

  cK1:=tblReport.FieldByName('K1').AsString;

  if  cK1='1' then begin
    tppfield.Font.Size := 11;
    tppfield.Font.Style:= [fsBold];
  end else if cK1='2' then begin
    tppfield.Font.Size := 12;
    tppfield.Font.Style:= [fsBold];
  end else if cK1='3' then begin
    tppfield.Font.Size := 13;
    tppfield.Font.Style:= [fsBold];
  end else if cK1='0' then begin
    tppfield.Font.Size := 10;
    tppfield.Font.Style:= [];
  end else if cK1='O' then begin
    // opis
    tppfield.Font.Size := 12;
    tppfield.Font.Style:= [fsBold];


  end;
end;

procedure TfrmLabel.ppReportPrintDialogClose(Sender: TObject);
begin
   Application.Terminate;
end;

procedure TfrmLabel.ppReportAfterPrint(Sender: TObject);
begin
   Application.Terminate;
end;





function TfrmLabel.KonvertDbPath(cPath: String): String;

var
        Ini: TIniFile;
        IniPriv: TIniFile;
        cNetBiosI: String;
        cNetBiosK: String;
        cNetBiosT: String;
        cNetBiosP: String;
        cNetBiosH: String;
        cUserName: String;


begin

Ini:=TIniFile.Create(ExtractFilePath(Application.ExeName)+'fmk.ini');

cNetBiosI:=Ini.ReadString('AdvantageDb','NetBiosI','\\server1\data1');
cNetBiosK:=Ini.ReadString('AdvantageDb','NetBiosK','\\server1\korisn');
cNetBiosT:=Ini.ReadString('AdvantageDb','NetBiosT','\\server1\datatest');
cNetBiosP:=Ini.ReadString('AdvantageDb','NetBiosP','\\server1\prog');

//ime usera
cUserName:=GetEnvironmentVariable('SC_USER');
cNetBiosH:=Ini.ReadString('AdvantageDb','NetBiosH','\\server1');

Ini.Free;

if (clipfn32.Left(AllTrim(Upper(cPath)),2)='I:') then
        Result:=cNetBiosI+SubStr(cPath,3,0)
else if (clipfn32.Left(AllTrim(Upper(cPath)),2)='K:') then
        Result:=cNetBiosK+SubStr(cPath,3,0)
else if (clipfn32.Left(AllTrim(Upper(cPath)),2)='T:') then
        Result:=cNetBiosT+SubStr(cPath,3,0)
else if (clipfn32.Left(AllTrim(Upper(cPath)),2)='P:') then
        Result:=cNetBiosP+SubStr(cPath,3,0)
else if (clipfn32.Left(AllTrim(Upper(cPath)),2)='H:') then begin
        if cUserName='' then
          ShowMessage('environment varijabla SC_USER nije postavljena ?');
        Result:=cNetBiosH+'\'+cUserName+'\'+SubStr(cPath,3,0)
end else
        Result:=cPath;


end;

procedure TfrmLabel.FormShow(Sender: TObject);
begin



  if Args.Print then begin
      //ShowMessage('PPPP');
      ppReport.ShowPrintDialog:=False;
      ppReport.DeviceType:=dtPrinter;

      ppReport.ShowCancelDialog:=False;
      ppReport.Print;


  end else begin
        ppReport.Print;

  end;

  ExeIni.WriteString('DelphiRB','Aktivan','0');
  ExeIni.Free;


end;

end.
