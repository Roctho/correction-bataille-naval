
program Bataille_Navale_Prof;

uses crt,sysutils;

CONST
	NBBATEAU=2;	
	MAXCASE=4;	
	MINL=1;	
	MAXL=10;	
	MINC=1;	
	MAXC=10;	

Type
	positionBateau=(enLigne,enColonne,enDiag);	
	etatBateau=(toucher,couler);	
	etatFlotte=(aFlot,aSombrer);	
	etatJoueur=(gagne,perd);	


type
	cellule=record
		ligne:integer;
		col:integer;
	end;
	
	bateau=record
		nCase:array [1..MAXCASE] of cellule;
		taille:integer;
	end;
	
	flotte=record
		nBateau:array [1..NBBATEAU] of bateau;
	end;
	


function tailleBateau(nBateau:bateau):integer;
var
	i:integer; 
	cpt:integer;	
begin
	cpt:=0;

	for i:=1 to MAXCASE do
	begin
		
		if (nBateau.nCase[i].ligne<>0) or (nBateau.nCase[i].col<>0) then
			cpt:=cpt+1;
	end;
	
	tailleBateau:=cpt;
end;



function etatBat(nBateau:bateau):etatBateau;
var
	etat:integer;	
begin
	etat:=tailleBateau(nBateau);
	if (etat<nBateau.taille) and (etat>0) then etatBat:=toucher
	else if (etat=0) then etatBat:=couler;
end;



function etatFlot(player:flotte):etatFlotte;
var
	i:integer;	
	cpt:integer;	
begin
	cpt:=0;

	for i:=1 to NBBATEAU do
	begin
		
		if (etatBat(player.nBateau[i])=couler) then	cpt:=cpt+1;
	end;
	
	if cpt=NBBATEAU then etatFlot:=aSombrer
	else
		etatFlot:=aFlot;
end;




PROCEDURE CreateCase(l,c:integer; VAR nCellule:cellule);
begin
	nCellule.ligne:=l;
	nCellule.col:=c;
end;



FUNCTION cmpCase(nCellule,tCellule:cellule):boolean;
begin
	if ((nCellule.col=tCellule.col) and (nCellule.ligne=tCellule.ligne)) then
		cmpCase:=true
	else
		cmpCase:=false;
end;



FUNCTION createBateau(nCellule:cellule; taille:integer):bateau;
var
	res:bateau;	
	posBateau:positionBateau;	
	i:integer;	
	pos:integer;	

begin
	
	pos:=Random(3);
	posBateau:=positionBateau(pos);
	res.taille:=taille;
	
	for i:=1 to MAXCASE do
	begin
		
		if (i<=taille) then
		begin
			res.nCase[i].ligne:=nCellule.ligne;
			res.nCase[i].col:=nCellule.col;
		end
		else
		begin
			res.nCase[i].ligne:=0;
			res.nCase[i].col:=0;
		end;
		
		if (posBateau=enLigne) then
			nCellule.col:=nCellule.col+1
		else
			
			if (posBateau=enColonne) then
				nCellule.ligne:=nCellule.ligne+1
			else
				
				if (posBateau=enDiag) then
				begin
					nCellule.ligne:=nCellule.ligne+1;
					nCellule.col:=nCellule.col+1;
				end;
	end;

	createBateau:=res;
end;



procedure fPlayer (var nBateau:bateau;var nCellule:cellule);
begin
	
	repeat
		nBateau.taille:=Random(MAXCASE)+3;
	until (nBateau.taille>2) and (nBateau.taille<=MAXCASE);
	
	repeat
		CreateCase((Random(MAXL)+MINL),(Random(MAXC)+MINL),nCellule);
	until (nCellule.ligne>=MINL) and (nCellule.ligne<=MAXL-nBateau.taille) and (nCellule.col>=MINC) and (nCellule.col<=MAXC-nBateau.taille);

	nBateau:=createBateau(nCellule,nBateau.taille);
end;



procedure initfPlayer(var player:flotte; nCellule:cellule);
var
  i,j:integer;	
begin
	for i:=1 to NBBATEAU do
	begin
		fPlayer(player.nBateau[i],nCellule);
		
		
		
		 for j:=1 to MAXCASE do 
			begin 
			end; 
	end;
end;



procedure attaquerBateau(var player:flotte);
var
	nCellule:cellule;	
	test:boolean;	
	i,j:integer;
begin
	
	repeat
		writeln('Entrez la ligne [1-10]');
		readln(nCellule.ligne);
		if (nCellule.ligne<1) or (nCellule.ligne>50) then writeln('erreur [1-10]');
	until (nCellule.ligne>0) and (nCellule.ligne<=50);
	
	repeat
		writeln('Entrez la colonne [1-10]');
		readln(nCellule.col);
		if (nCellule.col<1) or (nCellule.col>50) then writeln('erreur [1-10]');
	until (nCellule.col>0) and (nCellule.col<=50);
	
	for i:=1 to NBBATEAU do
	begin
		for j:=1 to player.nBateau[i].taille do
		begin
			test:=false;
			
			test:=cmpCase(nCellule,player.nBateau[i].nCase[j]);
		
			if test then
			begin
				writeln('touche ! ');
				CreateCase(0,0,player.nBateau[i].nCase[j]);
				if etatBat(player.nBateau[i])=couler then writeln('couler ! ');
			end;
		end;
	
	end;
end;



var
	nCellule:cellule;
	i:integer;	
	joueur1,joueur2:flotte;	
	etat1,etat2:etatJoueur;	
	etatfl1,etatfl2:etatFlotte;	

	
begin
	clrscr;
	randomize;
	etat1:=gagne;
	etat2:=gagne;
	etatfl1:=aFlot;
	etatfl2:=aFlot;
	
	initfPlayer(joueur1,nCellule);
	initfPlayer(joueur2,nCellule);
	

	repeat
		
		
		if (etat1=gagne) and (etat2=gagne) then
		begin
			writeln('Joueur 1 : ');
			attaquerBateau(joueur1);
		end;
		
		etatfl1:=etatFlot(joueur1);		
		
		
		if etatfl1=aSombrer then
			etat2:=perd;
		
		if (etat1=gagne) and (etat2=gagne) then
		begin
			writeln('Joueur 2 : ');
			attaquerBateau(joueur2);
		end;
			
		etatfl2:=etatFlot(joueur2);
		
		
		if etatfl2=aSombrer then
			etat1:=perd;
		
	until ((etat1=perd) or (etat2=perd)) and ((etatfl1=aSombrer) or (etatfl2=aSombrer));
	
	if etat1=perd then writeln('Joueur 2 a gagner')
	else writeln('Joueur 1 a gagner');
	
	readln;
end.




