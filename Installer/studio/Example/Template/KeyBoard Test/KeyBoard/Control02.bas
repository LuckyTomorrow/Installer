
DIM SHARED XYZ AS XYZ_TABLE							'Declare XYZ_TABLE's component
DIM SHARED FC AS FlowCtrl							'Declare FlowCtrl's component 

'Purpose：Initialization mode
SUB Init
	'In this mode, please write the initialization action...
	BASE 0,1,2
	SVON
	VL=2000
	VH=8000
	ACC=20000
	DEC=ACC
	
	JOG_VL=2000
	JOG_VH=8000
	JOG_ACC=20000
	JOG_DEC=JOG_ACC
	
	HOME_VL=2000
	HOME_VH=8000
	HOME_ACC=20000
	HOME_DEC=HOME_ACC
	
	RUN_TASK "cmd02"
END SUB

'Purpose：Back to the mechanical origin
SUB ModeHome
	'In this mode, write your Org action...
	XYZ.Home_XYZ()
	XYZ.WaitDone()
	'.......
END SUB

'Purpose：Approval for processing(Contains action: XY Table to work origin, 
'cylinder, peripheral equipment get into the preparation state)
SUB ModeOrg
	'In this mode, write your action...
	XYZ.MOVE_XY VR(CR_OrgX),VR(CR_OrgY)
	XYZ.WaitDone()
	XYZ.MOVE_Z VR(CR_OrgZ)
	XYZ.WaitDone()
	VR(CS_RunStepCount)=0
	'.......
END SUB

'Purpose：Stop mode
SUB ModeStop
	WAIT DONE										'Wait Motion DONE for Stop Command(cmd.bas) 
	'In this mode，write your action after Motion has stopped...
	
END SUB

'Purpose：Big Error mode
SUB ModeErrB
	WAIT DONE										'Wait Motion DONE for ErrStop Command(cmd.bas) 	
	'In this mode，write your action after Motion has stopped because of big error...
END SUB

'Purpose：Small Error mode
SUB ModeErrS
	WAIT DONE										'Wait Motion DONE for ErrStop Command(cmd.bas) 
	'In this mode，write your action after Motion has stopped because of small error...
	
END SUB

'Get the total length of the string
SUB GetTotalNum()
	VR(TotalNum_Char)=0
	FOR i AS INTEGER = 0 TO 19
		IF VR(Star_Char + i) <>0 THEN
			VR(TotalNum_Char)+=1
		ELSEIF(VR(Star_Char + i) =0) THEN
			EXIT SUB
		END IF
	NEXT i
END SUB

'Locate current character
SUB FindCharNum()					
	IF(VR(Star_Char+VR(CUR_INDEX))=0) THEN					'Used in the case of shorter strings than before
		VR(CUR_INDEX)=0
	END IF
	
	FOR i AS INTEGER=0 TO 9
		IF(VR(Star_Char+VR(CUR_INDEX))=ASC("0")+i) THEN 	'Get the numeric value of the current character
			VR(CUR_KEY)= VR(Star_Char+VR(CUR_INDEX))		'The ASC value of the current character is assigned to VR(CUR_KEY)
			VR(CUR_KEY_NUM)= CUSHORT(i)						'The numeric value of the current character is assigned to VR(CUR_KEY)		
		END IF
	NEXT i	
END SUB

'After motion done, the current character index is added 1 and is determined whether it is empty
SUB JudgeCharNum()
	VR(Cur_Index) +=1
	IF(VR(Star_Char + VR(Cur_Index))=0) THEN
		VR(Cur_Index) =0
	END IF
END SUB 

'Copy choosed figure's positionX,positionY and positionZ to VR(CR_MoveX), VR(CR_MoveY), VR(CR_MoveZ)
SUB  CopyData2MoveReg(Id As Integer)
	DIM AS Integer Index = C_DataIndexBase + Id*3
	VR(CR_MoveX)= VR(Index+0)
	VR(CR_MoveY)= VR(Index+1)
	VR(CR_MoveZ)= VR(Index+2)
END SUB

'Purpose：Run mode
SUB ModeRun
	'User custom action code, please write in this mode...
	GetTotalNum()
	FindCharNum()
	DIM AS INTEGER MaxCharNum= VR(TotalNum_Char)
	DIM AS INTEGER StarCharNum= VR(Cur_Index)
	DIM AS INTEGER i
	FOR i =StarCharNum TO MaxCharNum-1
		CopyData2MoveReg(VR(CUR_KEY_NUM))				'The process of running a number：
		XYZ.MOVE_XY VR(CR_MoveX),VR(CR_MoveY)			'First, move to the specified X and Y coordinates
		XYZ.WaitDone()	
		FC.ChecknPause()
		
		XYZ.MOVE_Z VR(CR_MoveZ)							'Second, move to the specified Z coordinate
		XYZ.WaitDone()	
		FC.ChecknPause()
		
		XYZ.MOVE_Z VR(CR_OrgZ)							'Last, move to the origin Z coordinate
		XYZ.WaitDone()	
		FC.ChecknPause()
		
		JudgeCharNum()
		FindCharNum()
	NEXT i
