unit uPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.Layouts;

type
  TZ = class(TForm)
    recFundo: TRectangle;
    layTitulo: TLayout;
    btnMenu: TButton;
    lbScore: TLabel;
    lbFase: TLabel;
    lbTitulo: TLabel;
    lbIX: TLabel;
    layConteudo: TLayout;
    layControles: TLayout;
    recPecaBorda: TRectangle;
    recPecaFundo: TRectangle;
    lbPecaValor: TLabel;
    recPeca: TRectangle;
    recProximaPecaBorda: TRectangle;
    recProximaPeca: TRectangle;
    lbProximaPeca: TLabel;
    recProximaPecaFundo: TRectangle;
    layBomba: TLayout;
    recBomba: TRectangle;
    phtBomba: TPathLabel;
    lblBomba: TLabel;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Z: TZ;

implementation

{$R *.fmx}

procedure TZ.Button1Click(Sender: TObject);
begin
  ShowMessage('Douglas Marques');
end;

end.
