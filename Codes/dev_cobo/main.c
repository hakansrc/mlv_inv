#include <F2837xD_Device.h>
#include <math.h>
#include <F2837xD_Pie_defines.h>

//#include <stdio.h>

extern void InitSysCtrl(void);
extern void InitPieCtrl(void);
extern void InitPieVectTable(void);
extern void InitCpuTimers(void);
extern void ConfigCpuTimer(struct CPUTIMER_VARS *, float, float);
extern void InitAdc(void);
extern void InitPeripheralClocks(void);

void Gpio_Select();
void InitSystem();
void Setup_ADC();
void InitEpwm1(); // Module-4 Phase-A
void InitEpwm2(); // Module-2 Phase-C
void InitEpwm3(); // Module-2 Phase-B
void InitEpwm4(); // Module-2 Phase-A
void InitEpwm5(); // Module-4 Phase-B
void InitEpwm6(); // Module-1 Phase-C
void InitEpwm7(); // Module-1 Phase-B
void InitEpwm8(); // Module-1 Phase-A
void InitEpwm9(); // Module-3 Phase-C
void InitEpwm10(); // Module-3 Phase-B
void InitEpwm11(); // Module-3 Phase-A
void InitEpwm12(); // Module-4 Phase-C
//void InitECapModules();

//interrupt void cpu_timer0_isr(void);
__interrupt void cpu_timer0_isr(void);
__interrupt void cpu_timer1_isr(void);
__interrupt void cpu_timer2_isr(void);
__interrupt void epwm1_isr(void);
__interrupt void adc1_isr(void);

// Global Variables
float Vdc_M1;
float Vdc_M2;
float Vdc_M3;
float Vdc_M4;
float Is_M1_PhA;
float Is_M1_PhB;
float Is_M1_PhC;
float Is_M2_PhA;
float Is_M2_PhB;
float Is_M2_PhC;
float Is_M3_PhA;
float Is_M3_PhB;
float Is_M3_PhC;
float Is_M4_PhA;
float Is_M4_PhB;
float Is_M4_PhC;
float Vdc_M1_adc;
float Vdc_M2_adc;
float Vdc_M3_adc;
float Vdc_M4_adc;
float Is_M1_PhA_adc;
float Is_M1_PhB_adc;
float Is_M1_PhC_adc;
float Is_M2_PhA_adc;
float Is_M2_PhB_adc;
float Is_M2_PhC_adc;
float Is_M3_PhA_adc;
float Is_M3_PhB_adc;
float Is_M3_PhC_adc;
float Is_M4_PhA_adc;
float Is_M4_PhB_adc;
float Is_M4_PhC_adc;

//__interrupt void ecap4_isr(void);

//int iCTRPeriod=0;
//int iCTRDutyCycle=0;
//int iECap1IntCount=0;

