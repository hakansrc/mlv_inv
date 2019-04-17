#include <F2837xD_Device.h>
#include <math.h>

void Gpio_Select1();
void InitSystem();
void InitEpwm1();
void InitEpwm2();
void InitEpwm3();
void InitEQep3Gpio_me(void);
void InitEQep3Module(void);

//interrupt void cpu_timer0_isr(void);
__interrupt void cpu_timer0_isr(void);
__interrupt void cpu_timer1_isr(void);
__interrupt void cpu_timer2_isr(void);
__interrupt void epwm1_isr(void);
__interrupt void epwm2_isr(void);
__interrupt void epwm3_isr(void);
int main(void)
{

    InitSysCtrl();// first link F2837xD_SysCtrl.c
    EALLOW;

    CpuSysRegs.PCLKCR2.bit.EPWM1 = 1;/*enable clock for epwm1*/
    CpuSysRegs.PCLKCR2.bit.EPWM2 = 1;/*enable clock for epwm1*/
    CpuSysRegs.PCLKCR2.bit.EPWM3 = 1;/*enable clock for epwm1*/
    CpuSysRegs.PCLKCR2.bit.EPWM4 = 1;/*enable clock for epwm1*/
    CpuSysRegs.PCLKCR4.bit.EQEP3 = 1;/*enable clock for EQEP3*/
    InitPeripheralClocks();

    CpuSysRegs.PCLKCR0.bit.TBCLKSYNC =0;
    CpuSysRegs.PCLKCR0.bit.GTBCLKSYNC =0;
    /*GPIO selection is as follows
     *GPIO0 generates   A signal of the encoder (check the angle)
     *GPIO2 generates   B signal of the encoder
     *GPIO4 generates   I signal of the encoder (lower the duty cycle)
     *
     *GPIO6 reads       A signal of the encoder
     *GPIO7 reads       B signal of the encoder
     *GPI08 reads       S signal
     *GPIO9 reads       I signal of the encoder
     * */
    EDIS;
    Gpio_Select1();
    EALLOW;
    /***********Configure GPIO Pins*************/
    GpioCtrlRegs.GPAPUD.bit.GPIO0 = 1;    // Disable pull-up on GPIO0 (EPWM1A)
    GpioCtrlRegs.GPAPUD.bit.GPIO1 = 1;    // Disable pull-up on GPIO1 (EPWM1B)

    GpioCtrlRegs.GPAMUX1.bit.GPIO0 = 1;   // Configure GPIO0 as EPWM1A
    GpioCtrlRegs.GPAMUX1.bit.GPIO1 = 1;     // Configure GPIO1 as EPWM1B

    GpioCtrlRegs.GPAPUD.bit.GPIO2 = 1;    // Disable pull-up on GPIO2 (EPWM2A)
    GpioCtrlRegs.GPAPUD.bit.GPIO3 = 1;    // Disable pull-up on GPIO3

    GpioCtrlRegs.GPAMUX1.bit.GPIO2 = 1;   // Configure GPIO2 as EPWM2A
    GpioCtrlRegs.GPAMUX1.bit.GPIO3 = 1;     // Configure GPIO3 as EPWM2B

    GpioCtrlRegs.GPAPUD.bit.GPIO4 = 1;    // Disable pull-up on GPIO2 (EPWM2A)
    GpioCtrlRegs.GPAPUD.bit.GPIO5 = 1;    // Disable pull-up on GPIO3

    GpioCtrlRegs.GPAMUX1.bit.GPIO4 = 1;   // Configure GPIO2 as EPWM2A
    GpioCtrlRegs.GPAMUX1.bit.GPIO5 = 1;     // Configure GPIO3 as EPWM2B
    /*******************************************/
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
    PieVectTable.EPWM2_INT = &epwm2_isr;
    PieVectTable.EPWM3_INT = &epwm3_isr;
    EDIS;
    EALLOW;
    InitEpwm1();
    InitEpwm2();
    InitEpwm3();
    EDIS;
    InitEQep3Gpio_me();
    EALLOW;
    InitEQep3Module();
    EDIS;
    InitCpuTimers();   // For this example, only initialize the Cpu Timers
    ConfigCpuTimer(&CpuTimer0, 200, 1000); //2 miliseconds
    ConfigCpuTimer(&CpuTimer1, 200, 1000000); //2 seconds
    ConfigCpuTimer(&CpuTimer2, 200, 1000000); //2 seconds

    //CpuTimer0Regs.PRD.all = 0xFFFFFFFF;
    CpuTimer0Regs.TCR.all = 0x4000; // Use write-only instruction to set TSS bit = 0
    CpuTimer1Regs.TCR.all = 0x4000; // Use write-only instruction to set TSS bit = 0
    CpuTimer2Regs.TCR.all = 0x4000; // Use write-only instruction to set TSS bit = 0
    IER |= M_INT1;
    IER |= M_INT3;
    IER |= M_INT13;
    IER |= M_INT14;

    PieCtrlRegs.PIEIER1.bit.INTx7 = 1;
    PieCtrlRegs.PIEIER3.bit.INTx1 = 1;
    PieCtrlRegs.PIEIER3.bit.INTx2 = 1;
    PieCtrlRegs.PIEIER3.bit.INTx3 = 1;

    EINT;  // Enable Global interrupt INTM
    ERTM;  // Enable Global realtime interrupt DBGM
    EALLOW;
    CpuSysRegs.PCLKCR0.bit.TBCLKSYNC =1;
    CpuSysRegs.PCLKCR0.bit.GTBCLKSYNC =1;

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
    GpioDataRegs.GPBSET.bit.GPIO34 = 1;




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
   //GpioDataRegs.GPATOGGLE.bit.GPIO31 = 1;

}
__interrupt void epwm1_isr(void)
{
    // Update the CMPA and CMPB values
    //update_compare(&epwm1_info);
    // Clear INT flag for this timer
    EPwm1Regs.ETCLR.bit.INT = 1;
    GpioDataRegs.GPBTOGGLE.bit.GPIO34 = 1;
    //EPwm1Regs.TBCTR = 0x0000;                     // Clear counter

   /*
    *if(EPwm1Regs.CMPA.half.CMPA>=45000)
    *    EPwm1Regs.CMPA.half.CMPA=0;    // Set compare A value
    *else
    *    EPwm1Regs.CMPA.half.CMPA+=1000;
    */

    // Acknowledge this interrupt to receive more interrupts from group 3
    PieCtrlRegs.PIEACK.all = PIEACK_GROUP3;
}
__interrupt void epwm2_isr(void)
{
    EPwm2Regs.ETCLR.bit.INT = 1;
    GpioDataRegs.GPATOGGLE.bit.GPIO31 = 1;
    //EPwm2Regs.TBCTR = 0x0000;                     // Clear counter

    PieCtrlRegs.PIEACK.all = PIEACK_GROUP3;
}
__interrupt void epwm3_isr(void)
{
    // Update the CMPA and CMPB values
    //update_compare(&epwm1_info);
    // Clear INT flag for this timer
    EPwm3Regs.ETCLR.bit.INT = 1;
    //GpioDataRegs.GPATOGGLE.bit.GPIO1  = 1;
   /*
    *if(EPwm1Regs.CMPA.half.CMPA>=45000)
    *    EPwm1Regs.CMPA.half.CMPA=0;    // Set compare A value
    *else
    *    EPwm1Regs.CMPA.half.CMPA+=1000;
    */

    // Acknowledge this interrupt to receive more interrupts from group 3
    PieCtrlRegs.PIEACK.all = PIEACK_GROUP3;
}
void InitEpwm1(void){
    EPwm1Regs.TBPRD = 500;
    EPwm1Regs.TBPHS.half.TBPHS = 0;          // Phase is 0
    EPwm1Regs.TBCTR = 0x0000;                     // Clear counter
    EPwm1Regs.TBCTL.bit.SYNCOSEL = 1;
    EPwm1Regs.TBCTL.bit.PHSEN = 0;

    EPwm1Regs.CMPA.half.CMPA = 250;    // Set compare A value
    EPwm1Regs.CMPB.half.CMPB = 250;    // Set Compare B value

    EPwm1Regs.TBCTL.bit.CTRMODE = 2; // Count up and douwn
    EPwm1Regs.TBCTL.bit.PHSEN = 0; //disable phase loading
    EPwm1Regs.TBCTL.bit.CLKDIV = 6; //TBCLOK = EPWMCLOCK/(64*10) = 156250Hz
    EPwm1Regs.TBCTL.bit.HSPCLKDIV = 5;

    //EPwm1Regs.CMPCTL.bit.SHDWAMODE = 1;//only active registers are used
    //EPwm1Regs.CMPCTL.bit.SHDWBMODE = 1;//only active registers are used
    EPwm1Regs.TBCTL.bit.PHSDIR = 1;


    EPwm1Regs.AQCTLA.bit.CAU = 2; //set high
    EPwm1Regs.AQCTLA.bit.CAD = 1; //setlow

    EPwm1Regs.AQCTLB.bit.CBU = 2; //set high
    EPwm1Regs.AQCTLB.bit.CBD = 1; //setlow

    EPwm1Regs.ETSEL.bit.INTSEL = 1;//when TBCTR == 0
    EPwm1Regs.ETSEL.bit.INTEN = 1;                // Enable INT
    EPwm1Regs.ETPS.bit.INTPRD = 1;           // Generate INT on first event
}
void InitEpwm2(void){
    EPwm2Regs.TBPRD = 500;
    EPwm2Regs.TBCTL.bit.PHSEN = 1;
    EPwm2Regs.TBPHS.half.TBPHS = 250;          // Phase is 0
    EPwm2Regs.TBCTR = 0x0000;                     // Clear counter
    EPwm2Regs.TBCTL.bit.SYNCOSEL = 1;

    EPwm2Regs.CMPA.half.CMPA = 250;    // Set compare A value
    EPwm2Regs.CMPB.half.CMPB = 250;    // Set Compare B value

    EPwm2Regs.TBCTL.bit.CTRMODE = 2; // Count up and douwn
    EPwm2Regs.TBCTL.bit.PHSEN = 1; //disable phase loading
    EPwm2Regs.TBCTL.bit.CLKDIV = 6; //TBCLOK = EPWMCLOCK/(64*10) = 156250Hz
    EPwm2Regs.TBCTL.bit.HSPCLKDIV = 5;
    EPwm2Regs.TBCTL.bit.PHSDIR = 1;

    //EPwm2Regs.CMPCTL.bit.SHDWAMODE = 1;//only active registers are used
    //EPwm2Regs.CMPCTL.bit.SHDWBMODE = 1;//only active registers are used


    EPwm2Regs.AQCTLA.bit.CAU = 2; //set high
    EPwm2Regs.AQCTLA.bit.CAD = 1; //setlow

    EPwm2Regs.AQCTLB.bit.CBU = 2; //set high
    EPwm2Regs.AQCTLB.bit.CBD = 1; //setlow

    EPwm2Regs.ETSEL.bit.INTSEL = 1;//when TBCTR == 0
    EPwm2Regs.ETSEL.bit.INTEN = 1;                // Enable INT
    EPwm2Regs.ETPS.bit.INTPRD = 1;
}
void InitEpwm3(void){
    EPwm3Regs.TBPRD = 50000;
    EPwm3Regs.TBPHS.half.TBPHS = 0;          // Phase is 0
    EPwm3Regs.TBCTR = 0x0000;                     // Clear counter
    EPwm3Regs.TBCTL.bit.SYNCOSEL = 1;

    EPwm3Regs.CMPA.half.CMPA = 42500+2500;    // Set compare A value
    EPwm3Regs.CMPB.half.CMPB = 42500+2500;    // Set Compare B value

    EPwm3Regs.TBCTL.bit.CTRMODE = 2; // Count up and douwn
    EPwm3Regs.TBCTL.bit.PHSEN = 0; //disable phase loading
    EPwm3Regs.TBCTL.bit.CLKDIV = 6; //TBCLOK = EPWMCLOCK/(64*10) = 156250Hz
    EPwm3Regs.TBCTL.bit.HSPCLKDIV = 5;

    //EPwm3Regs.CMPCTL.bit.SHDWAMODE = 1;//only active registers are used
    //EPwm3Regs.CMPCTL.bit.SHDWBMODE = 1;//only active registers are used


    EPwm3Regs.AQCTLA.bit.CAU = 2; //set high
    EPwm3Regs.AQCTLA.bit.CAD = 1; //setlow

    //EPwm1Regs.AQCTLB.bit.CBU = 2; //set high
    //EPwm1Regs.AQCTLB.bit.CBD = 1; //setlow

    EPwm3Regs.ETSEL.bit.INTSEL = 1;//when TBCTR == 0
    EPwm3Regs.ETSEL.bit.INTEN = 1;                // Enable INT
    EPwm3Regs.ETPS.bit.INTPRD = 1;
}

