
DIM SHARED XYZ AS XYZ_TABLE
DIM SHARED FC AS FlowCtrl
'Purpose：初始化模式
SUB Init
	'请在此模式下，编写您的初始化动作...
	'BASE 0,1,2
	'VH=1000
	'DPOS=0
	'MPOS=0
END SUB

'Purpose：回机械原点
SUB ModeHome
	'请在此模式下，编写您的回原点动作...
END SUB

'Purpose：淮备加工 (包含动作: XY Table到工作原点, 汽缸, 周边设备进入淮备加工状态)
SUB ModeOrg
	VR(CS_RunStepCount)=0
	'请在此模式下，编写您的到工作原点动作...
	'XYZ.MOVE_XYZ 5000, 5000, 5000			'ORG	
	'WAIT DONE
END SUB

'Purpose：停止模式
SUB ModeStop
	WAIT DONE									'Wait Motion DONE for Stop Command(cmd.bas) 
	'....										'2. 在ModeStop()，编写停止后, 您希望执行的动作...
END SUB

'Purpose：Big Error 模式
SUB ModeErrB
	WAIT DONE									'Wait Motion DONE for ErrStop Command(cmd.bas) 
	'....										'2. 在ModeErrB(), 编写Motion错误停止后, 您希望执行的动作...
END SUB											'3. 在ModeErrB()结束后, 系统会暂停Control.bas的执行, 并等待清除错误命令


'Purpose：Small Error 模式
SUB ModeErrS
	WAIT DONE									'Wait Motion DONE for ErrStop Command(cmd.bas) 
	'....										'2. 在ModeErrS(), 编写Motion错误停止后, 您希望执行的动作...
END SUB											'3. 在ModeErrS()结束后, 系统会暂停Control.bas的执行, 并等待清除错误命令

'Purpose：运行模式
SUB ModeRun
	'用户自定义动作代码, 请编写于此运行模式下...
	'示范动作: 
	'XYZ.MOVE_XYZ 5000, 6000, 7000				'path 0
	'XYZ.WaitDone()	
	'FC.ChecknPause()
	'XYZ.MOVE_XYZ 15000, 16000, 17000			'path 1
	'XYZ.WaitDone()	
	'FC.ChecknPause()
END SUB

'-------------------------------------------------------------------- 
'Debug 模式下的用户自定义动作...
'-------------------------------------------------------------------- 
'Purpose：处理Debug模式下的允许的动作...
SUB ModeDbg_SubActions
	SELECT CASE INT(VR(C_SubMD))				'依照子模式值VR(C_SubMD), 决定要处理的动作
	CASE 1										'当子动作模式VR(C_SubMD)=1 时(Servo On)
		BASE 0,1,2
		SVON
	'CASE N_SMD_xxx								'用户自定义...
	END SELECT
END SUB

'-------------------------------------------------------------------- 
'原点模式下的用户自定义动作...
'-------------------------------------------------------------------- 
'Purpose：处理原点模式下的允许的自定义动作...
SUB ModeHome_SubActions
	SELECT CASE INT(VR(C_SubMD))				'依照子模式值VR(C_SubMD), 决定要处理的动作
	CASE 2										'当子动作模式VR(C_SubMD)=2 时(到A点)
		BASE 0,1,2
		LINEABS 1000, 1000, 1000
		WAIT DONE	
	'CASE N_SMD_xxx								'用户自定义...
	END SELECT
END SUB



'主控制程式（请勿修改）
VR(C_RunMD)=N_MD_Idle
WHILE(1)
	FC.SetPreMode()								'(不可更动）
	SELECT CASE INT(VR(C_RunMD))
	CASE N_MD_Idle								'(不可更动）
		Init()
	CASE N_MD_Home								'(不可更动）
		ModeHome()
	CASE N_MD_Org								'(不可更动）
		ModeORG()
	CASE N_MD_Run								'(不可更动）
		ModeRun()
	CASE N_MD_Stop  							'(不可更动）
		ModeStop()
	CASE N_MD_ErrS								'(不可更动）
		ModeErrS()
	CASE N_MD_ErrB								'(不可更动）
		ModeErrB()
	CASE N_MD_Home_SubActions					'(不可更动）
		ModeHome_SubActions()				
	CASE N_MD_Dbg_SubActions					'(不可更动）
		ModeDbg_SubActions()
	'CASE N_MD_Org_SubActions					'(不可更动）
	'CASE N_MD_Run_SubActions					'(不可更动）
	END SELECT
	FC.SetNextMode()							'(不可更动）
	SLEEP(10)
WEND


