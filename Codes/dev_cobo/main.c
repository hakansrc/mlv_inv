#include <F2837xD_Device.h>
#include <math.h>

float32 dAngularSpeed=0;
float32 fRPM=0;
float32 fAngularPosition;
float32 fAngularSpeed;
double dTimerCoefficient=0;
unsigned int uiHighSpeedFlag=1; //0:low speed, 1 high speed
Uint32 uiPositionLatched = 0;
Uint32 uiPositionLatchedPrevious = 0;
Uint16 uiDirectonOfRotation = 0; //CW=0,CCW=1
Uint32 uiPositionTotalCounted;
Uint32 ticktimes=0;
unsigned int uiUpEventValue=16;

#define HIGHSPEED           1
#define LOWSPEED            0
#define CLOCKWISE           1
#define COUNTERCLOCKWISE    0
#define CLOCKHZ             200000000 //200MHz
#define EQEP3UNITTIMECOEFF   (double)CLOCKHZ/((double)EQep3Regs.QUPRD)
#define ENCODERTICKCOUNT    200
#define PI 3.14159

void Gpio_Select1();
void InitSystem();
void InitEpwm1();
void InitEpwm2();
void InitEpwm3();
void InitEQep3Gpio_me(void);
void InitEQep3Module(void);
void PositionSpeedCalculate(void);

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
    GpioCtrlRegs.GPAMUX1.bit.GPIO1 = 1;   // Configure GPIO1 as EPWM1B

    GpioCtrlRegs.GPAPUD.bit.GPIO2 = 1;    // Disable pull-up on GPIO2 (EPWM2A)
    GpioCtrlRegs.GPAPUD.bit.GPIO3 = 1;    // Disable pull-up on GPIO3 (EPWM2B)

    GpioCtrlRegs.GPAMUX1.bit.GPIO2 = 1;   // Configure GPIO2 as EPWM2A
    GpioCtrlRegs.GPAMUX1.bit.GPIO3 = 1;   // Configure GPIO3 as EPWM2B

    GpioCtrlRegs.GPAPUD.bit.GPIO4 = 1;    // Disable pull-up on GPIO4 (EPWM3A)
    GpioCtrlRegs.GPAPUD.bit.GPIO5 = 1;    // Disable pull-up on GPIO5 (EPWM3B)

    GpioCtrlRegs.GPAMUX1.bit.GPIO4 = 1;   // Configure GPIO4 as EPWM3A
    GpioCtrlRegs.GPAMUX1.bit.GPIO5 = 1;   // Configure GPIO5 as EPWM3B
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
        {
            PositionSpeedCalculate();
            if(EQep3Regs.QPOSCNT>ticktimes)
            {
                ticktimes = EQep3Regs.QPOSCNT;
            }
        }
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
    GpioDataRegs.GPBTOGGLE.bit.GPIO34 = 1;

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
    //GpioDataRegs.GPBTOGGLE.bit.GPIO34 = 1;
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
    //GpioDataRegs.GPATOGGLE.bit.GPIO31 = 1;
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
    EPwm1Regs.TBCTL.bit.CLKDIV = 0; //TBCLOK = EPWMCLOCK/(64*10) = 156250Hz
    EPwm1Regs.TBCTL.bit.HSPCLKDIV = 0;

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
    EPwm2Regs.TBCTL.bit.CLKDIV = 0; //TBCLOK = EPWMCLOCK/(64*10) = 156250Hz
    EPwm2Regs.TBCTL.bit.HSPCLKDIV = 0;
    EPwm2Regs.TBCTL.bit.PHSDIR = 0;

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

    EPwm3Regs.CMPA.half.CMPA = 42500+2500+4500;    // Set compare A value
    EPwm3Regs.CMPB.half.CMPB = 42500+2500+4500;    // Set Compare B value

    EPwm3Regs.TBCTL.bit.CTRMODE = 2; // Count up and douwn
    EPwm3Regs.TBCTL.bit.PHSEN = 0; //disable phase loading
    EPwm3Regs.TBCTL.bit.CLKDIV = 0; //TBCLOK = EPWMCLOCK/(64*10) = 156250Hz
    EPwm3Regs.TBCTL.bit.HSPCLKDIV = 0;

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
    /*the formula will be X/(t(k)-t(k-1)) at low  speeds, can be used with UPEVNT */
    /*the formula will be (x(k)-x(k-1))/T at high speeds, can be used with eqep unit timer or CAPCLK */

    EQep3Regs.QUPRD=40000;            // Unit Timer for 100Hz at 200 MHz SYSCLKOUT

    EQep3Regs.QDECCTL.bit.QSRC=2;       // Up count mode (freq. measurement)
    EQep3Regs.QDECCTL.bit.XCR=0;        // 2x resolution (cnt falling and rising edges)


    EQep3Regs.QEPCTL.bit.FREE_SOFT=2;   // QPOSCNT is not affected by emulation suspend
    EQep3Regs.QEPCTL.bit.PCRM= 0;       // QPOSCNT reset on every index event
    EQep3Regs.QEPCTL.bit.SEI = 0;       // Strobe event is not initialized
    EQep3Regs.QEPCTL.bit.IEI = 0;       // Initialize the position counter on the rising edge (1 for falling) of QEPI signal
    EQep3Regs.QEPCTL.bit.SWI = 0;       // Disabled. (Initializes the position counter (QPOSCNT=QPOSINIT) )
    EQep3Regs.QEPCTL.bit.SEL = 0;       // QPOSCNT is latched on rising edge (1 for falling) of QEPS strobe event (QPOSSLAT = QPOSCNT)
    EQep3Regs.QEPCTL.bit.IEL = 0;       // QPOSCNT is latched on rising edge (1 for falling) of QEPI event (QPOISLAT = QPOSCNT)
    EQep3Regs.QEPCTL.bit.QPEN=1;        // QEP enable
    EQep3Regs.QEPCTL.bit.QCLM=1;        // Latch on unit time out
    EQep3Regs.QEPCTL.bit.UTE=1;         // Unit Timer Enable (unit timer value set from QCAPCTL)
    EQep3Regs.QEPCTL.bit.WDE=1;         // watchdog of eqep disabled

    EQep3Regs.QPOSINIT = 0;             // Initial QPOSCNT , QPOSCNT set to zero on index event (or strobe or software if desired)
    EQep3Regs.QPOSMAX=0xffffffff;       // Max value of QPOSCNT
    EQep3Regs.QPOSCMP = 100;            // This value is compared to QPOSCNT value to generate SYNCO signal,can be enabled from QDECCTL[SOEN]

    EQep3Regs.QCAPCTL.bit.UPPS=0x4;      // UPEVNT = QCLK/16 , QCLK is triggered in every rising or falling edge of A or B
    EQep3Regs.QCAPCTL.bit.CCPS=7;       // CAPCLK = SYSCLKOUT/128
    EQep3Regs.QCAPCTL.bit.CEN=1;        // QEP Capture Enable

    EQep3Regs.QPOSCTL.bit.PCSHDW = 0;   // shadow disabled
    EQep3Regs.QPOSCTL.bit.PCLOAD = 0;   // does not matter, shadow already disabled
    EQep3Regs.QPOSCTL.bit.PCPOL = 0;    // polarity of sync output is set to high pulse output
    EQep3Regs.QPOSCTL.bit.PCE = 1;      // position compare enable
    EQep3Regs.QPOSCTL.bit.PCSPW = 0xFFF;// Select-position-compare sync output pulse width, 4096 * 4 * SYSCLKOUT cycles

    EQep3Regs.QEINT.all = 0;            // interrupts disabled
    EQep3Regs.QEINT.bit.UTO = 1;        // unit timeout interrupt enabled, check QCAPCTL.bit.CCPS (NOTE: can be used for speed calculations at high speeds,check technical reference manual page 1996)
    EQep3Regs.QEINT.bit.IEL = 1;        // Index event latch interrupt enabled

    EQep3Regs.QFLG.all = 0;             // Interrupts are flagged here
    EQep3Regs.QCLR.all = 0;             // QEP Interrupt Clear

    EQep3Regs.QFRC.all = 0b0;           // QEP Interrupt Force, no idea why it is needed

    EQep3Regs.QEPSTS.bit.UPEVNT  = 0;   // shows if UPEVNT happened
    EQep3Regs.QEPSTS.bit.FIDF    = 0;   // first index direction flag, 0 is CCW, 1 is CW
    EQep3Regs.QEPSTS.bit.QDF     = 0;   // direction flag,             0 is CCW, 1 is CW
    EQep3Regs.QEPSTS.bit.QDLF    = 0;   // direction latch flag,             0 is CCW, 1 is CW
    EQep3Regs.QEPSTS.bit.COEF    = 0;   // overlow flag, 0 is not occured, 1 is occured
    EQep3Regs.QEPSTS.bit.CDEF    = 0;   // capture direction error flag
    EQep3Regs.QEPSTS.bit.FIMF    = 0;   // Set by first occurrence of index pulse
    EQep3Regs.QEPSTS.bit.PCEF    = 0;   // Position counter error flag

    /*The capture timer (QCTMR) value is latched into the capture period register (QCPRD) on every unit (UPEVNT) position*/
    EQep3Regs.QCTMR            = 0;     // This register provides time base for edge capture unit. 16 bit
    EQep3Regs.QCPRD            = 0;     // This register holds the period count value between the last successive eQEP position events
    EQep3Regs.QCTMRLAT         = 0;     // QCTMR latch register, latching can be stopped by clearing QEPCTL[QCLM] register
    EQep3Regs.QCPRDLAT         = 0;     // QCPRD latch register, latching can be stopped by clearing QEPCTL[QCLM] register




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

