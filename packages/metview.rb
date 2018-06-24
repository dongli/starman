class Metview < Package
  url 'https://software.ecmwf.int/wiki/download/attachments/3964985/Metview-5.1.0-Source.tar.gz?api=v2'
  sha256 '32be5bfe8acb46bce83dad6e73d5db54b730d679eac1de49e5dbbe551e16a0d9'

  label :common

  depends_on :proj
  depends_on :netcdf
  depends_on 'odb-api'
  depends_on :eccodes
  depends_on :emoslib
  depends_on :magics

  patch :DATA

  def install
    args = std_cmake_args
    args << '-DENABLE_QT5=On'
    args << '-DENABLE_ODB=On'
    args << "-DECCODES_PATH=#{Eccodes.link_root}"
    args << "-DEMOS_PATH=#{Emoslib.link_root}"
    args << "-DMAGICS_PATH=#{Magics.link_root}"
    args << "-DNETCDF_PATH=#{Netcdf.link_root}"
    args << "-DODB_API_PATH=#{OdbApi.link_root}"
    args << "-DPROJ4_PATH=#{Proj.link_root}"
    args << "-DCMAKE_PREFIX_PATH=/usr/local/Cellar/qt/5.11.1" if OS.mac?
    mkdir 'build' do
      run 'cmake', '..', *args
      run 'make'
      run 'make', 'install'
    end
  end
end

__END__
diff --git a/src/libMetview/Box.cc b/src/libMetview/Box.cc
index 602e984..cbb6332 100644
--- a/src/libMetview/Box.cc
+++ b/src/libMetview/Box.cc
@@ -14,6 +14,8 @@
 #define TRUE 1
 #define FALSE 0
 
+const float maxfloat = 3.4E+35;
+
 Box :: Box(const Box& r) : _bll(r._bll), _bur(r._bur) {}
 
 Box :: Box (const Point& o, const Point& c)
@@ -115,12 +117,12 @@ Box :: remap (SProjection* in, SProjection* out)
 		x2 = _bur.x(),
 		y1 = _bll.y(),
 		y2 = _bur.y(),
-		xmin = MAXFLOAT,
-		xmax = -MAXFLOAT,
-		ymin = MAXFLOAT,
-		ymax = -MAXFLOAT;
+		xmin = maxfloat,
+		xmax = -maxfloat,
+		ymin = maxfloat,
+		ymax = -maxfloat;
 
-	float  bigval = MAXFLOAT / 10.;
+	float  bigval = maxfloat / 10.;
 
 	Point	p;
 	step = (x2 - x1)/NSTEPS;
@@ -224,10 +226,10 @@ Box :: remap (SProjection* in, SProjection* out)
 
 	_bll.x(xmin);
 	_bll.y(ymin);
-	if (_bll.tooBig ()) _bll.init (-MAXFLOAT,-MAXFLOAT);
+	if (_bll.tooBig ()) _bll.init (-maxfloat,-maxfloat);
 	_bur.x(xmax);
 	_bur.y(ymax);
-	if (_bur.tooBig ()) _bur.init (MAXFLOAT,MAXFLOAT);
+	if (_bur.tooBig ()) _bur.init (maxfloat,maxfloat);
 
 	return;
 }
@@ -241,10 +243,10 @@ Box :: remap (SProjection* out)
 		x2 = _bur.x(),
 		y1 = _bll.y(),
 		y2 = _bur.y(),
-		xmin = MAXFLOAT,
-		xmax = -MAXFLOAT,
-		ymin = MAXFLOAT,
-		ymax = -MAXFLOAT;
+		xmin = maxfloat,
+		xmax = -maxfloat,
+		ymin = maxfloat,
+		ymax = -maxfloat;
 	Point	p;
 	step = (x2 - x1)/NSTEPS;
 	for (aux = x1; aux < x2; aux += step)
@@ -253,7 +255,7 @@ Box :: remap (SProjection* out)
 		p.x(aux);
 		p.y(y1);
 		p = out->LL2PC(p);
