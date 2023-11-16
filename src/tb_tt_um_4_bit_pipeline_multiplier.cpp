#include <stdlib.h>
#include <iostream>
#include <verilated.h>
#include <verilated_vcd_c.h>
#include "Vtt_um_4_bit_pipeline_multiplier.h"
#include <stdlib.h>     /* srand, rand */
#include <time.h>       /* time */
#include <bitset>

#define MAX_SIM_TIME 20
vluint64_t sim_time = 0;

int main(int argc, char** argv, char** env) {
    Vtt_um_4_bit_pipeline_multiplier *dut = new Vtt_um_4_bit_pipeline_multiplier;

    Verilated::traceEverOn(true);
    VerilatedVcdC *m_trace = new VerilatedVcdC;
    dut->trace(m_trace, 5);
    m_trace->open("waveform.vcd");

    int ui_in_first_half = 0;
    int ui_in_first_half_shifted = 0;
    int ui_in_second_half = 0;
    dut->ena = 1;
    dut->rst_n = 1;

    srand (time(NULL));
    while(sim_time < 50){
        m_trace->dump(sim_time);
        if(sim_time % 2 == 0 || sim_time == 0){
            ui_in_first_half = std::rand() % 7 + 0;
            ui_in_second_half = std::rand() % 7 + 0;
            ui_in_first_half_shifted = ui_in_first_half << 4;
        }
        sim_time++;
        dut->clk ^= 1;
        dut->eval(); 
        m_trace->dump(sim_time);
        sim_time++;
        dut->clk ^= 1;
        dut->eval(); 
        m_trace->dump(sim_time);
        dut->ui_in = ui_in_first_half_shifted + ui_in_second_half;
        printf("CLOCK: %d | %d * %d | Generated: %d \n",
        sim_time,ui_in_first_half,ui_in_second_half, ui_in_first_half*ui_in_second_half);
        dut->eval(); 
    }
    // while (sim_time < 4) {
    //     m_trace->dump(sim_time);
    //     sim_time++;
    //     dut->ena = 1;
    //     dut->rst_n = 1;
    //     dut->clk ^= 1;
    //     dut->ui_in = 221;
    //     dut->eval();    
    // }
    // while (sim_time < 6) {
    //     m_trace->dump(sim_time);
    //     sim_time++;
    //     dut->ena = 1;
    //     dut->rst_n = 1;
    //     dut->clk ^= 1;
    //     dut->ui_in = 136;
    //     dut->eval();    
    // }
    // while (sim_time < 8) {
    //     m_trace->dump(sim_time);
    //     sim_time++;
    //     dut->ena = 1;
    //     dut->rst_n = 1;
    //     dut->clk ^= 1;
    //     dut->ui_in = 119;
    //     dut->eval();    
    // }
    // while (sim_time < 20) {
    //     m_trace->dump(sim_time);
    //     sim_time++;
    //     dut->ena = 1;
    //     dut->rst_n = 1;
    //     dut->clk ^= 1;
    //     dut->ui_in = 0;
    //     dut->eval();    
    // }


    m_trace->close();
    delete dut;
    exit(EXIT_SUCCESS); 
}