programme premiertest2:

var ent n, min, max, y;

	
debut
	
n := 0;
y := 0;
min := 0;
max := 0;
	
	si n=0 alors min:=y; max:=y
	sinon si y<min alors min:=y sinon si y>max alors max:=y fsi fsi
	fsi;
	n:=n+1;
		
fin

