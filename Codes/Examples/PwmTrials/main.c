#include <F2837xD_Device.h>
#include <math.h>

void Gpio_Select1();
void InitSystem();
void InitEpwm1();
void InitECapModules();

//interrupt void cpu_timer0_isr(void);
__interrupt void cpu_timer0_isr(void);
__interrupt void cpu_timer1_isr(void);
__interrupt void cpu_timer2_isr(void);
__interrupt void epwm1_isr(void);
__interrupt void ecap4_isr(void);

int iCTRPeriod=0;
int iCTRDutyCycle=0;
int iECap1IntCount=0;

int main(void)
{

    InitSysCtrl();// first link F2837xD_SysCtrl.c

    CpuSysRegs.PCLKCR2.bit.EPWM1 = 1;/*enable clock for epwm1*/
    EALLOW;
    CpuSysRegs.PCLKCR0.bit.TBCLKSYNC =0;

    EDIS;
    Gpio_Select1();
    EALLOW;
    GpioCtrlRegs.GPAPUD.bit.GPIO0 = 1;    // Disable pull-up on GPIO0 (EPWM1A)
    GpioCtrlRegs.GPAPUD.bit.GPIO1 = 1;    // Disable pull-up on GPIO1 (EPWM1B)
    GpioCtrlRegs.GPAMUX1.bit.GPIO0 = 1;   // Configure GPIO0 as EPWM1A
    GpioCtrlRegs.GPAMUX1.bit.GPIO1 = 1;     // Configure GPIO1 as EPWM1B
    EDIS;
    DINT; //disable the interrupts

    InitPieCtrl();// first link F2837xD_PieCtrl.c
    IER = 0x0000;
    IFR = 0x0000;
    //PieVectTable.TIMER0_INT = &cpu_timer0_isr;
    InitPieVectTable();

    EALLOW;  // This is needed to write to EALLOW protected registers
    PieVectTable.TIMER0_INT = &cpu_timer0_isr;
    PieVectTable.TIMER1_INT = &cpu_timer1_isr;
    PieVectTable.TIMER2_INT = &cpu_timer2_isr;
    PieVectTable.EPWM1_INT = &epwm1_isr;
    PieVectTable.ECAP4_INT = &ecap4_isr;
    EDIS;
    InitECapModules();

    InitCpuTimers();   // For this example, only initialize the Cpu Timers
    ConfigCpuTimer(&CpuTimer0, 200, 1000); //2 miliseconds
    ConfigCpuTimer(&CpuTimer1, 200, 1000000); //2 seconds
    ConfigCpuTimer(&CpuTimer2, 200, 1000000); //2 seconds
    InitEpwm1();


    //CpuTimer0Regs.PRD.all = 0xFFFFFFFF;
    CpuTimer0Regs.TCR.all = 0x4000; // Use write-only instruction to set TSS bit = 0
    CpuTimer1Regs.TCR.all = 0x4000; // Use write-only instruction to set TSS bit = 0
    CpuTimer2Regs.TCR.all = 0x4000; // Use write-only instruction to set TSS bit = 0
    IER |= M_INT1;
    IER |= M_INT3;
    IER |= M_INT4;
    IER |= M_INT13;
    IER |= M_INT14;
    PieCtrlRegs.PIEIER1.bit.INTx7 = 1;
    PieCtrlRegs.PIEIER3.bit.INTx1 = 1;
    PieCtrlRegs.PIEIER4.bit.INTx4 = 1;//enable interrupt for ecap4

    EINT;  // Enable Global interrupt INTM
    ERTM;  // Enable Global realtime interrupt DBGM
    EALLOW;
    CpuSysRegs.PCLKCR0.bit.TBCLKSYNC =1;

    EDIS;
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
   // GpioDataRegs.GPBTOGGLE.bit.GPIO34 = 1;

}

