unit uPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.StdCtrls, FMX.Controls.Presentation, FMX.Layouts, FMX.MultiView,
  FMX.Gestures;

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
    lblPecaValor: TLabel;
    recProximaPecaBorda: TRectangle;
    recProximaPeca: TRectangle;
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
    recPecaFundo: TRectangle;
    recProximaPecaFundo: TRectangle;
    Line2: TLine;
    Label1: TLabel;
    tkbDuracaoAnime: TTrackBar;
    lblDuracaoAnime: TLabel;
    GestureManager1: TGestureManager;
    procedure FormCreate(Sender: TObject);
    procedure layTrilha1DblClick(Sender: TObject);
    procedure tkbDuracaoAnimeChange(Sender: TObject);
    procedure btNovoJogoClick(Sender: TObject);
    procedure layBombaClick(Sender: TObject);
    procedure btLevel1Click(Sender: TObject);
    procedure layTrilha1Tap(Sender: TObject; const Point: TPointF);
    procedure layTrilha1Gesture(Sender: TObject;
      const EventInfo: TGestureEventInfo; var Handled: Boolean);
  private
    fPowerOn: Boolean;
    fPower: Double;
    FPlacar: Double;
    procedure setPower(const Value: Double);
    procedure setPowerOn(const Value: Boolean);

    procedure PecaClick(Sender: TObject);
    function getFase: Integer;
    function getPlacar: Double;
    procedure setPlacar(const Value: Double);
    { Private declarations }
  public
    { Public declarations }
    function GerarValor(Limite: Integer): Single;
    procedure RealocarPalco;
    function FimJogo: Boolean;
    procedure LimparTrilha(Trilha: TLayout);
    procedure NovoJogo;
    // declaração das propertys
    Property Power: Double read fPower write setPower;
    Property PowerOn: Boolean read fPowerOn write setPowerOn;
    Property Fase: Integer read getFase;
    Property Placar: Double read getPlacar write setPlacar;
  end;

var
  FPrincipal: TFPrincipal;
//  Placar: Double;
  Nivel: Integer;

implementation

// declaração de bibliotecas.
uses GameClasses, Math;

{$R *.fmx}

{ TFPrincipal }

procedure TFPrincipal.btLevel1Click(Sender: TObject);
begin
// define nível de dificuldade em bits,
// baseado em qual botão se mantem afundado.
  if btLevel1.IsPressed then
    Nivel := 7
  else if btLevel2.IsPressed then
    Nivel := 9
  else
    Nivel := 11;

// reinicia partida
  NovoJogo;
end;

procedure TFPrincipal.btNovoJogoClick(Sender: TObject);
begin
  NovoJogo;
  // recolhe painel de menu
  MultiView1.HideMaster;
end;

function TFPrincipal.FimJogo: Boolean;
var
  Peca1, Peca2, Peca3, Peca4, Peca5: TRectangle;
begin
  // Falso é a resposta padrão
  Result := False;

  // captura ultima peça de cada trilha
  Peca1 := TRectangle(layTrilha1.Children[layTrilha1.ChildrenCount-1]);
  Peca2 := TRectangle(layTrilha2.Children[layTrilha2.ChildrenCount-1]);
  Peca3 := TRectangle(layTrilha3.Children[layTrilha3.ChildrenCount-1]);
  Peca4 := TRectangle(layTrilha4.Children[layTrilha4.ChildrenCount-1]);
  Peca5 := TRectangle(layTrilha5.Children[layTrilha5.ChildrenCount-1]);

  // verifica se todas as ultimas peças atingiram o limite da trilha
  if (Peca1.Position.Y + Peca1.Height > layTrilha1.Height) and // trilha 1
     (Peca2.Position.Y + Peca2.Height > layTrilha2.Height) and // trilha 2
     (Peca3.Position.Y + Peca3.Height > layTrilha3.Height) and // trilha 3
     (Peca4.Position.Y + Peca4.Height > layTrilha4.Height) and // trilha 4
     (Peca5.Position.Y + Peca5.Height > layTrilha5.Height) then // trilha 5
  begin
    Result := True; // sinaliza fim de jogo.
  end

end;

procedure TFPrincipal.FormCreate(Sender: TObject);
begin
// reinicia placar
  Placar := 0;
  lblScore.Text := Format('%f', [Placar]);

// grava tempo das animações (velocidade do jogo)
  AniTime := TkbDuracaoAnime.Value;

// Define Nível inicial
  Nivel := 9; // 9 bits.

// Gera valores para as peças a serem jogadas
  recPeca.Value := GerarValor(Nivel); // 7 bits - até 128
  recProximaPeca.Value := GerarValor(Nivel); // 7 bits - até 128

// Inicia valor de Poder de Bomba
  Power := 100;

end;

