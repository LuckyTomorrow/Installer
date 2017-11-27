using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using MSConnection;
using System.Threading;
using System.Windows.Forms;
using System.Drawing;

namespace MSTest
{
    public enum SystemCommand : int
    {
        Step_Count = 3,
        H_BtnType = 7,
        CS_WarnId = 8,
        CS_ErrorId = 9,
        CR_JogAxId = 33
    }

    public enum UserCommand : int
    {
        Point_Num = 0,
        Current_Point = 1,
        AX0_SVON = 10,
        AX1_SVON =11,

        Run_btn = 34,
        Pause_btn = 35,
        Step_btn = 36,
        Resume_btn = 37,
        Home_btn = 38,
        Teach_btn = 39,
        Dbg_btn = 40
    }
    public enum AxPosition : int
    {
        PointX1 = 0,
        PointY1 = 2,
        PointX2 = 4,
        PointY2 = 6,
        PointX3 = 8,
        PointY3 = 10,
        PointX4 = 12,
        PointY4 = 14
    }
    public enum btnType : ushort
    {
        Run = 1,
        Pause = 2,
        Resume = 3,
        Step = 4,
        Stop = 5,
        Home = 6,
        JogAxPos = 7,
        JogAxNeg = 8,
        JogAxStop = 9,
        ResetErr = 10,
        Org = 11,
        SvOn = 12,
        SvOff = 13,

        Teach_P1 = 20,
        Teach_P2 = 21,
        Teach_P3 = 22,
        Teach_P4 = 23,

        PtP_P1 = 24,
        PtP_P2 = 25,
        PtP_P3 = 26,
        PtP_P4 = 27
    }
    public class ModBusClient
    {
        //Open the modbus communication
       public static MSClient Wrapper = new MSClient("127.0.0.1");

        public short[] VRSysList = new short[50];
        public ushort[] VRUserList = new ushort[50];
        public float[] F_VRList = new float[8];

        public const int SysStartAddr = 40001;
        public const int AxPosStartAddr = 40052;
        public const int UserStartAddr = 40152;

        public short GetSysCmd(int VRIndex)
        {
            int VRLength = 50;
            VRSysList=Wrapper.ReadList_I16(VRLength, SysStartAddr);
            if (VRSysList.Length == 0)
            {
                return 0;
            }
            return VRSysList[VRIndex];
        }

        public bool SetSysCmd(int VRIndex,short VRData)
        {
            if (Wrapper.CheckStatus() == true)
            {
                bool Result;
                int VRLength = 1;
                VRSysList[VRIndex] = VRData;
                Result = Wrapper.WriteList_I16(VRSysList, VRIndex, SysStartAddr + VRIndex, VRLength);
                return Result;
            }
            return false;

        }

        public  float[] GetAxTeachPos(int VRIndex)
        {
            int VRLength = 8;
            F_VRList = Wrapper.ReadList_F32( VRLength, AxPosStartAddr + VRIndex);
            return F_VRList;    
        }

        public bool SetAxTeachPos(int VRIndex,float[] VRTeachPosList)
        {
            if (Wrapper.CheckStatus() == true)
            {
                bool Result;
                int VRLength = 8;
                int index = 0;
                Result= Wrapper.WriteList_F32(VRTeachPosList, index, AxPosStartAddr + VRIndex, VRLength);
                return Result;
            }
            return false;


        }
        public ushort GetUserCmd(int VRIndex)
        {
            int VRLength = 50;
            VRUserList = Wrapper.ReadList_U16(VRLength, UserStartAddr);
            if (VRUserList.Length == 0)
            {
                return 0;
            }
            return VRUserList[VRIndex];
        }


        //Get the state of axis
        public  void GetAxState(TextBox a, int AxIndex)
        {
            switch (Wrapper.GetAxState(AxIndex))
            {
                case 0:
                    a.Text = "Disable";
                    a.BackColor = Color.Red;
                    break;
                case 1:
                    a.Text = "Ready";
                    a.BackColor = Color.Lime;
                    break;
                case 2:
                    a.Text = "Stopping";
                    a.BackColor = Color.Gray;
                    break;
                case 3:
                    a.Text = "Error";
                    a.BackColor = Color.Red;
                    break;
                case 4:
                    a.Text = "Homing";
                    a.BackColor = Color.Lime;
                    break;
                case 5:
                    a.Text = "PTP Driving";
                    a.BackColor = Color.Lime;
                    break;
                case 6:
                    a.Text = "Continus Driving";
                    a.BackColor = Color.Lime;
                    break;
                case 7:
                    a.Text = "Group interpolation motion";
                    a.BackColor = Color.Lime;
                    break;
                case 8:
                    a.Text = "JOG mode motion";
                    a.BackColor = Color.Gray;
                    break;
                case 9:
                    a.Text = "MPG mode motion";
                    a.BackColor = Color.Gray;
                    break;
            }
        }

        //Get the warning and wrong information
        public void GetErrAndWrong(TextBox Warning,TextBox Wrong)
        {
            //warning
            switch (GetSysCmd((int)SystemCommand.CS_WarnId))
            {
                case 0:
                    Warning.Text = "Success";
                    Warning.BackColor = Color.Lime;
                    break;
                case 1:
                    Warning.Text = "No Command";
                    Warning.BackColor = Color.Red;
                    break;
                case 2:
                    Warning.Text = "Invalid Operation";
                    Warning.BackColor = Color.Red;
                    break;
                case 3:
                    Warning.Text = "Home Not Finish";
                    Warning.BackColor = Color.Red;
                    break;
                case 4:
                    Warning.Text = "Not Finish";
                    Warning.BackColor = Color.Red;
                    break;
                case 5:
                    Warning.Text = "Unkonow Command";
                    Warning.BackColor = Color.Red;
                    break;
            }

            //wrong
            switch (GetSysCmd((int)SystemCommand.CS_ErrorId))
            {
                case 0:
                    Wrong.Text = "Success";
                    Wrong.BackColor = Color.Lime;
                    break;
                case 1:
                    Wrong.Text = "Axis Error";
                    Wrong.BackColor = Color.Red;
                    break;
                case 2:
                    Wrong.Text = "Axis AlmError";
                    Wrong.BackColor = Color.Red;
                    break;
                case 3:
                    Wrong.Text = "Axis PelError";
                    Wrong.BackColor = Color.Red;
                    break;
                case 4:
                    Wrong.Text = "Axis NelError";
                    Wrong.BackColor = Color.Red;
                    break;
                case 5:
                    Wrong.Text = "Axis EmgError";
                    Wrong.BackColor = Color.Red;
                    break;
            }
        }

    }

    
}
