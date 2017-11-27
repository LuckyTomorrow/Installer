'------------------------------------------------------------------
'The statement of the methods, and the concrete implementation is written in the end
'------------------------------------------------------------------
DECLARE SUB INIT()								'Declare an initial method
DECLARE SUB VRVALUE()							'Declare a method about interaction of HMI and VR

'------------------------------------------------------------------
'Initialization
'------------------------------------------------------------------
DIM CURRENTAXIS AS UBYTE=0						'An index of the current axis
DIM SVON_FLAG AS UBYTE=0						'A mark for the SVON movement
INIT()											'Call the initial method

'------------------------------------------------------------------
'Performance monitoring
'------------------------------------------------------------------
WHILE 1

'When switching the axis, judge the status of the SVON button
IF(CURRENTAXIS <> VR(Operate_Axis)) THEN 		'VR(Operate_Axis)=>Polymorphic Button
	VR(ServerButton)=0							'SVON Button
	SVON_FLAG=0
	BASE VR(Operate_Axis)
	IF(MIO.SVON) THEN			
		VR(ServerButton)=1
	ELSE
		VR(ServerButton)=0
	END IF
	CURRENTAXIS=VR(Operate_Axis)
END IF

BASE VR(Operate_Axis)							
IF(VR(ServerButton)=1 AND SVON_FLAG=0) THEN		'SVON_FLAG trigger the click button event in time
	SVON
	SVON_FLAG=1
ELSEIF(VR(ServerButton)=0 AND SVON_FLAG=1) THEN
	SVOFF
	SVON_FLAG=0
END IF			

SELECT CASE INT(VR(Run_Pattern))				'VR(Run_Pattern)=>radio button

	CASE 0 										'PTP movement
		IF(VR(Negative_Direction)=1) THEN 		'Negative motion button

			VR(RUN_MODE)=RUN_PTP_N 				
			VR(Negative_Direction)=0			'Reset the negative motion button

		ELSEIF(VR(Positive_Direction)=1) THEN 	'Positive motion button
			VR(RUN_MODE)=RUN_PTP_P 			
			VR(Positive_Direction)=0				
		END IF

	CASE 1 										'Continue movement
		IF(VR(Negative_Direction)=1) THEN 		
			VR(RUN_MODE)=RUN_REVERSE			
			VR(Negative_Direction)=0
		ELSEIF(VR(Positive_Direction)=1) THEN 
			VR(RUN_MODE)=RUN_FORWARD			
			VR(Positive_Direction)=0
		END IF
		
	CASE 2 										'Home movement
		IF(VR(Negative_Direction)=1) THEN 		
			VR(RUN_MODE)=RUN_HOMEN			
			VR(Negative_Direction)=0
		ELSEIF(VR(Positive_Direction)=1) THEN 
			VR(RUN_MODE)=RUN_HOMEP			
			VR(Positive_Direction)=0
		END IF
		
END SELECT

IF(VR(Stop_Motion)=1) THEN 						'Stop Button
	BASE VR(Operate_Axis)
	STOPDEC	
	WAIT DONE
	VR(RUN_MODE)=0		
	VR(Stop_Motion)=0
END IF

IF(VR(Clear_Err)=1) THEN						'Reset Error Button
	VR(RUN_MODE)=RUN_CLEAR_ERR		
	VR(Clear_Err)=0
END IF

IF(VR(Clear_Position)=1) THEN 					'Reset Position Button
	VR(RUN_MODE)=RUN_CLEAR_POS		
	VR(Clear_Position)=0
END IF

'Because of the JOG mode, the JOG button is processed in HMI ,
'it can be reset automatically
IF(VR(Jog_Negative)=1) THEN						'JOG- Button
	VR(RUN_MODE)=RUN_JOGN		
END IF

IF(VR(Jog_Positive)=1) THEN 					'JOG+ Button
	VR(RUN_MODE)=RUN_JOGP		
END IF	

VRVALUE()										'Call the method about interaction of HMI and VR

SLEEP 20
WEND

'------------------------------------------------------------------
'The concrete implementation of the method
'------------------------------------------------------------------	
SUB INIT()
	BASE 0,1,2,3
	POUT_MODE=0
	VL=5000
	VH=20000
	ACC=20000
	DEC=20000

	HOME_VL=5000
	HOME_VH=20000
	HOME_ACC=20000
	HOME_DEC=20000

	JOG_VL=5000
	JOG_VH=20000
	JOG_ACC=20000
	JOG_DEC=20000
	
	RUN_TASK "Run"
END SUB	
	
SUB VRVALUE()
	VL=VR(1)									'Initial velocity
	VH=VR(2)									'Running velocity
	ACC=VR(3)									'Accelerated velocity
	DEC=VR(4)									'Retarded velocity

	HOME_VL=VR(1)
	HOME_VH=VR(2)
	HOME_ACC=VR(3)
	HOME_DEC=VR(4)

	JOG_VL=VR(1)
	JOG_ACC=VR(3)
	JOG_DEC=VR(4)
	JOG_VH=VR(8)								'JOG speed
	
	BASE VR(Operate_Axis)						'Current Axis

	HOME_MODE=VR(Home_Pattern)					'Choose which way to home

	IF(VR(Jerk)=0) THEN							'Velocity curve type
		JK=0
		HOME_JK=0
	ELSE 
		JK=1
		HOME_JK=1
	END IF

'VR(5)-VR(7) => Theoretical position,Physical location and Current speed
	VR(5)=CDBL(DPOS)
	VR(6)=CDBL(MPOS)
	VR(7)=CDBL(DSPEED)
'VR(60)、VR(101) => Axis State,Error code
	VR(60)=STATE
	VR(101)=RUN_ERROR

'VR(63)-VR(77) => Axis I/O state
	VR(63)=MIO.RDY
	VR(64)=MIO.ALM
	VR(65)=MIO.PEL
	VR(66)=MIO.NEL
	VR(67)=MIO.ORG
	VR(68)=MIO.DIR
	VR(69)=MIO.EMG
	VR(70)=MIO.EZ
	VR(71)=MIO.LTC
	VR(72)=MIO.INP
	VR(73)=MIO.SVON
	VR(74)=MIO.SPEL
	VR(75)=MIO.SNEL
	VR(76)=MIO.CMP
	VR(77)=MIO.CAMDO
END SUB
'------------------------------------------------------------------	