int main(void)
{
    //printf("selamlar");
    //memcpy(&RamfuncsRunStart, &RamfuncsLoadStart, (size_t)&RamfuncsLoadSize);
    //EDIS;
    //InitFlash();

    InitSysCtrl();// first link F2837xD_SysCtrl.c
    // if you are using in flash
    // add 2837x_FLASH_lnk_cpu1_bist.cmd
    // and add "_FLASH" to your predefined options

    InitPeripheralClocks();

    EALLOW; // initperipheral clock diyince bunlara gerek kalmiyor sanirim.
    CpuSysRegs.PCLKCR2.bit.EPWM1 = 1;/*enable clock for epwm1*/
    CpuSysRegs.PCLKCR0.bit.TBCLKSYNC = 0;
    EDIS;

    Gpio_Select();
    //TrigRegs.INPUT10SELECT = 0;

    DINT; //disable the interrupts

    InitPieCtrl();// first link F2837xD_PieCtrl.c
    IER = 0x0000;
    IFR = 0x0000;
    InitPieVectTable();

    EALLOW;  // This is needed to write to EALLOW protected registers
    PieVectTable.TIMER0_INT = &cpu_timer0_isr;
    PieVectTable.TIMER1_INT = &cpu_timer1_isr;
    PieVectTable.TIMER2_INT = &cpu_timer2_isr;
    PieVectTable.EPWM1_INT = &epwm1_isr;
    PieVectTable.ADCA1_INT = &adc1_isr;
    //PieVectTable.ECAP4_INT = &ecap4_isr;
    EDIS;

    //InitECapModules();
    InitCpuTimers();   // For this example, only initialize the Cpu Timers
    ConfigCpuTimer(&CpuTimer0, 200, 250); //0.5 miliseconds (1 kHz square wave)
    ConfigCpuTimer(&CpuTimer1, 200, 1000000); //2 seconds
    ConfigCpuTimer(&CpuTimer2, 200, 1000000); //2 seconds

    InitEpwm1();
    InitEpwm2();
    InitEpwm3();
    InitEpwm4();
    InitEpwm5();
    InitEpwm6();
    InitEpwm7();
    InitEpwm8();
    InitEpwm9();
    InitEpwm10();
    InitEpwm11();
    InitEpwm12();

    //InitAdc();
    Setup_ADC();

    //CpuTimer0Regs.PRD.all = 0xFFFFFFFF;
    CpuTimer0Regs.TCR.all = 0x4000; // Use write-only instruction to set TSS bit = 0
    CpuTimer1Regs.TCR.all = 0x4000; // Use write-only instruction to set TSS bit = 0
    CpuTimer2Regs.TCR.all = 0x4000; // Use write-only instruction to set TSS bit = 0
    IER |= M_INT1;   // ADC
    IER |= M_INT3;   // EPWM
    //IER |= M_INT4; // ECAP
    IER |= M_INT13;  // CPU1.TIMER1
    IER |= M_INT14;  // CPU1.TIMER2
    PieCtrlRegs.PIEIER1.bit.INTx7 = 1; // TIMER0
    PieCtrlRegs.PIEIER3.bit.INTx1 = 1; // EPWM1
    PieCtrlRegs.PIEIER1.bit.INTx1 = 1; // ADCA1

    //PieCtrlRegs.PIEIER4.bit.INTx4 = 1;//enable interrupt for ecap4

    EINT;  // Enable Global interrupt INTM
    ERTM;  // Enable Global real time interrupt DBGM

    EALLOW;
    CpuSysRegs.PCLKCR0.bit.TBCLKSYNC = 1; // buna da gerek olmayabilir
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

void Gpio_Select()
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


    // Module-1 Phase-A PWM (ePWM8)
    GpioCtrlRegs.GPAPUD.bit.GPIO14 = 1;    // Disable pull-up on GPIO14 (EPWM8A)
    GpioCtrlRegs.GPAPUD.bit.GPIO15 = 1;    // Disable pull-up on GPIO15 (EPWM8B)
    GpioCtrlRegs.GPAGMUX1.bit.GPIO14 = 0;  // Configure GPIO14 as EPWM8A
    GpioCtrlRegs.GPAGMUX1.bit.GPIO15 = 0;  // Configure GPIO15 as EPWM8B
    GpioCtrlRegs.GPAMUX1.bit.GPIO14 = 1;   // Configure GPIO14 as EPWM8A
    GpioCtrlRegs.GPAMUX1.bit.GPIO15 = 1;   // Configure GPIO15 as EPWM8B

    // Module-1 Phase-B PWM (ePWM7)
    GpioCtrlRegs.GPAPUD.bit.GPIO12 = 1;    // Disable pull-up on GPIO12 (EPWM7A)
    GpioCtrlRegs.GPAPUD.bit.GPIO13 = 1;    // Disable pull-up on GPIO13 (EPWM7B)
    GpioCtrlRegs.GPAGMUX1.bit.GPIO12 = 0;  // Configure GPIO12 as EPWM7A
    GpioCtrlRegs.GPAGMUX1.bit.GPIO13 = 0;  // Configure GPIO13 as EPWM7B
    GpioCtrlRegs.GPAMUX1.bit.GPIO12 = 1;   // Configure GPIO12 as EPWM7A
    GpioCtrlRegs.GPAMUX1.bit.GPIO13 = 1;   // Configure GPIO13 as EPWM7B

    // Module-1 Phase-C PWM (ePWM6)
    GpioCtrlRegs.GPAPUD.bit.GPIO10 = 1;    // Disable pull-up on GPIO10 (EPWM6A)
    GpioCtrlRegs.GPAPUD.bit.GPIO11 = 1;    // Disable pull-up on GPIO11 (EPWM6B)
    GpioCtrlRegs.GPAGMUX1.bit.GPIO10 = 0;  // Configure GPIO10 as EPWM6A
    GpioCtrlRegs.GPAGMUX1.bit.GPIO11 = 0;  // Configure GPIO11 as EPWM6B
    GpioCtrlRegs.GPAMUX1.bit.GPIO10 = 1;   // Configure GPIO10 as EPWM6A
    GpioCtrlRegs.GPAMUX1.bit.GPIO11 = 1;   // Configure GPIO11 as EPWM6B

    // Module-2 Phase-A PWM (ePWM4)
    GpioCtrlRegs.GPAPUD.bit.GPIO6 = 1;    // Disable pull-up on GPIO6 (EPWM4A)
    GpioCtrlRegs.GPAPUD.bit.GPIO7 = 1;    // Disable pull-up on GPIO7 (EPWM4B)
    GpioCtrlRegs.GPAGMUX1.bit.GPIO6 = 0;  // Configure GPIO6 as EPWM4A
    GpioCtrlRegs.GPAGMUX1.bit.GPIO7 = 0;  // Configure GPIO7 as EPWM4B
    GpioCtrlRegs.GPAMUX1.bit.GPIO6 = 1;   // Configure GPIO6 as EPWM4A
    GpioCtrlRegs.GPAMUX1.bit.GPIO7 = 1;   // Configure GPIO7 as EPWM4B

    // Module-2 Phase-B PWM (ePWM3)
    GpioCtrlRegs.GPAPUD.bit.GPIO4 = 1;    // Disable pull-up on GPIO4 (EPWM3A)
    GpioCtrlRegs.GPAPUD.bit.GPIO5 = 1;    // Disable pull-up on GPIO5 (EPWM3B)
    GpioCtrlRegs.GPAGMUX1.bit.GPIO4 = 0;  // Configure GPIO4 as EPWM3A
    GpioCtrlRegs.GPAGMUX1.bit.GPIO5 = 0;  // Configure GPIO5 as EPWM3B
    GpioCtrlRegs.GPAMUX1.bit.GPIO4 = 1;   // Configure GPIO4 as EPWM3A
    GpioCtrlRegs.GPAMUX1.bit.GPIO5 = 1;   // Configure GPIO5 as EPWM3B

    // Module-2 Phase-C PWM (ePWM2)
    GpioCtrlRegs.GPAPUD.bit.GPIO2 = 1;    // Disable pull-up on GPIO2 (EPWM2A)
    GpioCtrlRegs.GPAPUD.bit.GPIO3 = 1;    // Disable pull-up on GPIO3 (EPWM2B)
    GpioCtrlRegs.GPAGMUX1.bit.GPIO2 = 0;  // Configure GPIO2 as EPWM2A
    GpioCtrlRegs.GPAGMUX1.bit.GPIO3 = 0;  // Configure GPIO3 as EPWM2B
    GpioCtrlRegs.GPAMUX1.bit.GPIO2 = 1;   // Configure GPIO2 as EPWM2A
    GpioCtrlRegs.GPAMUX1.bit.GPIO3 = 1;   // Configure GPIO3 as EPWM2B

    // Module-3 Phase-A PWM (ePWM11)
    GpioCtrlRegs.GPAPUD.bit.GPIO20 = 1;    // Disable pull-up on GPIO20 (EPWM11A)
    GpioCtrlRegs.GPAPUD.bit.GPIO21 = 1;    // Disable pull-up on GPIO21 (EPWM11B)
    GpioCtrlRegs.GPAGMUX2.bit.GPIO20 = 1;  // Configure GPIO20 as EPWM11A
    GpioCtrlRegs.GPAGMUX2.bit.GPIO21 = 1;  // Configure GPIO21 as EPWM11B
    GpioCtrlRegs.GPAMUX2.bit.GPIO20 = 1;   // Configure GPIO20 as EPWM11A
    GpioCtrlRegs.GPAMUX2.bit.GPIO21 = 1;   // Configure GPIO21 as EPWM11B

    // Module-3 Phase-B PWM (ePWM10)
    GpioCtrlRegs.GPAPUD.bit.GPIO18 = 1;    // Disable pull-up on GPIO18 (EPWM10A)
    GpioCtrlRegs.GPAPUD.bit.GPIO19 = 1;    // Disable pull-up on GPIO19 (EPWM10B)
    GpioCtrlRegs.GPAGMUX2.bit.GPIO18 = 1;  // Configure GPIO18 as EPWM10A
    GpioCtrlRegs.GPAGMUX2.bit.GPIO19 = 1;  // Configure GPIO19 as EPWM10B
    GpioCtrlRegs.GPAMUX2.bit.GPIO18 = 1;   // Configure GPIO18 as EPWM10A
    GpioCtrlRegs.GPAMUX2.bit.GPIO19 = 1;   // Configure GPIO19 as EPWM10B

    // Module-3 Phase-C PWM (ePWM9)
    GpioCtrlRegs.GPAPUD.bit.GPIO16 = 1;    // Disable pull-up on GPIO16 (EPWM9A)
    GpioCtrlRegs.GPAPUD.bit.GPIO17 = 1;    // Disable pull-up on GPIO17 (EPWM9B)
    GpioCtrlRegs.GPAGMUX2.bit.GPIO16 = 1;  // Configure GPIO16 as EPWM9A
    GpioCtrlRegs.GPAGMUX2.bit.GPIO17 = 1;  // Configure GPIO17 as EPWM9B
    GpioCtrlRegs.GPAMUX2.bit.GPIO16 = 1;   // Configure GPIO16 as EPWM9A
    GpioCtrlRegs.GPAMUX2.bit.GPIO17 = 1;   // Configure GPIO17 as EPWM9B

    // Module-4 Phase-A PWM (ePWM1)
    GpioCtrlRegs.GPAPUD.bit.GPIO0 = 1;    // Disable pull-up on GPIO0 (EPWM1A)
    GpioCtrlRegs.GPAPUD.bit.GPIO1 = 1;    // Disable pull-up on GPIO1 (EPWM1B)
    GpioCtrlRegs.GPAGMUX1.bit.GPIO0 = 0;  // Configure GPIO0 as EPWM1A
    GpioCtrlRegs.GPAGMUX1.bit.GPIO1 = 0;  // Configure GPIO1 as EPWM1B
    GpioCtrlRegs.GPAMUX1.bit.GPIO0 = 1;   // Configure GPIO0 as EPWM1A
    GpioCtrlRegs.GPAMUX1.bit.GPIO1 = 1;   // Configure GPIO1 as EPWM1B

    // Module-4 Phase-B PWM (ePWM5)
    GpioCtrlRegs.GPAPUD.bit.GPIO8 = 1;    // Disable pull-up on GPIO8 (EPWM5A)
    GpioCtrlRegs.GPAPUD.bit.GPIO9 = 1;    // Disable pull-up on GPIO9 (EPWM5B)
    GpioCtrlRegs.GPAGMUX1.bit.GPIO8 = 0;  // Configure GPIO8 as EPWM5A
    GpioCtrlRegs.GPAGMUX1.bit.GPIO9 = 0;  // Configure GPIO9 as EPWM5B
    GpioCtrlRegs.GPAMUX1.bit.GPIO8 = 1;   // Configure GPIO8 as EPWM5A
    GpioCtrlRegs.GPAMUX1.bit.GPIO9 = 1;   // Configure GPIO9 as EPWM5B

    // Module-4 Phase-C PWM (ePWM12)
    GpioCtrlRegs.GPAPUD.bit.GPIO22 = 1;    // Disable pull-up on GPIO22 (EPWM12A)
    GpioCtrlRegs.GPAPUD.bit.GPIO23 = 1;    // Disable pull-up on GPIO23 (EPWM12B)
    GpioCtrlRegs.GPAGMUX2.bit.GPIO22 = 1;  // Configure GPIO22 as EPWM12A
    GpioCtrlRegs.GPAGMUX2.bit.GPIO23 = 1;  // Configure GPIO23 as EPWM12B
    GpioCtrlRegs.GPAMUX2.bit.GPIO22 = 1;   // Configure GPIO22 as EPWM12A
    GpioCtrlRegs.GPAMUX2.bit.GPIO23 = 1;   // Configure GPIO23 as EPWM12B


    // Module-1 Phase-A Enable (GPIO94)
    GpioCtrlRegs.GPCPUD.bit.GPIO94 = 0; // enable pull up
    GpioDataRegs.GPCSET.bit.GPIO94 = 1; // Load output latch. Recommended in rm
    GpioCtrlRegs.GPCDIR.bit.GPIO94 = 1; // set it as output

    // Module-1 Phase-B Enable (GPIO93)
    GpioCtrlRegs.GPCPUD.bit.GPIO93 = 0; // enable pull up
    GpioDataRegs.GPCSET.bit.GPIO93 = 1; // Load output latch. Recommended in rm
    GpioCtrlRegs.GPCDIR.bit.GPIO93 = 1; // set it as output

    // Module-1 Phase-C Enable (GPIO92)
    GpioCtrlRegs.GPCPUD.bit.GPIO92 = 0; // enable pull up
    GpioDataRegs.GPCSET.bit.GPIO92 = 1; // Load output latch. Recommended in rm
    GpioCtrlRegs.GPCDIR.bit.GPIO92 = 1; // set it as output

    // Module-2 Phase-A Enable (GPIO91)
    GpioCtrlRegs.GPCPUD.bit.GPIO91 = 0; // enable pull up
    GpioDataRegs.GPCSET.bit.GPIO91 = 1; // Load output latch. Recommended in rm
    GpioCtrlRegs.GPCDIR.bit.GPIO91 = 1; // set it as output

    // Module-2 Phase-B Enable (GPIO90)
    GpioCtrlRegs.GPCPUD.bit.GPIO90 = 0; // enable pull up
    GpioDataRegs.GPCSET.bit.GPIO90 = 1; // Load output latch. Recommended in rm
    GpioCtrlRegs.GPCDIR.bit.GPIO90 = 1; // set it as output

    // Module-2 Phase-C Enable (GPIO89)
    GpioCtrlRegs.GPCPUD.bit.GPIO89 = 0; // enable pull up
    GpioDataRegs.GPCSET.bit.GPIO89 = 1; // Load output latch. Recommended in rm
    GpioCtrlRegs.GPCDIR.bit.GPIO89 = 1; // set it as output

    // Module-3 Phase-A Enable (GPIO77)
    GpioCtrlRegs.GPCPUD.bit.GPIO77 = 0; // enable pull up
    GpioDataRegs.GPCSET.bit.GPIO77 = 1; // Load output latch. Recommended in rm
    GpioCtrlRegs.GPCDIR.bit.GPIO77 = 1; // set it as output

    // Module-3 Phase-B Enable (GPIO78)
    GpioCtrlRegs.GPCPUD.bit.GPIO78 = 0; // enable pull up
    GpioDataRegs.GPCSET.bit.GPIO78 = 1; // Load output latch. Recommended in rm
    GpioCtrlRegs.GPCDIR.bit.GPIO78 = 1; // set it as output

    // Module-3 Phase-C Enable (GPIO79)
    GpioCtrlRegs.GPCPUD.bit.GPIO79 = 0; // enable pull up
    GpioDataRegs.GPCSET.bit.GPIO79 = 1; // Load output latch. Recommended in rm
    GpioCtrlRegs.GPCDIR.bit.GPIO79 = 1; // set it as output

    // Module-4 Phase-A Enable (GPIO74)
    GpioCtrlRegs.GPCPUD.bit.GPIO74 = 0; // enable pull up
    GpioDataRegs.GPCSET.bit.GPIO74 = 1; // Load output latch. Recommended in rm
    GpioCtrlRegs.GPCDIR.bit.GPIO74 = 1; // set it as output

    // Module-4 Phase-B Enable (GPIO75)
    GpioCtrlRegs.GPCPUD.bit.GPIO75 = 0; // enable pull up
    GpioDataRegs.GPCSET.bit.GPIO75 = 1; // Load output latch. Recommended in rm
    GpioCtrlRegs.GPCDIR.bit.GPIO75 = 1; // set it as output

    // Module-4 Phase-C Enable (GPIO76)
    GpioCtrlRegs.GPCPUD.bit.GPIO76 = 0; // enable pull up
    GpioDataRegs.GPCSET.bit.GPIO76 = 1; // Load output latch. Recommended in rm
    GpioCtrlRegs.GPCDIR.bit.GPIO76 = 1; // set it as output

    EDIS;

}
void InitSystem(void) // burayi yukari alalim
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

   // Module-4 Enables
   GpioDataRegs.GPCTOGGLE.bit.GPIO74 = 1;
   GpioDataRegs.GPCTOGGLE.bit.GPIO75 = 1;
   GpioDataRegs.GPCTOGGLE.bit.GPIO76 = 1;

   // Module-3 Enables
   GpioDataRegs.GPCTOGGLE.bit.GPIO77 = 1;
   GpioDataRegs.GPCTOGGLE.bit.GPIO78 = 1;
   GpioDataRegs.GPCTOGGLE.bit.GPIO79 = 1;

   // Module-2 Enables
   GpioDataRegs.GPCTOGGLE.bit.GPIO91 = 1;
   GpioDataRegs.GPCTOGGLE.bit.GPIO90 = 1;
   GpioDataRegs.GPCTOGGLE.bit.GPIO89 = 1;

   // Module-1 Enables
   //GpioDataRegs.GPCTOGGLE.bit.GPIO94 = 1;
   //GpioDataRegs.GPCTOGGLE.bit.GPIO93 = 1;
   GpioDataRegs.GPCTOGGLE.bit.GPIO92 = 1;

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
   //GpioDataRegs.GPATOGGLE.bit.GPIO31 = 1;

}
__interrupt void epwm1_isr(void)
{
    GpioDataRegs.GPCSET.bit.GPIO94 = 1;
    // Update the CMPA and CMPB values
    //update_compare(&epwm1_info);
    // Clear INT flag for this timer
    EPwm1Regs.ETCLR.bit.INT = 1;
    //GpioDataRegs.GPBTOGGLE.bit.GPIO34 = 1;
    //EPwm1Regs.CMPA.half.CMPA = 12500;
    //if(EPwm1Regs.CMPA.half.CMPA>=45)
    //    EPwm1Regs.CMPA.half.CMPA=0;    // Set compare A value
    //else
    //    EPwm1Regs.CMPA.half.CMPA+=1;

    // Acknowledge this interrupt to receive more interrupts from group 3
    PieCtrlRegs.PIEACK.all = PIEACK_GROUP3;
    GpioDataRegs.GPCCLEAR.bit.GPIO94 = 1;
}

