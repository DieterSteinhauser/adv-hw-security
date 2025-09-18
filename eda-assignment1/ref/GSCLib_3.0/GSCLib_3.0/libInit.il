printf("*************************************************************\n")
printf("*             Generic Standard Cell Library                 *\n")
printf("*                                                           *\n")
printf("* This library is provided as an education medium. It is    *\n")
printf("* based upon the generic process available thru Cadence PDK *\n")
printf("* factory in the GPDK Process Delivery Kit.                 *\n")
printf("* Cadence shall in no case be liable for the contents of    *\n")
printf("* this library.                                             *\n")
printf("*                                                           *\n")
printf("* GSCLib, v0.91, Oct 2002, Copyright Cadence Design Systems  *\n")
printf("* This library can be freely distributed.                   *\n")
printf("*                                                           *\n")
printf("*************************************************************\n")
printf(" \n")

when( getd('hiGraphicMode) && hiGraphicMode()

	; if IC5.0 or later
	; Preset the VXL component type ref library to make user's life
	; a little bit easier.
	if( car(parseString(nth(3 parseString(getVersion())) ".")) == "5"
		then
			envSetVal("layoutXL" "compTypeRefLibs" 'string "GSCLib")
		else
			printf("*** WARNING: This library works better with IC5.0 or later...\n")
			printf("***          Some features have been disabled for the version you are running.\n")
			printf(" \n")
	    )

	unless( GSCLib.init
	printf("Loading custom Skill for GSCLib....\n")
	
	procedure( GSCLibAbgenPrep(cv viewName "gt")
		prog( (newCV)
			printf("*** INFO: Processing %L %L %L.\n" cv~>libName cv~>cellName cv~>viewName)
			unless( GSCLibVerifyLayout(cv) 
				printf("*** ERROR: Please review layout for problems...\n")
				return(nil)
			      )
			unless( dbSave(cv cv~>libName cv~>cellName viewName)
				printf("*** ERROR: Could not duplicate the layout...\n")
				return(nil)
			      )
			unless( newCV = dbOpenCellViewByType(cv~>libName cv~>cellName viewName nil "a")
				printf("*** ERROR: Could not edit copied cellview....\n")
				return(nil)
			      )
			unless( GSCLibAbgenPrepDoIt(newCV)
				printf("*** ERROR: Problem processing the cellview...\n")
				return(nil)
			      )
			unless( dbSave(newCV)
				printf("*** ERROR: Could not save new cellview...\n")
				return(nil)
			      )
			printf("*** INFO: Done !\n")
			return(t)
		    )
		)
	procedure( GSCLibAbgenPrepDoIt(cv)
		prog( (pins newFig)
			pins = cv~>terminals~>pins
			printf("*** INFO: Processing pins...\n")
			foreach( pin pins
				 foreach(fig pin~>fig
					 newFig = dbCopyFig(fig cv)
					 fig~>purpose = "pin"
				        )
			       )
			printf("*** INFO: Flattening instances...\n")
			foreach( inst cv~>instances
				 dbFlattenInst(inst 20 t nil)
			       )
			return(t)
		    )
		 )
	procedure( GSCLibVerifyLayout(cv)
		prog( (pins status term netExpr bndr x y xx yy labels)
			status = nil

			printf("*** INFO: Layout verification for %s %s %s\n"
				cv~>libName cv~>cellName cv~>viewName)
			
			unless( pins = cv~>terminals~>pins
				printf("*** ERROR: There does not appear to be pins in your layout !\n")
				return(nil)
			      )

			unless( GSCLibVerifyPowerTerms(cv)
				return(nil)
			      )

			foreach( pin pins
				 printf("*** INFO: Verifying pins purpose for net %L.\n" pin~>term~>name)
				 foreach( figure pin~>fig
					  unless( figure~>purpose == "drawing"
						  printf("*** ERROR: Pins MUST be drawn using the 'drawing' purpose.\n")
						  printf("***        Some shapes for pin on net %L are using invalid purpose.\n" 
								pin~>term~>name)
						  status = t
					        )
					)
			       )
			when(status return(nil))
			status = nil
			foreach( term cv~>terminals
				 printf("*** INFO: Verifying label for terminal %L.\n" term~>name)
				 unless( labels = term~>textDisplays
					 status = t
					 printf("*** ERROR: Missing textDisplay for terminal.\n")
				       )
				 unless( status
					 foreach( l labels
						 	x = xCoord(car(l~>parent~>bBox))
							y = yCoord(car(l~>parent~>bBox))
							xx = xCoord(cadr(l~>parent~>bBox))
							yy = yCoord(cadr(l~>parent~>bBox))
							unless( xCoord(l~>xy) < xx &&
								xCoord(l~>xy) > x  &&
								yCoord(l~>xy) < yy &&
								yCoord(l~>xy) > y
								printf("*** ERROR: Label origin must be within the pin !\n")
								status = t
							      )
							unless( l~>lpp == list("text" "drawing")
								printf("*** ERROR: Label LPP must be text/drawing.\n")
								status = t
							      )
						)
	
			               )
					 
			       )
			when( status return(nil))

			printf("*** INFO: Verifying boundary.\n")
			unless( bndr = setof(shape cv~>shapes shape ~>layerName == "prBoundary")
				printf("*** ERROR: Layout must contain prBoundary shape...\n")
				return(nil)
			      )
			printf("***     :.")
			unless( onep(length(bndr))
				printf("*** ERROR: Layout must contain only 1 prBoundary shape...\n")
				return(nil)
			      )
			printf(".")
			bndr = car(bndr)
			x = xCoord(car(bndr~>bBox))
			y = yCoord(car(bndr~>bBox))
			xx = xCoord(cadr(bndr~>bBox))
			yy = yCoord(cadr(bndr~>bBox))
			unless( x == 0.0
				printf("\n*** ERROR: Cell x origin must be 0.\n")
				return(nil)
			      )
			printf(".")
			unless( y == 0.0
				printf("\n*** ERROR: Cell y origin must be 0.\n")
				return(nil)
			      )
			printf(".")
			unless( yy == 7.92
				printf("\n*** ERROR: Cell height must be 7.92.\n")
				return(nil)
			      )
			printf(".")
			when( abs(int(xx / 0.66 + 0.00001) - xx/0.66) > 0.0001
				printf("\n*** ERROR: Cell width must be a multiple of 0.66.\n")
				return(nil)
			      )
			printf(".\n")
			return(t)
		    )
	         )

	procedure( GSCLibVerifyPowerTerms(cv)
		prog( (netExpr)
			printf("*** INFO: Verifying power terminals 'POWR' & 'GRND'.\n")
			unless( member("POWR" cv~>terminals~>name)
				printf("*** ERROR: Missing required terminal 'POWR' in the layout.\n")
				return(nil)
			       )
			printf("***     :.")
			term = car(exists(term cv~>terminals term~>name == "POWR"))
			unless( term~>direction == "input"
				printf("\n*** ERROR: Power supply terminal must be of input type.\n")
				return(nil)
			      )
			printf(".")
			unless( netExpr = dbGetTermNetExpr(term)
				printf("\n*** ERROR: Missing net expression on power supply terminal.\n")
				return(nil)
			      )
			printf(".")
			unless( netExpr == "[@POWR:%:vdd!]"
				printf("\n*** ERROR: Net expression not following Specs...\n")
				return(nil)
			      )
			printf(".\n")
			unless( member("GRND" cv~>terminals~>name)
				 printf("\n*** ERROR: Missing required terminal 'GRND' in the layout.\n")
				 return(nil)
			       )
			printf("***     :.")
			term = car(exists(term cv~>terminals term~>name == "GRND"))
			unless( term~>direction == "input"
				printf("\n*** ERROR: Ground  terminal must be of input type.\n")
				return(nil)
			      )
			printf(".")
			unless( netExpr = dbGetTermNetExpr(term)
				printf("\n*** ERROR: Missing net expression on power supply terminal.\n")
				return(nil)
			      )
			printf(".")
			unless( netExpr == "[@GRND:%:gnd!]"
				printf("\n*** ERROR: Net expression not following Specs...\n")
				return(nil)
			      )
			printf(".\n")
			return(t)
	 	    )
	 	  )
			
			
	procedure( GSCLibVerifySchematic(cv)
		prog( ()
			printf("*** INFO: Verifying connectivity for %s\\%s\\%s.\n"
				cv~>libName cv~>cellName cv~>viewName)
			
			unless( GSCLibVerifyPowerTerms(cv)
				return(nil)
			      )

			return(t)
	    	    )
	    	 )


	procedure( GSCLibNetlistSubckt(cv f)

	; Note: This is a simplified netlisting procedure that assumes that
	; the input is an extracted cellview... (no vectored connectivity).

		prog( (terms wTerm mos conn res cap)
			printf("*** INFO: Writing subcircuit for %s\\%s\\%s.\n"
				cv~>libName cv~>cellName cv~>viewName)

			fprintf(f "*************************************************************\n")
			fprintf(f "** Subcircuit for %s/%s/%s\n" cv~>libName cv~>cellName cv~>viewName)
			fprintf(f "** (c) Cadence Design Systems, 2002.\n")
			fprintf(f "** This information can be freely redistributed provided\n")
			fprintf(f "** this header is not removed.\n")
			fprintf(f "** This Library is provided by Cadence without any guaranties.\n")
			fprintf(f "** timeStamp: %L\n" getCurrentTime() )
			fprintf(f "** \n")
			fprintf(f " \n")

			; Output the .SUBCKT line (termOrder does not care for lib char).
			fprintf(f ".SUBCKT %s " cv~>cellName)
			terms = cv~>terminals
			wTerm = setof( term terms 
						term~>direction == "input" && 
						!(term~>name == "POWR" || term~>name == "GRND"))~>name
			wTerm = sort(wTerm 'alphalessp)
			foreach( term wTerm fprintf(f "%s " term) )

			wTerm = setof( term terms term~>direction == "output")~>name
			wTerm = sort(wTerm 'alphalessp)
			foreach( term wTerm fprintf(f "%s " term) )

			fprintf(f "POWR GRND\n")

			; Now process the MOS devices.
			mos = setof(inst cv~>instances inst~>cellName == "pmos" || inst~>cellName == "nmos")
			foreach( m mos
				 fprintf(f "%s %s %s %s %s %s w=%s l=%s ad=%s as=%s pd=%s ps=%s\n"
					 if( substring(m~>name 1 1) == "M" 
						m~>name 
						if( m~>cellName == "nmos"
							strcat("MN" substring(m~>name 2 strlen(m~>name)-1))
							strcat("MP" substring(m~>name 2 strlen(m~>name)-1))
						  )
					   )
					  GSCLibGetConn(m "D")
					  GSCLibGetConn(m "G")
					  GSCLibGetConn(m "S")
					  GSCLibGetConn(m "B")
					  m~>model
					  aelEngNotation(m~>w)
					  aelEngNotation(m~>l)
					  aelEngNotation(m~>ad)
					  aelEngNotation(m~>as)
					  aelEngNotation(m~>pd)
					  aelEngNotation(m~>ps))

			       )
			; Now processing the PRESISTORs...
			res = setof(inst cv~>instances inst~>cellName == "presistor")
			foreach( r res
				 fprintf(f "%s %s %s %s\n"
						if( substring(r~>name 1 1) == "R"
							r~>name
							strcat("R" substring(r~>name 2 strlen(r~>name)-1))
						  )
						GSCLibGetConn(r "PLUS")
						GSCLibGetConn(r "MINUS")
						aelEngNotation(r~>r)
					)
			       )
			; Now processing the PCAPACITORs...
			cap = setof(inst cv~>instances inst~>cellName == "pcapacitor")
			foreach( c cap
				 fprintf(f "%s %s %s %s\n"
						if( substring(c~>name 1 1) == "C"
							c~>name
							strcat("C" substring(c~>name 2 strlen(c~>name)-1))
						  )
						GSCLibGetConn(c "PLUS")
						GSCLibGetConn(c "MINUS")
						aelEngNotation(c~>c)
					)
			       )
			fprintf(f ".ENDS %s \n\n" cv~>cellName)		
			return(t)
		    )
		)
	  

		procedure(GSCLibGetConn(device name)
			let( (conn netName)
				conn = car(exists(co device~>conns co~>name ==name))
				netName = conn~>net~>term~>name || conn~>net~>name
				when(substring(netName 1 1) == "+" 
					netName = substring(netName 2 strlen(netName)-1)
				    )
				rexCompile(":") 
				netName = rexReplace(netName "_" 0)
				netName
			   )
			)

	procedure(GSCLibSubcktFile(libName viewList fileName)
		prog( (libId f cv)
			unless( libId = ddGetObj(libName)
				printf("*** ERROR: Could not find specified library...\n")
				return()
			      )
			fileName = simplifyFilename(fileName)
			unless( f = outfile(fileName)
				printf("*** ERROR: Could not open output file...\n")
				return()
			      )
			fprintf(f "************************************************\n")
			fprintf(f "* Subcircuit file for library characterization. \n")
			fprintf(f "* (Do not use for regular simulations...)       \n")
			fprintf(f "*                                               \n")
			fprintf(f "* (c) 2002 Cadence Design Systems.              \n")
			fprintf(f "*  Gilles S.C. Lamant - gscl@cadence.com        \n")
			fprintf(f "************************************************\n")
			fprintf(f " \n \n \n")
			fprintf(f ".GLOBAL POWR GRND\n")
			fprintf(f " \n")

			foreach( cell libId~>cells
				 if( cv = dbOpenCellView(libName cell~>name viewList nil "r")
					then
						when( GSCLibVerifySchematic(cv)
							GSCLibNetlistSubckt(cv f)
						    )
					else
						printf("*** WARNING: No valid view found for %L\n" cell~>name)
				    )
				)
			close(f)
			return(t)
		    )
		)

	procedure( GSCLibPipo(libName)
		prog( (libId validCellNames name f fileName cv excludeCells)
			unless( libId = ddGetObj(libName)
				printf("*** ERROR: Could not find specified library.\n")
				return()
			      )
			validCellNames = ""
			excludeCells = ""
			foreach( cell libId~>cells
				 name = cell~>name
				 when( ( member(substring(name strlen(name)-1 2) list("X1" "X2" "X3" "X4" "X5" "X6" "X7" "X8" "X16" "XL")) ||
					 member(name list("FILL1" "FILL2" "FILL4" "FILL8") ) ) &&
				       member("layout" cell~>views~>name)
					cv = dbOpenCellView(libName name "layout" nil "r")
					if( GSCLibVerifyLayout(cv)
						then
							printf("*** INFO: Adding %L\n" name )
							validCellNames = strcat(validCellNames name ",")
						else
							printf("*** INFO: Cell not added to list because of problems...\n")
							excludeCells = strcat(excludeCells " " name)
					  )
				     )
			       )

			validCellNames = substring(validCellNames 1 strlen(validCellNames)-1)

			printf("*** INFO : Cell List %L\n" validCellNames)
			printf("*** WARNING: Cells with problems %L\n" excludeCells)
			
			unless( fileName = makeTempFileName("/tmp/pipo")
				printf("*** ERROR: Could not create temp file for PIPO setup.\n")
				return()
			      )	
			unless( f = outfile(fileName)
				printf("*** ERROR: Could not open temp file for PIPO setup.\n")
				return()
			      )
			fprintf(f " ; PIPO Setup file for %L\n" libName)
			fprintf(f " ; Generated %L\n" getCurrentTime() )
			fprintf(f " ; (c) 2002 Cadence Design Systems.\n")
			fprintf(f " ; Gilles S.C. Lamant\n")
			fprintf(f " \n")
			fprintf(f "streamOutKeys = list(nil \n")
			fprintf(f "\t 'runDir \t\t\".\"\n")
			fprintf(f "\t 'libName \t\t%L\n" libName)
			fprintf(f "\t 'primaryCell \t\t%L\n" validCellNames)
			fprintf(f "\t 'viewName \t\t\"layout\"\n")
			fprintf(f "\t 'outFile \t\t%L\n" strcat(libName ".gds"))
			fprintf(f "\t 'scale \t\t0.001000\n")
			fprintf(f "\t 'units \t\t\"microns\"\n")
			fprintf(f "\t 'convertToGeo\t\tt\n")
			fprintf(f "\t 'refLib\t\tnil\n")
			fprintf(f "\t 'libVersion\t\t\"5.0\"\n")
			fprintf(f "\t 'keepPcell\t\tnil\n")
			fprintf(f "\t 'layerTable\t\t%L\n" simplifyFilename(strcat(libId~>readPath "/../stream/stream.map")))
			fprintf(f "\t 'convertPin\t\t\"geometry\"\n")
			fprintf(f "\t )\n")
			fprintf(f "\n")

			close(f)
			system( sprintf(nil "pipo strmout %s\n" fileName))
			printf("Check your run directory for PIPO.LOG and GDSII file...\n")
			return()
		    )
		)

	procedure(GSCLibArea(libName fileName)
		prog( (libId validCellNames name f cv excludeCells)
			unless( libId = ddGetObj(libName)
				printf("*** ERROR: Could not find specified library.\n")
				return()
			      )
			validCellNames = ""
			excludeCells = ""
			unless( f = outfile(simplifyFilename(fileName))
				printf("*** ERROR: Could not open file for area output.\n")
				return()
		              )
			fprintf(f "%s\tarea\n" libName)
			foreach( cell libId~>cells
				 name = cell~>name
				 when( ( member(substring(name strlen(name)-1 2) list("X1" "X2" "X3" "X4" "X5" "X6" "X7" "X8" "X16" "XL")) ||
					 member(name list("FILL1" "FILL2" "FILL3" "FILL4" ) ) ) &&
				       member("layout" cell~>views~>name)
					cv = dbOpenCellView(libName name "layout" nil "r")
					if( GSCLibVerifyLayout(cv)
						then
							printf("*** INFO: Adding %L\n" name )
							validCellNames = strcat(validCellNames name ",")	
							GSCLibSaveArea(cv f)
						else
							printf("*** INFO: Cell not added to list because of problems...\n")
							excludeCells = strcat(excludeCells " " name)
					  )
					when(cv dbClose(cv))
				     )
			       )

			validCellNames = substring(validCellNames 1 strlen(validCellNames)-1)
			close(f)
			printf("*** INFO : Cell List %L\n" validCellNames)
			printf("*** WARNING: Cells with problems %L\n" excludeCells)
			return(t)
			
		)
	)


	procedure(GSCLibPostProcessAbstracts(libName )
		prog( (libId validCellNames cv excludeCells powerTerm groundTerm)
			unless( libId = ddGetObj(libName)
				printf("*** ERROR: Could not find specified library.\n")
				return()
			      )
			validCellNames = ""
			excludeCells = ""

			foreach( cell libId~>cells
				 name = cell~>name
				 when( ( member(substring(name strlen(name)-1 2) list("X1" "X2" "X3" "X4" "X5" "X6" "X7" "X8" "X16" "XL")) ||
					 member(name list("FILL1" "FILL2" "FILL3" "FILL4" ) ) ) &&
				         member("abstract" cell~>views~>name)
					 when( cv = dbOpenCellView(libName name "abstract" nil "a")
						printf("INFO: Processing %L abstract.\n" name)
						; We need to convert the regular terminal to add to it
						; the required inherited connections
						if( powerTerm = dbFindTermByName(cv "POWR")
							then
							    printf("INFO: Adding net expression to POWR terminal.\n")
							    dbReplaceTermNetExpr(powerTerm "[@POWR:%:vdd!]")
							else
							    printf("ERROR: Could not find POWR terminal in abstract...\n")
						  )
						if( groundTerm = dbFindTermByName(cv "GRND")
							then
							    printf("INFO: Adding net expression to GRND terminal.\n")
							    dbReplaceTermNetExpr(groundTerm "[@GRND:%:gnd!]")
							else
							    printf("ERROR: Could not find GRND terminal in abstract...\n")
						  )
					     )
					 when(cv dbSave(cv) dbClose(cv))
				     ) 
			       )

			return(t)
			
		)
	)

	procedure( GSCLibSaveArea(cv f)
		prog( (bndr area x xx y yy)
			
			unless( bndr = setof(shape cv~>shapes shape ~>layerName == "prBoundary")
				printf("*** ERROR: Layout must contain prBoundary shape...\n")
				return(nil)
			      )
			printf("***     :.")
			unless( onep(length(bndr))
				printf("*** ERROR: Layout must contain only 1 prBoundary shape...\n")
				return(nil)
			      )
			printf(".")
			bndr = car(bndr)
			x = xCoord(car(bndr~>bBox))
			y = yCoord(car(bndr~>bBox))
			xx = xCoord(cadr(bndr~>bBox))
			yy = yCoord(cadr(bndr~>bBox))
			unless( x == 0.0
				fprintf("\n*** ERROR: Cell x origin must be @ 0.\n")
				return(nil)
			      )
			printf(".")
			unless( y == 0.0
				fprintf("\n*** ERROR: Cell y origin must be @ 0.\n")
				return(nil)
			      )
			printf(".")
			unless( yy == 7.92
				fprintf("\n*** ERROR: Cell height must be 7.92.\n")
				return(nil)
			      )
			printf(".")
			when( abs(int(xx / 0.66 + 0.00001) - xx/0.66) > 0.0001
				printf("\n*** ERROR: Cell width must be a multiple of 0.66.\n")
				return(nil)
			      )

			area = truncate((xx - x) * (yy - y) * 10000.00)/10000.00

			fprintf(f "%s\t%.4n\n" cv~>cellName area)
			return(t)
			)
	)

	GSCLib.init = t
	GSCLib.load = strcat(ddGetObj("GSCLib")~>readPath "/libInit.il")

	procedure( GSCLibInit()
			GSCLib.init = nil
			loadi(GSCLib.load)
		 )
      )

) ; when hi