function TFPrincipal.GerarValor(Limite: Integer): Single;
begin
// calcula uma 2^x aleatoria de 1 até Limite.
  Result := Math.Power(2, RandomRange(1,Limite));
end;

function TFPrincipal.getFase: Integer;
begin
// Floor arredonda a divisão para baixo
  Result := Floor(Placar/2048);
end;

function TFPrincipal.getPlacar: Double;
begin
  Result := FPlacar;
end;

procedure TFPrincipal.layBombaClick(Sender: TObject);
begin
// liga/desliga do poder
  PowerOn := not PowerOn;
end;

procedure TFPrincipal.layTrilha1DblClick(Sender: TObject);
var
  LPeca : TRectangle;
  LTrilha: TLayout;
  I: Integer;
begin
// Armazena a trilha que disparou o evento
  LTrilha := TLayout(Sender);
// Cria uma duplicata da peça atual
  LPeca := TRectangle(recPeca.Clone(self));
// Posiciona duplicata sobre a trilha jogada
  LPeca.Parent := LTrilha;
// Remove alinhamento da peça para que a mesma tenha movimentos livres
  LPeca.Align := TAlignLayout.None;
// Posiciona a peça no começo da trilha escolhida.
  LPeca.Position.Y := LTrilha.Height+70;
// Altera os valores das proximas peças a serem jogadas
  recPeca.Value := recProximaPeca.Value;
  recProximaPeca.Value := GerarValor(Nivel);

// Associação da função de Poder no evento OnClick da peça
  LPeca.OnClick := PecaClick;

// Anima a peça ao longo da trilha
  TAnimation.Animate(LPeca, 'Position.Y', ((LPeca.Line-1)*(LPeca.Height+5)), ANITIME)
    .AnimeType(TAnimationType.Out)
    .AnimeInterpolation(TInterpolationType.Quadratic)
// Ao concluir a animação, executa função anônima
    .AnimeFinish(
      procedure (Sender: TObject) var R:Integer; begin
      // Teste de colisão da peça e peças subsequentes (sempre de baixo p/cima)
        Placar := Placar+LPeca.CheckHit(
                                        Procedure begin
                                          RealocarPalco;
                                        end);
        RealocarPalco;

      // Alteração do placar
        lblScore.Text := Format('%f', [Placar]);

      // verifica fim de jogo
        if FimJogo then begin
          ShowMessage('Fim de jogo');
        end;
      end)

    .Start;
end;

procedure TFPrincipal.layTrilha1Gesture(Sender: TObject;
  const EventInfo: TGestureEventInfo; var Handled: Boolean);
begin

  case  EventInfo.GestureID of
  // caso gesto lido seja o deslisar de baixo p/ cima
    sgiUp: begin
    // chama a execução da função
      layTrilha1DblClick(Sender);
    end;
  end;

end;

procedure TFPrincipal.layTrilha1Tap(Sender: TObject; const Point: TPointF);
begin
// Chama a execução da função
  layTrilha1DblClick(sender);
end;

procedure TFPrincipal.LimparTrilha(Trilha: TLayout);
var
  I: Integer;
begin
// Percorre as peças da trilha de baixo para cima
  for I := Trilha.ChildrenCount-1 downto 1 do begin
    Trilha.Children[I].DisposeOf; // Destroi a peça
  end;

end;

procedure TFPrincipal.NovoJogo;
begin
// Gera novos valores para as proximas peças
  recPeca.Value        := GerarValor(7);
  recProximaPeca.Value := GerarValor(7);

// Limpa todas as peças do palco
  LimparTrilha(layTrilha1);
  LimparTrilha(layTrilha2);
  LimparTrilha(layTrilha3);
  LimparTrilha(layTrilha4);
  LimparTrilha(layTrilha5);

// Zera placar
  Placar:= 0;
  lblScore.Text := Format('%f', [Placar]);
end;

procedure TFPrincipal.PecaClick(Sender: TObject);
var
  LPeca: TRectangle;
begin
  if PowerOn then begin
    LPeca := TRectangle(Sender);

    // se quantidade de poder maior que valor da peça, explode
    if LPeca.Value <= Power then begin
      Power := Power - LPeca.Value; // subtrai valor do poder

      // animações de explosão da peça
      TAnimation.Animate(LPeca, 'Opacity', 0.1, ANITIME)
        .AnimeType(TAnimationType.In)
        .AnimeInterpolation(TInterpolationType.Cubic)
        .Start;
      TAnimation.Animate(LPeca, 'Width', 80, ANITIME)
        .AnimeType(TAnimationType.In)
        .AnimeInterpolation(TInterpolationType.Cubic)
        .Start;
      TAnimation.Animate(LPeca, 'Height', 80, ANITIME)
        .AnimeType(TAnimationType.In)
        .AnimeInterpolation(TInterpolationType.Cubic)
        .Start;
      TAnimation.Animate(LPeca, 'Position.Y', LPeca.Position.y-10, ANITIME)
        .AnimeType(TAnimationType.In)
        .AnimeInterpolation(TInterpolationType.Cubic)
        .Start;
      TAnimation.Animate(LPeca, 'Position.X', LPeca.Position.y-10, ANITIME)
        .AnimeType(TAnimationType.In)
        .AnimeInterpolation(TInterpolationType.Cubic)
        .AnimeFinish(
          procedure (Sender: TObject) begin
            Sender.DisposeOf; // destroi peça
          end)
        .Start;
    end
    else begin
      PowerOn := false; // desliga poder
    end;
  end;

