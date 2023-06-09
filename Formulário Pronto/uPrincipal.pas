unit uPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.StdCtrls, FMX.Controls.Presentation, FMX.Layouts, FMX.MultiView;

type
  TFPrincipal = class(TForm)
    recFundo: TRectangle;
    layTitulo: TLayout;
    btnMenu: TButton;
    lblScore: TLabel;
    lblTitulo: TLabel;
    lblX: TLabel;
    lblFase: TLabel;
    layConteudo: TLayout;
    layControles: TLayout;
    recPecaBorda: TRectangle;
    recPeca: TRectangle;
    recPecaFundo: TRectangle;
    lblPecaValor: TLabel;
    recProximaPecaBorda: TRectangle;
    recProximaPeca: TRectangle;
    recProximaPecaFundo: TRectangle;
    lblProximaPeca: TLabel;
    layBomba: TLayout;
    recBomba: TRectangle;
    pthBomba: TPath;
    lblBomba: TLabel;
    layPalco: TLayout;
    layTrilha1: TLayout;
    Rectangle1: TRectangle;
    layTrilha2: TLayout;
    Rectangle2: TRectangle;
    layTrilha3: TLayout;
    Rectangle3: TRectangle;
    layTrilha4: TLayout;
    Rectangle4: TRectangle;
    layTrilha5: TLayout;
    Rectangle5: TRectangle;
    MultiView1: TMultiView;
    Layout1: TLayout;
    Circle1: TCircle;
    Layout2: TLayout;
    Label2: TLabel;
    btLevel3: TSpeedButton;
    btLevel2: TSpeedButton;
    btLevel1: TSpeedButton;
    Line1: TLine;
    btRecords: TSpeedButton;
    btSavarJogo: TSpeedButton;
    btNovoJogo: TSpeedButton;
    lblDuracaoAnime: TLabel;
    tkbDuracaoAnime: TTrackBar;
    Label1: TLabel;
    Line2: TLine;
    procedure FormCreate(Sender: TObject);
    procedure layTrilha1DblClick(Sender: TObject);
    procedure tkbDuracaoAnimeChange(Sender: TObject);
    procedure btNovoJogoClick(Sender: TObject);
  private
    fPowerOn: Boolean;
    fPower: Double;
    procedure setPower(const Value: Double);
    procedure setPowerOn(const Value: Boolean);
    { Private declarations }
  public
    { Public declarations }
    function GerarValor(Limite: Integer): Single;
    procedure RealocarPalco;
    function FimJogo: Boolean;
    procedure LimparTrilha(Trilha: TLayout);
    procedure NovoJogo;

    Property Power: Double read fPower write setPower;
    Property PowerOn: Boolean read fPowerOn write setPowerOn;
  end;

var
  FPrincipal: TFPrincipal;
  Placar: Double;

implementation

Uses GameClasses, Math;

{$R *.fmx}

//PODER ESPECIAL
procedure TFPrincipal.setPower(const Value: Double);
begin
  fPower := Value;
end;

procedure TFPrincipal.setPowerOn(const Value: Boolean);
begin
  fPowerOn := Value;
end;


//NOVO JOGO
procedure TFPrincipal.NovoJogo;
begin
    recPeca.Value  := GerarValor(7);
    recProximapeca.Value  := GerarValor(7);

    LimparTrilha(layTrilha1);
    LimparTrilha(layTrilha2);
    LimparTrilha(layTrilha3);
    LimparTrilha(layTrilha4);
    LimparTrilha(layTrilha5);

    Placar := 0;
    lblScore.Text := Format('%f', [Placar] );

end;

//LIMPAR TRILHA
procedure TFPrincipal.LimparTrilha(Trilha: TLayout);
var
  I: Integer;
begin
    for I := Trilha.ChildrenCount-1 downto 1 do begin
      Trilha.Children[I].DisposeOf;
    end;
end;


//FIM DE JOGO
procedure TFPrincipal.btNovoJogoClick(Sender: TObject);
begin
    NovoJogo;
    MultiView1.HideMaster;
end;

function TFprincipal.FimJogo: Boolean;
var
  Peca1, Peca2, Peca3, Peca4, Peca5: TRectangle;
