'-------------------------------------------------------------------
'The statement of the methods, and the concrete implementation is written in the end
'-------------------------------------------------------------------
DECLARE SUB INIT()								'Declare an initial method
DECLARE SUB GetNewPos(ByVal aa AS INTEGER)		'Declare a teaching method
DECLARE SUB VRVALUE()							'Declare a method about interaction of HMI and VR

'-------------------------------------------------------------------
'Initialization
'-------------------------------------------------------------------
INIT()											'Call the initial method

'-------------------------------------------------------------------
'Performance monitoring
'-------------------------------------------------------------------
WHILE 1

VRVALUE()										'Call the method about interaction of HMI and VR

IF(VR(BTN_START)=1) THEN 						'Start Button
	VR(RUN_MODE)=RUN_START				
	VR(BTN_START)=0								'Reset Start Button
END IF

IF(VR(BTN_STOP)=1) THEN							'Stop Button
	BASE 0,1
	VR(RUN_MODE)=0								'Reset Stop Button
	VR(BTN_STOP)=0
	STOPDEC
	WAIT DONE	
END IF

IF(VR(BTN_HOME)=1) THEN 						'Home Button
	VR(RUN_MODE)=RUN_HOME				
	VR(BTN_HOME)=0	
END IF

'Because of the JOG mode, the JOG button is processed in HMI ,
'it can be reset automatically
IF(VR(JOG_NEG)=1) THEN 							'JOG- Button
	VR(RUN_MODE)=RUN_JOG_N
END IF

IF(VR(JOG_POS)=1) THEN 							'JOG+ Button
	VR(RUN_MODE)=RUN_JOG_P
END IF

IF(VR(AXIS_X_RUN)=1) THEN 						'Axis(0)'s Start Button
	VR(RUN_MODE)=RUN_X_MOVE
	VR(AXIS_X_RUN)=0				
END IF

IF(VR(AXIS_Y_RUN)=1) THEN 						'Axis(1)'s Start Button
	VR(RUN_MODE)=RUN_Y_MOVE
	VR(AXIS_Y_RUN)=0
END IF

IF(VR(CLEAR_ERR)=1) THEN 						'Reset Error Button
	VR(RUN_MODE)=RUN_RESET_ERR
	VR(CLEAR_ERR)=0
END IF

FOR i AS INTEGER= 0 to 13  						'Iterate over the state of the instruction button
	IF(VR(BTN_FIRST_POSITION+i)=1) THEN			'When a Teach button is clicked
		IF(i=12) THEN
			BASE 0
			VR(33)= CDBL(DPOS)
			BASE 1
			VR(34)=CDBL(DPOS)
		ELSEIF(i=13) THEN
			BASE 0
			VR(35)= CDBL(DPOS)
			BASE 1
			VR(36)=CDBL(DPOS)			
		ELSE
			GetNewPos(i)						'Pass the dpos value of the Teach button to the corresponding HMI numeric input box
		END IF
		
		VR(BTN_FIRST_POSITION+i)=0				'Reset the Teach button 		
	END IF
NEXT i	

SLEEP 50
WEND

'-------------------------------------------------------------------
'The concrete implementation of the method
'-------------------------------------------------------------------
SUB GetNewPos(ByVal aa AS INTEGER)				'Pass the current dpos to the corresponding Teach Position
	BASE 0
	VR(2*aa)= CDBL(DPOS)
	BASE 1
	VR(1+2*aa)=CDBL(DPOS)
END SUB

SUB INIT()
	BASE 0,1
	SVON
	POUT_MODE=0

	VL=2000
	VH=8000
	ACC=20000
	DEC=ACC

	JOG_VL=2000
	JOG_VH=8000
	JOG_ACC=10000
	JOG_DEC=JOG_ACC

	GVL=2000
	GVH=8000
	GACC=20000
	GDEC=20000
	
	RUN_TASK "Run"
END SUB

SUB VRVALUE()
	BASE 0,1
	GVH=VR(GROUP_RUN_SPEED)						'Speed-slider Button
	VH=VR(RUN_SPEED)							'Axis Speed-slider Button

	BASE VR(JOG_AXIS)
	JOG_VH=VR(JOG_RUN_SPEED)					'JOG Speed-slider Button
END SUB
'-------------------------------------------------------------------

