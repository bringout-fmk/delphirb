
unit rpreview;


interface

uses
  Windows, SysUtils, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls, Grids, DBGrids, DBCtrls, Db, DBTables,
  Buttons, Tabs, IniFiles, ppViewr, ppTypes, Mask,
  ppForms, ppPrvDlg, ppUtils;

type
  TfrmReport1 = class(TForm)
    Panel1: TPanel;
    Panel3: TPanel;
    pnlPreviewBar: TPanel;
    Bevel1: TBevel;
    Panel4: TPanel;
    btnGo: TButton;
    pnlCancelButton: TPanel;
    spbPreviewCancel: TSpeedButton;
    btnSwitchPreviewer: TButton;
    cbxPrintToArchive: TCheckBox;
    procedure btnGoClick(Sender: TObject);
    procedure DBGrid1DrawDataCell(Sender: TObject; const Rect: TRect; Field: TField; State: TGridDrawState);
    procedure FormCreate(Sender: TObject);
    procedure btnUpdateClick(Sender: TObject);
    procedure TabSet1Change(Sender: TObject; NewTab: Integer;
      var AllowChange: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnLevelsClick(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure btnAddRecordClick(Sender: TObject);
    procedure TabSet2Change(Sender: TObject; NewTab: Integer;
      var AllowChange: Boolean);
    procedure ppViewer1PrintStateChange(Sender: TObject);
    procedure ppViewer1StatusChange(Sender: TObject);
    procedure ppViewer1PageChange(Sender: TObject);
    procedure spbPreviewCancelClick(Sender: TObject);
    procedure spbPreviewPrintClick(Sender: TObject);
    procedure spbPreviewWidthClick(Sender: TObject);
    procedure spbPreview100PercentClick(Sender: TObject);
    procedure spbPreviewWholeClick(Sender: TObject);
    procedure spbPreviewFirstClick(Sender: TObject);
    procedure spbPreviewPriorClick(Sender: TObject);
    procedure spbPreviewNextClick(Sender: TObject);
    procedure spbPreviewLastClick(Sender: TObject);
    procedure mskPreviewPageKeyPress(Sender: TObject; var Key: Char);
    procedure mskPreviewPercentageKeyPress(Sender: TObject; var Key: Char);
    procedure btnSwitchPreviewerClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    FColorCodes: TList;
    FDefaultLanguage: TppLanguageType;
    FJustCreated: Boolean;
    //FLevels: TfrmDMLevelDirectory;
    FIniFile: TIniFile;
    //FReportForm: TdmCustomForm;

    function  CreateForm(aLevel: Integer): TForm;
    procedure ButtonClickEvent(Sender: TObject);
    procedure InitColorCodes;
    procedure LanguageChanged;
    procedure PrintReport(aViewer: TppViewer);
    procedure UpdateRange;
    procedure SetCursor(aCursor: TCursor);
    procedure SetRange(aStart, aEnd: Longint);


  public
    { Public declarations }
  end;

var
  frmReport1: TfrmReport1;

implementation



{$R *.DFM}

{******************************************************************************
 *
 ** E V E N T   H A N D L E R S
 *
{******************************************************************************}

{------------------------------------------------------------------------------}
{ TfrmDMMain.FormCreate }

procedure TfrmReport1.FormCreate(Sender: TObject);
var
  lsPath: String;
begin
  FDefaultLanguage := lgDefault;

  LanguageChanged;

  lsPath := ExtractFilePath(ParamStr(0));

  {initialize database }
  //dbDemo.Connected := False;
  //dbDemo.Params.Values['PATH'] := lsPath;
  //dbDemo.Connected := True;

  //tblDemo.Active := True;

  FIniFile := TIniFile.Create(lsPath + 'DM.INI');

  //FLevels := nil;
  //FReportForm := nil;

  FColorCodes := TList.Create;
  InitColorCodes;

  btnLevelsClick(Self);

  FJustCreated := True;

end; {procedure, FormCreate}

{------------------------------------------------------------------------------}
{ TfrmDMMain.FormActivate }

procedure TfrmReport1.FormActivate(Sender: TObject);
begin

  if FJustCreated then
    begin
      FJustCreated := False;

      //TabSet1.TabIndex := FIniFile.ReadInteger('MAINFORM', 'CURRENTTAB', 0);

      //tblDemo.MoveBy(FIniFile.ReadInteger('MAINFORM', 'CURRENTROW', 0));
    end;

end; {procedure, FormActivate}

{------------------------------------------------------------------------------}
{ TfrmDMMain.FormDestroy }

procedure TfrmReport1.FormDestroy(Sender: TObject);
begin
  FColorCodes.Free;
end;

{------------------------------------------------------------------------------}
{ TfrmDMMain.FormClose }

procedure TfrmReport1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //FReportForm.Free;

  //if tblDemo.Active then
  //  begin
  //    FIniFile.WriteInteger('MAINFORM', 'CURRENTROW', tblDemo.FieldByName('Level').AsInteger - ((TabSet1.TabIndex * 10) + 1));
  //    FIniFile.WriteInteger('MAINFORM', 'CURRENTTAB', TabSet1.TabIndex);
  //  end;

  FIniFile.Free;

  if (ppViewer1.Report <> nil) and ppViewer1.Report.Printing then
    ppViewer1.Cancel;

end; {procedure, FormClose}

{------------------------------------------------------------------------------}
{ TfrmDMMain.btnUpdateClick }

procedure TfrmReport1.btnUpdateClick(Sender: TObject);
begin
  UpdateRange;
end; {procedure, btnUpdateClick}

{------------------------------------------------------------------------------}
{ TfrmDMMain.btnAddRecordClick }

procedure TfrmReport1.btnAddRecordClick(Sender: TObject);
begin
//  tblDemo.Append;
//  tblDemo.Post;
end; {procedure, btnAddRecordClick}

{------------------------------------------------------------------------------}
{ TfrmDMMain.btnLevelsClick }

procedure TfrmReport1.btnLevelsClick(Sender: TObject);
begin
  //if (FLevels = nil) then
  //  begin
  //    FLevels := TfrmDMLevelDirectory.Create(Application);
  //    FLevels.OnButtonClick := ButtonClickEvent;
  //  end;

  //FLevels.Show;
end; {procedure, btnLevelsClick}

{------------------------------------------------------------------------------}
{ TfrmDMMain.TabSet2Change }





{------------------------------------------------------------------------------}
{ TfrmDMMain.btnPrintClick }

procedure TfrmReport1.btnGoClick(Sender: TObject);
begin
  //PrintReport(nil);
end; {procedure, btnPrintClick}

{------------------------------------------------------------------------------}
{ TfrmDMMain.TabSet1Change }

procedure TfrmReport1.TabSet1Change(Sender: TObject; NewTab: Integer;
  var AllowChange: Boolean);
begin
  SetRange((NewTab * 10) + 1, (NewTab * 10) + 10);

end; {procedure, TabSet1Change}

{------------------------------------------------------------------------------}
{ TfrmDMMain.DBGrid1DblClick }

procedure TfrmReport1.DBGrid1DblClick(Sender: TObject);
begin
  ppViewer1.Reset;

  PrintReport(ppViewer1);
end; {procedure, DBGrid1DblClick}


{******************************************************************************
 *
 ** P R O C E D U R E S
 *
{******************************************************************************}

{------------------------------------------------------------------------------}
{ TfrmDMMain.InitColorCodes }

procedure TfrmReport1.InitColorCodes;
begin

  FColorCodes.Add(TObject(clYellow));
  FColorCodes.Add(TObject(clYellow));
  FColorCodes.Add(TObject(clAqua));
  FColorCodes.Add(TObject(clFuchsia));
  FColorCodes.Add(TObject(clLime));
  FColorCodes.Add(TObject(clRed));
  FColorCodes.Add(TObject(clBlue));
  FColorCodes.Add(TObject(clOlive));
  FColorCodes.Add(TObject(clTeal));
  FColorCodes.Add(TObject(clPurple));
  FColorCodes.Add(TObject(clGreen));
  FColorCodes.Add(TObject(clMaroon));
  FColorCodes.Add(TObject(clNavy));

end; {procedure, InitColorCodes}

{------------------------------------------------------------------------------}
{ TfrmDMMain.CreateForm }

function TfrmReport1.CreateForm(aLevel: Integer): TForm;
var
  lFormClass: TFormClass;
  lsClassName: String;
begin


end; {procedure, CreateForm}



{------------------------------------------------------------------------------}
{ TfrmDMMain.PrintReport }

procedure TfrmReport1.PrintReport(aViewer: TppViewer);
var
  lForm: TdmCustomForm;
  liRow: Integer;
begin
  {free any previously created report form}
  FReportForm.Free;
  FReportForm := nil;

  {reset viewer to page 1}
  ppViewer1.Reset;

  liRow := tblDemo.FieldByName('Level').AsInteger;

  lForm := CreateForm(liRow);

  if (lForm <> nil) then
    lForm.Report.Language := FDefaultLanguage;

  if lForm = nil then
    MessageDlg('No form found.',mtWarning, [mbOK], 0)

  else if lForm.DisplayFormModal then
    begin
      lForm.ShowModal;

      lForm.Free;
    end

  else if lForm.DisplayForm and lForm.AssignViewer then
    begin
      ppViewer1.Report := lForm.Report;

      lForm.Show;
    end

  else if lForm.DisplayForm and (aViewer = nil) then
    begin
      lForm.ShowModal;

      lForm.Free;
    end

  else
    begin
      SetCursor(crHourGlass);

      if (aViewer <> nil) then
        begin
          aViewer.Report := lForm.Report;

          lForm.Report.PrintToDevices;

          FReportForm := lForm;
        end

      else
        begin
          lForm.Report.ModalPreview := True;

{$IFDEF CachePages}
          lForm.Report.CachePages := True;
{$ENDIF}

          if cbxPrintToArchive.Checked then
            begin
              lForm.Report.AllowPrintToArchive := True;
              lForm.Report.ArchiveFileName := ExtractFilePath(ParamStr(0)) + 'Archives\dm' + Copy(lForm.ClassName, 5, 4) + '.raf';
              lForm.Report.Device := dvArchive;
            end;

          lForm.Report.Print;

          lForm.Free;
        end;

      SetCursor(crDefault);

    end;

end; {procedure, PrintReport}

{------------------------------------------------------------------------------}
{ TfrmDMMain.SetCursor }

procedure TfrmReport1.SetCursor(aCursor: TCursor);
begin
  Cursor := aCursor;
  DBGrid1.Cursor := aCursor;
  TabSet1.Cursor := aCursor;
  DBMemo2.Cursor := aCursor;
end; {procedure, SetCursor}

{------------------------------------------------------------------------------}
{ TfrmDMMain.DBGrid1DrawDataCell }

procedure TfrmReport1.DBGrid1DrawDataCell(Sender: TObject; const Rect: TRect; Field: TField; State: TGridDrawState);
var
  lColor: TColor;
  lRect: TRect;

begin


  if (Field.DataType <> ftBoolean) then Exit;


  if (gdSelected in State) then
    lColor := clHighlight
  else
    lColor := clWindow;

  DBGrid1.Canvas.Pen.Color := lColor;
  DBGrid1.Canvas.Brush.Color := lColor;

  DBGrid1.Canvas.Rectangle(Rect.Left, Rect.Top, Rect.Right, Rect.Bottom);

  if (Field.Value) then
    begin
      lColor := TColor(FColorCodes[Field.Index]);

      if (gdSelected in State) and (lColor = clNavy) then
        lColor := clHighlightText;

      DBGrid1.Canvas.Pen.Color := lColor;
      DBGrid1.Canvas.Brush.Color := lColor;

      lRect.Left   := Rect.Left + (((Rect.Right - Rect.Left) - 6) div 2);
      lRect.Top    := Rect.Top + (((Rect.Bottom - Rect.Top) - 6) div 2);
      lRect.Right  := Rect.Right - (((Rect.Right - Rect.Left) - 6) div 2);
      lRect.Bottom := Rect.Bottom - (((Rect.Bottom - Rect.Top) - 6) div 2);

      DBGrid1.Canvas.Rectangle(lRect.Left, lRect.Top, lRect.Right, lRect.Bottom);
    end;


end; {procedure, DBGrid1DrawDataCell}

{------------------------------------------------------------------------------}
{ TfrmDMMain.UpdateRange }

procedure TfrmReport1.UpdateRange;
var
  liRangeStart: Integer;
  liRangeEnd: Integer;
  liRow: Integer;
  lForm: TdmCustomForm;

begin

  tblDemo.First;
  liRangeStart := tblDemo.FieldByName('Level').AsInteger;

  tblDemo.Last;
  liRangeEnd := tblDemo.FieldByName('Level').AsInteger;

  liRow := liRangeStart;
  tblDemo.First;

  while (liRow <= liRangeEnd) do
    begin

      lForm := CreateForm(liRow);

      if (lForm <> nil) then
        ReportToDB(tblDemo, lForm.Report)
      else
        ReportToDB(tblDemo, nil);

      lForm.Free;

      tblDemo.Next;

      Inc(liRow);
    end;

  tblDemo.First;

end; {procedure, UpdateRange}

{------------------------------------------------------------------------------}
{ TfrmDMMain.ppViewer1PrintStateChange }

procedure TfrmReport1.ppViewer1PrintStateChange(Sender: TObject);
var
  lPosition: TPoint;
begin

  if ppViewer1.Busy then
    begin
      mskPreviewPercentage.Enabled := False;
      mskPreviewPage.Enabled := False;

      pnlPreviewBar.Cursor := crHourGlass;

      ppViewer1.Cursor := crHourGlass;

      pnlStatusBar.Cursor := crHourGlass;

      spbPreviewCancel.Cursor := crArrow;

      spbPreviewCancel.Enabled := True;
    end
  else
    begin
      mskPreviewPercentage.Enabled := True;
      mskPreviewPage.Enabled := True;

      pnlPreviewBar.Cursor := crDefault;

      ppViewer1.Cursor := crDefault;

      pnlStatusBar.Cursor := crDefault;

      spbPreviewCancel.Cursor := crDefault;

      spbPreviewCancel.Enabled := False;
    end;

  {this code will force the cursor to update}
  GetCursorPos(lPosition);
  SetCursorPos(lPosition.X, lPosition.Y);

end; {procedure, ppViewer1PrintStateChange}

{------------------------------------------------------------------------------}
{ TfrmDMMain.ppViewer1StatusChange }

procedure TfrmReport1.ppViewer1StatusChange(Sender: TObject);
begin

  pnlStatusBar.Caption := ppViewer1.Status;

end; {procedure, ppViewer1StatusChange}

{------------------------------------------------------------------------------}
{ TfrmDMMain.ppViewerPageChange }

procedure TfrmReport1.ppViewer1PageChange(Sender: TObject);
begin
  mskPreviewPage.Text := IntToStr(ppViewer1.AbsolutePageNo);
  mskPreviewPercentage.Text := IntToStr(ppViewer1.CalculatedZoom);
end; {procedure, ppViewerPageChange}

{------------------------------------------------------------------------------}
{ TfrmDMMain.spbPreviewPrintClick }

procedure TfrmReport1.spbPreviewPrintClick(Sender: TObject);
begin
  ppViewer1.Print;
end; {procedure, spbPreviewPrintClick}

{------------------------------------------------------------------------------}
{ TfrmDMMain.spbPreviewCancelClick }

procedure TfrmReport1.spbPreviewCancelClick(Sender: TObject);
begin
  if ppViewer1.Report.Printing then
    ppViewer1.Cancel;
end; {procedure, spbPreviewCancelClick}

{------------------------------------------------------------------------------}
{ TfrmDMMain.spbPreviewFirstClick}

procedure TfrmReport1.spbPreviewFirstClick(Sender: TObject);
begin
  ppViewer1.FirstPage;
end; {procedure, spbCloseClick}

{------------------------------------------------------------------------------}
{ TfrmDMMain.spbPreviewPriorClick}

procedure TfrmReport1.spbPreviewPriorClick(Sender: TObject);
begin
  ppViewer1.PriorPage;
end; {procedure, spbPreviewFirstClick}

{------------------------------------------------------------------------------}
{ TfrmDMMain.spbPreviewNextClick}

procedure TfrmReport1.spbPreviewNextClick(Sender: TObject);
begin
  ppViewer1.NextPage;
end; {procedure, spbPreviewNextClick}

{------------------------------------------------------------------------------}
{ TfrmDMMain.spbPreviewLastClick}

procedure TfrmReport1.spbPreviewLastClick(Sender: TObject);
begin
  ppViewer1.LastPage;
end; {procedure, spbPreviewLastClick}

{------------------------------------------------------------------------------}
{ TfrmDMMain.mskPreviewPageKeyPress}

procedure TfrmReport1.mskPreviewPageKeyPress(Sender: TObject; var Key: Char);
var
  liPage: Longint;
begin

  if (Key = #13) then
    begin
      liPage := StrToInt(mskPreviewPage.Text);

      ppViewer1.GotoPage(liPage);
    end; {if, carriage return pressed}

end; {procedure, mskPreviewPageKeyPress}

{------------------------------------------------------------------------------}
{ TfrmDMMain.spbPreviewZoomClick }

procedure TfrmReport1.spbPreviewWholeClick(Sender: TObject);
begin
  ppViewer1.ZoomSetting := zsWholePage;

  mskPreviewPercentage.Text := IntToStr(ppViewer1.CalculatedZoom);

  pnlPreviewBar.SetFocus;
end; {procedure, spbPreviewZoomClick}

{------------------------------------------------------------------------------}
{ TfrmDMMain.spbPreviewWidthClick}

procedure TfrmReport1.spbPreviewWidthClick(Sender: TObject);
begin
  ppViewer1.ZoomSetting := zsPageWidth;

  mskPreviewPercentage.Text := IntToStr(ppViewer1.CalculatedZoom);

  pnlPreviewBar.SetFocus;
end; {procedure, spbPreviewWidthClick}

{------------------------------------------------------------------------------}
{ TfrmDMMain.spbPreview100PercentClick}

procedure TfrmReport1.spbPreview100PercentClick(Sender: TObject);
begin
  ppViewer1.ZoomSetting := zs100Percent;

  mskPreviewPercentage.Text := IntToStr(ppViewer1.CalculatedZoom);

  pnlPreviewBar.SetFocus;
end; {procedure, spbPreview100PercentClick}

{------------------------------------------------------------------------------}
{ TfrmDMMain.mskPreviewPercentageKeyPress}

procedure TfrmReport1.mskPreviewPercentageKeyPress(Sender: TObject; var Key: Char);
var
  liPercentage: Integer;
begin
  if (Key = #13) then
    begin
      liPercentage := StrToIntDef(mskPreviewPercentage.Text, 100);

      ppViewer1.ZoomPercentage := liPercentage;

      spbPreviewWhole.Down := False;
      spbPreviewWidth.Down := False;
      spbPreview100Percent.Down := False;

      mskPreviewPercentage.Text := IntToStr(ppViewer1.CalculatedZoom);
    end; {if, carriage return pressed}

end; {procedure, mskPreviewPercentageKeyPress}

{------------------------------------------------------------------------------}
{ TfrmDMMain.btnSwitchPreviewerClick}

procedure TfrmReport1.btnSwitchPreviewerClick(Sender: TObject);
begin
  if btnSwitchPreviewer.Caption = 'One-Page Preview' then
    begin
      ppRegisterForm(TppCustomPreviewer, TfrmTwoPagePreview);
      btnSwitchPreviewer.Caption := 'Two-Page Preview'
    end

  else
    begin
      ppRegisterForm(TppCustomPreviewer, TppPrintPreview);
      btnSwitchPreviewer.Caption := 'One-Page Preview'
    end;

end; {procedure, btnSwitchPreviewerClick}

{------------------------------------------------------------------------------}
{ TfrmDMMain.LanguageChanged}

procedure TfrmReport1.LanguageChanged;
var
  lBitMap: TBitMap;

begin

  spbPreviewPrint.Hint := ppLoadStr(ppMsgPrint);
  spbPreviewWhole.Hint := ppLoadStr(ppMsgWhole);
  spbPreviewWidth.Hint := ppLoadStr(ppMsgPageWidth);
  spbPreview100Percent.Hint := ppLoadStr(ppMsg100Percent);
  spbPreviewFirst.Hint := ppLoadStr(ppMsgFirst);
  spbPreviewPrior.Hint := ppLoadStr(ppMsgPrior);
  spbPreviewNext.Hint := ppLoadStr(ppMsgNext);
  spbPreviewLast.Hint := ppLoadStr(ppMsgLast);
  spbPreviewCancel.Caption := ppLoadStr(ppMsgCancel);

  lBitMap := TBitMap.Create;
  spbPreviewCancel.Width := lBitMap.Canvas.TextWidth(spbPreviewCancel.Caption) + 30;
  lBitMap.Free;
  
  pnlCancelButton.Width := spbPreviewCancel.Width + 10;
  spbPreviewCancel.Left := (pnlCancelButton.Width - spbPreviewCancel.Width) - 2;

end; {procedure, LanguageChanged}



initialization


                   {basic}
  RegisterClasses([Tfrm0011, Tfrm0012, Tfrm0013, Tfrm0014, Tfrm0015, Tfrm0016, Tfrm0017,
                   Tfrm0018,

                   {images (.bmp, .wmf)}
                   Tfrm0021, Tfrm0022,  Tfrm0023,
{$IFDEF WIN32}
                   {richtext}
                   Tfrm0024, Tfrm0025, Tfrm0026, Tfrm0027, Tfrm0028, Tfrm0029,
{$ENDIF}

                   {newspapercols, mailing lables}
                   Tfrm0031, Tfrm0032, Tfrm0033,

                   {regions}
                   Tfrm0041, Tfrm0042, {Tfrm0043,}

                   {subreports}
                   Tfrm0051, Tfrm0052,

                   {master/detail}
                   Tfrm0061, Tfrm0062, Tfrm0063, Tfrm0064,

                   {multiple master/detail}
                   Tfrm0071, Tfrm0072, Tfrm0073,

                   {dynamic bands with shifting and stretching memos}
                   Tfrm0081, Tfrm0081, Tfrm0082, Tfrm0083, Tfrm0084, Tfrm0085,

                   {barcodes and charts}
                   Tfrm0091,

{$IFDEF ppTeeChart}
                   Tfrm0092,
{$ENDIF}

                   {print to file}
                   Tfrm0101, Tfrm0102, Tfrm0103, Tfrm0104, Tfrm0105, Tfrm0106,
                   Tfrm0107,

                   {data traversal settings}
                   Tfrm0111, Tfrm0112, Tfrm0113, Tfrm0114, Tfrm0115, Tfrm0116,

                   {printer settings}
                   Tfrm0121, Tfrm0122, Tfrm0123, Tfrm0124,

                   {nodata}
                   Tfrm0131, Tfrm0132, Tfrm0133, Tfrm0134, Tfrm0135, Tfrm0136,
                   Tfrm0137, Tfrm0138, Tfrm0139, Tfrm0140,
                   
                   {events}
                   Tfrm0141, Tfrm0142, Tfrm0143, Tfrm0144, Tfrm0145, Tfrm0146,
                   Tfrm0147, Tfrm0148,

                   {drill-down, archive reader}
                   Tfrm0151, Tfrm0152, Tfrm0153, Tfrm0154

                   ]);


end.  
