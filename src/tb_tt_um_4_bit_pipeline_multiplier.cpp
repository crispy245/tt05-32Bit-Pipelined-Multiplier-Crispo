#include <stdlib.h>
#include <iostream>
#include <verilated.h>
#include <verilated_vcd_c.h>
#include "Vtt_um_4_bit_pipeline_multiplier.h"

#define MAX_SIM_TIME 20
vluint64_t sim_time = 0;

int main(int argc, char** argv, char** env) {
    Vtt_um_4_bit_pipeline_multiplier *dut = new Vtt_um_4_bit_pipeline_multiplier;

    Verilated::traceEverOn(true);
    VerilatedVcdC *m_trace = new VerilatedVcdC;
    dut->trace(m_trace, 5);
    m_trace->open("waveform.vcd");

    while (sim_time < 10) {
        m_trace->dump(sim_time);
        sim_time++;
        dut->ena = 1;
        dut->rst_n = 1;
        dut->clk ^= 1;
        dut->ui_in = 119;
        dut->eval();    
    }
    while (sim_time < 20) {
        m_trace->dump(sim_time);
        sim_time++;
        dut->ena = 0;
        dut->rst_n = 1;
        dut->clk ^= 1;
        dut->ui_in = 119;
        dut->eval();    
    }
    while (sim_time < 30) {
        m_trace->dump(sim_time);
        sim_time++;
        dut->ena = 1;
        dut->rst_n = 0;
        dut->clk ^= 1;
        dut->ui_in = 119;
        dut->eval();    
    }

    m_trace->close();
    delete dut;
    exit(EXIT_SUCCESS); 
}