#include <F2837xD_Device.h>
void Gpio_Select1();
void InitSystem();
void SetPwmModules();
void InitPwmModules(void);

//interrupt void cpu_timer0_isr(void);
__interrupt void cpu_timer0_isr(void);
__interrupt void cpu_timer1_isr(void);
__interrupt void cpu_timer2_isr(void);
__interrupt void epwm1_isr(void);

int main(void)
{

    InitSysCtrl();// first link F2837xD_SysCtrl.c

    InitPieCtrl();// first link F2837xD_PieCtrl.c
    IER = 0x0000;
    IFR = 0x0000;
    //PieVectTable.TIMER0_INT = &cpu_timer0_isr;
    InitPieVectTable();
    Gpio_Select1();
    EALLOW;  // This is needed to write to EALLOW protected registers
    PieVectTable.TIMER0_INT = &cpu_timer0_isr;
    PieVectTable.TIMER1_INT = &cpu_timer1_isr;
    PieVectTable.TIMER2_INT = &cpu_timer2_isr;
    PieVectTable.EPWM1_INT = &epwm1_isr;
    EDIS;
    InitCpuTimers();   // For this example, only initialize the Cpu Timers
    ConfigCpuTimer(&CpuTimer0, 200, 1000); //2 miliseconds
    ConfigCpuTimer(&CpuTimer1, 200, 1000000); //2 seconds
    ConfigCpuTimer(&CpuTimer2, 200, 1000000); //2 seconds

    EALLOW;
    CpuSysRegs.PCLKCR0.bit.TBCLKSYNC =0;

    EDIS;
    //CpuTimer0Regs.PRD.all = 0xFFFFFFFF;
    CpuTimer0Regs.TCR.all = 0x4000; // Use write-only instruction to set TSS bit = 0
    CpuTimer1Regs.TCR.all = 0x4000; // Use write-only instruction to set TSS bit = 0
    CpuTimer2Regs.TCR.all = 0x4000; // Use write-only instruction to set TSS bit = 0
    IER |= M_INT1;
    IER |= M_INT13;
    IER |= M_INT14;
    PieCtrlRegs.PIEIER1.bit.INTx7 = 1;
    EINT;  // Enable Global interrupt INTM
    ERTM;  // Enable Global realtime interrupt DBGM

    EALLOW;
    WdRegs.WDCR.all = 0x0028;//set the watch dog
    EDIS;
    while(1)
    {
        while(!CpuTimer0.InterruptCount)
        {}
        WdRegs.WDKEY.all = 0x55;// serve to watchdog
        CpuTimer0.InterruptCount = 0;

    }

}