__interrupt void adc1_isr(void)
{
    GpioDataRegs.GPCSET.bit.GPIO93 = 1;

    Vdc_M3_adc    = AdcaResultRegs.ADCRESULT0;
    Vdc_M1_adc    = AdcaResultRegs.ADCRESULT1;
    Is_M3_PhC_adc = AdcaResultRegs.ADCRESULT3;
    Is_M1_PhA_adc = AdcaResultRegs.ADCRESULT4;
    Is_M2_PhB_adc = AdcaResultRegs.ADCRESULT5;
    Is_M3_PhB_adc = AdcaResultRegs.ADCRESULT14;
    Is_M3_PhA_adc = AdcaResultRegs.ADCRESULT15;

    Is_M4_PhB_adc = AdcbResultRegs.ADCRESULT0;
    Is_M4_PhC_adc = AdcbResultRegs.ADCRESULT1;
    Is_M2_PhC_adc = AdcbResultRegs.ADCRESULT2;
    Is_M4_PhA_adc = AdcbResultRegs.ADCRESULT3;

    Is_M2_PhA_adc = AdccResultRegs.ADCRESULT2;
    Is_M1_PhC_adc = AdccResultRegs.ADCRESULT3;
    Is_M1_PhB_adc = AdccResultRegs.ADCRESULT4;

    Vdc_M4_adc    = AdcdResultRegs.ADCRESULT0;
    Vdc_M2_adc    = AdcdResultRegs.ADCRESULT1;

    /*
    AdcRegs.ADCTRL2.bit.RST_SEQ1=1; // Clear INT SEQ1 bit
    AdcRegs.ADCST.bit.INT_SEQ1_CLR = 1;     // Clear INT SEQ1 bit
    */

    //AdcaRegs.ADCINTFLG.bit.ADCINT1 // ADC Interrupt 1 Flag. Reading these flags indicates if the associated ADCINT pulse was generated since the last clear
    AdcaRegs.ADCINTFLGCLR.bit.ADCINT1 = 1;  // Clears respective flag bit in the ADCINTFLG register
    PieCtrlRegs.PIEACK.all = PIEACK_GROUP1; // Acknowledge interrupt to PIE

    GpioDataRegs.GPCCLEAR.bit.GPIO93 = 1;

}