END SUB

'-------------------------------------------------------------------- 
'In Org mode, User-defined actions...
'-------------------------------------------------------------------- 
'Purpose: In Org mode,Demonstration action...To Point A
SUB SubMode_GoPointA
	CopyData2MoveReg(0)
	BASE 0,1,2
	LINEABS VR(CR_MoveX),VR(CR_MoveY), VR(CR_MoveZ)		'point 0
	WAIT DONE	
END SUB 

'Purpose: JOG P
SUB SubMode_JogAx_P()	 								'JOG+ mode
	BASE VR(CR_JogAxId)
	JOGP
END SUB
'Purpose: JOG N
SUB SubMode_JogAx_N()	 								'JOG- mode
	BASE VR(CR_JogAxId)
	JOGN
END SUB
'Purpose: JogStop
SUB SubMode_JogAxStop()	 								'JOG Stop mode
	BASE VR(CR_JogAxId)
	STOPDEC
END SUB

'Purpose: Save figure 0-9's position
SUB SubMode_Teach()	 									'Save Position
	DIM AS Integer Index = C_DataIndexBase + VR(Teach_Num)*3
	BASE 0
	VR(Index+0) = DPOS
	BASE 1
	VR(Index+1) = DPOS
	BASE 2
	VR(Index+2) = DPOS
END SUB

'Purpose: Teach figure 0-9
SUB SubMode_PtP()	 									'Teach
	DIM AS Integer Index = C_DataIndexBase + VR(Teach_Num)*3
	VR(CR_MoveX)= VR(Index+0)
	VR(CR_MoveY)= VR(Index+1)
	VR(CR_MoveZ)= VR(Index+2)
	
	XYZ.MOVE_XY VR(CR_MoveX),VR(CR_MoveY)
	XYZ.WaitDone()
	XYZ.MOVE_Z VR(CR_MoveZ)
	XYZ.WaitDone()
	XYZ.MOVE_Z VR(CR_OrgZ)
	XYZ.WaitDone()
END SUB

'Purpose：Handle the allowed custom actions in Org mode...
SUB ModeHome_SubActions
	SELECT CASE INT(VR(C_SubMD))
	CASE N_SMD_GoPointA									'Demonstration action...To Point A
		SubMode_GoPointA()
	CASE N_SMD_JogAx_P									'JOG P
		SubMode_JogAx_P()
	CASE N_SMD_JogAx_N									'JOG N
		SubMode_JogAx_N()		
	CASE N_SMD_JogAxStop								'Stop JOG
		SubMode_JogAxStop()
	CASE N_SMD_Teach									'Save figure 0-9's position
		SubMode_Teach()
	CASE N_SMD_PtP										'Teach
		SubMode_PtP()
	END SELECT
END SUB
'--------------------------------------------------------------------

'-------------------------------------------------------------------- 
'In Debug mode, User-defined actions...
'-------------------------------------------------------------------- 
'Purpose: In Debug mode,Demonstration action...Servo On
SUB SubMode_ServoOn
	BASE 0,1,2
	SVON
END SUB
'Purpose: In Debug mode,Demonstration action...Servo Off
SUB SubMode_ServoOff
	BASE 0,1,2
	SVOFF
END SUB

'Purpose：Handle the allowed custom actions in Debug mode...
SUB ModeDbg_SubActions
	SELECT CASE INT(VR(C_SubMD))
	CASE N_SMD_ServoOn									'Demonstration action...Servo On
		SubMode_ServoOn()
	CASE N_SMD_ServoOff									'Demonstration action...Servo Off
		SubMode_ServoOff()		
	'CASE N_SMD_xxx										'User difined...
	END SELECT
END SUB
'--------------------------------------------------------------------

'Master control program (Do not modify)
VR(C_RunMD)=N_MD_Idle
WHILE(1)
	FC.SetPreMode()										'(Do not modify)
	SELECT CASE INT(VR(C_RunMD))
	CASE N_MD_Idle										'(Do not modify)
		Init()
	CASE N_MD_Home										'(Do not modify)
		ModeHome()
	CASE N_MD_Org										'(Do not modify)
		ModeORG()
	CASE N_MD_Run										'(Do not modify)
		ModeRun()
	CASE N_MD_Stop  									'(Do not modify)
		ModeStop()
	CASE N_MD_ErrS										'(Do not modify)
		ModeErrS()
	CASE N_MD_ErrB										'(Do not modify)
		ModeErrB()
	CASE N_MD_Home_SubActions							'(Do not modify)
		ModeHome_SubActions()							'(Do not modify)
	CASE N_MD_Dbg_SubActions							'(Do not modify)
		ModeDbg_SubActions()							'(Do not modify)
	'CASE N_MD_Org_SubActions							'(Do not modify)
	'CASE N_MD_Run_SubActions							'(Do not modify)
	END SELECT
	
	FC.SetNextMode()									'(Do not modify)
	SLEEP(10)
WEND