void InitEQep3Module(void)
{

    EQep3Regs.QUPRD=2000000;            // Unit Timer for 100Hz at 200 MHz SYSCLKOUT

    EQep3Regs.QDECCTL.bit.QSRC=2;       // Up count mode (freq. measurement)
    EQep3Regs.QDECCTL.bit.XCR=0;        // 2x resolution (cnt falling and rising edges)

    EQep3Regs.QEPCTL.bit.FREE_SOFT=2;
    EQep3Regs.QEPCTL.bit.PCRM=00;       // QPOSCNT reset on index evnt
    EQep3Regs.QEPCTL.bit.UTE=1;         // Unit Timer Enable
    EQep3Regs.QEPCTL.bit.QCLM=1;        // Latch on unit time out
    EQep3Regs.QPOSMAX=0xffffffff;
    EQep3Regs.QEPCTL.bit.QPEN=1;        // QEP enable

    EQep3Regs.QCAPCTL.bit.UPPS=3;       // 1/8 for unit position
    EQep3Regs.QCAPCTL.bit.CCPS=7;       // 1/128 for CAP clock
    EQep3Regs.QCAPCTL.bit.CEN=1;        // QEP Capture Enable

}
void InitEQep3Gpio_me(void)
{
    EALLOW;

    /* Disable internal pull-up for the selected output pins
       for reduced power consumption */
    // Pull-ups can be enabled or disabled by the user.
    // Comment out other unwanted lines.
  GpioCtrlRegs.GPAPUD.bit.GPIO6 = 1;     // Disable pull-up on GPIO6 (EQEP3A)
  GpioCtrlRegs.GPAPUD.bit.GPIO7 = 1;     // Disable pull-up on GPIO7 (EQEP3B)
  GpioCtrlRegs.GPAPUD.bit.GPIO8 = 1;     // Disable pull-up on GPIO8 (EQEP3S)
  GpioCtrlRegs.GPAPUD.bit.GPIO9 = 1;     // Disable pull-up on GPIO9 (EQEP3I)


    /* Synchronize inputs to SYSCLK */
    // Synchronization can be enabled or disabled by the user.
    // Comment out other unwanted lines.

  GpioCtrlRegs.GPAQSEL1.bit.GPIO6 = 0;    // Sync GPIO6 to SYSCLK  (EQEP3A)
  GpioCtrlRegs.GPAQSEL1.bit.GPIO7 = 0;    // Sync GPIO7 to SYSCLK  (EQEP3B)
  GpioCtrlRegs.GPAQSEL1.bit.GPIO8 = 0;    // Sync GPIO8 to SYSCLK  (EQEP3S)
  GpioCtrlRegs.GPAQSEL1.bit.GPIO9 = 0;    // Sync GPIO9 to SYSCLK  (EQEP3I)


    /* Configure EQEP-1 pins using GPIO regs*/
    // This specifies which of the possible GPIO pins will be EQEP3 functional pins.
    // Comment out other unwanted lines.

  GpioCtrlRegs.GPAGMUX1.bit.GPIO6 = 1;    // Configure GPIO6 as EQEP3A
  GpioCtrlRegs.GPAMUX1.bit.GPIO6 = 1;     // Configure GPIO6 as EQEP3A
  GpioCtrlRegs.GPAGMUX1.bit.GPIO7 = 1;    // Configure GPIO7 as EQEP3B
  GpioCtrlRegs.GPAMUX1.bit.GPIO7 = 1;     // Configure GPIO7 as EQEP3B
  GpioCtrlRegs.GPAGMUX1.bit.GPIO8 = 1;    // Configure GPIO8 as EQEP3S
  GpioCtrlRegs.GPAMUX1.bit.GPIO8 = 1;     // Configure GPIO8 as EQEP3S
  GpioCtrlRegs.GPAGMUX1.bit.GPIO9 = 1;    // Configure GPIO9 as EQEP3I
  GpioCtrlRegs.GPAMUX1.bit.GPIO9 = 1;     // Configure GPIO9 as EQEP3I


    EDIS;
}
