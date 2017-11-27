'------------------------------------------------------------------
'The statement of the methods, and the concrete implementation is written in the end
'------------------------------------------------------------------
DECLARE SUB JOG_N(ByRef JOG_FLAG AS UBYTE)			'Declare  a JOG- method
DECLARE SUB JOG_P(ByRef JOG_FLAG AS UBYTE)			'Declare  a JOG+ method

'------------------------------------------------------------------
'Initialization
'------------------------------------------------------------------
DIM JOG_FLAG AS UBYTE=0								'The mark for the JOG movement

'------------------------------------------------------------------
'PARTICAL CODE: Motion state
'------------------------------------------------------------------
WHILE 1			

SELECT CASE INT(VR(RUN_MODE))

	CASE RUN_PTP_N  								'PTP negative mode
		BASE VR(Operate_Axis)						'VR(Operate_Axis)=>Polymorphic Button
		MOVE VR(Distance)*(-1)						'Distance
		VR(RUN_MODE)=0								'Reset Run mode

	CASE RUN_PTP_P   								'PTP Positive direction mode	
		BASE VR(Operate_Axis)
		MOVE VR(Distance)	
		VR(RUN_MODE)=0	

	CASE RUN_REVERSE								'Continuous negative direction mode	
		REVERSE AX(VR(Operate_Axis))	
		VR(RUN_MODE)=0

	CASE RUN_FORWARD								'Continuous positive direction mode
		FORWARD AX(VR(Operate_Axis)) 	
		VR(RUN_MODE)=0

	CASE RUN_HOMEN									'Home negative direction mode
		BASE VR(Operate_Axis)
		HOMEN	
		VR(RUN_MODE)=0

	CASE RUN_HOMEP									'Home positive direction mode
		BASE VR(Operate_Axis)
		HOMEP	
		VR(RUN_MODE)=0

	CASE RUN_CLEAR_ERR								'Reset Error mode	
		RESETERR AX(VR(Operate_Axis))
		CLEAR_ERROR	
		VR(RUN_MODE)=0

	CASE RUN_CLEAR_POS								'Reset Position mode
		BASE VR(Operate_Axis)
		DPOS=0
		MPOS=0	
		VR(RUN_MODE)=0

	CASE RUN_JOGN 									'JOG- mode
		JOG_N(JOG_FLAG)								'Call the JOG- method

	CASE RUN_JOGP									'JOG+ mode
		JOG_P(JOG_FLAG)								'Call the JOG+ method
		
END SELECT

SLEEP 50
WEND

'------------------------------------------------------------------
'The concrete implementation of the method
'------------------------------------------------------------------
SUB JOG_N(ByRef JOG_FLAG AS UBYTE)
	IF(VR(Jog_Negative)=1) THEN						'JOG- Button
		JOG_FLAG=1									'JOG_FLAG for the case on loosenning the Jog button
		JOGN AX(VR(Operate_Axis))
	ELSEIF(VR(Jog_Negative)=0 AND JOG_FLAG=1) THEN
		STOPDEC AX(VR(Operate_Axis))
		WAIT DONE
		JOG_FLAG=0									'After loosenning the Jog button，Reset JOG_POSITION and VR(100)
		VR(RUN_MODE)=0
	END IF
END SUB	

SUB JOG_P(ByRef JOG_FLAG AS UBYTE)
	IF(VR(Jog_Positive)=1) THEN						'JOG+ Button
		JOG_FLAG=1
		JOGP AX(VR(Operate_Axis))
	ELSEIF(VR(Jog_Positive)=0 AND JOG_FLAG=1) THEN
		JOG_FLAG=0
		STOPEMG AX(VR(Operate_Axis))
		VR(RUN_MODE)=0
	END IF
END SUB	
'------------------------------------------------------------------