__interrupt void cpu_timer2_isr(void)
{
   CpuTimer2.InterruptCount++;
   // The CPU acknowledges the interrupt.
   GpioDataRegs.GPATOGGLE.bit.GPIO31 = 1;

}
__interrupt void epwm1_isr(void)
{
    // Update the CMPA and CMPB values
    //update_compare(&epwm1_info);
    // Clear INT flag for this timer
    EPwm1Regs.ETCLR.bit.INT = 1;
    GpioDataRegs.GPBTOGGLE.bit.GPIO34 = 1;
    if(EPwm1Regs.CMPA.half.CMPA>=45000)
        EPwm1Regs.CMPA.half.CMPA=0;    // Set compare A value
    else
        EPwm1Regs.CMPA.half.CMPA+=1000;

    // Acknowledge this interrupt to receive more interrupts from group 3
    PieCtrlRegs.PIEACK.all = PIEACK_GROUP3;
}
void InitEpwm1(void)
{
    EPwm1Regs.TBPRD = 50000;
    EPwm1Regs.TBPHS.half.TBPHS = 0x0000;          // Phase is 0
    EPwm1Regs.TBCTR = 0x0000;                     // Clear counter

    EPwm1Regs.CMPA.half.CMPA = 10000;    // Set compare A value
    EPwm1Regs.CMPB.half.CMPB = 20000;    // Set Compare B value

    EPwm1Regs.TBCTL.bit.CTRMODE = 2; // Count up and douwn
    EPwm1Regs.TBCTL.bit.PHSEN = 0; //disable phase loading
    EPwm1Regs.TBCTL.bit.CLKDIV = 7;  //TBCLOK = EPWMCLOCK/(128*10) = 78125Hz
    EPwm1Regs.TBCTL.bit.HSPCLKDIV = 5;

    EPwm1Regs.CMPCTL.bit.SHDWAMODE = 1;//only active registers are used
    EPwm1Regs.CMPCTL.bit.SHDWBMODE = 1;//only active registers are used


    EPwm1Regs.AQCTLA.bit.CAU = 2; //set high
    EPwm1Regs.AQCTLA.bit.CAD = 1; //setlow

    EPwm1Regs.AQCTLB.bit.CBU = 2; //set high
    EPwm1Regs.AQCTLB.bit.CBD = 1; //setlow

    EPwm1Regs.ETSEL.bit.INTSEL = 1;//when TBCTR == 0
    EPwm1Regs.ETSEL.bit.INTEN = 1;                // Enable INT
    EPwm1Regs.ETPS.bit.INTPRD = 1;           // Generate INT on first event
}
void InitECapModules()
{
    ECap1Regs.ECEINT.all = 0x0000;          // Disable all capture __interrupts
    ECap1Regs.ECCLR.all = 0xFFFF;           // Clear all CAP __interrupt flags
    ECap1Regs.ECCTL1.bit.CAPLDEN = 0;       // Disable CAP1-CAP4 register loads
    ECap1Regs.ECCTL2.bit.TSCTRSTOP = 0;     // Make sure the counter is stopped

    ECap1Regs.ECCTL2.bit.CONT_ONESHT = 0;   // Continuous
    ECap1Regs.ECCTL2.bit.STOP_WRAP = 3;     // Wrap at 4 events
    ECap1Regs.ECCTL1.bit.CAP1POL = 0;       // Rising edge
    ECap1Regs.ECCTL1.bit.CAP2POL = 1;       // Falling edge
    ECap1Regs.ECCTL1.bit.CAP3POL = 0;       // Rising edge
    ECap1Regs.ECCTL1.bit.CAP4POL = 1;       // Falling edge
    ECap1Regs.ECCTL1.bit.CTRRST1 = 0;       // Do not reset when cap1 occurs
    ECap1Regs.ECCTL1.bit.CTRRST2 = 0;       // Do not reset when cap2 occurs
    ECap1Regs.ECCTL1.bit.CTRRST3 = 0;       // Do not reset when cap3 occurs
    ECap1Regs.ECCTL1.bit.CTRRST4 = 1;       // Reset when cap4 occurs
    ECap1Regs.ECCTL2.bit.SYNCI_EN = 1;      // Enable sync in
    ECap1Regs.ECCTL2.bit.SYNCO_SEL = 0;     // Pass through  (syncin=syncout)

    ECap1Regs.ECCTL2.bit.TSCTRSTOP = 1;     // Start Counter
    ECap1Regs.ECCTL2.bit.REARM = 0;         // no effect
    ECap1Regs.ECCTL1.bit.CAPLDEN = 1;       // Enable CAP1-CAP4 register loads
    ECap1Regs.ECEINT.bit.CEVT4 = 1;         // Enable Capture Event 4 Interrupt

}
__interrupt void ecap4_isr(void)
{
    ECap1Regs.ECCLR.bit.INT = 1;     // Clear the ECAP interrupt flags
    ECap1Regs.ECCLR.bit.CEVT4 = 1;   // Clear the ECAP4 interrupt flag
    iCTRPeriod=(int32)ECap1Regs.CAP2 - (int32)ECap1Regs.CAP1;
    iCTRDutyCycle=(int32)ECap1Regs.CAP3 - (int32)ECap1Regs.CAP1;
    iECap1IntCount++;
    PieCtrlRegs.PIEACK.all = PIEACK_GROUP4; // acknowledge the PIE group 4

}
