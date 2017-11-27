DIM SHARED XY AS XY_TABLE					'Declare the XY is XY_TABLE components
DIM SHARED FC AS FlowCtrl					'Declare the FC is FlowCtrl components
Dim SHARED DI_Run AS DInput						'Declare DInput's component 
RUN_TASK "Control02"
'Purpose: Stop Command
Function UserStop() As Integer
	XY.Stop()								'1. In UserStop()，Writing action about how to stop your device action...
	Return Err_Success						'(Do not remove)
End Function

'Purpose: Small Error
Function UserErrS() As Integer
	XY.Stop()								'2. In UserErrS(),Writing action when there is a samll mistake...(Ex: Stop)
	Return Err_Success						'(Do not remove)
End Function

'Purpose: Big Error
Function UserErrB() As Integer
	XY.Stop()								'3. In UserErrB(),Writing action when there is a big mistake...(Ex: Stop)
	Return Err_Success						'(Do not remove)
End Function

'Purpose: Reset Error Command
FUNCTION UserResetErr() As INTEGER
	XY.ResetMotionErr()					    '4. In UserResetErr(),Writing action about how to reset error
	Return Err_Success						'(Do not remove)
End Function

'Purpose: through the change in VR(H_BtnTyp), get the command form HMI
'Inpput:  VR(H_BtnTyp): Key species
'Output： VR(C_Cmd), function DoCmd() will perform actions based on the content of VR(C_Cmd)
Function ScanHmi()As Integer
	IF VR(H_BtnType) =0 THEN Return ERR_Success
	SELECT CASE INT(VR(H_BtnType))
		CASE N_HB_Run 		
			VR(C_Cmd) = N_CMD_Run
		CASE N_HB_Pause 	
			VR(C_Cmd) = N_CMD_Pause
		CASE N_HB_Resume 	
			VR(C_Cmd) = N_CMD_Resume
		CASE N_HB_Step 		
			VR(C_Cmd) = N_CMD_Step
		CASE N_HB_Stop 		
			VR(C_Cmd) = N_CMD_Stop
		CASE N_HB_Home 		
			VR(C_Cmd) = N_CMD_Home
		CASE N_HB_ORG 		
			VR(C_Cmd) = N_CMD_ORG
		CASE N_HB_ResetErr 		
			VR(C_Cmd) = N_CMD_ResetErr
			
		CASE N_HB_Teach_P1 To N_HB_Teach_P4				'When press the Teach-Save button, issue the Save-position command
			VR(C_Cmd) = N_CMD_HomeSub_Teach
			VR(Point_Num) = VR(H_BtnType)- N_HB_Teach_P1
		CASE N_HB_PtP_P1 To N_HB_PtP_P4					'When press the Teach button, issue the PTP command
			VR(C_Cmd) = N_CMD_HomeSub_PtP
			VR(Point_Num) = VR(H_BtnType)- N_HB_PtP_P1			
		CASE N_HB_JogAx_P 								'When press the JOG+ button, issue the JOG+ command
			VR(C_Cmd) = N_CMD_HomeSub_JogAx_P
		CASE N_HB_JogAx_N 								'When press the JOG- button, issue the JOG- command
			VR(C_Cmd) = N_CMD_HomeSub_JogAx_N			
		CASE N_HB_JogAxStop 							'When loosen the JOG button, issue the stop command
			VR(C_Cmd) = N_CMD_HomeSub_JogAxStop
		CASE N_HB_ServoOn                               'When loosen the ServoOn button, issue the Svon command
			VR(C_Cmd) = N_CMD_DbgSub_ServoOn
		CASE N_HB_ServoOff                              'When loosen the ServoOn button, issue the Svoff command
			VR(C_Cmd) = N_CMD_DbgSub_ServoOff	
	END SELECT
	IF VR(C_Cmd)<>0 THEN		VR(H_BtnType) =0		'After issuing command，Reset VR(H_BtnType)
	Return ERR_Success
End Function