void Setup_ADC(void)
{

    // AdcaRegs.ADCSOCFRC1.all = 0x000F; // Bi ara bakalim

    EALLOW;
    AdcaRegs.ADCCTL1.all = 0x00;            // ADC Control 1 Register
    AdcaRegs.ADCCTL1.bit.ADCPWDNZ = 1;      // All analog circuitry inside the core is powered up
    AdcaRegs.ADCCTL1.bit.INTPULSEPOS = 1;   // ? Interrupt pulse generation occurs at the end of the conversion, 1 cycle prior to the ADC result latching into its result register

    AdcbRegs.ADCCTL1.all = 0x00;            // ADC Control 1 Register
    AdcbRegs.ADCCTL1.bit.ADCPWDNZ = 1;      // All analog circuitry inside the core is powered up
    AdcbRegs.ADCCTL1.bit.INTPULSEPOS = 1;   // ? Interrupt pulse generation occurs at the end of the conversion, 1 cycle prior to the ADC result latching into its result register

    AdccRegs.ADCCTL1.all = 0x00;            // ADC Control 1 Register
    AdccRegs.ADCCTL1.bit.ADCPWDNZ = 1;      // All analog circuitry inside the core is powered up
    AdccRegs.ADCCTL1.bit.INTPULSEPOS = 1;   // ? Interrupt pulse generation occurs at the end of the conversion, 1 cycle prior to the ADC result latching into its result register

    AdcdRegs.ADCCTL1.all = 0x00;            // ADC Control 1 Register
    AdcdRegs.ADCCTL1.bit.ADCPWDNZ = 1;      // All analog circuitry inside the core is powered up
    AdcdRegs.ADCCTL1.bit.INTPULSEPOS = 1;   // ? Interrupt pulse generation occurs at the end of the conversion, 1 cycle prior to the ADC result latching into its result register

    AdcaRegs.ADCCTL2.all = 0x00;            // ADC Control 2 Register
    AdcaRegs.ADCCTL2.bit.SIGNALMODE = 0;    // Single-ended
    AdcaRegs.ADCCTL2.bit.RESOLUTION = 0;    // 12-bit resolution
    AdcaRegs.ADCCTL2.bit.PRESCALE = 0;      // ADCCLK = Input Clock / 1.0

    AdcbRegs.ADCCTL2.all = 0x00;            // ADC Control 2 Register
    AdcbRegs.ADCCTL2.bit.SIGNALMODE = 0;    // Single-ended
    AdcbRegs.ADCCTL2.bit.RESOLUTION = 0;    // 12-bit resolution
    AdcbRegs.ADCCTL2.bit.PRESCALE = 0;      // ADCCLK = Input Clock / 1.0

    AdccRegs.ADCCTL2.all = 0x00;            // ADC Control 2 Register
    AdccRegs.ADCCTL2.bit.SIGNALMODE = 0;    // Single-ended
    AdccRegs.ADCCTL2.bit.RESOLUTION = 0;    // 12-bit resolution
    AdccRegs.ADCCTL2.bit.PRESCALE = 0;      // ADCCLK = Input Clock / 1.0

    AdcdRegs.ADCCTL2.all = 0x00;            // ADC Control 2 Register
    AdcdRegs.ADCCTL2.bit.SIGNALMODE = 0;    // Single-ended
    AdcdRegs.ADCCTL2.bit.RESOLUTION = 0;    // 12-bit resolution
    AdcdRegs.ADCCTL2.bit.PRESCALE = 0;      // ADCCLK = Input Clock / 1.0

    AdcaRegs.ADCBURSTCTL.all = 0x00;        // ADC Burst Control Register
    AdcaRegs.ADCBURSTCTL.bit.BURSTEN = 0;   // Burst mode is disabled

    AdcbRegs.ADCBURSTCTL.all = 0x00;        // ADC Burst Control Register
    AdcbRegs.ADCBURSTCTL.bit.BURSTEN = 0;   // Burst mode is disabled

    AdccRegs.ADCBURSTCTL.all = 0x00;        // ADC Burst Control Register
    AdccRegs.ADCBURSTCTL.bit.BURSTEN = 0;   // Burst mode is disabled

    AdcdRegs.ADCBURSTCTL.all = 0x00;        // ADC Burst Control Register
    AdcdRegs.ADCBURSTCTL.bit.BURSTEN = 0;   // Burst mode is disabled

    AdcaRegs.ADCINTSEL1N2.all = 0x00;       // ADC Interrupt 1 and 2 Selection Register
    AdcaRegs.ADCINTSEL1N2.bit.INT1CONT = 0; // No further ADCINT1 pulses are generated until ADCINT1 flag (in ADCINTFLG register) is cleared by user
    AdcaRegs.ADCINTSEL1N2.bit.INT1E = 1;    // ADCINT1 is enabled
    AdcaRegs.ADCINTSEL1N2.bit.INT1SEL = 0;  // ? EOC0 is trigger for ADCINT1
    AdcaRegs.ADCINTFLGCLR.bit.ADCINT1 = 1;  // Clears respective flag bit in the ADCINTFLG register
    AdcaRegs.ADCINTSEL3N4.all = 0x00;       // ADC Interrupt 3 and 4 Selection Register

    AdcaRegs.ADCSOCPRICTL.all = 0x00;       // ADC SOC Priority Control Register
    AdcaRegs.ADCSOCPRICTL.bit.SOCPRIORITY = 0; // SOC priority is handled in round robin mode for all channels

    AdcaRegs.ADCINTSOCSEL1.all = 0x00;      // ADC Interrupt SOC Selection 1 Register
    AdcbRegs.ADCINTSOCSEL1.all = 0x00;      // ADC Interrupt SOC Selection 1 Register
    AdccRegs.ADCINTSOCSEL1.all = 0x00;      // ADC Interrupt SOC Selection 1 Register
    AdcdRegs.ADCINTSOCSEL1.all = 0x00;      // ADC Interrupt SOC Selection 1 Register
    /*
    AdcaRegs.ADCINTSOCSEL1.bit.SOC0 = 1; // ADCINT1 will trigger SOC0
    AdcaRegs.ADCINTSOCSEL1.bit.SOC1 = 1; // ADCINT1 will trigger SOC1
    AdcaRegs.ADCINTSOCSEL1.bit.SOC2 = 1; // ADCINT1 will trigger SOC2
    AdcaRegs.ADCINTSOCSEL1.bit.SOC3 = 1; // ADCINT1 will trigger SOC3
    AdcaRegs.ADCINTSOCSEL1.bit.SOC4 = 1; // ADCINT1 will trigger SOC4
    AdcaRegs.ADCINTSOCSEL1.bit.SOC5 = 1; // ADCINT1 will trigger SOC5
    AdcaRegs.ADCINTSOCSEL1.bit.SOC6 = 1; // ADCINT1 will trigger SOC6
    AdcaRegs.ADCINTSOCSEL1.bit.SOC7 = 1; // ADCINT1 will trigger SOC7
    */

    AdcaRegs.ADCINTSOCSEL2.all = 0x00; // ADC Interrupt SOC Selection 2 Register
    AdcbRegs.ADCINTSOCSEL2.all = 0x00; // ADC Interrupt SOC Selection 2 Register
    AdccRegs.ADCINTSOCSEL2.all = 0x00; // ADC Interrupt SOC Selection 2 Register
    AdcdRegs.ADCINTSOCSEL2.all = 0x00; // ADC Interrupt SOC Selection 2 Register
    /*
    AdcaRegs.ADCINTSOCSEL2.bit.SOC8 = 1; // ADCINT1 will trigger SOC8
    AdcaRegs.ADCINTSOCSEL2.bit.SOC9 = 1; // ADCINT1 will trigger SOC9
    AdcaRegs.ADCINTSOCSEL2.bit.SOC10 = 1; // ADCINT1 will trigger SOC10
    AdcaRegs.ADCINTSOCSEL2.bit.SOC11 = 1; // ADCINT1 will trigger SOC11
    AdcaRegs.ADCINTSOCSEL2.bit.SOC12 = 1; // ADCINT1 will trigger SOC12
    AdcaRegs.ADCINTSOCSEL2.bit.SOC13 = 1; // ADCINT1 will trigger SOC13
    AdcaRegs.ADCINTSOCSEL2.bit.SOC14 = 1; // ADCINT1 will trigger SOC14
    AdcaRegs.ADCINTSOCSEL2.bit.SOC15 = 1; // ADCINT1 will trigger SOC15
    */

    // AdcaRegs.ADCSOC0CTL.bit.TRIGSEL: SOC0 Trigger Source Select.
    // Along with the SOC0 field in the ADCINTSOCSEL1 register, this bit field configures which trigger will set the SOC0 flag
    // in the ADCSOCFLG1 register to initiate a conversion to start once priority is given to it
    // AdcaRegs.ADCSOC0CTL.bit.CHSEL: SOC0 Channel Select.
    // Selects the channel to be converted when SOC0 is received by the ADC
    // AdcaRegs.ADCSOC0CTL.bit.ACQPS: SOC0 Acquisition Prescale

    // Vdc_M3_adc
    AdcaRegs.ADCSOC0CTL.all = 0x0000;    // ADC SOC0 Control Register
    AdcaRegs.ADCSOC0CTL.bit.TRIGSEL = 7; // ADCTRIG5 - ePWM2, ADCSOCA
    AdcaRegs.ADCSOC0CTL.bit.CHSEL = 0;   // Single-ended ADCINA0
    AdcaRegs.ADCSOC0CTL.bit.ACQPS = 0;   // Sample window is 1 system clock cycle wide
    // Vdc_M1_adc
    AdcaRegs.ADCSOC1CTL.all = 0x0000;    // ADC SOC1 Control Register
    AdcaRegs.ADCSOC1CTL.bit.TRIGSEL = 7; // ADCTRIG5 - ePWM2, ADCSOCA
    AdcaRegs.ADCSOC1CTL.bit.CHSEL = 1;   // Single-ended ADCINA1
    AdcaRegs.ADCSOC1CTL.bit.ACQPS = 0;   // Sample window is 1 system clock cycle wide
    //AdcaRegs.ADCSOC2CTL.all = 0x0000;    // ADC SOC2 Control Register
    //AdcaRegs.ADCSOC2CTL.bit.TRIGSEL = 7; // ADCTRIG5 - ePWM2, ADCSOCA
    //AdcaRegs.ADCSOC2CTL.bit.CHSEL = 2;   // Single-ended ADCINA2
    //AdcaRegs.ADCSOC2CTL.bit.ACQPS = 0;   // Sample window is 1 system clock cycle wide
    // Is_M3_PhC_adc
    AdcaRegs.ADCSOC3CTL.all = 0x0000;    // ADC SOC3 Control Register
    AdcaRegs.ADCSOC3CTL.bit.TRIGSEL = 7; // ADCTRIG5 - ePWM2, ADCSOCA
    AdcaRegs.ADCSOC3CTL.bit.CHSEL = 3;   // Single-ended ADCINA3
    AdcaRegs.ADCSOC3CTL.bit.ACQPS = 0;   // Sample window is 1 system clock cycle wide
    // Is_M1_PhA_adc
    AdcaRegs.ADCSOC4CTL.all = 0x0000;    // ADC SOC4 Control Register
    AdcaRegs.ADCSOC4CTL.bit.TRIGSEL = 7; // ADCTRIG5 - ePWM2, ADCSOCA
    AdcaRegs.ADCSOC4CTL.bit.CHSEL = 4;   // Single-ended ADCINA4
    AdcaRegs.ADCSOC4CTL.bit.ACQPS = 0;   // Sample window is 1 system clock cycle wide
    // Is_M2_PhB_adc
    AdcaRegs.ADCSOC5CTL.all = 0x0000;    // ADC SOC5 Control Register
    AdcaRegs.ADCSOC5CTL.bit.TRIGSEL = 7; // ADCTRIG5 - ePWM2, ADCSOCA
    AdcaRegs.ADCSOC5CTL.bit.CHSEL = 5;   // Single-ended ADCINA5
    AdcaRegs.ADCSOC5CTL.bit.ACQPS = 0;   // Sample window is 1 system clock cycle wide
    // Is_M3_PhB_adc
    AdcaRegs.ADCSOC14CTL.all = 0x0000;    // ADC SOC14 Control Register
    AdcaRegs.ADCSOC14CTL.bit.TRIGSEL = 7; // ADCTRIG5 - ePWM2, ADCSOCA
    AdcaRegs.ADCSOC14CTL.bit.CHSEL = 14;   // Single-ended ADCIN14
    AdcaRegs.ADCSOC14CTL.bit.ACQPS = 0;   // Sample window is 1 system clock cycle wide
    // Is_M3_PhA_adc
    AdcaRegs.ADCSOC15CTL.all = 0x0000;    // ADC SOC15 Control Register
    AdcaRegs.ADCSOC15CTL.bit.TRIGSEL = 7; // ADCTRIG5 - ePWM2, ADCSOCA
    AdcaRegs.ADCSOC15CTL.bit.CHSEL = 15;   // Single-ended ADCIN15
    AdcaRegs.ADCSOC15CTL.bit.ACQPS = 0;   // Sample window is 1 system clock cycle wide
    // Is_M4_PhB_adc
    AdcbRegs.ADCSOC0CTL.all = 0x0000;    // ADC SOC0 Control Register
    AdcbRegs.ADCSOC0CTL.bit.TRIGSEL = 7; // ADCTRIG5 - ePWM2, ADCSOCA
    AdcbRegs.ADCSOC0CTL.bit.CHSEL = 0;   // Single-ended ADCINB0
    AdcbRegs.ADCSOC0CTL.bit.ACQPS = 0;   // Sample window is 1 system clock cycle wide
    // Is_M4_PhC_adc
    AdcbRegs.ADCSOC1CTL.all = 0x0000;    // ADC SOC1 Control Register
    AdcbRegs.ADCSOC1CTL.bit.TRIGSEL = 7; // ADCTRIG5 - ePWM2, ADCSOCA
    AdcbRegs.ADCSOC1CTL.bit.CHSEL = 1;   // Single-ended ADCINB1
    AdcbRegs.ADCSOC1CTL.bit.ACQPS = 0;   // Sample window is 1 system clock cycle wide
    // Is_M2_PhC_adc
    AdcbRegs.ADCSOC2CTL.all = 0x0000;    // ADC SOC2 Control Register
    AdcbRegs.ADCSOC2CTL.bit.TRIGSEL = 7; // ADCTRIG5 - ePWM2, ADCSOCA
    AdcbRegs.ADCSOC2CTL.bit.CHSEL = 2;   // Single-ended ADCINB2
    AdcbRegs.ADCSOC2CTL.bit.ACQPS = 0;   // Sample window is 1 system clock cycle wide
    // Is_M4_PhA_adc
    AdcbRegs.ADCSOC3CTL.all = 0x0000;    // ADC SOC3 Control Register
    AdcbRegs.ADCSOC3CTL.bit.TRIGSEL = 7; // ADCTRIG5 - ePWM2, ADCSOCA
    AdcbRegs.ADCSOC3CTL.bit.CHSEL = 3;   // Single-ended ADCIB3
    AdcbRegs.ADCSOC3CTL.bit.ACQPS = 0;   // Sample window is 1 system clock cycle wide
    //AdcbRegs.ADCSOC4CTL.all = 0x0000;    // ADC SOC4 Control Register
    //AdcbRegs.ADCSOC4CTL.bit.TRIGSEL = 7; // ADCTRIG5 - ePWM2, ADCSOCA
    //AdcbRegs.ADCSOC4CTL.bit.CHSEL = 4;   // Single-ended ADCINB4
    //AdcbRegs.ADCSOC4CTL.bit.ACQPS = 0;   // Sample window is 1 system clock cycle wide
    //AdcbRegs.ADCSOC5CTL.all = 0x0000;    // ADC SOC5 Control Register
    //AdcbRegs.ADCSOC5CTL.bit.TRIGSEL = 7; // ADCTRIG5 - ePWM2, ADCSOCA
    //AdcbRegs.ADCSOC5CTL.bit.CHSEL = 5;   // Single-ended ADCINB5
    //AdcbRegs.ADCSOC5CTL.bit.ACQPS = 0;   // Sample window is 1 system clock cycle wide
    // Is_M2_PhA_adc
    AdccRegs.ADCSOC2CTL.all = 0x0000;    // ADC SOC2 Control Register
    AdccRegs.ADCSOC2CTL.bit.TRIGSEL = 7; // ADCTRIG5 - ePWM2, ADCSOCA
    AdccRegs.ADCSOC2CTL.bit.CHSEL = 2;   // Single-ended ADCINC2
    AdccRegs.ADCSOC2CTL.bit.ACQPS = 0;   // Sample window is 1 system clock cycle wide
    // Is_M1_PhC_adc
    AdccRegs.ADCSOC3CTL.all = 0x0000;    // ADC SOC3 Control Register
    AdccRegs.ADCSOC3CTL.bit.TRIGSEL = 7; // ADCTRIG5 - ePWM2, ADCSOCA
    AdccRegs.ADCSOC3CTL.bit.CHSEL = 3;   // Single-ended ADCINC3
    AdccRegs.ADCSOC3CTL.bit.ACQPS = 0;   // Sample window is 1 system clock cycle wide
    // Is_M1_PhB_adc
    AdccRegs.ADCSOC4CTL.all = 0x0000;    // ADC SOC4 Control Register
    AdccRegs.ADCSOC4CTL.bit.TRIGSEL = 7; // ADCTRIG5 - ePWM2, ADCSOCA
    AdccRegs.ADCSOC4CTL.bit.CHSEL = 4;   // Single-ended ADCINC4
    AdccRegs.ADCSOC4CTL.bit.ACQPS = 0;   // Sample window is 1 system clock cycle wide
    //AdccRegs.ADCSOC5CTL.all = 0x0000;    // ADC SOC5 Control Register
    //AdccRegs.ADCSOC5CTL.bit.TRIGSEL = 7; // ADCTRIG5 - ePWM2, ADCSOCA
    //AdccRegs.ADCSOC5CTL.bit.CHSEL = 5;   // Single-ended ADCINC5
    //AdccRegs.ADCSOC5CTL.bit.ACQPS = 0;   // Sample window is 1 system clock cycle wide
    // Vdc_M4_adc
    AdcdRegs.ADCSOC0CTL.all = 0x0000;    // ADC SOC0 Control Register
    AdcdRegs.ADCSOC0CTL.bit.TRIGSEL = 7; // ADCTRIG5 - ePWM2, ADCSOCA
    AdcdRegs.ADCSOC0CTL.bit.CHSEL = 0;   // Single-ended ADCIND0
    AdcdRegs.ADCSOC0CTL.bit.ACQPS = 0;   // Sample window is 1 system clock cycle wide
    // Vdc_M2_adc
    AdcdRegs.ADCSOC1CTL.all = 0x0000;    // ADC SOC1 Control Register
    AdcdRegs.ADCSOC1CTL.bit.TRIGSEL = 7; // ADCTRIG5 - ePWM2, ADCSOCA
    AdcdRegs.ADCSOC1CTL.bit.CHSEL = 1;   // Single-ended ADCIND1
    AdcdRegs.ADCSOC1CTL.bit.ACQPS = 0;   // Sample window is 1 system clock cycle wide
    //AdcdRegs.ADCSOC2CTL.all = 0x0000;    // ADC SOC2 Control Register
    //AdcdRegs.ADCSOC2CTL.bit.TRIGSEL = 7; // ADCTRIG5 - ePWM2, ADCSOCA
    //AdcdRegs.ADCSOC2CTL.bit.CHSEL = 2;   // Single-ended ADCIND2
    //AdcdRegs.ADCSOC2CTL.bit.ACQPS = 0;   // Sample window is 1 system clock cycle wide
    //AdcdRegs.ADCSOC3CTL.all = 0x0000;    // ADC SOC3 Control Register
    //AdcdRegs.ADCSOC3CTL.bit.TRIGSEL = 7; // ADCTRIG5 - ePWM2, ADCSOCA
    //AdcdRegs.ADCSOC3CTL.bit.CHSEL = 3;   // Single-ended ADCIND3
    //AdcdRegs.ADCSOC3CTL.bit.ACQPS = 0;   // Sample window is 1 system clock cycle wide
    //AdcdRegs.ADCSOC4CTL.all = 0x0000;    // ADC SOC4 Control Register
    //AdcdRegs.ADCSOC4CTL.bit.TRIGSEL = 7; // ADCTRIG5 - ePWM2, ADCSOCA
    //AdcdRegs.ADCSOC4CTL.bit.CHSEL = 4;   // Single-ended ADCIND4
    //AdcdRegs.ADCSOC4CTL.bit.ACQPS = 0;   // Sample window is 1 system clock cycle wide
    //AdcdRegs.ADCSOC5CTL.all = 0x0000;    // ADC SOC5 Control Register
    //AdcdRegs.ADCSOC5CTL.bit.TRIGSEL = 7; // ADCTRIG5 - ePWM2, ADCSOCA
    //AdcdRegs.ADCSOC5CTL.bit.CHSEL = 5;   // Single-ended ADCIND5
    //AdcdRegs.ADCSOC5CTL.bit.ACQPS = 0;   // Sample window is 1 system clock cycle wide

    DELAY_US(1000);

    EDIS;

}
void InitEpwm1(void)
{
    EPwm1Regs.TBCTL.all = 0x00;
    EPwm1Regs.TBCTL.bit.CTRMODE = 2;   // Count up and douwn
    EPwm1Regs.TBCTL.bit.CLKDIV = 0;    // TBCLOK = EPWMCLOCK/(128*10) = 78125Hz
    EPwm1Regs.TBCTL.bit.HSPCLKDIV = 0;

    EPwm1Regs.TBPRD = 25000;
    EPwm1Regs.TBCTR = 0x0000;          // Clear counter

    EPwm1Regs.CMPCTL.all = 0x00;
    EPwm1Regs.CMPCTL.bit.SHDWAMODE = 1;//only active registers are used
    //EPwm1Regs.CMPCTL.bit.SHDWBMODE = 1;//only active registers are used

    EPwm1Regs.AQCTLA.all = 0x00;
    EPwm1Regs.AQCTLA.bit.CAU = 2; //set high
    EPwm1Regs.AQCTLA.bit.CAD = 1; //set low
    //EPwm1Regs.AQCTLB.all = 0x00;
    //EPwm1Regs.AQCTLB.bit.CBU = 1; //set low
    //EPwm1Regs.AQCTLB.bit.CBD = 2; //set high

    EPwm1Regs.CMPA.half.CMPA = 12500;    // Set compare A value
    //EPwm1Regs.CMPB.half.CMPB = EPwm1Regs.TBPRD/2;    // Set Compare B value

    EPwm1Regs.TBPHS.half.TBPHS = 0x0000;          // Phase is 0

    EPwm1Regs.TBCTL2.all = 0x00;
    EPwm1Regs.CMPCTL2.all = 0x00;
    EPwm1Regs.DBCTL.all = 0x00;
    EPwm1Regs.DBCTL.bit.OUT_MODE = 3;
    EPwm1Regs.DBCTL.bit.POLSEL = 2;
    EPwm1Regs.DBFED = 500;
    EPwm1Regs.DBRED = 500;
    EPwm1Regs.DBCTL2.all = 0x00;

    EPwm1Regs.ETSEL.all = 0x00;
    EPwm1Regs.ETSEL.bit.INTSEL = 1; // When TBCTR == 0
    EPwm1Regs.ETSEL.bit.INTEN = 1;  // Enable INT
    EPwm1Regs.ETPS.all = 0x00;
    EPwm1Regs.ETPS.bit.INTPRD = 1;  // Generate INT on first event

}

