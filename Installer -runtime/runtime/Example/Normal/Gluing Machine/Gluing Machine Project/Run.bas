'-------------------------------------------------------------------
'The statement of the methods, and the concrete implementation is written in the end
'-------------------------------------------------------------------
DECLARE SUB RUNMODE01()							'Declare a path motion method
DECLARE SUB RUNMODE02()							'Declare a circular motion method
DECLARE SUB JOG_N(ByRef JOG_FLAG AS UBYTE)		'Declare  a JOG- method
DECLARE SUB JOG_P(ByRef JOG_FLAG AS UBYTE)		'Declare  a JOG+ method

'-------------------------------------------------------------------
'Initialization
'-------------------------------------------------------------------
DIM JOG_FLAG AS UBYTE=0							'The mark for the JOG movement

'-------------------------------------------------------------------
'PARTICAL CODE: Motion state
'-------------------------------------------------------------------
WHILE 1

SELECT CASE INT(VR(RUN_MODE))
CASE RUN_START									'Start running	
	DO 																		
		IF(VR(RUN_CHOOSE)=0) THEN				'VR(RUN_CHOOSE)=>Polymorphic Button
			RUNMODE01()							'Path motion mode	
		ELSEIF(VR(RUN_CHOOSE)=1) THEN
			RUNMODE02()							'Circular motion mode
		ELSE
			RUNMODE01()							'Path & Circular motion mode
			IF(VR(RUN_MODE)=RUN_START) THEN
				RUNMODE02()
			END IF		
		END IF		
	'Stop motion at once
	LOOP WHILE(VR(BTN_RUNTIMES)=1 AND VR(RUN_MODE)=RUN_START)
	
	VR(RUN_MODE)=0
	
CASE RUN_HOME  									' Home mode
	BASE 0,1
	HOMEN 	
	VR(RUN_MODE)=0
	
CASE RUN_JOG_N 									'JOG- mode
	JOG_N(JOG_FLAG)								'Call the JOG- method

CASE RUN_JOG_P									'JOG+ mode
	JOG_P(JOG_FLAG)								'Call the JOG+ method

CASE RUN_X_MOVE									'Axis(x)'s PTP mode		
	MOVEABS AX(0),VR(POSITION_X) 				'Axis(x)'s target position
	VR(RUN_MODE)=0

CASE RUN_Y_MOVE 								'Axis(y)'s PTP mode	
	MOVEABS AX(1),VR(POSITION_Y) 				'Axis(y)'s target position
	VR(RUN_MODE)=0

CASE RUN_RESET_ERR								'Clear Error mode
	BASE 0,1
	RESETERR 									'Clear Axis's error
	CLEAR_ERROR									'Clear System's error
	VR(RUN_MODE)=0

END SELECT

SLEEP 50
WEND

'-------------------------------------------------------------------
'The concrete implementation of the method
'-------------------------------------------------------------------
SUB RUNMODE01()						
	BASE 0,1	
	PATHBEGIN
	MERGEON
	LINEABS VR(0),VR(1)							'Point 1
	LINEABS VR(2),VR(3)							'Point 2
	'Center of the circle is the center of the line between point 2 and point 6
	CIRCABS 0,(VR(2)+VR(10))/2,(VR(3)+VR(11))/2,VR(4),VR(5)
	LINEABS VR(6),VR(7)							'Point 4
	LINEABS VR(8),VR(9)							'Point 5
	LINEABS VR(10),VR(11)						'Point 6
	'Center of the circle is the center of the line between point 3 and point 7
	CIRCABS 0,(VR(12)+VR(4))/2,(VR(13)+VR(5))/2,VR(12),VR(13)
	LINEABS VR(14),VR(15)						'Point 8
	PATHEND	
	WAIT DONE
END SUB

SUB RUNMODE02()									'Sub mode of the circular motion
	BASE 0,1	
	PATHBEGIN
	MERGEON
	LINEABS VR(16),VR(17)						'Point 9
	'The Intermediate point is Point 10，the End point is point 11
	CIRCABS_3P 0,VR(18),VR(19),VR(20),VR(21)
	CIRCABS_A 0,(VR(16)+VR(20))/2,(VR(17)+VR(21))/2,180
	LINEABS VR(22),VR(23)						'Point 12
	'The Intermediate point is Point 13，the End point is point 14
	CIRCABS_3P 0,VR(33),VR(34),VR(35),VR(36)
	CIRCABS_A 0,(VR(22)+VR(35))/2,(VR(23)+VR(36))/2,180
	PATHEND	
	WAIT DONE
END SUB

SUB JOG_N(ByRef JOG_FLAG AS UBYTE)
	BASE VR(JOG_AXIS)							'JOG Mode's Axis Number
	IF(VR(JOG_NEG)=1) THEN						'JOG- Button
		JOG_FLAG=1								'JOG_FLAG for the case on loosenning the Jog button
		JOGN AX(VR(JOG_AXIS))		
	ELSEIF(VR(JOG_NEG)=0 AND JOG_FLAG=1) THEN
		JOG_FLAG=0
		STOPDEC AX(VR(JOG_AXIS))
		WAIT DONE
		VR(RUN_MODE)=0
	END IF		
END SUB

SUB JOG_P(ByRef JOG_FLAG AS UBYTE)
	BASE VR(JOG_AXIS)
	IF(VR(JOG_POS)=1) THEN						'JOG+ Button
		JOG_FLAG=1
		JOGP AX(VR(JOG_AXIS))		
	ELSEIF(VR(JOG_POS)=0 AND JOG_FLAG=1) THEN
		JOG_FLAG=0
		STOPDEC AX(VR(JOG_AXIS))	
		WAIT DONE
		VR(RUN_MODE)=0
	END IF	
END SUB
'-------------------------------------------------------------------