'Purpose: Command processing function
FUNCTION DoCmd() AS INTEGER
	DIM As INTEGER Ret = ERR_UnknowCommand
	SELECT CASE INT(VR(C_Cmd))
		CASE N_NO_CMD
			Ret=ERR_NoCommand
		CASE N_CMD_Home									'Home action (Do not remove)
			Ret=FC.CmdHome()
		CASE N_CMD_Org									'Org action (Do not remove)
			Ret=FC.CmdOrg()		
		CASE N_CMD_Run  								'Run action (Do not remove)
			Ret=FC.CmdRun()
		CASE N_CMD_Stop									'Stop action (Do not remove)
			FC.CmdStop()								'FC.CmdStop()should be first(Do not remove)
			Ret=UserStop()								'Your own Stop function...		
		CASE N_CMD_Pause								'Pause action(Do not remove)
			Ret=FC.CmdPause()
		CASE N_CMD_Step									'Step action(Do not remove)
			Ret=FC.CmdStep()					
		CASE N_CMD_Resume								'Resume action(Do not remove)
			Ret=FC.CmdResume()
		CASE N_CMD_OnErrB								'Big Error Occur(Do not remove)
			FC.CmdStop_ErrB()							'Do not remove FC.CmdStop()，and it should be first
			Ret=UserErrB()								'Your own Big Error function...
		CASE N_CMD_OnErrS								'Small Error Occur(Do not remove)
			FC.CmdStop_ErrS()							'Do not remove FC.CmdStop()，and it should be first
			Ret=UserErrS()								'Your own Error handling function...
		CASE N_CMD_ResetErr								'Reset Error(Do not remove)
			Ret=UserResetErr()							'Your own Reset error function...			
			FC.TrigErrTask()							'Do not remove ，and be first