void InitEpwm2(void)
{

    EPwm2Regs.TBCTL.all = 0x00;
    EPwm2Regs.TBCTL.bit.CTRMODE = 2;   // Count up and douwn
    EPwm2Regs.TBCTL.bit.CLKDIV = 0;    // TBCLOK = EPWMCLOCK/(128*10) = 78125Hz
    EPwm2Regs.TBCTL.bit.HSPCLKDIV = 0;

    EPwm2Regs.TBPRD = 25000;
    EPwm2Regs.TBCTR = 0x0000;          // Clear counter

    EPwm2Regs.CMPCTL.all = 0x00;
    EPwm2Regs.CMPCTL.bit.SHDWAMODE = 1;//only active registers are used
    //EPwm2Regs.CMPCTL.bit.SHDWBMODE = 1;//only active registers are used

    EPwm2Regs.AQCTLA.all = 0x00;
    EPwm2Regs.AQCTLA.bit.CAU = 2; //set high
    EPwm2Regs.AQCTLA.bit.CAD = 1; //set low
    //EPwm2Regs.AQCTLB.all = 0x00;
    //EPwm2Regs.AQCTLB.bit.CBU = 1; //set low
    //EPwm2Regs.AQCTLB.bit.CBD = 2; //set high

    EPwm2Regs.CMPA.half.CMPA = 12500;    // Set compare A value
    //EPwm2Regs.CMPB.half.CMPB = EPwm2Regs.TBPRD/2;    // Set Compare B value

    EPwm2Regs.TBPHS.half.TBPHS = 0x0000;          // Phase is 0

    EPwm2Regs.TBCTL2.all = 0x00;
    EPwm2Regs.CMPCTL2.all = 0x00;
    EPwm2Regs.DBCTL.all = 0x00;
    EPwm2Regs.DBCTL.bit.OUT_MODE = 3;
    EPwm2Regs.DBCTL.bit.POLSEL = 2;
    EPwm2Regs.DBFED = 500;
    EPwm2Regs.DBRED = 500;
    EPwm2Regs.DBCTL2.all = 0x00;

    EPwm2Regs.ETSEL.all = 0x00;
    EPwm2Regs.ETSEL.bit.SOCAEN  = 1;  // Enable SOCA generation
    EPwm2Regs.ETSEL.bit.SOCASEL = 2;  // Generate SOCA when CTR = PRD
    //EPwm2Regs.ETSEL.bit.INTEN = 1;
    //EPwm2Regs.ETSEL.bit.INTSEL = 1;
    EPwm2Regs.ETPS.bit.SOCAPRD = 1;   // Interrupt on the first event
    //EPwm2Regs.ETPS.bit.INTPRD = 1;

}