void PositionSpeedCalculate(void)
{
    /*TODO cover up the reverse direction case*/
    fAngularPosition = (float32)EQep3Regs.QPOSCNT/(float32)ENCODERTICKCOUNT*2*PI;
    if(uiHighSpeedFlag==HIGHSPEED)
    {
        if(EQep3Regs.QFLG.bit.UTO == 1)    // If unit timeout (depends on QUPRD)
        {
            uiPositionLatchedPrevious = uiPositionLatched;
            uiPositionLatched = EQep3Regs.QPOSLAT;
            if(uiPositionLatched>uiPositionLatchedPrevious)
                uiPositionTotalCounted = (uiPositionLatched -uiPositionLatchedPrevious);
            else
                uiPositionTotalCounted = ENCODERTICKCOUNT + uiPositionLatched - uiPositionLatchedPrevious;

            //fRPM = uiPositionTotalCounted*(CLOCKHZ/EQep3Regs.QUPRD)*60;
            //fRPM = fRPM/(float32)(ENCODERTICKCOUNT*4);
            fAngularSpeed = uiPositionTotalCounted*(CLOCKHZ/EQep3Regs.QUPRD)*2*PI;
            fAngularSpeed = fAngularSpeed/(float32)(ENCODERTICKCOUNT*4);
            EQep3Regs.QCLR.bit.UTO=1;
        }
    }
    else if (uiHighSpeedFlag==LOWSPEED)
    {
        if(EQep3Regs.QEPSTS.bit.UPEVNT==1)
        {
            //fRPM = 16*((CLOCKHZ/128)/EQep3Regs.QCPRDLAT)*60;
            //fRPM = fRPM/(float32)(ENCODERTICKCOUNT*4);
            fAngularSpeed = 16*((CLOCKHZ/128)/EQep3Regs.QCPRDLAT)*2*PI;/*TODO; parameterize the values,16 comes from UPPS value,128 comes from ccps value*/
            fAngularSpeed = fAngularSpeed/(float32)(ENCODERTICKCOUNT*4);
            EQep3Regs.QEPSTS.bit.UPEVNT=1;              // Clear status flag
        }
    }
}