'+++++CASE 101-199:	Debug Ready's sub action command (User difined...）
		CASE N_CMD_DbgSub_ServoOn						'If Command＝N_CMD_DbgSub_ServoOn
			VR(C_SubMD)=N_SMD_ServoOn					'Set "Servo On" sub action's mode number
			Ret=Err_Success
		CASE N_CMD_DbgSub_ServoOff						'If Command＝N_CMD_DbgSub_ServoOff
			VR(C_SubMD)=N_SMD_ServoOff					'Set "Servo Off" sub action's mode number
			Ret=Err_Success
			
'+++++CASE 201-299:	Home_Ready's sub action command (User difined...）
		CASE N_CMD_HomeSub_GoPointA						'If Command＝N_CMD_HomeSub_GoPointA
			VR(C_SubMD)=N_SMD_GoPointA					'Set "Go PointA" sub action's mode number
			Ret=Err_Success
		CASE N_CMD_HomeSub_JogAx_P						'If Command＝N_CMD_HomeSub_JogAx_P
			VR(C_SubMD)=N_SMD_JogAx_P 					'Set "JOG P" sub action's mode number
			Ret=Err_Success
		CASE N_CMD_HomeSub_JogAx_N						'If Command＝N_CMD_HomeSub_JogAx_N
			VR(C_SubMD)=N_SMD_JogAx_N 					'Set "JOG N" sub action's mode number
			Ret=Err_Success
		CASE N_CMD_HomeSub_JogAxStop					'If Command＝N_CMD_HomeSub_JogAxStop
			VR(C_SubMD)=N_SMD_JogAxStop					'Set "JOG Stop" sub action's mode number
			Ret=Err_Success		
		CASE N_CMD_HomeSub_Teach						'In Home Ready mode, save Teach position 
			VR(C_SubMD)=N_SMD_Teach						'Set "Save Position" sub action's mode number
			Return Err_Success
		CASE N_CMD_HomeSub_PtP							'In Home Ready mode,Teach choosed figure
			VR(C_SubMD)=N_SMD_PtP						'Set "Teach" sub action's mode number
			Return Err_Success	

'+++++CASE 301-399:	Org_Ready状态下的子动作模式下命令 (用户自定义...）
'	'CASE 301								'用户自定义动作（命令）

'+++++CASE 401-499:	Run 状态下的子动作模式下命令 (用户自定义...）
'	'CASE 401								'用户自定义动作（命令）

	END Select
	Return Ret
END FUNCTION

'Purpose: Scan the input from Motion
'Output： VR(C_Cmd), function DoCmd() will perform actions based on the content of VR(C_Cmd)
Function ScanMIO()As Integer
	DIM AxNo As Integer
	FOR AxNo=0 TO 1										'Scan axis's SVON status and error code
		BASE AxNo
		IF STATE=3	And FC.IsErr=false	THEN	 		'3: The axis enter into the wrong state
			VR(C_Cmd)=	N_CMD_OnErrS					'Produce the "wrong" command
		END IF
		
		IF STATE=3 THEN									'3: The axis enter into the wrong state
			IF MIO.ALM=1 THEN Return ERR_AxisAlmError   'Axis Alarm
			IF MIO.PEL=1 THEN Return ERR_AxisPelError   'Positive hardware limit in place
			IF MIO.NEL=1 THEN Return ERR_AxisNelError   'Negative hardware limit in place
			IF MIO.EMG=1 THEN Return ERR_AxisEmgError   'Emergency stop
			Return ERR_AxisError
		END IF
		
		IF AxNo=0 THEN VR(AX0_SVON)=MIO.SVON
		IF AxNo=1 THEN VR(AX1_SVON)=MIO.SVON
		
	Next AxNo	
		'Scan DI, If DI Run's rising edge occurs, issue "run" command
	'IF DI_Run.IsEdge_R()=TRUE THEN VR(C_Cmd) = N_CMD_Run	
	Return ERR_Success
End Function

'Purpose: Scan program's current state determines whether HMI button is currently available
Function ScanState()As Integer
	If VR(CS_RunSTA)=N_ST_DbgRdy Then
		VR(Run_btn)=0
		VR(Pause_btn)=0
		VR(Step_btn)=0
		VR(Resume_btn)=0
		VR(Home_btn)=1
		VR(Teach_btn)=1
		VR(Dbg_btn)=1
	ELSEIF VR(CS_RunSTA)=N_ST_HomeRdy Then
		VR(Run_btn)=0
		VR(Pause_btn)=0
		VR(Step_btn)=0
		VR(Resume_btn)=0
		VR(Home_btn)=1
		VR(Teach_btn)=1
		VR(Dbg_btn)=1
	ELSEIF VR(CS_RunSTA)=N_ST_OrgRdy Then
		VR(Run_btn)=1
		VR(Pause_btn)=0
		VR(Step_btn)=1
		VR(Resume_btn)=0
		VR(Home_btn)=0
		VR(Teach_btn)=1
		VR(Dbg_btn)=1
	ELSEIF VR(CS_RunSTA)=N_ST_RunAuto Then
		VR(Run_btn)=0
		VR(Pause_btn)=1
		VR(Step_btn)=0
		VR(Resume_btn)=0
		VR(Home_btn)=0
		VR(Teach_btn)=0
		VR(Dbg_btn)=0
	ELSEIF VR(CS_RunSTA)=N_ST_RunPause Then
		VR(Run_btn)=0
		VR(Pause_btn)=0
		VR(Step_btn)=1
		VR(Resume_btn)=1
		VR(Home_btn)=0
		VR(Teach_btn)=0
		VR(Dbg_btn)=0
	ELSEIF VR(CS_RunSTA)=N_ST_ErrB_Pause Or VR(CS_RunSTA)=N_ST_ErrS_Pause Then
		VR(Run_btn)=0
		VR(Pause_btn)=0
		VR(Step_btn)=0
		VR(Resume_btn)=0
		VR(Home_btn)=0
		VR(Teach_btn)=0
		VR(Dbg_btn)=0
	End If
	Return ERR_Success
End FUNCTION
'Purpose: System scan back loop (content immutable)
Dim As Integer Ret_1, Ret_2
WHILE(1)
	Ret_1 = ScanHmi()									'Scan HMI
	Ret_1 = ScanMIO()									'Sacn Motion I/O
	Ret_2 = FC.CheckCmd()								'Check the legality of the command	
	ScanState()											'Monitor whether the button is available in the current state
	IF Ret_2=ERR_Success THEN
		Ret_2 = DoCmd()									'According to ScanHmi(), ScanMIO()'s result, perform the operation
	END IF
	
	IF Ret_2<>ERR_UnknowCommand THEN VR(C_Cmd)=0		'If the command has been processed,reset VR(C_Cmd), VR(C_SubMD)
	IF Ret_2<>ERR_NoCommand THEN VR(CS_WarnId)=Ret_2 	'update	'Warning' status
	VR(CS_ErrId)=Ret_1									'update	'Error'	status
	SLEEP(10)
WEND