void InitEpwm3(void)
{

    EPwm3Regs.TBCTL.all = 0x00;
    EPwm3Regs.TBCTL.bit.CTRMODE = 2;   // Count up and douwn
    EPwm3Regs.TBCTL.bit.CLKDIV = 0;    // TBCLOK = EPWMCLOCK/(128*10) = 78125Hz
    EPwm3Regs.TBCTL.bit.HSPCLKDIV = 0;

    EPwm3Regs.TBPRD = 25000;
    EPwm3Regs.TBCTR = 0x0000;          // Clear counter

    EPwm3Regs.CMPCTL.all = 0x00;
    EPwm3Regs.CMPCTL.bit.SHDWAMODE = 1;//only active registers are used
    //EPwm3Regs.CMPCTL.bit.SHDWBMODE = 1;//only active registers are used

    EPwm3Regs.AQCTLA.all = 0x00;
    EPwm3Regs.AQCTLA.bit.CAU = 2; //set high
    EPwm3Regs.AQCTLA.bit.CAD = 1; //set low
    //EPwm3Regs.AQCTLB.all = 0x00;
    //EPwm3Regs.AQCTLB.bit.CBU = 1; //set low
    //EPwm3Regs.AQCTLB.bit.CBD = 2; //set high

    EPwm3Regs.CMPA.half.CMPA = 12500;    // Set compare A value
    //EPwm3Regs.CMPB.half.CMPB = EPwm3Regs.TBPRD/2;    // Set Compare B value

    EPwm3Regs.TBPHS.half.TBPHS = 0x0000;          // Phase is 0

    EPwm3Regs.TBCTL2.all = 0x00;
    EPwm3Regs.CMPCTL2.all = 0x00;
    EPwm3Regs.DBCTL.all = 0x00;
    EPwm3Regs.DBCTL.bit.OUT_MODE = 3;
    EPwm3Regs.DBCTL.bit.POLSEL = 2;
    EPwm3Regs.DBFED = 500;
    EPwm3Regs.DBRED = 500;
    EPwm3Regs.DBCTL2.all = 0x00;

    EPwm3Regs.ETSEL.all = 0x00;

}

