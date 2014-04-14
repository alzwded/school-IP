unit IPEditFormUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  EditBtn, Grids, Buttons;

type
  TKeyValuePair = record
    key, value: string;
  end;

  TStringArray = array of string;
  TKeyValueArray = array of TKeyValuePair;

  { TEditForm }

  TEditForm = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    DateEdit1: TDateEdit;
    StringGrid1: TStringGrid;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
  private
    initialKeys: TStringList;
    { private declarations }
  public
    { public declarations }
    procedure SetData(FirstName, LastName: string; DateOfBirth: TDate; Fields: array of TKeyValuePair);
    function GetDeletedKeys: TStringArray;
    function GetModifiedDetails: TKeyValueArray;
    function GetNewDetails: TKeyValueArray;
    function GetFirstName: string;
    function GetLastName: string;
    function GetBirthday: TDate;
  end;

var
  EditForm1: TEditForm;

implementation

{$R *.lfm}

function TEditForm.GetFirstName: string;
begin
  GetFirstName := Edit1.Text;
end;

function TEditForm.GetLastName: string;
begin
  GetLastName := Edit2.Text;
end;

function TEditForm.GetBirthday: TDate;
begin
  GetBirthday := DateEdit1.Date;
end;


function TEditForm.GetDeletedKeys: TStringArray;
var
  i: integer;
  myset: TStringList;
  ret: array of string;
  s: string;
begin
  myset := TStringList.Create;
  for i := StringGrid1.FixedRows to StringGrid1.RowCount - 1 do begin
    myset.Add(StringGrid1.Cells[0, i]);
  end;
  myset.Sort;
  SetLength(ret, 0);
  for s in initialKeys do begin
    if myset.IndexOf(s) = -1 then begin
      SetLength(ret, Length(ret) + 1);
      ret[Length(ret) - 1] := s;
    end;
  end;
  myset.Free;
  GetDeletedKeys := ret;
end;

function TEditForm.GetModifiedDetails: TKeyValueArray;
var
  i: integer;
  ret: TKeyValueArray;
begin
  for i := StringGrid1.FixedRows to StringGrid1.RowCount - 1 do begin
    if initialKeys.IndexOf(StringGrid1.Cells[0, i]) <> -1 then begin
      SetLength(ret, Length(ret) + 1);
      ret[Length(ret) - 1].Key := StringGrid1.Cells[0, i];
      ret[Length(ret) - 1].Value := StringGrid1.Cells[1, i];
    end;
  end;
  GetModifiedDetails := ret;
end;

function TEditForm.GetNewDetails: TKeyValueArray;
var
  i: integer;
  ret: array of TKeyValuePair;
begin
  for i := StringGrid1.FixedRows to StringGrid1.RowCount - 1 do begin
    if initialKeys.IndexOf(StringGrid1.Cells[0, i]) = -1 then begin
      SetLength(ret, Length(ret) + 1);
      ret[Length(ret) - 1].Key := StringGrid1.Cells[0, i];
      ret[Length(ret) - 1].Value := StringGrid1.Cells[1, i];
    end;
  end;
  GetNewDetails := ret;
end;

procedure TEditForm.Button1Click(Sender: TObject);
begin
  StringGrid1.RowCount := StringGrid1.RowCount + 1;
end;

procedure TEditForm.Button2Click(Sender: TObject);
var
  i, selected: integer;
begin
  selected := StringGrid1.Selection.Top;
  if selected <= 0 then exit;

  writeln(selected);
  writeln(StringGrid1.RowCount);

  for i := selected + 1 to StringGrid1.RowCount - 1 do begin
    StringGrid1.Cells[0, i - 1] := StringGrid1.Cells[0, i];
    StringGrid1.Cells[1, i - 1] := StringGrid1.Cells[1, i];
  end;

  StringGrid1.RowCount := StringGrid1.RowCount - 1;
end;

procedure TEditForm.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
end;

procedure TEditForm.FormCloseQuery(Sender: TObject; var CanClose: boolean);
var
  list: TStringList;
  i: integer;
  can: boolean;
begin
  if ModalResult = mrCancel then exit;
  // check for duplicates
  can := true;
  list := TStringList.Create;
  list.Sorted := True;
  list.Duplicates:=dupError;
  try
    for i := StringGrid1.FixedRows to StringGrid1.RowCount - 1 do begin
      writeln(StringGrid1.Cells[0, i]);
      list.Add(StringGrid1.Cells[0, i]);
    end;
  except
    on EStringListError do can := false
  end;
  list.Free;
  writeln(can);
  CanClose := can;
end;

{ TEditForm }
procedure TEditForm.SetData(FirstName, LastName: string; DateOfBirth: TDate; Fields: array of TKeyValuePair);
var
  i: integer;
begin
  Caption := 'Details of ' + FirstName + ' ' + LastName;
  Edit1.Text := FirstName;
  Edit2.Text := LastName;
  DateEdit1.Text := DateToStr(DateOfBirth);
  StringGrid1.Clean;
  StringGrid1.RowCount := StringGrid1.FixedRows + Length(Fields);
  StringGrid1.Columns[0].Title.Caption := 'Type';
  StringGrid1.Columns[1].Title.Caption := 'Data';
  if initialKeys = Nil then
    initialKeys := TStringList.Create;
  initialKeys.Clear;
  for i := 0 to Length(Fields) - 1 do begin
    initialKeys.Add(Fields[i].Key);
    StringGrid1.Cells[0, StringGrid1.FixedRows + i] := Fields[i].Key;
    StringGrid1.Cells[1, StringGrid1.FixedRows + i] := Fields[i].Value;
  end;
  initialKeys.Sort;
end;

end.

