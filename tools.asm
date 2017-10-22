	keep TOOLS***************************************************************** 		           ChemiGS			       ****************************************************************** A Drawing Program for Chemical Structures		       ** (c) 1992-93 by Urs Hochstrasser			       ** Buendtenweg 6			       ** 5105 AUENSTEIN (SWITZERLAND)			       ****************************************************************** Module TOOLS****************************************************************** USES ...*	mcopy	tools.macros	copy	equates.asm****************************************************************	** SUBROUTINES*CrossCursor start	using Globals	move4	gCrossCur,gEditCursor	rtsMarqueeCursor entry	move4 gMarqueeCur,gEditCursor	rtsHandCursor entry	move4 gHandCur,gEditCursor	rtsTextCursor entry	move4 gTextCur,gEditCursor	rtsEraseCursor entry	move4 gEraseCur,gEditCursor	rtsArrowCursor entry	move4 gArrowCur,gEditCursorAdjustCursor entry	brl	pastname	procedure name to be displayed	dc	i2'$7771'	by GSBug...	dw	'AdjustCursor'pastname	anop	lda	newCursor	sta	oldCursor	stz	newCursor	ph4	#0	~FrontWindow	pl4	theWindow	cmp4	theWindow,gDataWin	beq	x0	Edit Win not in front	brl	l2x0	ph4	#0	~GetContentRgn gDataWin	pl4	contentRgn	pha	~PtInRgn #gMainEvt+owhere,contentRgn*	~PtInRect #gMainEvt+owhere,#myRect	pla	beq	l2	Cursor not in edit window	~StartDrawing gDataWin	move4	gMainEvt+owhere,myPoint	***new	~GlobalToLocal #myPoint	***new	pha	~PtInRect #myPoint,#gContentRect	pla	beq l2	inc	newCursor	~SetOrigin #0,#0l2	anop	lda	oldCursor	cmp	newCursor	beq	exit	lda	newCursor	beq	l3	~SetCursor gEditCursor	bra	exitl3	~InitCursorexit	anop	rtscontentRgn ds	4oldCursor ds	2newCursor entry	ds	2theWindow ds	4myPoint	ds	4myRect	dc	i2'20,20,220,120'	end********************************************************************** Tool handlers*doHand	start	using Globals	using TransData	rtsdoErase	entry	rtsdoSingleB entry	~MoveTo xx,yy	~LineTo xx2,yy2	rtsdoDoubleB entry	jsr	MakeMatrix	move4	#doubleBData+2,0	ldx	doubleBDatadloop	stx	count	~BlockMove 0,#px,#8	jsr	TransForm	~MoveTo pxx,pyy	add4	0,#8	~BlockMove 0,#px,#8	jsr	TransForm	~LineTo pxx,pyy	add4	0,#8	ldx count	dbne	x,dloop	rtsdoHatchB	entry	jsr	MakeMatrix	move4	#hatchData+2,0	ldx	hatchDatahloop	stx	count*	~BlockMove 0,#px,#8	ldy	#0	*hloop2	lda	[0],y	*	sta	px,y	*	iny		* Special Agent Cooper	iny		*	cpy	#8	*	bcc	hloop2	*	jsr	TransForm	~MoveTo pxx,pyy	add4	0,#8	~BlockMove 0,#px,#8	jsr	TransForm	~LineTo pxx,pyy	add4	0,#8	ldx count	dbne	x,hloop	rtsdoWedgeB	entry		a somewhat different procedure...	jsr	MakeMatrix	move4	#wedgeBData+2,0	~BlockMove 0,#px,#8	jsr	TransForm	ph4	#0	~OpenPoly	pl4	myPoly	~MoveTo pxx,pyy	add4	0,#8	ldx	wedgeBDatadwloop	stx	count	~BlockMove 0,#px,#8	jsr	TransForm	~LineTo pxx,pyy	add4	0,#8	ldx count	dbne	x,dwloop	~ClosePoly	~PaintPoly myPoly	~FramePoly myPoly	rtsmyPoly	ds	4doCycloPropane entry	jsr	MarqueeCursor	rtsdoCycloPentane entry	jsr	MarqueeCursor	rts               doCycloHexane entry	jsr	MarqueeCursor	rts               doBenzene entry	jsr	MarqueeCursor	rts               doSeat	entry	jsr	MarqueeCursor	rts               doMarquee entry	jsr	dragRect	rtsdoText	entry	lda	fTextFlag	beq	firstTime* test	jsr	EndText	save old LE-text before making newfirstTime anop	lda	#1	sta	fTextFlag	ph4	#0	~LoadResource #kPicResID,#kToolPicID	pl4	toolBar*	_SetField LEditH,#$c8,#KeyFilter,#4*	bra	gaga	_Deref LEditH,LEditPtr	**** new	lda	LEditPtr	*	sta	<0	*	lda	LEditPtr+2	*	sta	<2	*	ldy	#$c8	*	lda	#<KeyFilter	*	sta	[0],y	*	iny		*	iny		*	lda	#^KeyFilter	*	sta	[0],y	*	_Unlock LeditH	**** end new	ph4	#0	*	~NewHandle #2,gMyID,#0,#0	*	pl4	outH	**** new endgaga	anop	lda	gDataWin	ldx	gDataWin+2	jsr	GrowClip	~SysBeep                   	~ShowControl LEditH	~DrawPicture toolBar,#destRect*	lda	gDataWin*	ldx	gDataWin+2*	jsr	ShrinkClip*** Get Text from Loc, if necessary...*** Edit text...exit	rtstoolBar	ds	4destRect dc	i2'0,0,17,640'LEditPtr ds	4textLen	ds	2	***TESTtheText	dc	h'0A4375534F84'	***TEST	dc	h'A53548824F'	***TESTdoDottedB entry	jsr	MakeMatrix	move4	#dottedBData+2,0	ldx	dottedBDatadtloop	stx	count	~BlockMove 0,#px,#8	jsr	TransForm	~MoveTo pxx,pyy	add4	0,#8	~BlockMove 0,#px,#8	jsr	TransForm	~LineTo pxx,pyy	add4	0,#8	ldx count	dbne	x,dtloop	rtsdoTripleB entry	jsr	MakeMatrix	move4	#tripleBData+2,0	ldx	tripleBDatatloop	stx	count	~BlockMove 0,#px,#8	jsr	TransForm	~MoveTo pxx,pyy	add4	0,#8	~BlockMove 0,#px,#8	jsr	TransForm	~LineTo pxx,pyy	add4	0,#8	ldx count	dbne	x,tloop	rtsdoWHatch	entry	jsr	MakeMatrix	move4	#wHatchData+2,0	ldx	wHatchDatawhloop	stx	count	~BlockMove 0,#px,#8	jsr	TransForm	~MoveTo pxx,pyy	add4	0,#8	~BlockMove 0,#px,#8	jsr	TransForm	~LineTo pxx,pyy	add4	0,#8	ldx count	dbne	x,whloop	rtsdoCChain entry		in fact, it's a modified double bond	jsr	MakeMatrix	move4	#cchainData+2,0	ldx	cchainDataccloop	stx	count	~BlockMove 0,#px,#8	jsr	TransForm	~MoveTo pxx,pyy	add4	0,#8	~BlockMove 0,#px,#8	jsr	TransForm	~LineTo pxx,pyy	add4	0,#8	ldx count	dbne	x,ccloop	rtsdoCycloButane entry	jsr	MarqueeCursor	rtsdoCycloPentane2 entry	jsr	MarqueeCursor	rtsdoBenzene2 entry	jsr	MarqueeCursor	rtsdoWheeland entry	jsr	MarqueeCursor	rtsdoBasin	entry	jsr	MarqueeCursor	rts	end* -----------------------------------------------------------------------*EndText	start	using	Globals	lda	fTextFlag	beq	exit	stz	fTextFlag	lda	gDataWin	ldx	gDataWin+2	jsr	GrowClip	~HideControl LEditH	~ShowControl TBarH	~DrawOneCtl TBarH**************************** hier noch was zu tun: Text retten und so*	lda	gDataWin*	ldx	gDataWin+2*	jsr	ShrinkClipexit	rts	endStoreData start	using Globals	stz	fSaved	indicate change to file	ph4	#0	~NewHandle #segSize,gMyID,#0,#0	pl4	gNewLink	~PtrToHand #NewSegment,gNewLink,#segSize	move4	gNewLink,sLink	lda	gToolID	sta	sCMD	~GetPenSize #penSize	move4	penSize,sPenSize	add2	yy,gYoffset	*** even more recent!	add2	yy2,gYoffset	*** Doc -> Window	add2	xx,gXoffset	***	add2	xx2,gXoffset	***	~PtrToHand #TheSegment,gLink,#segSize	move4 gNewLink,gLink	rtspenSize	ds	4	endDoTXEdit	start		;AtomText click handler	using	globals	move4	gTheText,theHandle	ph4	#0	~GetHandleSize theHandle	pl4	hLen	~HandToPtr theHandle,TheText,hLen	lda	txLink	check for last item in list	ora	txLink+2*	beq	newTXItem	lda	txLen	and	#$FF	sta	tLen	~LESetText #txString,tLen,LERecHndl	;noch zu bilden...	rtstheHandle ds	4hLen	ds	4tLen	ds	2LERecHndl ds	4	enddoDataWin start	using Globals	~SetPenSize gPenSize+2,gPenSize	move4	gMainEvt+owhere,myPoint	move4	gMainEvt+owhere,myPoint2	*** New Ruler Stuff	~GlobalToLocal #myPoint2	lda	myPoint2	cmp	#18	ruler heigth	bcs	content*	jsr	HandleRuler	in WINDOWS	jmp	tdExit	*** end ruler stuffcontent	anop*	stz	fShift*	lda	gMainEvt+omodifiers*	and	#shiftKey*	beq	l4*	inc	fShift*l4	anop	pha	~FindControl #gTaskDa2,#gMainEvt+owhere+2,#gmainEvt+owhwere,gDataWin	pl2	gTaskDa3	lda	gTaskDa3*	and	#$FFFF	beq	okContent	jsr	doControls	brl	exit2okContent anop	~StartDrawing gDataWin	~SetPenSize #2,#1	~GlobalToLocal #myPoint	lda	myY	ldx	myX	jsr	gridIt	'grid' the point	sta	yy	stx	xx	*------------------------------------------------------------------------** Tool Dispatch code*	lda	gToolID	bne	l7	jsr	doHand	brl	exitl7	cmp	#1	bne	l8	jsr	doErase	brl	exitl8	cmp	#11	bne	l9	jsr	doMarquee	brl	exitl9	cmp	#12	bne	l10	jsr	doText	brl	exitl10	cmp	#6	bcs	l1	jsr	dragLine	bcs	l11	brl	exitl11	lda	gToolID	asl	a	tax	jsr	(toolTable,x)	jsr	StoreDatatdExit	rtsl1	cmp	#11	bcs	l2	bra	exitl2	cmp	#17	bcc	l3	bra	exitl3	jsr	dragLine	bcc	exit	lda	gToolID	sec	sbc	#11	asl	a	tax	jsr	(toolTable2,x)	jsr	StoreDataexit	~SetOrigin #0,#0exit2	rtsgridIt	anop	pha	txa	lsr	a	lsr	a	ldy	fShift	half grid if SHIFT pressed	bne	g1	lsr	a	lsr	a	asl	a	asl	ag1	asl	a	asl	a	tax	pla	lsr	a	ldy	fShift	bne	g2	lsr	a	lsr	a	asl	a	asl	ag2	asl	a	rtstemp	ds	2dragLine	entry	~SetPenMode #notXOR	~MoveTo xx,yy	move4 point2,oldPoint	~GetMouse #point2	lda	y2	ldx	x2	jsr	gridIt	sta	yy2	stx	xx2	~LineTo xx2,yy2drLoop	lda	point2	cmp	oldPoint	bne	dr1	lda	point2+2	cmp	oldPoint+2	beq	dr2dr1	~LineTo xx,yy	~LineTo xx2,yy2dr2	pha	~StillDown #0	pla	beq	dr3	move4 point2,oldPoint	oldPoint = point2	~GetMouse #point2	lda	y2	ldx	x2	jsr	gridIt	sta	yy2	stx	xx2	brl	drLoopdr3	~LineTo xx,yy	~SetPenMode #modeCopy	lda	xx	test, if p1=p2	cmp	xx2	equal: clear carry (nothing to do	bne	dr4	any more!)	lda	yy	cmp	yy2	bne	dr4	clc		equal!	bra	dr5dr4	sec		not equaldr5	rtsdragRect	entry	~SetPenMode #notXOR	move4	myY,myRect	move4	#0,myrect+4	move4 myY,oldRect	move4 #0,oldRect+4	move4 myRect+4,oldRect+4	~GetMouse #myRect+4	~FrameRect #myRectdrRLoop	lda	myRect+4	cmp	oldRect+4	bne	drR1	lda	myRect+6	cmp	oldRect+6	beq	drR2drR1	~FrameRect #oldRect	~FrameRect #myRectdrR2	pha	~StillDown #0	pla	beq	drR3	move4 myRect+4,oldRect+4	oldPoint = point2	~GetMouse #myRect+4	brl	drRLoopdrR3	~FrameRect #myRect	~SetPenMode #modeCopy	rtsmyRect	ds	8oldRect	ds	8toolTable entry*---------------------------------------------	dc	i2'doHand'	0	dc	i2'doErase'	1	dc	i2'doSingleB'	2	dc	i2'doDoubleB'	3	dc	i2'doHatchB'	4	dc	i2'doWedgeB'	5* --------------------------------------------toolTable2 entry	dc	i2'doMarquee'	11	dc	i2'doText'	12	dc	i2'doDottedB'	13	dc	i2'doTripleB'	14	dc	i2'doWHatch'	15	dc	i2'doCChain'	16myPoint	anopmyY	ds	2myX	ds	2point2	anopy2	ds	2x2	ds	2myPoint2	anop	ds	4oldPoint	ds	4fShift	ds	2	enddoControls start	using Globals	~SysBeep	rts	end