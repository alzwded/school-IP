unit mainform;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqlite3conn, sqldb, db, BufDataset, FileUtil, Forms,
  Controls, Graphics, Dialogs, DBGrids, Grids, StdCtrls, ComCtrls, Clipbrd;

const
  THECAPTION = 'RefsMgr';

type

  { TForm1 }

  TForm1 = class(TForm)
    AddButton: TButton;
    RefreshButton: TButton;
    DeleteButton: TButton;
    SaveButton: TButton;
    StatusBar1: TStatusBar;
    UndoButton: TButton;
    Datasource1: TDatasource;
    SQLite3Connection1: TSQLite3Connection;
    SQLQuery1: TSQLQuery;
    SQLTransaction1: TSQLTransaction;
    Table1: TStringGrid;
    procedure AddButtonClick(Sender: TObject);
    procedure RefreshButtonClick(Sender: TObject);
    procedure DeleteButtonClick(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
    procedure StatusBar1DblClick(Sender: TObject);
    procedure Table1SelectCell(Sender: TObject; aCol, aRow: Integer;
      var CanSelect: Boolean);
    procedure UndoButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Table1EditingDone(Sender: TObject);
    procedure Table1GetEditText(Sender: TObject; ACol, ARow: Integer;
      var Value: string);
  private
    { private declarations }
    disableUpdate: boolean;
    prevValue: string;
    procedure MakeDirty;
    procedure Undirty;
    procedure UpdateGrid;
  public
    { public declarations }
  end; 

var
  Form1: TForm1; 

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.MakeDirty;
begin
  SaveButton.Enabled := True;
  UndoButton.ENabled := True;
  Form1.Caption := '*' + THECAPTION;
end;

procedure TForm1.Undirty;
begin
  SaveButton.Enabled := False;
  UndoButton.ENabled := False;
  Form1.Caption := THECAPTION;
end;

procedure TForm1.UpdateGrid;
var
  i: integer;
begin
  disableUpdate := true;
  SQLQuery1.Active := True;
  Table1.EditorMode:=true;
  Table1.Columns[0].Title.Caption := 'id';
  Table1.Columns[0].ReadOnly := True;
  Table1.Columns[1].Title.Caption := 'location';
  Table1.Columns[2].Title.Caption := 'localfile';
  Table1.Columns[3].Title.Caption := 'notes';
  Table1.RowCount := 1 + SQLQuery1.RecordCount;
  SQLQuery1.First;
  i := 1;
  while not SQLQuery1.EOF do begin
    writeln(i);
    Table1.Cells[0, i] := SQLQuery1.FieldByName('id').AsString;
    Table1.Cells[1, i] := SQLQuery1.FieldByName('location').AsString;
    Table1.Cells[2, i] := SQLQuery1.FieldByName('localfile').AsString;
    Table1.Cells[3, i] := SQLQuery1.FieldByName('notes').AsString;
    SQLQuery1.Next;
    inc(i);
  end;
  SQLQuery1.Active := False;
  disableUpdate := false;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  UpdateGrid;
end;

procedure TForm1.Table1EditingDone(Sender: TObject);
var
  row: integer;
  col: integer;
  q: TSQLQuery;
begin
  if disableUpdate then exit;

  row := Table1.Row;
  col := Table1.Col;

  if prevValue = Table1.Cells[col, row] then exit;

  q := TSQLQuery.Create(self);
  q.DataBase := SQLite3Connection1;
  q.Transaction := SQLTransaction1;

  q.SQL.Add('UPDATE refs SET ' + Table1.Columns[col].Title.Caption + ' = :value WHERE id = :rowid ; ');

  writeln(Table1.Columns[col].Title.Caption);
  writeln(Table1.Cells[col, row]);
  writeln(StrToInt(Table1.Cells[0, row]));
  writeln(q.SQL[0]);
  q.ParamByName('value').AsString := Table1.Cells[col, row];
  q.ParamByName('rowid').AsInteger := StrToInt(Table1.Cells[0, row]);

  q.ExecSQL;

  MakeDirty;
  q.Free;
end;

procedure TForm1.Table1GetEditText(Sender: TObject; ACol, ARow: Integer;
  var Value: string);
begin
  prevValue := Value;
  writeln(Value);
end;

procedure TForm1.AddButtonClick(Sender: TObject);
var
  q: TSQLQuery;
begin
  q := TSQLQuery.Create(Self);
  q.DataBase := SQLite3Connection1;
  q.Transaction := SQLTransaction1;
  q.SQL.Add('INSERT INTO refs DEFAULT VALUES');
  q.ExecSQL;
  MakeDirty;
  q.Free;
  UpdateGrid;
end;

procedure TForm1.RefreshButtonClick(Sender: TObject);
begin
  UpdateGrid;
end;

procedure TForm1.DeleteButtonClick(Sender: TObject);
var
  q: TSQLQuery;
begin
  q := TSQLQuery.Create(Self);
  q.DataBase := SQLite3Connection1;
  q.Transaction := SQLTransaction1;
  q.SQL.Add('DELETE FROM refs WHERE id = :id');
  q.ParamByName('id').AsInteger := StrToInt(Table1.Cells[0, Table1.Row]);
  q.ExecSQL;
  MakeDirty;
  q.Free;
  UpdateGrid;
end;

procedure TForm1.SaveButtonClick(Sender: TObject);
begin
  SQLTransaction1.CommitRetaining;
  Undirty;
end;

procedure TForm1.StatusBar1DblClick(Sender: TObject);
begin
  Clipboard.AsText := StatusBar1.Panels[0].Text;
end;

procedure TForm1.Table1SelectCell(Sender: TObject; aCol, aRow: Integer;
  var CanSelect: Boolean);
begin
  StatusBar1.Panels[0].Text := Table1.Cells[aCol, aRow];
end;

procedure TForm1.UndoButtonClick(Sender: TObject);
begin
  SQLTransaction1.RollbackRetaining;
  UpdateGrid;
  Undirty;
end;

end.