end;

procedure TFPrincipal.RealocarPalco;
var
  LPeca: TRectangle;
  I: Integer;
begin
// Reposiciona todas as peças da trilha 1
  for I := 1 to layTrilha1.ChildrenCount-1 do begin
    LPeca := TRectangle(layTrilha1.Children[I]); // Ponteiro para peça atual
    // Se a peça não estiver em processo de destruição (ponto)
    if not (csDestroying in LPeca.ComponentState) then
      LPeca.Position.Y := ((LPeca.Line-1)*(LPeca.Height+5)); // reposiciona peça
  end;
// Reposiciona todas as pelas da trilha 2
  for I := 1 to layTrilha2.ChildrenCount-1 do begin
    LPeca := TRectangle(layTrilha2.Children[I]);
    if not (csDestroying in LPeca.ComponentState) then
      LPeca.Position.Y := ((LPeca.Line-1)*(LPeca.Height+5));
  end;
// Reposiciona todas as pelas da trilha 3
  for I := 1 to layTrilha3.ChildrenCount-1 do begin
    LPeca := TRectangle(layTrilha3.Children[I]);
    if not (csDestroying in LPeca.ComponentState) then
      LPeca.Position.Y := ((LPeca.Line-1)*(LPeca.Height+5));
  end;
// Reposiciona todas as pelas da trilha 4
  for I := 1 to layTrilha4.ChildrenCount-1 do begin
    LPeca := TRectangle(layTrilha4.Children[I]);
    if not (csDestroying in LPeca.ComponentState) then
      LPeca.Position.Y := ((LPeca.Line-1)*(LPeca.Height+5));
  end;
// Reposiciona todas as pelas da trilha 5
  for I := 1 to layTrilha5.ChildrenCount-1 do begin
    LPeca := TRectangle(layTrilha5.Children[I]);
    if not (csDestroying in LPeca.ComponentState) then
      LPeca.Position.Y := ((LPeca.Line-1)*(LPeca.Height+5));
  end;
end;

procedure TFPrincipal.setPlacar(const Value: Double);
var
  LFase: Integer;
  LPowerInc: Integer;
begin
  LFase := Fase; // backup fase
  // altera placar (logo altera a fase também)
  FPlacar := Value;
  lblFase.Text := Format('(%d)', [Fase]);

  // se houver troca de fase, incrementa poder de bomba
  if Fase <> LFase then begin
  // incrementa mais ou menos dependendo
  // do nível de dificuldade
    case Nivel of
      7:  LPowerInc := 64;
      9:  LPowerInc := 32;
      11: LPowerInc := 16;
    end;
    Power := Power+LPowerInc; // faz o incremento
  end;

// utiliza multiplos para diminuir digitos do placar
  if Value <= Math.Power(2,11) then
    lblScore.Text := FormatFloat('#,###,###', value)
  else
    lblScore.Text := FormatFloat('#,###,###.000', value/1024)+' K'

end;

procedure TFPrincipal.setPower(const Value: Double);
begin
  fPower := Value;
// acumulo do poder - formata valores grandes
  lblBomba.Text := FormatFloat('#,###',value);
end;

procedure TFPrincipal.setPowerOn(const Value: Boolean);
begin
  fPowerOn := Value;
  if fPowerOn then
    pthBomba.Fill.Color := TAlphaColors.Crimson // muda cor para vermelho
  else
    pthBomba.Fill.Color := TAlphaColors.Azure; // muda a cor para cinza claro

// muda a cor da fonte para ficar igual a cor do icone
  lblBomba.FontColor := pthBomba.Fill.Color;
end;

// fim da função RealocarPalco

procedure TFPrincipal.tkbDuracaoAnimeChange(Sender: TObject);
begin
// Exibe velocidade na label
  lblDuracaoAnime.Text := Format('%2.f S', [tkbDuracaoAnime.Value]);
// Grava nova duração das animações. (util para depuração do jogo)
  AniTime := TkbDuracaoAnime.Value;
end;

end.
