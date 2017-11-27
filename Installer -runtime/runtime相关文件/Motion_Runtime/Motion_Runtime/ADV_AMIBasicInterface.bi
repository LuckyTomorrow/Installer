'fbc -w all "%f" -include ./Public/ADV_AMIBasicInterface.bi
#Inclib "AdvAMIBasic"
#include "string.bi"			'yf,2017.05.17   
'#Inclib "boost_system"
#define MAXVR 10000
#define MAXTABLE 50000
#define MAXDO 1024
#define MAXDI 1024
#define MAXAX 32
'#define DBL_MAX  2147483647
#define DBL_MAX  2147483648		'yf,set a invilid vale
#define LONG_MAX 2147483647		'yf,add 
#define ABAS_DFT_AXIS 32767		'yf,default axis "32767" as multi axis
#define ABAS_DFT_CYLID 32767	
#undef BASE
#undef LINE
#undef WAIT
'#undef OUT

#define PI 3.14159265358979323846
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Declare sub Basic_InitProcess Cdecl Alias "AMI_Basic_InitProcess"() 
Declare sub Basic_ExitProcess  Cdecl Alias "AMI_Basic_ExitProcess"() 
Declare Function DecryptString Cdecl Alias "AMI_DecryptString"(ByVal passwd As zstring ptr) As Boolean
sub InitProcess ()  constructor
	'print "-----------InitProcess-----------"				'yf,2016.07.05 mark info output
	Basic_InitProcess()
	'print "--------InitProcess Done--------"					'yf,2016.07.05 mark info output
	#ifdef ENC
    Dim tempStr as string = str(ENC)	
	dim tempchar as zstring ptr
	tempchar = StrPtr(tempStr)	
	DecryptString(tempchar)
	#endif
end sub
sub ExitProcess ()  destructor
	'print "-----------ExitProcess-----------"				'yf,2016.07.05 mark info output
	Basic_ExitProcess()
	'print "--------ExitProcess  Done--------"				'yf,2016.07.05 mark info output
end sub
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'TCP/IP
Declare Function TCP_Open Cdecl Alias "ABAS_OpenEthernet"(ByVal PortID as short, ByVal mode as short, ByVal portNum as unsigned short, ByVal IP As ZString Ptr = @"127.0.0.1") As Ulong 
Declare Function TCP_Close Cdecl Alias "ABAS_CloseEthernet"(ByVal PortID as short) As Ulong 
Declare Function ABAS_WriteEthernetStream Cdecl Alias "ABAS_WriteEthernetStream"(ByVal PortID as short, ByVal ByteArray As any Ptr, ByVal Num As Integer) As Ulong 
Declare Function ABAS_ReadEthernetStream Cdecl Alias "ABAS_ReadEthernetStream"(ByVal PortID as short, ByVal ByteArray As byte Ptr, ByVal Num As Integer, endStr as zstring ptr = @"#", utimeout as ulong = 0) As Ulong
Declare Function TCP_WriteVR Cdecl Alias "ABAS_WriteEthernetStreamVR"(ByVal PortID as short, ByVal vr_start As Integer, ByVal Num As Integer, dformat as integer) As Ulong 
Declare Function TCP_ReadVR Cdecl Alias "ABAS_ReadEthernetStreamVR"(ByVal PortID as short, ByVal vr_start As Integer, ByVal Num As Integer, dformat as integer, utimeout as ulong = 0) As Ulong 
Declare Function TCP_ResetBuf Cdecl Alias "ABAS_ResetEthernetBuffer"(ByVal PortID as short) As Ulong 
Declare SUB TCP_WAIT Cdecl Alias "ABAS_WaitTcp"(ByVal PortID as short, utimeOut as ulong = 0)
Declare Function TCP_CHECK Cdecl Alias "ABAS_TcpGetCharsNum"(ByVal PortID as short) As Ulong
Declare Function Tcp_Status Cdecl Alias "ABAS_TcpStatus"(ByVal PortID as short) As Ulong
'SERIAL PORTS
Declare Function COM_OPEN Cdecl Alias "ABAS_OpenComPort"(ByVal PortID as short) As Ulong 	' yangfei,2016.06.03 rename
Declare Function COM_ClOSE Cdecl Alias "ABAS_CloseComPort"(ByVal PortID as short) As Ulong 
Declare Function COM_SET Cdecl Alias "ABAS_SetComPort"(ByVal PortID as short, ByVal baudRate As UInteger, ByVal Parity As Integer, ByVal stopBits As Integer, ByVal charSize As UInteger ) As Ulong 
Declare Function ABAS_WriteComStream Cdecl Alias "ABAS_WriteComStream"(ByVal PortID as short, ByVal ByteArray As any Ptr, ByVal Num As Integer) As Ulong 
Declare Function ABAS_ReadComStream Cdecl Alias "ABAS_ReadComStream"(ByVal PortID as short, ByVal ByteArray As any Ptr, ByVal Num As Integer) As Ulong
Declare Function COM_WriteVR Cdecl Alias "ABAS_WriteComStreamVR"(ByVal PortID as short, ByVal vr_start As Integer, ByVal Num As Integer) As Ulong 
Declare Function COM_ReadVR Cdecl Alias "ABAS_ReadComStreamVR"(ByVal PortID as short, ByVal vr_start As Integer, ByVal Num As Integer) As Ulong 
Declare Function COM_ResetBuf Cdecl Alias "ABAS_ResetComBuffer"(ByVal PortID as short) As Ulong 

'SYSTEM
Declare Function File_WriteVR Cdecl Alias "ABAS_File_WriteVR"(ByVal path_file As ZString ptr, ByVal vr_start As Integer, ByVal vr_end As Integer) As Boolean
Declare Function File_ReadVR Cdecl Alias "ABAS_File_ReadVR"(ByVal path_file As ZString ptr) As Boolean
Declare Function RUN_TASK Cdecl Alias "ABAS_StartTask"(ByVal TaskName As ZString ptr, ByVal Option As unsigned short = 0) As Ulong
Declare Function STOP_TASK Cdecl Alias "ABAS_StopTask"(ByVal TaskName As ZString ptr) As Ulong
Declare Function STOP_ALL Cdecl Alias "ABAS_StopAllTask"() As Ulong  
'VR
Declare Sub WriteVR Cdecl Alias "ABAS_WriteVR"(ByVal Index As unsigned long , ByVal Value As double)
Declare Function ReadVR Cdecl Alias "ABAS_ReadVR"(ByVal Index As unsigned long) As double
 
'TABLE
Declare Sub WriteTable Cdecl Alias "ABAS_WriteTable"(ByVal Index As unsigned long , ByVal Value As double)
Declare Function ReadTable Cdecl Alias "ABAS_ReadTable"(ByVal Index As unsigned long) As double
  
'DIO
Declare Sub WriteDO Cdecl Alias "ABAS_WriteDO"(ByVal DoIndex As ULong, ByVal BitValue As Ubyte)
Declare Function ReadDO Cdecl Alias "ABAS_ReadDO"(ByVal DoIndex As ULong) As Ubyte
Declare Function ReadDI Cdecl Alias "ABAS_ReadDI"(ByVal DiIndex As ULong) As Ubyte

'Motion
Declare Sub BASE Cdecl Alias "ABAS_BASEAX" (ByVal AxisID As Short, ByVal AxisID1 As Short = ABAS_DFT_AXIS, ByVal AxisID2 As Short = ABAS_DFT_AXIS, ByVal AxisID3 As Short = ABAS_DFT_AXIS, ByVal AxisID4 As Short = ABAS_DFT_AXIS, ByVal AxisID5 As Short = ABAS_DFT_AXIS, ByVal AxisID6 As Short = ABAS_DFT_AXIS, ByVal AxisID7 As Short = ABAS_DFT_AXIS, ByVal AxisID8 As Short = ABAS_DFT_AXIS,...)
Declare Sub ABAS_MOVE Cdecl Alias "ABAS_MOVEAX"(ByVal AxisID As Short, ByVal Distance As Double = DBL_MAX, ByVal Distance1 As Double = DBL_MAX, ByVal Distance2 As Double = DBL_MAX, ByVal Distance3 As Double = DBL_MAX, ByVal Distance4 As Double = DBL_MAX, ByVal Distance5 As Double =DBL_MAX,...)
Declare Sub ABAS_MOVEABS Cdecl Alias "ABAS_MOVEABSAX"(ByVal AxisID As Short, ByVal Distance As Double = DBL_MAX,ByVal Distance1 As Double = DBL_MAX,ByVal Distance2 As Double = DBL_MAX,ByVal Distance3 As Double = DBL_MAX,ByVal Distance4 As Double = DBL_MAX,ByVal Distance5 As Double =DBL_MAX,...)
Declare Sub ABAS_MOVEV Cdecl Alias "ABAS_MOVEVAX"(ByVal AxisID As Short, ByVal Direction As Short = -1, ByVal Direction1 As Short = -1, ByVal Direction2 As Short = -1, ByVal Direction3 As Short = -1, ByVal Direction4 As Short = -1, ByVal Direction5 As Short = -1,...)
Declare Sub ABAS_HOME Cdecl Alias "ABAS_HOMEAX"(ByVal AxisID As Short, ByVal Direction As Short = -1,   ByVal Direction1 As Short = -1, ByVal Direction2 As Short= -1, ByVal Direction3 As Short= -1, ByVal Direction4 As Short= -1, ByVal Direction5 As Short= -1,...)
Declare Sub ABAS_STOPDEC Cdecl Alias "ABAS_STOPAX"(ByVal AxisID As Short,ByVal DecValue As Double = -1.0,ByVal DecValue1 As Double = -1.0,ByVal DecValue2 As Double = -1.0,ByVal DecValue3 As Double = -1.0,ByVal DecValue4 As Double = -1.0,ByVal DecValue5 As Double = -1.0,...)
Declare Sub ABAS_STOPEMG Cdecl Alias "ABAS_STOPEMGAX"(ByVal AxisID As Short = -1, ByVal AxisID1 As Short = -1,ByVal AxisID2 As Short = -1,ByVal AxisID3 As Short = -1,ByVal AxisID4 As Short = -1,ByVal AxisID5 As Short = -1,...)
Declare Sub ABAS_SERVO Cdecl Alias "ABAS_SERVOAX"(ByVal AxisID As Short, ByVal OnOff As Short = -1,   ByVal OnOff1 As Short = -1, ByVal OnOff2 As Short= -1, ByVal OnOff3 As Short= -1, ByVal OnOff4 As Short= -1, ByVal OnOff5 As Short= -1,...)
Declare Sub ABAS_RESETERR Cdecl Alias "ABAS_RESETERR"(ByVal AxisID As Short = -1, ByVal AxisID1 As Short = -1,ByVal AxisID2 As Short = -1,ByVal AxisID3 As Short = -1,ByVal AxisID4 As Short = -1,ByVal AxisID5 As Short = -1,...)

Declare Sub ABAS_WAIT Cdecl Alias "ABAS_WAIT"(ByVal AxisID As Short = -1, ByVal Mode As Short = 0)
Declare Sub ABAS_ADDMOVE Cdecl Alias "ABAS_ADDMOVEAX"(ByVal AxisID As Short = -1, ByVal DPos as double , ByVal Vel as double)
Declare Sub ABAS_PCHANGE Cdecl Alias "ABAS_PCHANGEAX"(ByVal AxisID As Short = -1, ByVal DPos as double)
Declare Sub ABAS_VCHANGEEX Cdecl Alias "ABAS_VCHANGEEX"(ByVal AxisID As Short = -1, ByVal Vel as double, ByVal Acc as double, ByVal Dec as double)
Declare Sub ABAS_VCHANGERATEEX  Cdecl Alias "ABAS_VCHANGERATEEX"(ByVal AxisID As Short = -1, ByVal Rate as Ulong, ByVal Acc as double, ByVal Dec as double)
Declare Sub ABAS_VCHANGE Cdecl Alias "ABAS_VCHANGE"(ByVal AxisID As Short = -1, ByVal Vel as double)
Declare Sub ABAS_VCHANGERATE Cdecl Alias "ABAS_VCHANGERATE"(ByVal AxisID As Short = -1, ByVal Rate as Ulong)
Declare Sub ABAS_EXTDRIVER Cdecl Alias "ABAS_EXTDRIVERAX"(ByVal AxisID As Short = -1, ByVal Mode as Ushort)
'Declare Sub ABAS_MOVEJOG Cdecl Alias "ABAS_MOVEJOGAX"(ByVal AxisID As Short = -1, ByVal Direction as Ushort)
Declare Sub ABAS_MOVEJOG Cdecl Alias "ABAS_MOVEJOGAX"(ByVal AxisID As Short = -1, ByVal Direction1 as Ushort = 0,...)		'yf,2016.06.17
'Declare Sub ABAS_SYNC Cdecl Alias "ABAS_SYNCAX"(ByVal AxisID As Short = -1, ByVal Mode As UShort, ByVal Distance As Double = DBL_MAX,ByVal Distance1 As Double = DBL_MAX,ByVal Distance2 As Double = DBL_MAX,ByVal Distance3 As Double = DBL_MAX,ByVal Distance4 As Double = DBL_MAX,ByVal Distance5 As Double =DBL_MAX)
Declare Sub ABAS_STA Cdecl Alias "ABAS_STAAX"(ByVal AxisID As Short, ByVal Distance As Double = DBL_MAX, ByVal Distance1 As Double = DBL_MAX, ByVal Distance2 As Double = DBL_MAX, ByVal Distance3 As Double = DBL_MAX, ByVal Distance4 As Double = DBL_MAX, ByVal Distance5 As Double =DBL_MAX,...)
Declare Sub ABAS_STAABS Cdecl Alias "ABAS_STAABSAX"(ByVal AxisID As Short, ByVal Distance As Double = DBL_MAX,ByVal Distance1 As Double = DBL_MAX,ByVal Distance2 As Double = DBL_MAX,ByVal Distance3 As Double = DBL_MAX,ByVal Distance4 As Double = DBL_MAX,ByVal Distance5 As Double =DBL_MAX,...)
Declare Sub ABAS_STAVEL Cdecl Alias "ABAS_STAVAX"(ByVal AxisID As Short, ByVal Direction As Short = -1, ByVal Direction1 As Short = -1, ByVal Direction2 As Short = -1, ByVal Direction3 As Short = -1, ByVal Direction4 As Short = -1, ByVal Direction5 As Short = -1,...)
Declare Sub ABAS_STARTSTA Cdecl Alias "ABAS_STARTSTAAX"(ByVal AxisID As Short = -1)
Declare Sub ABAS_STOPSTA Cdecl Alias "ABAS_STOPSTAAX"(ByVal AxisID As Short = -1)
Declare Sub ABAS_GEAR Cdecl Alias "ABAS_GEARAX"(ByVal AxisID As Short, ByVal Numerator As LONG, ByVal Denominator As LONG, ByVal RefSrc As ULONG, ByVal Absolute As ULONG)
Declare Sub ABAS_GANTRY Cdecl Alias "ABAS_GANTRYAX"(ByVal AxisID As Short, ByVal RefMasterSrc As Short, ByVal Direction As Short)
Declare Sub ABAS_TANGENT Cdecl Alias "ABAS_TANGENTAX"(ByVal AxisID As Short, ByVal StartVectorArray As Short Ptr, ByVal Plane As UBYTE, ByVal Direction As Short)
Declare Sub ABAS_PHASE Cdecl Alias "ABAS_PHASEAX" (ByVal AxisID As Short, ByVal Acc as double, ByVal Dec as double, ByVal PhaseSpeed as double, ByVal PhaseDist as double)

'Latch
Declare Function ABAS_LPOS Cdecl Alias "ABAS_LPOS"(ByVal AxisID As Short, ByVal PositionNo As Ulong) AS Double
Declare Sub ABAS_LBUF_RESET Cdecl Alias "ABAS_RESETLTCBUF"(ByVal AxisID As Short)
Declare Sub ABAS_LTC Cdecl Alias "ABAS_LTC"(ByVal AxisID As Short)
Declare Sub ABAS_RESETLTC Cdecl Alias "ABAS_RESETLTC"(ByVal AxisID As Short)
Declare Function ABAS_GETLTCFLAG Cdecl Alias "ABAS_GETLTCFLAG"(ByVal AxisID As Short) AS UShort		'yf,2016.06.29
Declare Sub ABAS_GetLatchBufferData Cdecl Alias "ABAS_GetLatchBufferData"(ByVal AxisID As Short, DataArray As double ptr, ByRef DataCnt As ULONG) 
Declare Sub ABAS_LBUF_STATUS Cdecl Alias "ABAS_GetLatchBufferStatus"(ByVal AxisID As Short, ByRef RemCant As ULONG, ByRef SpaceCnt As ULONG) 
'CMP
Declare Function ABAS_CPOS Cdecl Alias "ABAS_CPOS"( ByVal AxisID As Short ) As Double
Declare Sub ABAS_CMP Cdecl Alias "ABAS_CMP"(ByVal AxisID As Short, ByVal Cpos As Double)
Declare Sub ABAS_CMP_AUTO Cdecl Alias "ABAS_CMP_AUTO"(ByVal AxisID As Short, ByVal Start As Double, ByVal EndData As Double, ByVal Interval As Double)
Declare Sub ABAS_CMP_TABLE Cdecl Alias "ABAS_CMP_TABLE"(ByVal AxisID As Short, ByVal TableArray As Double Ptr, ByVal Arraycnt As Long)
Declare Sub ABAS_RESETCMP Cdecl Alias "ABAS_RESETCMP"(ByVal AxisID As Short = -1)						'yf,2016.06.29
Declare Function ABAS_GETCMPFLAG Cdecl Alias "ABAS_GETCMPFLAG"(ByVal AxisID As Short) AS UShort

'Path
Declare Sub PATHBEGIN Cdecl Alias "ABAS_PATHBEGIN"(ByVal StartNum As UShort = 0)		'yf,2016.06.20 default as 0
Declare Sub PATHEND Cdecl Alias "ABAS_PATHEND"()
Declare Sub ABAS_SetMergeMod Cdecl Alias "ABAS_SetMergeMod"(ByVal Mode As UShort)
Declare Sub ABAS_PATHDelay Cdecl Alias "ABAS_PATHDelay"(ByVal Mode As long)
Declare Sub PATHRESET Cdecl Alias "ABAS_PATHRESET"()

'Group
Declare Sub ABAS_LINE Cdecl Alias "ABAS_LINE"(ByVal Distance As Double = DBL_MAX,ByVal Distance1 As Double = DBL_MAX,ByVal Distance2 As Double = DBL_MAX,ByVal Distance3 As Double = DBL_MAX,ByVal Distance4 As Double = DBL_MAX,ByVal Distance5 As Double =DBL_MAX,ByVal Distance6 As Double = DBL_MAX,ByVal Distance7 As Double =DBL_MAX,...)			'yf,2017.01.16 fix default value 0 to dbl_max, and add para num to 8
Declare Sub ABAS_LINEABS Cdecl Alias "ABAS_LINEABS"(ByVal Distance As Double = DBL_MAX, ByVal Distance1 As Double = DBL_MAX,ByVal Distance2 As Double = DBL_MAX,ByVal Distance3 As Double = DBL_MAX,ByVal Distance4 As Double = DBL_MAX,ByVal Distance5 As Double =DBL_MAX,ByVal Distance6 As Double = DBL_MAX,ByVal Distance7 As Double =DBL_MAX,...)
Declare Sub ABAS_PTP Cdecl Alias "ABAS_PTP"(ByVal Distance As Double = DBL_MAX, ByVal Distance1 As Double = DBL_MAX,ByVal Distance2 As Double = DBL_MAX,ByVal Distance3 As Double = DBL_MAX,ByVal Distance4 As Double = DBL_MAX,ByVal Distance5 As Double =DBL_MAX,ByVal Distance6 As Double = DBL_MAX,ByVal Distance7 As Double = DBL_MAX,...)
Declare Sub ABAS_PTPABS Cdecl Alias "ABAS_PTPABS"(ByVal Distance As Double = DBL_MAX,ByVal Distance1 As Double = DBL_MAX,ByVal Distance2 As Double = DBL_MAX,ByVal Distance3 As Double = DBL_MAX,ByVal Distance4 As Double = DBL_MAX,ByVal Distance5 As Double =DBL_MAX,ByVal Distance6 As Double = DBL_MAX,ByVal Distance7 As Double = DBL_MAX,...)
Declare Sub CIRC Cdecl Alias "ABAS_CIRC"(ByVal Dircetion As Short= 0, ByVal Distance As Double = DBL_MAX, ByVal Distance1 As Double = DBL_MAX, ByVal Distance2 As Double = DBL_MAX, ByVal Distance3 As Double = DBL_MAX, ByVal Distance4 As Double = DBL_MAX, ByVal Distance5 As Double =DBL_MAX,ByVal Distance6 As Double = DBL_MAX,ByVal Distance7 As Double = DBL_MAX,...)
Declare Sub CIRCABS Cdecl Alias "ABAS_CIRCABS"(ByVal Dircetion As Short= 0, ByVal Distance As Double = DBL_MAX,ByVal Distance1 As Double = DBL_MAX,ByVal Distance2 As Double = DBL_MAX,ByVal Distance3 As Double = DBL_MAX,ByVal Distance4 As Double = DBL_MAX,ByVal Distance5 As Double =DBL_MAX,ByVal Distance6 As Double = DBL_MAX,ByVal Distance7 As Double = DBL_MAX,...)
Declare Sub CIRC_3P Cdecl Alias "ABAS_CIRC_3P"(ByVal Dircetion As Short= 0, ByVal Distance As Double = DBL_MAX, ByVal Distance1 As Double = DBL_MAX, ByVal Distance2 As Double = DBL_MAX, ByVal Distance3 As Double = DBL_MAX, ByVal Distance4 As Double = DBL_MAX, ByVal Distance5 As Double =DBL_MAX,ByVal Distance6 As Double = DBL_MAX,ByVal Distance7 As Double = DBL_MAX,...)
Declare Sub CIRCABS_3P Cdecl Alias "ABAS_CIRCABS_3P"(ByVal Dircetion As Short= 0, ByVal Distance As Double = DBL_MAX,ByVal Distance1 As Double = DBL_MAX,ByVal Distance2 As Double = DBL_MAX,ByVal Distance3 As Double = DBL_MAX,ByVal Distance4 As Double = DBL_MAX,ByVal Distance5 As Double =DBL_MAX,ByVal Distance6 As Double = DBL_MAX,ByVal Distance7 As Double = DBL_MAX,...)
Declare Sub CIRC_A Cdecl Alias "ABAS_CIRC_A"(ByVal Dircetion As Short= 0, ByVal Distance As Double = DBL_MAX, ByVal Distance1 As Double = DBL_MAX, ByVal Distance2 As Double = DBL_MAX, ByVal Distance3 As Double = DBL_MAX, ByVal Distance4 As Double = DBL_MAX, ByVal Distance5 As Double =DBL_MAX, ByVal Distance6 As Double = DBL_MAX, ByVal Distance7 As Double = DBL_MAX,...)
Declare Sub CIRCABS_A Cdecl Alias "ABAS_CIRCABS_A"(ByVal Dircetion As Short= 0, ByVal Distance As Double = DBL_MAX,ByVal Distance1 As Double = DBL_MAX,ByVal Distance2 As Double = DBL_MAX,ByVal Distance3 As Double = DBL_MAX,ByVal Distance4 As Double = DBL_MAX,ByVal Distance5 As Double =DBL_MAX,ByVal Distance6 As Double = DBL_MAX,ByVal Distance7 As Double = DBL_MAX,...)
Declare Sub HELIX Cdecl Alias "ABAS_HELIX"(ByVal Dircetion As Short= 0, ByVal Distance As Double = DBL_MAX,ByVal Distance1 As Double = DBL_MAX, ByVal Distance2 As Double = DBL_MAX, ByVal Distance3 As Double = DBL_MAX, ByVal Distance4 As Double = DBL_MAX, ByVal Distance5 As Double =DBL_MAX,ByVal Distance6 As Double = DBL_MAX,ByVal Distance7 As Double = DBL_MAX,...)
Declare Sub HELIXABS Cdecl Alias "ABAS_HELIXABS"(ByVal Dircetion As Short= 0, ByVal Distance As Double = DBL_MAX, ByVal Distance1 As Double = DBL_MAX, ByVal Distance2 As Double = DBL_MAX, ByVal Distance3 As Double = DBL_MAX,ByVal Distance4 As Double = DBL_MAX,ByVal Distance5 As Double =DBL_MAX,ByVal Distance6 As Double = DBL_MAX,ByVal Distance7 As Double = DBL_MAX,...)
Declare Sub HELIX_3P Cdecl Alias "ABAS_HELIX_3P"(ByVal Dircetion As Short= 0, ByVal Distance As Double = DBL_MAX, ByVal Distance1 As Double = DBL_MAX, ByVal Distance2 As Double = DBL_MAX, ByVal Distance3 As Double = DBL_MAX, ByVal Distance4 As Double = DBL_MAX, ByVal Distance5 As Double =DBL_MAX,ByVal Distance6 As Double = DBL_MAX,ByVal Distance7 As Double = DBL_MAX,...)
Declare Sub HELIXABS_3P Cdecl Alias "ABAS_HELIXABS_3P"(ByVal Dircetion As Short= 0, ByVal Distance As Double = DBL_MAX,ByVal Distance1 As Double = DBL_MAX,ByVal Distance2 As Double = DBL_MAX,ByVal Distance3 As Double = DBL_MAX,ByVal Distance4 As Double = DBL_MAX,ByVal Distance5 As Double =DBL_MAX,ByVal Distance6 As Double = DBL_MAX,ByVal Distance7 As Double = DBL_MAX,...)
Declare Sub HELIX_A Cdecl Alias "ABAS_HELIX_A"(ByVal Dircetion As Short= 0, ByVal Distance As Double = DBL_MAX, ByVal Distance1 As Double = DBL_MAX, ByVal Distance2 As Double = DBL_MAX, ByVal Distance3 As Double = DBL_MAX, ByVal Distance4 As Double = DBL_MAX, ByVal Distance5 As Double =DBL_MAX,ByVal Distance6 As Double = DBL_MAX,ByVal Distance7 As Double = DBL_MAX,...)
Declare Sub HELIXABS_A Cdecl Alias "ABAS_HELIXABS_A"(ByVal Dircetion As Short= 0, ByVal Distance As Double = DBL_MAX,ByVal Distance1 As Double = DBL_MAX,ByVal Distance2 As Double = DBL_MAX,ByVal Distance3 As Double = DBL_MAX,ByVal Distance4 As Double = DBL_MAX,ByVal Distance5 As Double =DBL_MAX,ByVal Distance6 As Double = DBL_MAX,ByVal Distance7 As Double = DBL_MAX,...)
'yf,2016.06.16 add group para
Declare Sub SetGroupSpeed Cdecl Alias "ABAS_SetGroupSpeed"(ByVal AxisID As Short, ByVal Fl As Double = -1.0)
Declare Sub SetGroupStartSpeed Cdecl Alias "ABAS_SetGroupStartSpeed"(ByVal AxisID As Short, ByVal Fl As Double = -1.0)   
Declare Sub SetGroupAcc Cdecl Alias "ABAS_SetGroupAcc"(ByVal AxisID As Short, ByVal Fl As Double = -1.0) 
Declare Sub SetGroupDec Cdecl Alias "ABAS_SetGroupDec"(ByVal AxisID As Short, ByVal Fl As Double = -1.0)
Declare Sub SetGroupJerk Cdecl Alias "ABAS_SetGroupJerk"(ByVal AxisID As Short, ByVal Fl As Double = -1.0)   
Declare Sub GPAUSE Cdecl Alias "ABAS_GPPAUSEMOTION"() 
Declare Sub GRESUME Cdecl Alias "ABAS_GPRESUMEMOTION"()  

'Set Property
Declare Sub ABAS_SetACC Cdecl Alias "ABAS_SetAcc"(ByVal AxisID As Short, ByVal AccValue As Double = -1.0,ByVal AccValue1 As Double = -1.0, ByVal AccValue2 As Double = -1.0, ByVal AccValue3 As Double = -1.0, ByVal AccValue4 As Double = -1.0, ByVal AccValue5 As Double = -1.0,...)
Declare Sub ABAS_SetDEC Cdecl Alias "ABAS_SetDec"(ByVal AxisID As Short, ByVal DecValue As Double = -1.0,ByVal DecValue1 As Double = -1.0,ByVal DecValue2 As Double = -1.0,ByVal DecValue3 As Double = -1.0,ByVal DecValue4 As Double = -1.0,ByVal DecValue5 As Double = -1.0,...)
Declare Sub ABAS_SetVL Cdecl Alias "ABAS_SetStartSpeed"(ByVal AxisID As Short, ByVal Fl As Double = -1.0,ByVal Fl1 As Double = -1.0,ByVal Fl2 As Double = -1.0,ByVal Fl3 As Double = -1.0,ByVal Fl4 As Double = -1.0,ByVal Fl5 As Double = -1.0,...)
Declare Sub ABAS_SetVH Cdecl Alias "ABAS_SetSpeed"(ByVal AxisID As Short, ByVal VelHigh As Double = -1.0,ByVal VelHigh1 As Double = -1.0,ByVal VelHigh2 As Double = -1.0,ByVal VelHigh3 As Double = -1.0,ByVal VelHigh4 As Double = -1.0,ByVal VelHigh5 As Double = -1.0,...)
Declare Sub ABAS_SetJK Cdecl Alias "ABAS_SetJerk"(ByVal AxisID As Short,ByVal TorS As double = -1, ByVal TorS1 As double = -1, ByVal TorS2 As double = -1, ByVal TorS3 As double = -1, ByVal TorS4 As double= -1, ByVal TorS5 As double = -1,...)
Declare Sub ABAS_SetHomeMode Cdecl Alias "ABAS_SetHomeMode"(ByVal AxisID As Short,ByVal HomeMode As Integer = -1, ByVal HomeMode1 As Integer = -1, ByVal HomeMode2 As Integer = -1, ByVal HomeMode3 As Integer = -1, ByVal HomeMode4 As Integer = -1, ByVal HomeMode5 As Integer = -1,...)
Declare Sub ABAS_SetDPOS Cdecl Alias "ABAS_SetCmdPosition"(ByVal AxisID As Short, ByVal Cpos As Double = -1.0, ByVal Cpos1 As Double = -1.0,ByVal Cpos2 As Double = -1.0,ByVal Cpos3 As Double = -1.0,ByVal Cpos4 As Double = -1.0,ByVal Cpos5 As Double = -1.0,...)
Declare Sub ABAS_SetMPOS Cdecl Alias "ABAS_SetActualPosition"(ByVal AxisID As Short, ByVal Apos As Double = -1.0, ByVal Apos1 As Double = -1.0,ByVal Apos2 As Double = -1.0,ByVal Apos3 As Double = -1.0,ByVal Apos4 As Double = -1.0,ByVal Apos5 As Double = -1.0,...)
'yf,2016.06.07 add PAR OF HOME
Declare Sub ABAS_SetHomeVL Cdecl Alias "ABAS_SetHomeStartSpeed"(ByVal AxisID As Short, ByVal Fl As Double = -1.0,ByVal Fl1 As Double = -1.0,ByVal Fl2 As Double = -1.0,ByVal Fl3 As Double = -1.0,ByVal Fl4 As Double = -1.0,ByVal Fl5 As Double = -1.0,...)  
Declare Sub ABAS_SetHomeVH Cdecl Alias "ABAS_SetHomeSpeed"(ByVal AxisID As Short, ByVal Fl As Double = -1.0,ByVal Fl1 As Double = -1.0,ByVal Fl2 As Double = -1.0,ByVal Fl3 As Double = -1.0,ByVal Fl4 As Double = -1.0,ByVal Fl5 As Double = -1.0,...)  
Declare Sub ABAS_SetHomeAcc Cdecl Alias "ABAS_SetHomeAcc"(ByVal AxisID As Short, ByVal Fl As Double = -1.0,ByVal Fl1 As Double = -1.0,ByVal Fl2 As Double = -1.0,ByVal Fl3 As Double = -1.0,ByVal Fl4 As Double = -1.0,ByVal Fl5 As Double = -1.0,...)                                                                                                   
Declare Sub ABAS_SetHomeDec Cdecl Alias "ABAS_SetHomeDec"(ByVal AxisID As Short, ByVal Fl As Double = -1.0,ByVal Fl1 As Double = -1.0,ByVal Fl2 As Double = -1.0,ByVal Fl3 As Double = -1.0,ByVal Fl4 As Double = -1.0,ByVal Fl5 As Double = -1.0,...) 
Declare Sub ABAS_SetHomeJK Cdecl Alias "ABAS_SetHomeJerk"(ByVal AxisID As Short, ByVal Fl As Double = -1.0,ByVal Fl1 As Double = -1.0,ByVal Fl2 As Double = -1.0,ByVal Fl3 As Double = -1.0,ByVal Fl4 As Double = -1.0,ByVal Fl5 As Double = -1.0,...) 
Declare Sub ABAS_SetHomeCross Cdecl Alias "ABAS_SetHomeCrossDistance"(ByVal AxisID As Short, ByVal Fl As Double = -1.0,ByVal Fl1 As Double = -1.0,ByVal Fl2 As Double = -1.0,ByVal Fl3 As Double = -1.0,ByVal Fl4 As Double = -1.0,ByVal Fl5 As Double = -1.0,...)                                                                                                                                                                                                                                                                                                     
 
'Set CFG
Declare Sub ABAS_SetPPU Cdecl Alias "ABAS_SetPPU"(ByVal AxisID As Short, ByVal PPU As long = -1, ByVal PPU1 As long = -1,ByVal PPU2 As long = -1,ByVal PPU3 As long = -1,ByVal PPU4 As long = -1,ByVal PPU5 As long = -1,...)
Declare Sub ABAS_SetMaxVel Cdecl Alias "ABAS_SetMaxVel"(ByVal AxisID As Short, ByVal CFG As Double = -1.0,ByVal CFG1 As Double = -1.0, ByVal CFG2 As Double = -1.0, ByVal CFG3 As Double = -1.0, ByVal CFG4 As Double = -1.0, ByVal CFG5 As Double = -1.0,...)
Declare Sub ABAS_SetMaxAcc Cdecl Alias "ABAS_SetMaxAcc"(ByVal AxisID As Short, ByVal CFG As Double = -1.0,ByVal CFG1 As Double = -1.0, ByVal CFG2 As Double = -1.0, ByVal CFG3 As Double = -1.0, ByVal CFG4 As Double = -1.0, ByVal CFG5 As Double = -1.0,...)
Declare Sub ABAS_SetMaxDec Cdecl Alias "ABAS_SetMaxDec"(ByVal AxisID As Short, ByVal CFG As Double = -1.0,ByVal CFG1 As Double = -1.0, ByVal CFG2 As Double = -1.0, ByVal CFG3 As Double = -1.0, ByVal CFG4 As Double = -1.0, ByVal CFG5 As Double = -1.0,...)
Declare Sub ABAS_SetPulseInMode Cdecl Alias "ABAS_SetPulseInMode"(ByVal AxisID As Short, ByVal CFG As long = -1.0,ByVal CFG1 As long = -1.0, ByVal CFG2 As long = -1.0, ByVal CFG3 As long = -1.0, ByVal CFG4 As long = -1.0, ByVal CFG5 As long = -1.0,...)
Declare Sub ABAS_SetPulseInLogic Cdecl Alias "ABAS_SetPulseInLogic"(ByVal AxisID As Short, ByVal CFG As long = -1.0,ByVal CFG1 As long = -1.0, ByVal CFG2 As long = -1.0, ByVal CFG3 As long = -1.0, ByVal CFG4 As long = -1.0, ByVal CFG5 As long = -1.0,...)
Declare Sub ABAS_SetPulseOutMode Cdecl Alias "ABAS_SetPulseOutMode"(ByVal AxisID As Short, ByVal CFG As long = -1.0,ByVal CFG1 As long = -1.0, ByVal CFG2 As long = -1.0, ByVal CFG3 As long = -1.0, ByVal CFG4 As long = -1.0, ByVal CFG5 As long = -1.0,...)
Declare Sub ABAS_SetAlmEnable Cdecl Alias "ABAS_SetAlmEnable"(ByVal AxisID As Short, ByVal CFG As long = -1.0,ByVal CFG1 As long = -1.0, ByVal CFG2 As long = -1.0, ByVal CFG3 As long = -1.0, ByVal CFG4 As long = -1.0, ByVal CFG5 As long = -1.0,...)
Declare Sub ABAS_SetAlmLogic Cdecl Alias "ABAS_SetAlmLogic"(ByVal AxisID As Short, ByVal CFG As long = -1.0,ByVal CFG1 As long = -1.0, ByVal CFG2 As long = -1.0, ByVal CFG3 As long = -1.0, ByVal CFG4 As long = -1.0, ByVal CFG5 As long = -1.0,...)
Declare Sub ABAS_SetAlmReact Cdecl Alias "ABAS_SetAlmReact"(ByVal AxisID As Short, ByVal CFG As long = -1.0,ByVal CFG1 As long = -1.0, ByVal CFG2 As long = -1.0, ByVal CFG3 As long = -1.0, ByVal CFG4 As long = -1.0, ByVal CFG5 As long = -1.0,...)
Declare Sub ABAS_SetInpEnable Cdecl Alias "ABAS_SetInpEnable"(ByVal AxisID As Short, ByVal CFG As long = -1.0,ByVal CFG1 As long = -1.0, ByVal CFG2 As long = -1.0, ByVal CFG3 As long = -1.0, ByVal CFG4 As long = -1.0, ByVal CFG5 As long = -1.0,...)
Declare Sub ABAS_SetInpLogic Cdecl Alias "ABAS_SetInpLogic"(ByVal AxisID As Short, ByVal CFG As long = -1.0,ByVal CFG1 As long = -1.0, ByVal CFG2 As long = -1.0, ByVal CFG3 As long = -1.0, ByVal CFG4 As long = -1.0, ByVal CFG5 As long = -1.0,...)
Declare Sub ABAS_SetErcLogic Cdecl Alias "ABAS_SetErcLogic"(ByVal AxisID As Short, ByVal CFG As long = -1.0,ByVal CFG1 As long = -1.0, ByVal CFG2 As long = -1.0, ByVal CFG3 As long = -1.0, ByVal CFG4 As long = -1.0, ByVal CFG5 As long = -1.0,...)
Declare Sub ABAS_SetErcEnableMode Cdecl Alias "ABAS_SetErcEnableMode"(ByVal AxisID As Short, ByVal CFG As long = -1.0,ByVal CFG1 As long = -1.0, ByVal CFG2 As long = -1.0, ByVal CFG3 As long = -1.0, ByVal CFG4 As long = -1.0, ByVal CFG5 As long = -1.0,...)
Declare Sub ABAS_SetElEnable Cdecl Alias "ABAS_SetElEnable"(ByVal AxisID As Short, ByVal CFG As long = -1.0,ByVal CFG1 As long = -1.0, ByVal CFG2 As long = -1.0, ByVal CFG3 As long = -1.0, ByVal CFG4 As long = -1.0, ByVal CFG5 As long = -1.0,...)
Declare Sub ABAS_SetElLogic Cdecl Alias "ABAS_SetElLogic"(ByVal AxisID As Short, ByVal CFG As long = -1.0,ByVal CFG1 As long = -1.0, ByVal CFG2 As long = -1.0, ByVal CFG3 As long = -1.0, ByVal CFG4 As long = -1.0, ByVal CFG5 As long = -1.0,...)
Declare Sub ABAS_SetElReact Cdecl Alias "ABAS_SetElReact"(ByVal AxisID As Short, ByVal CFG As long = -1.0,ByVal CFG1 As long = -1.0, ByVal CFG2 As long = -1.0, ByVal CFG3 As long = -1.0, ByVal CFG4 As long = -1.0, ByVal CFG5 As long = -1.0,...)
Declare Sub ABAS_SetSwMelEnable Cdecl Alias "ABAS_SetSwMelEnable"(ByVal AxisID As Short, ByVal CFG As long = -1.0,ByVal CFG1 As long = -1.0, ByVal CFG2 As long = -1.0, ByVal CFG3 As long = -1.0, ByVal CFG4 As long = -1.0, ByVal CFG5 As long = -1.0,...)
Declare Sub ABAS_SetSwMelReact Cdecl Alias "ABAS_SetSwMelReact"(ByVal AxisID As Short, ByVal CFG As long = -1.0,ByVal CFG1 As long = -1.0, ByVal CFG2 As long = -1.0, ByVal CFG3 As long = -1.0, ByVal CFG4 As long = -1.0, ByVal CFG5 As long = -1.0,...)
Declare Sub ABAS_SetSwMelValue Cdecl Alias "ABAS_SetSwMelValue"(ByVal AxisID As Short, ByVal CFG As long = LONG_MAX,ByVal CFG1 As long = LONG_MAX,ByVal CFG2 As long = LONG_MAX,ByVal CFG3 As long = LONG_MAX,ByVal CFG4 As long = LONG_MAX,ByVal CFG5 As long =LONG_MAX,...)
Declare Sub ABAS_SetSwPelEnable Cdecl Alias "ABAS_SetSwPelEnable"(ByVal AxisID As Short, ByVal CFG As long = -1.0,ByVal CFG1 As long = -1.0, ByVal CFG2 As long = -1.0, ByVal CFG3 As long = -1.0, ByVal CFG4 As long = -1.0, ByVal CFG5 As long = -1.0,...)
Declare Sub ABAS_SetSwPelReact Cdecl Alias "ABAS_SetSwPelReact"(ByVal AxisID As Short, ByVal CFG As long = -1.0,ByVal CFG1 As long = -1.0, ByVal CFG2 As long = -1.0, ByVal CFG3 As long = -1.0, ByVal CFG4 As long = -1.0, ByVal CFG5 As long = -1.0,...)
Declare Sub ABAS_SetSwPelValue Cdecl Alias "ABAS_SetSwPelValue"(ByVal AxisID As Short, ByVal CFG As long = LONG_MAX,ByVal CFG1 As long = LONG_MAX,ByVal CFG2 As long = LONG_MAX,ByVal CFG3 As long = LONG_MAX,ByVal CFG4 As long = LONG_MAX,ByVal CFG5 As long =LONG_MAX,...)
Declare Sub ABAS_SetOrgLogic Cdecl Alias "ABAS_SetOrgLogic"(ByVal AxisID As Short, ByVal CFG As long = -1.0,ByVal CFG1 As long = -1.0, ByVal CFG2 As long = -1.0, ByVal CFG3 As long = -1.0, ByVal CFG4 As long = -1.0, ByVal CFG5 As long = -1.0,...)
Declare Sub ABAS_SetEzLogic Cdecl Alias "ABAS_SetEzLogic"(ByVal AxisID As Short, ByVal CFG As long = -1.0,ByVal CFG1 As long = -1.0, ByVal CFG2 As long = -1.0, ByVal CFG3 As long = -1.0, ByVal CFG4 As long = -1.0, ByVal CFG5 As long = -1.0,...)
Declare Sub ABAS_SetBacklashEnable Cdecl Alias "ABAS_SetBacklashEnable"(ByVal AxisID As Short, ByVal CFG As long = -1.0,ByVal CFG1 As long = -1.0, ByVal CFG2 As long = -1.0, ByVal CFG3 As long = -1.0, ByVal CFG4 As long = -1.0, ByVal CFG5 As long = -1.0,...)
Declare Sub ABAS_SetBacklashPulses Cdecl Alias "ABAS_SetBacklashPulses"(ByVal AxisID As Short, ByVal CFG As long = -1.0,ByVal CFG1 As long = -1.0, ByVal CFG2 As long = -1.0, ByVal CFG3 As long = -1.0, ByVal CFG4 As long = -1.0, ByVal CFG5 As long = -1.0,...)
Declare Sub ABAS_SetLatchLogic Cdecl Alias "ABAS_SetLatchLogic"(ByVal AxisID As Short, ByVal CFG As long = -1.0,ByVal CFG1 As long = -1.0, ByVal CFG2 As long = -1.0, ByVal CFG3 As long = -1.0, ByVal CFG4 As long = -1.0, ByVal CFG5 As long = -1.0,...)
Declare Sub ABAS_SetLatchEnable Cdecl Alias "ABAS_SetLatchEnable"(ByVal AxisID As Short, ByVal CFG As long = -1.0,ByVal CFG1 As long = -1.0, ByVal CFG2 As long = -1.0, ByVal CFG3 As long = -1.0, ByVal CFG4 As long = -1.0, ByVal CFG5 As long = -1.0,...)
Declare Sub ABAS_SetHomeResetEnable Cdecl Alias "ABAS_SetHomeResetEnable"(ByVal AxisID As Short, ByVal CFG As long = -1.0,ByVal CFG1 As long = -1.0, ByVal CFG2 As long = -1.0, ByVal CFG3 As long = -1.0, ByVal CFG4 As long = -1.0, ByVal CFG5 As long = -1.0,...)
Declare Sub ABAS_SetCmpSrc Cdecl Alias "ABAS_SetCmpSrc"(ByVal AxisID As Short, ByVal CFG As long = -1.0,ByVal CFG1 As long = -1.0, ByVal CFG2 As long = -1.0, ByVal CFG3 As long = -1.0, ByVal CFG4 As long = -1.0, ByVal CFG5 As long = -1.0,...)
Declare Sub ABAS_SetCmpMethod Cdecl Alias "ABAS_SetCmpMethod"(ByVal AxisID As Short, ByVal CFG As long = -1.0,ByVal CFG1 As long = -1.0, ByVal CFG2 As long = -1.0, ByVal CFG3 As long = -1.0, ByVal CFG4 As long = -1.0, ByVal CFG5 As long = -1.0,...)
Declare Sub ABAS_SetCmpPulseMode Cdecl Alias "ABAS_SetCmpPulseMode"(ByVal AxisID As Short, ByVal CFG As long = -1.0,ByVal CFG1 As long = -1.0, ByVal CFG2 As long = -1.0, ByVal CFG3 As long = -1.0, ByVal CFG4 As long = -1.0, ByVal CFG5 As long = -1.0,...)
Declare Sub ABAS_SetCmpPulseLogic Cdecl Alias "ABAS_SetCmpPulseLogic"(ByVal AxisID As Short, ByVal CFG As long = -1.0,ByVal CFG1 As long = -1.0, ByVal CFG2 As long = -1.0, ByVal CFG3 As long = -1.0, ByVal CFG4 As long = -1.0, ByVal CFG5 As long = -1.0,...)
Declare Sub ABAS_SetCmpPulseWidth Cdecl Alias "ABAS_SetCmpPulseWidth"(ByVal AxisID As Short, ByVal CFG As long = -1.0,ByVal CFG1 As long = -1.0, ByVal CFG2 As long = -1.0, ByVal CFG3 As long = -1.0, ByVal CFG4 As long = -1.0, ByVal CFG5 As long = -1.0,...)
Declare Sub ABAS_SetCmpEnable Cdecl Alias "ABAS_SetCmpEnable"(ByVal AxisID As Short, ByVal CFG As long = -1.0,ByVal CFG1 As long = -1.0, ByVal CFG2 As long = -1.0, ByVal CFG3 As long = -1.0, ByVal CFG4 As long = -1.0, ByVal CFG5 As long = -1.0,...)
Declare Sub ABAS_SetGenDoEnable Cdecl Alias "ABAS_SetGenDoEnable"(ByVal AxisID As Short, ByVal CFG As long = -1.0,ByVal CFG1 As long = -1.0, ByVal CFG2 As long = -1.0, ByVal CFG3 As long = -1.0, ByVal CFG4 As long = -1.0, ByVal CFG5 As long = -1.0,...)
Declare Sub ABAS_SetExtMasterSrc Cdecl Alias "ABAS_SetExtMasterSrc"(ByVal AxisID As Short, ByVal CFG As long = -1.0,ByVal CFG1 As long = -1.0, ByVal CFG2 As long = -1.0, ByVal CFG3 As long = -1.0, ByVal CFG4 As long = -1.0, ByVal CFG5 As long = -1.0,...)
Declare Sub ABAS_SetExtSelEnable Cdecl Alias "ABAS_SetExtSelEnable"(ByVal AxisID As Short, ByVal CFG As long = -1.0,ByVal CFG1 As long = -1.0, ByVal CFG2 As long = -1.0, ByVal CFG3 As long = -1.0, ByVal CFG4 As long = -1.0, ByVal CFG5 As long = -1.0,...)
Declare Sub ABAS_SetExtPulseNum Cdecl Alias "ABAS_SetExtPulseNum"(ByVal AxisID As Short, ByVal CFG As long = -1.0,ByVal CFG1 As long = -1.0, ByVal CFG2 As long = -1.0, ByVal CFG3 As long = -1.0, ByVal CFG4 As long = -1.0, ByVal CFG5 As long = -1.0,...)
Declare Sub ABAS_SetExtPulseInMode Cdecl Alias "ABAS_SetExtPulseInMode"(ByVal AxisID As Short, ByVal CFG As long = -1.0,ByVal CFG1 As long = -1.0, ByVal CFG2 As long = -1.0, ByVal CFG3 As long = -1.0, ByVal CFG4 As long = -1.0, ByVal CFG5 As long = -1.0,...)
Declare Sub ABAS_SetExtPresetNum Cdecl Alias "ABAS_SetExtPresetNum"(ByVal AxisID As Short, ByVal CFG As long = -1.0,ByVal CFG1 As long = -1.0, ByVal CFG2 As long = -1.0, ByVal CFG3 As long = -1.0, ByVal CFG4 As long = -1.0, ByVal CFG5 As long = -1.0,...)
Declare Sub ABAS_SetCamDOEnable Cdecl Alias "ABAS_SetCamDOEnable"(ByVal AxisID As Short, ByVal CFG As long = -1.0,ByVal CFG1 As long = -1.0, ByVal CFG2 As long = -1.0, ByVal CFG3 As long = -1.0, ByVal CFG4 As long = -1.0, ByVal CFG5 As long = -1.0,...)
Declare Sub ABAS_SetCamDOLoLimit Cdecl Alias "ABAS_SetCamDOLoLimit"(ByVal AxisID As Short, ByVal CFG As long = LONG_MAX,ByVal CFG1 As long = LONG_MAX,ByVal CFG2 As long = LONG_MAX,ByVal CFG3 As long = LONG_MAX,ByVal CFG4 As long = LONG_MAX,ByVal CFG5 As long =LONG_MAX,...)
Declare Sub ABAS_SetCamDOHiLimit Cdecl Alias "ABAS_SetCamDOHiLimit"(ByVal AxisID As Short, ByVal CFG As long = LONG_MAX,ByVal CFG1 As long = LONG_MAX,ByVal CFG2 As long = LONG_MAX,ByVal CFG3 As long = LONG_MAX,ByVal CFG4 As long = LONG_MAX,ByVal CFG5 As long =LONG_MAX,...)
Declare Sub ABAS_SetCamDOCmpSrc Cdecl Alias "ABAS_SetCamDOCmpSrc"(ByVal AxisID As Short, ByVal CFG As long = -1.0,ByVal CFG1 As long = -1.0, ByVal CFG2 As long = -1.0, ByVal CFG3 As long = -1.0, ByVal CFG4 As long = -1.0, ByVal CFG5 As long = -1.0,...)
Declare Sub ABAS_SetCamDOLogic Cdecl Alias "ABAS_SetCamDOLogic"(ByVal AxisID As Short, ByVal CFG As long = -1.0,ByVal CFG1 As long = -1.0, ByVal CFG2 As long = -1.0, ByVal CFG3 As long = -1.0, ByVal CFG4 As long = -1.0, ByVal CFG5 As long = -1.0,...)
Declare Sub ABAS_SetModuleRange Cdecl Alias "ABAS_SetModuleRange"(ByVal AxisID As Short, ByVal CFG As long = -1.0,ByVal CFG1 As long = -1.0, ByVal CFG2 As long = -1.0, ByVal CFG3 As long = -1.0, ByVal CFG4 As long = -1.0, ByVal CFG5 As long = -1.0,...)
Declare Sub ABAS_SetBacklashVel Cdecl Alias "ABAS_SetBacklashVel"(ByVal AxisID As Short, ByVal CFG As long = -1.0,ByVal CFG1 As long = -1.0, ByVal CFG2 As long = -1.0, ByVal CFG3 As long = -1.0, ByVal CFG4 As long = -1.0, ByVal CFG5 As long = -1.0,...)
Declare Sub ABAS_SetPulseInMaxFreq Cdecl Alias "ABAS_SetPulseInMaxFreq"(ByVal AxisID As Short, ByVal CFG As long = -1.0,ByVal CFG1 As long = -1.0, ByVal CFG2 As long = -1.0, ByVal CFG3 As long = -1.0, ByVal CFG4 As long = -1.0, ByVal CFG5 As long = -1.0,...)
Declare Sub ABAS_SetSimStartSource Cdecl Alias "ABAS_SetSimStartSource"(ByVal AxisID As Short, ByVal CFG As long = -1.0,ByVal CFG1 As long = -1.0, ByVal CFG2 As long = -1.0, ByVal CFG3 As long = -1.0, ByVal CFG4 As long = -1.0, ByVal CFG5 As long = -1.0,...)
Declare Sub ABAS_SetOrgReact Cdecl Alias "ABAS_SetOrgReact"(ByVal AxisID As Short, ByVal CFG As long = -1.0,ByVal CFG1 As long = -1.0, ByVal CFG2 As long = -1.0, ByVal CFG3 As long = -1.0, ByVal CFG4 As long = -1.0, ByVal CFG5 As long = -1.0,...)
Declare Sub ABAS_SetIN1StopReact Cdecl Alias "ABAS_SetIN1StopReact"(ByVal AxisID As Short, ByVal CFG As long = -1.0,ByVal CFG1 As long = -1.0, ByVal CFG2 As long = -1.0, ByVal CFG3 As long = -1.0, ByVal CFG4 As long = -1.0, ByVal CFG5 As long = -1.0,...)
Declare Sub ABAS_SetIN1StopLogic Cdecl Alias "ABAS_SetIN1StopLogic"(ByVal AxisID As Short, ByVal CFG As long = -1.0,ByVal CFG1 As long = -1.0, ByVal CFG2 As long = -1.0, ByVal CFG3 As long = -1.0, ByVal CFG4 As long = -1.0, ByVal CFG5 As long = -1.0,...)
Declare Sub ABAS_SetIN1StopEnable Cdecl Alias "ABAS_SetIN1StopEnable"(ByVal AxisID As Short, ByVal CFG As long = -1.0,ByVal CFG1 As long = -1.0, ByVal CFG2 As long = -1.0, ByVal CFG3 As long = -1.0, ByVal CFG4 As long = -1.0, ByVal CFG5 As long = -1.0,...)
Declare Sub ABAS_SetIN1StopEdge Cdecl Alias "ABAS_SetIN1StopEdge"(ByVal AxisID As Short, ByVal CFG As long = -1.0,ByVal CFG1 As long = -1.0, ByVal CFG2 As long = -1.0, ByVal CFG3 As long = -1.0, ByVal CFG4 As long = -1.0, ByVal CFG5 As long = -1.0,...)
Declare Sub ABAS_SetIN1Offset Cdecl Alias "ABAS_SetIN1Offset"(ByVal AxisID As Short, ByVal CFG As Double = -1.0,ByVal CFG1 As Double = -1.0, ByVal CFG2 As Double = -1.0, ByVal CFG3 As Double = -1.0, ByVal CFG4 As Double = -1.0, ByVal CFG5 As Double = -1.0,...)
Declare Sub ABAS_SetIN2StopReact Cdecl Alias "ABAS_SetIN2StopReact"(ByVal AxisID As Short, ByVal CFG As long = -1.0,ByVal CFG1 As long = -1.0, ByVal CFG2 As long = -1.0, ByVal CFG3 As long = -1.0, ByVal CFG4 As long = -1.0, ByVal CFG5 As long = -1.0,...)
Declare Sub ABAS_SetIN2StopLogic Cdecl Alias "ABAS_SetIN2StopLogic"(ByVal AxisID As Short, ByVal CFG As long = -1.0,ByVal CFG1 As long = -1.0, ByVal CFG2 As long = -1.0, ByVal CFG3 As long = -1.0, ByVal CFG4 As long = -1.0, ByVal CFG5 As long = -1.0,...)
Declare Sub ABAS_SetIN2StopEnable Cdecl Alias "ABAS_SetIN2StopEnable"(ByVal AxisID As Short, ByVal CFG As long = -1.0,ByVal CFG1 As long = -1.0, ByVal CFG2 As long = -1.0, ByVal CFG3 As long = -1.0, ByVal CFG4 As long = -1.0, ByVal CFG5 As long = -1.0,...)
Declare Sub ABAS_SetIN2StopEdge Cdecl Alias "ABAS_SetIN2StopEdge"(ByVal AxisID As Short, ByVal CFG As long = -1.0,ByVal CFG1 As long = -1.0, ByVal CFG2 As long = -1.0, ByVal CFG3 As long = -1.0, ByVal CFG4 As long = -1.0, ByVal CFG5 As long = -1.0,...)
Declare Sub ABAS_SetIN2Offset Cdecl Alias "ABAS_SetIN2Offset"(ByVal AxisID As Short, ByVal CFG As Double = -1.0,ByVal CFG1 As Double = -1.0, ByVal CFG2 As Double = -1.0, ByVal CFG3 As Double = -1.0, ByVal CFG4 As Double = -1.0, ByVal CFG5 As Double = -1.0,...)
Declare Sub ABAS_SetIN4StopReact Cdecl Alias "ABAS_SetIN4StopReact"(ByVal AxisID As Short, ByVal CFG As long = -1.0,ByVal CFG1 As long = -1.0, ByVal CFG2 As long = -1.0, ByVal CFG3 As long = -1.0, ByVal CFG4 As long = -1.0, ByVal CFG5 As long = -1.0,...)
Declare Sub ABAS_SetIN4StopLogic Cdecl Alias "ABAS_SetIN4StopLogic"(ByVal AxisID As Short, ByVal CFG As long = -1.0,ByVal CFG1 As long = -1.0, ByVal CFG2 As long = -1.0, ByVal CFG3 As long = -1.0, ByVal CFG4 As long = -1.0, ByVal CFG5 As long = -1.0,...)
Declare Sub ABAS_SetIN4StopEnable Cdecl Alias "ABAS_SetIN4StopEnable"(ByVal AxisID As Short, ByVal CFG As long = -1.0,ByVal CFG1 As long = -1.0, ByVal CFG2 As long = -1.0, ByVal CFG3 As long = -1.0, ByVal CFG4 As long = -1.0, ByVal CFG5 As long = -1.0,...)
Declare Sub ABAS_SetIN4StopEdge Cdecl Alias "ABAS_SetIN4StopEdge"(ByVal AxisID As Short, ByVal CFG As long = -1.0,ByVal CFG1 As long = -1.0, ByVal CFG2 As long = -1.0, ByVal CFG3 As long = -1.0, ByVal CFG4 As long = -1.0, ByVal CFG5 As long = -1.0,...)
Declare Sub ABAS_SetIN4Offset Cdecl Alias "ABAS_SetIN4Offset"(ByVal AxisID As Short, ByVal CFG As Double = -1.0,ByVal CFG1 As Double = -1.0, ByVal CFG2 As Double = -1.0, ByVal CFG3 As Double = -1.0, ByVal CFG4 As Double = -1.0, ByVal CFG5 As Double = -1.0,...)
Declare Sub ABAS_SetIN5StopReact Cdecl Alias "ABAS_SetIN5StopReact"(ByVal AxisID As Short, ByVal CFG As long = -1.0,ByVal CFG1 As long = -1.0, ByVal CFG2 As long = -1.0, ByVal CFG3 As long = -1.0, ByVal CFG4 As long = -1.0, ByVal CFG5 As long = -1.0,...)
Declare Sub ABAS_SetIN5StopLogic Cdecl Alias "ABAS_SetIN5StopLogic"(ByVal AxisID As Short, ByVal CFG As long = -1.0,ByVal CFG1 As long = -1.0, ByVal CFG2 As long = -1.0, ByVal CFG3 As long = -1.0, ByVal CFG4 As long = -1.0, ByVal CFG5 As long = -1.0,...)
Declare Sub ABAS_SetIN5StopEnable Cdecl Alias "ABAS_SetIN5StopEnable"(ByVal AxisID As Short, ByVal CFG As long = -1.0,ByVal CFG1 As long = -1.0, ByVal CFG2 As long = -1.0, ByVal CFG3 As long = -1.0, ByVal CFG4 As long = -1.0, ByVal CFG5 As long = -1.0,...)
Declare Sub ABAS_SetIN5StopEdge Cdecl Alias "ABAS_SetIN5StopEdge"(ByVal AxisID As Short, ByVal CFG As long = -1.0,ByVal CFG1 As long = -1.0, ByVal CFG2 As long = -1.0, ByVal CFG3 As long = -1.0, ByVal CFG4 As long = -1.0, ByVal CFG5 As long = -1.0,...)
Declare Sub ABAS_SetIN5Offset Cdecl Alias "ABAS_SetIN5Offset"(ByVal AxisID As Short, ByVal CFG As Double = -1.0,ByVal CFG1 As Double = -1.0, ByVal CFG2 As Double = -1.0, ByVal CFG3 As Double = -1.0, ByVal CFG4 As Double = -1.0, ByVal CFG5 As Double = -1.0,...)
Declare Sub ABAS_SetLatchBufEnable Cdecl Alias "ABAS_SetLatchBufEnable"(ByVal AxisID As Short, ByVal CFG As long = -1.0,ByVal CFG1 As long = -1.0, ByVal CFG2 As long = -1.0, ByVal CFG3 As long = -1.0, ByVal CFG4 As long = -1.0, ByVal CFG5 As long = -1.0,...)
Declare Sub ABAS_SetLatchBufMinDist Cdecl Alias "ABAS_SetLatchBufMinDist"(ByVal AxisID As Short, ByVal CFG As long = -1.0,ByVal CFG1 As long = -1.0, ByVal CFG2 As long = -1.0, ByVal CFG3 As long = -1.0, ByVal CFG4 As long = -1.0, ByVal CFG5 As long = -1.0,...)
Declare Sub ABAS_SetLatchBufEventNum Cdecl Alias "ABAS_SetLatchBufEventNum"(ByVal AxisID As Short, ByVal CFG As long = -1.0,ByVal CFG1 As long = -1.0, ByVal CFG2 As long = -1.0, ByVal CFG3 As long = -1.0, ByVal CFG4 As long = -1.0, ByVal CFG5 As long = -1.0,...)
Declare Sub ABAS_SetLatchBufSource Cdecl Alias "ABAS_SetLatchBufSource"(ByVal AxisID As Short, ByVal CFG As long = -1.0,ByVal CFG1 As long = -1.0, ByVal CFG2 As long = -1.0, ByVal CFG3 As long = -1.0, ByVal CFG4 As long = -1.0, ByVal CFG5 As long = -1.0,...)
Declare Sub ABAS_SetLatchBufAxisID Cdecl Alias "ABAS_SetLatchBufAxisID"(ByVal AxisID As Short, ByVal CFG As long = -1.0,ByVal CFG1 As long = -1.0, ByVal CFG2 As long = -1.0, ByVal CFG3 As long = -1.0, ByVal CFG4 As long = -1.0, ByVal CFG5 As long = -1.0,...)
Declare Sub ABAS_SetLatchBufEdge Cdecl Alias "ABAS_SetLatchBufEdge"(ByVal AxisID As Short, ByVal CFG As long = -1.0,ByVal CFG1 As long = -1.0, ByVal CFG2 As long = -1.0, ByVal CFG3 As long = -1.0, ByVal CFG4 As long = -1.0, ByVal CFG5 As long = -1.0,...)
Declare Sub ABAS_SetHomeOffsetDistance Cdecl Alias "ABAS_SetHomeOffsetDistance"(ByVal AxisID As Short, ByVal CFG As Double = -1.0,ByVal CFG1 As Double = -1.0, ByVal CFG2 As Double = -1.0, ByVal CFG3 As Double = -1.0, ByVal CFG4 As Double = -1.0, ByVal CFG5 As Double = -1.0,...)
Declare Sub ABAS_SetHomeOffsetVel Cdecl Alias "ABAS_SetHomeOffsetVel"(ByVal AxisID As Short, ByVal CFG As Double = -1.0,ByVal CFG1 As Double = -1.0, ByVal CFG2 As Double = -1.0, ByVal CFG3 As Double = -1.0, ByVal CFG4 As Double = -1.0, ByVal CFG5 As Double = -1.0,...)
Declare Sub ABAS_SetPPUDenominator Cdecl Alias "ABAS_SetPPUDenominator"(ByVal AxisID As Short, ByVal CFG As long = -1.0,ByVal CFG1 As long = -1.0, ByVal CFG2 As long = -1.0, ByVal CFG3 As long = -1.0, ByVal CFG4 As long = -1.0, ByVal CFG5 As long = -1.0,...)
Declare Sub ABAS_SetPelToleranceEnable Cdecl Alias "ABAS_SetPelToleranceEnable"(ByVal AxisID As Short, ByVal CFG As long = -1.0,ByVal CFG1 As long = -1.0, ByVal CFG2 As long = -1.0, ByVal CFG3 As long = -1.0, ByVal CFG4 As long = -1.0, ByVal CFG5 As long = -1.0,...)
Declare Sub ABAS_SetPelToleranceValue Cdecl Alias "ABAS_SetPelToleranceValue"(ByVal AxisID As Short, ByVal CFG As long = -1.0,ByVal CFG1 As long = -1.0, ByVal CFG2 As long = -1.0, ByVal CFG3 As long = -1.0, ByVal CFG4 As long = -1.0, ByVal CFG5 As long = -1.0,...)
Declare Sub ABAS_SetSwPelToleranceEnable Cdecl Alias "ABAS_SetSwPelToleranceEnable"(ByVal AxisID As Short, ByVal CFG As long = -1.0,ByVal CFG1 As long = -1.0, ByVal CFG2 As long = -1.0, ByVal CFG3 As long = -1.0, ByVal CFG4 As long = -1.0, ByVal CFG5 As long = -1.0,...)
Declare Sub ABAS_SetSwPelToleranceValue Cdecl Alias "ABAS_SetSwPelToleranceValue"(ByVal AxisID As Short, ByVal CFG As long = -1.0,ByVal CFG1 As long = -1.0, ByVal CFG2 As long = -1.0, ByVal CFG3 As long = -1.0, ByVal CFG4 As long = -1.0, ByVal CFG5 As long = -1.0,...)
Declare Sub ABAS_SetMelToleranceEnable Cdecl Alias "ABAS_SetMelToleranceEnable"(ByVal AxisID As Short, ByVal CFG As long = -1.0,ByVal CFG1 As long = -1.0, ByVal CFG2 As long = -1.0, ByVal CFG3 As long = -1.0, ByVal CFG4 As long = -1.0, ByVal CFG5 As long = -1.0,...)
Declare Sub ABAS_SetMelToleranceValue Cdecl Alias "ABAS_SetMelToleranceValue"(ByVal AxisID As Short, ByVal CFG As long = -1.0,ByVal CFG1 As long = -1.0, ByVal CFG2 As long = -1.0, ByVal CFG3 As long = -1.0, ByVal CFG4 As long = -1.0, ByVal CFG5 As long = -1.0,...)
Declare Sub ABAS_SetSwMelToleranceEnable Cdecl Alias "ABAS_SetSwMelToleranceEnable"(ByVal AxisID As Short, ByVal CFG As long = -1.0,ByVal CFG1 As long = -1.0, ByVal CFG2 As long = -1.0, ByVal CFG3 As long = -1.0, ByVal CFG4 As long = -1.0, ByVal CFG5 As long = -1.0,...)
Declare Sub ABAS_SetSwMelToleranceValue Cdecl Alias "ABAS_SetSwMelToleranceValue"(ByVal AxisID As Short, ByVal CFG As long = -1.0,ByVal CFG1 As long = -1.0, ByVal CFG2 As long = -1.0, ByVal CFG3 As long = -1.0, ByVal CFG4 As long = -1.0, ByVal CFG5 As long = -1.0,...)
Declare Sub ABAS_SetCmpPulseWidthEx Cdecl Alias "ABAS_SetCmpPulseWidthEx"(ByVal AxisID As Short, ByVal CFG As long = -1.0,ByVal CFG1 As long = -1.0, ByVal CFG2 As long = -1.0, ByVal CFG3 As long = -1.0, ByVal CFG4 As long = -1.0, ByVal CFG5 As long = -1.0,...)
Declare Sub ABAS_SetALMFilterTime Cdecl Alias "ABAS_SetALMFilterTime"(ByVal AxisID As Short, ByVal CFG As long = -1.0,ByVal CFG1 As long = -1.0, ByVal CFG2 As long = -1.0, ByVal CFG3 As long = -1.0, ByVal CFG4 As long = -1.0, ByVal CFG5 As long = -1.0,...)
Declare Sub ABAS_SetLMTPFilterTime Cdecl Alias "ABAS_SetLMTPFilterTime"(ByVal AxisID As Short, ByVal CFG As long = -1.0,ByVal CFG1 As long = -1.0, ByVal CFG2 As long = -1.0, ByVal CFG3 As long = -1.0, ByVal CFG4 As long = -1.0, ByVal CFG5 As long = -1.0,...)
Declare Sub ABAS_SetLMTNFilterTime Cdecl Alias "ABAS_SetLMTNFilterTime"(ByVal AxisID As Short, ByVal CFG As long = -1.0,ByVal CFG1 As long = -1.0, ByVal CFG2 As long = -1.0, ByVal CFG3 As long = -1.0, ByVal CFG4 As long = -1.0, ByVal CFG5 As long = -1.0,...)
Declare Sub ABAS_SetORGFilterTime Cdecl Alias "ABAS_SetORGFilterTime"(ByVal AxisID As Short, ByVal CFG As long = -1.0,ByVal CFG1 As long = -1.0, ByVal CFG2 As long = -1.0, ByVal CFG3 As long = -1.0, ByVal CFG4 As long = -1.0, ByVal CFG5 As long = -1.0,...)
Declare Sub ABAS_SetIN1FilterTime Cdecl Alias "ABAS_SetIN1FilterTime"(ByVal AxisID As Short, ByVal CFG As long = -1.0,ByVal CFG1 As long = -1.0, ByVal CFG2 As long = -1.0, ByVal CFG3 As long = -1.0, ByVal CFG4 As long = -1.0, ByVal CFG5 As long = -1.0,...)
Declare Sub ABAS_SetIN2FilterTime Cdecl Alias "ABAS_SetIN2FilterTime"(ByVal AxisID As Short, ByVal CFG As long = -1.0,ByVal CFG1 As long = -1.0, ByVal CFG2 As long = -1.0, ByVal CFG3 As long = -1.0, ByVal CFG4 As long = -1.0, ByVal CFG5 As long = -1.0,...)
Declare Sub ABAS_SetIN4FilterTime Cdecl Alias "ABAS_SetIN4FilterTime"(ByVal AxisID As Short, ByVal CFG As long = -1.0,ByVal CFG1 As long = -1.0, ByVal CFG2 As long = -1.0, ByVal CFG3 As long = -1.0, ByVal CFG4 As long = -1.0, ByVal CFG5 As long = -1.0,...)
Declare Sub ABAS_SetIN5FilterTime Cdecl Alias "ABAS_SetIN5FilterTime"(ByVal AxisID As Short, ByVal CFG As long = -1.0,ByVal CFG1 As long = -1.0, ByVal CFG2 As long = -1.0, ByVal CFG3 As long = -1.0, ByVal CFG4 As long = -1.0, ByVal CFG5 As long = -1.0,...)
Declare Sub ABAS_SetPulseOutReverse Cdecl Alias "ABAS_SetPulseOutReverse"(ByVal AxisID As Short, ByVal CFG As long = -1.0,ByVal CFG1 As long = -1.0, ByVal CFG2 As long = -1.0, ByVal CFG3 As long = -1.0, ByVal CFG4 As long = -1.0, ByVal CFG5 As long = -1.0,...)
Declare Sub ABAS_SetKillDec Cdecl Alias "ABAS_SetKillDec"(ByVal AxisID As Short, ByVal CFG As Double = -1.0,ByVal CFG1 As Double = -1.0, ByVal CFG2 As Double = -1.0, ByVal CFG3 As Double = -1.0, ByVal CFG4 As Double = -1.0, ByVal CFG5 As Double = -1.0,...)
Declare Sub ABAS_SetMaxErrorCnt Cdecl Alias "ABAS_SetMaxErrorCnt"(ByVal AxisID As Short, ByVal CFG As long = -1.0,ByVal CFG1 As long = -1.0, ByVal CFG2 As long = -1.0, ByVal CFG3 As long = -1.0, ByVal CFG4 As long = -1.0, ByVal CFG5 As long = -1.0,...)
Declare Sub ABAS_SetJogVLTime Cdecl Alias "ABAS_SetJogVLTime"(ByVal AxisID As Short, ByVal CFG As long = -1.0,ByVal CFG1 As long = -1.0, ByVal CFG2 As long = -1.0, ByVal CFG3 As long = -1.0, ByVal CFG4 As long = -1.0, ByVal CFG5 As long = -1.0,...)
Declare Sub ABAS_SetJogVelLow Cdecl Alias "ABAS_SetJogVelLow"(ByVal AxisID As Short, ByVal CFG As Double = -1.0,ByVal CFG1 As Double = -1.0, ByVal CFG2 As Double = -1.0, ByVal CFG3 As Double = -1.0, ByVal CFG4 As Double = -1.0, ByVal CFG5 As Double = -1.0,...)
Declare Sub ABAS_SetJogVelHigh Cdecl Alias "ABAS_SetJogVelHigh"(ByVal AxisID As Short, ByVal CFG As Double = -1.0,ByVal CFG1 As Double = -1.0, ByVal CFG2 As Double = -1.0, ByVal CFG3 As Double = -1.0, ByVal CFG4 As Double = -1.0, ByVal CFG5 As Double = -1.0,...)
Declare Sub ABAS_SetJogAcc Cdecl Alias "ABAS_SetJogAcc"(ByVal AxisID As Short, ByVal CFG As Double = -1.0,ByVal CFG1 As Double = -1.0, ByVal CFG2 As Double = -1.0, ByVal CFG3 As Double = -1.0, ByVal CFG4 As Double = -1.0, ByVal CFG5 As Double = -1.0,...)
Declare Sub ABAS_SetJogDec Cdecl Alias "ABAS_SetJogDec"(ByVal AxisID As Short, ByVal CFG As Double = -1.0,ByVal CFG1 As Double = -1.0, ByVal CFG2 As Double = -1.0, ByVal CFG3 As Double = -1.0, ByVal CFG4 As Double = -1.0, ByVal CFG5 As Double = -1.0,...)
Declare Sub ABAS_SetJogJerk Cdecl Alias "ABAS_SetJogJerk"(ByVal AxisID As Short, ByVal CFG As Double = -1.0,ByVal CFG1 As Double = -1.0, ByVal CFG2 As Double = -1.0, ByVal CFG3 As Double = -1.0, ByVal CFG4 As Double = -1.0, ByVal CFG5 As Double = -1.0,...)

'Get Property
Declare Function ABAS_GetACC Cdecl Alias "ABAS_GetAcc"(ByVal AxisIndex As Short = -1) As Double
Declare Function ABAS_GetDEC Cdecl Alias "ABAS_GetDec"(ByVal AxisIndex As Short = -1) As Double
Declare Function ABAS_GetVL Cdecl Alias "ABAS_GetStartSpeed"(ByVal AxisIndex As Short = -1) As Double
Declare Function ABAS_GetVH Cdecl Alias "ABAS_GetSpeed"(ByVal AxisIndex As Short = -1) As Double
Declare Function ABAS_GetJK Cdecl Alias "ABAS_GetJerk"(ByVal AxisIndex As Short = -1) As Double
Declare Function ABAS_GetHomeMode Cdecl Alias "ABAS_GetHomeMode"(ByVal AxisIndex As Short = -1) As UShort
Declare Function ABAS_GetDPOS Cdecl Alias "ABAS_GetCmdPosition"(ByVal AxisIndex As Short = -1) As Double
Declare Function ABAS_GetMPOS Cdecl Alias "ABAS_GetActualPosition"(ByVal AxisIndex As Short = -1) As Double
'yf,2016.06.07 add PAR of Home
Declare Function ABAS_GetHomeVL Cdecl Alias "ABAS_GetHomeStartSpeed"(ByVal AxisIndex As Short = -1) As Double
Declare Function ABAS_GetHomeVH Cdecl Alias "ABAS_GetHomeSpeed"(ByVal AxisIndex As Short = -1) As Double
Declare Function ABAS_GetHomeACC Cdecl Alias "ABAS_GetHomeAcc"(ByVal AxisIndex As Short = -1) As Double
Declare Function ABAS_GetHomeDEC Cdecl Alias "ABAS_GetHomeDec"(ByVal AxisIndex As Short = -1) As Double
Declare Function ABAS_GetHomeJK Cdecl Alias "ABAS_GetHomeJerk"(ByVal AxisIndex As Short = -1) As Double
Declare Function ABAS_GetHomeCross Cdecl Alias "ABAS_GetHomeCrossDistance"(ByVal AxisIndex As Short = -1) As Double

Declare Function GetGroupSpeed Cdecl Alias "ABAS_GetGroupSpeed"(ByVal AxisID As Short = -1) As Double
Declare Function GetGroupStartSpeed Cdecl Alias "ABAS_GetGroupStartSpeed"(ByVal AxisID As Short = -1)  As Double 
Declare Function GetGroupAcc Cdecl Alias "ABAS_GetGroupAcc"(ByVal AxisID As Short = -1) As Double
Declare Function GetGroupDec Cdecl Alias "ABAS_GetGroupDec"(ByVal AxisID As Short = -1) As Double
Declare Function GetGroupJerk Cdecl Alias "ABAS_GetGroupJerk"(ByVal AxisID As Short = -1) As Double
Declare Function GetGroupCurrentSpeed Cdecl Alias "ABAS_GetGroupCurrentSpeed"(ByVal AxisID As Short = -1) As Double 
Declare Function GetGroupState Cdecl Alias "ABAS_GetGroupState"(ByVal AxisID As Short = -1)	As UShort 

'Get CFG
Declare Function ABAS_GetPPU Cdecl Alias "ABAS_GetPPU"(ByVal AxisID As Short = -1) As Ulong
Declare Function ABAS_GetMaxVel Cdecl Alias "ABAS_GetMaxVel"(ByVal AxisID As Short = -1) As double
Declare Function ABAS_GetMaxAcc Cdecl Alias "ABAS_GetMaxAcc"(ByVal AxisID As Short = -1) As double
Declare Function ABAS_GetMaxDec Cdecl Alias "ABAS_GetMaxDec"(ByVal AxisID As Short = -1) As double
Declare Function ABAS_GetPulseInMode Cdecl Alias "ABAS_GetPulseInMode"(ByVal AxisID As Short = -1) As Ulong 
Declare Function ABAS_GetPulseInLogic Cdecl Alias "ABAS_GetPulseInLogic"(ByVal AxisID As Short = -1) As Ulong
Declare Function ABAS_GetPulseOutMode Cdecl Alias "ABAS_GetPulseOutMode"(ByVal AxisID As Short = -1) As Ulong 
Declare Function ABAS_GetAlmEnable Cdecl Alias "ABAS_GetAlmEnable"(ByVal AxisID As Short = -1) As Ulong 
Declare Function ABAS_GetAlmLogic Cdecl Alias "ABAS_GetAlmLogic"(ByVal AxisID As Short = -1) As Ulong
Declare Function ABAS_GetAlmReact Cdecl Alias "ABAS_GetAlmReact"(ByVal AxisID As Short = -1) As Ulong
Declare Function ABAS_GetInpEnable Cdecl Alias "ABAS_GetInpEnable"(ByVal AxisID As Short = -1) As Ulong 
Declare Function ABAS_GetInpLogic Cdecl Alias "ABAS_GetInpLogic"(ByVal AxisID As Short = -1) As Ulong
Declare Function ABAS_GetErcLogic Cdecl Alias "ABAS_GetErcLogic"(ByVal AxisID As Short = -1) As Ulong 
Declare Function ABAS_GetErcEnableMode Cdecl Alias "ABAS_GetErcEnableMode"(ByVal AxisID As Short = -1) As Ulong
Declare Function ABAS_GetElEnable Cdecl Alias "ABAS_GetElEnable"(ByVal AxisID As Short = -1) As Ulong
Declare Function ABAS_GetElLogic Cdecl Alias "ABAS_GetElLogic"(ByVal AxisID As Short = -1) As Ulong
Declare Function ABAS_GetElReact Cdecl Alias "ABAS_GetElReact"(ByVal AxisID As Short = -1) As Ulong
Declare Function ABAS_GetSwMelEnable Cdecl Alias "ABAS_GetSwMelEnable"(ByVal AxisID As Short = -1) As Ulong
Declare Function ABAS_GetSwMelReact Cdecl Alias "ABAS_GetSwMelReact"(ByVal AxisID As Short = -1) As Ulong
Declare Function ABAS_GetSwMelValue Cdecl Alias "ABAS_GetSwMelValue"(ByVal AxisID As Short = -1) As long
Declare Function ABAS_GetSwPelEnable Cdecl Alias "ABAS_GetSwPelEnable"(ByVal AxisID As Short = -1) As Ulong
Declare Function ABAS_GetSwPelReact Cdecl Alias "ABAS_GetSwPelReact"(ByVal AxisID As Short = -1) As Ulong
Declare Function ABAS_GetSwPelValue Cdecl Alias "ABAS_GetSwPelValue"(ByVal AxisID As Short = -1) As long
Declare Function ABAS_GetOrgLogic Cdecl Alias "ABAS_GetOrgLogic"(ByVal AxisID As Short = -1) As Ulong
Declare Function ABAS_GetEzLogic Cdecl Alias "ABAS_GetEzLogic"(ByVal AxisID As Short = -1) As Ulong
Declare Function ABAS_GetBacklashEnable Cdecl Alias "ABAS_GetBacklashEnable"(ByVal AxisID As Short = -1) As Ulong
Declare Function ABAS_GetBacklashPulses Cdecl Alias "ABAS_GetBacklashPulses"(ByVal AxisID As Short = -1) As Ulong
Declare Function ABAS_GetLatchLogic Cdecl Alias "ABAS_GetLatchLogic"(ByVal AxisID As Short = -1) As Ulong
Declare Function ABAS_GetLatchEnable Cdecl Alias "ABAS_GetLatchEnable"(ByVal AxisID As Short = -1) As Ulong
Declare Function ABAS_GetHomeResetEnable Cdecl Alias "ABAS_GetHomeResetEnable"(ByVal AxisID As Short = -1) As Ulong
Declare Function ABAS_GetCmpSrc Cdecl Alias "ABAS_GetCmpSrc"(ByVal AxisID As Short = -1) As Ulong
Declare Function ABAS_GetCmpMethod Cdecl Alias "ABAS_GetCmpMethod"(ByVal AxisID As Short = -1) As Ulong
Declare Function ABAS_GetCmpPulseMode Cdecl Alias "ABAS_GetCmpPulseMode"(ByVal AxisID As Short = -1) As Ulong
Declare Function ABAS_GetCmpPulseLogic Cdecl Alias "ABAS_GetCmpPulseLogic"(ByVal AxisID As Short = -1) As Ulong
Declare Function ABAS_GetCmpPulseWidth Cdecl Alias "ABAS_GetCmpPulseWidth"(ByVal AxisID As Short = -1) As Ulong
Declare Function ABAS_GetCmpEnable Cdecl Alias "ABAS_GetCmpEnable"(ByVal AxisID As Short = -1) As Ulong
Declare Function ABAS_GetGenDoEnable Cdecl Alias "ABAS_GetGenDoEnable"(ByVal AxisID As Short = -1) As Ulong
Declare Function ABAS_GetExtMasterSrc Cdecl Alias "ABAS_GetExtMasterSrc"(ByVal AxisID As Short = -1) As Ulong
Declare Function ABAS_GetExtSelEnable Cdecl Alias "ABAS_GetExtSelEnable"(ByVal AxisID As Short = -1) As Ulong
Declare Function ABAS_GetExtPulseNum Cdecl Alias "ABAS_GetExtPulseNum"(ByVal AxisID As Short = -1) As Ulong
Declare Function ABAS_GetExtPulseInMode Cdecl Alias "ABAS_GetExtPulseInMode"(ByVal AxisID As Short = -1) As Ulong
Declare Function ABAS_GetExtPresetNum Cdecl Alias "ABAS_GetExtPresetNum"(ByVal AxisID As Short = -1) As Ulong
Declare Function ABAS_GetCamDOEnable Cdecl Alias "ABAS_GetCamDOEnable"(ByVal AxisID As Short = -1) As Ulong
Declare Function ABAS_GetCamDOLoLimit Cdecl Alias "ABAS_GetCamDOLoLimit"(ByVal AxisID As Short = -1) As long
Declare Function ABAS_GetCamDOHiLimit Cdecl Alias "ABAS_GetCamDOHiLimit"(ByVal AxisID As Short = -1) As long
Declare Function ABAS_GetCamDOCmpSrc Cdecl Alias "ABAS_GetCamDOCmpSrc"(ByVal AxisID As Short = -1) As Ulong
Declare Function ABAS_GetCamDOLogic Cdecl Alias "ABAS_GetCamDOLogic"(ByVal AxisID As Short = -1) As Ulong
Declare Function ABAS_GetModuleRange Cdecl Alias "ABAS_GetModuleRange"(ByVal AxisID As Short = -1) As Ulong
Declare Function ABAS_GetBacklashVel Cdecl Alias "ABAS_GetBacklashVel"(ByVal AxisID As Short = -1) As Ulong
Declare Function ABAS_GetPulseInMaxFreq Cdecl Alias "ABAS_GetPulseInMaxFreq"(ByVal AxisID As Short = -1) As Ulong
Declare Function ABAS_GetSimStartSource Cdecl Alias "ABAS_GetSimStartSource"(ByVal AxisID As Short = -1) As Ulong
Declare Function ABAS_GetOrgReact Cdecl Alias "ABAS_GetOrgReact"(ByVal AxisID As Short = -1) As Ulong
Declare Function ABAS_GetIN1StopReact Cdecl Alias "ABAS_GetIN1StopReact"(ByVal AxisID As Short = -1) As Ulong
Declare Function ABAS_GetIN1StopLogic Cdecl Alias "ABAS_GetIN1StopLogic"(ByVal AxisID As Short = -1) As Ulong
Declare Function ABAS_GetIN1StopEnable Cdecl Alias "ABAS_GetIN1StopEnable"(ByVal AxisID As Short = -1) As Ulong
Declare Function ABAS_GetIN1StopEdge Cdecl Alias "ABAS_GetIN1StopEdge"(ByVal AxisID As Short = -1) As Ulong
Declare Function ABAS_GetIN1Offset Cdecl Alias "ABAS_GetIN1Offset"(ByVal AxisID As Short = -1) As double
Declare Function ABAS_GetIN2StopReact Cdecl Alias "ABAS_GetIN2StopReact"(ByVal AxisID As Short = -1) As Ulong
Declare Function ABAS_GetIN2StopLogic Cdecl Alias "ABAS_GetIN2StopLogic"(ByVal AxisID As Short = -1) As Ulong
Declare Function ABAS_GetIN2StopEnable Cdecl Alias "ABAS_GetIN2StopEnable"(ByVal AxisID As Short = -1) As Ulong
Declare Function ABAS_GetIN2StopEdge Cdecl Alias "ABAS_GetIN2StopEdge"(ByVal AxisID As Short = -1) As Ulong
Declare Function ABAS_GetIN2Offset Cdecl Alias "ABAS_GetIN2Offset"(ByVal AxisID As Short = -1) As double
Declare Function ABAS_GetIN4StopReact Cdecl Alias "ABAS_GetIN4StopReact"(ByVal AxisID As Short = -1) As Ulong
Declare Function ABAS_GetIN4StopLogic Cdecl Alias "ABAS_GetIN4StopLogic"(ByVal AxisID As Short = -1) As Ulong
Declare Function ABAS_GetIN4StopEnable Cdecl Alias "ABAS_GetIN4StopEnable"(ByVal AxisID As Short = -1) As Ulong
Declare Function ABAS_GetIN4StopEdge Cdecl Alias "ABAS_GetIN4StopEdge"(ByVal AxisID As Short = -1) As Ulong
Declare Function ABAS_GetIN4Offset Cdecl Alias "ABAS_GetIN4Offset"(ByVal AxisID As Short = -1) As double
Declare Function ABAS_GetIN5StopReact Cdecl Alias "ABAS_GetIN5StopReact"(ByVal AxisID As Short = -1) As Ulong
Declare Function ABAS_GetIN5StopLogic Cdecl Alias "ABAS_GetIN5StopLogic"(ByVal AxisID As Short = -1) As Ulong
Declare Function ABAS_GetIN5StopEnable Cdecl Alias "ABAS_GetIN5StopEnable"(ByVal AxisID As Short = -1) As Ulong
Declare Function ABAS_GetIN5StopEdge Cdecl Alias "ABAS_GetIN5StopEdge"(ByVal AxisID As Short = -1) As Ulong
Declare Function ABAS_GetIN5Offset Cdecl Alias "ABAS_GetIN5Offset"(ByVal AxisID As Short = -1) As double
Declare Function ABAS_GetLatchBufEnable Cdecl Alias "ABAS_GetLatchBufEnable"(ByVal AxisID As Short = -1) As Ulong
Declare Function ABAS_GetLatchBufMinDist Cdecl Alias "ABAS_GetLatchBufMinDist"(ByVal AxisID As Short = -1) As Ulong
Declare Function ABAS_GetLatchBufEventNum Cdecl Alias "ABAS_GetLatchBufEventNum"(ByVal AxisID As Short = -1) As Ulong
Declare Function ABAS_GetLatchBufSource Cdecl Alias "ABAS_GetLatchBufSource"(ByVal AxisID As Short = -1) As Ulong
Declare Function ABAS_GetLatchBufAxisID Cdecl Alias "ABAS_GetLatchBufAxisID"(ByVal AxisID As Short = -1) As Ulong
Declare Function ABAS_GetLatchBufEdge Cdecl Alias "ABAS_GetLatchBufEdge"(ByVal AxisID As Short = -1) As Ulong
Declare Function ABAS_GetHomeOffsetDistance Cdecl Alias "ABAS_GetHomeOffsetDistance"(ByVal AxisID As Short = -1) As double
Declare Function ABAS_GetHomeOffsetVel Cdecl Alias "ABAS_GetHomeOffsetVel"(ByVal AxisID As Short = -1) As double
Declare Function ABAS_GetPPUDenominator Cdecl Alias "ABAS_GetPPUDenominator"(ByVal AxisID As Short = -1) As Ulong
Declare Function ABAS_GetPelToleranceEnable Cdecl Alias "ABAS_GetPelToleranceEnable"(ByVal AxisID As Short = -1) As Ulong
Declare Function ABAS_GetPelToleranceValue Cdecl Alias "ABAS_GetPelToleranceValue"(ByVal AxisID As Short = -1) As Ulong
Declare Function ABAS_GetSwPelToleranceEnable Cdecl Alias "ABAS_GetSwPelToleranceEnable"(ByVal AxisID As Short = -1) As Ulong
Declare Function ABAS_GetSwPelToleranceValue Cdecl Alias "ABAS_GetSwPelToleranceValue"(ByVal AxisID As Short = -1) As Ulong
Declare Function ABAS_GetMelToleranceEnable Cdecl Alias "ABAS_GetMelToleranceEnable"(ByVal AxisID As Short = -1) As Ulong
Declare Function ABAS_GetMelToleranceValue Cdecl Alias "ABAS_GetMelToleranceValue"(ByVal AxisID As Short = -1) As Ulong
Declare Function ABAS_GetSwMelToleranceEnable Cdecl Alias "ABAS_GetSwMelToleranceEnable"(ByVal AxisID As Short = -1) As Ulong
Declare Function ABAS_GetSwMelToleranceValue Cdecl Alias "ABAS_GetSwMelToleranceValue"(ByVal AxisID As Short = -1) As Ulong
Declare Function ABAS_GetCmpPulseWidthEx Cdecl Alias "ABAS_GetCmpPulseWidthEx"(ByVal AxisID As Short = -1) As Ulong
Declare Function ABAS_GetALMFilterTime Cdecl Alias "ABAS_GetALMFilterTime"(ByVal AxisID As Short = -1) As Ulong
Declare Function ABAS_GetLMTPFilterTime Cdecl Alias "ABAS_GetLMTPFilterTime"(ByVal AxisID As Short = -1) As Ulong
Declare Function ABAS_GetLMTNFilterTime Cdecl Alias "ABAS_GetLMTNFilterTime"(ByVal AxisID As Short = -1) As Ulong
Declare Function ABAS_GetORGFilterTime Cdecl Alias "ABAS_GetORGFilterTime"(ByVal AxisID As Short = -1) As Ulong
Declare Function ABAS_GetIN1FilterTime Cdecl Alias "ABAS_GetIN1FilterTime"(ByVal AxisID As Short = -1) As Ulong
Declare Function ABAS_GetIN2FilterTime Cdecl Alias "ABAS_GetIN2FilterTime"(ByVal AxisID As Short = -1) As Ulong
Declare Function ABAS_GetIN4FilterTime Cdecl Alias "ABAS_GetIN4FilterTime"(ByVal AxisID As Short = -1) As Ulong
Declare Function ABAS_GetIN5FilterTime Cdecl Alias "ABAS_GetIN5FilterTime"(ByVal AxisID As Short = -1) As Ulong
Declare Function ABAS_GetPulseOutReverse Cdecl Alias "ABAS_GetPulseOutReverse"(ByVal AxisID As Short = -1) As Ulong
Declare Function ABAS_GetKillDec Cdecl Alias "ABAS_GetKillDec"(ByVal AxisID As Short = -1) As DOUBLE
Declare Function ABAS_GetMaxErrorCnt Cdecl Alias "ABAS_GetMaxErrorCnt"(ByVal AxisID As Short = -1) As Ulong
Declare Function ABAS_GetJogVLTime Cdecl Alias "ABAS_GetJogVLTime"(ByVal AxisID As Short = -1) As Ulong
Declare Function ABAS_GetJogVelLow Cdecl Alias "ABAS_GetJogVelLow"(ByVal AxisID As Short = -1) As DOUBLE
Declare Function ABAS_GetJogVelHigh Cdecl Alias "ABAS_GetJogVelHigh"(ByVal AxisID As Short = -1) As DOUBLE
Declare Function ABAS_GetJogAcc Cdecl Alias "ABAS_GetJogAcc"(ByVal AxisID As Short = -1) As DOUBLE
Declare Function ABAS_GetJogDec Cdecl Alias "ABAS_GetJogDec"(ByVal AxisID As Short = -1) As DOUBLE
Declare Function ABAS_GetJogJerk Cdecl Alias "ABAS_GetJogJerk"(ByVal AxisID As Short = -1) As DOUBLE

'State
Declare Function ABAS_GetMIO Cdecl Alias "ABAS_GetMotionIO"(ByVal AxisIndex As Short = -1) As Ulong
Declare Function ABAS_GetSTATUS Cdecl Alias "ABAS_GetMotionStatus"(ByVal AxisIndex As Short = -1) As Ulong
Declare Function ABAS_GetSTATE Cdecl Alias "ABAS_GetState"(ByVal AxisIndex As Short = -1) As UShort
Declare Function ABAS_GetSPEED Cdecl Alias "ABAS_GetCurrentSpeed"(ByVal AxisIndex As Short = -1) As Double

'Other
Declare Sub AXIS Cdecl Alias "ABAS_GetAXIS"(ByVal AxisNo As UShort)

'Error
Declare Function ABAS_GetErrorAxis Cdecl Alias "ABAS_GetErrorAxis"() As Ulong
Declare Function ABAS_GetMotionError Cdecl Alias "ABAS_GetMotionError"(ByVal AxisIndex As Short = -1) As Ulong
Declare Function ABAS_GetSystemError Cdecl Alias "ABAS_GetSystemError"() As Ulong
Declare Sub ABAS_ClearSystemError Cdecl Alias "ABAS_ClearSystemError"()

'PATHLINK
Declare Sub ABAS_PathLinkInitial Cdecl Alias "ABAS_PathLinkInitial"(ByVal MasAxisIndex as SHORT, ByRef SynInfoArray as double, ByVal MasOffsetPos As double, ByRef RefPoint As double, PAangle As double, MAangle As double)
Declare Sub ABAS_PathLinkBegin Cdecl Alias "ABAS_PathLinkBegin"(ByVal MasAxisIndex as SHORT, ByVal PathLinkOption As ULong)
Declare Sub ABAS_PathLinkEnd Cdecl Alias "ABAS_PathLinkEnd"()
Declare Sub ABAS_PathLinkStop Cdecl Alias "ABAS_PathLinkStop"(ByVal MasAxisIndex as SHORT)
Declare Sub ABAS_PATHLINK_RESETBUF Cdecl Alias "ABAS_PathLinkResetBuffer"(ByVal MasAxisIndex as SHORT=-1)
Declare Function ABAS_PATHLINK_BUFSTATUS Cdecl Alias "ABAS_PathLinkGetBufState"(ByVal MasAxisIndex as SHORT=-1) as ULONG
Declare Sub ABAS_PathLinkSetProcBuffer Cdecl Alias "ABAS_PathLinkSetProcBuffer"(ByVal MasAxisIndex as SHORT, ByRef RefPoint As double, MasLtcData as double)
Declare Function ABAS_PATHLINK_STATUS Cdecl Alias "ABAS_PathLinkStatus"(ByVal MasAxisIndex as SHORT=-1) as ULONG
Declare Function BAS_PathLinkGetReadyData Cdecl Alias "ABAS_PathLinkGetReadyData"(ByRef RdyPoint_X As double, ByRef RdyPoint_Y As double, ByVal Offset As double = 0) as ULONG

Declare Sub ABAS_CancelWait Cdecl Alias "ABAS_CancelWait"(ByVal MasAxisIndex as SHORT, ByVal WaitMode as SHORT)
'cyl
Declare Sub ABAS_CylMove Cdecl Alias "ABAS_CylMove"(ByVal cylId as short = -1, byVal dir as ushort,...)
Declare Sub Cyl_BASE Cdecl Alias "ABAS_CylBase"(cylId1 as short = ABAS_DFT_CYLID, cylId2 as short = ABAS_DFT_CYLID, cylId3 as short = ABAS_DFT_CYLID, cylId4 as short = ABAS_DFT_CYLID, cylId5 as short = ABAS_DFT_CYLID, cylId6 as short = ABAS_DFT_CYLID, cylId7 as short = ABAS_DFT_CYLID, cylId8 as short = ABAS_DFT_CYLID, cylId9 as short = ABAS_DFT_CYLID,...)
Declare Sub ABAS_CylStop Cdecl Alias "ABAS_CylStop"(ByVal cylId as short = -1, byVal mode as ushort,...)
Declare Sub ABAS_CylSetActionTime Cdecl Alias "ABAS_CylSetActionTime"(ByVal cylId as short = -1, byVal mode as ushort = 0, byVal dlyTime as Ulong,...)
Declare Sub ABAS_CylSetAlmTime Cdecl Alias "ABAS_CylSetAlmTime"(ByVal cylId as short = -1, byVal mode as ushort = 0, byVal dlyTime as Ulong,...)
Declare Sub ABAS_CylSetDoneType Cdecl Alias "ABAS_CylSetDoneType"(ByVal cylId as short = -1, byVal mode as ushort = 0, byVal dlyTime as Ulong,...)
Declare Sub ABAS_CylSetEncValue Cdecl Alias "ABAS_CylSetEncValue"(ByVal cylId as short = -1, byVal mode as ushort = 0, byVal dlyTime as double,...)
Declare Function ABAS_CylGetActionTime Cdecl Alias "ABAS_CylGetActionTime"(ByVal AxisIndex As Short = -1, byVal mode as ushort = 0) As Ulong
Declare Function ABAS_CylGetAlmTime Cdecl Alias "ABAS_CylGetAlmTime"(ByVal AxisIndex As Short = -1, byVal mode as ushort = 0) As Ulong
Declare Function ABAS_CylGetDoneType Cdecl Alias "ABAS_CylGetDoneType"(ByVal AxisIndex As Short = -1, byVal mode as ushort = 0) As Ulong
Declare Function ABAS_CylGetEncValue Cdecl Alias "ABAS_CylGetEncValue"(ByVal AxisIndex As Short = -1, byVal mode as ushort = 0) As Double
Declare Function ABAS_CylStatus Cdecl Alias "ABAS_CylStatus"(ByVal AxisIndex As Short = -1) As Ulong
'yf,2017.03.01 add task_status
Declare Function Task_Status Cdecl Alias "ABAS_GetTaskStatus"(taskName As ZString ptr) As Ulong

Declare Function BAS_XYZToYBC Cdecl Alias "ABAS_XYZToYBC"(x as const double ptr, y as const double ptr, z as const double ptr, r as const double ptr, zyxCnt as ulong , feed as double ptr, rotate as double ptr, bend as double ptr, rybc as double ptr, ybcCnt as ulong) As Ulong
Declare Function BAS_YBCToXYZ Cdecl Alias "ABAS_YBCToXYZ"(feed as const double ptr, rotate as const double ptr, bend as const double ptr, r as const double ptr, zyxCnt as ulong , x as double ptr, y as double ptr, z as double ptr, rXYZ as double ptr, ybcCnt as ulong) As Ulong
Declare Sub StrToVR Cdecl Alias "ABAS_StrToVR"(strInput as zstring ptr, vrStart as ulong)
Declare Function BAS_VRToStr Cdecl Alias "ABAS_VRToStr"(vrstart as ulong, vrcnt as ulong = 0 ) As zstring ptr
Declare Sub VRClear Cdecl Alias "ABAS_VRClear"(vrstart as ulong, vrcnt as ulong)
Declare Sub VRExchange Cdecl Alias "ABAS_VRExchange"(sstart as ulong, dstart as ulong, cnt as ulong)
Declare Sub VRCopy Cdecl Alias "ABAS_VRCopy"(sStart as ulong, dStart as ulong, cnt as ulong)

Declare Sub File_Delete Cdecl Alias "ABAS_FileDelete"(pathName as zstring ptr)
Declare Sub File_Rename Cdecl Alias "ABAS_FileReName"(sPathname as zstring ptr, newName as zstring ptr)
Declare Sub File_Copy Cdecl Alias "ABAS_FileCopy"(sPathname as zstring ptr, newName as zstring ptr)
Declare Function BAS_GetFiles Cdecl Alias "ABAS_GetFiles"(path as zstring ptr = 0, mextension as zstring ptr = 0, isFullName as ulong = 0) as Ulong
Declare Function BAS_GetFile Cdecl Alias "ABAS_GetFile"(fileIndex as ulong) as zstring ptr
Declare Sub BAS_FilesCopy Cdecl Alias "ABAS_FilesCopy"(sPath as zstring ptr, dpath as zstring ptr, fileName as zstring ptr = @"*")
Declare Function BAS_GetRefPlane Cdecl Alias "ABAS_GetRefPlane"() as long
Declare Sub BAS_PATHSTATUS Cdecl ALias "ABAS_PathStatus"(pCurIndex as ulong ptr, pcurCmd as ulong ptr, premainCnt as ulong ptr, pSpaceRemian as ulong ptr)

'ydd 17.5.2
'ydd 2017.4.26
Declare Sub ABAS_CAMTABLE Cdecl Alias "ABAS_DownLoadCamTable"(CamIndex As Short, MasAxisNo As Short, SlavAxisNo As Short, VR_Start As Long, DataCount As Ulong, CamID As Ushort = 0, IsSpdUsed As Ulong = 0)

Declare Sub CAMSET Cdecl Alias "ABAS_CamTableConfig"(CamIndex As Short, masRelorAbs As ushort = 0, slvRelorAbs As ushort = 0, perodic As ushort = 0)
Declare Sub CAMIN  Cdecl Alias "ABAS_CamInAxis"(CamIndex As Short, MasOffset As Double =0, SlvOffset As Double =0, MasRatioNum  As Ulong = 1, MasRatioDemo As Ulong = 1, SlvRatioNum As Ulong = 1, SlvRatioDemo As Ulong = 1, RefSrc As Ulong = 0)

Declare Sub ABAS_GpSetSpdFwd Cdecl Alias "ABAS_GpSetSpdFwd"(ptpValue As Ulong)
Declare Function ABAS_GpGetSpdFwd Cdecl Alias "ABAS_GpGetSpdFwd"() As Ulong

Declare Sub TASK_PAUSE Cdecl Alias "ABAS_PauseTask"(index As Ulong = 0)
Declare Sub TASK_RESUME Cdecl Alias "ABAS_ResumeTask"(index As Ulong = 0)

Declare Sub BAS_MCMP_AXEnabel Cdecl ALias "ABAS_MCMP_AXEnabel"(enable as ulong)
Declare Function BAS_Get_MCMP_AXEnabel Cdecl ALias "ABAS_Get_MCMP_AXEnabel"() as ulong
Declare Sub BAS_MCMP_ChannelEN Cdecl ALias "ABAS_MCMP_ChannelEN"(enable as ulong)
Declare Function BAS_Get_MCMP_ChannelEN Cdecl ALias "ABAS_Get_MCMP_ChannelEN"() as ulong
Declare Sub BAS_MCMP_Logic Cdecl ALias "ABAS_MCMP_Logic"(lowOrHigh as ulong)
Declare Function BAS_Get_MCMP_Logic Cdecl ALias "ABAS_Get_MCMP_Logic"() as ulong
Declare Sub BAS_MCMP_PWidth Cdecl ALias "ABAS_MCMP_PWidth"(width as ulong)
Declare Function BAS_Get_MCMP_PWidth Cdecl ALias "ABAS_Get_MCMP_PWidth"() as ulong
Declare Sub BAS_MCMP_Mode Cdecl ALias "ABAS_MCMP_Mode"(mode as ulong)
Declare Function BAS_Get_MCMP_Mode Cdecl ALias "ABAS_Get_MCMP_Mode"() as ulong
Declare Sub BAS_MCMP_AutoEmpty Cdecl ALias "ABAS_MCMP_AutoEmpty"(enable as ulong)
Declare Function BAS_Get_MCMP_AutoEmpty Cdecl ALias "ABAS_Get_MCMP_AutoEmpty"() as ulong
Declare Sub BAS_MCMP_PWMFREQ Cdecl ALias "ABAS_MCMP_PWMFREQ"(frequency as ulong)
Declare Function BAS_Get_MCMP_PWMFREQ Cdecl ALias "ABAS_Get_MCMP_PWMFREQ"() as ulong
Declare Sub BAS_MCMP_PWMDuty Cdecl ALias "ABAS_MCMP_PWMDuty"(duty as double)
Declare Function BAS_Get_MCMP_PWMDuty Cdecl ALias "ABAS_Get_MCMP_PWMDuty"() as double
Declare Sub BAS_MCP_DEVA Cdecl ALias "ABAS_MCP_DEVA"(axId as short , deviation as ulong,...)
Declare Function BAS_GetMCP_DEVA Cdecl ALias "ABAS_GetMCP_DEVA"(axId as short) as ulong
Declare Sub BAS_CMP_SetDo Cdecl ALias "ABAS_CMP_SetDo"(axId as short, onOrOff as ulong, ...)
Declare Sub BAS_MCMPPWMTIMETABLE Cdecl ALias "ABAS_MCMP_PWMTimeTable"(ptime as const ulong ptr, cnt as ulong)
Declare Sub MCMPFORCEOUT Cdecl ALias "ABAS_MCMP_ForceOut"(onOrOff as ulong = 1)
Declare Sub MCMPSETDO Cdecl ALias "ABAS_MCMP_SetDo"(onOrOff as ulong)
Declare Sub BAS_SetMCMPMaxPWMFreq Cdecl ALias "ABAS_SetMCMPMaxPWMFreq"(frequency as ulong)
Declare Function BAS_GetMCMPMaxPWMFreq Cdecl ALias "ABAS_GetMCMPMaxPWMFreq"() as ulong
Declare Sub BAS_SetMCMPMinPWMFreq Cdecl ALias "ABAS_SetMCMPMinPWMFreq"(frequency as ulong)
Declare Function BAS_GetMCMPMinPWMFreq Cdecl ALias "ABAS_GetMCMPMinPWMFreq"() as ulong
Declare Sub BAS_SetMCMPMaxPWMDuty Cdecl ALias "ABAS_SetMCMPMaxPWMDuty"(duty as double)
Declare Function BAS_GetMCMPMaxPWMDuty Cdecl ALias "ABAS_GetMCMPMaxPWMDuty"() as double
Declare Sub BAS_SetMCMPMinPWMDuty Cdecl ALias "ABAS_SetMCMPMinPWMDuty"(duty as double)
Declare Function BAS_GetMCMPMinPWMDuty Cdecl ALias "ABAS_GetMCMPMinPWMDuty"() as double
Declare Sub BAS_SetPWMLinkVelEn Cdecl ALias "ABAS_SetPWMLinkVelEn"(enable as ulong)
Declare Function BAS_GetPWMLinkVelEn Cdecl ALias "ABAS_GetPWMLinkVelEn"() as ulong
Declare Sub BAS_SetPWMMonitorMode Cdecl ALias "ABAS_SetPWMMonitorMode"(mode as ulong)
Declare Function BAS_GetPWMMonitorMode Cdecl ALias "ABAS_GetPWMMonitorMode"() as ulong
Declare Sub BAS_SetPWMRefVel Cdecl ALias "ABAS_SetPWMRefVel"(velocity as double)
Declare Function BAS_GetPWMRefVel Cdecl ALias "ABAS_GetPWMRefVel"() as double
'yf,2017.06.01
Declare Sub VRRESET Cdecl ALias "ABAS_VRReset"(vrStart as ulong, vrCnt as ulong)
Declare Sub DORESET Cdecl ALias "ABAS_DoReset"(doStart as ulong, doCnt as ulong)

Declare Sub BAS_SetEmgLogic Cdecl ALias "ABAS_SetEmgLogic"(emglogic as ulong)
Declare Function BAS_GetEmgLogic Cdecl ALias "ABAS_GetEmgLogic"() as ulong
Declare Sub BAS_SetEmgFilter Cdecl ALias "ABAS_SetEmgFilter"(emglogic as ulong)
Declare Function BAS_GetEmgFilter Cdecl ALias "ABAS_GetEmgFilter"() as ulong

'ydd 17.7.31

#define DATATYPE_U16			0
#define DATATYPE_I16				1
#define DATATYPE_U32			2
#define DATATYPE_I32				3
#define DATATYPE_F32			4
#define DATATYPE_F64			5
#define DATATYPE_OTHER			6

Declare Function BAS_ModBusOpen Cdecl ALias "ABAS_ModBusOpen"(ByVal MbIndex as Integer, ByVal ConnectMode As Integer, ByVal IPorComPort As ZString Ptr , ByVal DeviceID As ulong,  ByVal IpPortOrBaudRate As ulong, ByVal Parity As Ushort = 0, ByVal StopBit As Ushort = 0, ByVal DataBit As Ushort = 8) As ULONG
Declare Function BAS_ModbusClose Cdecl ALias "ABAS_ModbusClose"(ByVal MbIndex as Integer) as ulong
Declare Function BAS_ModbusTransfer Cdecl ALias "ABAS_ModbusTransfer"(ByVal MbIndex as Integer, ByVal FunCode As Byte, ByVal StartAddress As Ushort , DataArray As Any Ptr,  ByVal DataCnt As ulong, ByVal DataType As Ulong, ByVal Vr_Index As long) As ULONG
Declare Function MB_STATUS Cdecl ALias "ABAS_ModbusGetStatus"(ByVal MbIndex as Integer) As Boolean

Declare Function MB_OPEN (ByVal MbIndex as Integer, ByVal ConnectMode As Integer, ByVal IPorComPort As ZString Ptr , ByVal IpPortOrBaudRate As ulong, ByVal DeviceID As ulong,  ByVal Parity As Ushort = 0, ByVal StopBit As Ushort = 0, ByVal DataBit As Ushort = 8) As Boolean
Function MB_OPEN (ByVal MbIndex as Integer, ByVal ConnectMode As Integer, ByVal IPorComPort As ZString Ptr ,  ByVal IpPortOrBaudRate As ulong, ByVal DeviceID As ulong, ByVal Parity As Ushort = 0, ByVal StopBit As Ushort = 0, ByVal DataBit As Ushort = 8) As Boolean
	Dim result As Ulong
	result  = BAS_ModBusOpen(MbIndex, ConnectMode,IPorComPort , DeviceID,  IpPortOrBaudRate, Parity, StopBit, DataBit)
	if result>0 then	
	return FALSE
	else	
	return TRUE
	endif
End Function

Declare Function MB_CLOSE(ByVal MbIndex as Integer) As Boolean
Function MB_CLOSE (ByVal MbIndex as Integer)  As Boolean
	Dim result As Ulong
	result = BAS_ModbusClose(MbIndex)
	if result>0 then
	return FALSE
	else
	return TRUE
	endif
End Function

Declare Function MB_SETCOIL Overload(ByVal MbIndex as Integer, ByVal StartAddress As Ushort, ByVal Value As Byte) As Boolean
Function MB_SETCOIL Overload(ByVal MbIndex as Integer, ByVal StartAddress As Ushort, ByVal Value As Byte) As Boolean 
	Dim result As Ulong
	Dim p As byte ptr = @Value
	result = BAS_ModbusTransfer(MbIndex, 5, StartAddress, p, 1,  DATATYPE_OTHER,  -1)
	if result>0 then
	return FALSE
	else
	return TRUE
	endif
End Function

Declare Function MB_SETCOIL Overload(ByVal MbIndex as Integer, ByVal StartAddress As Ushort, ValueArray() As Byte, ByVal DataCnt As Ulong = 1) As Boolean
Function MB_SETCOIL Overload(ByVal MbIndex as Integer, ByVal StartAddress As Ushort, ValueArray() As Byte, ByVal DataCnt As Ulong = 1) As Boolean 
	Dim result As Ulong	
	Dim tempArray As Byte Ptr = @ValueArray(0)
	result = BAS_ModbusTransfer(MbIndex, 15, StartAddress, tempArray, DataCnt,  DATATYPE_OTHER,  -1)
	if result>0 then
	return FALSE
	else
	return TRUE
	endif
End Function

Declare Function MB_SETCOIL Overload(ByVal MbIndex as Integer, ByVal StartAddress As Ushort, ValueArray() As UByte, ByVal DataCnt As Ulong = 1) As Boolean
Function MB_SETCOIL Overload(ByVal MbIndex as Integer, ByVal StartAddress As Ushort, ValueArray() As UByte, ByVal DataCnt As Ulong = 1) As Boolean 
	Dim result As Ulong	
	Dim tempArray As Byte Ptr = @ValueArray(0)
	result = BAS_ModbusTransfer(MbIndex, 15, StartAddress, tempArray, DataCnt,  DATATYPE_OTHER,  -1)
	if result>0 then
	return FALSE
	else
	return TRUE
	endif
End Function

Declare Function MB_GETCOIL Overload(ByVal MbIndex as Integer, ByVal StartAddress As Ushort, ByRef Value As Byte) As Boolean
Function MB_GETCOIL (ByVal MbIndex as Integer, ByVal StartAddress As Ushort, ByRef Value As Byte)  As Boolean
	Dim result As Ulong
	Dim tempData As byte ptr = @Value
	result = BAS_ModbusTransfer(MbIndex, 1, StartAddress, tempData, 1,  DATATYPE_OTHER,  -1)
	if result>0 then
	return FALSE
	else
	return TRUE
	endif
End Function

Declare Function MB_GETCOIL Overload(ByVal MbIndex as Integer, ByVal StartAddress As Ushort, Value() As Byte, ByVal DataCnt As Ulong = 1) As Boolean
Function MB_GETCOIL (ByVal MbIndex as Integer, ByVal StartAddress As Ushort, Value() As Byte, ByVal DataCnt As Ulong =1)  As Boolean
	Dim result As Ulong
	Dim tempData As byte ptr = @Value(0)
	result = BAS_ModbusTransfer(MbIndex, 1, StartAddress, tempData, DataCnt,  DATATYPE_OTHER,  -1)
	if result>0 then
	return FALSE
	else
	return TRUE
	endif
End Function

Declare Function MB_GETCOIL Overload(ByVal MbIndex as Integer, ByVal StartAddress As Ushort, Value() As UByte, ByVal DataCnt As Ulong = 1) As Boolean
Function MB_GETCOIL (ByVal MbIndex as Integer, ByVal StartAddress As Ushort, Value() As UByte, ByVal DataCnt As Ulong =1)  As Boolean
	Dim result As Ulong
	Dim tempData As byte ptr = @Value(0)
	result = BAS_ModbusTransfer(MbIndex, 1, StartAddress, tempData, DataCnt,  DATATYPE_OTHER,  -1)
	if result>0 then
	return FALSE
	else
	return TRUE
	endif
End Function


Declare Function MB_GETINPUT Overload(ByVal MbIndex as Integer, ByVal StartAddress As Ushort, ByRef Value As Byte) As Boolean
Function MB_GETINPUT (ByVal MbIndex as Integer, ByVal StartAddress As Ushort, ByRef Value As Byte) As Boolean
	Dim result As Ulong
	Dim tempData As byte ptr = @Value
	result = BAS_ModbusTransfer(MbIndex, 2, StartAddress, tempData, 1,  DATATYPE_OTHER,  -1)
	if result>0 then
	return FALSE
	else
	return TRUE
	endif
End Function

Declare Function MB_GETINPUT Overload(ByVal MbIndex as Integer, ByVal StartAddress As Ushort, Value() As Byte, ByVal DataCnt As Ulong = 1) As Boolean
Function MB_GETINPUT (ByVal MbIndex as Integer, ByVal StartAddress As Ushort, Value() As Byte, ByVal DataCnt As Ulong = 1) As Boolean
	Dim result As Ulong
	Dim tempData As byte ptr = @Value(0)
	result = BAS_ModbusTransfer(MbIndex, 2, StartAddress, tempData, DataCnt,  DATATYPE_OTHER,  -1)
	if result>0 then
	return FALSE
	else
	return TRUE
	endif
End Function

Declare Function MB_GETINPUT Overload(ByVal MbIndex as Integer, ByVal StartAddress As Ushort, Value() As UByte, ByVal DataCnt As Ulong = 1) As Boolean
Function MB_GETINPUT (ByVal MbIndex as Integer, ByVal StartAddress As Ushort, Value() As UByte, ByVal DataCnt As Ulong = 1) As Boolean
	Dim result As Ulong
	Dim tempData As byte ptr = @Value(0)
	result = BAS_ModbusTransfer(MbIndex, 2, StartAddress, tempData, DataCnt,  DATATYPE_OTHER,  -1)
	if result>0 then
	return FALSE
	else
	return TRUE
	endif
End Function

Declare Function MB_SETHDREG Overload(ByVal MbIndex as Integer, ByVal StartAddress As Ushort, ByVal Value As Ushort) As Boolean
Function MB_SETHDREG Overload(ByVal MbIndex as Integer, ByVal StartAddress As Ushort, ByVal Value As Ushort) As Boolean 
	Dim result As Ushort
	Dim p As Ushort ptr = @Value
	result = BAS_ModbusTransfer(MbIndex, 6, StartAddress, p, 1,  DATATYPE_U16,  -1)
	if result>0 then
	return FALSE
	else
	return TRUE
	endif
End Function

Declare Function MB_SETHDREG Overload(ByVal MbIndex as Integer, ByVal StartAddress As Ushort, ValueArray() As Ushort, ByVal DataCnt As Ulong = 1) As Boolean
Function MB_SETHDREG Overload(ByVal MbIndex as Integer, ByVal StartAddress As Ushort, ValueArray() As Ushort, ByVal DataCnt As Ulong = 1) As Boolean 
	Dim result As Ushort
	Dim p As Ushort ptr = @ValueArray(0)
	result = BAS_ModbusTransfer(MbIndex, 16, StartAddress, p, DataCnt,  DATATYPE_U16,  -1)
	if result>0 then
	return FALSE
	else
	return TRUE
	endif
End Function

Declare Function MB_GETHDREG Overload(ByVal MbIndex as Integer, ByVal StartAddress As Ushort, ByRef Value As Ushort) As Boolean
Function MB_GETHDREG Overload(ByVal MbIndex as Integer, ByVal StartAddress As Ushort, ByRef Value As Ushort)  As Boolean 
	Dim result As Ulong
	Dim tempData As Ushort Ptr = @Value
	result = BAS_ModbusTransfer(MbIndex, 3, StartAddress, tempData, 1,  DATATYPE_U16,  -1)
	if result>0 then
	return FALSE
	else
	return TRUE
	endif
End Function

Declare Function MB_GETHDREG Overload(ByVal MbIndex as Integer, ByVal StartAddress As Ushort, Value() As Ushort, ByVal DataCnt As Ulong = 1) As Boolean
Function MB_GETHDREG Overload(ByVal MbIndex as Integer, ByVal StartAddress As Ushort, Value() As Ushort, ByVal DataCnt As Ulong = 1)  As Boolean 
	Dim result As Ulong
	Dim tempData As Ushort Ptr = @Value(0)
	result = BAS_ModbusTransfer(MbIndex, 3, StartAddress, tempData, DataCnt,  DATATYPE_U16,  -1)
	if result>0 then
	return FALSE
	else
	return TRUE
	endif
End Function

Declare Function MB_SETHDREG Overload(ByVal MbIndex as Integer, ByVal StartAddress As Ushort, ByVal Value As Short) As Boolean
Function MB_SETHDREG Overload(ByVal MbIndex as Integer, ByVal StartAddress As Ushort, ByVal Value As Short) As Boolean 
	Dim result As Short
	Dim p As Short ptr = @Value
	result = BAS_ModbusTransfer(MbIndex, 6, StartAddress, p, 1,  DATATYPE_I16,  -1)
	if result>0 then
	return FALSE
	else
	return TRUE
	endif
End Function

Declare Function MB_SETHDREG Overload(ByVal MbIndex as Integer, ByVal StartAddress As Ushort, ValueArray() As Short, ByVal DataCnt As Ulong = 1) As Boolean
Function MB_SETHDREG Overload(ByVal MbIndex as Integer, ByVal StartAddress As Ushort, ValueArray() As Short, ByVal DataCnt As Ulong = 1) As Boolean 
	Dim result As Short
	Dim p As Short ptr = @ValueArray(0)
	result = BAS_ModbusTransfer(MbIndex, 16, StartAddress, p, DataCnt,  DATATYPE_I16,  -1)
	if result>0 then
	return FALSE
	else
	return TRUE
	endif
End Function

Declare Function MB_GETHDREG Overload(ByVal MbIndex as Integer, ByVal StartAddress As Ushort, ByRef Value As Short) As Boolean
Function MB_GETHDREG Overload(ByVal MbIndex as Integer, ByVal StartAddress As Ushort, ByRef Value As Short)  As Boolean
	Dim result As Ulong
	Dim tempData As Short Ptr= @Value
	result = BAS_ModbusTransfer(MbIndex, 3, StartAddress, tempData, 1,  DATATYPE_I16,  -1)
	if result>0 then
	return FALSE
	else
	return TRUE
	endif
End Function

Declare Function MB_GETHDREG Overload(ByVal MbIndex as Integer, ByVal StartAddress As Ushort, Value() As Short, ByVal DataCnt As Ulong = 1) As Boolean
Function MB_GETHDREG Overload(ByVal MbIndex as Integer, ByVal StartAddress As Ushort, Value() As Short, ByVal DataCnt As Ulong = 1)  As Boolean
	Dim result As Ulong
	Dim tempData As Short Ptr= @Value(0)
	result = BAS_ModbusTransfer(MbIndex, 3, StartAddress, tempData, DataCnt,  DATATYPE_I16,  -1)
	if result>0 then
	return FALSE
	else
	return TRUE
	endif
End Function

Declare Function MB_SETHDREG Overload(ByVal MbIndex as Integer, ByVal StartAddress As Ushort, ByVal Value As Ulong ) As Boolean
Function MB_SETHDREG Overload(ByVal MbIndex as Integer, ByVal StartAddress As Ushort, ByVal Value As Ulong) As Boolean 
	Dim result As Short
	Dim p As Ulong ptr = @Value
	result = BAS_ModbusTransfer(MbIndex, 16, StartAddress, p, 1,  DATATYPE_U32,  -1)
	if result>0 then
	return FALSE
	else
	return TRUE
	endif
End Function

Declare Function MB_SETHDREG Overload(ByVal MbIndex as Integer, ByVal StartAddress As Ushort,  ValueArray() As Ulong, ByVal DataCnt As Ulong = 1) As Boolean
Function MB_SETHDREG Overload(ByVal MbIndex as Integer, ByVal StartAddress As Ushort, ValueArray() As Ulong, ByVal DataCnt As Ulong = 1) As Boolean 
	Dim result As Short
	Dim p As Ulong ptr = @ValueArray(0)
	result = BAS_ModbusTransfer(MbIndex, 16, StartAddress, p, DataCnt,  DATATYPE_U32,  -1)
	if result>0 then
	return FALSE
	else
	return TRUE
	endif
End Function

Declare Function MB_GETHDREG Overload(ByVal MbIndex as Integer, ByVal StartAddress As Ushort, ByRef Value As Ulong) As Boolean
Function MB_GETHDREG Overload(ByVal MbIndex as Integer, ByVal StartAddress As Ushort, ByRef Value As Ulong)  As Boolean
	Dim result As Ulong
	Dim tempData As Ulong Ptr= @Value
	result = BAS_ModbusTransfer(MbIndex, 3, StartAddress, tempData, 1,  DATATYPE_U32,  -1)
	if result>0 then
	return FALSE
	else
	return TRUE
	endif
End Function

Declare Function MB_GETHDREG Overload(ByVal MbIndex as Integer, ByVal StartAddress As Ushort, Value() As Ulong, ByVal DataCnt As Ulong = 1) As Boolean
Function MB_GETHDREG Overload(ByVal MbIndex as Integer, ByVal StartAddress As Ushort, Value() As Ulong, ByVal DataCnt As Ulong = 1)  As Boolean
	Dim result As Ulong
	Dim tempData As Ulong Ptr= @Value(0)
	result = BAS_ModbusTransfer(MbIndex, 3, StartAddress, tempData, DataCnt,  DATATYPE_U32,  -1)
	if result>0 then
	return FALSE
	else
	return TRUE
	endif
End Function

Declare Function MB_SETHDREG Overload(ByVal MbIndex as Integer, ByVal StartAddress As Ushort, ByVal Value As long) As Boolean
Function MB_SETHDREG Overload(ByVal MbIndex as Integer, ByVal StartAddress As Ushort, ByVal Value As long) As Boolean 
	Dim result As Short
	Dim p As long ptr = @Value
	result = BAS_ModbusTransfer(MbIndex, 16, StartAddress, p, 1,  DATATYPE_I32,  -1)
	if result>0 then
	return FALSE
	else
	return TRUE
	endif
End Function

Declare Function MB_SETHDREG Overload(ByVal MbIndex as Integer, ByVal StartAddress As Ushort, ValueArray() As long, ByVal DataCnt As Ulong = 1) As Boolean
Function MB_SETHDREG Overload(ByVal MbIndex as Integer, ByVal StartAddress As Ushort, ValueArray() As long, ByVal DataCnt As Ulong = 1) As Boolean 
	Dim result As Short
	Dim p As long ptr = @ValueArray(0)
	result = BAS_ModbusTransfer(MbIndex, 16, StartAddress, p, DataCnt,  DATATYPE_I32,  -1)
	if result>0 then
	return FALSE
	else
	return TRUE
	endif
End Function

Declare Function MB_GETHDREG Overload(ByVal MbIndex as Integer, ByVal StartAddress As Ushort, ByRef Value As long) As Boolean
Function MB_GETHDREG Overload(ByVal MbIndex as Integer, ByVal StartAddress As Ushort, ByRef Value As long)  As Boolean
	Dim result As Ulong
	Dim tempData As long Ptr= @Value
	result = BAS_ModbusTransfer(MbIndex, 3, StartAddress, tempData, 1,  DATATYPE_I32,  -1)
	if result>0 then
	return FALSE
	else
	return TRUE
	endif
End Function

Declare Function MB_GETHDREG Overload(ByVal MbIndex as Integer, ByVal StartAddress As Ushort, Value() As long, ByVal DataCnt As Ulong = 1) As Boolean
Function MB_GETHDREG Overload(ByVal MbIndex as Integer, ByVal StartAddress As Ushort, Value() As long, ByVal DataCnt As Ulong = 1)  As Boolean
	Dim result As Ulong
	Dim tempData As long Ptr= @Value(0)
	result = BAS_ModbusTransfer(MbIndex, 3, StartAddress, tempData, DataCnt,  DATATYPE_I32,  -1)
	if result>0 then
	return FALSE
	else
	return TRUE
	endif
End Function

Declare Function MB_SETHDREG Overload(ByVal MbIndex as Integer, ByVal StartAddress As Ushort, ByVal Value As Integer) As Boolean
Function MB_SETHDREG Overload(ByVal MbIndex as Integer, ByVal StartAddress As Ushort, ByVal Value As Integer) As Boolean 
	Dim result As Short
	Dim p As Integer ptr = @Value
	result = BAS_ModbusTransfer(MbIndex, 16, StartAddress, p, 1,  DATATYPE_I32,  -1)
	if result>0 then
	return FALSE
	else
	return TRUE
	endif
End Function

Declare Function MB_SETHDREG Overload(ByVal MbIndex as Integer, ByVal StartAddress As Ushort, ValueArray() As Integer, ByVal DataCnt As Ulong = 1) As Boolean
Function MB_SETHDREG Overload(ByVal MbIndex as Integer, ByVal StartAddress As Ushort, ValueArray() As Integer, ByVal DataCnt As Ulong = 1) As Boolean 
	Dim result As Short
	Dim p As Integer ptr = @ValueArray(0)
	result = BAS_ModbusTransfer(MbIndex, 16, StartAddress, p, DataCnt,  DATATYPE_I32,  -1)
	if result>0 then
	return FALSE
	else
	return TRUE
	endif
End Function

Declare Function MB_GETHDREG Overload(ByVal MbIndex as Integer, ByVal StartAddress As Ushort, ByRef Value As Integer) As Boolean
Function MB_GETHDREG Overload(ByVal MbIndex as Integer, ByVal StartAddress As Ushort, ByRef Value As Integer)  As Boolean
	Dim result As Ulong
	Dim tempData As Integer Ptr= @Value
	result = BAS_ModbusTransfer(MbIndex, 3, StartAddress, tempData, 1,  DATATYPE_I32,  -1)
	if result>0 then
	return FALSE
	else
	return TRUE
	endif
End Function

Declare Function MB_GETHDREG Overload(ByVal MbIndex as Integer, ByVal StartAddress As Ushort, Value() As Integer, ByVal DataCnt As Ulong = 1) As Boolean
Function MB_GETHDREG Overload(ByVal MbIndex as Integer, ByVal StartAddress As Ushort, Value() As Integer, ByVal DataCnt As Ulong = 1)  As Boolean
	Dim result As Ulong
	Dim tempData As Integer Ptr= @Value(0)
	result = BAS_ModbusTransfer(MbIndex, 3, StartAddress, tempData, DataCnt,  DATATYPE_I32,  -1)
	if result>0 then
	return FALSE
	else
	return TRUE
	endif
End Function


Declare Function MB_SETHDREG Overload(ByVal MbIndex as Integer, ByVal StartAddress As Ushort, ByVal Value As UInteger) As Boolean
Function MB_SETHDREG Overload(ByVal MbIndex as Integer, ByVal StartAddress As Ushort, ByVal Value As UInteger) As Boolean 
	Dim result As Short
	Dim p As UInteger ptr = @Value
	result = BAS_ModbusTransfer(MbIndex, 16, StartAddress, p, 1,  DATATYPE_U32,  -1)
	if result>0 then
	return FALSE
	else
	return TRUE
	endif
End Function

Declare Function MB_SETHDREG Overload(ByVal MbIndex as Integer, ByVal StartAddress As Ushort, ValueArray() As UInteger, ByVal DataCnt As Ulong = 1) As Boolean
Function MB_SETHDREG Overload(ByVal MbIndex as Integer, ByVal StartAddress As Ushort, ValueArray() As UInteger, ByVal DataCnt As Ulong = 1) As Boolean 
	Dim result As Short
	Dim p As UInteger ptr = @ValueArray(0)
	result = BAS_ModbusTransfer(MbIndex, 16, StartAddress, p, DataCnt,  DATATYPE_U32,  -1)
	if result>0 then
	return FALSE
	else
	return TRUE
	endif
End Function

Declare Function MB_GETHDREG Overload(ByVal MbIndex as Integer, ByVal StartAddress As Ushort, ByRef Value As UInteger) As Boolean
Function MB_GETHDREG Overload(ByVal MbIndex as Integer, ByVal StartAddress As Ushort, ByRef Value As UInteger)  As Boolean
	Dim result As Ulong
	Dim tempData As UInteger Ptr= @Value
	result = BAS_ModbusTransfer(MbIndex, 3, StartAddress, tempData, 1,  DATATYPE_U32,  -1)
	if result>0 then
	return FALSE
	else
	return TRUE
	endif
End Function

Declare Function MB_GETHDREG Overload(ByVal MbIndex as Integer, ByVal StartAddress As Ushort, Value() As UInteger, ByVal DataCnt As Ulong = 1) As Boolean
Function MB_GETHDREG Overload(ByVal MbIndex as Integer, ByVal StartAddress As Ushort, Value() As UInteger, ByVal DataCnt As Ulong = 1)  As Boolean
	Dim result As Ulong
	Dim tempData As UInteger Ptr= @Value(0)
	result = BAS_ModbusTransfer(MbIndex, 3, StartAddress, tempData, DataCnt,  DATATYPE_U32,  -1)
	if result>0 then
	return FALSE
	else
	return TRUE
	endif
End Function

Declare Function MB_SETHDREG Overload(ByVal MbIndex as Integer, ByVal StartAddress As Ushort, ByVal Value As Single) As Boolean
Function MB_SETHDREG Overload(ByVal MbIndex as Integer, ByVal StartAddress As Ushort, ByVal Value As Single) As Boolean 
	Dim result As Short
	Dim p As Single ptr = @Value
	result = BAS_ModbusTransfer(MbIndex, 16, StartAddress, p, 1,  DATATYPE_F32,  -1)
	if result>0 then
	return FALSE
	else
	return TRUE
	endif
End Function

Declare Function MB_SETHDREG Overload(ByVal MbIndex as Integer, ByVal StartAddress As Ushort, ValueArray() As Single, ByVal DataCnt As Ulong = 1) As Boolean
Function MB_SETHDREG Overload(ByVal MbIndex as Integer, ByVal StartAddress As Ushort, ValueArray() As Single, ByVal DataCnt As Ulong = 1) As Boolean 
	Dim result As Short
	Dim p As Single ptr = @ValueArray(0)
	result = BAS_ModbusTransfer(MbIndex, 16, StartAddress, p, DataCnt,  DATATYPE_F32,  -1)
	if result>0 then
	return FALSE
	else
	return TRUE
	endif
End Function

Declare Function MB_GETHDREG Overload(ByVal MbIndex as Integer, ByVal StartAddress As Ushort, ByRef Value As Single) As Boolean
Function MB_GETHDREG Overload(ByVal MbIndex as Integer, ByVal StartAddress As Ushort, ByRef Value As Single)  As Boolean
	Dim result As Ulong
	Dim tempData As Single Ptr= @Value
	result = BAS_ModbusTransfer(MbIndex, 3, StartAddress, tempData, 1,  DATATYPE_F32,  -1)
	if result>0 then
	return FALSE
	else
	return TRUE
	endif
End Function

Declare Function MB_GETHDREG Overload(ByVal MbIndex as Integer, ByVal StartAddress As Ushort, Value() As Single, ByVal DataCnt As Ulong = 1) As Boolean
Function MB_GETHDREG Overload(ByVal MbIndex as Integer, ByVal StartAddress As Ushort, Value() As Single, ByVal DataCnt As Ulong = 1)  As Boolean
	Dim result As Ulong
	Dim tempData As Single Ptr= @Value(0)
	result = BAS_ModbusTransfer(MbIndex, 3, StartAddress, tempData, DataCnt,  DATATYPE_F32,  -1)
	if result>0 then
	return FALSE
	else
	return TRUE
	endif
End Function

Declare Function MB_SETHDREG Overload(ByVal MbIndex as Integer, ByVal StartAddress As Ushort, ByVal Value As Double) As Boolean
Function MB_SETHDREG Overload(ByVal MbIndex as Integer, ByVal StartAddress As Ushort, ByVal Value As Double) As Boolean 
	Dim result As Short
	Dim p As Double ptr = @Value
	result = BAS_ModbusTransfer(MbIndex, 16, StartAddress, p, 1,  DATATYPE_F64,  -1)
	if result>0 then
	return FALSE
	else
	return TRUE
	endif
End Function

Declare Function MB_SETHDREG Overload(ByVal MbIndex as Integer, ByVal StartAddress As Ushort, ValueArray() As Double, ByVal DataCnt As Ulong = 1) As Boolean
Function MB_SETHDREG Overload(ByVal MbIndex as Integer, ByVal StartAddress As Ushort, ValueArray() As Double, ByVal DataCnt As Ulong = 1) As Boolean 
	Dim result As Short
	Dim p As Double ptr = @ValueArray(0)
	result = BAS_ModbusTransfer(MbIndex, 16, StartAddress, p, DataCnt,  DATATYPE_F64,  -1)
	if result>0 then
	return FALSE
	else
	return TRUE
	endif
End Function

Declare Function MB_SETHDREG Overload(ByVal MbIndex as Integer, ByVal StartAddress As Ushort, ByVal Value As Double, ByVal DataType As Ushort) As Boolean
Function MB_SETHDREG Overload(ByVal MbIndex as Integer, ByVal StartAddress As Ushort, ByVal Value As Double, ByVal DataType As Ushort) As Boolean 
	Dim result As Short

	Select Case DataType
	Case DATATYPE_U16
		Dim p As Ushort = CUShort(Value)
		result = BAS_ModbusTransfer(MbIndex, 6, StartAddress, @p, 1,  DATATYPE_U16,  -1)  
	Case DATATYPE_I16
		Dim p As Short = CShort(Value)
		result = BAS_ModbusTransfer(MbIndex, 6, StartAddress, @p, 1,  DATATYPE_I16,  -1) 
	Case DATATYPE_U32
		Dim p As Ulong = CUInt(Value)
		result = BAS_ModbusTransfer(MbIndex, 16, StartAddress, @p, 1,  DATATYPE_U32,  -1) 
	Case DATATYPE_I32
		Dim p As long = CInt(Value)
		result = BAS_ModbusTransfer(MbIndex, 16, StartAddress, @p, 1,  DATATYPE_I32,  -1) 
	Case DATATYPE_F32
		Dim p As Single = CSng(Value)
		result = BAS_ModbusTransfer(MbIndex, 16, StartAddress, @p, 1,  DATATYPE_F32,  -1) 
	Case DATATYPE_F64
		Dim p As Double = Value
		result = BAS_ModbusTransfer(MbIndex, 16, StartAddress, @p, 1,  DATATYPE_F64,  -1)
	Case Else
	   return FALSE
	End Select
	
	if result>0 then
	return FALSE
	else
	return TRUE
	endif
End Function


Declare Function MB_GETHDREG Overload(ByVal MbIndex as Integer, ByVal StartAddress As Ushort, ByRef Value As Double) As Boolean
Function MB_GETHDREG Overload(ByVal MbIndex as Integer, ByVal StartAddress As Ushort, ByRef Value As Double)  As Boolean
	Dim result As Ulong
	Dim tempData As Double Ptr= @Value
	result = BAS_ModbusTransfer(MbIndex, 3, StartAddress, tempData, 1,  DATATYPE_F64,  -1)
	if result>0 then
	return FALSE
	else
	return TRUE
	endif
End Function

Declare Function MB_GETHDREG Overload(ByVal MbIndex as Integer, ByVal StartAddress As Ushort, Value() As Double, ByVal DataCnt As Ulong = 1) As Boolean
Function MB_GETHDREG Overload(ByVal MbIndex as Integer, ByVal StartAddress As Ushort, Value() As Double, ByVal DataCnt As Ulong = 1)  As Boolean
	Dim result As Ulong
	Dim tempData As Double Ptr= @Value(0)
	result = BAS_ModbusTransfer(MbIndex, 3, StartAddress, tempData, DataCnt,  DATATYPE_F64,  -1)
	if result>0 then
	return FALSE
	else
	return TRUE
	endif
End Function

Declare Function MB_GETINREG Overload(ByVal MbIndex as Integer, ByVal StartAddress As Ushort, ByRef Value As Ushort) As Boolean
Function MB_GETINREG Overload(ByVal MbIndex as Integer, ByVal StartAddress As Ushort, ByRef Value As Ushort)  As Boolean 
	Dim result As Ulong
	Dim tempData As Ushort Ptr = @Value
	result = BAS_ModbusTransfer(MbIndex, 4, StartAddress, tempData, 1,  DATATYPE_U16,  -1)
	if result>0 then
	return FALSE
	else
	return TRUE
	endif
End Function

Declare Function MB_GETINREG Overload(ByVal MbIndex as Integer, ByVal StartAddress As Ushort, Value() As Ushort, ByVal DataCnt As Ulong = 1) As Boolean
Function MB_GETINREG Overload(ByVal MbIndex as Integer, ByVal StartAddress As Ushort, Value() As Ushort, ByVal DataCnt As Ulong = 1)  As Boolean 
	Dim result As Ulong
	Dim tempData As Ushort Ptr = @Value(0)
	result = BAS_ModbusTransfer(MbIndex, 4, StartAddress, tempData, DataCnt,  DATATYPE_U16,  -1)
	if result>0 then
	return FALSE
	else
	return TRUE
	endif
End Function

Declare Function MB_GETINREG Overload(ByVal MbIndex as Integer, ByVal StartAddress As Ushort, ByRef Value As Short) As Boolean
Function MB_GETINREG Overload(ByVal MbIndex as Integer, ByVal StartAddress As Ushort, ByRef Value As Short)  As Boolean 
	Dim result As Ulong
	Dim tempData As Short Ptr = @Value
	result = BAS_ModbusTransfer(MbIndex, 4, StartAddress, tempData, 1,  DATATYPE_I16,  -1)
	if result>0 then
	return FALSE
	else
	return TRUE
	endif
End Function

Declare Function MB_GETINREG Overload(ByVal MbIndex as Integer, ByVal StartAddress As Ushort, Value() As Short, ByVal DataCnt As Ulong = 1) As Boolean
Function MB_GETINREG Overload(ByVal MbIndex as Integer, ByVal StartAddress As Ushort, Value() As Short, ByVal DataCnt As Ulong = 1)  As Boolean 
	Dim result As Ulong
	Dim tempData As Short Ptr = @Value(0)
	result = BAS_ModbusTransfer(MbIndex, 4, StartAddress, tempData, DataCnt,  DATATYPE_I16,  -1)
	if result>0 then
	return FALSE
	else
	return TRUE
	endif
End Function

Declare Function MB_GETINREG Overload(ByVal MbIndex as Integer, ByVal StartAddress As Ushort, ByRef Value As Ulong) As Boolean
Function MB_GETINREG Overload(ByVal MbIndex as Integer, ByVal StartAddress As Ushort, ByRef Value As Ulong)  As Boolean
	Dim result As Ulong
	Dim tempData As Ulong Ptr= @Value
	result = BAS_ModbusTransfer(MbIndex, 4, StartAddress, tempData, 1,  DATATYPE_U32,  -1)
	if result>0 then
	return FALSE
	else
	return TRUE
	endif
End Function

Declare Function MB_GETINREG Overload(ByVal MbIndex as Integer, ByVal StartAddress As Ushort, Value() As Ulong, ByVal DataCnt As Ulong = 1) As Boolean
Function MB_GETINREG Overload(ByVal MbIndex as Integer, ByVal StartAddress As Ushort, Value() As Ulong, ByVal DataCnt As Ulong = 1)  As Boolean
	Dim result As Ulong
	Dim tempData As Ulong Ptr= @Value(0)
	result = BAS_ModbusTransfer(MbIndex, 4, StartAddress, tempData, DataCnt,  DATATYPE_U32,  -1)
	if result>0 then
	return FALSE
	else
	return TRUE
	endif
End Function

Declare Function MB_GETINREG Overload(ByVal MbIndex as Integer, ByVal StartAddress As Ushort, ByRef Value As long) As Boolean
Function MB_GETINREG Overload(ByVal MbIndex as Integer, ByVal StartAddress As Ushort, ByRef Value As long)  As Boolean
	Dim result As Ulong
	Dim tempData As long Ptr= @Value
	result = BAS_ModbusTransfer(MbIndex, 4, StartAddress, tempData, 1,  DATATYPE_I32,  -1)
	if result>0 then
	return FALSE
	else
	return TRUE
	endif
End Function

Declare Function MB_GETINREG Overload(ByVal MbIndex as Integer, ByVal StartAddress As Ushort, Value() As long, ByVal DataCnt As Ulong = 1) As Boolean
Function MB_GETINREG Overload(ByVal MbIndex as Integer, ByVal StartAddress As Ushort, Value() As long, ByVal DataCnt As Ulong = 1)  As Boolean
	Dim result As Ulong
	Dim tempData As long Ptr= @Value(0)
	result = BAS_ModbusTransfer(MbIndex, 4, StartAddress, tempData, DataCnt,  DATATYPE_I32,  -1)
	if result>0 then
	return FALSE
	else
	return TRUE
	endif
End Function

Declare Function MB_GETINREG Overload(ByVal MbIndex as Integer, ByVal StartAddress As Ushort, ByRef Value As Integer) As Boolean
Function MB_GETINREG Overload(ByVal MbIndex as Integer, ByVal StartAddress As Ushort, ByRef Value As Integer)  As Boolean
	Dim result As Ulong
	Dim tempData As Integer Ptr= @Value
	result = BAS_ModbusTransfer(MbIndex, 4, StartAddress, tempData, 1,  DATATYPE_I32,  -1)
	if result>0 then
	return FALSE
	else
	return TRUE
	endif
End Function

Declare Function MB_GETINREG Overload(ByVal MbIndex as Integer, ByVal StartAddress As Ushort, Value() As Integer, ByVal DataCnt As Ulong = 1) As Boolean
Function MB_GETINREG Overload(ByVal MbIndex as Integer, ByVal StartAddress As Ushort, Value() As Integer, ByVal DataCnt As Ulong = 1)  As Boolean
	Dim result As Ulong
	Dim tempData As Integer Ptr= @Value(0)
	result = BAS_ModbusTransfer(MbIndex, 4, StartAddress, tempData, DataCnt,  DATATYPE_I32,  -1)
	if result>0 then
	return FALSE
	else
	return TRUE
	endif
End Function

Declare Function MB_GETINREG Overload(ByVal MbIndex as Integer, ByVal StartAddress As Ushort, ByRef Value As UInteger) As Boolean
Function MB_GETINREG Overload(ByVal MbIndex as Integer, ByVal StartAddress As Ushort, ByRef Value As UInteger)  As Boolean
	Dim result As Ulong
	Dim tempData As UInteger Ptr= @Value
	result = BAS_ModbusTransfer(MbIndex, 4, StartAddress, tempData, 1,  DATATYPE_U32,  -1)
	if result>0 then
	return FALSE
	else
	return TRUE
	endif
End Function

Declare Function MB_GETINREG Overload(ByVal MbIndex as Integer, ByVal StartAddress As Ushort, Value() As UInteger, ByVal DataCnt As Ulong = 1) As Boolean
Function MB_GETINREG Overload(ByVal MbIndex as Integer, ByVal StartAddress As Ushort, Value() As UInteger, ByVal DataCnt As Ulong = 1)  As Boolean
	Dim result As Ulong
	Dim tempData As UInteger Ptr= @Value(0)
	result = BAS_ModbusTransfer(MbIndex, 4, StartAddress, tempData, DataCnt,  DATATYPE_U32,  -1)
	if result>0 then
	return FALSE
	else
	return TRUE
	endif
End Function

Declare Function MB_GETINREG Overload(ByVal MbIndex as Integer, ByVal StartAddress As Ushort, ByRef Value As Single) As Boolean
Function MB_GETINREG Overload(ByVal MbIndex as Integer, ByVal StartAddress As Ushort, ByRef Value As Single)  As Boolean
	Dim result As Ulong
	Dim tempData As Single Ptr= @Value
	result = BAS_ModbusTransfer(MbIndex, 4, StartAddress, tempData, 1,  DATATYPE_F32,  -1)
	if result>0 then
	return FALSE
	else
	return TRUE
	endif
End Function

Declare Function MB_GETINREG Overload(ByVal MbIndex as Integer, ByVal StartAddress As Ushort, Value() As Single, ByVal DataCnt As Ulong = 1) As Boolean
Function MB_GETINREG Overload(ByVal MbIndex as Integer, ByVal StartAddress As Ushort, Value() As Single, ByVal DataCnt As Ulong = 1)  As Boolean
	Dim result As Ulong
	Dim tempData As Single Ptr= @Value(0)
	result = BAS_ModbusTransfer(MbIndex, 4, StartAddress, tempData, DataCnt,  DATATYPE_F32,  -1)
	if result>0 then
	return FALSE
	else
	return TRUE
	endif
End Function

Declare Function MB_GETINREG Overload(ByVal MbIndex as Integer, ByVal StartAddress As Ushort, ByRef Value As Double) As Boolean
Function MB_GETINREG Overload(ByVal MbIndex as Integer, ByVal StartAddress As Ushort, ByRef Value As Double)  As Boolean
	Dim result As Ulong
	Dim tempData As Double Ptr= @Value
	result = BAS_ModbusTransfer(MbIndex, 4, StartAddress, tempData, 1,  DATATYPE_F64,  -1)
	if result>0 then
	return FALSE
	else
	return TRUE
	endif
End Function

Declare Function MB_GETINREG Overload(ByVal MbIndex as Integer, ByVal StartAddress As Ushort, Value() As Double, ByVal DataCnt As Ulong = 1) As Boolean
Function MB_GETINREG Overload(ByVal MbIndex as Integer, ByVal StartAddress As Ushort, Value() As Double, ByVal DataCnt As Ulong = 1)  As Boolean
	Dim result As Ulong
	Dim tempData As Double Ptr= @Value(0)
	result = BAS_ModbusTransfer(MbIndex, 4, StartAddress, tempData, DataCnt,  DATATYPE_F64,  -1)
	if result>0 then
	return FALSE
	else
	return TRUE
	endif
End Function

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''Type
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''Type
'TCP

'SERIAL PORT

'VR
Type Type_VR
    Declare Operator Let (rhs As double) 
    Declare Operator Let (rhs As Type_VR) 
    Declare Operator Cast() As double
    Declare Operator Cast() As String
	id As Ulong
End Type
Operator Type_VR.Let (rhs As double)
	WriteVR(This.id, rhs)
End Operator
Operator Type_VR.Let (rhs As Type_VR) 
	WriteVR(This.id, ReadVR(rhs.id))
End Operator
Operator Type_VR.cast () As double
	Return ReadVR(This.id)
End Operator
Operator Type_VR.cast () As String
	Return Str(ReadVR(This.id))
End Operator

'Table
Type Type_Table
    Declare Operator Let (rhs As double)
    Declare Operator Let (rhs As Type_VR) 
    Declare Operator Cast() As double
    Declare Operator Cast() As String
	id As Ulong
End Type
Operator Type_Table.Let (rhs As double)
	WriteTable(This.id, rhs)
End Operator
Operator Type_Table.Let (rhs As Type_VR) 
	WriteTable(This.id, ReadTable(rhs.id))
End Operator
Operator Type_Table.cast () As double
	Return ReadTable(This.id)
End Operator
Operator Type_Table.cast () As String
	Return Str(ReadTable(This.id))
End Operator
'DO
Type Type_DO
    Declare Operator Let (rhs As Ubyte)
    Declare Operator Cast() As Ubyte
    Declare Operator Cast() As String
	id As Ulong
End Type
Operator Type_DO.Let (rhs As Ubyte)
	WriteDO(This.id, rhs)
End Operator
Operator Type_DO.cast () As Ubyte
	Return ReadDO(This.id)
End Operator
Operator Type_DO.cast () As String
	Return Str(ReadDO(This.id))
End Operator
'DI
Type Type_DI
    Declare Operator Let (rhs As Ubyte)
    Declare Operator Cast() As Ubyte
    Declare Operator Cast() As String
	id As Ulong
End Type
Operator Type_DI.Let (rhs As Ubyte)
	print "DI(" + str(This.id) + ") can't be set value!"					'yf,2016.07.05 be saved
End Operator
Operator Type_DI.cast () As Ubyte
	Return ReadDI(This.id)
End Operator
Operator Type_DI.cast () As String
	Return Str(ReadDI(This.id))
End Operator

'AX
Type Type_AX
	id As UShort
End Type

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'PPU
Type Type_PPU
  value As LONG
  Declare Operator Let (rhs As LONG )  
  Declare Operator Cast() As ULONG
  Declare Operator Cast() As String
End Type
Operator Type_PPU.let (rhs As LONG )
  ABAS_SetPPU(-1, rhs, rhs, rhs, rhs, rhs, rhs, rhs, rhs)
End Operator
Operator Type_PPU.cast () As ULONG
  Return ABAS_GetPPU()
End Operator
Operator Type_PPU.cast () As String
  Return Str(ABAS_GetPPU())
End Operator

'MaxVel
Type Type_MaxVel
  value As DOUBLE
  Declare Operator Let (rhs As DOUBLE )  
  Declare Operator Cast() As DOUBLE
  Declare Operator Cast() As String
End Type
Operator Type_MaxVel.let (rhs As DOUBLE )
  ABAS_SetMaxVel(-1, rhs, rhs, rhs, rhs, rhs, rhs, rhs, rhs)
End Operator
Operator Type_MaxVel.cast () As DOUBLE
  Return ABAS_GetMaxVel()
End Operator
Operator Type_MaxVel.cast () As String
  Return Str(ABAS_GetMaxVel())
End Operator
'MaxAcc
Type Type_MaxAcc
  value As DOUBLE
  Declare Operator Let (rhs As DOUBLE )  
  Declare Operator Cast() As DOUBLE
  Declare Operator Cast() As String
End Type
Operator Type_MaxAcc.let (rhs As DOUBLE )
  ABAS_SetMaxAcc(-1, rhs, rhs, rhs, rhs, rhs, rhs, rhs, rhs)
End Operator
Operator Type_MaxAcc.cast () As DOUBLE
  Return ABAS_GetMaxAcc()
End Operator
Operator Type_MaxAcc.cast () As String
  Return Str(ABAS_GetMaxAcc())
End Operator
'MaxDec
Type Type_MaxDec
  value As DOUBLE
  Declare Operator Let (rhs As DOUBLE )  
  Declare Operator Cast() As DOUBLE
  Declare Operator Cast() As String
End Type
Operator Type_MaxDec.let (rhs As DOUBLE )
  ABAS_SetMaxDec(-1, rhs, rhs, rhs, rhs, rhs, rhs, rhs, rhs)
End Operator
Operator Type_MaxDec.cast () As DOUBLE
  Return ABAS_GetMaxDec()
End Operator
Operator Type_MaxDec.cast () As String
  Return Str(ABAS_GetMaxDec())
End Operator
'PulseInMode
Type Type_PulseInMode
  value As LONG
  Declare Operator Let (rhs As LONG )  
  Declare Operator Cast() As ULONG
  Declare Operator Cast() As String
End Type
Operator Type_PulseInMode.let (rhs As LONG )
  ABAS_SetPulseInMode(-1, rhs, rhs, rhs, rhs, rhs, rhs, rhs, rhs)
End Operator
Operator Type_PulseInMode.cast () As ULONG
  Return ABAS_GetPulseInMode()
End Operator
Operator Type_PulseInMode.cast () As String
  Return Str(ABAS_GetPulseInMode())
End Operator

'PulseInLogic
Type Type_PulseInLogic
  value As LONG
  Declare Operator Let (rhs As LONG )  
  Declare Operator Cast() As ULONG
  Declare Operator Cast() As String
End Type
Operator Type_PulseInLogic.let (rhs As LONG )
  ABAS_SetPulseInLogic(-1, rhs, rhs, rhs, rhs, rhs, rhs, rhs, rhs)
End Operator
Operator Type_PulseInLogic.cast () As ULONG
  Return ABAS_GetPulseInLogic()
End Operator
Operator Type_PulseInLogic.cast () As String
  Return Str(ABAS_GetPulseInLogic())
End Operator

'PulseOutMode
Type Type_PulseOutMode
  value As LONG
  Declare Operator Let (rhs As LONG )  
  Declare Operator Cast() As ULONG
  Declare Operator Cast() As String
End Type
Operator Type_PulseOutMode.let (rhs As LONG )
  ABAS_SetPulseOutMode(-1, rhs, rhs, rhs, rhs, rhs, rhs, rhs, rhs)
End Operator
Operator Type_PulseOutMode.cast () As ULONG
  Return ABAS_GetPulseOutMode()
End Operator
Operator Type_PulseOutMode.cast () As String
  Return Str(ABAS_GetPulseOutMode())
End Operator

'AlmEnable
Type Type_AlmEnable
  value As LONG
  Declare Operator Let (rhs As LONG )  
  Declare Operator Cast() As ULONG
  Declare Operator Cast() As String
End Type
Operator Type_AlmEnable.let (rhs As LONG )
  ABAS_SetAlmEnable(-1, rhs, rhs, rhs, rhs, rhs, rhs, rhs, rhs)
End Operator
Operator Type_AlmEnable.cast () As ULONG
  Return ABAS_GetAlmEnable()
End Operator
Operator Type_AlmEnable.cast () As String
  Return Str(ABAS_GetAlmEnable())
End Operator

'AlmLogic
Type Type_AlmLogic
  value As LONG
  Declare Operator Let (rhs As LONG )  
  Declare Operator Cast() As ULONG
  Declare Operator Cast() As String
End Type
Operator Type_AlmLogic.let (rhs As LONG )
  ABAS_SetAlmLogic(-1, rhs, rhs, rhs, rhs, rhs, rhs, rhs, rhs)
End Operator
Operator Type_AlmLogic.cast () As ULONG
  Return ABAS_GetAlmLogic()
End Operator
Operator Type_AlmLogic.cast () As String
  Return Str(ABAS_GetAlmLogic())
End Operator

'AlmReact
Type Type_AlmReact
  value As LONG
  Declare Operator Let (rhs As LONG )  
  Declare Operator Cast() As ULONG
  Declare Operator Cast() As String
End Type
Operator Type_AlmReact.let (rhs As LONG )
  ABAS_SetAlmReact(-1, rhs, rhs, rhs, rhs, rhs, rhs, rhs, rhs)
End Operator
Operator Type_AlmReact.cast () As ULONG
  Return ABAS_GetAlmReact()
End Operator
Operator Type_AlmReact.cast () As String
  Return Str(ABAS_GetAlmReact())
End Operator

'InpEnable
Type Type_InpEnable
  value As LONG
  Declare Operator Let (rhs As LONG )  
  Declare Operator Cast() As ULONG
  Declare Operator Cast() As String
End Type
Operator Type_InpEnable.let (rhs As LONG )
  ABAS_SetInpEnable(-1, rhs, rhs, rhs, rhs, rhs, rhs, rhs, rhs)
End Operator
Operator Type_InpEnable.cast () As ULONG
  Return ABAS_GetInpEnable()
End Operator
Operator Type_InpEnable.cast () As String
  Return Str(ABAS_GetInpEnable())
End Operator

'InpLogic
Type Type_InpLogic
  value As LONG
  Declare Operator Let (rhs As LONG )  
  Declare Operator Cast() As ULONG
  Declare Operator Cast() As String
End Type
Operator Type_InpLogic.let (rhs As LONG )
  ABAS_SetInpLogic(-1, rhs, rhs, rhs, rhs, rhs, rhs, rhs, rhs)
End Operator
Operator Type_InpLogic.cast () As ULONG
  Return ABAS_GetInpLogic()
End Operator
Operator Type_InpLogic.cast () As String
  Return Str(ABAS_GetInpLogic())
End Operator

'ErcLogic
Type Type_ErcLogic
  value As LONG
  Declare Operator Let (rhs As LONG )  
  Declare Operator Cast() As ULONG
  Declare Operator Cast() As String
End Type
Operator Type_ErcLogic.let (rhs As LONG )
  ABAS_SetErcLogic(-1, rhs, rhs, rhs, rhs, rhs, rhs, rhs, rhs)
End Operator
Operator Type_ErcLogic.cast () As ULONG
  Return ABAS_GetErcLogic()
End Operator
Operator Type_ErcLogic.cast () As String
  Return Str(ABAS_GetErcLogic())
End Operator

'ErcEnableMode
Type Type_ErcEnableMode
  value As LONG
  Declare Operator Let (rhs As LONG )  
  Declare Operator Cast() As ULONG
  Declare Operator Cast() As String
End Type
Operator Type_ErcEnableMode.let (rhs As LONG )
  ABAS_SetErcEnableMode(-1, rhs, rhs, rhs, rhs, rhs, rhs, rhs, rhs)
End Operator
Operator Type_ErcEnableMode.cast () As ULONG
  Return ABAS_GetErcEnableMode()
End Operator
Operator Type_ErcEnableMode.cast () As String
  Return Str(ABAS_GetErcEnableMode())
End Operator

'ElEnable
Type Type_ElEnable
  value As LONG
  Declare Operator Let (rhs As LONG )  
  Declare Operator Cast() As ULONG
  Declare Operator Cast() As String
End Type
Operator Type_ElEnable.let (rhs As LONG )
  ABAS_SetElEnable(-1, rhs, rhs, rhs, rhs, rhs, rhs, rhs, rhs)
End Operator
Operator Type_ElEnable.cast () As ULONG
  Return ABAS_GetElEnable()
End Operator
Operator Type_ElEnable.cast () As String
  Return Str(ABAS_GetElEnable())
End Operator

'ElLogic
Type Type_ElLogic
  value As LONG
  Declare Operator Let (rhs As LONG )  
  Declare Operator Cast() As ULONG
  Declare Operator Cast() As String
End Type
Operator Type_ElLogic.let (rhs As LONG )
  ABAS_SetElLogic(-1, rhs, rhs, rhs, rhs, rhs, rhs, rhs, rhs)
End Operator
Operator Type_ElLogic.cast () As ULONG
  Return ABAS_GetElLogic()
End Operator
Operator Type_ElLogic.cast () As String
  Return Str(ABAS_GetElLogic())
End Operator

'ElReact
Type Type_ElReact
  value As LONG
  Declare Operator Let (rhs As LONG )  
  Declare Operator Cast() As ULONG
  Declare Operator Cast() As String
End Type
Operator Type_ElReact.let (rhs As LONG )
  ABAS_SetElReact(-1, rhs, rhs, rhs, rhs, rhs, rhs, rhs, rhs)
End Operator
Operator Type_ElReact.cast () As ULONG
  Return ABAS_GetElReact()
End Operator
Operator Type_ElReact.cast () As String
  Return Str(ABAS_GetElReact())
End Operator

'SwMelEnable
Type Type_SwMelEnable
  value As LONG
  Declare Operator Let (rhs As LONG )  
  Declare Operator Cast() As ULONG
  Declare Operator Cast() As String
End Type
Operator Type_SwMelEnable.let (rhs As LONG )
  ABAS_SetSwMelEnable(-1, rhs, rhs, rhs, rhs, rhs, rhs, rhs, rhs)
End Operator
Operator Type_SwMelEnable.cast () As ULONG
  Return ABAS_GetSwMelEnable()
End Operator
Operator Type_SwMelEnable.cast () As String
  Return Str(ABAS_GetSwMelEnable())
End Operator

'SwMelReact
Type Type_SwMelReact
  value As LONG
  Declare Operator Let (rhs As LONG )  
  Declare Operator Cast() As ULONG
  Declare Operator Cast() As String
End Type
Operator Type_SwMelReact.let (rhs As LONG )
  ABAS_SetSwMelReact(-1, rhs, rhs, rhs, rhs, rhs, rhs, rhs, rhs)
End Operator
Operator Type_SwMelReact.cast () As ULONG
  Return ABAS_GetSwMelReact()
End Operator
Operator Type_SwMelReact.cast () As String
  Return Str(ABAS_GetSwMelReact())
End Operator

'SwMelValue
Type Type_SwMelValue
  value As LONG
  Declare Operator Let (rhs As LONG )  
  Declare Operator Cast() As LONG
  Declare Operator Cast() As String
End Type
Operator Type_SwMelValue.let (rhs As LONG )
  ABAS_SetSwMelValue(-1, rhs, rhs, rhs, rhs, rhs, rhs, rhs, rhs)
End Operator
Operator Type_SwMelValue.cast () As LONG
  Return ABAS_GetSwMelValue()
End Operator
Operator Type_SwMelValue.cast () As String
  Return Str(ABAS_GetSwMelValue())
End Operator

'SwPelEnable
Type Type_SwPelEnable
  value As LONG
  Declare Operator Let (rhs As LONG )  
  Declare Operator Cast() As ULONG
  Declare Operator Cast() As String
End Type
Operator Type_SwPelEnable.let (rhs As LONG )
  ABAS_SetSwPelEnable(-1, rhs, rhs, rhs, rhs, rhs, rhs, rhs, rhs)
End Operator
Operator Type_SwPelEnable.cast () As ULONG
  Return ABAS_GetSwPelEnable()
End Operator
Operator Type_SwPelEnable.cast () As String
  Return Str(ABAS_GetSwPelEnable())
End Operator

'SwPelReact
Type Type_SwPelReact
  value As LONG
  Declare Operator Let (rhs As LONG )  
  Declare Operator Cast() As ULONG
  Declare Operator Cast() As String
End Type
Operator Type_SwPelReact.let (rhs As LONG )
  ABAS_SetSwPelReact(-1, rhs, rhs, rhs, rhs, rhs, rhs, rhs, rhs)
End Operator
Operator Type_SwPelReact.cast () As ULONG
  Return ABAS_GetSwPelReact()
End Operator
Operator Type_SwPelReact.cast () As String
  Return Str(ABAS_GetSwPelReact())
End Operator

'SwPelValue
Type Type_SwPelValue
  value As LONG
  Declare Operator Let (rhs As LONG )  
  Declare Operator Cast() As LONG
  Declare Operator Cast() As String
End Type
Operator Type_SwPelValue.let (rhs As LONG )
  ABAS_SetSwPelValue(-1, rhs, rhs, rhs, rhs, rhs, rhs, rhs, rhs)
End Operator
Operator Type_SwPelValue.cast () As LONG
  Return ABAS_GetSwPelValue()
End Operator
Operator Type_SwPelValue.cast () As String
  Return Str(ABAS_GetSwPelValue())
End Operator

'OrgLogic
Type Type_OrgLogic
  value As LONG
  Declare Operator Let (rhs As LONG )  
  Declare Operator Cast() As ULONG
  Declare Operator Cast() As String
End Type
Operator Type_OrgLogic.let (rhs As LONG )
  ABAS_SetOrgLogic(-1, rhs, rhs, rhs, rhs, rhs, rhs, rhs, rhs)
End Operator
Operator Type_OrgLogic.cast () As ULONG
  Return ABAS_GetOrgLogic()
End Operator
Operator Type_OrgLogic.cast () As String
  Return Str(ABAS_GetOrgLogic())
End Operator

'EzLogic
Type Type_EzLogic
  value As LONG
  Declare Operator Let (rhs As LONG )  
  Declare Operator Cast() As ULONG
  Declare Operator Cast() As String
End Type
Operator Type_EzLogic.let (rhs As LONG )
  ABAS_SetEzLogic(-1, rhs, rhs, rhs, rhs, rhs, rhs, rhs, rhs)
End Operator
Operator Type_EzLogic.cast () As ULONG
  Return ABAS_GetEzLogic()
End Operator
Operator Type_EzLogic.cast () As String
  Return Str(ABAS_GetEzLogic())
End Operator

'BacklashEnable
Type Type_BacklashEnable
  value As LONG
  Declare Operator Let (rhs As LONG )  
  Declare Operator Cast() As ULONG
  Declare Operator Cast() As String
End Type
Operator Type_BacklashEnable.let (rhs As LONG )
  ABAS_SetBacklashEnable(-1, rhs, rhs, rhs, rhs, rhs, rhs, rhs, rhs)
End Operator
Operator Type_BacklashEnable.cast () As ULONG
  Return ABAS_GetBacklashEnable()
End Operator
Operator Type_BacklashEnable.cast () As String
  Return Str(ABAS_GetBacklashEnable())
End Operator

'BacklashPulses
Type Type_BacklashPulses
  value As LONG
  Declare Operator Let (rhs As LONG )  
  Declare Operator Cast() As ULONG
  Declare Operator Cast() As String
End Type
Operator Type_BacklashPulses.let (rhs As LONG )
  ABAS_SetBacklashPulses(-1, rhs, rhs, rhs, rhs, rhs, rhs, rhs, rhs)
End Operator
Operator Type_BacklashPulses.cast () As ULONG
  Return ABAS_GetBacklashPulses()
End Operator
Operator Type_BacklashPulses.cast () As String
  Return Str(ABAS_GetBacklashPulses())
End Operator

'LatchLogic
Type Type_LatchLogic
  value As LONG
  Declare Operator Let (rhs As LONG )  
  Declare Operator Cast() As ULONG
  Declare Operator Cast() As String
End Type
Operator Type_LatchLogic.let (rhs As LONG )
  ABAS_SetLatchLogic(-1, rhs, rhs, rhs, rhs, rhs, rhs, rhs, rhs)
End Operator
Operator Type_LatchLogic.cast () As ULONG
  Return ABAS_GetLatchLogic()
End Operator
Operator Type_LatchLogic.cast () As String
  Return Str(ABAS_GetLatchLogic())
End Operator

'LatchEnable
Type Type_LatchEnable
  value As LONG
  Declare Operator Let (rhs As LONG )  
  Declare Operator Cast() As ULONG
  Declare Operator Cast() As String
End Type
Operator Type_LatchEnable.let (rhs As LONG )
  ABAS_SetLatchEnable(-1, rhs, rhs, rhs, rhs, rhs, rhs, rhs, rhs)
End Operator
Operator Type_LatchEnable.cast () As ULONG
  Return ABAS_GetLatchEnable()
End Operator
Operator Type_LatchEnable.cast () As String
  Return Str(ABAS_GetLatchEnable())
End Operator

'HomeResetEnable
Type Type_HomeResetEnable
  value As LONG
  Declare Operator Let (rhs As LONG )  
  Declare Operator Cast() As ULONG
  Declare Operator Cast() As String
End Type
Operator Type_HomeResetEnable.let (rhs As LONG )
  ABAS_SetHomeResetEnable(-1, rhs, rhs, rhs, rhs, rhs, rhs, rhs, rhs)
End Operator
Operator Type_HomeResetEnable.cast () As ULONG
  Return ABAS_GetHomeResetEnable()
End Operator
Operator Type_HomeResetEnable.cast () As String
  Return Str(ABAS_GetHomeResetEnable())
End Operator

'CmpSrc
Type Type_CmpSrc
  value As LONG
  Declare Operator Let (rhs As LONG )  
  Declare Operator Cast() As ULONG
  Declare Operator Cast() As String
End Type
Operator Type_CmpSrc.let (rhs As LONG )
  ABAS_SetCmpSrc(-1, rhs, rhs, rhs, rhs, rhs, rhs, rhs, rhs)
End Operator
Operator Type_CmpSrc.cast () As ULONG
  Return ABAS_GetCmpSrc()
End Operator
Operator Type_CmpSrc.cast () As String
  Return Str(ABAS_GetCmpSrc())
End Operator

'CmpMethod
Type Type_CmpMethod
  value As LONG
  Declare Operator Let (rhs As LONG )  
  Declare Operator Cast() As ULONG
  Declare Operator Cast() As String
End Type
Operator Type_CmpMethod.let (rhs As LONG )
  ABAS_SetCmpMethod(-1, rhs, rhs, rhs, rhs, rhs, rhs, rhs, rhs)
End Operator
Operator Type_CmpMethod.cast () As ULONG
  Return ABAS_GetCmpMethod()
End Operator
Operator Type_CmpMethod.cast () As String
  Return Str(ABAS_GetCmpMethod())
End Operator

'CmpPulseMode
Type Type_CmpPulseMode
  value As LONG
  Declare Operator Let (rhs As LONG )  
  Declare Operator Cast() As ULONG
  Declare Operator Cast() As String
End Type
Operator Type_CmpPulseMode.let (rhs As LONG )
  ABAS_SetCmpPulseMode(-1, rhs, rhs, rhs, rhs, rhs, rhs, rhs, rhs)
End Operator
Operator Type_CmpPulseMode.cast () As ULONG
  Return ABAS_GetCmpPulseMode()
End Operator
Operator Type_CmpPulseMode.cast () As String
  Return Str(ABAS_GetCmpPulseMode())
End Operator

'CmpPulseLogic
Type Type_CmpPulseLogic
  value As LONG
  Declare Operator Let (rhs As LONG )  
  Declare Operator Cast() As ULONG
  Declare Operator Cast() As String
End Type
Operator Type_CmpPulseLogic.let (rhs As LONG )
  ABAS_SetCmpPulseLogic(-1, rhs, rhs, rhs, rhs, rhs, rhs, rhs, rhs)
End Operator
Operator Type_CmpPulseLogic.cast () As ULONG
  Return ABAS_GetCmpPulseLogic()
End Operator
Operator Type_CmpPulseLogic.cast () As String
  Return Str(ABAS_GetCmpPulseLogic())
End Operator

'CmpPulseWidth
Type Type_CmpPulseWidth
  value As LONG
  Declare Operator Let (rhs As LONG )  
  Declare Operator Cast() As ULONG
  Declare Operator Cast() As String
End Type
Operator Type_CmpPulseWidth.let (rhs As LONG )
  ABAS_SetCmpPulseWidth(-1, rhs, rhs, rhs, rhs, rhs, rhs, rhs, rhs)
End Operator
Operator Type_CmpPulseWidth.cast () As ULONG
  Return ABAS_GetCmpPulseWidth()
End Operator
Operator Type_CmpPulseWidth.cast () As String
  Return Str(ABAS_GetCmpPulseWidth())
End Operator

'CmpEnable
Type Type_CmpEnable
  value As LONG
  Declare Operator Let (rhs As LONG )  
  Declare Operator Cast() As ULONG
  Declare Operator Cast() As String
End Type
Operator Type_CmpEnable.let (rhs As LONG )
  ABAS_SetCmpEnable(-1, rhs, rhs, rhs, rhs, rhs, rhs, rhs, rhs)
End Operator
Operator Type_CmpEnable.cast () As ULONG
  Return ABAS_GetCmpEnable()
End Operator
Operator Type_CmpEnable.cast () As String
  Return Str(ABAS_GetCmpEnable())
End Operator

'GenDoEnable
Type Type_GenDoEnable
  value As LONG
  Declare Operator Let (rhs As LONG )  
  Declare Operator Cast() As ULONG
  Declare Operator Cast() As String
End Type
Operator Type_GenDoEnable.let (rhs As LONG )
  ABAS_SetGenDoEnable(-1, rhs, rhs, rhs, rhs, rhs, rhs, rhs, rhs)
End Operator
Operator Type_GenDoEnable.cast () As ULONG
  Return ABAS_GetGenDoEnable()
End Operator
Operator Type_GenDoEnable.cast () As String
  Return Str(ABAS_GetGenDoEnable())
End Operator

'ExtMasterSrc
Type Type_ExtMasterSrc
  value As LONG
  Declare Operator Let (rhs As LONG )  
  Declare Operator Cast() As ULONG
  Declare Operator Cast() As String
End Type
Operator Type_ExtMasterSrc.let (rhs As LONG )
  ABAS_SetExtMasterSrc(-1, rhs, rhs, rhs, rhs, rhs, rhs, rhs, rhs)
End Operator
Operator Type_ExtMasterSrc.cast () As ULONG
  Return ABAS_GetExtMasterSrc()
End Operator
Operator Type_ExtMasterSrc.cast () As String
  Return Str(ABAS_GetExtMasterSrc())
End Operator

'ExtSelEnable
Type Type_ExtSelEnable
  value As LONG
  Declare Operator Let (rhs As LONG )  
  Declare Operator Cast() As ULONG
  Declare Operator Cast() As String
End Type
Operator Type_ExtSelEnable.let (rhs As LONG )
  ABAS_SetExtSelEnable(-1, rhs, rhs, rhs, rhs, rhs, rhs, rhs, rhs)
End Operator
Operator Type_ExtSelEnable.cast () As ULONG
  Return ABAS_GetExtSelEnable()
End Operator
Operator Type_ExtSelEnable.cast () As String
  Return Str(ABAS_GetExtSelEnable())
End Operator

'ExtPulseNum
Type Type_ExtPulseNum
  value As LONG
  Declare Operator Let (rhs As LONG )  
  Declare Operator Cast() As ULONG
  Declare Operator Cast() As String
End Type
Operator Type_ExtPulseNum.let (rhs As LONG )
  ABAS_SetExtPulseNum(-1, rhs, rhs, rhs, rhs, rhs, rhs, rhs, rhs)
End Operator
Operator Type_ExtPulseNum.cast () As ULONG
  Return ABAS_GetExtPulseNum()
End Operator
Operator Type_ExtPulseNum.cast () As String
  Return Str(ABAS_GetExtPulseNum())
End Operator

'ExtPulseInMode
Type Type_ExtPulseInMode
  value As LONG
  Declare Operator Let (rhs As LONG )  
  Declare Operator Cast() As ULONG
  Declare Operator Cast() As String
End Type
Operator Type_ExtPulseInMode.let (rhs As LONG )
  ABAS_SetExtPulseInMode(-1, rhs, rhs, rhs, rhs, rhs, rhs, rhs, rhs)
End Operator
Operator Type_ExtPulseInMode.cast () As ULONG
  Return ABAS_GetExtPulseInMode()
End Operator
Operator Type_ExtPulseInMode.cast () As String
  Return Str(ABAS_GetExtPulseInMode())
End Operator

'ExtPresetNum
Type Type_ExtPresetNum
  value As LONG
  Declare Operator Let (rhs As LONG )  
  Declare Operator Cast() As ULONG
  Declare Operator Cast() As String
End Type
Operator Type_ExtPresetNum.let (rhs As LONG )
  ABAS_SetExtPresetNum(-1, rhs, rhs, rhs, rhs, rhs, rhs, rhs, rhs)
End Operator
Operator Type_ExtPresetNum.cast () As ULONG
  Return ABAS_GetExtPresetNum()
End Operator
Operator Type_ExtPresetNum.cast () As String
  Return Str(ABAS_GetExtPresetNum())
End Operator

'CamDOEnable
Type Type_CamDOEnable
  value As LONG
  Declare Operator Let (rhs As LONG )  
  Declare Operator Cast() As ULONG
  Declare Operator Cast() As String
End Type
Operator Type_CamDOEnable.let (rhs As LONG )
  ABAS_SetCamDOEnable(-1, rhs, rhs, rhs, rhs, rhs, rhs, rhs, rhs)
End Operator
Operator Type_CamDOEnable.cast () As ULONG
  Return ABAS_GetCamDOEnable()
End Operator
Operator Type_CamDOEnable.cast () As String
  Return Str(ABAS_GetCamDOEnable())
End Operator

'CamDOLoLimit
Type Type_CamDOLoLimit
  value As LONG
  Declare Operator Let (rhs As LONG )  
  Declare Operator Cast() As LONG
  Declare Operator Cast() As String
End Type
Operator Type_CamDOLoLimit.let (rhs As LONG )
  ABAS_SetCamDOLoLimit(-1, rhs, rhs, rhs, rhs, rhs, rhs, rhs, rhs)
End Operator
Operator Type_CamDOLoLimit.cast () As LONG
  Return ABAS_GetCamDOLoLimit()
End Operator
Operator Type_CamDOLoLimit.cast () As String
  Return Str(ABAS_GetCamDOLoLimit())
End Operator

'CamDOHiLimit
Type Type_CamDOHiLimit
  value As LONG
  Declare Operator Let (rhs As LONG )  
  Declare Operator Cast() As LONG
  Declare Operator Cast() As String
End Type
Operator Type_CamDOHiLimit.let (rhs As LONG )
  ABAS_SetCamDOHiLimit(-1, rhs, rhs, rhs, rhs, rhs, rhs, rhs, rhs)
End Operator
Operator Type_CamDOHiLimit.cast () As LONG
  Return ABAS_GetCamDOHiLimit()
End Operator
Operator Type_CamDOHiLimit.cast () As String
  Return Str(ABAS_GetCamDOHiLimit())
End Operator

'CamDOCmpSrc
Type Type_CamDOCmpSrc
  value As LONG
  Declare Operator Let (rhs As LONG )  
  Declare Operator Cast() As ULONG
  Declare Operator Cast() As String
End Type
Operator Type_CamDOCmpSrc.let (rhs As LONG )
  ABAS_SetCamDOCmpSrc(-1, rhs, rhs, rhs, rhs, rhs, rhs, rhs, rhs)
End Operator
Operator Type_CamDOCmpSrc.cast () As ULONG
  Return ABAS_GetCamDOCmpSrc()
End Operator
Operator Type_CamDOCmpSrc.cast () As String
  Return Str(ABAS_GetCamDOCmpSrc())
End Operator

'CamDOLogic
Type Type_CamDOLogic
  value As LONG
  Declare Operator Let (rhs As LONG )  
  Declare Operator Cast() As ULONG
  Declare Operator Cast() As String
End Type
Operator Type_CamDOLogic.let (rhs As LONG )
  ABAS_SetCamDOLogic(-1, rhs, rhs, rhs, rhs, rhs, rhs, rhs, rhs)
End Operator
Operator Type_CamDOLogic.cast () As ULONG
  Return ABAS_GetCamDOLogic()
End Operator
Operator Type_CamDOLogic.cast () As String
  Return Str(ABAS_GetCamDOLogic())
End Operator

'ModuleRange
Type Type_ModuleRange
  value As LONG
  Declare Operator Let (rhs As LONG )  
  Declare Operator Cast() As ULONG
  Declare Operator Cast() As String
End Type
Operator Type_ModuleRange.let (rhs As LONG )
  ABAS_SetModuleRange(-1, rhs, rhs, rhs, rhs, rhs, rhs, rhs, rhs)
End Operator
Operator Type_ModuleRange.cast () As ULONG
  Return ABAS_GetModuleRange()
End Operator
Operator Type_ModuleRange.cast () As String
  Return Str(ABAS_GetModuleRange())
End Operator

'BacklashVel
Type Type_BacklashVel
  value As LONG
  Declare Operator Let (rhs As LONG )  
  Declare Operator Cast() As ULONG
  Declare Operator Cast() As String
End Type
Operator Type_BacklashVel.let (rhs As LONG )
  ABAS_SetBacklashVel(-1, rhs, rhs, rhs, rhs, rhs, rhs, rhs, rhs)
End Operator
Operator Type_BacklashVel.cast () As ULONG
  Return ABAS_GetBacklashVel()
End Operator
Operator Type_BacklashVel.cast () As String
  Return Str(ABAS_GetBacklashVel())
End Operator

'PulseInMaxFreq
Type Type_PulseInMaxFreq
  value As LONG
  Declare Operator Let (rhs As LONG )  
  Declare Operator Cast() As ULONG
  Declare Operator Cast() As String
End Type
Operator Type_PulseInMaxFreq.let ( rhs As LONG )
  ABAS_SetPulseInMaxFreq(-1, rhs, rhs, rhs, rhs, rhs, rhs, rhs, rhs)
End Operator
Operator Type_PulseInMaxFreq.cast () As ULONG
  Return ABAS_GetPulseInMaxFreq()
End Operator
Operator Type_PulseInMaxFreq.cast () As String
  Return Str(ABAS_GetPulseInMaxFreq())
End Operator

'SimStartSource
Type Type_SimStartSource
  value As LONG
  Declare Operator Let (rhs As LONG )  
  Declare Operator Cast() As ULONG
  Declare Operator Cast() As String
End Type
Operator Type_SimStartSource.let ( rhs As LONG )
  ABAS_SetSimStartSource(-1, rhs, rhs, rhs, rhs, rhs, rhs, rhs, rhs)
End Operator
Operator Type_SimStartSource.cast () As ULONG
  Return ABAS_GetSimStartSource()
End Operator
Operator Type_SimStartSource.cast () As String
  Return Str(ABAS_GetSimStartSource())
End Operator


'OrgReact
Type Type_OrgReact
  value As LONG
  Declare Operator Let (rhs As LONG )  
  Declare Operator Cast() As ULONG
  Declare Operator Cast() As String
End Type
Operator Type_OrgReact.let (rhs As LONG )
  ABAS_SetOrgReact(-1, rhs, rhs, rhs, rhs, rhs, rhs, rhs, rhs)
End Operator
Operator Type_OrgReact.cast () As ULONG
  Return ABAS_GetOrgReact()
End Operator
Operator Type_OrgReact.cast () As String
  Return Str(ABAS_GetOrgReact())
End Operator

'IN1StopReact
Type Type_IN1StopReact
  value As LONG
  Declare Operator Let (rhs As LONG )  
  Declare Operator Cast() As ULONG
  Declare Operator Cast() As String
End Type
Operator Type_IN1StopReact.let (rhs As LONG )
  ABAS_SetIN1StopReact(-1, rhs, rhs, rhs, rhs, rhs, rhs, rhs, rhs)
End Operator
Operator Type_IN1StopReact.cast () As ULONG
  Return ABAS_GetIN1StopReact()
End Operator
Operator Type_IN1StopReact.cast () As String
  Return Str(ABAS_GetIN1StopReact())
End Operator

'IN1StopLogic
Type Type_IN1StopLogic
  value As LONG
  Declare Operator Let (rhs As LONG )  
  Declare Operator Cast() As ULONG
  Declare Operator Cast() As String
End Type
Operator Type_IN1StopLogic.let (rhs As LONG )
  ABAS_SetIN1StopLogic(-1, rhs, rhs, rhs, rhs, rhs, rhs, rhs, rhs)
End Operator
Operator Type_IN1StopLogic.cast () As ULONG
  Return ABAS_GetIN1StopLogic()
End Operator
Operator Type_IN1StopLogic.cast () As String
  Return Str(ABAS_GetIN1StopLogic())
End Operator

'IN1StopEnable
Type Type_IN1StopEnable
  value As LONG
  Declare Operator Let (rhs As LONG )  
  Declare Operator Cast() As ULONG
  Declare Operator Cast() As String
End Type
Operator Type_IN1StopEnable.let (rhs As LONG )
  ABAS_SetIN1StopEnable(-1, rhs, rhs, rhs, rhs, rhs, rhs, rhs, rhs)
End Operator
Operator Type_IN1StopEnable.cast () As ULONG
  Return ABAS_GetIN1StopEnable()
End Operator
Operator Type_IN1StopEnable.cast () As String
  Return Str(ABAS_GetIN1StopEnable())
End Operator

'IN1StopEdge
Type Type_IN1StopEdge
  value As LONG
  Declare Operator Let (rhs As LONG )  
  Declare Operator Cast() As ULONG
  Declare Operator Cast() As String
End Type
Operator Type_IN1StopEdge.let (rhs As LONG )
  ABAS_SetIN1StopEdge(-1, rhs, rhs, rhs, rhs, rhs, rhs, rhs, rhs)
End Operator
Operator Type_IN1StopEdge.cast () As ULONG
  Return ABAS_GetIN1StopEdge()
End Operator
Operator Type_IN1StopEdge.cast () As String
  Return Str(ABAS_GetIN1StopEdge())
End Operator

'IN1Offset
Type Type_IN1Offset
  value As DOUBLE
  Declare Operator Let (rhs As DOUBLE )  
  Declare Operator Cast() As DOUBLE
  Declare Operator Cast() As String
End Type
Operator Type_IN1Offset.let (rhs As DOUBLE )
  ABAS_SetIN1Offset(-1, rhs, rhs, rhs, rhs, rhs, rhs, rhs, rhs)
End Operator
Operator Type_IN1Offset.cast () As DOUBLE
  Return ABAS_GetIN1Offset()
End Operator
Operator Type_IN1Offset.cast () As String
  Return Str(ABAS_GetIN1Offset())
End Operator

'IN2StopReact
Type Type_IN2StopReact
  value As LONG
  Declare Operator Let (rhs As LONG )  
  Declare Operator Cast() As ULONG
  Declare Operator Cast() As String
End Type
Operator Type_IN2StopReact.let (rhs As LONG )
  ABAS_SetIN2StopReact(-1, rhs, rhs, rhs, rhs, rhs, rhs, rhs, rhs)
End Operator
Operator Type_IN2StopReact.cast () As ULONG
  Return ABAS_GetIN2StopReact()
End Operator
Operator Type_IN2StopReact.cast () As String
  Return Str(ABAS_GetIN2StopReact())
End Operator

'IN2StopLogic
Type Type_IN2StopLogic
  value As LONG
  Declare Operator Let (rhs As LONG )  
  Declare Operator Cast() As ULONG
  Declare Operator Cast() As String
End Type
Operator Type_IN2StopLogic.let (rhs As LONG )
  ABAS_SetIN2StopLogic(-1, rhs, rhs, rhs, rhs, rhs, rhs, rhs, rhs)
End Operator
Operator Type_IN2StopLogic.cast () As ULONG
  Return ABAS_GetIN2StopLogic()
End Operator
Operator Type_IN2StopLogic.cast () As String
  Return Str(ABAS_GetIN2StopLogic())
End Operator

'IN2StopEnable
Type Type_IN2StopEnable
  value As LONG
  Declare Operator Let (rhs As LONG )  
  Declare Operator Cast() As ULONG
  Declare Operator Cast() As String
End Type
Operator Type_IN2StopEnable.let (rhs As LONG )
  ABAS_SetIN2StopEnable(-1, rhs, rhs, rhs, rhs, rhs, rhs, rhs, rhs)
End Operator
Operator Type_IN2StopEnable.cast () As ULONG
  Return ABAS_GetIN2StopEnable()
End Operator
Operator Type_IN2StopEnable.cast () As String
  Return Str(ABAS_GetIN2StopEnable())
End Operator

'IN2StopEdge
Type Type_IN2StopEdge
  value As LONG
  Declare Operator Let (rhs As LONG )  
  Declare Operator Cast() As ULONG
  Declare Operator Cast() As String
End Type
Operator Type_IN2StopEdge.let (rhs As LONG )
  ABAS_SetIN2StopEdge(-1, rhs, rhs, rhs, rhs, rhs, rhs, rhs, rhs)
End Operator
Operator Type_IN2StopEdge.cast () As ULONG
  Return ABAS_GetIN2StopEdge()
End Operator
Operator Type_IN2StopEdge.cast () As String
  Return Str(ABAS_GetIN2StopEdge())
End Operator

'IN2Offset
Type Type_IN2Offset
  value As DOUBLE
  Declare Operator Let (rhs As DOUBLE )  
  Declare Operator Cast() As DOUBLE
  Declare Operator Cast() As String
End Type
Operator Type_IN2Offset.let (rhs As DOUBLE )
  ABAS_SetIN2Offset(-1, rhs, rhs, rhs, rhs, rhs, rhs, rhs, rhs)
End Operator
Operator Type_IN2Offset.cast () As DOUBLE
  Return ABAS_GetIN2Offset()
End Operator
Operator Type_IN2Offset.cast () As String
  Return Str(ABAS_GetIN2Offset())
End Operator

'IN4StopReact
Type Type_IN4StopReact
  value As LONG
  Declare Operator Let (rhs As LONG )  
  Declare Operator Cast() As ULONG
  Declare Operator Cast() As String
End Type
Operator Type_IN4StopReact.let (rhs As LONG )
  ABAS_SetIN4StopReact(-1, rhs, rhs, rhs, rhs, rhs, rhs, rhs, rhs)
End Operator
Operator Type_IN4StopReact.cast () As ULONG
  Return ABAS_GetIN4StopReact()
End Operator
Operator Type_IN4StopReact.cast () As String
  Return Str(ABAS_GetIN4StopReact())
End Operator

'IN4StopLogic
Type Type_IN4StopLogic
  value As LONG
  Declare Operator Let (rhs As LONG )  
  Declare Operator Cast() As ULONG
  Declare Operator Cast() As String
End Type
Operator Type_IN4StopLogic.let (rhs As LONG )
  ABAS_SetIN4StopLogic(-1, rhs, rhs, rhs, rhs, rhs, rhs, rhs, rhs)
End Operator
Operator Type_IN4StopLogic.cast () As ULONG
  Return ABAS_GetIN4StopLogic()
End Operator
Operator Type_IN4StopLogic.cast () As String
  Return Str(ABAS_GetIN4StopLogic())
End Operator

'IN4StopEnable
Type Type_IN4StopEnable
  value As LONG
  Declare Operator Let (rhs As LONG )  
  Declare Operator Cast() As ULONG
  Declare Operator Cast() As String
End Type
Operator Type_IN4StopEnable.let (rhs As LONG )
  ABAS_SetIN4StopEnable(-1, rhs, rhs, rhs, rhs, rhs, rhs, rhs, rhs)
End Operator
Operator Type_IN4StopEnable.cast () As ULONG
  Return ABAS_GetIN4StopEnable()
End Operator
Operator Type_IN4StopEnable.cast () As String
  Return Str(ABAS_GetIN4StopEnable())
End Operator

'IN4StopEdge
Type Type_IN4StopEdge
  value As LONG
  Declare Operator Let (rhs As LONG )  
  Declare Operator Cast() As ULONG
  Declare Operator Cast() As String
End Type
Operator Type_IN4StopEdge.let (rhs As LONG )
  ABAS_SetIN4StopEdge(-1, rhs, rhs, rhs, rhs, rhs, rhs, rhs, rhs)
End Operator
Operator Type_IN4StopEdge.cast () As ULONG
  Return ABAS_GetIN4StopEdge()
End Operator
Operator Type_IN4StopEdge.cast () As String
  Return Str(ABAS_GetIN4StopEdge())
End Operator

'IN4Offset
Type Type_IN4Offset
  value As DOUBLE
  Declare Operator Let (rhs As DOUBLE )  
  Declare Operator Cast() As DOUBLE
  Declare Operator Cast() As String
End Type
Operator Type_IN4Offset.let (rhs As DOUBLE )
  ABAS_SetIN4Offset(-1, rhs, rhs, rhs, rhs, rhs, rhs, rhs, rhs)
End Operator
Operator Type_IN4Offset.cast () As DOUBLE
  Return ABAS_GetIN4Offset()
End Operator
Operator Type_IN4Offset.cast () As String
  Return Str(ABAS_GetIN4Offset())
End Operator

'IN5StopReact
Type Type_IN5StopReact
  value As LONG
  Declare Operator Let (rhs As LONG )  
  Declare Operator Cast() As ULONG
  Declare Operator Cast() As String
End Type
Operator Type_IN5StopReact.let (rhs As LONG )
  ABAS_SetIN5StopReact(-1, rhs, rhs, rhs, rhs, rhs, rhs, rhs, rhs)
End Operator
Operator Type_IN5StopReact.cast () As ULONG
  Return ABAS_GetIN5StopReact()
End Operator
Operator Type_IN5StopReact.cast () As String
  Return Str(ABAS_GetIN5StopReact())
End Operator

'IN5StopLogic
Type Type_IN5StopLogic
  value As LONG
  Declare Operator Let (rhs As LONG )  
  Declare Operator Cast() As ULONG
  Declare Operator Cast() As String
End Type
Operator Type_IN5StopLogic.let (rhs As LONG )
  ABAS_SetIN5StopLogic(-1, rhs, rhs, rhs, rhs, rhs, rhs, rhs, rhs)
End Operator
Operator Type_IN5StopLogic.cast () As ULONG
  Return ABAS_GetIN5StopLogic()
End Operator
Operator Type_IN5StopLogic.cast () As String
  Return Str(ABAS_GetIN5StopLogic())
End Operator

'IN5StopEnable
Type Type_IN5StopEnable
  value As LONG
  Declare Operator Let (rhs As LONG )  
  Declare Operator Cast() As ULONG
  Declare Operator Cast() As String
End Type
Operator Type_IN5StopEnable.let (rhs As LONG )
  ABAS_SetIN5StopEnable(-1, rhs, rhs, rhs, rhs, rhs, rhs, rhs, rhs)
End Operator
Operator Type_IN5StopEnable.cast () As ULONG
  Return ABAS_GetIN5StopEnable()
End Operator
Operator Type_IN5StopEnable.cast () As String
  Return Str(ABAS_GetIN5StopEnable())
End Operator

'IN5StopEdge
Type Type_IN5StopEdge
  value As LONG
  Declare Operator Let (rhs As LONG )  
  Declare Operator Cast() As ULONG
  Declare Operator Cast() As String
End Type
Operator Type_IN5StopEdge.let (rhs As LONG )
  ABAS_SetIN5StopEdge(-1, rhs, rhs, rhs, rhs, rhs, rhs, rhs, rhs)
End Operator
Operator Type_IN5StopEdge.cast () As ULONG
  Return ABAS_GetIN5StopEdge()
End Operator
Operator Type_IN5StopEdge.cast () As String
  Return Str(ABAS_GetIN5StopEdge())
End Operator

'IN5Offset
Type Type_IN5Offset
  value As DOUBLE
  Declare Operator Let (rhs As DOUBLE )  
  Declare Operator Cast() As DOUBLE
  Declare Operator Cast() As String
End Type
Operator Type_IN5Offset.let (rhs As DOUBLE )
  ABAS_SetIN5Offset(-1, rhs, rhs, rhs, rhs, rhs, rhs, rhs, rhs)
End Operator
Operator Type_IN5Offset.cast () As DOUBLE
  Return ABAS_GetIN5Offset()
End Operator
Operator Type_IN5Offset.cast () As String
  Return Str(ABAS_GetIN5Offset())
End Operator

'LatchBufEnable
Type Type_LatchBufEnable
  value As LONG
  Declare Operator Let (rhs As LONG )  
  Declare Operator Cast() As ULONG
  Declare Operator Cast() As String
End Type
Operator Type_LatchBufEnable.let ( rhs As LONG )
  ABAS_SetLatchBufEnable(-1, rhs, rhs, rhs, rhs, rhs, rhs, rhs, rhs)
End Operator
Operator Type_LatchBufEnable.cast () As ULONG
  Return ABAS_GetLatchBufEnable()
End Operator
Operator Type_LatchBufEnable.cast () As String
  Return Str(ABAS_GetLatchBufEnable())
End Operator

'LatchBufEventNum
Type Type_LatchBufEventNum
  value As LONG
  Declare Operator Let (rhs As LONG )  
  Declare Operator Cast() As ULONG
  Declare Operator Cast() As String
End Type
Operator Type_LatchBufEventNum.let (rhs As LONG )
  ABAS_SetLatchBufEventNum(-1, rhs, rhs, rhs, rhs, rhs, rhs, rhs, rhs)
End Operator
Operator Type_LatchBufEventNum.cast () As ULONG
  Return ABAS_GetLatchBufEventNum()
End Operator
Operator Type_LatchBufEventNum.cast () As String
  Return Str(ABAS_GetLatchBufEventNum())
End Operator

'LatchBufMinDist
Type Type_LatchBufMinDist
  value As LONG
  Declare Operator Let (rhs As LONG )  
  Declare Operator Cast() As ULONG
  Declare Operator Cast() As String
End Type
Operator Type_LatchBufMinDist.let ( rhs As LONG )
  ABAS_SetLatchBufMinDist(-1, rhs, rhs, rhs, rhs, rhs, rhs, rhs, rhs)
End Operator
Operator Type_LatchBufMinDist.cast () As ULONG
  Return ABAS_GetLatchBufMinDist()
End Operator
Operator Type_LatchBufMinDist.cast () As String
  Return Str(ABAS_GetLatchBufMinDist())
End Operator

'LatchBufSource
Type Type_LatchBufSource
  value As LONG
  Declare Operator Let (rhs As LONG )  
  Declare Operator Cast() As ULONG
  Declare Operator Cast() As String
End Type
Operator Type_LatchBufSource.let (rhs As LONG )
  ABAS_SetLatchBufSource(-1, rhs, rhs, rhs, rhs, rhs, rhs, rhs, rhs)
End Operator
Operator Type_LatchBufSource.cast () As ULONG
  Return ABAS_GetLatchBufSource()
End Operator
Operator Type_LatchBufSource.cast () As String
  Return Str(ABAS_GetLatchBufSource())
End Operator

'LatchBufAxisID
Type Type_LatchBufAxisID
  value As LONG
  Declare Operator Let (rhs As LONG )  
  Declare Operator Cast() As ULONG
  Declare Operator Cast() As String
End Type
Operator Type_LatchBufAxisID.let (rhs As LONG )
  ABAS_SetLatchBufAxisID(-1, rhs, rhs, rhs, rhs, rhs, rhs, rhs, rhs)
End Operator
Operator Type_LatchBufAxisID.cast () As ULONG
  Return ABAS_GetLatchBufAxisID()
End Operator
Operator Type_LatchBufAxisID.cast () As String
  Return Str(ABAS_GetLatchBufAxisID())
End Operator

'LatchBufEdge
Type Type_LatchBufEdge
  value As LONG
  Declare Operator Let (rhs As LONG )  
  Declare Operator Cast() As ULONG
  Declare Operator Cast() As String
End Type
Operator Type_LatchBufEdge.let (rhs As LONG )
  ABAS_SetLatchBufEdge(-1, rhs, rhs, rhs, rhs, rhs, rhs, rhs, rhs)
End Operator
Operator Type_LatchBufEdge.cast () As ULONG
  Return ABAS_GetLatchBufEdge()
End Operator
Operator Type_LatchBufEdge.cast () As String
  Return Str(ABAS_GetLatchBufEdge())
End Operator

'HomeOffsetDistance
Type Type_HomeOffsetDistance
  value As double
  Declare Operator Let (rhs As double )  
  Declare Operator Cast() As double
  Declare Operator Cast() As String
End Type
Operator Type_HomeOffsetDistance.let (rhs As double )
  ABAS_SetHomeOffsetDistance(-1, rhs, rhs, rhs, rhs, rhs, rhs, rhs, rhs)
End Operator
Operator Type_HomeOffsetDistance.cast () As double
  Return ABAS_GetHomeOffsetDistance()
End Operator
Operator Type_HomeOffsetDistance.cast () As String
  Return Str(ABAS_GetHomeOffsetDistance())
End Operator

'HomeOffsetVel
Type Type_HomeOffsetVel
  value As double
  Declare Operator Let (rhs As double )  
  Declare Operator Cast() As double
  Declare Operator Cast() As String
End Type
Operator Type_HomeOffsetVel.let (rhs As double )
  ABAS_SetHomeOffsetVel(-1, rhs, rhs, rhs, rhs, rhs, rhs, rhs, rhs)
End Operator
Operator Type_HomeOffsetVel.cast () As double
  Return ABAS_GetHomeOffsetVel()
End Operator
Operator Type_HomeOffsetVel.cast () As String
  Return Str(ABAS_GetHomeOffsetVel())
End Operator

'PPUDenominator
Type Type_PPUDenominator
  value As LONG
  Declare Operator Let (rhs As LONG )  
  Declare Operator Cast() As ULONG
  Declare Operator Cast() As String
End Type
Operator Type_PPUDenominator.let (rhs As LONG )
  ABAS_SetPPUDenominator(-1, rhs, rhs, rhs, rhs, rhs, rhs, rhs, rhs)
End Operator
Operator Type_PPUDenominator.cast () As ULONG
  Return ABAS_GetPPUDenominator()
End Operator
Operator Type_PPUDenominator.cast () As String
  Return Str(ABAS_GetPPUDenominator())
End Operator

'PelToleranceEnable
Type Type_PelToleranceEnable
  value As LONG
  Declare Operator Let (rhs As LONG )  
  Declare Operator Cast() As ULONG
  Declare Operator Cast() As String
End Type
Operator Type_PelToleranceEnable.let (rhs As LONG )
  ABAS_SetPelToleranceEnable(-1, rhs, rhs, rhs, rhs, rhs, rhs, rhs, rhs)
End Operator
Operator Type_PelToleranceEnable.cast () As ULONG
  Return ABAS_GetPelToleranceEnable()
End Operator
Operator Type_PelToleranceEnable.cast () As String
  Return Str(ABAS_GetPelToleranceEnable())
End Operator

'PelToleranceValue
Type Type_PelToleranceValue
  value As LONG
  Declare Operator Let (rhs As LONG )  
  Declare Operator Cast() As ULONG
  Declare Operator Cast() As String
End Type
Operator Type_PelToleranceValue.let (rhs As LONG )
  ABAS_SetPelToleranceValue(-1, rhs, rhs, rhs, rhs, rhs, rhs, rhs, rhs)
End Operator
Operator Type_PelToleranceValue.cast () As ULONG
  Return ABAS_GetPelToleranceValue()
End Operator
Operator Type_PelToleranceValue.cast () As String
  Return Str(ABAS_GetPelToleranceValue())
End Operator

'SwPelToleranceEnable
Type Type_SwPelToleranceEnable
  value As LONG
  Declare Operator Let (rhs As LONG )  
  Declare Operator Cast() As ULONG
  Declare Operator Cast() As String
End Type
Operator Type_SwPelToleranceEnable.let (rhs As LONG )
  ABAS_SetSwPelToleranceEnable(-1, rhs, rhs, rhs, rhs, rhs, rhs, rhs, rhs)
End Operator
Operator Type_SwPelToleranceEnable.cast () As ULONG
  Return ABAS_GetSwPelToleranceEnable()
End Operator
Operator Type_SwPelToleranceEnable.cast () As String
  Return Str(ABAS_GetSwPelToleranceEnable())
End Operator

'SwPelToleranceValue
Type Type_SwPelToleranceValue
  value As LONG
  Declare Operator Let (rhs As LONG )  
  Declare Operator Cast() As ULONG
  Declare Operator Cast() As String
End Type
Operator Type_SwPelToleranceValue.let (rhs As LONG )
  ABAS_SetSwPelToleranceValue(-1, rhs, rhs, rhs, rhs, rhs, rhs, rhs, rhs)
End Operator
Operator Type_SwPelToleranceValue.cast () As ULONG
  Return ABAS_GetSwPelToleranceValue()
End Operator
Operator Type_SwPelToleranceValue.cast () As String
  Return Str(ABAS_GetSwPelToleranceValue())
End Operator

'MelToleranceEnable
Type Type_MelToleranceEnable
  value As LONG
  Declare Operator Let (rhs As LONG )  
  Declare Operator Cast() As ULONG
  Declare Operator Cast() As String
End Type
Operator Type_MelToleranceEnable.let (rhs As LONG )
  ABAS_SetMelToleranceEnable(-1, rhs, rhs, rhs, rhs, rhs, rhs, rhs, rhs)
End Operator
Operator Type_MelToleranceEnable.cast () As ULONG
  Return ABAS_GetMelToleranceEnable()
End Operator
Operator Type_MelToleranceEnable.cast () As String
  Return Str(ABAS_GetMelToleranceEnable())
End Operator

'MelToleranceValue
Type Type_MelToleranceValue
  value As LONG
  Declare Operator Let (rhs As LONG )  
  Declare Operator Cast() As ULONG
  Declare Operator Cast() As String
End Type
Operator Type_MelToleranceValue.let (rhs As LONG )
  ABAS_SetMelToleranceValue(-1, rhs, rhs, rhs, rhs, rhs, rhs, rhs, rhs)
End Operator
Operator Type_MelToleranceValue.cast () As ULONG
  Return ABAS_GetMelToleranceValue()
End Operator
Operator Type_MelToleranceValue.cast () As String
  Return Str(ABAS_GetMelToleranceValue())
End Operator

'SwMelToleranceEnable
Type Type_SwMelToleranceEnable
  value As LONG
  Declare Operator Let (rhs As LONG )  
  Declare Operator Cast() As ULONG
  Declare Operator Cast() As String
End Type
Operator Type_SwMelToleranceEnable.let (rhs As LONG )
  ABAS_SetSwMelToleranceEnable(-1, rhs, rhs, rhs, rhs, rhs, rhs, rhs, rhs)
End Operator
Operator Type_SwMelToleranceEnable.cast () As ULONG
  Return ABAS_GetSwMelToleranceEnable()
End Operator
Operator Type_SwMelToleranceEnable.cast () As String
  Return Str(ABAS_GetSwMelToleranceEnable())
End Operator

'SwMelToleranceValue
Type Type_SwMelToleranceValue
  value As LONG
  Declare Operator Let (rhs As LONG )  
  Declare Operator Cast() As ULONG
  Declare Operator Cast() As String
End Type
Operator Type_SwMelToleranceValue.let (rhs As LONG )
  ABAS_SetSwMelToleranceValue(-1, rhs, rhs, rhs, rhs, rhs, rhs, rhs, rhs)
End Operator
Operator Type_SwMelToleranceValue.cast () As ULONG
  Return ABAS_GetSwMelToleranceValue()
End Operator
Operator Type_SwMelToleranceValue.cast () As String
  Return Str(ABAS_GetSwMelToleranceValue())
End Operator

'CmpPulseWidthEx
Type Type_CmpPulseWidthEx
  value As LONG
  Declare Operator Let (rhs As LONG )  
  Declare Operator Cast() As ULONG
  Declare Operator Cast() As String
End Type
Operator Type_CmpPulseWidthEx.let (rhs As LONG )
  ABAS_SetCmpPulseWidthEx(-1, rhs, rhs, rhs, rhs, rhs, rhs, rhs, rhs)
End Operator
Operator Type_CmpPulseWidthEx.cast () As ULONG
  Return ABAS_GetCmpPulseWidthEx()
End Operator
Operator Type_CmpPulseWidthEx.cast () As String
  Return Str(ABAS_GetCmpPulseWidthEx())
End Operator

'ALMFilterTime
Type Type_ALMFilterTime
  value As LONG
  Declare Operator Let (rhs As LONG )  
  Declare Operator Cast() As ULONG
  Declare Operator Cast() As String
End Type
Operator Type_ALMFilterTime.let (rhs As LONG )
  ABAS_SetALMFilterTime(-1, rhs, rhs, rhs, rhs, rhs, rhs, rhs, rhs)
End Operator
Operator Type_ALMFilterTime.cast () As ULONG
  Return ABAS_GetALMFilterTime()
End Operator
Operator Type_ALMFilterTime.cast () As String
  Return Str(ABAS_GetALMFilterTime())
End Operator

'LMTPFilterTime
Type Type_LMTPFilterTime
  value As LONG
  Declare Operator Let (rhs As LONG )  
  Declare Operator Cast() As ULONG
  Declare Operator Cast() As String
End Type
Operator Type_LMTPFilterTime.let (rhs As LONG )
  ABAS_SetLMTPFilterTime(-1, rhs, rhs, rhs, rhs, rhs, rhs, rhs, rhs)
End Operator
Operator Type_LMTPFilterTime.cast () As ULONG
  Return ABAS_GetLMTPFilterTime()
End Operator
Operator Type_LMTPFilterTime.cast () As String
  Return Str(ABAS_GetLMTPFilterTime())
End Operator

'LMTNFilterTime
Type Type_LMTNFilterTime
  value As LONG
  Declare Operator Let (rhs As LONG )  
  Declare Operator Cast() As ULONG
  Declare Operator Cast() As String
End Type
Operator Type_LMTNFilterTime.let (rhs As LONG )
  ABAS_SetLMTNFilterTime(-1, rhs, rhs, rhs, rhs, rhs, rhs, rhs, rhs)
End Operator
Operator Type_LMTNFilterTime.cast () As ULONG
  Return ABAS_GetLMTNFilterTime()
End Operator
Operator Type_LMTNFilterTime.cast () As String
  Return Str(ABAS_GetLMTNFilterTime())
End Operator

'ORGFilterTime
Type Type_ORGFilterTime
  value As LONG
  Declare Operator Let (rhs As LONG )  
  Declare Operator Cast() As ULONG
  Declare Operator Cast() As String
End Type
Operator Type_ORGFilterTime.let (rhs As LONG )
  ABAS_SetORGFilterTime(-1, rhs, rhs, rhs, rhs, rhs, rhs, rhs, rhs)
End Operator
Operator Type_ORGFilterTime.cast () As ULONG
  Return ABAS_GetORGFilterTime()
End Operator
Operator Type_ORGFilterTime.cast () As String
  Return Str(ABAS_GetORGFilterTime())
End Operator

'IN1FilterTime
Type Type_IN1FilterTime
  value As LONG
  Declare Operator Let (rhs As LONG )  
  Declare Operator Cast() As ULONG
  Declare Operator Cast() As String
End Type
Operator Type_IN1FilterTime.let (rhs As LONG )
  ABAS_SetIN1FilterTime(-1, rhs, rhs, rhs, rhs, rhs, rhs, rhs, rhs)
End Operator
Operator Type_IN1FilterTime.cast () As ULONG
  Return ABAS_GetIN1FilterTime()
End Operator
Operator Type_IN1FilterTime.cast () As String
  Return Str(ABAS_GetIN1FilterTime())
End Operator

'IN2FilterTime
Type Type_IN2FilterTime
  value As LONG
  Declare Operator Let (rhs As LONG )  
  Declare Operator Cast() As ULONG
  Declare Operator Cast() As String
End Type
Operator Type_IN2FilterTime.let (rhs As LONG )
  ABAS_SetIN2FilterTime(-1, rhs, rhs, rhs, rhs, rhs, rhs, rhs, rhs)
End Operator
Operator Type_IN2FilterTime.cast () As ULONG
  Return ABAS_GetIN2FilterTime()
End Operator
Operator Type_IN2FilterTime.cast () As String
  Return Str(ABAS_GetIN2FilterTime())
End Operator

'IN4FilterTime
Type Type_IN4FilterTime
  value As LONG
  Declare Operator Let (rhs As LONG )  
  Declare Operator Cast() As ULONG
  Declare Operator Cast() As String
End Type
Operator Type_IN4FilterTime.let (rhs As LONG )
  ABAS_SetIN4FilterTime(-1, rhs, rhs, rhs, rhs, rhs, rhs, rhs, rhs)
End Operator
Operator Type_IN4FilterTime.cast () As ULONG
  Return ABAS_GetIN4FilterTime()
End Operator
Operator Type_IN4FilterTime.cast () As String
  Return Str(ABAS_GetIN4FilterTime())
End Operator

'IN5FilterTime
Type Type_IN5FilterTime
  value As LONG
  Declare Operator Let (rhs As LONG )  
  Declare Operator Cast() As ULONG
  Declare Operator Cast() As String
End Type
Operator Type_IN5FilterTime.let (rhs As LONG )
  ABAS_SetIN5FilterTime(-1, rhs, rhs, rhs, rhs, rhs, rhs, rhs, rhs)
End Operator
Operator Type_IN5FilterTime.cast () As ULONG
  Return ABAS_GetIN5FilterTime()
End Operator
Operator Type_IN5FilterTime.cast () As String
  Return Str(ABAS_GetIN5FilterTime())
End Operator

'PulseOutReverse
Type Type_PulseOutReverse
  value As LONG
  Declare Operator Let (rhs As LONG )  
  Declare Operator Cast() As ULONG
  Declare Operator Cast() As String
End Type
Operator Type_PulseOutReverse.let (rhs As LONG )
  ABAS_SetPulseOutReverse(-1, rhs, rhs, rhs, rhs, rhs, rhs, rhs, rhs)
End Operator
Operator Type_PulseOutReverse.cast () As ULONG
  Return ABAS_GetPulseOutReverse()
End Operator
Operator Type_PulseOutReverse.cast () As String
  Return Str(ABAS_GetPulseOutReverse())
End Operator

'KillDec
Type Type_KillDec
  value As LONG
  Declare Operator Let (rhs As DOUBLE )  
  Declare Operator Cast() As DOUBLE
  Declare Operator Cast() As String
End Type
Operator Type_KillDec.let (rhs As DOUBLE )
  ABAS_SetKillDec(-1, rhs, rhs, rhs, rhs, rhs, rhs, rhs, rhs)
End Operator
Operator Type_KillDec.cast () As DOUBLE
  Return ABAS_GetKillDec()
End Operator
Operator Type_KillDec.cast () As String
  Return Str(ABAS_GetKillDec())
End Operator

'MaxErrorCnt
Type Type_MaxErrorCnt
  value As LONG
  Declare Operator Let (rhs As LONG )  
  Declare Operator Cast() As ULONG
  Declare Operator Cast() As String
End Type
Operator Type_MaxErrorCnt.let (rhs As LONG )
  ABAS_SetMaxErrorCnt(-1, rhs, rhs, rhs, rhs, rhs, rhs, rhs, rhs)
End Operator
Operator Type_MaxErrorCnt.cast () As ULONG
  Return ABAS_GetMaxErrorCnt()
End Operator
Operator Type_MaxErrorCnt.cast () As String
  Return Str(ABAS_GetMaxErrorCnt())
End Operator

'JogVLTime
Type Type_JogVLTime
  value As LONG
  Declare Operator Let (rhs As LONG )  
  Declare Operator Cast() As ULONG
  Declare Operator Cast() As String
End Type
Operator Type_JogVLTime.let (rhs As LONG )
  ABAS_SetJogVLTime(-1, rhs, rhs, rhs, rhs, rhs, rhs, rhs, rhs)
End Operator
Operator Type_JogVLTime.cast () As ULONG
  Return ABAS_GetJogVLTime()
End Operator
Operator Type_JogVLTime.cast () As String
  Return Str(ABAS_GetJogVLTime())
End Operator

'JogVelLow
Type Type_JogVelLow
  value As LONG
  Declare Operator Let (rhs As DOUBLE )  
  Declare Operator Cast() As DOUBLE
  Declare Operator Cast() As String
End Type
Operator Type_JogVelLow.let (rhs As DOUBLE )
  ABAS_SetJogVelLow(-1, rhs, rhs, rhs, rhs, rhs, rhs, rhs, rhs)
End Operator
Operator Type_JogVelLow.cast () As DOUBLE
  Return ABAS_GetJogVelLow()
End Operator
Operator Type_JogVelLow.cast () As String
  Return Str(ABAS_GetJogVelLow())
End Operator

'JogVelHigh
Type Type_JogVelHigh
  value As LONG
  Declare Operator Let (rhs As DOUBLE )  
  Declare Operator Cast() As DOUBLE
  Declare Operator Cast() As String
End Type
Operator Type_JogVelHigh.let (rhs As DOUBLE )
  ABAS_SetJogVelHigh(-1, rhs, rhs, rhs, rhs, rhs, rhs, rhs, rhs)
End Operator
Operator Type_JogVelHigh.cast () As DOUBLE
  Return ABAS_GetJogVelHigh()
End Operator
Operator Type_JogVelHigh.cast () As String
  Return Str(ABAS_GetJogVelHigh())
End Operator

'JogAcc
Type Type_JogAcc
  value As LONG
  Declare Operator Let (rhs As DOUBLE )  
  Declare Operator Cast() As DOUBLE
  Declare Operator Cast() As String
End Type
Operator Type_JogAcc.let (rhs As DOUBLE )
  ABAS_SetJogAcc(-1, rhs, rhs, rhs, rhs, rhs, rhs, rhs, rhs)
End Operator
Operator Type_JogAcc.cast () As DOUBLE
  Return ABAS_GetJogAcc()
End Operator
Operator Type_JogAcc.cast () As String
  Return Str(ABAS_GetJogAcc())
End Operator

'JogDec
Type Type_JogDec
  value As LONG
  Declare Operator Let (rhs As DOUBLE )  
  Declare Operator Cast() As DOUBLE
  Declare Operator Cast() As String
End Type
Operator Type_JogDec.let (rhs As DOUBLE )
  ABAS_SetJogDec(-1, rhs, rhs, rhs, rhs, rhs, rhs, rhs, rhs)
End Operator
Operator Type_JogDec.cast () As DOUBLE
  Return ABAS_GetJogDec()
End Operator
Operator Type_JogDec.cast () As String
  Return Str(ABAS_GetJogDec())
End Operator

'JogJerk
Type Type_JogJerk
  value As Double
  Declare Operator Let (rhs As Double )  
  Declare Operator Cast() As double
  Declare Operator Cast() As String
End Type
Operator Type_JogJerk.let (rhs As Double )
  value = rhs 
  ABAS_SetJogJerk(-1, value, value, value, value, value, value, value, value)
End Operator
Operator Type_JogJerk.cast () As double
	Return ABAS_GetJogJerk()
End Operator
Operator Type_JogJerk.cast () As String
  Return Str(ABAS_GetJogJerk())
End Operator

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'ACC
Type Type_ACC
  value As Double
  Declare Operator Let (rhs As Double )  
  Declare Operator Cast() As double
  Declare Operator Cast() As String
End Type
Operator Type_ACC.let (rhs As Double)
  value= rhs
  ABAS_SetACC(-1, value, value, value, value, value, value, value, value)		
End Operator
Operator Type_ACC.cast () As double
	Return ABAS_GetACC()
End Operator
Operator Type_ACC.cast () As String
  Return Str(ABAS_GetACC())
End Operator

'DEC
Type Type_DEC
  value As Double
  Declare Operator Let (rhs As Double )  
  Declare Operator Cast() As double
  Declare Operator Cast() As String
End Type
Operator Type_DEC.let (rhs As Double )
  value = rhs 
  ABAS_SetDEC(-1, value, value, value, value, value, value, value, value)
End Operator
Operator Type_DEC.cast () As double
	Return ABAS_GetDEC()
End Operator
Operator Type_DEC.cast () As String
  Return Str(ABAS_GetDEC())
End Operator

'VL
Type Type_VL
  value As Double
  Declare Operator Let (rhs As Double )  
  Declare Operator Cast() As double
  Declare Operator Cast() As String
End Type
Operator Type_VL.let (rhs As Double )
  value = rhs 
  ABAS_SetVL(-1, value, value, value, value, value, value, value, value)
End Operator
Operator Type_VL.cast () As double
	Return ABAS_GetVL()
End Operator
Operator Type_VL.cast () As String
  Return Str(ABAS_GetVL())
End Operator

'VH
Type Type_VH
  value As Double
  Declare Operator Let (rhs As Double )  
  Declare Operator Cast() As double
  Declare Operator Cast() As String
End Type
Operator Type_VH.let (rhs As Double )
  value = rhs 
  ABAS_SetVH(-1, value, value, value, value, value, value, value, value)
End Operator
Operator Type_VH.cast () As double
	Return ABAS_GetVH()
End Operator
Operator Type_VH.cast () As String
  Return Str(ABAS_GetVH())
End Operator

'JERK
Type Type_JERK
  value As Double
  'Declare Operator Let (rhs As Integer ) 
  Declare Operator Let (rhs As double )		'yf 2016.12.23  
  Declare Operator Cast() As double
  Declare Operator Cast() As String
End Type
Operator Type_JERK.let (rhs As double)
  value = rhs 
  ABAS_SetJK(-1, value, value, value, value, value, value, value, value)
End Operator
Operator Type_JERK.cast () As double
	Return ABAS_GetJK()
End Operator
Operator Type_JERK.cast () As String
  Return Str(ABAS_GetJK())
End Operator

'HOME_MODE
Type Type_HOMEMODE
  value As Integer
  Declare Operator Let (rhs As Integer )  
  Declare Operator Cast() As UShort
  Declare Operator Cast() As String
End Type
Operator Type_HOMEMODE.let (rhs As Integer )
  value = rhs 
  ABAS_SetHomeMode(-1, value, value, value, value, value, value, value, value)
End Operator
Operator Type_HOMEMODE.cast () As UShort
	Return ABAS_GetHomeMode()
End Operator
Operator Type_HOMEMODE.cast () As String
  Return Str(ABAS_GetHomeMode())
End Operator

'DPOS
Type Type_DPOS
  value As Double
  Declare Operator Let (rhs As Double )  
  Declare Operator Cast() As double
  Declare Operator Cast() As String
End Type
Operator Type_DPOS.let (rhs As Double )
  value = rhs 
  ABAS_SetDPOS(-1, value, value, value, value, value, value, value, value)
End Operator
Operator Type_DPOS.cast () As double
	Return ABAS_GetDPOS()
End Operator
Operator Type_DPOS.cast () As String
  Return Str(ABAS_GetDPOS())
End Operator

'MPOS
Type Type_MPOS
  value As Double
  Declare Operator Let (rhs As Double )  
  Declare Operator Cast() As double
  Declare Operator Cast() As String
End Type
Operator Type_MPOS.let (rhs As Double )
  value = rhs 
  ABAS_SetMPOS(-1, value, value, value, value, value, value, value, value)
End Operator
Operator Type_MPOS.cast () As double
	Return ABAS_GetMPOS()
End Operator
Operator Type_MPOS.cast () As String
  Return Str(ABAS_GetMPOS())
End Operator  

'Home_VL
Type Type_HOME_VL
  value As Double
  Declare Operator Let (rhs As Double )  
  Declare Operator Cast() As double
  Declare Operator Cast() As String
End Type
Operator Type_HOME_VL.let (rhs As Double )
  value = rhs 
  ABAS_SetHomeVL(-1, value, value, value, value, value, value, value, value)
End Operator
Operator Type_HOME_VL.cast () As double
	Return ABAS_GetHomeVL
End Operator
Operator Type_HOME_VL.cast () As String
  Return Str(ABAS_GetHomeVL())
End Operator 

'Home_VH
Type Type_HOME_VH
  value As Double
  Declare Operator Let ( rhs As Double )  
  Declare Operator Cast() As double
  Declare Operator Cast() As String
End Type
Operator Type_HOME_VH.let ( rhs As Double )
  value = rhs 
  ABAS_SetHomeVH(-1, value, value, value, value, value, value, value, value)
End Operator
Operator Type_HOME_VH.cast () As double
	Return ABAS_GetHomeVH
End Operator
Operator Type_HOME_VH.cast () As String
  Return Str(ABAS_GetHomeVH())
End Operator 

'Home_ACC
Type Type_HOME_ACC
  value As Double
  Declare Operator Let (rhs As Double )  
  Declare Operator Cast() As double
  Declare Operator Cast() As String
End Type
Operator Type_HOME_ACC.let (rhs As Double )
  value = rhs 
  ABAS_SetHomeACC(-1, value, value, value, value, value, value, value, value)
End Operator
Operator Type_HOME_ACC.cast () As double
	Return ABAS_GetHomeACC
End Operator
Operator Type_HOME_ACC.cast () As String
  Return Str(ABAS_GetHomeACC())
End Operator 

'Home_DEC
Type Type_HOME_DEC
  value As Double
  Declare Operator Let (rhs As Double )  
  Declare Operator Cast() As double
  Declare Operator Cast() As String
End Type
Operator Type_HOME_DEC.let (rhs As Double )
  value = rhs 
  ABAS_SetHomeDEC(-1, value, value, value, value, value, value, value, value)
End Operator
Operator Type_HOME_DEC.cast () As double
	Return ABAS_GetHomeDEC
End Operator
Operator Type_HOME_DEC.cast () As String
  Return Str(ABAS_GetHomeDEC())
End Operator  

'Home_JK
Type Type_HOME_JK
  value As Double
  Declare Operator Let (rhs As Double )  
  Declare Operator Cast() As double
  Declare Operator Cast() As String
End Type
Operator Type_HOME_JK.let (rhs As Double )
  value = rhs 
  ABAS_SetHomeJK(-1, value, value, value, value, value, value, value, value)
End Operator
Operator Type_HOME_JK.cast () As double
	Return ABAS_GetHomeJK
End Operator
Operator Type_HOME_JK.cast () As String
  Return Str(ABAS_GetHomeJK())
End Operator 

'Home_CROSS
Type Type_HOME_CROSS
  value As Double
  Declare Operator Let (rhs As Double )  
  Declare Operator Cast() As double
  Declare Operator Cast() As String
End Type
Operator Type_HOME_CROSS.let (rhs As Double )
  value = rhs 
  ABAS_SetHomeCross(-1, value, value, value, value, value, value, value, value)
End Operator
Operator Type_HOME_CROSS.cast () As double
	Return ABAS_GetHomeCross
End Operator
Operator Type_HOME_CROSS.cast () As String
  Return Str(ABAS_GetHomeCross())
End Operator  


'PATH_DELAY
Type Type_PATH_DELAY
  'value As Ulong
  value As long						'2017.02.16 ulong to long
  Declare Operator Let (rhs As long )  
End Type
Operator Type_PATH_DELAY.let (rhs As long )
  value = rhs 
  ABAS_PATHDelay(rhs)
End Operator

'yf,2016.06.16
'GVL
Type Type_GVL
  value As Double
  Declare Operator Let (rhs As Double )  
  Declare Operator Cast() As double
  Declare Operator Cast() As String
End Type
Operator Type_GVL.let (rhs As Double )
  value = rhs 
  SetGroupStartSpeed(-1, value)
End Operator
Operator Type_GVL.cast () As double
	Return GetGroupStartSpeed()
End Operator
Operator Type_GVL.cast () As String
  Return Str(GetGroupStartSpeed())
End Operator 

'GVH
Type Type_GVH
  value As Double
  Declare Operator Let (rhs As Double )  
  Declare Operator Cast() As double
  Declare Operator Cast() As String
End Type
Operator Type_GVH.let (rhs As Double )
  value = rhs 
  SetGroupSpeed(-1, value)
End Operator
Operator Type_GVH.cast () As double
	Return GetGroupSpeed()
End Operator
Operator Type_GVH.cast () As String
  Return Str(GetGroupSpeed())
End Operator 

'GACC
Type Type_GACC
  value As Double
  Declare Operator Let ( rhs As Double )  
  Declare Operator Cast() As double
  Declare Operator Cast() As String
End Type
Operator Type_GACC.let (rhs As Double )
  value = rhs 
  SetGroupAcc(-1, value)
End Operator
Operator Type_GACC.cast () As double
	Return GetGroupAcc()
End Operator
Operator Type_GACC.cast () As String
  Return Str(GetGroupAcc())
End Operator 

'GDEC
Type Type_GDEC
  value As Double
  Declare Operator Let (rhs As Double )  
  Declare Operator Cast() As double
  Declare Operator Cast() As String
End Type
Operator Type_GDEC.let (rhs As Double )
  value = rhs 
  SetGroupDec(-1, value)
End Operator
Operator Type_GDEC.cast () As double
	Return GetGroupDec()
End Operator
Operator Type_GDEC.cast () As String
  Return Str(GetGroupDec())
End Operator 

'GDEC
Type Type_GJK
  value As Double
  Declare Operator Let (rhs As Double )  
  Declare Operator Cast() As double
  Declare Operator Cast() As String
End Type
Operator Type_GJK.let (rhs As Double )
  value = rhs 
  SetGroupJerk(-1, value)
End Operator
Operator Type_GJK.cast () As double
	Return GetGroupJerk()
End Operator
Operator Type_GJK.cast () As String
  Return Str(GetGroupJerk())
End Operator
 
'GDSPEED
Type Type_GDSPEED
	value As Double = 0.0
  Declare Operator Cast() As Double
  Declare Operator Cast() As String
End Type
Operator Type_GDSPEED.cast () As Double
	Return GetGroupCurrentSpeed
End Operator
Operator Type_GDSPEED.cast () As String
  Return Str(GetGroupCurrentSpeed)
End Operator
 
'GSTATE
Type Type_GSTATE
	value As UShort = 0
  Declare Operator Cast() As UShort
  Declare Operator Cast() As String
End Type
Operator Type_GSTATE.cast () As UShort
	Return GetGroupState()
End Operator
Operator Type_GSTATE.cast () As String
  Return Str(GetGroupState())
End Operator

'DSPEED
Type Type_DSPEED
	value As Double = 0.0
  Declare Operator Cast() As double
  Declare Operator Cast() As String
End Type
Operator Type_DSPEED.cast () As double
	Return ABAS_GetSPEED()
End Operator
Operator Type_DSPEED.cast () As String
  Return Str(ABAS_GetSPEED())
End Operator

Type Type_GpSpdFwd
  value As LONG
  Declare Operator Let (rhs As LONG )  
  Declare Operator Cast() As ULONG
  Declare Operator Cast() As String
End Type
Operator Type_GpSpdFwd.let (rhs As LONG )
  ABAS_GpSetSpdFwd(rhs)
End Operator
Operator Type_GpSpdFwd.cast () As ULONG
  Return ABAS_GpGetSpdFwd()
End Operator
Operator Type_GpSpdFwd.cast () As String
  Return Str(ABAS_GpGetSpdFwd())
End Operator


'MIO
Type Type_MIO
  value As Ulong
  Declare Property RDY () As UShort 
  Declare Property ALM () As UShort
  Declare Property PEL () As UShort		'yangfei,2016.06.03
  Declare Property NEL () As UShort
  Declare Property ORG () As UShort
  Declare Property DIR () As UShort
  Declare Property EMG () As UShort
  Declare Property PCS () As UShort
  Declare Property ERC () As UShort
  Declare Property EZ () As UShort
  Declare Property CLR () As UShort
  Declare Property LTC () As UShort
  Declare Property SD () As UShort
  Declare Property INP () As UShort
  Declare Property SVON () As UShort
  Declare Property ALRM () As UShort
  Declare Property SPEL () As UShort
  Declare Property SNEL () As UShort
  Declare Property CMP () As UShort
  Declare Property CAMDO () As UShort
  Declare Operator Cast() As ulong		'yf,2017.05.08
  Declare Operator Cast() As String
End Type
Property Type_MIO.RDY () As UShort 
  value = ABAS_GetMIO(-1)
  value Shr= 0
  return value and 1
End Property
Property Type_MIO.ALM () As UShort 
  value = ABAS_GetMIO(-1)
  value Shr= 1
  return value and 1
End Property
Property Type_MIO.PEL () As UShort 
  value = ABAS_GetMIO(-1)
  value Shr= 2
  return value and 1
End Property
Property Type_MIO.NEL () As UShort 
  value = ABAS_GetMIO(-1)
  value Shr= 3
  return value and 1
End Property
Property Type_MIO.ORG () As UShort 
  value = ABAS_GetMIO(-1)
  value Shr= 4
  return value and 1
End Property
Property Type_MIO.DIR () As UShort 
  value = ABAS_GetMIO(-1)
  value Shr= 5
  return value and 1
End Property
Property Type_MIO.EMG () As UShort 
  value = ABAS_GetMIO(-1)
  value Shr= 6
  return value and 1
End Property
Property Type_MIO.PCS () As UShort 
  value = ABAS_GetMIO(-1)
  value Shr= 7
  return value and 1
End Property
Property Type_MIO.ERC () As UShort 
  value = ABAS_GetMIO(-1)
  value Shr= 8
  return value and 1
End Property
Property Type_MIO.EZ () As UShort 
  value = ABAS_GetMIO(-1)
  value Shr= 9
  return value and 1
End Property
Property Type_MIO.CLR () As UShort 
  value = ABAS_GetMIO(-1)
  value Shr= 10
  return value and 1
End Property
Property Type_MIO.LTC () As UShort 
  value = ABAS_GetMIO(-1)
  value Shr= 11
  return value and 1
End Property
Property Type_MIO.SD () As UShort 
  value = ABAS_GetMIO(-1)
  value Shr= 12
  return value and 1
End Property
Property Type_MIO.INP () As UShort 
  value = ABAS_GetMIO(-1)
  value Shr= 13
  return value and 1
End Property
Property Type_MIO.SVON () As UShort 
  value = ABAS_GetMIO(-1)
  value Shr= 14
  return value and 1
End Property
Property Type_MIO.ALRM () As UShort 
  value = ABAS_GetMIO(-1)
  value Shr= 15
  return value and 1
End Property
Property Type_MIO.SPEL () As UShort 
  value = ABAS_GetMIO(-1)
  value Shr= 16
  return value and 1
End Property
Property Type_MIO.SNEL () As UShort 
  value = ABAS_GetMIO(-1)
  value Shr= 17
  return value and 1
End Property
Property Type_MIO.CMP () As UShort 
  value = ABAS_GetMIO(-1)
  value Shr= 18
  return value and 1
End Property
Property Type_MIO.CAMDO () As UShort 
  value = ABAS_GetMIO(-1)
  value Shr= 19
  return value and 1
End Property
Operator Type_MIO.cast () As ulong
	Return ABAS_GetMIO(-1)
End Operator
Operator Type_MIO.cast () As String
  Return Str(ABAS_GetMIO(-1))
End Operator

Type Type_MCMP_EN
	value As ULONG = 0.0
	Declare Operator Let (rhs As ULONG )  
  Declare Operator Cast() As ULONG
  Declare Operator Cast() As String
End Type
Operator Type_MCMP_EN.let (rhs As ulong )
  value = rhs 
	BAS_MCMP_AXEnabel(value)
End Operator
Operator Type_MCMP_EN.cast () As Ulong
	Return BAS_Get_MCMP_AXEnabel()
End Operator
Operator Type_MCMP_EN.cast () As String
  Return Str(BAS_Get_MCMP_AXEnabel())
End Operator

Type Type_MCMP_CH
	value As Ulong = 0.0
	Declare Operator Let (rhs As ULONG ) 
  Declare Operator Cast() As Ulong
  Declare Operator Cast() As String
End Type
Operator Type_MCMP_CH.let (rhs As ulong )
  value = rhs 
	BAS_MCMP_ChannelEN(value)
End Operator
Operator Type_MCMP_CH.cast () As Ulong
	Return BAS_Get_MCMP_ChannelEN()
End Operator
Operator Type_MCMP_CH.cast () As String
  Return Str(BAS_Get_MCMP_ChannelEN())
End Operator

Type Type_MCMP_LOGIC
	value As Ulong = 0.0
	Declare Operator Let (rhs As ULONG )
  Declare Operator Cast() As Ulong
  Declare Operator Cast() As String
End Type
Operator Type_MCMP_LOGIC.let (rhs As ulong )
  value = rhs 
	BAS_MCMP_Logic(value)
End Operator
Operator Type_MCMP_LOGIC.cast () As Ulong
	Return BAS_Get_MCMP_Logic()
End Operator
Operator Type_MCMP_LOGIC.cast () As String
  Return Str(BAS_Get_MCMP_Logic())
End Operator

Type Type_MCMP_WIDTH
	value As Ulong = 0.0
	Declare Operator Let (rhs As ULONG )
  Declare Operator Cast() As Ulong
  Declare Operator Cast() As String
End Type
Operator Type_MCMP_WIDTH.let (rhs As ulong )
  value = rhs 
	BAS_MCMP_PWidth(value)
End Operator
Operator Type_MCMP_WIDTH.cast () As Ulong
	Return BAS_Get_MCMP_PWidth()
End Operator
Operator Type_MCMP_WIDTH.cast () As String
  Return Str(BAS_Get_MCMP_PWidth())
End Operator

Type Type_MCMP_DEVIA
	value As Ulong = 0.0
	Declare Operator Let (rhs As ULONG )
  Declare Operator Cast() As Ulong
  Declare Operator Cast() As String
End Type
Operator Type_MCMP_DEVIA.let (rhs As ulong )
  value = rhs 
	BAS_MCP_DEVA(-1, value, value, value, value, value, value, value, value)			'yf,2017.05.31
End Operator
Operator Type_MCMP_DEVIA.cast () As Ulong
	Return BAS_GetMCP_DEVA(-1)
End Operator
Operator Type_MCMP_DEVIA.cast () As String
  Return Str(BAS_GetMCP_DEVA(-1))
End Operator

Type Type_MCMP_MODE
	value As Ulong = 0.0
	Declare Operator Let (rhs As ULONG )
  Declare Operator Cast() As Ulong
  Declare Operator Cast() As String
End Type
Operator Type_MCMP_MODE.let (rhs As ulong )
  value = rhs 
	BAS_MCMP_Mode(value)
End Operator
Operator Type_MCMP_MODE.cast () As Ulong
	Return BAS_Get_MCMP_Mode()
End Operator
Operator Type_MCMP_MODE.cast () As String
  Return Str(BAS_Get_MCMP_Mode())
End Operator

Type Type_MCMP_EMPTY
	value As Ulong = 0.0
	Declare Operator Let (rhs As ULONG )
  Declare Operator Cast() As Ulong
  Declare Operator Cast() As String
End Type
Operator Type_MCMP_EMPTY.let (rhs As ulong )
  value = rhs 
	BAS_MCMP_AutoEmpty(value)
End Operator
Operator Type_MCMP_EMPTY.cast () As Ulong
	Return BAS_Get_MCMP_AutoEmpty()
End Operator
Operator Type_MCMP_EMPTY.cast () As String
  Return Str(BAS_Get_MCMP_AutoEmpty())
End Operator

Type Type_MCMP_PWMFREQ
	value As Ulong = 0.0
	Declare Operator Let (rhs As ULONG )
  Declare Operator Cast() As Ulong
  Declare Operator Cast() As String
End Type
Operator Type_MCMP_PWMFREQ.let (rhs As ulong )
  value = rhs 
	 BAS_MCMP_PWMFREQ(value)
End Operator
Operator Type_MCMP_PWMFREQ.cast () As Ulong
	Return BAS_Get_MCMP_PWMFREQ()
End Operator
Operator Type_MCMP_PWMFREQ.cast () As String
  Return Str(BAS_Get_MCMP_PWMFREQ())
End Operator

Type Type_MCMP_PWMDUTY
	value As Double = 0.0
	Declare Operator Let (rhs As double )
  Declare Operator Cast() As double
  Declare Operator Cast() As String
End Type
Operator Type_MCMP_PWMDUTY.let (rhs As double )
  value = rhs 
	BAS_MCMP_PWMDuty(value)
End Operator
Operator Type_MCMP_PWMDUTY.cast () As double
	Return BAS_Get_MCMP_PWMDuty()
End Operator
Operator Type_MCMP_PWMDUTY.cast () As String
  Return Str(BAS_Get_MCMP_PWMDuty())
End Operator



''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''Function
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''Sub
'WriteTCPStream 'TCP_WriteStream
Declare Function TCP_Write Overload(ByVal PortID as short, Array() As Byte, ByVal Num As Integer) As Ulong 
Function TCP_Write Overload(ByVal PortID as short, Array() As Byte, ByVal Num As Integer) As Ulong
	 return ABAS_WriteEthernetStream(PortID, @Array(0), Num)
End Function

Declare Function TCP_Write Overload(ByVal PortID as short, Array() As short, ByVal Num As Integer) As Ulong 
Function TCP_Write Overload(ByVal PortID as short, Array() As short, ByVal Num As Integer) As Ulong
	dim as integer sNum = 2 * Num 
	dim sArray(0 to sNum -1) as byte
	dim as integer dataIndex = 0
	dim pAny as  any ptr
	dim pByte as  byte ptr
	For mindex As Integer = LBound(Array) To UBound(Array)
		pAny = @Array(mindex)
		pByte = pAny
		sArray(dataIndex)	= *pByte
		sArray(dataIndex + 1) = *(pByte + 1)
		dataIndex +=2
	next
	 return ABAS_WriteEthernetStream(PortID, @sArray(0), sNum)
End Function

Declare Function TCP_Write Overload(ByVal PortID as short, Array() As long, ByVal Num As Integer) As Ulong 
Function TCP_Write Overload(ByVal PortID as short, Array() As long, ByVal Num As Integer) As Ulong
	dim as integer lNum = 4 * Num 
	dim lArray(0 to lNum -1) as byte
	dim as integer dataIndex = 0
	dim pAny as  any ptr
	dim pByte as  byte ptr
	For mindex As Integer = LBound(Array) To UBound(Array)
		pAny = @Array(mindex)
		pByte = pAny
		lArray(dataIndex)	= *pByte
		lArray(dataIndex + 1) = *(pByte + 1)
		lArray(dataIndex + 2)	= *(pByte + 2)
		lArray(dataIndex + 3) = *(pByte + 3)
		dataIndex +=4
	next
	 return ABAS_WriteEthernetStream(PortID, @lArray(0), lNum)
End Function

Declare Function TCP_WriteStr Overload(ByVal PortID as short, ByVal Array As String) As Ulong 
Function TCP_WriteStr Overload(ByVal PortID as short, ByVal Array As String) As Ulong
	 return ABAS_WriteEthernetStream(PortID, Strptr(Array), len(Array))
End Function

'ReadTCPStream 'TCP_ReadStream
'Declare Function TCP_ReadStream Overload(ByVal PortID as short, Array() As Byte, ByVal Num As Integer, endStr as string ="#", uTimeout as ulong = 0) As Ulong 
'Function TCP_ReadStream Overload(ByVal PortID as short, Array() As Byte, ByVal Num As Integer, endStr as string ="#", uTimeout as ulong = 0) As Ulong
	 'return ABAS_ReadEthernetStream(PortID, @Array(0), Num, Strptr(endStr), uTimeout)
'End Function

Declare Function TCP_Read Overload(ByVal PortID as short, Array() As Byte, ByVal Num As Integer, uTimeout as ulong = 0) As Ulong 
Function TCP_Read Overload(ByVal PortID as short, Array() As Byte, ByVal Num As Integer, uTimeout as ulong = 0) As Ulong
		dim endStr as string = "#"
	 return ABAS_ReadEthernetStream(PortID, @Array(0), Num, Strptr(endStr), uTimeout)
End Function

Declare Function TCP_Read Overload(ByVal PortID as short, Array() As short, ByVal Num As Integer, uTimeout as ulong = 0) As Ulong 
Function TCP_Read Overload(ByVal PortID as short, Array() As short, ByVal Num As Integer, uTimeout as ulong = 0) As Ulong
		dim endStr as string = "#"
		dim as integer byteCnt = 2 * Num 
		dim myDataArray(0 to byteCnt - 1) as byte
	  dim as long lResult = ABAS_ReadEthernetStream(PortID, @myDataArray(0), byteCnt, Strptr(endStr), uTimeout)
	  dim as integer dataIndex = 0
	  dim pAny as  any ptr
	  dim pByte as  byte ptr
	  For mindex As Integer = LBound(Array) To UBound(Array)
    	'Array(mindex) = myDataArray(dataIndex) + myDataArray(dataIndex + 1)  * 256
    	pAny = @Array(mindex)			'yf,2017.01.03 fix auto change positive value to nagetive value
	  	pByte = pAny
	  	*pByte = myDataArray(dataIndex)
	  	*(PByte+1)= myDataArray(dataIndex + 1)
    	dataIndex = dataIndex +2
		Next

	 return lResult
End Function

Declare Function TCP_Read Overload(ByVal PortID as short, Array() As long, ByVal Num As Integer, uTimeout as ulong = 0) As Ulong 
Function TCP_Read Overload(ByVal PortID as short, Array() As long, ByVal Num As Integer, uTimeout as ulong = 0) As Ulong
	 	dim endStr as string = "#"
		dim as integer byteCnt = 4 * Num 
		dim myDataArray(0 to byteCnt - 1) as byte
	  dim as long lResult = ABAS_ReadEthernetStream(PortID, @myDataArray(0), byteCnt, Strptr(endStr), uTimeout)
	  dim as integer dataIndex = 0
	  dim pAny as  any ptr
	  dim pByte as  byte ptr
	  For mindex As Integer = LBound(Array) To UBound(Array)
    	'Array(mindex) = myDataArray(dataIndex) + 256 * (myDataArray(dataIndex + 1)  + 256 *(myDataArray(dataIndex + 2)  +  256 * myDataArray(dataIndex + 3)))
    	pAny = @Array(mindex)			'yf,2017.01.03 fix auto change positive value to nagetive value
	  	pByte = pAny
	  	*pByte = myDataArray(dataIndex)
	  	*(PByte+1)= myDataArray(dataIndex + 1)
	  	*(PByte+2)= myDataArray(dataIndex + 2)
	  	*(PByte+3)= myDataArray(dataIndex + 3)
    	dataIndex = dataIndex +4
		Next

	 return lResult
End Function

Declare Function TCP_ReadStr Overload(ByVal PortID as short, ByRef Array As String, ByVal Num As Integer, endStr as string ="#", uTimeout as ulong = 0) As Ulong 
Function TCP_ReadStr Overload(ByVal PortID as short, ByRef Array As String, ByVal Num As Integer, endStr as string ="#", uTimeout as ulong = 0) As Ulong
	 Array = space(Num)
	 return ABAS_ReadEthernetStream(PortID, Strptr(Array), Num, Strptr(endStr), uTimeout)
End Function
Declare Function TCP_ReadStr Overload(ByVal PortID as short, ByRef Array As String, ByVal Num As Integer, uTimeout as ulong) As Ulong 
Function TCP_ReadStr Overload(ByVal PortID as short, ByRef Array As String, ByVal Num As Integer, uTimeout as ulong) As Ulong
	 Array = space(Num)
	 return ABAS_ReadEthernetStream(PortID, Strptr(Array), Num, Strptr("#"), uTimeout)
End Function

'WriteComStream	'COM_WriteStream yangfei,2016.06.03 rename
Declare Function COM_WriteStream Overload(ByVal PortID as short, Array() As Byte, ByVal Num As Integer) As Ulong 
Function COM_WriteStream Overload(ByVal PortID as short, Array() As Byte, ByVal Num As Integer) As Ulong
	 return ABAS_WriteComStream(PortID, @Array(0), Num)
End Function
Declare Function COM_WriteStream Overload(ByVal PortID as short, ByVal Array As String, ByVal Num As Integer) As Ulong 
Function COM_WriteStream Overload(ByVal PortID as short, ByVal Array As String, ByVal Num As Integer) As Ulong
	 return ABAS_WriteComStream(PortID, Strptr(Array), Num)
End Function

'ReadComStream	'COM_ReadStream yangfei,2016.06.03 rename
Declare Function COM_ReadStream Overload(ByVal PortID as short, Array() As Byte, ByVal Num As Integer) As Ulong 
Function COM_ReadStream Overload(ByVal PortID as short, Array() As Byte, ByVal Num As Integer) As Ulong
	 return ABAS_ReadComStream(PortID, @Array(0), Num)
End Function
Declare Function COM_ReadStream Overload(ByVal PortID as short, ByRef Array As String, ByVal Num As Integer) As Ulong 
Function COM_ReadStream Overload(ByVal PortID as short, ByRef Array As String, ByVal Num As Integer) As Ulong
	 Array = space(Num)
	 return ABAS_ReadComStream(PortID, Strptr(Array), Num)
End Function

'STATE
Declare Function STATE Overload () As UShort
Function STATE  () As UShort
	 return ABAS_GetSTATE()
End Function
Declare Function STATE Overload (ByVal AxisID As Type_AX) As UShort
Function STATE (ByVal AxisID As Type_AX) As UShort
	 return ABAS_GetSTATE( AxisID.id)
End Function

'STATUS
Declare Function STATUS Overload () As Ulong
Function STATUS  () As Ulong
	 return ABAS_GetSTATUS(-1)
End Function
Declare Function STATUS Overload (ByVal AxisID As Type_AX) As Ulong
Function STATUS (ByVal AxisID As Type_AX) As Ulong
	 return ABAS_GetSTATUS( AxisID.id)
End Function

'SPEED    'yf,2017.01.16 speed not used in manual
'Declare Function SPEED Overload () As UShort
'Function SPEED  () As UShort
'	 return ABAS_GetSPEED()
'End Function
'Declare Function SPEED Overload (ByVal AxisID As Type_AX) As UShort
'Function SPEED (ByVal AxisID As Type_AX) As UShort
'	 return ABAS_GetSPEED( AxisID.id)
'End Function



'ADDMOVE
Declare Sub ADDMOVE Overload (ByVal DPos as double , ByVal Vel as double)
Sub ADDMOVE  (ByVal DPos as double , ByVal Vel as double)
	 ABAS_ADDMOVE( -1, DPos,Vel)
End Sub
Declare Sub ADDMOVE Overload (ByVal AxisID As Type_AX, ByVal DPos as double , ByVal Vel as double)
Sub ADDMOVE (ByVal AxisID As Type_AX, ByVal DPos as double , ByVal Vel as double)
	 ABAS_ADDMOVE( AxisID.id, DPos,Vel )
End Sub

'PCHANGE
Declare Sub PCHANGE Overload (ByVal DPos as double )
Sub PCHANGE  (ByVal DPos as double )
	 ABAS_PCHANGE( -1, DPos)
End Sub
Declare Sub PCHANGE Overload (ByVal AxisID As Type_AX, ByVal DPos as double)
Sub PCHANGE (ByVal AxisID As Type_AX, ByVal DPos as double )
	 ABAS_PCHANGE( AxisID.id, DPos)
End Sub

'VCHANGE
Declare Sub VCHANGE Overload (ByVal Vel as double)
Sub VCHANGE  (ByVal Vel as double )
	 ABAS_VCHANGE( -1, Vel)
End Sub
Declare Sub VCHANGE Overload (ByVal Vel as double, ByVal Acc as double, ByVal Dec as double )
Sub VCHANGE  (ByVal Vel as double, ByVal Acc as double, ByVal Dec as double  )
	 ABAS_VCHANGEEX( -1, Vel, Acc, Dec)
End Sub
Declare Sub VCHANGE Overload (ByVal AxisID As Type_AX, ByVal Vel as double)
Sub VCHANGE (ByVal AxisID As Type_AX, ByVal Vel as double)
	 ABAS_VCHANGE( AxisID.id, Vel)
End Sub
Declare Sub VCHANGE Overload (ByVal AxisID As Type_AX, ByVal Vel as double, ByVal Acc as double, ByVal Dec as double)
Sub VCHANGE (ByVal AxisID As Type_AX, ByVal Vel as double, ByVal Acc as double, ByVal Dec as double)
	 ABAS_VCHANGEEX( AxisID.id, Vel, Acc, Dec)
End Sub

'VCHANGERATE 'VCHANGE_RATE yangfei,2016.06.03 rename
Declare Sub VCHANGE_RATE Overload (ByVal Rate as Ulong)
Sub VCHANGE_RATE  (ByVal Rate as Ulong )
	 ABAS_VCHANGERATE( -1, Rate)
End Sub
Declare Sub VCHANGE_RATE Overload (ByVal Rate as Ulong, ByVal Acc as double, ByVal Dec as double )
Sub VCHANGE_RATE  (ByVal Rate as Ulong, ByVal Acc as double, ByVal Dec as double  )
	 ABAS_VCHANGERATEEX( -1, Rate, Acc, Dec)
End Sub
Declare Sub VCHANGE_RATE Overload (ByVal AxisID As Type_AX, ByVal Rate as Ulong)
Sub VCHANGE_RATE (ByVal AxisID As Type_AX, ByVal Rate as Ulong)
	 ABAS_VCHANGERATE( AxisID.id, Rate)
End Sub
Declare Sub VCHANGE_RATE Overload (ByVal AxisID As Type_AX, ByVal Rate as Ulong, ByVal Acc as double, ByVal Dec as double)
Sub VCHANGE_RATE (ByVal AxisID As Type_AX, ByVal Rate as Ulong, ByVal Acc as double, ByVal Dec as double)
	 ABAS_VCHANGERATEEX( AxisID.id, Rate, Acc, Dec)
End Sub

'JOGP
'Declare Sub JOGP Overload ()
'Sub JOGP  ()
'	 ABAS_MOVEJOG( -1, 0)
'End Sub
'Declare Sub JOGP Overload ( ByVal AxisID As Type_AX )
'Sub JOGP  (ByVal AxisID As Type_AX)
'	 ABAS_MOVEJOG( AxisID.id, 0)
'End Sub 

'yf,2016.6.17
'Declare Sub JOGP Overload ()
'Sub JOGP  ()
	 'ABAS_MOVEJOG( -1, 0,0,0,0, 0,0,0,0)
'End Sub
Declare Sub JOGP Overload ( ByVal AxisID As Type_AX )
Sub JOGP  (ByVal AxisID As Type_AX)
	 ABAS_MOVEJOG( AxisID.id, 0)
End Sub 
Declare Sub JOGP Overload (ByVal Direction1 as Ushort = 0 , ByVal Direction2 as Ushort = 0, ByVal Direction3 as Ushort = 0, ByVal Direction4 as Ushort = 0, ByVal Direction5 as Ushort = 0, ByVal Direction6 as UShort = 0, ByVal Direction7 as Ushort = 0 , ByVal Direction8 as Ushort = 0 )
Sub JOGP  (ByVal Direction1 as Ushort = 0, ByVal Direction2 as Ushort = 0, ByVal Direction3 as Ushort = 0, ByVal Direction4 as Ushort = 0, ByVal Direction5 as Ushort = 0, ByVal Direction6 as UShort = 0, ByVal Direction7 as Ushort = 0,  ByVal Direction8 as Ushort = 0)
	 	ABAS_MOVEJOG( -1, Direction1,Direction2,Direction3,Direction4,Direction5,Direction6,Direction7,Direction8)
End Sub

'JOGN
'Declare Sub JOGN Overload ()
'Sub JOGN  ()
'	 ABAS_MOVEJOG( -1, 1)
'End Sub
'Declare Sub JOGN Overload ( ByVal AxisID As Type_AX )
'Sub JOGN  (ByVal AxisID As Type_AX)
'	 ABAS_MOVEJOG( AxisID.id, 1)
'End Sub

'Declare Sub JOGN Overload ()
'Sub JOGN  ()
	 'ABAS_MOVEJOG( -1, 1, 1, 1, 1, 1, 1, 1, 1)
'End Sub
Declare Sub JOGN Overload ( ByVal AxisID As Type_AX )
Sub JOGN  (ByVal AxisID As Type_AX)
	 ABAS_MOVEJOG( AxisID.id, 1)
End Sub
Declare Sub JOGN Overload (ByVal Direction1 as Ushort = 0, ByVal Direction2 as Ushort = 0 , ByVal Direction3 as Ushort =  0, ByVal Direction4 as Ushort = 0, ByVal Direction5 as Ushort = 0, ByVal Direction6 as UShort = 0, ByVal Direction7 as Ushort = 0, ByVal Direction8 as Ushort =0 )
Sub JOGN  (ByVal Direction1 as Ushort = 0, ByVal Direction2 as Ushort = 0, ByVal Direction3 as Ushort = 0, ByVal Direction4 as Ushort = 0, ByVal Direction5 as Ushort = 0, ByVal Direction6 as UShort = 0, ByVal Direction7 as UShort = 0, ByVal Direction8 as Ushort = 0)
	 if Direction1 = 0 and Direction2 = 0 and Direction3 = 0 and Direction4 = 0 and Direction5 = 0 and Direction6 = 0 and Direction7 = 0 and Direction8 = 0 Then
	 		ABAS_MOVEJOG( -1, 1,1,1,1,1,1,1,1)
	 else
	 		ABAS_MOVEJOG( -1, Direction1 Xor 1,Direction2 Xor 1,Direction3 Xor 1,Direction4 Xor 1,Direction5 Xor 1,Direction6 Xor 1,Direction7 Xor 1, Direction8 Xor 1)
	 end if
End Sub

'JOGON
Declare Sub JOGON Overload ()
Sub JOGON  ()
	 ABAS_EXTDRIVER( -1, 0)
	 ABAS_EXTDRIVER( -1, 1)
End Sub
Declare Sub JOGON Overload ( ByVal AxisID As Type_AX )
Sub JOGON  (ByVal AxisID As Type_AX)
	 ABAS_EXTDRIVER( AxisID.id, 0)
	 ABAS_EXTDRIVER( AxisID.id, 1)
End Sub

'JOGOFF
Declare Sub JOGOFF Overload ()
Sub JOGOFF  ()
	 ABAS_EXTDRIVER( -1, 0)
End Sub
Declare Sub JOGOFF Overload ( ByVal AxisID As Type_AX )
Sub JOGOFF  (ByVal AxisID As Type_AX)
	 ABAS_EXTDRIVER( AxisID.id, 0)
End Sub

'MPGON
Declare Sub MPGON Overload ()
Sub MPGON  ()
	 ABAS_EXTDRIVER( -1, 0)
	 ABAS_EXTDRIVER( -1, 2)
End Sub
Declare Sub MPGON Overload ( ByVal AxisID As Type_AX )
Sub MPGON  (ByVal AxisID As Type_AX)
	 ABAS_EXTDRIVER( AxisID.id, 0)
	 ABAS_EXTDRIVER( AxisID.id, 2)
End Sub

'MPGOFF
Declare Sub MPGOFF Overload ()
Sub MPGOFF  ()
	 ABAS_EXTDRIVER( -1, 0)
End Sub
Declare Sub MPGOFF Overload ( ByVal AxisID As Type_AX )
Sub MPGOFF  (ByVal AxisID As Type_AX)
	 ABAS_EXTDRIVER( AxisID.id, 0)
End Sub

'MOVEJOG
Declare Sub MOVEJOG Overload (ByVal Direction as Ushort)
Sub MOVEJOG  (ByVal Direction as Ushort)
	 ABAS_MOVEJOG( -1, Direction)
End Sub
Declare Sub MOVEJOG Overload ( ByVal AxisID As Type_AX , ByVal Direction as Ushort)
Sub MOVEJOG  (ByVal AxisID As Type_AX, ByVal Direction as Ushort)
	 ABAS_MOVEJOG( AxisID.id, Direction)
End Sub
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'MOVE
'Declare Sub MOVE Overload (ByVal Distance As Double = 0.0,ByVal Distance1 As Double = 0.0,ByVal Distance2 As Double = 0.0,ByVal Distance3 As Double = 0.0,ByVal Distance4 As Double = 0.0,ByVal Distance5 As Double =0.0)
'Sub MOVE (ByVal Distance As Double = 0.0,ByVal Distance1 As Double = 0.0,ByVal Distance2 As Double = 0.0,ByVal Distance3 As Double = 0.0,ByVal Distance4 As Double = 0.0,ByVal Distance5 As Double =0.0)
'	ABAS_MOVE( -1, Distance, Distance1, Distance2, Distance3, Distance4, Distance5)
'End Sub
'Declare Sub MOVE Overload (ByVal AxisID As Type_AX, ByVal Distance As Double)
'Sub MOVE (ByVal AxisID As Type_AX, ByVal Distance As Double)
'	ABAS_MOVE( AxisID.id, Distance)
'End Sub

Declare Sub MOVE Overload (ByVal Distance As Double = DBL_MAX, ByVal Distance1 As Double = DBL_MAX, ByVal Distance2 As Double = DBL_MAX, ByVal Distance3 As Double = DBL_MAX, ByVal Distance4 As Double = DBL_MAX, ByVal Distance5 As Double =DBL_MAX, ByVal Distance6 As Double =DBL_MAX, ByVal Distance7 As Double =DBL_MAX)
Sub MOVE (ByVal Distance As Double = DBL_MAX, ByVal Distance1 As Double = DBL_MAX, ByVal Distance2 As Double = DBL_MAX, ByVal Distance3 As Double = DBL_MAX, ByVal Distance4 As Double = DBL_MAX, ByVal Distance5 As Double =DBL_MAX, ByVal Distance6 As Double =DBL_MAX, ByVal Distance7 As Double =DBL_MAX)
	ABAS_MOVE( -1, Distance, Distance1, Distance2, Distance3, Distance4, Distance5, Distance6, Distance7)
End Sub
Declare Sub MOVE Overload (ByVal AxisID As Type_AX, ByVal Distance As Double)
Sub MOVE (ByVal AxisID As Type_AX, ByVal Distance As Double)
	ABAS_MOVE( AxisID.id, Distance)
End Sub

'MOVEABS
Declare Sub MOVEABS Overload (ByVal Distance As Double = DBL_MAX, ByVal Distance1 As Double = DBL_MAX,ByVal Distance2 As Double = DBL_MAX,ByVal Distance3 As Double = DBL_MAX,ByVal Distance4 As Double = DBL_MAX,ByVal Distance5 As Double =DBL_MAX,ByVal Distance6 As Double =DBL_MAX,ByVal Distance7 As Double =DBL_MAX)
Sub MOVEABS (ByVal Distance As Double = DBL_MAX,ByVal Distance1 As Double = DBL_MAX,ByVal Distance2 As Double = DBL_MAX,ByVal Distance3 As Double = DBL_MAX,ByVal Distance4 As Double =DBL_MAX,ByVal Distance5 As Double =DBL_MAX,ByVal Distance6 As Double =DBL_MAX,ByVal Distance7 As Double =DBL_MAX)
	 ABAS_MOVEABS( -1, Distance, Distance1, Distance2, Distance3, Distance4, Distance5, Distance6, Distance7)
End Sub
Declare Sub MOVEABS Overload (ByVal AxisID As Type_AX, ByVal Distance As Double)
Sub MOVEABS (ByVal AxisID As Type_AX, ByVal Distance As Double)
	 ABAS_MOVEABS( AxisID.id, Distance)
End Sub

'FORWARD 			'yf,2016.07.25 change default value
Declare Sub FORWARD Overload (ByVal Direction As Short= 0, ByVal Direction1 As Short = 0, ByVal Direction2 As Short = 0, ByVal Direction3 As Short = 0, ByVal Direction4 As Short = 0, ByVal Direction5 As Short = 0, ByVal Direction6 As Short = 0, ByVal Direction7 As Short = 0)
Sub FORWARD  (ByVal Direction As Short= 0, ByVal Direction1 As Short = 0, ByVal Direction2 As Short = 0, ByVal Direction3 As Short = 0, ByVal Direction4 As Short = 0, ByVal Direction5 As Short = 0, ByVal Direction6 As Short = 0, ByVal Direction7 As Short = 0)
		ABAS_MOVEV( -1, Direction, Direction1, Direction2, Direction3, Direction4, Direction5, Direction6, Direction7)
End Sub
Declare Sub FORWARD Overload (ByVal AxisID As Type_AX)
Sub FORWARD (ByVal AxisID As Type_AX)
	 ABAS_MOVEV( AxisID.id, 0)
End Sub

'REVERSE
Declare Sub REVERSE Overload (ByVal Direction As Short= 0, ByVal Direction1 As Short = 0, ByVal Direction2 As Short = 0, ByVal Direction3 As Short = 0, ByVal Direction4 As Short = 0, ByVal Direction5 As Short = 0, ByVal Direction6 As Short = 0, ByVal Direction7 As Short = 0)
Sub REVERSE  (ByVal Direction As Short= 0, ByVal Direction1 As Short = 0, ByVal Direction2 As Short = 0, ByVal Direction3 As Short = 0, ByVal Direction4 As Short = 0, ByVal Direction5 As Short = 0, ByVal Direction6 As Short = 0, ByVal Direction7 As Short = 0)
	 if Direction = 0 and Direction1 = 0 and  Direction2 = 0 and  Direction3 = 0 and Direction4 = 0 and Direction5 = 0 and Direction6 = 0 and Direction7 = 0 Then
		ABAS_MOVEV( -1, 1,1,1,1,1,1,1,1)
	else
		ABAS_MOVEV( -1, Direction Xor 1, Direction1 Xor 1,Direction2 Xor 1, Direction3 Xor 1, Direction4 Xor 1, Direction5 Xor 1, Direction6 Xor 1, Direction7 Xor 1)
	End if
End Sub
Declare Sub REVERSE Overload (ByVal AxisID As Type_AX)
Sub REVERSE (ByVal AxisID As Type_AX)
	 ABAS_MOVEV( AxisID.id, 1)
End Sub

'HOMEP
Declare Sub HOMEP Overload (ByVal Direction As Short= 0, ByVal Direction1 As Short = 0, ByVal Direction2 As Short = 0, ByVal Direction3 As Short = 0, ByVal Direction4 As Short = 0, ByVal Direction5 As Short = 0, ByVal Direction6 As Short = 0, ByVal Direction7 As Short = 0)
Sub HOMEP  (ByVal Direction As Short= 0, ByVal Direction1 As Short = 0, ByVal Direction2 As Short = 0, ByVal Direction3 As Short = 0, ByVal Direction4 As Short = 0, ByVal Direction5 As Short = 0, ByVal Direction6 As Short = 0, ByVal Direction7 As Short = 0)
		ABAS_HOME( -1, Direction, Direction1, Direction2, Direction3, Direction4, Direction5, Direction6, Direction7)
End Sub
Declare Sub HOMEP Overload (ByVal AxisID As Type_AX,  ByVal Direction As Short)
Sub HOMEP (ByVal AxisID As Type_AX)
	 ABAS_HOME( AxisID.id, 0)
End Sub

'HOMEN
Declare Sub HOMEN Overload (ByVal Direction As Short= 0, ByVal Direction1 As Short = 0, ByVal Direction2 As Short = 0, ByVal Direction3 As Short = 0, ByVal Direction4 As Short = 0, ByVal Direction5 As Short = 0, ByVal Direction6 As Short = 0, ByVal Direction7 As Short = 0)
Sub HOMEN  (ByVal Direction As Short= 0, ByVal Direction1 As Short = 0, ByVal Direction2 As Short = 0, ByVal Direction3 As Short = 0, ByVal Direction4 As Short = 0, ByVal Direction5 As Short = 0, ByVal Direction6 As Short = 0, ByVal Direction7 As Short = 0)
	 if Direction = 0 and Direction1 = 0 and  Direction2 = 0 and  Direction3 = 0 and Direction4 = 0 and Direction5 = 0 and Direction6 = 0 and Direction7 = 0 Then
		ABAS_HOME( -1, 1,1,1,1,1,1,1,1)
	else
		ABAS_HOME( -1, Direction Xor 1, Direction1 Xor 1,Direction2 Xor 1, Direction3 Xor 1, Direction4 Xor 1, Direction5 Xor 1, Direction6 Xor 1, Direction7 Xor 1)
	End if
End Sub
Declare Sub HOMEN Overload (ByVal AxisID As Type_AX,  ByVal Direction As Short)
Sub HOMEN (ByVal AxisID As Type_AX)
	 ABAS_HOME( AxisID.id, 1)
End Sub

'STOPDEC
Declare Sub STOPDEC Overload (ByVal DecValue As Double = -1.0,ByVal DecValue1 As Double = -1.0,ByVal DecValue2 As Double = -1.0,ByVal DecValue3 As Double = -1.0,ByVal DecValue4 As Double = -1.0,ByVal DecValue5 As Double = -1.0,ByVal DecValue6 As Double = -1.0,ByVal DecValue7 As Double = -1.0)
Sub STOPDEC  (ByVal DecValue As Double = -1.0,ByVal DecValue1 As Double = -1.0,ByVal DecValue2 As Double = -1.0,ByVal DecValue3 As Double = -1.0,ByVal DecValue4 As Double = -1.0,ByVal DecValue5 As Double = -1.0,ByVal DecValue6 As Double = -1.0,ByVal DecValue7 As Double = -1.0)
	 ABAS_STOPDEC( -1, DecValue, DecValue1, DecValue2, DecValue3, DecValue4, DecValue5, DecValue6, DecValue7)
End Sub
Declare Sub STOPDEC Overload (ByVal AxisID As Type_AX, ByVal DecValue As Double = -1.0)
Sub STOPDEC (ByVal AxisID As Type_AX, ByVal DecValue As Double = -1.0)
	 ABAS_STOPDEC( AxisID.id, DecValue)
End Sub

'STOPEMG
'Declare Sub STOPEMG Overload (ByVal AxisID As Short = -1, ByVal AxisID1 As Short = -1,ByVal AxisID2 As Short = -1,ByVal AxisID3 As Short = -1,ByVal AxisID4 As Short = -1,ByVal AxisID5 As Short = -1,ByVal AxisID6 As Short = -1,ByVal AxisID7 As Short = -1)
'Sub STOPEMG  (ByVal AxisID As Short = -1, ByVal AxisID1 As Short = -1,ByVal AxisID2 As Short = -1,ByVal AxisID3 As Short = -1,ByVal AxisID4 As Short = -1,ByVal AxisID5 As Short = -1,ByVal AxisID6 As Short = -1,ByVal AxisID7 As Short = -1)
'	 ABAS_STOPEMG( AxisID, AxisID1, AxisID2, AxisID3, AxisID4, AxisID5, AxisID6, AxisID7)
'End Sub		'yf,2017.02.22 this funciton is no use
Declare Sub STOPEMG Overload (ByVal AxisID As Type_AX)
Sub STOPEMG (ByVal AxisID As Type_AX)
	 ABAS_STOPEMG( AxisID.id)
End Sub
'yf,2017.02.22 add
Declare Sub STOPEMG Overload ()		
Sub STOPEMG  ()
	 ABAS_STOPEMG(-1)
End Sub

'RESETERR
'Declare Sub RESETERR Overload (ByVal AxisID As Short = -1, ByVal AxisID1 As Short = -1,ByVal AxisID2 As Short = -1,ByVal AxisID3 As Short = -1,ByVal AxisID4 As Short = -1,ByVal AxisID5 As Short = -1,ByVal AxisID6 As Short = -1,ByVal AxisID7 As Short = -1)
'Sub RESETERR  (ByVal AxisID As Short = -1, ByVal AxisID1 As Short = -1,ByVal AxisID2 As Short = -1,ByVal AxisID3 As Short = -1,ByVal AxisID4 As Short = -1,ByVal AxisID5 As Short = -1,ByVal AxisID6 As Short = -1,ByVal AxisID7 As Short = -1)
'	 ABAS_RESETERR( AxisID, AxisID1, AxisID2, AxisID3, AxisID4, AxisID5, AxisID6, AxisID7)
'End Sub
Declare Sub RESETERR Overload (ByVal AxisID As Type_AX)
Sub RESETERR (ByVal AxisID As Type_AX)
	 ABAS_RESETERR( AxisID.id)
End Sub
'yf,2017.02.22 add 
Declare Sub RESETERR Overload ()
Sub RESETERR ()
	 ABAS_RESETERR(-1)
End Sub

'SERVON
'Declare Sub SERVON Overload ()		' yangfei,2016.06.03
'Sub SERVON  ()
Declare Sub SVON Overload ()
Sub SVON  ()
	 ABAS_SERVO( -1, 1,1,1,1,1,1,1,1)
End Sub
'Declare Sub SERVON Overload (ByVal AxisID As Type_AX)	' yangfei,2016.06.03
'Sub SERVON (ByVal AxisID As Type_AX)
Declare Sub SVON Overload (ByVal AxisID As Type_AX)
Sub SVON (ByVal AxisID As Type_AX)
	 ABAS_SERVO( AxisID.id, 1)
End Sub

'SERVOFF
'Declare Sub SERVOFF Overload ()
'Sub SERVOFF  ()
Declare Sub SVOFF Overload ()		' yangfei,2016.06.03
Sub SVOFF  ()
	 ABAS_SERVO( -1, 0,0,0,0,0,0,0,0)
End Sub
'Declare Sub SERVOFF Overload (ByVal AxisID As Type_AX)		' yangfei,2016.06.03
'Sub SERVOFF (ByVal AxisID As Type_AX)
Declare Sub SVOFF Overload (ByVal AxisID As Type_AX)
Sub SVOFF (ByVal AxisID As Type_AX)
	 ABAS_SERVO( AxisID.id, 0)
End Sub

'SYNC
'Declare Sub SYNC Overload (ByVal Mode As UShort, ByVal Distance As Double = DBL_MAX, ByVal Distance1 As Double = DBL_MAX,ByVal Distance2 As Double = DBL_MAX,ByVal Distance3 As Double = DBL_MAX,ByVal Distance4 As Double = DBL_MAX,ByVal Distance5 As Double =DBL_MAX)
'Sub SYNC (ByVal Mode As UShort, ByVal Distance As Double = DBL_MAX,ByVal Distance1 As Double = DBL_MAX,ByVal Distance2 As Double = DBL_MAX,ByVal Distance3 As Double = DBL_MAX,ByVal Distance4 As Double =DBL_MAX,ByVal Distance5 As Double =DBL_MAX)
'	 ABAS_SYNC( -1, Mode, Distance, Distance1, Distance2, Distance3, Distance4, Distance5)
'End Sub
'Declare Sub SYNC Overload (ByVal AxisID As Type_AX, ByVal Mode As UShort, ByVal Distance As Double)
'Sub SYNC (ByVal AxisID As Type_AX, ByVal Mode As UShort, ByVal Distance As Double)
'	 ABAS_SYNC( AxisID.id, Mode, Distance)
'End Sub

'STA
Declare Sub SETSTA Overload (ByVal Distance As Double = DBL_MAX, ByVal Distance1 As Double = DBL_MAX, ByVal Distance2 As Double = DBL_MAX, ByVal Distance3 As Double = DBL_MAX, ByVal Distance4 As Double = DBL_MAX, ByVal Distance5 As Double =DBL_MAX, ByVal Distance6 As Double =DBL_MAX, ByVal Distance7 As Double =DBL_MAX)
Sub SETSTA (ByVal Distance As Double = DBL_MAX, ByVal Distance1 As Double = DBL_MAX, ByVal Distance2 As Double = DBL_MAX, ByVal Distance3 As Double = DBL_MAX, ByVal Distance4 As Double = DBL_MAX, ByVal Distance5 As Double =DBL_MAX, ByVal Distance6 As Double = DBL_MAX, ByVal Distance7 As Double =DBL_MAX)
	ABAS_STA( -1, Distance, Distance1, Distance2, Distance3, Distance4, Distance5, Distance6, Distance7)
End Sub
Declare Sub SETSTA Overload (ByVal AxisID As Type_AX, ByVal Distance As Double)
Sub SETSTA (ByVal AxisID As Type_AX, ByVal Distance As Double)
	ABAS_STA( AxisID.id, Distance)
End Sub

'STAABS		'SETSTA_ABS
Declare Sub SETSTA_ABS Overload (ByVal Distance As Double = DBL_MAX, ByVal Distance1 As Double = DBL_MAX,ByVal Distance2 As Double = DBL_MAX,ByVal Distance3 As Double = DBL_MAX,ByVal Distance4 As Double = DBL_MAX,ByVal Distance5 As Double =DBL_MAX,ByVal Distance6 As Double =DBL_MAX,ByVal Distance7 As Double =DBL_MAX)
Sub SETSTA_ABS (ByVal Distance As Double = DBL_MAX,ByVal Distance1 As Double = DBL_MAX,ByVal Distance2 As Double = DBL_MAX,ByVal Distance3 As Double = DBL_MAX,ByVal Distance4 As Double =DBL_MAX,ByVal Distance5 As Double =DBL_MAX,ByVal Distance6 As Double =DBL_MAX,ByVal Distance7 As Double =DBL_MAX)
	 ABAS_STAABS( -1, Distance, Distance1, Distance2, Distance3, Distance4, Distance5, Distance6, Distance7)
End Sub
Declare Sub SETSTA_ABS Overload (ByVal AxisID As Type_AX, ByVal Distance As Double)
Sub SETSTA_ABS (ByVal AxisID As Type_AX, ByVal Distance As Double)
	 ABAS_STAABS( AxisID.id, Distance)
End Sub

'STAVEL	'SETSTA_VEL
Declare Sub SETSTA_VEL Overload (ByVal Direction As Short= -1, ByVal Direction1 As Short = -1, ByVal Direction2 As Short = -1, ByVal Direction3 As Short = -1, ByVal Direction4 As Short = -1, ByVal Direction5 As Short = -1, ByVal Direction6 As Short = -1, ByVal Direction7 As Short = -1)
Sub SETSTA_VEL  (ByVal Direction As Short= -1, ByVal Direction1 As Short = -1, ByVal Direction2 As Short = -1, ByVal Direction3 As Short = -1, ByVal Direction4 As Short = -1, ByVal Direction5 As Short = -1, ByVal Direction6 As Short = -1, ByVal Direction7 As Short = -1)
	 ABAS_STAVEL( -1, Direction, Direction1, Direction2, Direction3, Direction4, Direction5, Direction6, Direction7)
End Sub
Declare Sub SETSTA_VEL Overload (ByVal AxisID As Type_AX, ByVal Direction As Short)
Sub SETSTA_VEL (ByVal AxisID As Type_AX, ByVal Direction As Short)
	 ABAS_MOVEV( AxisID.id, Direction)
End Sub

'STARTSTA
Declare Sub STARTSTA Overload ()
Sub STARTSTA ()
	 ABAS_STARTSTA( -1)
End Sub
Declare Sub STARTSTA Overload (ByVal AxisID As Type_AX)
Sub STARTSTA (ByVal AxisID As Type_AX)
	 ABAS_STARTSTA( AxisID.id)
End Sub

'STOPSTA
Declare Sub STOPSTA Overload ()
Sub STOPSTA ()
	 ABAS_STOPSTA( -1)
End Sub
Declare Sub STOPSTA Overload (ByVal AxisID As Type_AX)
Sub STOPSTA (ByVal AxisID As Type_AX)
	 ABAS_STOPSTA( AxisID.id)
End Sub

'GEAR
Declare Sub GEAR(ByVal AxisID As Type_AX, ByVal Numerator As LONG, ByVal Denominator As LONG, ByVal RefSrc As ULONG, ByVal Absolute As ULONG)
Sub GEAR (ByVal AxisID As Type_AX, ByVal Numerator As LONG, ByVal Denominator As LONG, ByVal RefSrc As ULONG, ByVal Absolute As ULONG)
	 ABAS_GEAR( AxisID.id, Numerator, Denominator, RefSrc, Absolute)
End Sub

'GANTRY
Declare Sub GANTRY(ByVal AxisID As Type_AX, ByVal RefMasterSrc As Short, ByVal Direction As Short)
Sub GANTRY (ByVal AxisID As Type_AX, ByVal RefMasterSrc As Short, ByVal Direction As Short)
	 ABAS_GANTRY( AxisID.id, RefMasterSrc, Direction)
End Sub

'TANGENT
Declare Sub TANGENT Overload (ByVal AxisID As Type_AX, StartVectorArray() As Short, ByVal Plane As UBYTE, ByVal Direction As Short, ByVal ModuleRange As long = -1)
Sub TANGENT (ByVal AxisID As Type_AX, StartVectorArray() As Short, ByVal Plane As UBYTE, ByVal Direction As Short, ByVal ModuleRange As long = -1)
	IF  ModuleRange <> -1 THEN											' yf,2016.08.05 para error check
	 ABAS_SetModuleRange( AxisID.id, ModuleRange )
	END IF
	ABAS_TANGENT( AxisID.id, @StartVectorArray(0), Plane, Direction)
End Sub

Declare Sub TANGENT Overload (ByVal AxisID As Type_AX, StartVectorArray() As Short, ByVal Direction As Short, ByVal ModuleRange As long = -1)
Sub TANGENT (ByVal AxisID As Type_AX, StartVectorArray() As Short, ByVal Direction As Short, ByVal ModuleRange As long = -1)
	IF  ModuleRange <> -1 THEN											' yf,2016.08.05 para error check
	 ABAS_SetModuleRange( AxisID.id, ModuleRange )
	END IF
	dim rfPlane as long
	rfPlane = BAS_GetRefPlane()
	ABAS_TANGENT( AxisID.id, @StartVectorArray(0), rfPlane, Direction)
End Sub

'PHASE
Declare Sub PHASE(ByVal AxisID As Type_AX, ByVal Acc as double, ByVal Dec as double, ByVal PhaseSpeed as double, ByVal PhaseDist as double)
Sub PHASE (ByVal AxisID As Type_AX, ByVal Acc as double, ByVal Dec as double, ByVal PhaseSpeed as double, ByVal PhaseDist as double)
	 ABAS_PHASE( AxisID.id, Acc, Dec, PhaseSpeed, PhaseDist)
End Sub

'LTC
'Declare Sub LTC(ByVal AxisID As Type_AX)		'yangfei,2016.06.03
'Declare Sub TrigLTC Overload (ByVal AxisID As Type_AX)	
Declare Sub TrigLTC (ByVal AxisID As Type_AX)	
Sub TrigLTC (ByVal AxisID As Type_AX)
	 ABAS_LTC( AxisID.id )
End Sub

'Declare Sub TrigLTC Overload ()		'yangfei,2016.06.03 add 
'Sub TrigLTC ()
	 'ABAS_LTC( -1 )
'End Sub

'LDPOS
Declare Function LDPOS(ByVal AxisID As Type_AX) AS Double
Function LDPOS (ByVal AxisID As Type_AX) AS Double
	 Return ABAS_LPOS( AxisID.id, 0 )
End Function

'LMPOS
Declare Function LMPOS(ByVal AxisID As Type_AX) AS Double
Function LMPOS (ByVal AxisID As Type_AX) AS Double
	 Return ABAS_LPOS( AxisID.id, 1 )
End Function

'RESETLTC
Declare Sub RESETLTC(ByVal AxisID As Type_AX)
Sub RESETLTC (ByVal AxisID As Type_AX)
	 ABAS_RESETLTC( AxisID.id )
End Sub

' yf,2016.06.29
'RESETCMP 
Declare Sub RESETCMP(ByVal AxisID As Type_AX)
Sub RESETCMP (ByVal AxisID As Type_AX)
	 ABAS_RESETCMP( AxisID.id )
End Sub

'LTC_FLAG
Declare Function LTC_FLAG(ByVal AxisID As Type_AX) AS UShort
Function LTC_FLAG (ByVal AxisID As Type_AX) AS UShort
	 Return ABAS_GETLTCFLAG( AxisID.id)
End Function

'CMP_FLAG
Declare Function CMP_FLAG(ByVal AxisID As Type_AX) AS UShort
Function CMP_FLAG (ByVal AxisID As Type_AX) AS UShort
	 Return ABAS_GETCMPFLAG( AxisID.id)
End Function

'CPOS
Declare Function CPOS(ByVal AxisID As Type_AX) AS Double
Function CPOS (ByVal AxisID As Type_AX) AS Double
	 Return ABAS_CPOS( AxisID.id )
End Function

'CMP
Declare Sub CMP Overload (ByVal AxisID As Type_AX, ByVal position As Double)
Sub CMP (ByVal AxisID As Type_AX, ByVal position As Double)
	 ABAS_CMP(AxisID.id, position)
End Sub
Declare Sub CMP Overload (ByVal AxisID As Type_AX, ByVal Start As Double, ByVal End As Double, ByVal Interval As Double)
Sub CMP (ByVal AxisID As Type_AX, ByVal Start As Double, ByVal EndData As Double, ByVal Interval As Double)
	 ABAS_CMP_AUTO(AxisID.id, Start,EndData,Interval)
End Sub
Declare Sub CMP Overload (ByVal AxisID As Type_AX, TableArray() As Double, ByVal Arraycnt As Long)
Sub CMP (ByVal AxisID As Type_AX, TableArray() As Double, ByVal Arraycnt As Long)
	 ABAS_CMP_TABLE(AxisID.id, @TableArray(0), Arraycnt)
End Sub

'MERGEON
Declare Sub MERGEON ()
Sub MERGEON ()
	 ABAS_SetMergeMod(0)
End Sub
'MERGEOFF
Declare Sub MERGEOFF ()
Sub MERGEOFF ()
	 ABAS_SetMergeMod(1)
End Sub

'Error Axis
Declare Function ERROR_AXIS() AS Ulong
Function ERROR_AXIS () AS Ulong
	 Return ABAS_GetErrorAxis()
End Function

'Motion Error
'Declare Function MOTION_ERROR Overload () As Ulong
'Function MOTION_ERROR() As Ulong
	 'return ABAS_GetMotionError(-1)
'End Function
'Declare Function MOTION_ERROR Overload (ByVal AxisID As Type_AX) As Ulong
'Function MOTION_ERROR (ByVal AxisID As Type_AX) As Ulong
	 'return ABAS_GetMotionError( AxisID.id)
'End Function

'run error yf,206.7.13 rename
Declare Function RUN_ERROR Overload () As Ulong
Function RUN_ERROR() As Ulong
	 return ABAS_GetMotionError(-1)
End Function
Declare Function RUN_ERROR Overload (ByVal AxisID As Type_AX) As Ulong
Function RUN_ERROR (ByVal AxisID As Type_AX) As Ulong
	 return ABAS_GetMotionError( AxisID.id)
End Function


'System Error
Declare Function SYSTEM_ERROR() AS Ulong
Function SYSTEM_ERROR () AS Ulong
	 Return ABAS_GetSystemError()
End Function

'Clear System error
Declare Sub CLEAR_ERROR ()
Sub CLEAR_ERROR ()
	 ABAS_ClearSystemError()
End Sub

'LINE	'yf,2017.02.16
Declare Sub LINE Overload(Distance As Double = DBL_MAX, Distance1 As Double = DBL_MAX, Distance2 As Double = DBL_MAX, Distance3 As Double = DBL_MAX, Distance4 As Double = DBL_MAX, Distance5 As Double =DBL_MAX, Distance6 As Double =DBL_MAX, Distance7 As Double =DBL_MAX)
Sub LINE(Distance As Double = DBL_MAX, Distance1 As Double = DBL_MAX, Distance2 As Double = DBL_MAX, Distance3 As Double = DBL_MAX, Distance4 As Double = DBL_MAX, Distance5 As Double =DBL_MAX, Distance6 As Double =DBL_MAX, Distance7 As Double =DBL_MAX)
	ABAS_LINE(Distance, Distance1, Distance2, Distance3, Distance4, Distance5, Distance6, Distance7)
End Sub

Declare Sub LINE Overload(DisArray() As Double)
Sub LINE(DisArray() As Double) 
Dim array(0 to 7) As Double = {DBL_MAX, DBL_MAX, DBL_MAX, DBL_MAX, DBL_MAX, DBL_MAX, DBL_MAX, DBL_MAX}
Dim arrayIndex As Integer = 0
For index As Integer = LBound(DisArray) To UBound(DisArray)
	'Print "Index = ";index									'yf,2016.07.05 mark info output
    array(arrayIndex) = DisArray(index)
    if(arrayIndex>8) THEN
    Exit For    
    End If
    arrayIndex+=1
Next
	ABAS_LINE(array(0),array(1),array(2),array(3),array(4),array(5), array(6), array(7))
End Sub

'LINEABS 'yf,2017.02.16
Declare Sub LINEABS Overload(Distance As Double = DBL_MAX, Distance1 As Double = DBL_MAX, Distance2 As Double = DBL_MAX, Distance3 As Double = DBL_MAX, Distance4 As Double = DBL_MAX, Distance5 As Double =DBL_MAX, Distance6 As Double =DBL_MAX, Distance7 As Double =DBL_MAX )
Sub LINEABS(Distance As Double = DBL_MAX, Distance1 As Double = DBL_MAX, Distance2 As Double = DBL_MAX,Distance3 As Double = DBL_MAX, Distance4 As Double = DBL_MAX, Distance5 As Double =DBL_MAX, Distance6 As Double =DBL_MAX, Distance7 As Double =DBL_MAX)
	ABAS_LINEABS(Distance, Distance1, Distance2, Distance3, Distance4, Distance5, Distance6, Distance7)
End Sub

Declare Sub LINEABS Overload(DisArray() As Double)
Sub LINEABS(DisArray() As Double) 
Dim array(0 to 7) As Double = {DBL_MAX, DBL_MAX, DBL_MAX, DBL_MAX, DBL_MAX, DBL_MAX, DBL_MAX, DBL_MAX}
Dim arrayIndex As Integer = 0
For index As Integer = LBound(DisArray) To UBound(DisArray)
	'Print "Index = ";index								'yf,2016.07.05 mark info output
    array(arrayIndex) = DisArray(index)
    if(arrayIndex>8) THEN
    Exit For
    End If
    arrayIndex+=1
Next
	ABAS_LINEABS(array(0),array(1),array(2),array(3),array(4),array(5),array(6),array(7))
End Sub

'PTP	'DIRECT yangfei, 2016.06.03 rename
Declare Sub DIRECT Overload(Distance As Double = DBL_MAX, Distance1 As Double = DBL_MAX, Distance2 As Double = DBL_MAX, Distance3 As Double = DBL_MAX, Distance4 As Double = DBL_MAX, Distance5 As Double =DBL_MAX, Distance6 As Double =DBL_MAX, Distance7 As Double =DBL_MAX)
Sub DIRECT(Distance As Double = DBL_MAX, Distance1 As Double = DBL_MAX, Distance2 As Double = DBL_MAX, Distance3 As Double = DBL_MAX, Distance4 As Double = DBL_MAX, Distance5 As Double =DBL_MAX, Distance6 As Double =DBL_MAX, Distance7 As Double =DBL_MAX)
	ABAS_PTP(Distance, Distance1, Distance2, Distance3, Distance4, Distance5, Distance6, Distance7)
End Sub

Declare Sub DIRECT Overload(DisArray() As Double)
Sub DIRECT(DisArray() As Double) 
Dim array(0 to 7) As Double = {DBL_MAX,DBL_MAX,DBL_MAX,DBL_MAX,DBL_MAX,DBL_MAX,DBL_MAX,DBL_MAX}
Dim arrayIndex As Integer = 0
For index As Integer = LBound(DisArray) To UBound(DisArray)
	'Print "Index = ";index											'yf,2016.07.05 mark info output
    array(arrayIndex) = DisArray(index)
    if(arrayIndex>8) THEN
    Exit For
    End If 
    arrayIndex+=1
Next
	ABAS_PTP(array(0),array(1),array(2),array(3),array(4),array(5),array(6),array(7))
End Sub

'PTPABS 'DIRECTABS yangfei, 2016.06.03 rename
Declare Sub DIRECTABS Overload(Distance As Double = DBL_MAX, Distance1 As Double = DBL_MAX, Distance2 As Double = DBL_MAX, Distance3 As Double = DBL_MAX, Distance4 As Double = DBL_MAX, Distance5 As Double =DBL_MAX, Distance6 As Double =DBL_MAX, Distance7 As Double =DBL_MAX)
Sub DIRECTABS(Distance As Double = DBL_MAX, Distance1 As Double = DBL_MAX, Distance2 As Double = DBL_MAX, Distance3 As Double = DBL_MAX, ByVal Distance4 As Double = DBL_MAX, Distance5 As Double = DBL_MAX, Distance6 As Double =DBL_MAX, Distance7 As Double =DBL_MAX)
	ABAS_PTPABS(Distance, Distance1, Distance2, Distance3, Distance4, Distance5, Distance6, Distance7)
End Sub

Declare Sub DIRECTABS Overload(DisArray() As Double)
Sub DIRECTABS(DisArray() As Double) 
Dim array(0 to 7) As Double = {DBL_MAX, DBL_MAX, DBL_MAX, DBL_MAX, DBL_MAX, DBL_MAX, DBL_MAX, DBL_MAX}
Dim arrayIndex As Integer = 0
For index As Integer = LBound(DisArray) To UBound(DisArray)
	'Print "Index = ";index											'yf,2016.07.05 mark info output
    array(arrayIndex) = DisArray(index)
    if(arrayIndex>8) THEN
    Exit For
    End If
    arrayIndex+=1
Next
	ABAS_PTPABS(array(0),array(1),array(2),array(3),array(4),array(5),array(6),array(7))
End Sub

'ydd 2017.4.26
Declare Sub CAMSTOP Overload (ByVal AxisID As Type_AX)
Sub CAMSTOP(ByVal AxisID As Type_AX)
	 ABAS_STOPEMG( AxisID.id)
End Sub

Declare Sub CAMSTOP Overload ()		
Sub CAMSTOP ()
	 ABAS_STOPEMG(-1)
End Sub


Declare Sub CAMTABLE overload(CamIndex As Short, MasAxisNo As Short, SlavAxisNo As Short, VR_Start As Long, DataCount As Ulong, CamID As Ushort = 0, IsSpdUsed As Ulong = 0)
Sub CAMTABLE overload(CamIndex As Short, MasAxisNo As Short, SlavAxisNo As Short, VR_Start As Long, DataCount As Ulong, CamID As Ushort = 0, IsSpdUsed As Ulong = 0)
	ABAS_CAMTABLE(CamIndex, MasAxisNo, SlavAxisNo, VR_Start, DataCount, CamID, IsSpdUsed)
END Sub

Declare Sub CAMTABLE overload(CamIndex As Short, MasAxisNo As Type_AX, SlavAxisNo As Type_AX, VR_Start As Long, DataCount As Ulong, CamID As Ushort = 0, IsSpdUsed As Ulong = 0)
Sub CAMTABLE overload(CamIndex As Short, MasAxisNo As Type_AX, SlavAxisNo As Type_AX, VR_Start As Long,DataCount As Ulong, CamID As Ushort = 0, IsSpdUsed As Ulong = 0)
	ABAS_CAMTABLE(CamIndex, MasAxisNo.id, SlavAxisNo.id, VR_Start, DataCount, CamID, IsSpdUsed)
END Sub

Declare Sub LBUF_DATA overload(ByVal AxisID As Short, DataArray() As double, ByRef DataCnt As ULONG) 
Sub LBUF_DATA overload(ByVal AxisID As Short, DataArray() As double, ByRef DataCnt As ULONG)
	Dim As double ptr tempData = @DataArray(0)
	ABAS_GetLatchBufferData(AxisID, tempData, DataCnt)
END Sub

Declare Sub LBUF_DATA overload(ByVal AxisID As Type_AX, DataArray() As double, ByRef DataCnt As ULONG) 
Sub LBUF_DATA overload(ByVal AxisID As Type_AX, DataArray() As double, ByRef DataCnt As ULONG)
	Dim As double ptr tempData = @DataArray(0)
	ABAS_GetLatchBufferData(AxisID.id, tempData, DataCnt)
END Sub

Declare Sub LBUF_STATUS overload(ByVal AxisID As Short, ByRef RemCant As ULONG, ByRef SpaceCnt As ULONG) 
Sub LBUF_STATUS overload(ByVal AxisID As Short, ByRef RemCant As ULONG, ByRef SpaceCnt As ULONG) 	
	ABAS_LBUF_STATUS(AxisID, RemCant, SpaceCnt)
END Sub

Declare Sub LBUF_STATUS overload(ByVal AxisID As Type_AX, ByRef RemCant As ULONG, ByRef SpaceCnt As ULONG) 
Sub LBUF_STATUS overload(ByVal AxisID As Type_AX, ByRef RemCant As ULONG, ByRef SpaceCnt As ULONG) 	
	ABAS_LBUF_STATUS(AxisID.id, RemCant, SpaceCnt)
END Sub


Declare Sub LBUF_RESET overload(ByVal AxisID As Short)
Sub LBUF_RESET overload(ByVal AxisID As Short)
	ABAS_LBUF_RESET(AxisID)
End Sub

Declare Sub LBUF_RESET overload(ByVal AxisID As Type_AX)
Sub LBUF_RESET overload(ByVal AxisID As Type_AX)
	ABAS_LBUF_RESET(AxisID.id)
End Sub

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''Const
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''Dim
Const T = 0
Const S = 1
Const CW = 0
Const CCW = 1
Const DONE = 1
Const LATCHED = 4
Const COMPARED = 2
Const CYLDONE = 8
Const LTCBUFDONE = &H40

Dim Shared VR(0 to MAXVR-1) As Type_VR
Dim Shared TABLE(0 to MAXTABLE-1) As Type_Table
Dim Shared DOUT(0 to MAXDO-1) As Type_DO
Dim Shared DIN(0 to MAXDI-1) As Type_DI
Dim Shared AX(0 to MAXAX-1) As Type_AX
Dim Shared ACC As Type_ACC
Dim Shared DEC As Type_DEC
Dim Shared VL As Type_VL
Dim Shared VH As Type_VH
Dim Shared JK As Type_JERK
Dim Shared HOME_MODE As Type_HOMEMODE
Dim Shared DPOS As Type_DPOS
Dim Shared MPOS As Type_MPOS
Dim Shared MIO As Type_MIO
Dim Shared UNIT_NUM As Type_PPU
Dim Shared MAXVEL As Type_MaxVel
Dim Shared MAXACC As Type_MaxAcc
Dim Shared MAXDEC As Type_MaxDec
Dim Shared PIN_MODE As Type_PulseInMode
Dim Shared PIN_LOGIC As Type_PulseInLogic
Dim Shared POUT_MODE As Type_PulseOutMode
Dim Shared ALM_EN As Type_AlmEnable
Dim Shared ALM_LOGIC As Type_AlmLogic
Dim Shared ALM_MODE As Type_AlmReact
Dim Shared INP_EN As Type_InpEnable
Dim Shared INP_LOGIC As Type_InpLogic
Dim Shared ERC_LOGIC As Type_ErcLogic
Dim Shared ERC_EN As Type_ErcEnableMode
Dim Shared EL_EN As Type_ElEnable
Dim Shared EL_LOGIC As Type_ElLogic
Dim Shared EL_MODE As Type_ElReact
Dim Shared SNEL_EN As Type_SwMelEnable
Dim Shared SNEL_MODE As Type_SwMelReact
Dim Shared SNEL As Type_SwMelValue
Dim Shared SPEL_EN As Type_SwPelEnable
Dim Shared SPEL_MODE As Type_SwPelReact
Dim Shared SPEL As Type_SwPelValue
Dim Shared ORG_LOGIC As Type_OrgLogic
Dim Shared EZ_LOGIC As Type_EzLogic
Dim Shared BACKLASH_EN As Type_BacklashEnable
Dim Shared BACKLASH_PULSE As Type_BacklashPulses
Dim Shared LTC_LOGIC As Type_LatchLogic
Dim Shared LTC_EN As Type_LatchEnable
Dim Shared HOME_RESET As Type_HomeResetEnable
Dim Shared CMP_SRC As Type_CmpSrc
Dim Shared CMP_METHOD As Type_CmpMethod
Dim Shared CMP_MODE As Type_CmpPulseMode
Dim Shared CMP_LOGIC As Type_CmpPulseLogic
Dim Shared CMP_WIDTH As Type_CmpPulseWidth
Dim Shared CMP_EN As Type_CmpEnable
Dim Shared DO_EN As Type_GenDoEnable
Dim Shared EXT_SRC As Type_ExtMasterSrc
Dim Shared EXT_EN As Type_ExtSelEnable
Dim Shared EXT_PULSE As Type_ExtPulseNum
Dim Shared EXT_MODE As Type_ExtPulseInMode
Dim Shared EXT_PRESET As Type_ExtPresetNum
Dim Shared CAMDO_EN As Type_CamDOEnable
Dim Shared CAMDO_LPOS As Type_CamDOLoLimit
Dim Shared CAMDO_HPOS As Type_CamDOHiLimit
Dim Shared CAMDO_SRC As Type_CamDOCmpSrc
Dim Shared CAMDO_LOGIC As Type_CamDOLogic
Dim Shared MODULO As Type_ModuleRange
Dim Shared BACKLASH_VEL As Type_BacklashVel
Dim Shared PIN_MAXFREQ As Type_PulseInMaxFreq
Dim Shared STA_SRC As Type_SimStartSource
Dim Shared ORG_MODE As Type_OrgReact
Dim Shared IN1STOP_MODE As Type_IN1StopReact
Dim Shared IN1STOP_LOGIC As Type_IN1StopLogic
Dim Shared IN1STOP_EN As Type_IN1StopEnable
Dim Shared IN1STOP_EDGE As Type_IN1StopEdge
Dim Shared IN1STOP_OFFSET As Type_IN1Offset
Dim Shared IN2STOP_MODE As Type_IN2StopReact
Dim Shared IN2STOP_LOGIC As Type_IN2StopLogic
Dim Shared IN2STOP_EN As Type_IN2StopEnable
Dim Shared IN2STOP_EDGE As Type_IN2StopEdge
Dim Shared IN2STOP_OFFSET As Type_IN2Offset
Dim Shared IN4STOP_MODE As Type_IN4StopReact
Dim Shared IN4STOP_LOGIC As Type_IN4StopLogic
Dim Shared IN4STOP_EN As Type_IN4StopEnable
Dim Shared IN4STOP_EDGE As Type_IN4StopEdge
Dim Shared IN4STOP_OFFSET As Type_IN4Offset
Dim Shared IN5STOP_MODE As Type_IN5StopReact
Dim Shared IN5STOP_LOGIC As Type_IN5StopLogic
Dim Shared IN5STOP_EN As Type_IN5StopEnable
Dim Shared IN5STOP_EDGE As Type_IN5StopEdge
Dim Shared IN5STOP_OFFSET As Type_IN5Offset
Dim Shared LBUF_EN As Type_LatchBufEnable
Dim Shared LBUF_DIST As Type_LatchBufMinDist
Dim Shared LBUF_EVTNUM As Type_LatchBufEventNum
Dim Shared LBUF_SRC As Type_LatchBufSource
Dim Shared LBUF_ID As Type_LatchBufAxisID
Dim Shared LTC_EDGE As Type_LatchBufEdge		' yangfei,2016.06.03 rename
Dim Shared HOME_OFFSETDIST As Type_HomeOffsetDistance
Dim Shared HOME_OFFSETVEL As Type_HomeOffsetVel		' yf,2016.06.12 letter bug fix
Dim Shared UNIT_DENOM As Type_PPUDenominator
Dim Shared PEL_TOL_EN As Type_PelToleranceEnable
Dim Shared PEL_TOL As Type_PelToleranceValue
Dim Shared SPEL_TOL_EN As Type_SwPelToleranceEnable
Dim Shared SPEL_TOL As Type_SwPelToleranceValue
Dim Shared NEL_TOL_EN As Type_MelToleranceEnable
Dim Shared NEL_TOL As Type_MelToleranceValue
Dim Shared SNEL_TOL_EN As Type_SwMelToleranceEnable
Dim Shared SNEL_TOL As Type_SwMelToleranceValue
Dim Shared CMP_WIDTHEX As Type_CmpPulseWidthEx
Dim Shared ALM_FILTER As Type_ALMFilterTime
Dim Shared PEL_FILTER As Type_LMTPFilterTime
Dim Shared NEL_FILTER As Type_LMTNFilterTime
Dim Shared ORG_FILTER As Type_ORGFilterTime
Dim Shared IN1_FILTER As Type_IN1FilterTime
Dim Shared IN2_FILTER As Type_IN2FilterTime
Dim Shared IN4_FILTER As Type_IN4FilterTime
Dim Shared IN5_FILTER As Type_IN5FilterTime
Dim Shared POUT_REVERSE As Type_PulseOutReverse
Dim Shared INSTOP_DEC As Type_KillDec
Dim Shared FE_LIMIT As Type_MaxErrorCnt
Dim Shared JOG_VLTIME As Type_JogVLTime
Dim Shared JOG_VL As Type_JogVelLow
Dim Shared JOG_VH As Type_JogVelHigh
Dim Shared JOG_ACC As Type_JogAcc
Dim Shared JOG_DEC As Type_JogDec
Dim Shared JOG_JK As Type_JogJerk
Dim Shared DELAY As Type_PATH_DELAY
Dim Shared HOME_VL As Type_HOME_VL
Dim Shared HOME_VH As Type_HOME_VH
Dim Shared HOME_ACC As Type_HOME_ACC
Dim Shared HOME_DEC As Type_HOME_DEC
Dim Shared HOME_JK As Type_HOME_JK
Dim Shared HOME_CROSS As Type_HOME_CROSS
'yf,2016.06.16
Dim Shared GVL As Type_GVL
Dim Shared GVH As Type_GVH
Dim Shared GACC As Type_GACC
Dim Shared GDEC As Type_GDEC
Dim Shared GJK As Type_GJK
Dim Shared GSTATE As Type_GSTATE
Dim Shared GDSPEED As Type_GDSPEED
Dim Shared DSPEED As Type_DSPEED
Dim Shared GSPDFWD As Type_GpSpdFwd

'yf,2017.05.13
dim shared MCMP_EN AS Type_MCMP_EN
dim shared MCMP_CH AS Type_MCMP_CH
dim shared MCMP_LOGIC AS Type_MCMP_LOGIC
dim shared MCMP_WIDTH AS Type_MCMP_WIDTH
dim shared MCMP_DEVIA AS Type_MCMP_DEVIA 
dim shared MCMP_MODE AS Type_MCMP_MODE
dim shared MCMP_EMPTY AS Type_MCMP_EMPTY
dim shared MCMP_PWMFREQ AS Type_MCMP_PWMFREQ
dim shared MCMP_PWMDUTY AS Type_MCMP_PWMDUTY


For i As Ulong = 0 To MAXVR - 1 
	VR(i).id = i 
Next i
For i As Ulong = 0 To MAXTABLE - 1 
	TABLE(i).id = i 
Next i
For i As Ulong = 0 To MAXDO - 1 
	DOUT(i).id = i 
Next i
For i As Ulong = 0 To MAXDI - 1 
	DIN(i).id = i 
Next i
For i As UShort = 0 To MAXAX - 1 
	AX(i).id = i 
Next i

Declare Sub PATHLINK_INI overload(ByVal MasAxisNo As short, ByVal SYNINFO_SartVR As LONG, ByVal MasOffsetPos As double = 0, ByVal RefPoint_SartVR As LONG = -1, ByVal MAngle As double = 0.0,ByVal PAngle As double = 0.0)
Sub PATHLINK_INI overload(ByVal MasAxisNo As short, ByVal SYNINFO_SartVR As LONG, ByVal MasOffsetPos As double = 0, ByVal RefPoint_SartVR As LONG = -1, ByVal MAngle As double = 0.0,ByVal PAngle As double = 0.0)
Dim SynInfoArray(6) As double = {0.0,0.0,0.0,0.0,0.0,0.0,0.0}
Dim RefPointIniArray(3) As double = {0.0,0.0,0.0}
For Index As Integer = 0 to 5
	SynInfoArray(Index) = VR(SYNINFO_SartVR + Index)
	if(Index<=3) Then
		if(RefPoint_SartVR>=0) Then
			RefPointIniArray(Index) = VR(RefPoint_SartVR + Index)
		End If		
	End If
Next Index
ABAS_PathLinkInitial(MasAxisNo, SynInfoArray(0), MasOffsetPos, RefPointIniArray(0), PAngle, MAngle)
End Sub


Declare Sub PATHLINK_INI overload(ByVal MasAxisNo As Type_AX, ByVal SYNINFO_SartVR As LONG, ByVal MasOffsetPos As double = 0, ByVal RefPoint_SartVR As LONG = -1, ByVal MAngle As double = 0.0,ByVal PAngle As double = 0.0)
Sub PATHLINK_INI overload(ByVal MasAxisNo As Type_AX, ByVal SYNINFO_SartVR As LONG, ByVal MasOffsetPos As double = 0, ByVal RefPoint_SartVR As LONG = -1, ByVal MAngle As double = 0.0,ByVal PAngle As double = 0.0)
PATHLINK_INI(MasAxisNo.id, SYNINFO_SartVR, MasOffsetPos, RefPoint_SartVR, MAngle, PAngle)
End Sub

Declare Sub PATHLINK_BEGIN overload(ByVal MasAxisNo As short, ByVal PathLinkOption As ULONG = 0)
Sub PATHLINK_BEGIN overload(ByVal MasAxisNo As short, ByVal PathLinkOption As ULONG = 0)
	ABAS_PathLinkBegin(MasAxisNo, PathLinkOption)
End Sub

Declare Sub PATHLINK_BEGIN overload(ByVal MasAxisNo As Type_AX, ByVal PathLinkOption As ULONG = 0)
Sub PATHLINK_BEGIN overload(ByVal MasAxisNo As Type_AX, ByVal PathLinkOption As ULONG = 0)
	ABAS_PathLinkBegin(MasAxisNo.id, PathLinkOption)
End Sub

Declare Sub PATHLINK_END
Sub PATHLINK_END
	ABAS_PathLinkEnd
End Sub

Declare Sub PATHLINK_RESETBUF overload(ByVal MasAxisIndex as SHORT=-1)
Sub PATHLINK_RESETBUF overload(ByVal MasAxisIndex as SHORT=-1)
	ABAS_PATHLINK_RESETBUF(MasAxisIndex)
End Sub

Declare Sub PATHLINK_RESETBUF overload (ByVal MasAxisIndex as Type_AX)
Sub PATHLINK_RESETBUF overload(ByVal MasAxisIndex as Type_AX)
	PATHLINK_RESETBUF(MasAxisIndex.id)
End Sub

Declare Function PATHLINK_BUFSTATUS overload(ByVal MasAxisIndex as SHORT=-1) as ULONG
Function PATHLINK_BUFSTATUS overload(ByVal MasAxisIndex as SHORT=-1) as ULONG
	return ABAS_PATHLINK_BUFSTATUS(MasAxisIndex)
End Function

Declare Function PATHLINK_BUFSTATUS overload (ByVal MasAxisIndex as Type_AX) as ULONG
Function PATHLINK_BUFSTATUS overload (ByVal MasAxisIndex as Type_AX) as ULONG
	return PATHLINK_BUFSTATUS(MasAxisIndex.id)
End Function 

Declare Function PATHLINK_STATUS overload(ByVal MasAxisIndex as SHORT=-1) as ULONG
Function PATHLINK_STATUS overload(ByVal MasAxisIndex as SHORT=-1) as ULONG
	return ABAS_PATHLINK_STATUS(MasAxisIndex)
End Function 

Declare Function PATHLINK_STATUS overload(ByVal MasAxisIndex as Type_AX) as ULONG
Function PATHLINK_STATUS overload(ByVal MasAxisIndex as Type_AX) as ULONG
	return PATHLINK_STATUS(MasAxisIndex.id)
End Function 

Declare Sub PATHLINK_STOP overload(ByVal MasAxisNo As short = -1)
Sub PATHLINK_STOP(ByVal MasAxisNo As short = -1)
	ABAS_PathLinkStop(MasAxisNo)
End Sub

Declare Sub PATHLINK_STOP overload(ByVal MasAxisNo As Type_AX)
Sub PATHLINK_STOP(ByVal MasAxisNo As Type_AX)
ABAS_PathLinkStop(MasAxisNo.id)
End Sub

Declare SUB PATHLINK_SETBUF overload(ByVal MasAxisNo As short = -1, ByVal RefPoint_StartVR As long = -1, LatchData as double = 0.0)
Sub PATHLINK_SETBUF overload(ByVal MasAxisNo As short = -1, ByVal RefPoint_StartVR As long = -1, LatchData as double = 0.0)
Dim RefPointArray(3) As double = {0.0,0.0,0.0}
if(RefPoint_StartVR>=0) Then
For Index As Integer = 0 to 2		
		RefPointArray(Index) = VR(RefPoint_StartVR + Index)		
Next Index
End If
ABAS_PathLinkSetProcBuffer(MasAxisNo, RefPointArray(0), LatchData)
End Sub

Declare SUB PATHLINK_SETBUF overload(ByVal MasAxisNo As Type_AX, ByVal RefPoint_StartVR As long = -1, LatchData as double = 0.0)
Sub PATHLINK_SETBUF overload(ByVal MasAxisNo As Type_AX, ByVal RefPoint_StartVR As long = -1, LatchData as double = 0.0)
PATHLINK_SETBUF(MasAxisNo.id, RefPoint_StartVR, LatchData)
End Sub

Declare Sub  PATHLINK_RDYPOINT Overload(ByRef RdyPoint_X As double, ByRef RdyPoint_Y As double, ByVal Offset As double = 0)
Sub PATHLINK_RDYPOINT Overload(ByRef RdyPoint_X As double, ByRef RdyPoint_Y As double, ByVal Offset As double = 0)
	BAS_PathLinkGetReadyData(RdyPoint_X, RdyPoint_Y, Offset)
End Sub

Declare Sub  PATHLINK_RDYPOINT Overload(ByRef RdyPoint_X As Type_VR, ByRef RdyPoint_Y As Type_VR, ByVal Offset As double = 0)
Sub PATHLINK_RDYPOINT Overload(ByRef RdyPoint_X As Type_VR, ByRef RdyPoint_Y As Type_VR, ByVal Offset As double = 0)
	Dim As double point_x, point_y	
	BAS_PathLinkGetReadyData(point_x, point_y, Offset)
	Print point_x;point_y
	RdyPoint_X = point_x
	RdyPoint_Y = point_y
End Sub

'cyl
#define MAXCYL 1024
Type Type_CYL
	id As UShort
End Type

Dim Shared CYL(0 to MAXCYL -1) As Type_CYL
For i as ushort = LBOUND(CYL) to UBOUND(CYL)		'yf,2017.01.16 bug fix ,cyl not init
	CYL(i).id = i
next i

Declare Sub Cyl_Move Overload(dir1 as ushort = 0, dir2 as ushort = 0, dir3 as ushort = 0, dir4 as ushort = 0,dir5 as ushort = 0,dir6 as ushort = 0,dir7 as ushort = 0,dir8 as ushort = 0)
Sub Cyl_Move(dir1 as ushort = 0, dir2 as ushort = 0, dir3 as ushort = 0, dir4 as ushort = 0,dir5 as ushort = 0,dir6 as ushort = 0,dir7 as ushort = 0,dir8 as ushort = 0)
	ABAS_CylMove(-1, dir1, dir2, dir3, dir4, dir5, dir6, dir7, dir8)
End Sub

Declare Sub Cyl_Move Overload(cylID As Type_CYL, dir1 as ushort = 0)
Sub Cyl_Move(cylID As Type_CYL, dir1 as ushort = 0)
	ABAS_CylMove(cylID.id, dir1)
End Sub

'Declare Sub Cyl_Stop Overload(mode1 as ushort = 3, mode2 as ushort = 3, mode3 as ushort = 3, mode4 as ushort = 3, mode5 as ushort = 3,mode6 as ushort = 3,mode7 as ushort = 3,mode8 as ushort = 3)
'Sub Cyl_Stop(mode1 as ushort = 3, mode2 as ushort = 3, mode3 as ushort = 3, mode4 as ushort = 3, mode5 as ushort = 3,mode6 as ushort = 3,mode7 as ushort = 3,mode8 as ushort = 3)
'	ABAS_CylStop(-1, mode1, mode2, mode3, mode4, mode5, mode6, mode7, mode8)
'End Sub
'
'Declare Sub Cyl_Stop Overload(cylID As Type_CYL, mode1 as ushort = 3)
'Sub Cyl_Stop(cylID As Type_CYL, mode1 as ushort = 3)
'	ABAS_CylStop(cylID.id, mode1)
'End Sub
' yf,2017.02.10
Declare Sub Cyl_Stop Overload()
Sub Cyl_Stop()
	ABAS_CylStop(-1, 3, 3, 3, 3, 3, 3, 3, 3)
End Sub

Declare Sub Cyl_Stop Overload(cylID As Type_CYL)
Sub Cyl_Stop(cylID As Type_CYL)
	ABAS_CylStop(cylID.id, 3)
End Sub

Declare Sub Cyl_AlmReset Overload()
Sub Cyl_AlmReset()
	ABAS_CylStop(-1, 2, 2, 2, 2, 2, 2, 2, 2)
End Sub

Declare Sub Cyl_AlmReset Overload(cylID As Type_CYL)
Sub Cyl_AlmReset(cylID As Type_CYL)
	ABAS_CylStop(cylID.id, 2)
End Sub

Declare Function Cyl_Status Overload () as ulong
Function Cyl_Status() as ulong
	Return	ABAS_CylStatus(-1)
End Function

Declare Function Cyl_Status Overload(cylID As Type_CYL) as ulong
Function Cyl_Status(cylID As Type_CYL) as ulong
	Return	ABAS_CylStatus(cylID.id)
End Function

Type Type_CYL_FwTime
  value As Ulong
  Declare Operator Let ( ByRef rhs As Ulong )  
  Declare Operator Cast() As ulong
  Declare Operator Cast() As String
End Type
Operator Type_CYL_FwTime.let ( ByRef rhs As Ulong )
  value = rhs 
  ABAS_CylSetActionTime(-1, 0, value, value, value, value, value, value, value, value)		' mode = 0 as forward
End Operator
Operator Type_CYL_FwTime.cast () As ulong
	Return ABAS_CylGetActionTime(-1, 0)
End Operator
Operator Type_CYL_FwTime.cast () As String
  Return Str(ABAS_CylGetActionTime(-1, 0))
End Operator

Type Type_CYL_FwAlmTime
  value As Ulong
  Declare Operator Let ( ByRef rhs As Ulong )  
  Declare Operator Cast() As ulong
  Declare Operator Cast() As String
End Type
Operator Type_CYL_FwAlmTime.let ( ByRef rhs As Ulong )
  value = rhs 
  ABAS_CylSetAlmTime(-1, 0, value, value, value, value, value, value, value, value)
End Operator
Operator Type_CYL_FwAlmTime.cast () As ulong
	Return ABAS_CylGetAlmTime(-1, 0)
End Operator
Operator Type_CYL_FwAlmTime.cast () As String
  Return Str(ABAS_CylGetAlmTime(-1, 0))
End Operator

Type Type_CYL_FwDoneType
  value As Ulong
  Declare Operator Let (rhs As Ulong )  
  Declare Operator Cast() As ulong
  Declare Operator Cast() As String
End Type
Operator Type_CYL_FwDoneType.let (rhs As Ulong )
  value = rhs 
  ABAS_CylSetDoneType(-1, 0, value, value, value, value, value, value, value, value)
End Operator
Operator Type_CYL_FwDoneType.cast () As ulong
	Return ABAS_CylGetDoneType(-1, 0)
End Operator
Operator Type_CYL_FwDoneType.cast () As String
  Return Str(ABAS_CylGetDoneType(-1, 0))
End Operator

Type Type_CYL_FwEncValue
  value As Double
  Declare Operator Let (rhs As double )  
  Declare Operator Cast() As double
  Declare Operator Cast() As String
End Type
Operator Type_CYL_FwEncValue.let (rhs As double )
  value = rhs 
  ABAS_CylSetEncValue(-1, 0, value, value, value, value, value, value, value, value)
End Operator
Operator Type_CYL_FwEncValue.cast () As double
	Return ABAS_CylGetEncValue(-1, 0)
End Operator
Operator Type_CYL_FwEncValue.cast () As String
  Return Str(ABAS_CylGetEncValue(-1, 0))
End Operator

Type Type_CYL_BwTime
  value As Ulong
  Declare Operator Let (rhs As Ulong )  
  Declare Operator Cast() As ulong
  Declare Operator Cast() As String
End Type
Operator Type_CYL_BwTime.let (rhs As Ulong )
  value = rhs 
  ABAS_CylSetActionTime(-1, 1, value, value, value, value, value, value, value, value)		' mode = 1 as Backward
End Operator
Operator Type_CYL_BwTime.cast () As ulong
	Return ABAS_CylGetActionTime(-1, 1)
End Operator
Operator Type_CYL_BwTime.cast () As String
  Return Str(ABAS_CylGetActionTime(-1, 1))
End Operator

Type Type_CYL_BwAlmTime
  value As Ulong
  Declare Operator Let (rhs As Ulong )  
  Declare Operator Cast() As ulong
  Declare Operator Cast() As String
End Type
Operator Type_CYL_BwAlmTime.let (rhs As Ulong )
  value = rhs 
  ABAS_CylSetAlmTime(-1, 1, value, value, value, value, value, value, value, value)
End Operator
Operator Type_CYL_BwAlmTime.cast () As ulong
	Return ABAS_CylGetAlmTime(-1, 1)
End Operator
Operator Type_CYL_BwAlmTime.cast () As String
  Return Str(ABAS_CylGetAlmTime(-1, 1))
End Operator

Type Type_CYL_BwDoneType
  value As Ulong
  Declare Operator Let (rhs As Ulong )  
  Declare Operator Cast() As ulong
  Declare Operator Cast() As String
End Type
Operator Type_CYL_BwDoneType.let (rhs As Ulong )
  value = rhs 
  ABAS_CylSetDoneType(-1, 1, value, value, value, value, value, value, value, value)
End Operator
Operator Type_CYL_BwDoneType.cast () As ulong
	Return ABAS_CylGetDoneType(-1, 1)
End Operator
Operator Type_CYL_BwDoneType.cast () As String
  Return Str(ABAS_CylGetDoneType(-1, 1))
End Operator

Type Type_CYL_BwEncValue
  value As Double
  Declare Operator Let (rhs As double )  
  Declare Operator Cast() As double
  Declare Operator Cast() As String
End Type
Operator Type_CYL_BwEncValue.let (rhs As double )
  value = rhs 
  ABAS_CylSetEncValue(-1, 1, value, value, value, value, value, value, value, value)
End Operator
Operator Type_CYL_BwEncValue.cast () As double
	Return ABAS_CylGetEncValue(-1, 1)
End Operator
Operator Type_CYL_BwEncValue.cast () As String
  Return Str(ABAS_CylGetEncValue(-1, 1))
End Operator

Dim Shared CYL_FwTime As Type_CYL_FwTime
Dim Shared CYL_BwTime As Type_CYL_BwTime
Dim Shared CYL_FwAlmTime As Type_CYL_FwAlmTime
Dim Shared CYL_BwAlmTime As Type_CYL_BwAlmTime
Dim Shared CYL_FwDoneType As Type_CYL_FwDoneType
Dim Shared CYL_BwDoneType As Type_CYL_BwDoneType
Dim Shared CYL_FwEncValue As Type_CYL_FwEncValue
Dim Shared CYL_BwEncValue As Type_CYL_BwEncValue

Declare Function ParseStr(inputStr as string, outputArray() As string, delimits as string) As Ulong
Function ParseStr(inputStr as string, outputArray() As string, delimits as string) As Ulong
	 dim as ulong sIndex = 0
	 dim as ulong numCnt = 0
	 dim as ulong delCnt = len(delimits)
	 dim as ULONG lowIndex = LBOUND(outputArray)
	 'print "lowIndex = ", lowIndex
	 dim as INTEGER isAddLast = 0
	 sIndex = Instr(inputStr, delimits)
	 dim as string mStr
	 mStr = inputStr
	 
	 while(sIndex > 0)
	 		if (sIndex - 1) > 0 then
				IF(Ubound(outputArray) >= (lowIndex + numCnt)) then 
					outputArray(lowIndex + numCnt) = left(mStr, sIndex - 1)
					numCnt = numCnt+1
				else
					exit WHILE
				end if
	 		end if
	 		if(sIndex+delCnt) > len(mStr) then
				isAddLast = 1
	 			exit WHILE
	 		end if
	 		dim as string temp = Mid(mStr, sIndex+delCnt)
			'print "sIndex+delCnt = ", sIndex+delCnt
	 		mStr = temp
			'print "mStr = ", mStr
	 		sIndex = Instr(mStr, delimits)
			'print "sIndex = ", sIndex
	 wend
	 if isAddLast < 1 or sIndex = 0 THEN
		IF(Ubound(outputArray) >= (lowIndex + numCnt)) THEN
			outputArray(lowIndex + numCnt)=mStr
			numCnt = numCnt+1
		end if
	 end IF
	 return numCnt
End Function  

Declare Function GetFilesCnt overload(mextension as zstring ptr = 0, isFullName as ulong = 0, pathName as zstring ptr = 0) As Ulong 
Function GetFilesCnt overload(mextension as zstring ptr = 0, isFullName as ulong = 0, pathName as zstring ptr = 0) As Ulong
		return BAS_GetFiles(pathName , mextension, isFullName)
End Function  

Declare Function GetFileName(fileIndex as ulong) As String
Function GetFileName(fileIndex as ulong) As String
	return *BAS_GetFile(fileIndex)
End Function

Declare Function VRToStr(vrstart as ulong, vrcnt as ulong = 0) As String
Function VRToStr(vrstart as ulong, vrcnt as ulong = 0) As String
		return *BAS_VRToStr(vrstart, vrcnt)
End Function

Declare Sub File_Import(sPath as zstring ptr , dPath as zstring ptr = 0)
Sub File_Import(sPath as zstring ptr , dPath as zstring ptr = 0)
	BAS_FilesCopy(sPath, dPath)
end sub

Declare Sub File_Export(dPath as zstring ptr , sPath as zstring ptr = 0)
Sub File_Export(dPath as zstring ptr , sPath as zstring ptr = 0)
	BAS_FilesCopy(sPath, dPath)
end sub

Declare Sub VRShift(sVr as ulong, cnt as ulong, shiftCnt as long)						'yf,2017.05.22 
Sub VRShift(sVr as ulong, cnt as ulong, shiftCnt as long)
	VRCopy(sVr, sVr + shiftCnt , cnt)
	VRClear(sVr, cnt)
end sub

Declare Function File_Find(fileList() as string , fileName as string) as LONG
Function File_Find(fileList() as string , fileName as string) as long
	dim fileIndex as long = -1
	for i as integer = LBound(fileList) to UBound(fileList)
		if fileList(i) = fileName then
			fileIndex = i
			exit for
		end if 
	next i
	return fileIndex
end function

'WAIT
Declare Sub WAIT Overload (ByVal Mode As Short)
Sub WAIT  (ByVal Mode As Short)
	 ABAS_WAIT( -1, Mode)
End Sub
Declare Sub WAIT Overload (ByVal AxisID As Type_AX, ByVal Mode As Short)
Sub WAIT (ByVal AxisID As Type_AX, ByVal Mode As Short)
	 ABAS_WAIT( AxisID.id, Mode)
End Sub
Declare Sub WAIT Overload (cylId As Type_CYL, ByVal Mode As Short)
Sub WAIT (cylId As Type_CYL, ByVal Mode As Short)
	 ABAS_WAIT( cylId.id, Mode)
End Sub


'CACELWAIT
Declare Sub CANCELWAIT Overload (ByVal Mode As Short)
Sub CANCELWAIT  (ByVal Mode As Short)
	 ABAS_CancelWait( -1, Mode)
End Sub
Declare Sub CANCELWAIT Overload (ByVal AxisID As Type_AX, ByVal Mode As Short)
Sub CANCELWAIT (ByVal AxisID As Type_AX, ByVal Mode As Short)
	 ABAS_CancelWait( AxisID.id, Mode)
End Sub
Declare Sub CANCELWAIT Overload (cylId As Type_CYL, ByVal Mode As Short)
Sub CANCELWAIT (cylId As Type_CYL, ByVal Mode As Short)
	 ABAS_CancelWait( cylId.id, Mode)
End Sub

Declare Sub PATH_STATUS( byref remainCnt as ulong, byref freeSpaceCnt as ulong , byref curIndex as ulong = 0  , byref curCmd as ulong  = 0)
Sub PATH_STATUS(byref remainCnt as ulong, byref freeSpaceCnt as ulong , byref curIndex as ulong = 0  , byref curCmd as ulong  = 0)
	dim as ulong i = 0, j = 0, k = 0, m = 0
	BAS_PATHSTATUS(@i, @j , @k, @m)
	remainCnt = k
	freeSpaceCnt = m
	curIndex = i
	curCmd = j
End Sub

Declare Sub CMPSETDO OVERLOAD(ax as Type_AX, onOrOff as ulong)
sub CMPSETDO(ax as Type_AX, onOrOff as ulong)
	BAS_CMP_SetDo(ax.id, onOrOff)
end sub

Declare Function XYZTOYBC OVERLOAD(x() as const double, y() as const double, z() as const double, r() as const double, xyzCnt as ulong , feed() as double, rotate() as double, bend() as double, rybc() as double , ybcCnt as ulong) As Ulong
Function XYZTOYBC(x() as const double, y() as const double, z() as const double, r() as const double, xyzCnt as ulong , feed() as double, rotate() as double, bend() as double, rybc() as double , ybcCnt as ulong) As Ulong
	return BAS_XYZToYBC(@x(0), @y(0), @z(0), @r(0), xyzCnt, @feed(0), @rotate(0), @bend(0), @rybc(0), ybcCnt)
END Function

Declare Function YBCTOXYZ OVERLOAD(feed() as const double, rotate() as const double, bend() as const double, rybc() as const double, ybcCnt as ulong , x() as double, y() as double, z() as double, rxyz() as double , xyzCnt as ulong) As Ulong
Function YBCTOXYZ(feed() as const double, rotate() as const double, bend() as const double, rybc() as const double, ybcCnt as ulong , x() as double, y() as double, z() as double, rxyz() as double , xyzCnt as ulong) As Ulong
	return BAS_YBCToXYZ(@feed(0), @rotate(0), @bend(0), @rybc(0), ybcCnt, @x(0), @y(0), @z(0), @rxyz(0), xyzCnt)
END Function
Declare Sub MCMPPWMTIMETABLE(pwmTimeTable() as const ulong, cnt as ulong)
Sub MCMPPWMTIMETABLE(pwmTimeTable() as const ulong, cnt as ulong)
	BAS_MCMPPWMTIMETABLE(@pwmTimeTable(0), cnt)
END Sub
Type Type_EMG_LOGIC
		value As Ulong
    Declare Operator Let (emgLogic As ulong) 
    Declare Operator Cast() As ulong
    Declare Operator Cast() As String
End Type
Operator Type_EMG_LOGIC.let (emgLogic As Ulong )
  BAS_SetEmgLogic(emgLogic)
End Operator
Operator Type_EMG_LOGIC.cast () As ulong
	Return BAS_GetEmgLogic()
End Operator
Operator Type_EMG_LOGIC.cast () As String
  Return Str(BAS_GetEmgLogic())
End Operator

Type Type_EMG_Filter
		value As Ulong
    Declare Operator Let (emgFilter As ulong) 
    Declare Operator Cast() As ulong
    Declare Operator Cast() As String
End Type
Operator Type_EMG_Filter.let (emgFilter As Ulong )
  BAS_SetEmgFilter(emgFilter)
End Operator
Operator Type_EMG_Filter.cast () As ulong
	Return BAS_GetEmgFilter()
End Operator
Operator Type_EMG_Filter.cast () As String
  Return Str(BAS_GetEmgFilter())
End Operator

Dim Shared EMG_LOGIC As Type_EMG_LOGIC
Dim Shared EMG_Filter As Type_EMG_Filter

Type Type_MCMP_PWM_MAX_FREQ
		value As Ulong
    Declare Operator Let (frequency As ulong) 
    Declare Operator Cast() As ulong
    Declare Operator Cast() As String
End Type
Operator Type_MCMP_PWM_MAX_FREQ.let (frequency As Ulong )
  BAS_SetMCMPMaxPWMFreq(frequency)
End Operator
Operator Type_MCMP_PWM_MAX_FREQ.cast () As ulong
	Return BAS_GetMCMPMaxPWMFreq()
End Operator
Operator Type_MCMP_PWM_MAX_FREQ.cast () As String
  Return Str(BAS_GetMCMPMaxPWMFreq())
End Operator

Type Type_MCMP_PWM_MIN_FREQ
		value As Ulong
    Declare Operator Let (frequency As ulong) 
    Declare Operator Cast() As ulong
    Declare Operator Cast() As String
End Type
Operator Type_MCMP_PWM_MIN_FREQ.let (frequency As Ulong )
  BAS_SetMCMPMinPWMFreq(frequency)
End Operator
Operator Type_MCMP_PWM_MIN_FREQ.cast () As ulong
	Return BAS_GetMCMPMinPWMFreq()
End Operator
Operator Type_MCMP_PWM_MIN_FREQ.cast () As String
  Return Str(BAS_GetMCMPMinPWMFreq())
End Operator

Type Type_MCMP_PWM_MAX_DUTY
		value As Double
    Declare Operator Let (duty As Double) 
    Declare Operator Cast() As Double
    Declare Operator Cast() As String
End Type
Operator Type_MCMP_PWM_MAX_DUTY.let (duty As Double )
  BAS_SetMCMPMaxPWMDuty(duty)
End Operator
Operator Type_MCMP_PWM_MAX_DUTY.cast () As Double
	Return BAS_GetMCMPMaxPWMDuty()
End Operator
Operator Type_MCMP_PWM_MAX_DUTY.cast () As String
  Return Str(BAS_GetMCMPMaxPWMDuty())
End Operator

Type Type_MCMP_PWM_MIN_DUTY
		value As Double
    Declare Operator Let (duty As Double) 
    Declare Operator Cast() As Double
    Declare Operator Cast() As String
End Type
Operator Type_MCMP_PWM_MIN_DUTY.let (duty As Double )
  BAS_SetMCMPMinPWMDuty(duty)
End Operator
Operator Type_MCMP_PWM_MIN_DUTY.cast () As Double
	Return BAS_GetMCMPMinPWMDuty()
End Operator
Operator Type_MCMP_PWM_MIN_DUTY.cast () As String
  Return Str(BAS_GetMCMPMinPWMDuty())
End Operator

Type Type_PWM_LINKEN
		value As Ulong
    Declare Operator Let (enable As ulong) 
    Declare Operator Cast() As ulong
    Declare Operator Cast() As String
End Type
Operator Type_PWM_LINKEN.let (enable As Ulong )
  BAS_SetPWMLinkVelEn(enable)
End Operator
Operator Type_PWM_LINKEN.cast () As ulong
	Return BAS_GetPWMLinkVelEn()
End Operator
Operator Type_PWM_LINKEN.cast () As String
  Return Str(BAS_GetPWMLinkVelEn())
End Operator

Type Type_PWM_MODE
		value As Ulong
    Declare Operator Let (mode As ulong) 
    Declare Operator Cast() As ulong
    Declare Operator Cast() As String
End Type
Operator Type_PWM_MODE.let (mode As Ulong )
  BAS_SetPWMMonitorMode(mode)
End Operator
Operator Type_PWM_MODE.cast () As ulong
	Return BAS_GetPWMMonitorMode()
End Operator
Operator Type_PWM_MODE.cast () As String
  Return Str(BAS_GetPWMMonitorMode())
End Operator

Type Type_PWM_REF_V
		value As Ulong
    Declare Operator Let (velocity As double) 
    Declare Operator Cast() As double
    Declare Operator Cast() As String
End Type
Operator Type_PWM_REF_V.let (velocity As double )
  BAS_SetPWMRefVel(velocity)
End Operator
Operator Type_PWM_REF_V.cast () As double
	Return BAS_GetPWMRefVel()
End Operator
Operator Type_PWM_REF_V.cast () As String
  Return Str(BAS_GetPWMRefVel())
End Operator

Dim shared MCMP_PWMMAXFREQ as Type_MCMP_PWM_MAX_FREQ
Dim shared MCMP_PWMMINFREQ as Type_MCMP_PWM_MIN_FREQ
Dim shared MCMP_PWMMAXDUTY as Type_MCMP_PWM_MAX_DUTY
Dim shared MCMP_PWMMINDUTY as Type_MCMP_PWM_MIN_DUTY
Dim shared GPWM_LINKEN as Type_PWM_LINKEN
Dim shared GPWM_MODE as Type_PWM_MODE
Dim shared GPWM_REFVEL as Type_PWM_REF_V

