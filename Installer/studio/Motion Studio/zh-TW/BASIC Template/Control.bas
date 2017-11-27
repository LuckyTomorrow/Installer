
DIM SHARED XYZ AS XYZ_TABLE
DIM SHARED FC AS FlowCtrl
'Purpose：初始化模式
SUB Init
	'請在此模式下，編寫您的初始化動作...
	'BASE 0,1,2
	'VH=1000
	'DPOS=0
	'MPOS=0
END SUB

'Purpose：回機械原點
SUB ModeHome
	'請在此模式下，編寫您的回原點動作...
END SUB

'Purpose：淮備加工 (包含動作: XY Table到工作原點, 汽缸, 周邊設備進入淮備加工狀態)
SUB ModeOrg
	VR(CS_RunStepCount)=0
	'請在此模式下，編寫您的到工作原點動作...
	'XYZ.MOVE_XYZ 5000, 5000, 5000			'ORG	
	'WAIT DONE
END SUB

'Purpose：停止模式
SUB ModeStop
	WAIT DONE									'Wait Motion DONE for Stop Command(cmd.bas) 
	'....										'2. 在ModeStop()，編寫停止後, 您希望執行的動作...
END SUB

'Purpose：Big Error 模式
SUB ModeErrB
	WAIT DONE									'Wait Motion DONE for ErrStop Command(cmd.bas) 
	'....										'2. 在ModeErrB(), 編寫Motion錯誤停止後, 您希望執行的動作...
END SUB											'3. 在ModeErrB()結束後, 系統會暫停Control.bas的執行, 並等待清除錯誤命令


'Purpose：Small Error 模式
SUB ModeErrS
	WAIT DONE									'Wait Motion DONE for ErrStop Command(cmd.bas) 
	'....										'2. 在ModeErrS(), 編寫Motion錯誤停止後, 您希望執行的動作...
END SUB											'3. 在ModeErrS()結束後, 系統會暫停Control.bas的執行, 並等待清除錯誤命令

'Purpose：運行模式
SUB ModeRun
	'用戶自定義動作代碼, 請編寫於此運行模式下...
	'示範動作: 
	'XYZ.MOVE_XYZ 5000, 6000, 7000				'path 0
	'XYZ.WaitDone()	
	'FC.ChecknPause()
	'XYZ.MOVE_XYZ 15000, 16000, 17000			'path 1
	'XYZ.WaitDone()	
	'FC.ChecknPause()
END SUB

'-------------------------------------------------------------------- 
'Debug 模式下的用戶自定義動作...
'-------------------------------------------------------------------- 
'Purpose：處理Debug模式下的允許的動作...
SUB ModeDbg_SubActions
	SELECT CASE INT(VR(C_SubMD))				'依照子模式值VR(C_SubMD), 決定要處理的動作
	CASE 1										'當子動作模式VR(C_SubMD)=1 時(Servo On)
		BASE 0,1,2
		SVON
	'CASE N_SMD_xxx								'用戶自定義...
	END SELECT
END SUB

'-------------------------------------------------------------------- 
'原點模式下的用戶自定義動作...
'-------------------------------------------------------------------- 
'Purpose：處理原點模式下的允許的自定義動作...
SUB ModeHome_SubActions
	SELECT CASE INT(VR(C_SubMD))				'依照子模式值VR(C_SubMD), 決定要處理的動作
	CASE 2										'當子動作模式VR(C_SubMD)=2 時(到A點)
		BASE 0,1,2
		LINEABS 1000, 1000, 1000
		WAIT DONE	
	'CASE N_SMD_xxx								'用戶自定義...
	END SELECT
END SUB



'主控制程式（請勿修改）
VR(C_RunMD)=N_MD_Idle
WHILE(1)
	FC.SetPreMode()								'(不可更動）
	SELECT CASE INT(VR(C_RunMD))
	CASE N_MD_Idle								'(不可更動）
		Init()
	CASE N_MD_Home								'(不可更動）
		ModeHome()
	CASE N_MD_Org								'(不可更動）
		ModeORG()
	CASE N_MD_Run								'(不可更動）
		ModeRun()
	CASE N_MD_Stop  							'(不可更動）
		ModeStop()
	CASE N_MD_ErrS								'(不可更動）
		ModeErrS()
	CASE N_MD_ErrB								'(不可更動）
		ModeErrB()
	CASE N_MD_Home_SubActions					'(不可更動）
		ModeHome_SubActions()				
	CASE N_MD_Dbg_SubActions					'(不可更動）
		ModeDbg_SubActions()
	'CASE N_MD_Org_SubActions					'(不可更動）
	'CASE N_MD_Run_SubActions					'(不可更動）
	END SELECT
	FC.SetNextMode()							'(不可更動）
	SLEEP(10)
WEND


