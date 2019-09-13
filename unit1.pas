unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Grids, EditBtn, StdCtrls, Spin, Dos, RegExpr, LCLType, ComCtrls, Windows;

type
  tabDana = record
    punktNadania:string[48];
    kodPrzesylki:string[24];
    waga:double;
    cena:byte;
    nrKuriera:longint;
    czyOplacona:boolean;
    nrNadawcy:longint;
    adres:string[128];
    kodPocztowy:string[8];
    czyUsuniety:boolean;
    id:integer;
  end;
  tabDane = Array of tabDana;
  nadano = record
    punktNadania:string[48];
    id:integer;
  end;
  kodPrzes = record
    kodPrzesylki:string[24];
    id:integer;
  end;
  waga = record
    waga:double;
    id:integer;
  end;
  cena = record
    cena:byte;
    id:integer;
  end;
  nrKuriera = record
    nrKuriera:longint;
    id:integer;
  end;
  czyOplacona = record
    czyOplacona:boolean;
    id:integer;
  end;
  nrNadawcy = record
    nrNadawcy:longint;
    id:integer;
  end;
  adres = record
    adres:string[128];
    id:integer;
  end;
  kodPocztowy = record
    kodPocztowy:string[8];
    id:integer;
  end;

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    ComboBox3: TComboBox;
    ComboBox4: TComboBox;
    ComboBox5: TComboBox;
    ComboBox6: TComboBox;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    FloatSpinEdit1: TFloatSpinEdit;
    FloatSpinEdit2: TFloatSpinEdit;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label2: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    OpenDialog1: TOpenDialog;
    PageControl1: TPageControl;
    SaveDialog1: TSaveDialog;
    SpinEdit1: TSpinEdit;
    SpinEdit2: TSpinEdit;
    SpinEdit3: TSpinEdit;
    SpinEdit4: TSpinEdit;
    SpinEdit5: TSpinEdit;
    SpinEdit6: TSpinEdit;
    StringGrid1: TStringGrid;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure ComboBox3Change(Sender: TObject);
    procedure ComboBox6Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TabSheet1Show(Sender: TObject);
    procedure TabSheet2Show(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;
  tab: tabDane;
  tabPoczNadano:Array of nadano;
  tabPoczKodPrzesylki:Array of kodPrzes;
  tabPoczWaga:Array of waga;
  tabPoczCena:Array of cena;
  tabPoczNrKuriera: Array of nrKuriera;
  tabPoczCzyOplacona: Array of czyOplacona;
  tabPoczNrNadawcy: Array of nrNadawcy;
  tabPoczAdres: Array of adres;
  tabPoczKodPocztowy: Array of kodPocztowy;
  tabLancuchow:Array of Array[0..8] of Integer;
  tabLanInwersyjne:Array of Array of Integer;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Button6Click(Sender: TObject);
begin
  { usuwanie wszystkiego }
  if(length(tab) = 0) then exit;
  SetLength(tab,0);
  StringGrid1.RowCount:=1;//.clean
end;

procedure quickSortWyszukajNadano(var tabElem:tabDane;lewy,prawy:integer);
var
  i,j:Integer;
  x,piwot:tabDana;
begin
  i:=(lewy + prawy) div 2;
  piwot:=tabElem[i];
  tabElem[i]:=tabElem[prawy];
  j:=lewy;
  for i:=lewy to prawy-1 do
    if(tabElem[i].punktNadania<piwot.punktNadania) then
    begin
      x:=tabElem[i];
      tabElem[i]:=tabElem[j];
      tabElem[j]:=x;
      inc(j);
    end;
  tabElem[prawy]:=tabElem[j];
  tabElem[j]:=piwot;
  if(lewy < j - 1) then quickSortWyszukajNadano(tabElem,lewy,j-1);
  if(j+1 < prawy) then quickSortWyszukajNadano(tabElem,j+1,prawy);
end;

function wyszukajNadano(nr:integer):tabDane;
var
  freq,start,stop:Int64;
  i,miejsce,l,p,s:Integer;
  tabNadano:array[0..19] of string[48] = ('Białystok','Bydgoszcz','Choroszcz','Częstochowa','Gdańsk','Gdynia','Gniezno','Katowice','Kielce','Koszalin','Kraków','Lublin','Łódź','Mielno','Opole','Piła','Poznań','Szczecin','Warszawa','Wrocław');
  tabOdp,tabElem,tabPom:tabDane;
  czyZnaleziono:bool;
begin
  freq:=0;
  start:=0;
  stop:=0;
  miejsce:=0;
  SetLength(tabOdp,0);
  SetLength(tabElem,0);
  if(Form1.ComboBox6.ItemIndex = 0) then
  begin
    for i:=0 to (Length(tab)-1) do
    begin
      if not tab[i].czyUsuniety then
      begin
        SetLength(tabElem,Length(tabElem)+1);
        tabElem[Length(tabElem)-1]:=tab[i];
      end;
    end;
    QueryPerformanceFrequency(freq);
    QueryPerformanceCounter(start);
    quickSortWyszukajNadano(tabElem,0,Length(tabElem)-1);
    QueryPerformanceCounter(stop);
    ShowMessage('Sortowanie trwało: '+FloatToStr(1000*((stop-start)/freq))+' milisekund.');
    QueryPerformanceFrequency(freq);
    QueryPerformanceCounter(start);
    l:=0;
    p:=Length(tabElem)-1;
    czyZnaleziono:=false;
    while((l<=p) and (not czyZnaleziono)) do
    begin
      s:=(l+p) div 2;
      if(tabElem[s].punktNadania = tabNadano[nr]) then
      begin
        czyZnaleziono:=true;
      end else if(tabElem[s].punktNadania < tabNadano[nr]) then l:=s+1 else p:=s-1;
    end;

    if(czyZnaleziono) then
    begin
      { WYSZUKAJ PRZED WYSZUKANYM }
      i:=s;
      while(i > 0) do
      begin
        dec(i);
        if(tabElem[i].punktNadania = tabNadano[nr]) then
        begin
          SetLength(tabPom,(Length(tabPom)+1));
          tabPom[Length(tabPom)-1]:=tabElem[i];
        end else i:= -1;
      end;
      for i:=0 to (Length(tabPom)-1) do
      begin
        SetLength(tabOdp,(Length(tabOdp)+1));
        tabOdp[Length(tabOdp)-1]:=tabPom[i];
      end;
      { DODAJ WYSZUKANE }
      SetLength(tabOdp,(Length(tabOdp)+1));
      tabOdp[Length(tabOdp)-1]:=tabElem[s];
      { WYSZUKAJ PO WYSZUKANYM }
      i:=s;
      while(i < (Length(tabElem)-1)) do
      begin
        inc(i);
        if(tabElem[i].punktNadania = tabNadano[nr]) then
        begin
          SetLength(tabOdp,(Length(tabOdp)+1));
          tabOdp[Length(tabOdp)-1]:=tabElem[i];
        end else i:= Length(tabElem);
      end;
    end;
    QueryPerformanceCounter(stop);
    ShowMessage('Wyszukiwanie trwało: '+FloatToStr(1000*((stop-start)/freq))+' milisekund.');
  end;
  if(Form1.ComboBox6.ItemIndex = 1) then
  begin
    QueryPerformanceFrequency(freq);
    QueryPerformanceCounter(start);
    for i:=0 to (Length(tab)-1) do
    begin
      if((tab[i].punktNadania = tabNadano[nr]) and (not tab[i].czyUsuniety)) then
      begin
        SetLength(tabOdp,miejsce+1);
        tabOdp[miejsce]:=tab[i];
        inc(miejsce);
      end;
    end;
    QueryPerformanceCounter(stop);
    ShowMessage('Wyszukiwanie trwało: '+FloatToStr(1000*((stop-start)/freq))+' milisekund.');
  end;
  if(Form1.ComboBox6.ItemIndex = 2) then
  begin
    QueryPerformanceFrequency(freq);
    QueryPerformanceCounter(start);
    for i:=0 to (Length(tabPoczNadano)-1) do
    begin
      if(tabPoczNadano[i].punktNadania = tabNadano[nr]) then
      begin
        l:=tabPoczNadano[i].id;
        while(l <> -1) do
        begin
          SetLength(tabOdp,Length(tabOdp)+1);
          tabOdp[length(tabOdp)-1]:=tab[l];
          l:=tabLancuchow[l][0];
        end;
        break;
      end;
    end;
    QueryPerformanceCounter(stop);
    ShowMessage('Wyszukiwanie trwało: '+FloatToStr(1000*((stop-start)/freq))+' milisekund.');
  end;
  if(Form1.ComboBox6.ItemIndex = 3) then
  begin
    QueryPerformanceFrequency(freq);
    QueryPerformanceCounter(start);
    for i:=0 to (Length(tabPoczNadano)-1) do
    begin
      if(tabPoczNadano[i].punktNadania = tabNadano[nr]) then
      begin
        l:=tabPoczNadano[i].id;
        for p:=0 to (Length(tabLanInwersyjne[l])-1) do
        begin
          SetLength(tabOdp,Length(tabOdp)+1);
          tabOdp[length(tabOdp)-1]:=tab[tabLanInwersyjne[l][p]];
        end;
        break;
      end;
    end;
    QueryPerformanceCounter(stop);
    ShowMessage('Wyszukiwanie trwało: '+FloatToStr(1000*((stop-start)/freq))+' milisekund.');
  end;
  wyszukajNadano:=tabOdp;
end;

procedure quickSortWyszukajKodPrzes(var tabElem:tabDane;lewy,prawy:integer);
var
  i,j:Integer;
  x,piwot:tabDana;
begin
  i:=(lewy + prawy) div 2;
  piwot:=tabElem[i];
  tabElem[i]:=tabElem[prawy];
  j:=lewy;
  for i:=lewy to prawy-1 do
    if(tabElem[i].kodPrzesylki<piwot.kodPrzesylki) then
    begin
      x:=tabElem[i];
      tabElem[i]:=tabElem[j];
      tabElem[j]:=x;
      inc(j);
    end;
  tabElem[prawy]:=tabElem[j];
  tabElem[j]:=piwot;
  if(lewy < j - 1) then quickSortWyszukajKodPrzes(tabElem,lewy,j-1);
  if(j+1 < prawy) then quickSortWyszukajKodPrzes(tabElem,j+1,prawy);
end;

function wyszukajKodPrzes():tabDane;
var
  freq,start,stop:Int64;
  i,miejsce,l,p,s:Integer;
  tabOdp,tabElem,tabPom:tabDane;
  czyZnaleziono:bool;
begin
  freq:=0;
  start:=0;
  stop:=0;
  miejsce:=0;
  SetLength(tabOdp,0);
  SetLength(tabElem,0);
  if(Form1.ComboBox6.ItemIndex = 0) then
  begin
    for i:=0 to (Length(tab)-1) do
    begin
      if not tab[i].czyUsuniety then
      begin
        SetLength(tabElem,Length(tabElem)+1);
        tabElem[Length(tabElem)-1]:=tab[i];
      end;
    end;
    QueryPerformanceFrequency(freq);
    QueryPerformanceCounter(start);
    quickSortWyszukajKodPrzes(tabElem,0,Length(tabElem)-1);
    QueryPerformanceCounter(stop);
    ShowMessage('Sortowanie trwało: '+FloatToStr(1000*((stop-start)/freq))+' milisekund.');
    QueryPerformanceFrequency(freq);
    QueryPerformanceCounter(start);
    l:=0;
    p:=Length(tabElem)-1;
    czyZnaleziono:=false;
    while((l<=p) and (not czyZnaleziono)) do
    begin
      s:=(l+p) div 2;
      if(tabElem[s].kodPrzesylki = Form1.Edit7.Text) then
      begin
        czyZnaleziono:=true;
      end else if(tabElem[s].kodPrzesylki < Form1.Edit7.Text) then l:=s+1 else p:=s-1;
    end;

    if(czyZnaleziono) then
    begin
      { WYSZUKAJ PRZED WYSZUKANYM }
      i:=s;
      while(i > 0) do
      begin
        dec(i);
        if(tabElem[i].kodPrzesylki = Form1.Edit7.Text) then
        begin
          SetLength(tabPom,(Length(tabPom)+1));
          tabPom[Length(tabPom)-1]:=tabElem[i];
        end else i:= -1;
      end;
      for i:=0 to (Length(tabPom)-1) do
      begin
        SetLength(tabOdp,(Length(tabOdp)+1));
        tabOdp[Length(tabOdp)-1]:=tabPom[i];
      end;
      { DODAJ WYSZUKANE }
      SetLength(tabOdp,(Length(tabOdp)+1));
      tabOdp[Length(tabOdp)-1]:=tabElem[s];
      { WYSZUKAJ PO WYSZUKANYM }
      i:=s;
      while(i < (Length(tabElem)-1)) do
      begin
        inc(i);
        if(tabElem[i].kodPrzesylki = Form1.Edit7.Text) then
        begin
          SetLength(tabOdp,(Length(tabOdp)+1));
          tabOdp[Length(tabOdp)-1]:=tabElem[i];
        end else i:= Length(tabElem);
      end;
    end;
    QueryPerformanceCounter(stop);
    ShowMessage('Wyszukiwanie trwało: '+FloatToStr(1000*((stop-start)/freq))+' milisekund.');
  end;
  if(Form1.ComboBox6.ItemIndex = 1) then
  begin
    QueryPerformanceFrequency(freq);
    QueryPerformanceCounter(start);
    for i:=0 to (Length(tab)-1) do
    begin
      if((tab[i].kodPrzesylki = Form1.Edit7.Text) and (not tab[i].czyUsuniety)) then
      begin
        SetLength(tabOdp,miejsce+1);
        tabOdp[miejsce]:=tab[i];
        inc(miejsce);
      end;
    end;
    QueryPerformanceCounter(stop);
    ShowMessage('Wyszukiwanie trwało: '+FloatToStr(1000*((stop-start)/freq))+' milisekund.');
  end;
  if(Form1.ComboBox6.ItemIndex = 2) then
  begin
    QueryPerformanceFrequency(freq);
    QueryPerformanceCounter(start);
    for i:=0 to (Length(tabPoczKodPrzesylki)-1) do
    begin
      if(tabPoczKodPrzesylki[i].kodPrzesylki = Form1.Edit7.Text) then
      begin
        l:=tabPoczKodPrzesylki[i].id;
        while(l <> -1) do
        begin
          SetLength(tabOdp,Length(tabOdp)+1);
          tabOdp[length(tabOdp)-1]:=tab[l];
          l:=tabLancuchow[l][1];
        end;
        break;
      end;
    end;
    QueryPerformanceCounter(stop);
    ShowMessage('Wyszukiwanie trwało: '+FloatToStr(1000*((stop-start)/freq))+' milisekund.');
  end;
  if(Form1.ComboBox6.ItemIndex = 3) then
  begin
    QueryPerformanceFrequency(freq);
    QueryPerformanceCounter(start);
    for i:=0 to (Length(tabPoczKodPrzesylki)-1) do
    begin
      if(tabPoczKodPrzesylki[i].kodPrzesylki = Form1.Edit7.Text) then
      begin
        l:=tabPoczKodPrzesylki[i].id;
        for p:=0 to (Length(tabLanInwersyjne[l])-1) do
        begin
          SetLength(tabOdp,Length(tabOdp)+1);
          tabOdp[length(tabOdp)-1]:=tab[tabLanInwersyjne[l][p]];
        end;
        break;
      end;
    end;
    QueryPerformanceCounter(stop);
    ShowMessage('Wyszukiwanie trwało: '+FloatToStr(1000*((stop-start)/freq))+' milisekund.');
  end;
  wyszukajKodPrzes:=tabOdp;
end;

procedure quickSortWyszukajWaga(var tabElem:tabDane;lewy,prawy:integer);
var
  i,j:Integer;
  x,piwot:tabDana;
begin
  i:=(lewy + prawy) div 2;
  piwot:=tabElem[i];
  tabElem[i]:=tabElem[prawy];
  j:=lewy;
  for i:=lewy to prawy-1 do
    if(tabElem[i].waga<piwot.waga) then
    begin
      x:=tabElem[i];
      tabElem[i]:=tabElem[j];
      tabElem[j]:=x;
      inc(j);
    end;
  tabElem[prawy]:=tabElem[j];
  tabElem[j]:=piwot;
  if(lewy < j - 1) then quickSortWyszukajWaga(tabElem,lewy,j-1);
  if(j+1 < prawy) then quickSortWyszukajWaga(tabElem,j+1,prawy);
end;

function wyszukajWaga():tabDane;
var
  szukane:double;
  freq,start,stop:Int64;
  i,miejsce,l,p,s:Integer;
  tabOdp,tabElem,tabPom:tabDane;
  czyZnaleziono:bool;
begin
  freq:=0;
  start:=0;
  stop:=0;
  miejsce:=0;
  SetLength(tabOdp,0);
  szukane:=StrToFloat(Form1.FloatSpinEdit2.Text);
  SetLength(tabElem,0);
  if(Form1.ComboBox6.ItemIndex = 0) then
  begin
    for i:=0 to (Length(tab)-1) do
    begin
      if not tab[i].czyUsuniety then
      begin
        SetLength(tabElem,Length(tabElem)+1);
        tabElem[Length(tabElem)-1]:=tab[i];
      end;
    end;
    QueryPerformanceFrequency(freq);
    QueryPerformanceCounter(start);
    quickSortWyszukajWaga(tabElem,0,Length(tabElem)-1);
    QueryPerformanceCounter(stop);
    ShowMessage('Sortowanie trwało: '+FloatToStr(1000*((stop-start)/freq))+' milisekund.');
    QueryPerformanceFrequency(freq);
    QueryPerformanceCounter(start);
    l:=0;
    p:=Length(tabElem)-1;
    czyZnaleziono:=false;
    while((l<=p) and (not czyZnaleziono)) do
    begin
      s:=(l+p) div 2;
      if(tabElem[s].waga = szukane) then
      begin
        czyZnaleziono:=true;
      end else if(tabElem[s].waga < szukane) then l:=s+1 else p:=s-1;
    end;

    if(czyZnaleziono) then
    begin
      { WYSZUKAJ PRZED WYSZUKANYM }
      i:=s;
      while(i > 0) do
      begin
        dec(i);
        if(tabElem[i].waga = szukane) then
        begin
          SetLength(tabPom,(Length(tabPom)+1));
          tabPom[Length(tabPom)-1]:=tabElem[i];
        end else i:= -1;
      end;
      for i:=0 to (Length(tabPom)-1) do
      begin
        SetLength(tabOdp,(Length(tabOdp)+1));
        tabOdp[Length(tabOdp)-1]:=tabPom[i];
      end;
      { DODAJ WYSZUKANE }
      SetLength(tabOdp,(Length(tabOdp)+1));
      tabOdp[Length(tabOdp)-1]:=tabElem[s];
      { WYSZUKAJ PO WYSZUKANYM }
      i:=s;
      while(i < (Length(tabElem)-1)) do
      begin
        inc(i);
        if(tabElem[i].waga = szukane) then
        begin
          SetLength(tabOdp,(Length(tabOdp)+1));
          tabOdp[Length(tabOdp)-1]:=tabElem[i];
        end else i:= Length(tabElem);
      end;
    end;
    QueryPerformanceCounter(stop);
    ShowMessage('Wyszukiwanie trwało: '+FloatToStr(1000*((stop-start)/freq))+' milisekund.');
  end;
  if(Form1.ComboBox6.ItemIndex = 1) then
  begin
    QueryPerformanceFrequency(freq);
    QueryPerformanceCounter(start);
    for i:=0 to (Length(tab)-1) do
    begin
      if((tab[i].waga = szukane) and (not tab[i].czyUsuniety)) then
      begin
        SetLength(tabOdp,miejsce+1);
        tabOdp[miejsce]:=tab[i];
        inc(miejsce);
      end;
    end;
    QueryPerformanceCounter(stop);
    ShowMessage('Wyszukiwanie trwało: '+FloatToStr(1000*((stop-start)/freq))+' milisekund.');
  end;
  if(Form1.ComboBox6.ItemIndex = 2) then
  begin
    QueryPerformanceFrequency(freq);
    QueryPerformanceCounter(start);
    for i:=0 to (Length(tabPoczWaga)-1) do
    begin
      if(tabPoczWaga[i].waga = szukane) then
      begin
        l:=tabPoczWaga[i].id;
        while(l <> -1) do
        begin
          SetLength(tabOdp,Length(tabOdp)+1);
          tabOdp[length(tabOdp)-1]:=tab[l];
          l:=tabLancuchow[l][2];
        end;
        break;
      end;
    end;
    QueryPerformanceCounter(stop);
    ShowMessage('Wyszukiwanie trwało: '+FloatToStr(1000*((stop-start)/freq))+' milisekund.');
  end;
  if(Form1.ComboBox6.ItemIndex = 3) then
  begin
    QueryPerformanceFrequency(freq);
    QueryPerformanceCounter(start);
    for i:=0 to (Length(tabPoczWaga)-1) do
    begin
      if(tabPoczWaga[i].waga = szukane) then
      begin
        l:=tabPoczWaga[i].id;
        for p:=0 to (Length(tabLanInwersyjne[l])-1) do
        begin
          SetLength(tabOdp,Length(tabOdp)+1);
          tabOdp[length(tabOdp)-1]:=tab[tabLanInwersyjne[l][p]];
        end;
        break;
      end;
    end;
    QueryPerformanceCounter(stop);
    ShowMessage('Wyszukiwanie trwało: '+FloatToStr(1000*((stop-start)/freq))+' milisekund.');
  end;
  wyszukajWaga:=tabOdp;
end;

procedure quickSortWyszukajCena(var tabElem:tabDane;lewy,prawy:integer);
var
  i,j:Integer;
  x,piwot:tabDana;
begin
  i:=(lewy + prawy) div 2;
  piwot:=tabElem[i];
  tabElem[i]:=tabElem[prawy];
  j:=lewy;
  for i:=lewy to prawy-1 do
    if(tabElem[i].cena<piwot.cena) then
    begin
      x:=tabElem[i];
      tabElem[i]:=tabElem[j];
      tabElem[j]:=x;
      inc(j);
    end;
  tabElem[prawy]:=tabElem[j];
  tabElem[j]:=piwot;
  if(lewy < j - 1) then quickSortWyszukajCena(tabElem,lewy,j-1);
  if(j+1 < prawy) then quickSortWyszukajCena(tabElem,j+1,prawy);
end;

function wyszukajCena(nr:integer):tabDane;
var
  freq,start,stop:Int64;
  tabCena:array[0..9] of Byte = (10,15,20,25,30,35,40,45,50,55);
  i,miejsce,l,p,s:Integer;
  tabOdp,tabElem,tabPom:tabDane;
  czyZnaleziono:bool;
begin
  freq:=0;
  start:=0;
  stop:=0;
  miejsce:=0;
  SetLength(tabOdp,0);
  SetLength(tabElem,0);
  if(Form1.ComboBox6.ItemIndex = 0) then
  begin
    for i:=0 to (Length(tab)-1) do
    begin
      if not tab[i].czyUsuniety then
      begin
        SetLength(tabElem,Length(tabElem)+1);
        tabElem[Length(tabElem)-1]:=tab[i];
      end;
    end;
    QueryPerformanceFrequency(freq);
    QueryPerformanceCounter(start);
    quickSortWyszukajCena(tabElem,0,Length(tabElem)-1);
    QueryPerformanceCounter(stop);
    ShowMessage('Sortowanie trwało: '+FloatToStr(1000*((stop-start)/freq))+' milisekund.');
    QueryPerformanceFrequency(freq);
    QueryPerformanceCounter(start);
    l:=0;
    p:=Length(tabElem)-1;
    czyZnaleziono:=false;
    while((l<=p) and (not czyZnaleziono)) do
    begin
      s:=(l+p) div 2;
      if(tabElem[s].cena = tabCena[nr]) then
      begin
        czyZnaleziono:=true;
      end else if(tabElem[s].cena < tabCena[nr]) then l:=s+1 else p:=s-1;
    end;

    if(czyZnaleziono) then
    begin
      { WYSZUKAJ PRZED WYSZUKANYM }
      i:=s;
      while(i > 0) do
      begin
        dec(i);
        if(tabElem[i].cena = tabCena[nr]) then
        begin
          SetLength(tabPom,(Length(tabPom)+1));
          tabPom[Length(tabPom)-1]:=tabElem[i];
        end else i:= -1;
      end;
      for i:=0 to (Length(tabPom)-1) do
      begin
        SetLength(tabOdp,(Length(tabOdp)+1));
        tabOdp[Length(tabOdp)-1]:=tabPom[i];
      end;
      { DODAJ WYSZUKANE }
      SetLength(tabOdp,(Length(tabOdp)+1));
      tabOdp[Length(tabOdp)-1]:=tabElem[s];
      { WYSZUKAJ PO WYSZUKANYM }
      i:=s;
      while(i < (Length(tabElem)-1)) do
      begin
        inc(i);
        if(tabElem[i].cena = tabCena[nr]) then
        begin
          SetLength(tabOdp,(Length(tabOdp)+1));
          tabOdp[Length(tabOdp)-1]:=tabElem[i];
        end else i:= Length(tabElem);
      end;
    end;
    QueryPerformanceCounter(stop);
    ShowMessage('Wyszukiwanie trwało: '+FloatToStr(1000*((stop-start)/freq))+' milisekund.');
  end;
  if(Form1.ComboBox6.ItemIndex = 1) then
  begin
    QueryPerformanceFrequency(freq);
    QueryPerformanceCounter(start);
    for i:=0 to (Length(tab)-1) do
    begin
      if((tab[i].cena = tabCena[nr]) and (not tab[i].czyUsuniety)) then
      begin
        SetLength(tabOdp,miejsce+1);
        tabOdp[miejsce]:=tab[i];
        inc(miejsce);
      end;
    end;
    QueryPerformanceCounter(stop);
    ShowMessage('Wyszukiwanie trwało: '+FloatToStr(1000*((stop-start)/freq))+' milisekund.');
  end;
  if(Form1.ComboBox6.ItemIndex = 2) then
  begin
    QueryPerformanceFrequency(freq);
    QueryPerformanceCounter(start);
    for i:=0 to (Length(tabPoczCena)-1) do
    begin
      if(tabPoczCena[i].cena = tabCena[nr]) then
      begin
        l:=tabPoczCena[i].id;
        while(l <> -1) do
        begin
          SetLength(tabOdp,Length(tabOdp)+1);
          tabOdp[length(tabOdp)-1]:=tab[l];
          l:=tabLancuchow[l][3];
        end;
        break;
      end;
    end;
    QueryPerformanceCounter(stop);
    ShowMessage('Wyszukiwanie trwało: '+FloatToStr(1000*((stop-start)/freq))+' milisekund.');
  end;
  if(Form1.ComboBox6.ItemIndex = 3) then
  begin
    QueryPerformanceFrequency(freq);
    QueryPerformanceCounter(start);
    for i:=0 to (Length(tabPoczCena)-1) do
    begin
      if(tabPoczCena[i].cena = tabCena[nr]) then
      begin
        l:=tabPoczCena[i].id;
        for p:=0 to (Length(tabLanInwersyjne[l])-1) do
        begin
          SetLength(tabOdp,Length(tabOdp)+1);
          tabOdp[length(tabOdp)-1]:=tab[tabLanInwersyjne[l][p]];
        end;
        break;
      end;
    end;
    QueryPerformanceCounter(stop);
    ShowMessage('Wyszukiwanie trwało: '+FloatToStr(1000*((stop-start)/freq))+' milisekund.');
  end;
  wyszukajCena:=tabOdp;
end;

procedure quickSortWyszukajNrKuriera(var tabElem:tabDane;lewy,prawy:integer);
var
  i,j:Integer;
  x,piwot:tabDana;
begin
  i:=(lewy + prawy) div 2;
  piwot:=tabElem[i];
  tabElem[i]:=tabElem[prawy];
  j:=lewy;
  for i:=lewy to prawy-1 do
    if(tabElem[i].nrKuriera<piwot.nrKuriera) then
    begin
      x:=tabElem[i];
      tabElem[i]:=tabElem[j];
      tabElem[j]:=x;
      inc(j);
    end;
  tabElem[prawy]:=tabElem[j];
  tabElem[j]:=piwot;
  if(lewy < j - 1) then quickSortWyszukajNrKuriera(tabElem,lewy,j-1);
  if(j+1 < prawy) then quickSortWyszukajNrKuriera(tabElem,j+1,prawy);
end;

function wyszukajNrKuriera():tabDane;
var
  freq,start,stop:Int64;
  i,miejsce,l,p,s:Integer;
  tabOdp,tabElem,tabPom:tabDane;
  czyZnaleziono:bool;
  szukane:longint;
begin
  freq:=0;
  start:=0;
  stop:=0;
  miejsce:=0;
  SetLength(tabOdp,0);
  szukane:=StrToInt(Form1.SpinEdit6.Text);
  SetLength(tabElem,0);
  if(Form1.ComboBox6.ItemIndex = 0) then
  begin
    for i:=0 to (Length(tab)-1) do
    begin
      if not tab[i].czyUsuniety then
      begin
        SetLength(tabElem,Length(tabElem)+1);
        tabElem[Length(tabElem)-1]:=tab[i];
      end;
    end;
    QueryPerformanceFrequency(freq);
    QueryPerformanceCounter(start);
    quickSortWyszukajNrKuriera(tabElem,0,Length(tabElem)-1);
    QueryPerformanceCounter(stop);
    ShowMessage('Sortowanie trwało: '+FloatToStr(1000*((stop-start)/freq))+' milisekund.');
    QueryPerformanceFrequency(freq);
    QueryPerformanceCounter(start);
    l:=0;
    p:=Length(tabElem)-1;
    czyZnaleziono:=false;
    while((l<=p) and (not czyZnaleziono)) do
    begin
      s:=(l+p) div 2;
      if(tabElem[s].nrKuriera = szukane) then
      begin
        czyZnaleziono:=true;
      end else if(tabElem[s].nrKuriera < szukane) then l:=s+1 else p:=s-1;
    end;

    if(czyZnaleziono) then
    begin
      { WYSZUKAJ PRZED WYSZUKANYM }
      i:=s;
      while(i > 0) do
      begin
        dec(i);
        if(tabElem[i].nrKuriera = szukane) then
        begin
          SetLength(tabPom,(Length(tabPom)+1));
          tabPom[Length(tabPom)-1]:=tabElem[i];
        end else i:= -1;
      end;
      for i:=0 to (Length(tabPom)-1) do
      begin
        SetLength(tabOdp,(Length(tabOdp)+1));
        tabOdp[Length(tabOdp)-1]:=tabPom[i];
      end;
      { DODAJ WYSZUKANE }
      SetLength(tabOdp,(Length(tabOdp)+1));
      tabOdp[Length(tabOdp)-1]:=tabElem[s];
      { WYSZUKAJ PO WYSZUKANYM }
      i:=s;
      while(i < (Length(tabElem)-1)) do
      begin
        inc(i);
        if(tabElem[i].nrKuriera = szukane) then
        begin
          SetLength(tabOdp,(Length(tabOdp)+1));
          tabOdp[Length(tabOdp)-1]:=tabElem[i];
        end else i:= Length(tabElem);
      end;
    end;
    QueryPerformanceCounter(stop);
    ShowMessage('Wyszukiwanie trwało: '+FloatToStr(1000*((stop-start)/freq))+' milisekund.');
  end;
  if(Form1.ComboBox6.ItemIndex = 1) then
  begin
    QueryPerformanceFrequency(freq);
    QueryPerformanceCounter(start);
    for i:=0 to (Length(tab)-1) do
    begin
      if((tab[i].nrKuriera = szukane) and (not tab[i].czyUsuniety)) then
      begin
        SetLength(tabOdp,miejsce+1);
        tabOdp[miejsce]:=tab[i];
        inc(miejsce);
      end;
    end;
    QueryPerformanceCounter(stop);
    ShowMessage('Wyszukiwanie trwało: '+FloatToStr(1000*((stop-start)/freq))+' milisekund.');
  end;
  if(Form1.ComboBox6.ItemIndex = 2) then
  begin
    QueryPerformanceFrequency(freq);
    QueryPerformanceCounter(start);
    for i:=0 to (Length(tabPoczNrKuriera)-1) do
    begin
      if(tabPoczNrKuriera[i].nrKuriera = szukane) then
      begin
        l:=tabPoczNrKuriera[i].id;
        while(l <> -1) do
        begin
          SetLength(tabOdp,Length(tabOdp)+1);
          tabOdp[length(tabOdp)-1]:=tab[l];
          l:=tabLancuchow[l][4];
        end;
        break;
      end;
    end;
    QueryPerformanceCounter(stop);
    ShowMessage('Wyszukiwanie trwało: '+FloatToStr(1000*((stop-start)/freq))+' milisekund.');
  end;
  if(Form1.ComboBox6.ItemIndex = 3) then
  begin
    QueryPerformanceFrequency(freq);
    QueryPerformanceCounter(start);
    for i:=0 to (Length(tabPoczNrKuriera)-1) do
    begin
      if(tabPoczNrKuriera[i].nrKuriera = szukane) then
      begin
        l:=tabPoczNrKuriera[i].id;
        for p:=0 to (Length(tabLanInwersyjne[l])-1) do
        begin
          SetLength(tabOdp,Length(tabOdp)+1);
          tabOdp[length(tabOdp)-1]:=tab[tabLanInwersyjne[l][p]];
        end;
        break;
      end;
    end;
    QueryPerformanceCounter(stop);
    ShowMessage('Wyszukiwanie trwało: '+FloatToStr(1000*((stop-start)/freq))+' milisekund.');
  end;
  wyszukajNrKuriera:=tabOdp;
end;

procedure quickSortWyszukajCzyOplacona(var tabElem:tabDane;lewy,prawy:integer);
var
  i,j:Integer;
  x,piwot:tabDana;
begin
  i:=(lewy + prawy) div 2;
  piwot:=tabElem[i];
  tabElem[i]:=tabElem[prawy];
  j:=lewy;
  for i:=lewy to prawy-1 do
    if(tabElem[i].czyOplacona<piwot.czyOplacona) then
    begin
      x:=tabElem[i];
      tabElem[i]:=tabElem[j];
      tabElem[j]:=x;
      inc(j);
    end;
  tabElem[prawy]:=tabElem[j];
  tabElem[j]:=piwot;
  if(lewy < j - 1) then quickSortWyszukajCzyOplacona(tabElem,lewy,j-1);
  if(j+1 < prawy) then quickSortWyszukajCzyOplacona(tabElem,j+1,prawy);
end;

function wyszukajCzyOplacona():tabDane;
var
  freq,start,stop:Int64;
  i,miejsce,l,p,s:Integer;
  tabOdp,tabElem,tabPom:tabDane;
  czyZnaleziono,szukane:bool;
begin
  freq:=0;
  start:=0;
  stop:=0;
  miejsce:=0;
  SetLength(tabOdp,0);
  szukane:=Form1.CheckBox2.Checked;
  SetLength(tabElem,0);
  if(Form1.ComboBox6.ItemIndex = 0) then
  begin
    for i:=0 to (Length(tab)-1) do
    begin
      if not tab[i].czyUsuniety then
      begin
        SetLength(tabElem,Length(tabElem)+1);
        tabElem[Length(tabElem)-1]:=tab[i];
      end;
    end;
    QueryPerformanceFrequency(freq);
    QueryPerformanceCounter(start);
    quickSortWyszukajCzyOplacona(tabElem,0,Length(tabElem)-1);
    QueryPerformanceCounter(stop);
    ShowMessage('Sortowanie trwało: '+FloatToStr(1000*((stop-start)/freq))+' milisekund.');
    QueryPerformanceFrequency(freq);
    QueryPerformanceCounter(start);
    l:=0;
    p:=Length(tabElem)-1;
    czyZnaleziono:=false;
    while((l<=p) and (not czyZnaleziono)) do
    begin
      s:=(l+p) div 2;
      if(tabElem[s].czyOplacona = szukane) then
      begin
        czyZnaleziono:=true;
      end else if(tabElem[s].czyOplacona < szukane) then l:=s+1 else p:=s-1;
    end;

    if(czyZnaleziono) then
    begin
      { WYSZUKAJ PRZED WYSZUKANYM }
      i:=s;
      while(i > 0) do
      begin
        dec(i);
        if(tabElem[i].czyOplacona = szukane) then
        begin
          SetLength(tabPom,(Length(tabPom)+1));
          tabPom[Length(tabPom)-1]:=tabElem[i];
        end else i:= -1;
      end;
      for i:=0 to (Length(tabPom)-1) do
      begin
        SetLength(tabOdp,(Length(tabOdp)+1));
        tabOdp[Length(tabOdp)-1]:=tabPom[i];
      end;
      { DODAJ WYSZUKANE }
      SetLength(tabOdp,(Length(tabOdp)+1));
      tabOdp[Length(tabOdp)-1]:=tabElem[s];
      { WYSZUKAJ PO WYSZUKANYM }
      i:=s;
      while(i < (Length(tabElem)-1)) do
      begin
        inc(i);
        if(tabElem[i].czyOplacona = szukane) then
        begin
          SetLength(tabOdp,(Length(tabOdp)+1));
          tabOdp[Length(tabOdp)-1]:=tabElem[i];
        end else i:= Length(tabElem);
      end;
    end;
    QueryPerformanceCounter(stop);
    ShowMessage('Wyszukiwanie trwało: '+FloatToStr(1000*((stop-start)/freq))+' milisekund.');
  end;
  if(Form1.ComboBox6.ItemIndex = 1) then
  begin
    QueryPerformanceFrequency(freq);
    QueryPerformanceCounter(start);
    for i:=0 to (Length(tab)-1) do
    begin
      if((tab[i].czyOplacona = szukane) and (not tab[i].czyUsuniety)) then
      begin
        SetLength(tabOdp,miejsce+1);
        tabOdp[miejsce]:=tab[i];
        inc(miejsce);
      end;
    end;
    QueryPerformanceCounter(stop);
    ShowMessage('Wyszukiwanie trwało: '+FloatToStr(1000*((stop-start)/freq))+' milisekund.');
  end;
  if(Form1.ComboBox6.ItemIndex = 2) then
  begin
    QueryPerformanceFrequency(freq);
    QueryPerformanceCounter(start);
    for i:=0 to (Length(tabPoczCzyOplacona)-1) do
    begin
      if(tabPoczCzyOplacona[i].czyOplacona = szukane) then
      begin
        l:=tabPoczCzyOplacona[i].id;
        while(l <> -1) do
        begin
          SetLength(tabOdp,Length(tabOdp)+1);
          tabOdp[length(tabOdp)-1]:=tab[l];
          l:=tabLancuchow[l][5];
        end;
        break;
      end;
    end;
    QueryPerformanceCounter(stop);
    ShowMessage('Wyszukiwanie trwało: '+FloatToStr(1000*((stop-start)/freq))+' milisekund.');
  end;
  if(Form1.ComboBox6.ItemIndex = 3) then
  begin
    QueryPerformanceFrequency(freq);
    QueryPerformanceCounter(start);
    for i:=0 to (Length(tabPoczCzyOplacona)-1) do
    begin
      if(tabPoczCzyOplacona[i].czyOplacona = szukane) then
      begin
        l:=tabPoczCzyOplacona[i].id;
        for p:=0 to (Length(tabLanInwersyjne[l])-1) do
        begin
          SetLength(tabOdp,Length(tabOdp)+1);
          tabOdp[length(tabOdp)-1]:=tab[tabLanInwersyjne[l][p]];
        end;
        break;
      end;
    end;
    QueryPerformanceCounter(stop);
    ShowMessage('Wyszukiwanie trwało: '+FloatToStr(1000*((stop-start)/freq))+' milisekund.');
  end;
  wyszukajCzyOplacona:=tabOdp;
end;

procedure quickSortWyszukajNrNadawcy(var tabElem:tabDane;lewy,prawy:integer);
var
  i,j:Integer;
  x,piwot:tabDana;
begin
  i:=(lewy + prawy) div 2;
  piwot:=tabElem[i];
  tabElem[i]:=tabElem[prawy];
  j:=lewy;
  for i:=lewy to prawy-1 do
    if(tabElem[i].nrNadawcy<piwot.nrNadawcy) then
    begin
      x:=tabElem[i];
      tabElem[i]:=tabElem[j];
      tabElem[j]:=x;
      inc(j);
    end;
  tabElem[prawy]:=tabElem[j];
  tabElem[j]:=piwot;
  if(lewy < j - 1) then quickSortWyszukajNrNadawcy(tabElem,lewy,j-1);
  if(j+1 < prawy) then quickSortWyszukajNrNadawcy(tabElem,j+1,prawy);
end;

function wyszukajNrNadawcy():tabDane;
var
  freq,start,stop:Int64;
  i,miejsce,l,p,s:Integer;
  tabOdp,tabElem,tabPom:tabDane;
  czyZnaleziono:bool;
  szukane:longint;
begin
  freq:=0;
  start:=0;
  stop:=0;
  miejsce:=0;
  SetLength(tabOdp,0);
  szukane:=StrToInt(Form1.SpinEdit5.Text);
  SetLength(tabElem,0);
  if(Form1.ComboBox6.ItemIndex = 0) then
  begin
    for i:=0 to (Length(tab)-1) do
    begin
      if not tab[i].czyUsuniety then
      begin
        SetLength(tabElem,Length(tabElem)+1);
        tabElem[Length(tabElem)-1]:=tab[i];
      end;
    end;
    QueryPerformanceFrequency(freq);
    QueryPerformanceCounter(start);
    quickSortWyszukajNrNadawcy(tabElem,0,Length(tabElem)-1);
    QueryPerformanceCounter(stop);
    ShowMessage('Sortowanie trwało: '+FloatToStr(1000*((stop-start)/freq))+' milisekund.');
    QueryPerformanceFrequency(freq);
    QueryPerformanceCounter(start);
    l:=0;
    p:=Length(tabElem)-1;
    czyZnaleziono:=false;
    while((l<=p) and (not czyZnaleziono)) do
    begin
      s:=(l+p) div 2;
      if(tabElem[s].nrNadawcy = szukane) then
      begin
        czyZnaleziono:=true;
      end else if(tabElem[s].nrNadawcy < szukane) then l:=s+1 else p:=s-1;
    end;

    if(czyZnaleziono) then
    begin
      { WYSZUKAJ PRZED WYSZUKANYM }
      i:=s;
      while(i > 0) do
      begin
        dec(i);
        if(tabElem[i].nrNadawcy = szukane) then
        begin
          SetLength(tabPom,(Length(tabPom)+1));
          tabPom[Length(tabPom)-1]:=tabElem[i];
        end else i:= -1;
      end;
      for i:=0 to (Length(tabPom)-1) do
      begin
        SetLength(tabOdp,(Length(tabOdp)+1));
        tabOdp[Length(tabOdp)-1]:=tabPom[i];
      end;
      { DODAJ WYSZUKANE }
      SetLength(tabOdp,(Length(tabOdp)+1));
      tabOdp[Length(tabOdp)-1]:=tabElem[s];
      { WYSZUKAJ PO WYSZUKANYM }
      i:=s;
      while(i < (Length(tabElem)-1)) do
      begin
        inc(i);
        if(tabElem[i].nrNadawcy = szukane) then
        begin
          SetLength(tabOdp,(Length(tabOdp)+1));
          tabOdp[Length(tabOdp)-1]:=tabElem[i];
        end else i:= Length(tabElem);
      end;
    end;
    QueryPerformanceCounter(stop);
    ShowMessage('Wyszukiwanie trwało: '+FloatToStr(1000*((stop-start)/freq))+' milisekund.');
  end;
  if(Form1.ComboBox6.ItemIndex = 1) then
  begin
    QueryPerformanceFrequency(freq);
    QueryPerformanceCounter(start);
    for i:=0 to (Length(tab)-1) do
    begin
      if((tab[i].nrNadawcy = szukane) and (not tab[i].czyUsuniety)) then
      begin
        SetLength(tabOdp,miejsce+1);
        tabOdp[miejsce]:=tab[i];
        inc(miejsce);
      end;
    end;
    QueryPerformanceCounter(stop);
    ShowMessage('Wyszukiwanie trwało: '+FloatToStr(1000*((stop-start)/freq))+' milisekund.');
  end;
  if(Form1.ComboBox6.ItemIndex = 2) then
  begin
    QueryPerformanceFrequency(freq);
    QueryPerformanceCounter(start);
    for i:=0 to (Length(tabPoczNrNadawcy)-1) do
    begin
      if(tabPoczNrNadawcy[i].nrNadawcy = szukane) then
      begin
        l:=tabPoczNrNadawcy[i].id;
        while(l <> -1) do
        begin
          SetLength(tabOdp,Length(tabOdp)+1);
          tabOdp[length(tabOdp)-1]:=tab[l];
          l:=tabLancuchow[l][6];
        end;
        break;
      end;
    end;
    QueryPerformanceCounter(stop);
    ShowMessage('Wyszukiwanie trwało: '+FloatToStr(1000*((stop-start)/freq))+' milisekund.');
  end;
  if(Form1.ComboBox6.ItemIndex = 3) then
  begin
    QueryPerformanceFrequency(freq);
    QueryPerformanceCounter(start);
    for i:=0 to (Length(tabPoczNrNadawcy)-1) do
    begin
      if(tabPoczNrNadawcy[i].nrNadawcy = szukane) then
      begin
        l:=tabPoczNrNadawcy[i].id;
        for p:=0 to (Length(tabLanInwersyjne[l])-1) do
        begin
          SetLength(tabOdp,Length(tabOdp)+1);
          tabOdp[length(tabOdp)-1]:=tab[tabLanInwersyjne[l][p]];
        end;
        break;
      end;
    end;
    QueryPerformanceCounter(stop);
    ShowMessage('Wyszukiwanie trwało: '+FloatToStr(1000*((stop-start)/freq))+' milisekund.');
  end;
  wyszukajNrNadawcy:=tabOdp;
end;

procedure quickSortWyszukajAdres(var tabElem:tabDane;lewy,prawy:integer);
var
  i,j:Integer;
  x,piwot:tabDana;
begin
  i:=(lewy + prawy) div 2;
  piwot:=tabElem[i];
  tabElem[i]:=tabElem[prawy];
  j:=lewy;
  for i:=lewy to prawy-1 do
    if(tabElem[i].adres<piwot.adres) then
    begin
      x:=tabElem[i];
      tabElem[i]:=tabElem[j];
      tabElem[j]:=x;
      inc(j);
    end;
  tabElem[prawy]:=tabElem[j];
  tabElem[j]:=piwot;
  if(lewy < j - 1) then quickSortWyszukajAdres(tabElem,lewy,j-1);
  if(j+1 < prawy) then quickSortWyszukajAdres(tabElem,j+1,prawy);
end;

function wyszukajAdres():tabDane;
var
  freq,start,stop:Int64;
  i,miejsce,l,p,s:Integer;
  tabOdp,tabElem,tabPom:tabDane;
  czyZnaleziono:bool;
begin
  freq:=0;
  start:=0;
  stop:=0;
  miejsce:=0;
  SetLength(tabOdp,0);
  SetLength(tabElem,0);
  if(Form1.ComboBox6.ItemIndex = 0) then
  begin
    for i:=0 to (Length(tab)-1) do
    begin
      if not tab[i].czyUsuniety then
      begin
        SetLength(tabElem,Length(tabElem)+1);
        tabElem[Length(tabElem)-1]:=tab[i];
      end;
    end;
    QueryPerformanceFrequency(freq);
    QueryPerformanceCounter(start);
    quickSortWyszukajAdres(tabElem,0,Length(tabElem)-1);
    QueryPerformanceCounter(stop);
    ShowMessage('Sortowanie trwało: '+FloatToStr(1000*((stop-start)/freq))+' milisekund.');
    QueryPerformanceFrequency(freq);
    QueryPerformanceCounter(start);
    l:=0;
    p:=Length(tabElem)-1;
    czyZnaleziono:=false;
    while((l<=p) and (not czyZnaleziono)) do
    begin
      s:=(l+p) div 2;
      if(tabElem[s].adres = Form1.Edit6.Text) then
      begin
        czyZnaleziono:=true;
      end else if(tabElem[s].adres < Form1.Edit6.Text) then l:=s+1 else p:=s-1;
    end;

    if(czyZnaleziono) then
    begin
      { WYSZUKAJ PRZED WYSZUKANYM }
      i:=s;
      while(i > 0) do
      begin
        dec(i);
        if(tabElem[i].adres = Form1.Edit6.Text) then
        begin
          SetLength(tabPom,(Length(tabPom)+1));
          tabPom[Length(tabPom)-1]:=tabElem[i];
        end else i:= -1;
      end;
      for i:=0 to (Length(tabPom)-1) do
      begin
        SetLength(tabOdp,(Length(tabOdp)+1));
        tabOdp[Length(tabOdp)-1]:=tabPom[i];
      end;
      { DODAJ WYSZUKANE }
      SetLength(tabOdp,(Length(tabOdp)+1));
      tabOdp[Length(tabOdp)-1]:=tabElem[s];
      { WYSZUKAJ PO WYSZUKANYM }
      i:=s;
      while(i < (Length(tabElem)-1)) do
      begin
        inc(i);
        if(tabElem[i].adres = Form1.Edit6.Text) then
        begin
          SetLength(tabOdp,(Length(tabOdp)+1));
          tabOdp[Length(tabOdp)-1]:=tabElem[i];
        end else i:= Length(tabElem);
      end;
    end;
    QueryPerformanceCounter(stop);
    ShowMessage('Wyszukiwanie trwało: '+FloatToStr(1000*((stop-start)/freq))+' milisekund.');
  end;
  if(Form1.ComboBox6.ItemIndex = 1) then
  begin
    QueryPerformanceFrequency(freq);
    QueryPerformanceCounter(start);
    for i:=0 to (Length(tab)-1) do
    begin
      if((tab[i].adres = Form1.Edit6.Text) and (not tab[i].czyUsuniety)) then
      begin
        SetLength(tabOdp,miejsce+1);
        tabOdp[miejsce]:=tab[i];
        inc(miejsce);
      end;
    end;
    QueryPerformanceCounter(stop);
    ShowMessage('Wyszukiwanie trwało: '+FloatToStr(1000*((stop-start)/freq))+' milisekund.');
  end;
  if(Form1.ComboBox6.ItemIndex = 2) then
  begin
    QueryPerformanceFrequency(freq);
    QueryPerformanceCounter(start);
    for i:=0 to (Length(tabPoczAdres)-1) do
    begin
      if(tabPoczAdres[i].adres = Form1.Edit6.Text) then
      begin
        l:=tabPoczAdres[i].id;
        while(l <> -1) do
        begin
          SetLength(tabOdp,Length(tabOdp)+1);
          tabOdp[length(tabOdp)-1]:=tab[l];
          l:=tabLancuchow[l][7];
        end;
        break;
      end;
    end;
    QueryPerformanceCounter(stop);
    ShowMessage('Wyszukiwanie trwało: '+FloatToStr(1000*((stop-start)/freq))+' milisekund.');
  end;
  if(Form1.ComboBox6.ItemIndex = 3) then
  begin
    QueryPerformanceFrequency(freq);
    QueryPerformanceCounter(start);
    for i:=0 to (Length(tabPoczAdres)-1) do
    begin
      if(tabPoczAdres[i].adres = Form1.Edit6.Text) then
      begin
        l:=tabPoczAdres[i].id;
        for p:=0 to (Length(tabLanInwersyjne[l])-1) do
        begin
          SetLength(tabOdp,Length(tabOdp)+1);
          tabOdp[length(tabOdp)-1]:=tab[tabLanInwersyjne[l][p]];
        end;
        break;
      end;
    end;
    QueryPerformanceCounter(stop);
    ShowMessage('Wyszukiwanie trwało: '+FloatToStr(1000*((stop-start)/freq))+' milisekund.');
  end;
  wyszukajAdres:=tabOdp;
end;

procedure quickSortWyszukajKodPocz(var tabElem:tabDane;lewy,prawy:integer);
var
  i,j:Integer;
  x,piwot:tabDana;
begin
  i:=(lewy + prawy) div 2;
  piwot:=tabElem[i];
  tabElem[i]:=tabElem[prawy];
  j:=lewy;
  for i:=lewy to prawy-1 do
    if(tabElem[i].kodPocztowy<piwot.kodPocztowy) then
    begin
      x:=tabElem[i];
      tabElem[i]:=tabElem[j];
      tabElem[j]:=x;
      inc(j);
    end;
  tabElem[prawy]:=tabElem[j];
  tabElem[j]:=piwot;
  if(lewy < j - 1) then quickSortWyszukajKodPocz(tabElem,lewy,j-1);
  if(j+1 < prawy) then quickSortWyszukajKodPocz(tabElem,j+1,prawy);
end;

function wyszukajKodPocz():tabDane;
var
  freq,start,stop:Int64;
  i,miejsce,l,p,s:Integer;
  tabOdp,tabElem,tabPom:tabDane;
  czyZnaleziono:bool;
begin
  freq:=0;
  start:=0;
  stop:=0;
  miejsce:=0;
  SetLength(tabOdp,0);
  SetLength(tabElem,0);
  if(Form1.ComboBox6.ItemIndex = 0) then
  begin
    for i:=0 to (Length(tab)-1) do
    begin
      if not tab[i].czyUsuniety then
      begin
        SetLength(tabElem,Length(tabElem)+1);
        tabElem[Length(tabElem)-1]:=tab[i];
      end;
    end;
    QueryPerformanceFrequency(freq);
    QueryPerformanceCounter(start);
    quickSortWyszukajKodPocz(tabElem,0,Length(tabElem)-1);
    QueryPerformanceCounter(stop);
    ShowMessage('Sortowanie trwało: '+FloatToStr(1000*((stop-start)/freq))+' milisekund.');
    QueryPerformanceFrequency(freq);
    QueryPerformanceCounter(start);
    l:=0;
    p:=Length(tabElem)-1;
    czyZnaleziono:=false;
    while((l<=p) and (not czyZnaleziono)) do
    begin
      s:=(l+p) div 2;
      if(tabElem[s].kodPocztowy = Form1.Edit5.Text) then
      begin
        czyZnaleziono:=true;
      end else if(tabElem[s].kodPocztowy < Form1.Edit5.Text) then l:=s+1 else p:=s-1;
    end;

    if(czyZnaleziono) then
    begin
      { WYSZUKAJ PRZED WYSZUKANYM }
      i:=s;
      while(i > 0) do
      begin
        dec(i);
        if(tabElem[i].kodPocztowy = Form1.Edit5.Text) then
        begin
          SetLength(tabPom,(Length(tabPom)+1));
          tabPom[Length(tabPom)-1]:=tabElem[i];
        end else i:= -1;
      end;
      for i:=0 to (Length(tabPom)-1) do
      begin
        SetLength(tabOdp,(Length(tabOdp)+1));
        tabOdp[Length(tabOdp)-1]:=tabPom[i];
      end;
      { DODAJ WYSZUKANE }
      SetLength(tabOdp,(Length(tabOdp)+1));
      tabOdp[Length(tabOdp)-1]:=tabElem[s];
      { WYSZUKAJ PO WYSZUKANYM }
      i:=s;
      while(i < (Length(tabElem)-1)) do
      begin
        inc(i);
        if(tabElem[i].kodPocztowy = Form1.Edit5.Text) then
        begin
          SetLength(tabOdp,(Length(tabOdp)+1));
          tabOdp[Length(tabOdp)-1]:=tabElem[i];
        end else i:= Length(tabElem);
      end;
    end;
    QueryPerformanceCounter(stop);
    ShowMessage('Wyszukiwanie trwało: '+FloatToStr(1000*((stop-start)/freq))+' milisekund.');
  end;
  if(Form1.ComboBox6.ItemIndex = 1) then
  begin
    QueryPerformanceFrequency(freq);
    QueryPerformanceCounter(start);
    for i:=0 to (Length(tab)-1) do
    begin
      if((tab[i].kodPocztowy = Form1.Edit5.Text) and (not tab[i].czyUsuniety)) then
      begin
        SetLength(tabOdp,miejsce+1);
        tabOdp[miejsce]:=tab[i];
        inc(miejsce);
      end;
    end;
    QueryPerformanceCounter(stop);
    ShowMessage('Wyszukiwanie trwało: '+FloatToStr(1000*((stop-start)/freq))+' milisekund.');
  end;
  if(Form1.ComboBox6.ItemIndex = 2) then
  begin
    QueryPerformanceFrequency(freq);
    QueryPerformanceCounter(start);
    for i:=0 to (Length(tabPoczKodPocztowy)-1) do
    begin
      if(tabPoczKodPocztowy[i].kodPocztowy = Form1.Edit5.Text) then
      begin
        l:=tabPoczKodPocztowy[i].id;
        while(l <> -1) do
        begin
          SetLength(tabOdp,Length(tabOdp)+1);
          tabOdp[length(tabOdp)-1]:=tab[l];
          l:=tabLancuchow[l][8];
        end;
        break;
      end;
    end;
    QueryPerformanceCounter(stop);
    ShowMessage('Wyszukiwanie trwało: '+FloatToStr(1000*((stop-start)/freq))+' milisekund.');
  end;
  if(Form1.ComboBox6.ItemIndex = 3) then
  begin
    QueryPerformanceFrequency(freq);
    QueryPerformanceCounter(start);
    for i:=0 to (Length(tabPoczKodPocztowy)-1) do
    begin
      if(tabPoczKodPocztowy[i].kodPocztowy = Form1.Edit5.Text) then
      begin
        l:=tabPoczKodPocztowy[i].id;
        for p:=0 to (Length(tabLanInwersyjne[l])-1) do
        begin
          SetLength(tabOdp,Length(tabOdp)+1);
          tabOdp[length(tabOdp)-1]:=tab[tabLanInwersyjne[l][p]];
        end;
        break;
      end;
    end;
    QueryPerformanceCounter(stop);
    ShowMessage('Wyszukiwanie trwało: '+FloatToStr(1000*((stop-start)/freq))+' milisekund.');
  end;
  wyszukajKodPocz:=tabOdp;
end;

procedure TForm1.Button7Click(Sender: TObject);
var
  nr,i,ilosc:integer;
  tabOdp:tabDane;
  regexp:TRegExpr;
begin
  nr:=ComboBox3.ItemIndex;
  SetLength(tabOdp,0);

  if(nr >= 0) then
  begin
    if(nr = 0) then
    begin
      if(ComboBox4.ItemIndex >= 0) then tabOdp:=wyszukajNadano(ComboBox4.ItemIndex);
    end else
    begin
      if(nr = 1) then
      begin
        regexp:=TRegExpr.Create;
        regexp.Expression:='^[a-zA-Z0-9]{20}$';
        if regexp.Exec(Edit7.Text) then
        begin
          tabOdp:=wyszukajKodPrzes();
        end else ShowMessage('Kod przesyłki może składać się tylko ze znaków: a-zA-Z0-9 i długość musi wynosić 20 znaków.');
        regexp.Free;
      end else
      begin
        if(nr = 2) then
        begin
          if(StrToFloat(FloatSpinEdit2.Text) >= 0.1) then
          begin
            tabOdp:=wyszukajWaga();
          end else ShowMessage('Waga musi wynosić przynajmniej 0.1kg');
        end else
        begin
          if(nr = 3) then
          begin
            if(ComboBox5.ItemIndex >= 0) then tabOdp:=wyszukajCena(ComboBox5.ItemIndex);
          end else
          begin
            if(nr = 4) then
            begin
              if(StrToInt(SpinEdit6.Text) >= 1) then tabOdp:=wyszukajNrKuriera();
            end else
            begin
              if(nr = 5) then
              begin
                tabOdp:=wyszukajCzyOplacona();
              end else
              begin
                if(nr = 6) then
                begin
                  if(StrToInt(SpinEdit5.Text) >= 1) then tabOdp:=wyszukajNrNadawcy();
                end else
                begin
                  if(nr = 7) then
                  begin
                    regexp:=TRegExpr.Create;
                    regexp.Expression:='^ul. [A-Z][a-z0-9]{2,10} [0-9]{1,2}[a-z]?(\\[0-9]{1,2})?, [A-Z][a-z0-9]{2,10}$';
                    if regexp.Exec(Edit6.Text) then
                    begin
                      tabOdp:=wyszukajAdres();
                    end else ShowMessage('Adres powinien wyglądać następująco:'+sLineBreak+'ul. <ulica> <nr domu>, <miejscowość>'+sLineBreak+'lub'+sLineBreak+'ul. <ulica> <nr budynku>\<nr lokalu>, <miejscowość>');
                    regexp.Free;
                  end else
                  begin
                    if(nr = 8) then
                    begin
                      regexp:=TRegExpr.Create;
                      regexp.Expression:='^[0-9]{2}-[0-9]{3}$';
                      if regexp.Exec(Edit5.Text) then
                      begin
                        tabOdp:=wyszukajKodPocz();
                      end else ShowMessage('Podaj prawidłowy kod pocztowy!');
                      regexp.Free;
                    end;
                  end;
                end;
              end;
            end;
          end;
        end;
      end;
    end;
  end;
  StringGrid1.RowCount:=1;//.clean
  StringGrid1.RowCount:=Length(tabOdp)+1;
  ilosc:=0;
  for i:=0 to (Length(tabOdp)-1) do
  begin
    inc(ilosc);
    StringGrid1.Cells[0,ilosc]:=IntToStr(tabOdp[i].id+1);
    StringGrid1.Cells[1,ilosc]:=tabOdp[i].punktNadania;
    StringGrid1.Cells[2,ilosc]:=tabOdp[i].kodPrzesylki;
    StringGrid1.Cells[3,ilosc]:=FloatToStrF(tabOdp[i].waga,ffFixed,8,2);
    StringGrid1.Cells[4,ilosc]:=IntToStr(tabOdp[i].cena);
    StringGrid1.Cells[5,ilosc]:=IntToStr(tabOdp[i].nrKuriera);
    if(tabOdp[i].czyOplacona) then StringGrid1.Cells[6,ilosc]:='TAK' else StringGrid1.Cells[6,ilosc]:='NIE';
    StringGrid1.Cells[7,ilosc]:=IntToStr(tabOdp[i].nrNadawcy);
    StringGrid1.Cells[8,ilosc]:=tabOdp[i].adres;
    StringGrid1.Cells[9,ilosc]:=tabOdp[i].kodPocztowy;
  end;
end;

procedure wyzerujWartosciWyszukaj();
begin
  Form1.ComboBox4.ItemIndex:=-1;
  Form1.ComboBox4.Text:='Wybierz...';
  Form1.Edit7.Text:='';
  Form1.FloatSpinEdit2.Text:='0,00';
  Form1.ComboBox5.ItemIndex:=-1;
  Form1.ComboBox5.Text:='Wybierz...';
  Form1.SpinEdit5.Text:='0';
  Form1.CheckBox2.Checked:=false;
  Form1.SpinEdit6.Text:='0';
  Form1.Edit6.Text:='';
  Form1.Edit5.Text:='';

  Form1.ComboBox4.Enabled:=false;
  Form1.Label26.Enabled:=false;
  Form1.Edit7.Enabled:=false;
  Form1.Label25.Enabled:=false;
  Form1.FloatSpinEdit2.Enabled:=false;
  Form1.Label24.Enabled:=false;
  Form1.ComboBox5.Enabled:=false;
  Form1.Label23.Enabled:=false;
  Form1.SpinEdit6.Enabled:=false;
  Form1.Label22.Enabled:=false;
  Form1.CheckBox2.Enabled:=false;
  Form1.SpinEdit5.Enabled:=false;
  Form1.Label21.Enabled:=false;
  Form1.Edit6.Enabled:=false;
  Form1.Label20.Enabled:=false;
  Form1.Edit5.Enabled:=false;
  Form1.Label19.Enabled:=false;
end;

procedure TForm1.ComboBox3Change(Sender: TObject);
var
  nr:integer;
begin
  wyzerujWartosciWyszukaj();

  nr:=ComboBox3.ItemIndex;
  if(nr >= 0) then
  begin
    Button7.Enabled:=true;

    if(nr = 0) then
    begin
      ComboBox4.Enabled:=true;
      Label26.Enabled:=true;
    end else
    begin
      if(nr = 1) then
      begin
        Edit7.Enabled:=true;
        Label25.Enabled:=true;
      end else
      begin
        if(nr = 2) then
        begin
          FloatSpinEdit2.Enabled:=true;
          Label24.Enabled:=true;
        end else
        begin
          if(nr = 3) then
          begin
            ComboBox5.Enabled:=true;
            Label23.Enabled:=true;
          end else
          begin
            if(nr = 4) then
            begin
              SpinEdit6.Enabled:=true;
              Label22.Enabled:=true;
            end else
            begin
              if(nr = 5) then
              begin
                CheckBox2.Enabled:=true;
              end else
              begin
                if(nr = 6) then
                begin
                  SpinEdit5.Enabled:=true;
                  Label21.Enabled:=true;
                end else
                begin
                  if(nr = 7) then
                  begin
                    Edit6.Enabled:=true;
                    Label20.Enabled:=true;
                  end else
                  begin
                    if(nr = 8) then
                    begin
                      Edit5.Enabled:=true;
                      Label19.Enabled:=true;
                    end;
                  end;
                end;
              end;
            end;
          end;
        end;
      end;
    end;
  end;
end;

procedure metodaInwersyjnaPrepare();
var
  i,j,k,nr:integer; //ilosc
  czyWystepuje,wstawiono:boolean;
  freq,start,stop:Int64;
begin
  freq:=0;
  start:=0;
  stop:=0;
  SetLength(tabPoczNadano,0);
  SetLength(tabPoczKodPrzesylki,0);
  SetLength(tabPoczWaga,0);
  SetLength(tabPoczCena,0);
  SetLength(tabPoczNrKuriera,0);
  SetLength(tabPoczCzyOplacona,0);
  SetLength(tabPoczNrNadawcy,0);
  SetLength(tabPoczAdres,0);
  SetLength(tabPoczKodPocztowy,0);
  SetLength(tabLancuchow,0);
  SetLength(tabLanInwersyjne,0);
  nr := 0;

  QueryPerformanceFrequency(freq);
  QueryPerformanceCounter(start);
  for i:=0 to (Length(tab)-1) do
  begin
    if tab[i].czyUsuniety then continue;

    czyWystepuje := false;
    for j:=0 to (Length(tabPoczNadano)-1) do
    begin
      if(tabPoczNadano[j].punktNadania=tab[i].punktNadania) then czyWystepuje:=true;
    end;
    if not czyWystepuje then
    begin
      SetLength(tabPoczNadano,Length(tabPoczNadano)+1);
      wstawiono:=false;
      for j:=0 to (Length(tabPoczNadano)-2) do
      begin
        if(tab[i].punktNadania < tabPoczNadano[j].punktNadania) then
        begin
          wstawiono := true;
          for k:=(Length(tabPoczNadano)-1) downto (j+1) do
          begin
            tabPoczNadano[k]:=tabPoczNadano[k-1];
          end;
          tabPoczNadano[j].punktNadania:=tab[i].punktNadania;
          tabPoczNadano[j].id:=nr;
          break;
        end;
      end;
      if not wstawiono then
      begin
        tabPoczNadano[Length(tabPoczNadano)-1].punktNadania:=tab[i].punktNadania;
        tabPoczNadano[Length(tabPoczNadano)-1].id:=nr;
      end;
      inc(nr);
      SetLength(tabLanInwersyjne,nr);
    end;

    czyWystepuje := false;
    for j:=0 to (Length(tabPoczKodPrzesylki)-1) do
    begin
      if(tabPoczKodPrzesylki[j].kodPrzesylki=tab[i].kodPrzesylki) then czyWystepuje:=true;
    end;
    if not czyWystepuje then
    begin
      SetLength(tabPoczKodPrzesylki,Length(tabPoczKodPrzesylki)+1);
      wstawiono:=false;
      for j:=0 to (Length(tabPoczKodPrzesylki)-2) do
      begin
        if(tab[i].kodPrzesylki < tabPoczKodPrzesylki[j].kodPrzesylki) then
        begin
          wstawiono := true;
          for k:=(Length(tabPoczKodPrzesylki)-1) downto (j+1) do
          begin
            tabPoczKodPrzesylki[k]:=tabPoczKodPrzesylki[k-1];
          end;
          tabPoczKodPrzesylki[j].kodPrzesylki:=tab[i].kodPrzesylki;
          tabPoczKodPrzesylki[j].id:=nr;
          break;
        end;
      end;
      if not wstawiono then
      begin
        tabPoczKodPrzesylki[Length(tabPoczKodPrzesylki)-1].kodPrzesylki:=tab[i].kodPrzesylki;
        tabPoczKodPrzesylki[Length(tabPoczKodPrzesylki)-1].id:=nr;
      end;
      inc(nr);
      SetLength(tabLanInwersyjne,nr);
    end;

    czyWystepuje := false;
    for j:=0 to (Length(tabPoczWaga)-1) do
    begin
      if(tabPoczWaga[j].waga=tab[i].waga) then czyWystepuje:=true;
    end;
    if not czyWystepuje then
    begin
      SetLength(tabPoczWaga,Length(tabPoczWaga)+1);
      wstawiono:=false;
      for j:=0 to (Length(tabPoczWaga)-2) do
      begin
        if(tab[i].waga < tabPoczWaga[j].waga) then
        begin
          wstawiono := true;
          for k:=(Length(tabPoczWaga)-1) downto (j+1) do
          begin
            tabPoczWaga[k]:=tabPoczWaga[k-1];
          end;
          tabPoczWaga[j].waga:=tab[i].waga;
          tabPoczWaga[j].id:=nr;
          break;
        end;
      end;
      if not wstawiono then
      begin
        tabPoczWaga[Length(tabPoczWaga)-1].waga:=tab[i].waga;
        tabPoczWaga[Length(tabPoczWaga)-1].id:=nr;
      end;
      inc(nr);
      SetLength(tabLanInwersyjne,nr);
    end;

    czyWystepuje := false;
    for j:=0 to (Length(tabPoczCena)-1) do
    begin
      if(tabPoczCena[j].cena=tab[i].cena) then czyWystepuje:=true;
    end;
    if not czyWystepuje then
    begin
      SetLength(tabPoczCena,Length(tabPoczCena)+1);
      wstawiono:=false;
      for j:=0 to (Length(tabPoczCena)-2) do
      begin
        if(tab[i].cena < tabPoczCena[j].cena) then
        begin
          wstawiono := true;
          for k:=(Length(tabPoczCena)-1) downto (j+1) do
          begin
            tabPoczCena[k]:=tabPoczCena[k-1];
          end;
          tabPoczCena[j].cena:=tab[i].cena;
          tabPoczCena[j].id:=nr;
          break;
        end;
      end;
      if not wstawiono then
      begin
        tabPoczCena[Length(tabPoczCena)-1].cena:=tab[i].cena;
        tabPoczCena[Length(tabPoczCena)-1].id:=nr;
      end;
      inc(nr);
      SetLength(tabLanInwersyjne,nr);
    end;
    { NR KURIERA }
    czyWystepuje := false;
    for j:=0 to (Length(tabPoczNrKuriera)-1) do
    begin
      if(tabPoczNrKuriera[j].nrKuriera=tab[i].nrKuriera) then czyWystepuje:=true;
    end;
    if not czyWystepuje then
    begin
      SetLength(tabPoczNrKuriera,Length(tabPoczNrKuriera)+1);
      wstawiono:=false;
      for j:=0 to (Length(tabPoczNrKuriera)-2) do
      begin
        if(tab[i].nrKuriera < tabPoczNrKuriera[j].nrKuriera) then
        begin
          wstawiono := true;
          for k:=(Length(tabPoczNrKuriera)-1) downto (j+1) do
          begin
            tabPoczNrKuriera[k]:=tabPoczNrKuriera[k-1];
          end;
          tabPoczNrKuriera[j].nrKuriera:=tab[i].nrKuriera;
          tabPoczNrKuriera[j].id:=nr;
          break;
        end;
      end;
      if not wstawiono then
      begin
        tabPoczNrKuriera[Length(tabPoczNrKuriera)-1].nrKuriera:=tab[i].nrKuriera;
        tabPoczNrKuriera[Length(tabPoczNrKuriera)-1].id:=nr;
      end;
      inc(nr);
      SetLength(tabLanInwersyjne,nr);
    end;
    { CZY OPLACONA }
    czyWystepuje := false;
    for j:=0 to (Length(tabPoczCzyOplacona)-1) do
    begin
      if(tabPoczCzyOplacona[j].czyOplacona=tab[i].czyOplacona) then czyWystepuje:=true;
    end;
    if not czyWystepuje then
    begin
      SetLength(tabPoczCzyOplacona,Length(tabPoczCzyOplacona)+1);
      wstawiono:=false;
      for j:=0 to (Length(tabPoczCzyOplacona)-2) do
      begin
        if(tab[i].czyOplacona < tabPoczCzyOplacona[j].czyOplacona) then
        begin
          wstawiono := true;
          for k:=(Length(tabPoczCzyOplacona)-1) downto (j+1) do
          begin
            tabPoczCzyOplacona[k]:=tabPoczCzyOplacona[k-1];
          end;
          tabPoczCzyOplacona[j].czyOplacona:=tab[i].czyOplacona;
          tabPoczCzyOplacona[j].id:=nr;
          break;
        end;
      end;
      if not wstawiono then
      begin
        tabPoczCzyOplacona[Length(tabPoczCzyOplacona)-1].czyOplacona:=tab[i].czyOplacona;
        tabPoczCzyOplacona[Length(tabPoczCzyOplacona)-1].id:=nr;
      end;
      inc(nr);
      SetLength(tabLanInwersyjne,nr);
    end;
    { NR NADAWCY }
    czyWystepuje := false;
    for j:=0 to (Length(tabPoczNrNadawcy)-1) do
    begin
      if(tabPoczNrNadawcy[j].nrNadawcy=tab[i].nrNadawcy) then czyWystepuje:=true;
    end;
    if not czyWystepuje then
    begin
      SetLength(tabPoczNrNadawcy,Length(tabPoczNrNadawcy)+1);
      wstawiono:=false;
      for j:=0 to (Length(tabPoczNrNadawcy)-2) do
      begin
        if(tab[i].nrNadawcy < tabPoczNrNadawcy[j].nrNadawcy) then
        begin
          wstawiono := true;
          for k:=(Length(tabPoczNrNadawcy)-1) downto (j+1) do
          begin
            tabPoczNrNadawcy[k]:=tabPoczNrNadawcy[k-1];
          end;
          tabPoczNrNadawcy[j].nrNadawcy:=tab[i].nrNadawcy;
          tabPoczNrNadawcy[j].id:=nr;
          break;
        end;
      end;
      if not wstawiono then
      begin
        tabPoczNrNadawcy[Length(tabPoczCzyOplacona)-1].nrNadawcy:=tab[i].nrNadawcy;
        tabPoczNrNadawcy[Length(tabPoczCzyOplacona)-1].id:=nr;
      end;
      inc(nr);
      SetLength(tabLanInwersyjne,nr);
    end;
    { ADRES NADAWCY }
    czyWystepuje := false;
    for j:=0 to (Length(tabPoczAdres)-1) do
    begin
      if(tabPoczAdres[j].adres=tab[i].adres) then czyWystepuje:=true;
    end;
    if not czyWystepuje then
    begin
      SetLength(tabPoczAdres,Length(tabPoczAdres)+1);
      wstawiono:=false;
      for j:=0 to (Length(tabPoczAdres)-2) do
      begin
        if(tab[i].adres < tabPoczAdres[j].adres) then
        begin
          wstawiono := true;
          for k:=(Length(tabPoczAdres)-1) downto (j+1) do
          begin
            tabPoczAdres[k]:=tabPoczAdres[k-1];
          end;
          tabPoczAdres[j].adres:=tab[i].adres;
          tabPoczAdres[j].id:=nr;
          break;
        end;
      end;
      if not wstawiono then
      begin
        tabPoczAdres[Length(tabPoczAdres)-1].adres:=tab[i].adres;
        tabPoczAdres[Length(tabPoczAdres)-1].id:=nr;
      end;
      inc(nr);
      SetLength(tabLanInwersyjne,nr);
    end;
    { KOD POCZTOWY }
    czyWystepuje := false;
    for j:=0 to (Length(tabPoczKodPocztowy)-1) do
    begin
      if(tabPoczKodPocztowy[j].kodPocztowy=tab[i].kodPocztowy) then czyWystepuje:=true;
    end;
    if not czyWystepuje then
    begin
      SetLength(tabPoczKodPocztowy,Length(tabPoczKodPocztowy)+1);
      wstawiono:=false;
      for j:=0 to (Length(tabPoczKodPocztowy)-2) do
      begin
        if(tab[i].kodPocztowy < tabPoczKodPocztowy[j].kodPocztowy) then
        begin
          wstawiono := true;
          for k:=(Length(tabPoczKodPocztowy)-1) downto (j+1) do
          begin
            tabPoczKodPocztowy[k]:=tabPoczKodPocztowy[k-1];
          end;
          tabPoczKodPocztowy[j].kodPocztowy:=tab[i].kodPocztowy;
          tabPoczKodPocztowy[j].id:=nr;
          break;
        end;
      end;
      if not wstawiono then
      begin
        tabPoczKodPocztowy[Length(tabPoczKodPocztowy)-1].kodPocztowy:=tab[i].kodPocztowy;
        tabPoczKodPocztowy[Length(tabPoczKodPocztowy)-1].id:=nr;
      end;
      inc(nr);
      SetLength(tabLanInwersyjne,nr);
    end;
  end;

  for i:=0 to length(tabPoczNadano)-1 do
  begin
    for j:=0 to length(tab)-1 do
    begin
      if((tab[j].punktNadania = tabPoczNadano[i].punktNadania) and (not tab[j].czyUsuniety)) then
      begin
        SetLength(tabLanInwersyjne[tabPoczNadano[i].id],Length(tabLanInwersyjne[tabPoczNadano[i].id])+1);
        tabLanInwersyjne[tabPoczNadano[i].id][Length(tabLanInwersyjne[tabPoczNadano[i].id])-1]:=j;
      end;
    end;
  end;

  for i:=0 to length(tabPoczKodPrzesylki)-1 do
  begin
    for j:=0 to length(tab)-1 do
    begin
      if((tab[j].kodPrzesylki = tabPoczKodPrzesylki[i].kodPrzesylki) and (not tab[j].czyUsuniety)) then
      begin
        SetLength(tabLanInwersyjne[tabPoczKodPrzesylki[i].id],Length(tabLanInwersyjne[tabPoczKodPrzesylki[i].id])+1);
        tabLanInwersyjne[tabPoczKodPrzesylki[i].id][Length(tabLanInwersyjne[tabPoczKodPrzesylki[i].id])-1]:=j;
      end;
    end;
  end;

  for i:=0 to length(tabPoczWaga)-1 do
  begin
    for j:=0 to length(tab)-1 do
    begin
      if((tab[j].waga = tabPoczWaga[i].waga) and (not tab[j].czyUsuniety)) then
      begin
        SetLength(tabLanInwersyjne[tabPoczWaga[i].id],Length(tabLanInwersyjne[tabPoczWaga[i].id])+1);
        tabLanInwersyjne[tabPoczWaga[i].id][Length(tabLanInwersyjne[tabPoczWaga[i].id])-1]:=j;
      end;
    end;
  end;

  for i:=0 to length(tabPoczCena)-1 do
  begin
    for j:=0 to length(tab)-1 do
    begin
      if((tab[j].cena = tabPoczCena[i].cena) and (not tab[j].czyUsuniety)) then
      begin
        SetLength(tabLanInwersyjne[tabPoczCena[i].id],Length(tabLanInwersyjne[tabPoczCena[i].id])+1);
        tabLanInwersyjne[tabPoczCena[i].id][Length(tabLanInwersyjne[tabPoczCena[i].id])-1]:=j;
      end;
    end;
  end;

  for i:=0 to length(tabPoczNrKuriera)-1 do
  begin
    for j:=0 to length(tab)-1 do
    begin
      if((tab[j].nrKuriera = tabPoczNrKuriera[i].nrKuriera) and (not tab[j].czyUsuniety)) then
      begin
        SetLength(tabLanInwersyjne[tabPoczNrKuriera[i].id],Length(tabLanInwersyjne[tabPoczNrKuriera[i].id])+1);
        tabLanInwersyjne[tabPoczNrKuriera[i].id][Length(tabLanInwersyjne[tabPoczNrKuriera[i].id])-1]:=j;
      end;
    end;
  end;

  for i:=0 to length(tabPoczCzyOplacona)-1 do
  begin
    for j:=0 to length(tab)-1 do
    begin
      if((tab[j].czyOplacona = tabPoczCzyOplacona[i].czyOplacona) and (not tab[j].czyUsuniety)) then
      begin
        SetLength(tabLanInwersyjne[tabPoczCzyOplacona[i].id],Length(tabLanInwersyjne[tabPoczCzyOplacona[i].id])+1);
        tabLanInwersyjne[tabPoczCzyOplacona[i].id][Length(tabLanInwersyjne[tabPoczCzyOplacona[i].id])-1]:=j;
      end;
    end;
  end;

  for i:=0 to length(tabPoczNrNadawcy)-1 do
  begin
    for j:=0 to length(tab)-1 do
    begin
      if((tab[j].nrNadawcy = tabPoczNrNadawcy[i].nrNadawcy) and (not tab[j].czyUsuniety)) then
      begin
        SetLength(tabLanInwersyjne[tabPoczNrNadawcy[i].id],Length(tabLanInwersyjne[tabPoczNrNadawcy[i].id])+1);
        tabLanInwersyjne[tabPoczNrNadawcy[i].id][Length(tabLanInwersyjne[tabPoczNrNadawcy[i].id])-1]:=j;
      end;
    end;
  end;

  for i:=0 to length(tabPoczAdres)-1 do
  begin
    for j:=0 to length(tab)-1 do
    begin
      if((tab[j].adres = tabPoczAdres[i].adres) and (not tab[j].czyUsuniety)) then
      begin
        SetLength(tabLanInwersyjne[tabPoczAdres[i].id],Length(tabLanInwersyjne[tabPoczAdres[i].id])+1);
        tabLanInwersyjne[tabPoczAdres[i].id][Length(tabLanInwersyjne[tabPoczAdres[i].id])-1]:=j;
      end;
    end;
  end;

  for i:=0 to length(tabPoczKodPocztowy)-1 do
  begin
    for j:=0 to length(tab)-1 do
    begin
      if((tab[j].kodPocztowy = tabPoczKodPocztowy[i].kodPocztowy) and (not tab[j].czyUsuniety)) then
      begin
        SetLength(tabLanInwersyjne[tabPoczKodPocztowy[i].id],Length(tabLanInwersyjne[tabPoczKodPocztowy[i].id])+1);
        tabLanInwersyjne[tabPoczKodPocztowy[i].id][Length(tabLanInwersyjne[tabPoczKodPocztowy[i].id])-1]:=j;
      end;
    end;
  end;

  QueryPerformanceCounter(stop);
  ShowMessage('Inicjalizacja tablic do metody inwersyjnej trwała: '+FloatToStr(1000*((stop-start)/freq))+' milisekund.');
  {for i:=0 to (length(tabLanInwersyjne)-1) do
  begin
    for j:=0 to (Length(tabLanInwersyjne[i])-1) do
    begin
      inc(k);
    end;
  end;
  Form1.StringGrid1.RowCount:=1;//.clean
  Form1.StringGrid1.RowCount:=k;
  k:=0;
  for i:=0 to (length(tabLanInwersyjne)-1) do
  begin
    for j:=0 to (Length(tabLanInwersyjne[i])-1) do
    begin
      inc(k);
      Form1.StringGrid1.Cells[0,k]:=IntToStr(k);
      Form1.StringGrid1.Cells[1,k]:=IntToStr(i);
      Form1.StringGrid1.Cells[2,k]:=IntToStr(tabLanInwersyjne[i][j]);
    end;
  end; }
end;

procedure metodaLancuchowaPrepare();
var
  i,j,k,poprzedni:integer; //ilosc
  czyWystepuje:boolean;
  freq,start,stop:Int64;
begin
  freq:=0;
  start:=0;
  stop:=0;
  SetLength(tabPoczNadano,0);
  SetLength(tabPoczKodPrzesylki,0);
  SetLength(tabPoczWaga,0);
  SetLength(tabPoczCena,0);
  SetLength(tabPoczNrKuriera,0);
  SetLength(tabPoczCzyOplacona,0);
  SetLength(tabPoczNrNadawcy,0);
  SetLength(tabPoczAdres,0);
  SetLength(tabPoczKodPocztowy,0);
  SetLength(tabLancuchow,0);
  SetLength(tabLanInwersyjne,0);

  QueryPerformanceFrequency(freq);
  QueryPerformanceCounter(start);
  for i:=0 to (Length(tab)-1) do
  begin
    if tab[i].czyUsuniety then continue;

    czyWystepuje := false;
    k:=-1;
    for j:=0 to (Length(tabPoczNadano)-1) do
    begin
      if(tabPoczNadano[j].punktNadania=tab[i].punktNadania) then
      begin
        czyWystepuje:=true;
        break;
      end else if(tab[i].punktNadania < tabPoczNadano[j].punktNadania) then k:=j;
    end;
    if not czyWystepuje then
    begin
      SetLength(tabPoczNadano,Length(tabPoczNadano)+1);
      j:=k;
      if(j > -1) then
      begin
        for k:=(Length(tabPoczNadano)-1) downto (j) do
        begin
          tabPoczNadano[k]:=tabPoczNadano[k-1];
        end;
        tabPoczNadano[j].punktNadania:=tab[i].punktNadania;
        tabPoczNadano[j].id:=i;
      end else begin
        tabPoczNadano[Length(tabPoczNadano)-1].punktNadania:=tab[i].punktNadania;
        tabPoczNadano[Length(tabPoczNadano)-1].id:=i;
      end;
    end;

    czyWystepuje := false;
    k:=-1;
    for j:=0 to (Length(tabPoczKodPrzesylki)-1) do
    begin
      if(tabPoczKodPrzesylki[j].kodPrzesylki=tab[i].kodPrzesylki) then
      begin
        czyWystepuje:=true;
        break;
      end else if(tab[i].kodPrzesylki < tabPoczKodPrzesylki[j].kodPrzesylki) then k:=j;
    end;
    if not czyWystepuje then
    begin
      SetLength(tabPoczKodPrzesylki,Length(tabPoczKodPrzesylki)+1);
      j:=k;
      if(j > -1) then
      begin
        for k:=(Length(tabPoczKodPrzesylki)-1) downto (j) do
        begin
          tabPoczKodPrzesylki[k]:=tabPoczKodPrzesylki[k-1];
        end;
        tabPoczKodPrzesylki[j].kodPrzesylki:=tab[i].kodPrzesylki;
        tabPoczKodPrzesylki[j].id:=i;
      end else begin
        tabPoczKodPrzesylki[Length(tabPoczKodPrzesylki)-1].kodPrzesylki:=tab[i].kodPrzesylki;
        tabPoczKodPrzesylki[Length(tabPoczKodPrzesylki)-1].id:=i;
      end;
    end;

    czyWystepuje := false;
    k:=-1;
    for j:=0 to (Length(tabPoczWaga)-1) do
    begin
      if(tabPoczWaga[j].waga=tab[i].waga) then
      begin
        czyWystepuje:=true;
        break;
      end else if(tab[i].waga < tabPoczWaga[j].waga) then k:=j;
    end;
    if not czyWystepuje then
    begin
      SetLength(tabPoczWaga,Length(tabPoczWaga)+1);
      j:=k;
      if(j > -1) then
      begin
        for k:=(Length(tabPoczWaga)-1) downto (j) do
        begin
          tabPoczWaga[k]:=tabPoczWaga[k-1];
        end;
        tabPoczWaga[j].waga:=tab[i].waga;
        tabPoczWaga[j].id:=i;
      end else begin
        tabPoczWaga[Length(tabPoczWaga)-1].waga:=tab[i].waga;
        tabPoczWaga[Length(tabPoczWaga)-1].id:=i;
      end;
    end;

    czyWystepuje := false;
    k:=-1;
    for j:=0 to (Length(tabPoczCena)-1) do
    begin
      if(tabPoczCena[j].cena=tab[i].cena) then
      begin
        czyWystepuje:=true;
        break;
      end else if(tab[i].cena < tabPoczCena[j].cena) then k:=j;
    end;
    if not czyWystepuje then
    begin
      SetLength(tabPoczCena,Length(tabPoczCena)+1);
      j:=k;
      if(j > -1) then
      begin
        for k:=(Length(tabPoczCena)-1) downto (j) do
        begin
          tabPoczCena[k]:=tabPoczCena[k-1];
        end;
        tabPoczCena[j].cena:=tab[i].cena;
        tabPoczCena[j].id:=i;
      end else begin
        tabPoczCena[Length(tabPoczCena)-1].cena:=tab[i].cena;
        tabPoczCena[Length(tabPoczCena)-1].id:=i;
      end;
    end;
    { NR KURIERA }
    czyWystepuje := false;
    k:=-1;
    for j:=0 to (Length(tabPoczNrKuriera)-1) do
    begin
      if(tabPoczNrKuriera[j].nrKuriera=tab[i].nrKuriera) then
      begin
        czyWystepuje:=true;
        break;
      end else if(tab[i].nrKuriera < tabPoczNrKuriera[j].nrKuriera) then k:=j;
    end;
    if not czyWystepuje then
    begin
      SetLength(tabPoczNrKuriera,Length(tabPoczNrKuriera)+1);
      j:=k;
      if(j > -1) then
      begin
        for k:=(Length(tabPoczNrKuriera)-1) downto (j) do
        begin
          tabPoczNrKuriera[k]:=tabPoczNrKuriera[k-1];
        end;
        tabPoczNrKuriera[j].nrKuriera:=tab[i].nrKuriera;
        tabPoczNrKuriera[j].id:=i;
      end else begin
        tabPoczNrKuriera[Length(tabPoczNrKuriera)-1].nrKuriera:=tab[i].nrKuriera;
        tabPoczNrKuriera[Length(tabPoczNrKuriera)-1].id:=i;
      end;
    end;
    { CZY OPLACONA }
    czyWystepuje := false;
    k:=-1;
    for j:=0 to (Length(tabPoczCzyOplacona)-1) do
    begin
      if(tabPoczCzyOplacona[j].czyOplacona=tab[i].czyOplacona) then
      begin
        czyWystepuje:=true;
        break;
      end else if(tab[i].czyOplacona < tabPoczCzyOplacona[j].czyOplacona) then k:=j;
    end;
    if not czyWystepuje then
    begin
      SetLength(tabPoczCzyOplacona,Length(tabPoczCzyOplacona)+1);
      j:=k;
      if(j > -1) then
      begin
        for k:=(Length(tabPoczCzyOplacona)-1) downto (j) do
        begin
          tabPoczCzyOplacona[k]:=tabPoczCzyOplacona[k-1];
        end;
        tabPoczCzyOplacona[j].czyOplacona:=tab[i].czyOplacona;
        tabPoczCzyOplacona[j].id:=i;
      end else begin
        tabPoczCzyOplacona[Length(tabPoczCzyOplacona)-1].czyOplacona:=tab[i].czyOplacona;
        tabPoczCzyOplacona[Length(tabPoczCzyOplacona)-1].id:=i;
      end;
    end;
    { NR NADAWCY }
    czyWystepuje := false;
    k:=-1;
    for j:=0 to (Length(tabPoczNrNadawcy)-1) do
    begin
      if(tabPoczNrNadawcy[j].nrNadawcy=tab[i].nrNadawcy) then
      begin
        czyWystepuje:=true;
        break;
      end else if(tab[i].nrNadawcy < tabPoczNrNadawcy[j].nrNadawcy) then k:=j;
    end;
    if not czyWystepuje then
    begin
      SetLength(tabPoczNrNadawcy,Length(tabPoczNrNadawcy)+1);
      j:=k;
      if(j > -1) then
      begin
        for k:=(Length(tabPoczNrNadawcy)-1) downto (j) do
        begin
          tabPoczNrNadawcy[k]:=tabPoczNrNadawcy[k-1];
        end;
        tabPoczNrNadawcy[j].nrNadawcy:=tab[i].nrNadawcy;
        tabPoczNrNadawcy[j].id:=i;
      end else begin
        tabPoczNrNadawcy[Length(tabPoczNrNadawcy)-1].nrNadawcy:=tab[i].nrNadawcy;
        tabPoczNrNadawcy[Length(tabPoczNrNadawcy)-1].id:=i;
      end;
    end;
    { ADRES NADAWCY }
    czyWystepuje := false;
    k:=-1;
    for j:=0 to (Length(tabPoczAdres)-1) do
    begin
      if(tabPoczAdres[j].adres=tab[i].adres) then
      begin
        czyWystepuje:=true;
        break;
      end else if(tab[i].adres < tabPoczAdres[j].adres) then k:=j;
    end;
    if not czyWystepuje then
    begin
      SetLength(tabPoczAdres,Length(tabPoczAdres)+1);
      j:=k;
      if(j > -1) then
      begin
        for k:=(Length(tabPoczAdres)-1) downto (j) do
        begin
          tabPoczAdres[k]:=tabPoczAdres[k-1];
        end;
        tabPoczAdres[j].adres:=tab[i].adres;
        tabPoczAdres[j].id:=i;
      end else begin
        tabPoczAdres[Length(tabPoczAdres)-1].adres:=tab[i].adres;
        tabPoczAdres[Length(tabPoczAdres)-1].id:=i;
      end;
    end;
    { KOD POCZTOWY }
    czyWystepuje := false;
    k:=-1;
    for j:=0 to (Length(tabPoczKodPocztowy)-1) do
    begin
      if(tabPoczKodPocztowy[j].kodPocztowy=tab[i].kodPocztowy) then
      begin
        czyWystepuje:=true;
        break;
      end else if(tab[i].kodPocztowy < tabPoczKodPocztowy[j].kodPocztowy) then k:=j;
    end;
    if not czyWystepuje then
    begin
      SetLength(tabPoczKodPocztowy,Length(tabPoczKodPocztowy)+1);
      j:=k;
      if(j > -1) then
      begin
        for k:=(Length(tabPoczKodPocztowy)-1) downto (j) do
        begin
          tabPoczKodPocztowy[k]:=tabPoczKodPocztowy[k-1];
        end;
        tabPoczKodPocztowy[j].kodPocztowy:=tab[i].kodPocztowy;
        tabPoczKodPocztowy[j].id:=i;
      end else begin
        tabPoczKodPocztowy[Length(tabPoczKodPocztowy)-1].kodPocztowy:=tab[i].kodPocztowy;
        tabPoczKodPocztowy[Length(tabPoczKodPocztowy)-1].id:=i;
      end;
    end;
  end;

  SetLength(tabLancuchow,length(tab));
  for i:=0 to (length(tabLancuchow)-1) do
  begin
    for j:=0 to 8 do tabLancuchow[i][j]:=-1;
  end;

  for i:=0 to length(tabPoczNadano)-1 do
  begin
    poprzedni := tabPoczNadano[i].id;
    for j:=(tabPoczNadano[i].id+1) to length(tab)-1 do
    begin
      if((tab[j].punktNadania = tabPoczNadano[i].punktNadania) and (not tab[j].czyUsuniety)) then
      begin
        tabLancuchow[poprzedni][0]:=j;
        poprzedni:=j;
      end;
    end;
  end;

  for i:=0 to length(tabPoczKodPrzesylki)-1 do
  begin
    poprzedni := tabPoczKodPrzesylki[i].id;
    for j:=(tabPoczKodPrzesylki[i].id+1) to length(tab)-1 do
    begin
      if((tab[j].kodPrzesylki = tabPoczKodPrzesylki[i].kodPrzesylki) and (not tab[j].czyUsuniety)) then
      begin
        tabLancuchow[poprzedni][1]:=j;
        poprzedni:=j;
      end;
    end;
  end;

  for i:=0 to length(tabPoczWaga)-1 do
  begin
    poprzedni := tabPoczWaga[i].id;
    for j:=(tabPoczWaga[i].id+1) to length(tab)-1 do
    begin
      if((tab[j].waga = tabPoczWaga[i].waga) and (not tab[j].czyUsuniety)) then
      begin
        tabLancuchow[poprzedni][2]:=j;
        poprzedni:=j;
      end;
    end;
  end;

  for i:=0 to length(tabPoczCena)-1 do
  begin
    poprzedni := tabPoczCena[i].id;
    for j:=(tabPoczCena[i].id+1) to length(tab)-1 do
    begin
      if((tab[j].cena = tabPoczCena[i].cena) and (not tab[j].czyUsuniety)) then
      begin
        tabLancuchow[poprzedni][3]:=j;
        poprzedni:=j;
      end;
    end;
  end;

  for i:=0 to length(tabPoczNrKuriera)-1 do
  begin
    poprzedni := tabPoczNrKuriera[i].id;
    for j:=(tabPoczNrKuriera[i].id+1) to length(tab)-1 do
    begin
      if((tab[j].nrKuriera = tabPoczNrKuriera[i].nrKuriera) and (not tab[j].czyUsuniety)) then
      begin
        tabLancuchow[poprzedni][4]:=j;
        poprzedni:=j;
      end;
    end;
  end;

  for i:=0 to length(tabPoczCzyOplacona)-1 do
  begin
    poprzedni := tabPoczCzyOplacona[i].id;
    for j:=(tabPoczCzyOplacona[i].id+1) to length(tab)-1 do
    begin
      if((tab[j].czyOplacona = tabPoczCzyOplacona[i].czyOplacona) and (not tab[j].czyUsuniety)) then
      begin
        tabLancuchow[poprzedni][5]:=j;
        poprzedni:=j;
      end;
    end;
  end;

  for i:=0 to length(tabPoczNrNadawcy)-1 do
  begin
    poprzedni := tabPoczNrNadawcy[i].id;
    for j:=(tabPoczNrNadawcy[i].id+1) to length(tab)-1 do
    begin
      if((tab[j].nrNadawcy = tabPoczNrNadawcy[i].nrNadawcy) and (not tab[j].czyUsuniety)) then
      begin
        tabLancuchow[poprzedni][6]:=j;
        poprzedni:=j;
      end;
    end;
  end;

  for i:=0 to length(tabPoczAdres)-1 do
  begin
    poprzedni := tabPoczAdres[i].id;
    for j:=(tabPoczAdres[i].id+1) to length(tab)-1 do
    begin
      if((tab[j].adres = tabPoczAdres[i].adres) and (not tab[j].czyUsuniety)) then
      begin
        tabLancuchow[poprzedni][7]:=j;
        poprzedni:=j;
      end;
    end;
  end;

  for i:=0 to length(tabPoczKodPocztowy)-1 do
  begin
    poprzedni := tabPoczKodPocztowy[i].id;
    for j:=(tabPoczKodPocztowy[i].id+1) to length(tab)-1 do
    begin
      if((tab[j].kodPocztowy = tabPoczKodPocztowy[i].kodPocztowy) and (not tab[j].czyUsuniety)) then
      begin
        tabLancuchow[poprzedni][8]:=j;
        poprzedni:=j;
      end;
    end;
  end;

  QueryPerformanceCounter(stop);
  ShowMessage('Inicjalizacja tablic do metody łańcuchowej trwała: '+FloatToStr(1000*((stop-start)/freq))+' milisekund.');
  {ilosc:=0;
  for i:=0 to (length(tabLancuchow)-1) do
  begin
    inc(ilosc);
    Form1.StringGrid1.Cells[0,ilosc]:=IntToStr(ilosc);
    Form1.StringGrid1.Cells[1,ilosc]:=IntToStr(tabLancuchow[i][0]);
    Form1.StringGrid1.Cells[2,ilosc]:=IntToStr(tabLancuchow[i][1]);
    Form1.StringGrid1.Cells[3,ilosc]:=IntToStr(tabLancuchow[i][2]);
    Form1.StringGrid1.Cells[4,ilosc]:=IntToStr(tabLancuchow[i][3]);
    Form1.StringGrid1.Cells[5,ilosc]:=IntToStr(tabLancuchow[i][4]);
    Form1.StringGrid1.Cells[6,ilosc]:=IntToStr(tabLancuchow[i][5]);
    Form1.StringGrid1.Cells[7,ilosc]:=IntToStr(tabLancuchow[i][6]);
    Form1.StringGrid1.Cells[8,ilosc]:=IntToStr(tabLancuchow[i][7]);
    Form1.StringGrid1.Cells[9,ilosc]:=IntToStr(tabLancuchow[i][8]);
  end; }
end;

procedure TForm1.ComboBox6Change(Sender: TObject);
var
  nr:integer;
begin
  if(Length(tab) = 0) then exit;
  nr:=ComboBox6.ItemIndex;
  if(nr < 0) then
  begin
    ComboBox3.ItemIndex := -1;
    ComboBox3.Text:='Wybierz...';
    ComboBox3.Enabled:=false;
  end else
  begin
    if(nr = 2) then metodaLancuchowaPrepare();
    if(nr = 3) then metodaInwersyjnaPrepare();
    ComboBox3.Enabled:=true;
    Label18.Enabled:=true;
  end;
end;

procedure TForm1.Button4Click(Sender: TObject);
var
  i,j,iloscWierszy,iloscTab,iloscCalkowita:integer;
  tabNadano:array[0..19] of string[48] = ('Białystok','Bydgoszcz','Choroszcz','Częstochowa','Gdańsk','Gdynia','Gniezno','Katowice','Kielce','Koszalin','Kraków','Lublin','Łódź','Mielno','Opole','Piła','Poznań','Szczecin','Warszawa','Wrocław');
  tabCena:array[0..9] of Byte = (10,15,20,25,30,35,40,45,50,55);
  rok,miesiac,dzien,WDay,godzina,minuta,sekunda,setnasekundy:word;
  znaki:string[64];
  miasto,ulica:string[128];
begin
  if(SpinEdit2.Text = '0') then
  begin
    ShowMessage('Podaj wartość większą od 0.');
  end;
  rok:=0;miesiac:=0;dzien:=0;WDay:=0;godzina:=0;minuta:=0;sekunda:=0;setnasekundy:=0;
  GetDate(rok,miesiac,dzien,WDay);
  iloscWierszy:=StringGrid1.RowCount;
  iloscTab:=Length(tab);
  iloscCalkowita:=iloscWierszy+StrToInt(SpinEdit2.Text);
  if iloscCalkowita < 101000 then StringGrid1.RowCount:=iloscCalkowita;
  for i:=iloscTab to (iloscTab+StrToInt(SpinEdit2.Text)-1) do
  begin
    inc(iloscTab);
    SetLength(tab,iloscTab);
    tab[i].czyUsuniety:=false;
    tab[i].id:=i;
    tab[i].punktNadania:=tabNadano[random(20)];

    GetTime(godzina,minuta,sekunda,setnasekundy);
    znaki:=IntToStr(random(10))+chr(65+random(26));
    if(godzina < 10) then znaki:=znaki+'0';
    znaki:=znaki+IntToStr(godzina);
    if(minuta < 10) then znaki:=znaki+'0';
    znaki:=znaki+IntToStr(minuta);
    if(sekunda < 10) then znaki:=znaki+'0';
    znaki:=znaki+IntToStr(sekunda);
    if(setnasekundy < 10) then znaki:=znaki+'0';
    znaki:=znaki+IntToStr(setnasekundy)+chr(97+random(26));
    if(dzien < 10) then znaki:=znaki+'0';
    znaki:=znaki+IntToStr(dzien);
    if(miesiac < 10) then znaki:=znaki+'0';
    znaki:=znaki+IntToStr(miesiac)+IntToStr(rok)+IntToStr(random(10));

    tab[i].kodPrzesylki:=znaki;
    tab[i].waga:=random(25)+(random(100)/100);
    if(tab[i].waga < 0.1) then tab[i].waga:=tab[i].waga+1;
    tab[i].cena:=tabCena[random(10)];
    tab[i].nrKuriera:=random(9999)+1;
    if(random(2) = 1) then tab[i].czyOplacona:=true else tab[i].czyOplacona:=false;
    tab[i].nrNadawcy:=random(9999)+1;
    for j:=0 to (random(7)+3) do
    begin
      if j = 0 then
      begin
        miasto:=chr(65+random(26));
      end else
      begin
        miasto:=miasto+chr(97+random(26));
      end;
    end;
    for j:=0 to (random(10)+3) do
    begin
      if j = 0 then
      begin
        ulica:=chr(65+random(26));
      end else
      begin
        ulica:=ulica+chr(97+random(26));
      end;
    end;
    if(random(2) = 1) then tab[i].adres:='ul. '+ulica+' '+IntToStr((random(50)+1))+'\'+IntToStr((random(20)+1))+', '+miasto else tab[i].adres:='ul. '+ulica+' '+IntToStr((random(50)+1))+', '+miasto;
    tab[i].kodPocztowy:=IntToStr(random(10))+IntToStr(random(10))+'-'+IntToStr(random(10))+IntToStr(random(10))+IntToStr(random(10));
    if (iloscCalkowita < 101000) then
    begin
      StringGrid1.Cells[0,iloscWierszy]:=IntToStr(i+1);
      StringGrid1.Cells[1,iloscWierszy]:=tab[i].punktNadania;
      StringGrid1.Cells[2,iloscWierszy]:=tab[i].kodPrzesylki;
      StringGrid1.Cells[3,iloscWierszy]:=FloatToStrF(tab[i].waga,ffFixed,8,2);
      StringGrid1.Cells[4,iloscWierszy]:=IntToStr(tab[i].cena);
      StringGrid1.Cells[5,iloscWierszy]:=IntToStr(tab[i].nrKuriera);
      if(tab[i].czyOplacona) then StringGrid1.Cells[6,iloscWierszy]:='TAK' else StringGrid1.Cells[6,iloscWierszy]:='NIE';
      StringGrid1.Cells[7,iloscWierszy]:=IntToStr(tab[i].nrNadawcy);
      StringGrid1.Cells[8,iloscWierszy]:=tab[i].adres;
      StringGrid1.Cells[9,iloscWierszy]:=tab[i].kodPocztowy;
      inc(iloscWierszy);
    end;
  end;
  if (iloscCalkowita >= 101000) then ShowMessage('Wygenerowano '+SpinEdit2.Text+' rekordów!');
  SpinEdit2.Text := '0';
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  nazwa_pliku:string;
  plik:file of tabDana;
  i,ilosc:integer;
begin
  if OpenDialog1.Execute then
  begin
    nazwa_pliku:=OpenDialog1.Filename;
    assignFile(plik,nazwa_pliku);
    if(not fileexists(nazwa_pliku)) then
    begin
      ShowMessage('Podany plik nie istnieje!');
      exit;
    end;
    reset(plik);
    SetLength(tab,0);
    StringGrid1.RowCount:=1;
    while not eof(plik) do
    begin
      SetLength(tab,Length(tab)+1);
      read(plik,tab[Length(tab)-1]);
    end;
    closefile(plik);
    StringGrid1.RowCount:=Length(tab)+1;
    for i:=0 to (Length(tab)-1) do
    begin
      ilosc:=i+1;
      StringGrid1.Cells[0,ilosc]:=IntToStr(tab[i].id+1);
      StringGrid1.Cells[1,ilosc]:=tab[i].punktNadania;
      StringGrid1.Cells[2,ilosc]:=tab[i].kodPrzesylki;
      StringGrid1.Cells[3,ilosc]:=FloatToStrF(tab[i].waga,ffFixed,8,2);
      StringGrid1.Cells[4,ilosc]:=IntToStr(tab[i].cena);
      StringGrid1.Cells[5,ilosc]:=IntToStr(tab[i].nrKuriera);
      if(tab[i].czyOplacona) then StringGrid1.Cells[6,ilosc]:='TAK' else StringGrid1.Cells[6,ilosc]:='NIE';
      StringGrid1.Cells[7,ilosc]:=IntToStr(tab[i].nrNadawcy);
      StringGrid1.Cells[8,ilosc]:=tab[i].adres;
      StringGrid1.Cells[9,ilosc]:=tab[i].kodPocztowy;
    end;
    ShowMessage('Wczytano plik!');
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  i,ile:integer;
begin
  if StrToInt(SpinEdit1.Text) < 1 then
  begin
    ShowMessage('Podaj numer rekordu który chcesz usunąć!');
    exit;
  end;

  if((StrToInt(SpinEdit1.Text) > Length(tab)) or tab[StrToInt(SpinEdit1.Text)-1].czyUsuniety) then
  begin
    ShowMessage('Nie ma takiego numeru rekordu!');
    exit;
  end;

  ile:=0;
  for i:=0 to (Length(tab)-1) do
  begin
    if(not tab[i].czyUsuniety) then
    begin
      inc(ile);
      if(i = (StrToInt(SpinEdit1.Text)-1)) then break;
    end;
  end;
  tab[StrToInt(SpinEdit1.Text)-1].czyUsuniety:=true;
  StringGrid1.DeleteRow(ile);

  {for i:=0 to (StrToInt(SpinEdit1.Text)-1) do
  begin
    if(not tab[i].czyUsuniety) then inc(ile);
  end;
  for i:=ile to (StringGrid1.RowCount-2) do
  begin
    StringGrid1.Cells[0,i]:=StringGrid1.Cells[0,i+1];
    StringGrid1.Cells[1,i]:=StringGrid1.Cells[1,i+1];
    StringGrid1.Cells[2,i]:=StringGrid1.Cells[2,i+1];
    StringGrid1.Cells[3,i]:=StringGrid1.Cells[3,i+1];
    StringGrid1.Cells[4,i]:=StringGrid1.Cells[4,i+1];
    StringGrid1.Cells[5,i]:=StringGrid1.Cells[5,i+1];
    StringGrid1.Cells[6,i]:=StringGrid1.Cells[6,i+1];
    StringGrid1.Cells[7,i]:=StringGrid1.Cells[7,i+1];
    StringGrid1.Cells[8,i]:=StringGrid1.Cells[8,i+1];
    StringGrid1.Cells[9,i]:=StringGrid1.Cells[9,i+1];
  end;
  StringGrid1.RowCount:=StringGrid1.RowCount-1;}

  SpinEdit1.Text:='0';
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  nazwa_pliku:string;
  plik:file of tabDana;
  i:integer;
begin
  if(Length(tab) < 1) then exit;
  if SaveDialog1.Execute then
  begin
    nazwa_pliku:=SaveDialog1.Filename;
    assignFile(plik,nazwa_pliku);
    if(fileexists(nazwa_pliku)) then
    begin
      if MessageDlg('Potwierdź', 'Czy chcesz nadpisać wybrany plik?',mtConfirmation,[mbYes,mbNo],0) <> mrYes then exit;
    end;
    rewrite(plik);
    for i:=0 to (Length(tab)-1) do
    begin
      if(not tab[i].czyUsuniety) then write(plik,tab[i]);
    end;
    closeFile(plik);
    ShowMessage('Zapisano plik! ('+nazwa_pliku+')');
  end;
end;

procedure TForm1.Button5Click(Sender: TObject);
var
  tabNadano:array[0..19] of string[48] = ('Białystok','Bydgoszcz','Choroszcz','Częstochowa','Gdańsk','Gdynia','Gniezno','Katowice','Kielce','Koszalin','Kraków','Lublin','Łódź','Mielno','Opole','Piła','Poznań','Szczecin','Warszawa','Wrocław');
  tabCena:array[0..9] of Byte = (10,15,20,25,30,35,40,45,50,55);
  czyDobrze:boolean;
  regexp:TRegExpr;
  iloscWierszy,iloscTab:integer;
begin
  czyDobrze:=true;
  if(ComboBox1.ItemIndex < 0) then czyDobrze:=false;
  regexp:=TRegExpr.Create;
  regexp.Expression:='^[a-zA-Z0-9]{20}$';
  if (not regexp.Exec(Edit2.Text) and czyDobrze) then
  begin
    czyDobrze:=false;
    ShowMessage('Kod przesyłki może składać się tylko ze znaków: a-zA-Z0-9 i długość musi wynosić 20 znaków.');
  end;
  if((StrToFloat(FloatSpinEdit1.Text) < 0.1) and (czyDobrze)) then
  begin
    czyDobrze:=false;
    ShowMessage('Waga musi wynosić przynajmniej 0.1kg');
  end;
  if(ComboBox2.ItemIndex < 0) then czyDobrze:=false;
  if((StrToInt(SpinEdit3.Text) < 1) or (StrToInt(SpinEdit4.Text) < 1)) then czyDobrze:=false;
  regexp.Expression:='^ul. [A-Z][a-z0-9]{2,} [0-9]{1,}[a-z]?(\\[0-9]{1,})?, [A-Z][a-z0-9]{2,}$';
  if (not regexp.Exec(Edit3.Text) and czyDobrze) then
  begin
    czyDobrze:=false;
    ShowMessage('Adres powinien wyglądać następująco:'+sLineBreak+'ul. <ulica> <nr domu>, <miejscowość>'+sLineBreak+'lub'+sLineBreak+'ul. <ulica> <nr budynku>\<nr lokalu>, <miejscowość>');
  end;
  regexp.Expression:='^[0-9]{2}-[0-9]{3}$';
  if (not regexp.Exec(Edit4.Text) and czyDobrze) then
  begin
    czyDobrze:=false;
    ShowMessage('Podaj prawidłowy kod pocztowy!');
  end;
  regexp.Free;
  if not czyDobrze then exit;

  StringGrid1.RowCount:=StringGrid1.RowCount+1;
  iloscWierszy:=StringGrid1.RowCount-1;
  iloscTab:=Length(tab);
  SetLength(tab,iloscTab+1);
  tab[iloscTab].adres:=Edit3.Text;
  tab[iloscTab].cena:=tabCena[ComboBox2.ItemIndex];
  tab[iloscTab].waga:=StrToFloat(FloatSpinEdit1.Text);
  tab[iloscTab].punktNadania:=tabNadano[ComboBox1.ItemIndex];
  tab[iloscTab].nrNadawcy:=StrToInt(SpinEdit4.Text);
  tab[iloscTab].czyOplacona:=CheckBox1.Checked;
  tab[iloscTab].nrKuriera:=StrToInt(SpinEdit3.Text);
  tab[iloscTab].kodPrzesylki:=Edit2.Text;
  tab[iloscTab].kodPocztowy:=Edit4.Text;
  tab[iloscTab].czyUsuniety:=false;
  tab[iloscTab].id:=iloscTab;

  StringGrid1.Cells[0,iloscWierszy]:=IntToStr(iloscTab+1);
  StringGrid1.Cells[1,iloscWierszy]:=tabNadano[ComboBox1.ItemIndex];
  StringGrid1.Cells[2,iloscWierszy]:=Edit2.Text;
  StringGrid1.Cells[3,iloscWierszy]:=FloatSpinEdit1.Text;
  StringGrid1.Cells[4,iloscWierszy]:=IntToStr(tabCena[ComboBox2.ItemIndex]);
  StringGrid1.Cells[5,iloscWierszy]:=SpinEdit3.Text;
  if(CheckBox1.Checked) then StringGrid1.Cells[6,iloscWierszy]:='TAK' else StringGrid1.Cells[6,iloscWierszy]:='NIE';
  StringGrid1.Cells[7,iloscWierszy]:=SpinEdit4.Text;
  StringGrid1.Cells[8,iloscWierszy]:=Edit3.Text;
  StringGrid1.Cells[9,iloscWierszy]:=Edit4.Text;

  ComboBox1.ItemIndex:=-1;
  ComboBox1.Text:='Wybierz...';
  Edit2.Text:='';
  FloatSpinEdit1.Text:='0,00';
  ComboBox2.ItemIndex:=-1;
  ComboBox2.Text:='Wybierz...';
  SpinEdit3.Text:='0';
  SpinEdit4.Text:='0';
  Edit3.Text:='';
  Edit4.Text:='';
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Randomize;
  SetLength(tab,0);
end;

procedure TForm1.TabSheet1Show(Sender: TObject);
var
  i,ilosc:integer;
begin
  SpinEdit1.Enabled:=true;
  Button1.Enabled:=true;
  Button6.Enabled:=true;
  Button7.Enabled:=false;
  ComboBox6.ItemIndex:=-1;
  ComboBox6.Text:='Wybierz...';
  ComboBox3.ItemIndex:=-1;
  ComboBox3.Text:='Wybierz...';
  ComboBox3.Enabled:=false;
  Label18.Enabled:=false;
  wyzerujWartosciWyszukaj();
  if(Length(tab) < 101000) then
  begin
    ilosc:=0;
    StringGrid1.RowCount:=Length(tab)+1;
    for i:=0 to (length(tab)-1) do
    begin
      if(not tab[i].czyUsuniety) then
      begin
        inc(ilosc);
        StringGrid1.Cells[0,ilosc]:=IntToStr(i+1);
        StringGrid1.Cells[1,ilosc]:=tab[i].punktNadania;
        StringGrid1.Cells[2,ilosc]:=tab[i].kodPrzesylki;
        StringGrid1.Cells[3,ilosc]:=FloatToStrF(tab[i].waga,ffFixed,8,2);
        StringGrid1.Cells[4,ilosc]:=IntToStr(tab[i].cena);
        StringGrid1.Cells[5,ilosc]:=IntToStr(tab[i].nrKuriera);
        if(tab[i].czyOplacona) then StringGrid1.Cells[6,ilosc]:='TAK' else StringGrid1.Cells[6,ilosc]:='NIE';
        StringGrid1.Cells[7,ilosc]:=IntToStr(tab[i].nrNadawcy);
        StringGrid1.Cells[8,ilosc]:=tab[i].adres;
        StringGrid1.Cells[9,ilosc]:=tab[i].kodPocztowy;
      end;
    end;
    StringGrid1.RowCount:=ilosc+1;
  end;
end;

procedure TForm1.TabSheet2Show(Sender: TObject);
begin
  SpinEdit1.Enabled:=false;
  Button1.Enabled:=false;
  Button6.Enabled:=false;
end;

end.