-		if ( p.x() < (MAXFLOAT / 10.) ) 
+		if ( p.x() < (maxfloat / 10.) ) 
 		{
 			/* search for minimum and maximum coordinates,*/
 			/* if a valid remapped point is calculated */
@@ -272,7 +274,7 @@ Box :: remap (SProjection* out)
 		p.x(aux);
 		p.y(y2);
 		p = out->LL2PC(p);
-		if ( p.x() < (MAXFLOAT / 10.) ) 
+		if ( p.x() < (maxfloat / 10.) ) 
 		{
 			/* search for minimum and maximum coordinates,*/
 			/* if a valid remapped point is calculated */
@@ -295,7 +297,7 @@ Box :: remap (SProjection* out)
 		p.x(x1);
 		p.y(aux);
 		p = out->LL2PC(p);
-		if ( p.x() < (MAXFLOAT / 10.) ) 
+		if ( p.x() < (maxfloat / 10.) ) 
 		{
 			/* search for minimum and maximum coordinates,*/
 			/* if a valid remapped point is calculated */
@@ -314,7 +316,7 @@ Box :: remap (SProjection* out)
 		p.x(x2);
 		p.y(aux);
 		p = out->LL2PC(p);
-		if ( p.x() < (MAXFLOAT / 10.) ) 
+		if ( p.x() < (maxfloat / 10.) ) 
 		{
 			/* search for minimum and maximum coordinates,*/
 			/* if a valid remapped point is calculated */
diff --git a/src/libMetview/proj_braz.cc b/src/libMetview/proj_braz.cc
index 9dec7ec..e4100e1 100644
--- a/src/libMetview/proj_braz.cc
+++ b/src/libMetview/proj_braz.cc
@@ -20,6 +20,9 @@
 #include <math.h>
 #include "proj_braz.hpp"
 
+const float maxfloat = 3.4E+35;
+const float bigfloat = 3.4E+35;
+
 static Datum			*D;
 static SProjection		*Sp1,*Sp2;
 static GeneralProjection	*Gp1,*Gp2;
@@ -89,10 +92,10 @@ void pBBoxRemapInOut (SProjection *In, SProjection *Out, BBox *B)
 	x2 = B->Bur.X,
 	y1 = B->Bll.Y,
 	y2 = B->Bur.Y,
-	xmin = MAXFLOAT,
-	xmax = -MAXFLOAT,
-	ymin = MAXFLOAT,
-	ymax = -MAXFLOAT;
+	xmin = maxfloat,
+	xmax = -maxfloat,
+	ymin = maxfloat,
+	ymax = -maxfloat;
 	CPoint	p;
 	step = (x2 - x1)/NSTEPS;
 	for (aux = x1; aux < x2; aux += step)
@@ -101,10 +104,10 @@ void pBBoxRemapInOut (SProjection *In, SProjection *Out, BBox *B)
 		p.X = aux;
 		p.Y = y1;
 		p = pPC2LL(In,p);
-		if ( p.X < (MAXFLOAT / 10.) )
+		if ( p.X < (maxfloat / 10.) )
 		{
 			p = pLL2PC(Out,p);
-			if ( p.X < (MAXFLOAT / 10.) )
+			if ( p.X < (maxfloat / 10.) )
 			{
 				/* search for minimum and maximum coordinates,*/
 				/* if a valid remapped point is calculated */
@@ -123,10 +126,10 @@ void pBBoxRemapInOut (SProjection *In, SProjection *Out, BBox *B)
 		p.X = aux;
 		p.Y = y2;
 		p = pPC2LL(In,p);
-		if ( p.X < (MAXFLOAT / 10.) )
+		if ( p.X < (maxfloat / 10.) )
 		{
 			p = pLL2PC(Out,p);
-			if ( p.X < (MAXFLOAT / 10.) )
+			if ( p.X < (maxfloat / 10.) )
 			{
 				/* search for minimum and maximum coordinates,*/
 				/* if a valid remapped point is calculated */
@@ -150,10 +153,10 @@ void pBBoxRemapInOut (SProjection *In, SProjection *Out, BBox *B)
 		p.X = x1;
 		p.Y = aux;
 		p = pPC2LL(In,p);
-		if ( p.X < (MAXFLOAT / 10.) )
+		if ( p.X < (maxfloat / 10.) )
 		{
 			p = pLL2PC(Out,p);
-			if ( p.X < (MAXFLOAT / 10.) )
+			if ( p.X < (maxfloat / 10.) )
 			{
 				/* search for minimum and maximum coordinates,*/
 				/* if a valid remapped point is calculated */
@@ -173,10 +176,10 @@ void pBBoxRemapInOut (SProjection *In, SProjection *Out, BBox *B)
 		p.X = x2;
 		p.Y = aux;
 		p = pPC2LL(In,p);
-		if ( p.X < (MAXFLOAT / 10.) )
+		if ( p.X < (maxfloat / 10.) )
 		{
 			p = pLL2PC(Out,p); 
-			if ( p.X < (MAXFLOAT / 10.) )
+			if ( p.X < (maxfloat / 10.) )
 			{
 				/* search for minimum and maximum coordinates,*/
 				/* if a valid remapped point is calculated */
@@ -197,15 +200,15 @@ void pBBoxRemapInOut (SProjection *In, SProjection *Out, BBox *B)
 	B->Bll.Y = ymin;
 	if (pTooBig(&B->Bll))
 	{
-		B->Bll.X = -MAXFLOAT;
-		B->Bll.Y = -MAXFLOAT;
+		B->Bll.X = -maxfloat;
+		B->Bll.Y = -maxfloat;
 	}
 	B->Bur.X = xmax;
 	B->Bur.Y = ymax;
 	if (pTooBig(&B->Bll))
 	{
-		B->Bur.X = MAXFLOAT;
-		B->Bur.Y = MAXFLOAT;
+		B->Bur.X = maxfloat;
+		B->Bur.Y = maxfloat;
 	}
 
 	return;
@@ -219,10 +222,10 @@ void pBBoxRemap (SProjection *Out, BBox *B)
 	x2 = B->Bur.X,
 	y1 = B->Bll.Y,
 	y2 = B->Bur.Y,
-	xmin = MAXFLOAT,
-	xmax = -MAXFLOAT,
-	ymin = MAXFLOAT,
-	ymax = -MAXFLOAT;
+	xmin = maxfloat,
+	xmax = -maxfloat,
+	ymin = maxfloat,
+	ymax = -maxfloat;
 	CPoint	p;
 	step = (x2 - x1)/NSTEPS;
 	for (aux = x1; aux < x2; aux += step)
@@ -231,7 +234,7 @@ void pBBoxRemap (SProjection *Out, BBox *B)
 		p.X = aux;
 		p.Y = y1;
 		p = pLL2PC(Out,p);
-		if ( p.X < (MAXFLOAT / 10.) )
+		if ( p.X < (maxfloat / 10.) )
 		{
 				/* search for minimum and maximum coordinates,*/
 				/* if a valid remapped point is calculated */
@@ -249,7 +252,7 @@ void pBBoxRemap (SProjection *Out, BBox *B)
 		p.X = aux;
 		p.Y = y2;
 		p = pLL2PC(Out,p);
-		if ( p.X < (MAXFLOAT / 10.) )
+		if ( p.X < (maxfloat / 10.) )
 		{
 				/* search for minimum and maximum coordinates,*/
 				/* if a valid remapped point is calculated */
@@ -272,7 +275,7 @@ void pBBoxRemap (SProjection *Out, BBox *B)
 		p.X = x1;
 		p.Y = aux;
 		p = pLL2PC(Out,p);
-		if ( p.X < (MAXFLOAT / 10.) )
+		if ( p.X < (maxfloat / 10.) )
 		{
 				/* search for minimum and maximum coordinates,*/
 				/* if a valid remapped point is calculated */
@@ -291,7 +294,7 @@ void pBBoxRemap (SProjection *Out, BBox *B)
 		p.X = x2;
 		p.Y = aux;
 		p = pLL2PC(Out,p);
-		if ( p.X < (MAXFLOAT / 10.) )
+		if ( p.X < (maxfloat / 10.) )
 		{
 				if (p.X < xmin)
 					xmin = p.X;
@@ -660,11 +663,11 @@ void pmvimg_(int* nx, int* ny, unsigned char* buff)
 
 short pTooBig(CPoint *p)
 {
-/* old version: p->* > BIGFLOAT and p->X < -BIGFLOAT, works for SGI 
+/* old version: p->* > bigfloat and p->X < -bigfloat, works for SGI 
    but not for Linux */
 
-	return ( p->X >= BIGFLOAT || p->Y >= BIGFLOAT || p->X <= -BIGFLOAT
-	||   p->Y <= -BIGFLOAT );
+	return ( p->X >= bigfloat || p->Y >= bigfloat || p->X <= -bigfloat
+	||   p->Y <= -bigfloat );
 }
 
 short pPointOnLine(SImage *Im, CPoint *p, CPoint *q, CPoint *w)
@@ -912,7 +915,7 @@ void ChangeLL(SProjection *Sp, double *lon1, double *lat1)
 	z1 = (n1*(1-equad1))*sin(*lat1);
 
 	/* Geocentric cartesian coordinates calculation - datum 2 */
-	if (Pdx == MAXFLOAT || Sp->Pout->Pdx == MAXFLOAT)
+	if (Pdx == maxfloat || Sp->Pout->Pdx == maxfloat)
 	{
 		x2 = x1; 
 		y2 = y1;
@@ -951,12 +954,12 @@ CPoint pSatLL2PC(SProjection *Sp, CPoint ptll)
 	double Pflt,Prd;
 
 	CPoint ppc;
-/* Check if ptll contains MAXFLOAT */
+/* Check if ptll contains maxfloat */
 
 	if (pTooBig(&ptll))
 	{
-		ppc.X = MAXFLOAT;
-		ppc.Y = MAXFLOAT;
+		ppc.X = maxfloat;
+		ppc.Y = maxfloat;
 		return ppc;
 	}
 
@@ -992,8 +995,8 @@ CPoint pSatLL2PC(SProjection *Sp, CPoint ptll)
 	/* Visibility test */
 	if ( x < 0.0 )
 	{
-		ppc.X = MAXFLOAT;
-		ppc.Y = MAXFLOAT;
+		ppc.X = maxfloat;
+		ppc.Y = maxfloat;
 		return ppc;
 	}
 	else
@@ -1017,8 +1020,8 @@ CPoint pSatLL2PC(SProjection *Sp, CPoint ptll)
 
 		if ( fabs(x-x1) > 1.0 )
 		{
-			ppc.X = MAXFLOAT;
-			ppc.Y = MAXFLOAT;
+			ppc.X = maxfloat;
+			ppc.Y = maxfloat;
 			return ppc;
 		}
 	}
@@ -1095,8 +1098,8 @@ CPoint pSatPC2LL(SProjection *Sp, CPoint ptpc)
 	v = (b*b) - (4.*a*c);
 	if (v < 0)
 	{
-		ppc.X = MAXFLOAT;
-		ppc.Y = MAXFLOAT;
+		ppc.X = maxfloat;
+		ppc.Y = maxfloat;
 		return ppc;
 	}
 
@@ -1587,27 +1590,27 @@ quadrants and try interpolating again */
 	    !pPointOnLine (Imi,&pill,&piul,&pil))
 	{
 		XXX++;
-		if (pTooBig (&piu)) pInitPoint (&piu,MAXFLOAT,MAXFLOAT);
-		if (pTooBig (&pil)) pInitPoint (&pil,-MAXFLOAT,-MAXFLOAT);
-		if (pTooBig (&pim)) pInitPoint (&pim,MAXFLOAT,-MAXFLOAT);
+		if (pTooBig (&piu)) pInitPoint (&piu,maxfloat,maxfloat);
+		if (pTooBig (&pil)) pInitPoint (&pil,-maxfloat,-maxfloat);
+		if (pTooBig (&pim)) pInitPoint (&pim,maxfloat,-maxfloat);
 		pInterpolateIn (Imi, Imo, pol, pou, poul, pom, pil, piu, piul, pim);
 
 	/*		printf ("Quadrant 2 - Level %d",XXX); */
-		if (pTooBig (&piu)) pInitPoint (&piu,-MAXFLOAT,MAXFLOAT);
-		if (pTooBig (&pim)) pInitPoint (&pim,-MAXFLOAT,-MAXFLOAT);
-		if (pTooBig (&pir)) pInitPoint (&pir,MAXFLOAT,-MAXFLOAT);
+		if (pTooBig (&piu)) pInitPoint (&piu,-maxfloat,maxfloat);
+		if (pTooBig (&pim)) pInitPoint (&pim,-maxfloat,-maxfloat);
+		if (pTooBig (&pir)) pInitPoint (&pir,maxfloat,-maxfloat);
 		pInterpolateIn (Imi, Imo, pom, pour, pou, por, pim, piur, piu, pir);
 
 	/*		printf ("Quadrant 3 - Level %d",XXX); */
-		if (pTooBig (&pil)) pInitPoint (&pil,-MAXFLOAT,MAXFLOAT);
-		if (pTooBig (&pim)) pInitPoint (&pim,MAXFLOAT,MAXFLOAT);
-		if (pTooBig (&pib)) pInitPoint (&pib,MAXFLOAT,-MAXFLOAT);
+		if (pTooBig (&pil)) pInitPoint (&pil,-maxfloat,maxfloat);
+		if (pTooBig (&pim)) pInitPoint (&pim,maxfloat,maxfloat);
+		if (pTooBig (&pib)) pInitPoint (&pib,maxfloat,-maxfloat);
 		pInterpolateIn (Imi, Imo, poll, pom, pol, pob, pill, pim, pil, pib);
 
 	/*		printf ("Quadrant 4 - Level %d",XXX); */
-		if (pTooBig (&pim)) pInitPoint (&pim,-MAXFLOAT,MAXFLOAT);
-		if (pTooBig (&pir)) pInitPoint (&pir,MAXFLOAT,MAXFLOAT);
-		if (pTooBig (&pib)) pInitPoint (&pib,-MAXFLOAT,-MAXFLOAT);
+		if (pTooBig (&pim)) pInitPoint (&pim,-maxfloat,maxfloat);
+		if (pTooBig (&pir)) pInitPoint (&pir,maxfloat,maxfloat);
+		if (pTooBig (&pib)) pInitPoint (&pib,-maxfloat,-maxfloat);
 		pInterpolateIn (Imi, Imo, pob, por, pom, polr, pib, pir, pim, pilr);
 
 		XXX--;
@@ -1780,32 +1783,32 @@ void pRemapI (SImage *Imi, SImage *Imo)
 	else
 	{
 		piul = pPC2LL (Imo->IProj,poul);
-		if (pTooBig(&piul)) pInitPoint(&piul,-MAXFLOAT,MAXFLOAT);
+		if (pTooBig(&piul)) pInitPoint(&piul,-maxfloat,maxfloat);
 		else
 		{
 			piul = pLL2PC(p,piul);
-			if (pTooBig(&piul)) pInitPoint(&piul,-MAXFLOAT,MAXFLOAT);
+			if (pTooBig(&piul)) pInitPoint(&piul,-maxfloat,maxfloat);
 		}
 		piur = pPC2LL (Imo->IProj,pour);
-		if (pTooBig(&piur)) pInitPoint(&piur,MAXFLOAT,MAXFLOAT);
+		if (pTooBig(&piur)) pInitPoint(&piur,maxfloat,maxfloat);
 		else
 		{
 			piur = pLL2PC(p,piur);
-			if (pTooBig(&piur)) pInitPoint(&piur,MAXFLOAT,MAXFLOAT);
+			if (pTooBig(&piur)) pInitPoint(&piur,maxfloat,maxfloat);
 		}
 		pill = pPC2LL (Imo->IProj,poll);
-		if (pTooBig(&pill)) pInitPoint(&pill,-MAXFLOAT,-MAXFLOAT);
+		if (pTooBig(&pill)) pInitPoint(&pill,-maxfloat,-maxfloat);
 		else
 		{
 			pill = pLL2PC(p,pill);
-			if (pTooBig(&pill)) pInitPoint(&pill,-MAXFLOAT,-MAXFLOAT);
+			if (pTooBig(&pill)) pInitPoint(&pill,-maxfloat,-maxfloat);
 		}
 		pilr = pPC2LL (Imo->IProj,polr);
-		if (pTooBig(&pilr)) pInitPoint(&pilr,MAXFLOAT,-MAXFLOAT);
+		if (pTooBig(&pilr)) pInitPoint(&pilr,maxfloat,-maxfloat);
 		else
 		{
 			pilr = pLL2PC(p,pilr);
-			if (pTooBig(&pilr)) pInitPoint(&pilr,MAXFLOAT,-MAXFLOAT);
+			if (pTooBig(&pilr)) pInitPoint(&pilr,maxfloat,-maxfloat);
 		}
 
 	}
diff --git a/src/libMvQtGui/MvQTreeViewSearchLine.cc b/src/libMvQtGui/MvQTreeViewSearchLine.cc
index c3277da..8437e50 100644
--- a/src/libMvQtGui/MvQTreeViewSearchLine.cc
+++ b/src/libMvQtGui/MvQTreeViewSearchLine.cc
@@ -13,6 +13,7 @@
 #include <QLineEdit>
 #include <QPushButton>
 #include <QTreeView>
+#include <QHeaderView>
 
 #include "MvQTreeViewSearchLine.h"
 #include "TreeModelMatchCollector.h"