void InitEpwm4(void)
{

    EPwm4Regs.TBCTL.all = 0x00;
    EPwm4Regs.TBCTL.bit.CTRMODE = 2;   // Count up and douwn
    EPwm4Regs.TBCTL.bit.CLKDIV = 0;    // TBCLOK = EPWMCLOCK/(128*10) = 78125Hz
    EPwm4Regs.TBCTL.bit.HSPCLKDIV = 0;

    EPwm4Regs.TBPRD = 25000;
    EPwm4Regs.TBCTR = 0x0000;          // Clear counter

    EPwm4Regs.CMPCTL.all = 0x00;
    EPwm4Regs.CMPCTL.bit.SHDWAMODE = 1;//only active registers are used
    //EPwm4Regs.CMPCTL.bit.SHDWBMODE = 1;//only active registers are used

    EPwm4Regs.AQCTLA.all = 0x00;
    EPwm4Regs.AQCTLA.bit.CAU = 2; //set high
    EPwm4Regs.AQCTLA.bit.CAD = 1; //set low
    //EPwm4Regs.AQCTLB.all = 0x00;
    //EPwm4Regs.AQCTLB.bit.CBU = 1; //set low
    //EPwm4Regs.AQCTLB.bit.CBD = 2; //set high

    EPwm4Regs.CMPA.half.CMPA = 12500;    // Set compare A value
    //EPwm4Regs.CMPB.half.CMPB = EPwm4Regs.TBPRD/2;    // Set Compare B value

    EPwm4Regs.TBPHS.half.TBPHS = 0x0000;          // Phase is 0

    EPwm4Regs.TBCTL2.all = 0x00;
    EPwm4Regs.CMPCTL2.all = 0x00;
    EPwm4Regs.DBCTL.all = 0x00;
    EPwm4Regs.DBCTL.bit.OUT_MODE = 3;
    EPwm4Regs.DBCTL.bit.POLSEL = 2;
    EPwm4Regs.DBFED = 500;
    EPwm4Regs.DBRED = 500;
    EPwm4Regs.DBCTL2.all = 0x00;

    EPwm4Regs.ETSEL.all = 0x00;

}

void InitEpwm5(void)
{

    EPwm5Regs.TBCTL.all = 0x00;
    EPwm5Regs.TBCTL.bit.CTRMODE = 2;   // Count up and douwn
    EPwm5Regs.TBCTL.bit.CLKDIV = 0;    // TBCLOK = EPWMCLOCK/(128*10) = 78125Hz
    EPwm5Regs.TBCTL.bit.HSPCLKDIV = 0;

    EPwm5Regs.TBPRD = 25000;
    EPwm5Regs.TBCTR = 0x0000;          // Clear counter

    EPwm5Regs.CMPCTL.all = 0x00;
    EPwm5Regs.CMPCTL.bit.SHDWAMODE = 1;//only active registers are used
    //EPwm5Regs.CMPCTL.bit.SHDWBMODE = 1;//only active registers are used

    EPwm5Regs.AQCTLA.all = 0x00;
    EPwm5Regs.AQCTLA.bit.CAU = 2; //set high
    EPwm5Regs.AQCTLA.bit.CAD = 1; //set low
    //EPwm5Regs.AQCTLB.all = 0x00;
    //EPwm5Regs.AQCTLB.bit.CBU = 1; //set low
    //EPwm5Regs.AQCTLB.bit.CBD = 2; //set high

    EPwm5Regs.CMPA.half.CMPA = 12500;    // Set compare A value
    //EPwm5Regs.CMPB.half.CMPB = EPwm5Regs.TBPRD/2;    // Set Compare B value

    EPwm5Regs.TBPHS.half.TBPHS = 0x0000;          // Phase is 0

    EPwm5Regs.TBCTL2.all = 0x00;
    EPwm5Regs.CMPCTL2.all = 0x00;
    EPwm5Regs.DBCTL.all = 0x00;
    EPwm5Regs.DBCTL.bit.OUT_MODE = 3;
    EPwm5Regs.DBCTL.bit.POLSEL = 2;
    EPwm5Regs.DBFED = 500;
    EPwm5Regs.DBRED = 500;
    EPwm5Regs.DBCTL2.all = 0x00;

    EPwm5Regs.ETSEL.all = 0x00;

}

void InitEpwm6(void)
{

    EPwm6Regs.TBCTL.all = 0x00;
     EPwm6Regs.TBCTL.bit.CTRMODE = 2;   // Count up and douwn
     EPwm6Regs.TBCTL.bit.CLKDIV = 0;    // TBCLOK = EPWMCLOCK/(128*10) = 78125Hz
     EPwm6Regs.TBCTL.bit.HSPCLKDIV = 0;

     EPwm6Regs.TBPRD = 25000;
     EPwm6Regs.TBCTR = 0x0000;          // Clear counter

     EPwm6Regs.CMPCTL.all = 0x00;
     EPwm6Regs.CMPCTL.bit.SHDWAMODE = 1;//only active registers are used
     //EPwm6Regs.CMPCTL.bit.SHDWBMODE = 1;//only active registers are used

     EPwm6Regs.AQCTLA.all = 0x00;
     EPwm6Regs.AQCTLA.bit.CAU = 2; //set high
     EPwm6Regs.AQCTLA.bit.CAD = 1; //set low
     //EPwm6Regs.AQCTLB.all = 0x00;
     //EPwm6Regs.AQCTLB.bit.CBU = 1; //set low
     //EPwm6Regs.AQCTLB.bit.CBD = 2; //set high

     EPwm6Regs.CMPA.half.CMPA = 12500;    // Set compare A value
     //EPwm6Regs.CMPB.half.CMPB = EPwm6Regs.TBPRD/2;    // Set Compare B value

     EPwm6Regs.TBPHS.half.TBPHS = 0x0000;          // Phase is 0

     EPwm6Regs.TBCTL2.all = 0x00;
     EPwm6Regs.CMPCTL2.all = 0x00;
     EPwm6Regs.DBCTL.all = 0x00;
     EPwm6Regs.DBCTL.bit.OUT_MODE = 3;
     EPwm6Regs.DBCTL.bit.POLSEL = 2;
     EPwm6Regs.DBFED = 500;
     EPwm6Regs.DBRED = 500;
     EPwm6Regs.DBCTL2.all = 0x00;

     EPwm6Regs.ETSEL.all = 0x00;

}

void InitEpwm7(void)
{

    EPwm7Regs.TBCTL.all = 0x00;
    EPwm7Regs.TBCTL.bit.CTRMODE = 2;   // Count up and douwn
    EPwm7Regs.TBCTL.bit.CLKDIV = 0;    // TBCLOK = EPWMCLOCK/(128*10) = 78125Hz
    EPwm7Regs.TBCTL.bit.HSPCLKDIV = 0;

    EPwm7Regs.TBPRD = 25000;
    EPwm7Regs.TBCTR = 0x0000;          // Clear counter

    EPwm7Regs.CMPCTL.all = 0x00;
    EPwm7Regs.CMPCTL.bit.SHDWAMODE = 1;//only active registers are used
    //EPwm7Regs.CMPCTL.bit.SHDWBMODE = 1;//only active registers are used

    EPwm7Regs.AQCTLA.all = 0x00;
    EPwm7Regs.AQCTLA.bit.CAU = 2; //set high
    EPwm7Regs.AQCTLA.bit.CAD = 1; //set low
    //EPwm7Regs.AQCTLB.all = 0x00;
    //EPwm7Regs.AQCTLB.bit.CBU = 1; //set low
    //EPwm7Regs.AQCTLB.bit.CBD = 2; //set high

    EPwm7Regs.CMPA.half.CMPA = 12500;    // Set compare A value
    //EPwm7Regs.CMPB.half.CMPB = EPwm7Regs.TBPRD/2;    // Set Compare B value

    EPwm7Regs.TBPHS.half.TBPHS = 0x0000;          // Phase is 0

    EPwm7Regs.TBCTL2.all = 0x00;
    EPwm7Regs.CMPCTL2.all = 0x00;
    EPwm7Regs.DBCTL.all = 0x00;
    EPwm7Regs.DBCTL.bit.OUT_MODE = 3;
    EPwm7Regs.DBCTL.bit.POLSEL = 2;
    EPwm7Regs.DBFED = 500;
    EPwm7Regs.DBRED = 500;
    EPwm7Regs.DBCTL2.all = 0x00;

    EPwm7Regs.ETSEL.all = 0x00;

}

void InitEpwm8(void)
{

    EPwm8Regs.TBCTL.all = 0x00;
     EPwm8Regs.TBCTL.bit.CTRMODE = 2;   // Count up and douwn
     EPwm8Regs.TBCTL.bit.CLKDIV = 0;    // TBCLOK = EPWMCLOCK/(128*10) = 78125Hz
     EPwm8Regs.TBCTL.bit.HSPCLKDIV = 0;

     EPwm8Regs.TBPRD = 25000;
     EPwm8Regs.TBCTR = 0x0000;          // Clear counter

     EPwm8Regs.CMPCTL.all = 0x00;
     EPwm8Regs.CMPCTL.bit.SHDWAMODE = 1;//only active registers are used
     //EPwm8Regs.CMPCTL.bit.SHDWBMODE = 1;//only active registers are used

     EPwm8Regs.AQCTLA.all = 0x00;
     EPwm8Regs.AQCTLA.bit.CAU = 2; //set high
     EPwm8Regs.AQCTLA.bit.CAD = 1; //set low
     //EPwm8Regs.AQCTLB.all = 0x00;
     //EPwm8Regs.AQCTLB.bit.CBU = 1; //set low
     //EPwm8Regs.AQCTLB.bit.CBD = 2; //set high

     EPwm8Regs.CMPA.half.CMPA = 12500;    // Set compare A value
     //EPwm8Regs.CMPB.half.CMPB = EPwm8Regs.TBPRD/2;    // Set Compare B value

     EPwm8Regs.TBPHS.half.TBPHS = 0x0000;          // Phase is 0

     EPwm8Regs.TBCTL2.all = 0x00;
     EPwm8Regs.CMPCTL2.all = 0x00;
     EPwm8Regs.DBCTL.all = 0x00;
     EPwm8Regs.DBCTL.bit.OUT_MODE = 3;
     EPwm8Regs.DBCTL.bit.POLSEL = 2;
     EPwm8Regs.DBFED = 500;
     EPwm8Regs.DBRED = 500;
     EPwm8Regs.DBCTL2.all = 0x00;

     EPwm8Regs.ETSEL.all = 0x00;

}