void Gpio_Select1()
{
    EALLOW;
    GpioCtrlRegs.GPAMUX1.all = 0;
    GpioCtrlRegs.GPAMUX2.all = 0;
    GpioCtrlRegs.GPAGMUX1.all = 0;
    GpioCtrlRegs.GPAGMUX2.all = 0;

    GpioCtrlRegs.GPBMUX1.all = 0;
    GpioCtrlRegs.GPBMUX2.all = 0;
    GpioCtrlRegs.GPBGMUX1.all = 0;
    GpioCtrlRegs.GPBGMUX2.all = 0;

    GpioCtrlRegs.GPCMUX1.all = 0;
    GpioCtrlRegs.GPCMUX2.all = 0;
    GpioCtrlRegs.GPCGMUX1.all = 0;
    GpioCtrlRegs.GPCGMUX2.all = 0;

    GpioCtrlRegs.GPDMUX1.all = 0;
    GpioCtrlRegs.GPDMUX2.all = 0;
    GpioCtrlRegs.GPDGMUX1.all = 0;
    GpioCtrlRegs.GPDGMUX2.all = 0;

    GpioCtrlRegs.GPEMUX1.all = 0;
    GpioCtrlRegs.GPEMUX2.all = 0;
    GpioCtrlRegs.GPEGMUX1.all = 0;
    GpioCtrlRegs.GPEGMUX2.all = 0;

    GpioCtrlRegs.GPFMUX1.all = 0;
    GpioCtrlRegs.GPFMUX2.all = 0;
    GpioCtrlRegs.GPFGMUX1.all = 0;
    GpioCtrlRegs.GPFGMUX2.all = 0;

    GpioCtrlRegs.GPAPUD.bit.GPIO31 = 0; // enable pull up
    GpioDataRegs.GPASET.bit.GPIO31 = 1; // Load output latch. Recommended in rm
    GpioCtrlRegs.GPADIR.bit.GPIO31 = 1; // set it as output

    GpioCtrlRegs.GPBPUD.bit.GPIO34 = 0; // enable pull up
    GpioDataRegs.GPBSET.bit.GPIO34 = 1; // Load output latch. Recommended in rm
    GpioCtrlRegs.GPBDIR.bit.GPIO34 = 1; // set it as output
    GpioDataRegs.GPASET.bit.GPIO31 = 1;
    GpioDataRegs.GPBCLEAR.bit.GPIO34 = 1;




    EDIS;

    /*TODO pullup settings can be done here*/
    /***************************************/

}
void InitSystem(void)
{
    EALLOW;
    WdRegs.WDCR.all = 0x0028;         // Watchdog enabled, 4.3 milliseconds
    CpuSysRegs.PCLKCR0.bit.CPUTIMER0 = 1; //enable cputimer0
    EDIS;
}
__interrupt void cpu_timer0_isr(void)
{
   CpuTimer0.InterruptCount++;
   WdRegs.WDKEY.all = 0xAA;

   // Acknowledge this interrupt to receive more interrupts from group 1
   PieCtrlRegs.PIEACK.all = PIEACK_GROUP1;
}

__interrupt void cpu_timer1_isr(void)
{
   CpuTimer1.InterruptCount++;
   // The CPU acknowledges the interrupt.
   //GpioDataRegs.GPBTOGGLE.bit.GPIO34 = 1;

}

__interrupt void cpu_timer2_isr(void)
{
   CpuTimer2.InterruptCount++;
   // The CPU acknowledges the interrupt.
   GpioDataRegs.GPATOGGLE.bit.GPIO31 = 1;

}
void SetPwmModules(void)
{
    CpuSysRegs.PCLKCR2.bit.EPWM1=1; //Enable EWM1 clock

    EALLOW;
    GpioCtrlRegs.GPAPUD.bit.GPIO0 = 1; //disable pull up
    GpioCtrlRegs.GPAPUD.bit.GPIO1 = 1; //disable pull up

    GpioCtrlRegs.GPAMUX1.bit.GPIO0 = 1;//Configure GPIO0 as EPWM1A
    GpioCtrlRegs.GPAMUX1.bit.GPIO1 = 1;//Configure GPIO1 as EPWM1B
    EDIS;
}

__interrupt void epwm1_isr(void)
{
    GpioDataRegs.GPBTOGGLE.bit.GPIO34 = 1;

    // Clear INT flag for this timer
    EPwm1Regs.ETCLR.bit.INT = 1;
    // Acknowledge this interrupt to receive more interrupts from group 3
    PieCtrlRegs.PIEACK.all = PIEACK_GROUP3;
}
void InitPwmModules(void)
{
    EPwm1Regs.TBCTL.bit.PHSDIR = 1;
    EPwm1Regs.TBPRD = 39000;
    EPwm1Regs.TBCTL.bit.PHSEN = 0;    // Disable phase loading
    EPwm1Regs.TBPHS.half.TBPHS = 0;       // Phase is 0
    EPwm1Regs.TBCTR = 0x0000;                  // Clear counter
    EPwm1Regs.TBCTL.bit.CLKDIV = 7;  //TBCLOK = EPWMCLOCK/(128*10) = 78125Hz
    EPwm1Regs.TBCTL.bit.HSPCLKDIV = 5;


    EPwm1Regs.CMPCTL.bit.SHDWAMODE = 0;
    EPwm1Regs.CMPCTL.bit.SHDWBMODE = 0;

    EPwm1Regs.CMPA.half.CMPA = 20000;    // Set compare A value
    EPwm1Regs.CMPB.half.CMPB = 20000;              // Set Compare B value


}