begin
  Result := False;

  Peca1 := TRectangle(layTrilha1.Children[layTrilha1.ChildrenCount-1]);
  Peca2 := TRectangle(layTrilha2.Children[layTrilha2.ChildrenCount-1]);
  Peca3 := TRectangle(layTrilha3.Children[layTrilha3.ChildrenCount-1]);
  Peca4 := TRectangle(layTrilha4.Children[layTrilha4.ChildrenCount-1]);
  Peca5 := TRectangle(layTrilha5.Children[layTrilha5.ChildrenCount-1]);

  if (Peca1.Position.Y + Peca1.Height > layTrilha1.Height) and
    (Peca2.Position.Y + Peca1.Height > layTrilha2.Height) and
    (Peca3.Position.Y + Peca1.Height > layTrilha3.Height) and
    (Peca4.Position.Y + Peca1.Height > layTrilha4.Height) and
    (Peca5.Position.Y + Peca1.Height > layTrilha5.Height) then
    begin
      Result := True;
    end;
end;


//AO CRIAR FORMUL�RIO FA�A:
procedure TFPrincipal.FormCreate(Sender: TObject);
begin
  //Reiniciar placar
  Placar := 0;
  lblScore.Text := Format('%f', [Placar]);

  //'Gravar tempo das anima��es
  AniTime := TkbDuracaoAnime.Value;

  //Gerar valores
  recPeca.Value := GerarValor(7);
  recProximapeca.Value  := GerarValor(7);
end;

function TFprincipal.GerarValor(Limite: Integer): Single;
Begin
  //Calcular
  Result := Math.Power(2, RandomRange(1, Limite));
End;


//PROCEDIMENTO DE DUPLO CLIQUE
procedure TFPrincipal.layTrilha1DblClick(Sender: TObject);
var
  LPeca : TRectangle;
  LTrilha : TLayout;
  I: Integer;
begin
  LTrilha := TLayout(Sender);
  LPeca := TRectangle(recPeca.Clone(Self));
  LPeca.Parent := LTrilha;
  LPeca.Align := TAlignLayout.None;
  LPeca.Position.Y := LTrilha.Height + 70;
  recPeca.Value	 := recProximaPeca.Value;
  recProximaPeca.Value  := GerarValor(7);

  TAnimation.Animate(LPeca, 'Position.Y', ((LPeca.Line-1)*(LPeca.Height+5)), ANITIME)
    .AnimeType(TAnimationType.Out)
    .AnimeInterpolation(TInterpolationType.Quadratic)

    .AnimeFinish(
      procedure (Sender: TObject) var R:Integer; Begin
        Placar := Placar + Lpeca.CheckHit(
          Procedure begin
            RealocarPalco;
          end);
          RealocarPalco;
        lblScore.Text  := Format('%f', [Placar]);

        if FimJogo then
          begin
              ShowMessage('Fim de jogo');
          end;
      End)

    .Start;
end;


//ALTERAR VALOR DE VELOCIDADE DE ANIMA��ES
procedure TFPrincipal.tkbDuracaoAnimeChange(Sender: TObject);
begin
  lblDuracaoAnime.Text := Format('%2.f S', [tkbDuracaoAnime.Value]);
  AniTime := TkbDuracaoAnime.Value;
end;

//CORRIGIR BUG DE COMBO
procedure TFPrincipal.RealocarPalco;
var
  Lpeca: TRectangle;
  I: Integer;
Begin
  for I := 1 to layTrilha1.ChildrenCount-1 do begin
    LPeca := TRectangle(layTrilha1.Children[I]);
    if not (csDestroying in LPeca.ComponentState) then
      LPeca.Position.Y := ((LPeca.Line-1)*(LPeca.Height+5));
  end;

  for I := 1 to layTrilha2.ChildrenCount-1 do begin
    LPeca := TRectangle(layTrilha2.Children[I]);
    if not (csDestroying in LPeca.ComponentState) then
      LPeca.Position.Y := ((LPeca.Line-1)*(LPeca.Height+5));
  end;

  for I := 1 to layTrilha3.ChildrenCount-1 do begin
    LPeca := TRectangle(layTrilha3.Children[I]);
    if not (csDestroying in LPeca.ComponentState) then
      LPeca.Position.Y := ((LPeca.Line-1)*(LPeca.Height+5));
  end;

  for I := 1 to layTrilha4.ChildrenCount-1 do begin
    LPeca := TRectangle(layTrilha4.Children[I]);
    if not (csDestroying in LPeca.ComponentState) then
      LPeca.Position.Y := ((LPeca.Line-1)*(LPeca.Height+5));
  end;

  for I := 1 to layTrilha5.ChildrenCount-1 do begin
    LPeca := TRectangle(layTrilha5.Children[I]);
    if not (csDestroying in LPeca.ComponentState) then
      LPeca.Position.Y := ((LPeca.Line-1)*(LPeca.Height+5));
  end;
End;

end.