void InitEpwm9(void)
{

    EPwm9Regs.TBCTL.all = 0x00;
     EPwm9Regs.TBCTL.bit.CTRMODE = 2;   // Count up and douwn
     EPwm9Regs.TBCTL.bit.CLKDIV = 0;    // TBCLOK = EPWMCLOCK/(128*10) = 78125Hz
     EPwm9Regs.TBCTL.bit.HSPCLKDIV = 0;

     EPwm9Regs.TBPRD = 25000;
     EPwm9Regs.TBCTR = 0x0000;          // Clear counter

     EPwm9Regs.CMPCTL.all = 0x00;
     EPwm9Regs.CMPCTL.bit.SHDWAMODE = 1;//only active registers are used
     //EPwm9Regs.CMPCTL.bit.SHDWBMODE = 1;//only active registers are used

     EPwm9Regs.AQCTLA.all = 0x00;
     EPwm9Regs.AQCTLA.bit.CAU = 2; //set high
     EPwm9Regs.AQCTLA.bit.CAD = 1; //set low
     //EPwm9Regs.AQCTLB.all = 0x00;
     //EPwm9Regs.AQCTLB.bit.CBU = 1; //set low
     //EPwm9Regs.AQCTLB.bit.CBD = 2; //set high

     EPwm9Regs.CMPA.half.CMPA = 12500;    // Set compare A value
     //EPwm9Regs.CMPB.half.CMPB = EPwm9Regs.TBPRD/2;    // Set Compare B value

     EPwm9Regs.TBPHS.half.TBPHS = 0x0000;          // Phase is 0

     EPwm9Regs.TBCTL2.all = 0x00;
     EPwm9Regs.CMPCTL2.all = 0x00;
     EPwm9Regs.DBCTL.all = 0x00;
     EPwm9Regs.DBCTL.bit.OUT_MODE = 3;
     EPwm9Regs.DBCTL.bit.POLSEL = 2;
     EPwm9Regs.DBFED = 500;
     EPwm9Regs.DBRED = 500;
     EPwm9Regs.DBCTL2.all = 0x00;

     EPwm9Regs.ETSEL.all = 0x00;

}

void InitEpwm10(void)
{

    EPwm10Regs.TBCTL.all = 0x00;
     EPwm10Regs.TBCTL.bit.CTRMODE = 2;   // Count up and douwn
     EPwm10Regs.TBCTL.bit.CLKDIV = 0;    // TBCLOK = EPWMCLOCK/(128*10) = 78125Hz
     EPwm10Regs.TBCTL.bit.HSPCLKDIV = 0;

     EPwm10Regs.TBPRD = 25000;
     EPwm10Regs.TBCTR = 0x0000;          // Clear counter

     EPwm10Regs.CMPCTL.all = 0x00;
     EPwm10Regs.CMPCTL.bit.SHDWAMODE = 1;//only active registers are used
     //EPwm10Regs.CMPCTL.bit.SHDWBMODE = 1;//only active registers are used

     EPwm10Regs.AQCTLA.all = 0x00;
     EPwm10Regs.AQCTLA.bit.CAU = 2; //set high
     EPwm10Regs.AQCTLA.bit.CAD = 1; //set low
     //EPwm10Regs.AQCTLB.all = 0x00;
     //EPwm10Regs.AQCTLB.bit.CBU = 1; //set low
     //EPwm10Regs.AQCTLB.bit.CBD = 2; //set high

     EPwm10Regs.CMPA.half.CMPA = 12500;    // Set compare A value
     //EPwm10Regs.CMPB.half.CMPB = EPwm10Regs.TBPRD/2;    // Set Compare B value

     EPwm10Regs.TBPHS.half.TBPHS = 0x0000;          // Phase is 0

     EPwm10Regs.TBCTL2.all = 0x00;
     EPwm10Regs.CMPCTL2.all = 0x00;
     EPwm10Regs.DBCTL.all = 0x00;
     EPwm10Regs.DBCTL.bit.OUT_MODE = 3;
     EPwm10Regs.DBCTL.bit.POLSEL = 2;
     EPwm10Regs.DBFED = 500;
     EPwm10Regs.DBRED = 500;
     EPwm10Regs.DBCTL2.all = 0x00;

     EPwm10Regs.ETSEL.all = 0x00;

}

void InitEpwm11(void)
{

    EPwm11Regs.TBCTL.all = 0x00;
     EPwm11Regs.TBCTL.bit.CTRMODE = 2;   // Count up and douwn
     EPwm11Regs.TBCTL.bit.CLKDIV = 0;    // TBCLOK = EPWMCLOCK/(128*10) = 78125Hz
     EPwm11Regs.TBCTL.bit.HSPCLKDIV = 0;

     EPwm11Regs.TBPRD = 25000;
     EPwm11Regs.TBCTR = 0x0000;          // Clear counter

     EPwm11Regs.CMPCTL.all = 0x00;
     EPwm11Regs.CMPCTL.bit.SHDWAMODE = 1;//only active registers are used
     //EPwm11Regs.CMPCTL.bit.SHDWBMODE = 1;//only active registers are used

     EPwm11Regs.AQCTLA.all = 0x00;
     EPwm11Regs.AQCTLA.bit.CAU = 2; //set high
     EPwm11Regs.AQCTLA.bit.CAD = 1; //set low
     //EPwm11Regs.AQCTLB.all = 0x00;
     //EPwm11Regs.AQCTLB.bit.CBU = 1; //set low
     //EPwm11Regs.AQCTLB.bit.CBD = 2; //set high

     EPwm11Regs.CMPA.half.CMPA = 12500;    // Set compare A value
     //EPwm11Regs.CMPB.half.CMPB = EPwm11Regs.TBPRD/2;    // Set Compare B value

     EPwm11Regs.TBPHS.half.TBPHS = 0x0000;          // Phase is 0

     EPwm11Regs.TBCTL2.all = 0x00;
     EPwm11Regs.CMPCTL2.all = 0x00;
     EPwm11Regs.DBCTL.all = 0x00;
     EPwm11Regs.DBCTL.bit.OUT_MODE = 3;
     EPwm11Regs.DBCTL.bit.POLSEL = 2;
     EPwm11Regs.DBFED = 500;
     EPwm11Regs.DBRED = 500;
     EPwm11Regs.DBCTL2.all = 0x00;

     EPwm11Regs.ETSEL.all = 0x00;

}

void InitEpwm12(void)
{

    EPwm12Regs.TBCTL.all = 0x00;
    EPwm12Regs.TBCTL.bit.CTRMODE = 2;   // Count up and douwn
    EPwm12Regs.TBCTL.bit.CLKDIV = 0;    // TBCLOK = EPWMCLOCK/(128*10) = 78125Hz
    EPwm12Regs.TBCTL.bit.HSPCLKDIV = 0;

    EPwm12Regs.TBPRD = 25000;
    EPwm12Regs.TBCTR = 0x0000;          // Clear counter

    EPwm12Regs.CMPCTL.all = 0x00;
    EPwm12Regs.CMPCTL.bit.SHDWAMODE = 1;//only active registers are used
    //EPwm12Regs.CMPCTL.bit.SHDWBMODE = 1;//only active registers are used

    EPwm12Regs.AQCTLA.all = 0x00;
    EPwm12Regs.AQCTLA.bit.CAU = 2; //set high
    EPwm12Regs.AQCTLA.bit.CAD = 1; //set low
    //EPwm12Regs.AQCTLB.all = 0x00;
    //EPwm12Regs.AQCTLB.bit.CBU = 1; //set low
    //EPwm12Regs.AQCTLB.bit.CBD = 2; //set high

    EPwm12Regs.CMPA.half.CMPA = 12500;    // Set compare A value
    //EPwm12Regs.CMPB.half.CMPB = EPwm12Regs.TBPRD/2;    // Set Compare B value

    EPwm12Regs.TBPHS.half.TBPHS = 0x0000;          // Phase is 0

    EPwm12Regs.TBCTL2.all = 0x00;
    EPwm12Regs.CMPCTL2.all = 0x00;
    EPwm12Regs.DBCTL.all = 0x00;
    EPwm12Regs.DBCTL.bit.OUT_MODE = 3;
    EPwm12Regs.DBCTL.bit.POLSEL = 2;
    EPwm12Regs.DBFED = 500;
    EPwm12Regs.DBRED = 500;
    EPwm12Regs.DBCTL2.all = 0x00;

    EPwm12Regs.ETSEL.all = 0x00;

}




/*
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

    //ECap1Regs.

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

*/


