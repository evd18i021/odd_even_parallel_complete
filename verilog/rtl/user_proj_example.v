// SPDX-FileCopyrightText: 2020 Efabless Corporation
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// SPDX-License-Identifier: Apache-2.0

`default_nettype none
/*
 *-------------------------------------------------------------
 *
 * user_proj_example
 *
 * This is an example of a (trivially simple) user project,
 * showing how the user project can connect to the logic
 * analyzer, the wishbone bus, and the I/O pads.
 *
 * This project generates an integer count, which is output
 * on the user area GPIO pads (digital output only).  The
 * wishbone connection allows the project to be controlled
 * (start and stop) from the management SoC program.
 *
 * See the testbenches in directory "mprj_counter" for the
 * example programs that drive this user project.  The three
 * testbenches are "io_ports", "la_test1", and "la_test2".
 *
 *-------------------------------------------------------------
 */

module user_proj_example #(
    parameter BITS = 32
)(
`ifdef USE_POWER_PINS
    inout vccd1,	// User area 1 1.8V supply
    inout vssd1,	// User area 1 digital ground
`endif

    // Wishbone Slave ports (WB MI A)
    input wb_clk_i,
    input wb_rst_i,
    input wbs_stb_i,
    input wbs_cyc_i,
    input wbs_we_i,
    input [3:0] wbs_sel_i,
    input [31:0] wbs_dat_i,
    input [31:0] wbs_adr_i,
    output wbs_ack_o,
    output [31:0] wbs_dat_o,

    // Logic Analyzer Signals
    input  [127:0] la_data_in,
    output [127:0] la_data_out,
    input  [127:0] la_oenb,

    // IOs
    input  [`MPRJ_IO_PADS-1:0] io_in,
    output [`MPRJ_IO_PADS-1:0] io_out,
    output [`MPRJ_IO_PADS-1:0] io_oeb,

    // IRQ
    output [2:0] irq
);
    wire clk;
    wire rst;

    wire [`MPRJ_IO_PADS-1:0] io_in;
    wire [`MPRJ_IO_PADS-1:0] io_out;
    wire [`MPRJ_IO_PADS-1:0] io_oeb;

    wire [31:0] rdata; 
    wire [31:0] wdata;
    wire [BITS-1:0] count;

    wire valid;
    wire [3:0] wstrb;
    wire [31:0] la_write;

    // WB MI A
    assign valid = wbs_cyc_i && wbs_stb_i; 
    assign wstrb = wbs_sel_i & {4{wbs_we_i}};
    assign wbs_dat_o = rdata;
    assign wdata = wbs_dat_i;

    // IO
    assign io_out = count;
    assign io_oeb = {(`MPRJ_IO_PADS-1){rst}};

    // IRQ
    assign irq = 3'b000;	// Unused

    // LA
    assign la_data_out = {{(127-BITS){1'b0}}, count};
    // Assuming LA probes [63:32] are for controlling the count register  
    assign la_write = ~la_oenb[63:32] & ~{BITS{valid}};
    // Assuming LA probes [65:64] are for controlling the count clk & reset  
    assign clk = (~la_oenb[64]) ? la_data_in[64]: wb_clk_i;
    assign rst = (~la_oenb[65]) ? la_data_in[65]: wb_rst_i;

odd_even_parallel_complete dut(

i0s,i1s,i2s,i3s,i4s,i5s,i6s,i7s,i8s,i9s,i10s,i11s,i12s,i13s,i14s,i15s,i16s,i17s,i18s,i19s,i20s,i21s,i22s,i23s,i24s,i25s,i26s,i27s,i28s,i29s,i30s,i31s,
i0,i1,i2,i3,i4,i5,i6,i7,i8,i9,i10,i11,i12,i13,i14,i15,i16,i17,i18,i19,i20,i21,i22,i23,i24,i25,i26,i27,i28,i29,i30,i31,
s,ss,clk,reset,
se0,se1,se2,se3,se4,se5,se6,se7,se8,se9,se10,se11,se12,se13,se14,se15,se16,se17,se18,se19,se20,se21,se22,se23,se24,se25,se26,se27,se28,se29,se30,se31,

oo0,oo1,oo2,oo3,oo4,oo5,oo6,oo7,oo8,oo9,oo10,oo11,oo12,oo13,oo14,oo15,oo16,oo17,oo18,oo19,oo20,oo21,oo22,oo23,oo24,oo25,oo26,oo27,oo28,oo29,oo30,oo31,
oo0s,oo1s,oo2s,oo3s,oo4s,oo5s,oo6s,oo7s,oo8s,oo9s,oo10s,oo11s,oo12s,oo13s,oo14s,oo15s,oo16s,oo17s,oo18s,oo19s,oo20s,oo21s,oo22s,oo23s,
oo24s,oo25s,oo26s,oo27s,oo28s,oo29s,oo30s,oo31s

);

endmodule

//32-point proposed Integer DCT using parallel architecture 

//`include "odd_even_parallel.v"
//`include "dflipflop25.v"
//`include "storage32_25.v"

module odd_even_parallel_complete(

i0s,i1s,i2s,i3s,i4s,i5s,i6s,i7s,i8s,i9s,i10s,i11s,i12s,i13s,i14s,i15s,i16s,i17s,i18s,i19s,i20s,i21s,i22s,i23s,i24s,i25s,i26s,i27s,i28s,i29s,i30s,i31s,
i0,i1,i2,i3,i4,i5,i6,i7,i8,i9,i10,i11,i12,i13,i14,i15,i16,i17,i18,i19,i20,i21,i22,i23,i24,i25,i26,i27,i28,i29,i30,i31,
s,ss,clk,reset,
se0,se1,se2,se3,se4,se5,se6,se7,se8,se9,se10,se11,se12,se13,se14,se15,se16,se17,se18,se19,se20,se21,se22,se23,se24,se25,se26,se27,se28,se29,se30,se31,

oo0,oo1,oo2,oo3,oo4,oo5,oo6,oo7,oo8,oo9,oo10,oo11,oo12,oo13,oo14,oo15,oo16,oo17,oo18,oo19,oo20,oo21,oo22,oo23,oo24,oo25,oo26,oo27,oo28,oo29,oo30,oo31,
oo0s,oo1s,oo2s,oo3s,oo4s,oo5s,oo6s,oo7s,oo8s,oo9s,oo10s,oo11s,oo12s,oo13s,oo14s,oo15s,oo16s,oo17s,oo18s,oo19s,oo20s,oo21s,oo22s,oo23s,
oo24s,oo25s,oo26s,oo27s,oo28s,oo29s,oo30s,oo31s

);

input clk,reset;

input i0s,i1s,i2s,i3s,i4s,i5s,i6s,i7s,i8s,i9s,i10s,i11s,i12s,i13s,i14s,i15s,i16s,i17s,i18s,i19s,i20s,i21s,i22s,i23s,i24s,i25s,i26s,i27s,i28s,i29s,i30s,i31s;
input [7:0] i0,i1,i2,i3,i4,i5,i6,i7,i8,i9,i10,i11,i12,i13,i14,i15,i16,i17,i18,i19,i20,i21,i22,i23,i24,i25,i26,i27,i28,i29,i30,i31;

input s,ss;//ss=0 for row process and ss=1 for column process

input se0,se1,se2,se3,se4,se5,se6,se7,se8,se9,se10,se11,se12,se13,se14,se15,se16,se17,se18,se19,se20,se21,se22,se23,se24,se25,se26,se27,se28,se29,se30,se31;

output [39:0] oo0,oo1,oo2,oo3,oo4,oo5,oo6,oo7,oo8,oo9,oo10,oo11,oo12,oo13,oo14,oo15,oo16,oo17,oo18,oo19,oo20,oo21,oo22,oo23,oo24,oo25,oo26,oo27,oo28,oo29,oo30,oo31;
output oo0s,oo1s,oo2s,oo3s,oo4s,oo5s,oo6s,oo7s,oo8s,oo9s,oo10s,oo11s,oo12s,oo13s,oo14s,oo15s,oo16s,oo17s,oo18s,oo19s,oo20s,oo21s,oo22s,
oo23s,oo24s,oo25s,oo26s,oo27s,oo28s,oo29s,oo30s,oo31s;

//row process

wire ou0s,ou1s,ou2s,ou3s,ou4s,ou5s,ou6s,ou7s,ou8s,ou9s,ou10s,ou11s,ou12s,ou13s,ou14s,ou15s,
ou16s,ou17s,ou18s,ou19s,ou20s,ou21s,ou22s,ou23s,ou24s,ou25s,ou26s,ou27s,ou28s,ou29s,ou30s,ou31s;
wire [23:0] ou0,ou1,ou2,ou3,ou4,ou5,ou6,ou7,ou8,ou9,ou10,ou11,ou12,ou13,ou14,ou15,
ou16,ou17,ou18,ou19,ou20,ou21,ou22,ou23,ou24,ou25,ou26,ou27,ou28,ou29,ou30,ou31;

odd_even_parallel dfd(

i0s,i1s,i2s,i3s,i4s,i5s,i6s,i7s,i8s,i9s,i10s,i11s,i12s,i13s,i14s,i15s,i16s,i17s,i18s,i19s,i20s,i21s,i22s,i23s,i24s,i25s,i26s,i27s,i28s,i29s,i30s,i31s,
i0,i1,i2,i3,i4,i5,i6,i7,i8,i9,i10,i11,i12,i13,i14,i15,i16,i17,i18,i19,i20,i21,i22,i23,i24,i25,i26,i27,i28,i29,i30,i31,
s,
ou0s,ou1s,ou2s,ou3s,ou4s,ou5s,ou6s,ou7s,ou8s,ou9s,ou10s,ou11s,ou12s,ou13s,ou14s,ou15s,ou16s,ou17s,ou18s,ou19s,ou20s,ou21s,ou22s,ou23s,ou24s,ou25s,ou26s,ou27s,ou28s,ou29s,ou30s,ou31s,
ou0,ou1,ou2,ou3,ou4,ou5,ou6,ou7,ou8,ou9,ou10,ou11,ou12,ou13,ou14,ou15,ou16,ou17,ou18,ou19,ou20,ou21,ou22,ou23,ou24,ou25,ou26,ou27,ou28,ou29,ou30,ou31

);

//32x32-transpose buffer

wire od0s,od1s,od2s,od3s,od4s,od5s,od6s,od7s,od8s,od9s,od10s,od11s,od12s,od13s,od14s,od15s,
od16s,od17s,od18s,od19s,od20s,od21s,od22s,od23s,od24s,od25s,od26s,od27s,od28s,od29s,od30s,od31s;
wire [23:0] od0,od1,od2,od3,od4,od5,od6,od7,od8,od9,od10,od11,od12,od13,od14,od15,
od16,od17,od18,od19,od20,od21,od22,od23,od24,od25,od26,od27,od28,od29,od30,od31;

storage32_25 ds00({ou0s,ou0},{od0s,od0},se0,clk,reset);
storage32_25 ds01({ou1s,ou1},{od1s,od1},se1,clk,reset);
storage32_25 ds02({ou2s,ou2},{od2s,od2},se2,clk,reset);
storage32_25 ds03({ou3s,ou3},{od3s,od3},se3,clk,reset);
storage32_25 ds04({ou4s,ou4},{od4s,od4},se4,clk,reset);
storage32_25 ds05({ou5s,ou5},{od5s,od5},se5,clk,reset);
storage32_25 ds06({ou6s,ou6},{od6s,od6},se6,clk,reset);
storage32_25 ds07({ou7s,ou7},{od7s,od7},se7,clk,reset);
storage32_25 ds08({ou8s,ou8},{od8s,od8},se8,clk,reset);
storage32_25 ds09({ou9s,ou9},{od9s,od9},se9,clk,reset);
storage32_25 ds10({ou10s,ou10},{od10s,od10},se10,clk,reset);
storage32_25 ds11({ou11s,ou11},{od11s,od11},se11,clk,reset);
storage32_25 ds12({ou12s,ou12},{od12s,od12},se12,clk,reset);
storage32_25 ds13({ou13s,ou13},{od13s,od13},se13,clk,reset);
storage32_25 ds14({ou14s,ou14},{od14s,od14},se14,clk,reset);
storage32_25 ds15({ou15s,ou15},{od15s,od15},se15,clk,reset);
storage32_25 ds16({ou16s,ou16},{od16s,od16},se16,clk,reset);
storage32_25 ds17({ou17s,ou17},{od17s,od17},se17,clk,reset);
storage32_25 ds18({ou18s,ou18},{od18s,od18},se18,clk,reset);
storage32_25 ds19({ou19s,ou19},{od19s,od19},se19,clk,reset);
storage32_25 ds20({ou20s,ou20},{od20s,od20},se20,clk,reset);
storage32_25 ds21({ou21s,ou21},{od21s,od21},se21,clk,reset);
storage32_25 ds22({ou22s,ou22},{od22s,od22},se22,clk,reset);
storage32_25 ds23({ou23s,ou23},{od23s,od23},se23,clk,reset);
storage32_25 ds24({ou24s,ou24},{od24s,od24},se24,clk,reset);
storage32_25 ds25({ou25s,ou25},{od25s,od25},se25,clk,reset);
storage32_25 ds26({ou26s,ou26},{od26s,od26},se26,clk,reset);
storage32_25 ds27({ou27s,ou27},{od27s,od27},se27,clk,reset);
storage32_25 ds28({ou28s,ou28},{od28s,od28},se28,clk,reset);
storage32_25 ds29({ou29s,ou29},{od29s,od29},se29,clk,reset);
storage32_25 ds30({ou30s,ou30},{od30s,od30},se30,clk,reset);
storage32_25 ds31({ou31s,ou31},{od31s,od31},se31,clk,reset);

//column process

odd_even_folded ddd(

od0s,od1s,od2s,od3s,od4s,od5s,od6s,od7s,od8s,od9s,od10s,od11s,od12s,od13s,od14s,od15s,
od16s,od17s,od18s,od19s,od20s,od21s,od22s,od23s,od24s,od25s,od26s,od27s,od28s,od29s,od30s,od31s,
{16'd0,od0},{16'd0,od1},{16'd0,od2},{16'd0,od3},{16'd0,od4},{16'd0,od5},{16'd0,od6},{16'd0,od7},{16'd0,od8},{16'd0,od9},{16'd0,od10},{16'd0,od11},{16'd0,od12},{16'd0,od13},{16'd0,od14},{16'd0,od15},{16'd0,od16},{16'd0,od17},{16'd0,od18},{16'd0,od19},{16'd0,od20},{16'd0,od21},{16'd0,od22},{16'd0,od23},{16'd0,od24},{16'd0,od25},{16'd0,od26},{16'd0,od27},{16'd0,od28},{16'd0,od29},{16'd0,od30},{16'd0,od31},
s,
oo0s,oo1s,oo2s,oo3s,oo4s,oo5s,oo6s,oo7s,oo8s,oo9s,oo10s,oo11s,oo12s,oo13s,oo14s,oo15s,
oo16s,oo17s,oo18s,oo19s,oo20s,oo21s,oo22s,oo23s,oo24s,oo25s,oo26s,oo27s,oo28s,oo29s,oo30s,oo31s,
oo0,oo1,oo2,oo3,oo4,oo5,oo6,oo7,oo8,oo9,oo10,oo11,oo12,oo13,oo14,oo15,oo16,oo17,oo18,oo19,oo20,oo21,oo22,oo23,oo24,oo25,oo26,oo27,oo28,oo29,oo30,oo31

);

endmodule



// D flip flop

module dflipflop25(q,d,clk,reset);
output [24:0] q;
input [24:0] d;
input clk,reset;
reg [24:0] q;
always@(posedge reset or negedge clk)
if(reset)
q<=25'b00000000;
else
q<=d;
endmodule

// storage buffer

//`include "mux2to1_25.v"
//`include "dflipflop25.v"

module storage32_25(i,d32,s,clk,reset);

input [24:0] i;
input s,clk,reset;//s is 0 for feed back and 1 for feed forward
output [24:0] d32;

wire [24:0] m1,m2,m3,m4,m5,m6,m7,m8,m9,m10,m11,m12,m13,m14,m15,m16,m17,m18,m19,m20,m21,m22,m23,m24,m25,m26,m27,m28,m29,m30,m31,m32;
wire [24:0] d1,d2,d3,d4,d5,d6,d7,d8,d9,d10,d11,d12,d13,d14,d15,d16,d17,d18,d19,d20,d21,d22,d23,d24,d25,d26,d27,d28,d29,d30,d31,d32;

mux2to1_25 mu1(m1,d1,i,s); 
dflipflop25 df1(d1,m1,clk,reset);

mux2to1_25 mu2(m2,d2,d1,s);
dflipflop25 df2(d2,m2,clk,reset);

mux2to1_25 mu3(m3,d3,d2,s);
dflipflop25 df3(d3,m3,clk,reset);

mux2to1_25 mu4(m4,d4,d3,s);
dflipflop25 df4(d4,m4,clk,reset);

mux2to1_25 mu5(m5,d5,d4,s);
dflipflop25 df5(d5,m5,clk,reset);

mux2to1_25 mu6(m6,d6,d5,s);
dflipflop25 df6(d6,m6,clk,reset);

mux2to1_25 mu7(m7,d7,d6,s);
dflipflop25 df7(d7,m7,clk,reset);

mux2to1_25 mu8(m8,d8,d7,s);
dflipflop25 df8(d8,m8,clk,reset);

mux2to1_25 mu9(m9,d9,d8,s);
dflipflop25 df9(d9,m9,clk,reset);

mux2to1_25 mu10(m10,d10,d9,s);
dflipflop25 df10(d10,m10,clk,reset);

mux2to1_25 mu11(m11,d11,d10,s);
dflipflop25 df11(d11,m11,clk,reset);

mux2to1_25 mu12(m12,d12,d11,s);
dflipflop25 df12(d12,m12,clk,reset);

mux2to1_25 mu13(m13,d13,d12,s);
dflipflop25 df13(d13,m13,clk,reset);

mux2to1_25 mu14(m14,d14,d13,s);
dflipflop25 df14(d14,m14,clk,reset);

mux2to1_25 mu15(m15,d15,d14,s);
dflipflop25 df15(d15,m15,clk,reset);

mux2to1_25 mu16(m16,d16,d15,s);
dflipflop25 df16(d16,m16,clk,reset);

mux2to1_25 mu17(m17,d17,d16,s);
dflipflop25 df17(d17,m17,clk,reset);

mux2to1_25 mu18(m18,d18,d17,s);
dflipflop25 df18(d18,m18,clk,reset);

mux2to1_25 mu19(m19,d19,d18,s);
dflipflop25 df19(d19,m19,clk,reset);

mux2to1_25 mu20(m20,d20,d19,s);
dflipflop25 df20(d20,m20,clk,reset);

mux2to1_25 mu21(m21,d21,d20,s);
dflipflop25 df21(d21,m21,clk,reset);

mux2to1_25 mu22(m22,d22,d21,s);
dflipflop25 df22(d22,m22,clk,reset);

mux2to1_25 mu23(m23,d23,d22,s);
dflipflop25 df23(d23,m23,clk,reset);

mux2to1_25 mu24(m24,d24,d23,s);
dflipflop25 df24(d24,m24,clk,reset);

mux2to1_25 mu25(m25,d25,d24,s);
dflipflop25 df25(d25,m25,clk,reset);

mux2to1_25 mu26(m26,d26,d25,s);
dflipflop25 df26(d26,m26,clk,reset);

mux2to1_25 mu27(m27,d27,d26,s);
dflipflop25 df27(d27,m27,clk,reset);

mux2to1_25 mu28(m28,d28,d27,s);
dflipflop25 df28(d28,m28,clk,reset);

mux2to1_25 mu29(m29,d29,d28,s);
dflipflop25 df29(d29,m29,clk,reset);

mux2to1_25 mu30(m30,d30,d29,s);
dflipflop25 df30(d30,m30,clk,reset);

mux2to1_25 mu31(m31,d31,d30,s);
dflipflop25 df31(d31,m31,clk,reset);

mux2to1_25 mu32(m32,d32,d31,s);
dflipflop25 df32(d32,m32,clk,reset);

endmodule



//odd_even decomposition based 1D DCT used for 2D parallel architecture

/*`include "adder24.v"
`include "kgp.v"
`include "kgp_carry.v"
`include "recursive_stage1.v"
`include "recurse24.v"
`include "add_shift_parallel.v"
`include "mux2to1_25.v"*/

module odd_even_parallel(

i0s,i1s,i2s,i3s,i4s,i5s,i6s,i7s,i8s,i9s,i10s,i11s,i12s,i13s,i14s,i15s,i16s,i17s,i18s,i19s,i20s,i21s,i22s,i23s,i24s,i25s,i26s,i27s,i28s,i29s,i30s,i31s,
i0,i1,i2,i3,i4,i5,i6,i7,i8,i9,i10,i11,i12,i13,i14,i15,i16,i17,i18,i19,i20,i21,i22,i23,i24,i25,i26,i27,i28,i29,i30,i31,
s,

ou0s,ou1s,ou2s,ou3s,ou4s,ou5s,ou6s,ou7s,ou8s,ou9s,ou10s,ou11s,ou12s,ou13s,ou14s,ou15s,ou16s,ou17s,ou18s,ou19s,ou20s,ou21s,ou22s,ou23s,ou24s,ou25s,ou26s,ou27s,ou28s,ou29s,ou30s,ou31s,
ou0,ou1,ou2,ou3,ou4,ou5,ou6,ou7,ou8,ou9,ou10,ou11,ou12,ou13,ou14,ou15,ou16,ou17,ou18,ou19,ou20,ou21,ou22,ou23,ou24,ou25,ou26,ou27,ou28,ou29,ou30,ou31

);

input i0s,i1s,i2s,i3s,i4s,i5s,i6s,i7s,i8s,i9s,i10s,i11s,i12s,i13s,i14s,i15s,i16s,i17s,i18s,i19s,i20s,i21s,i22s,i23s,i24s,i25s,i26s,i27s,i28s,i29s,i30s,i31s;
input [7:0] i0,i1,i2,i3,i4,i5,i6,i7,i8,i9,i10,i11,i12,i13,i14,i15,i16,i17,i18,i19,i20,i21,i22,i23,i24,i25,i26,i27,i28,i29,i30,i31;

input s;

output ou0s,ou1s,ou2s,ou3s,ou4s,ou5s,ou6s,ou7s,ou8s,ou9s,ou10s,ou11s,ou12s,ou13s,ou14s,ou15s,ou16s,ou17s,ou18s,ou19s,ou20s,ou21s,ou22s,ou23s,ou24s,ou25s,ou26s,ou27s,ou28s,ou29s,ou30s,ou31s;
output [23:0] ou0,ou1,ou2,ou3,ou4,ou5,ou6,ou7,ou8,ou9,ou10,ou11,ou12,ou13,ou14,ou15,ou16,ou17,ou18,ou19,ou20,ou21,ou22,ou23,ou24,ou25,ou26,ou27,ou28,ou29,ou30,ou31;

//stage1-adders

wire r0s,r1s,r2s,r3s,r4s,r5s,r6s,r7s,r8s,r9s,r10s,r11s,r12s,r13s,r14s,r15s;
wire [23:0] r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,r13,r14,r15;

wire rr0s,rr1s,rr2s,rr3s,rr4s,rr5s,rr6s,rr7s,rr8s,rr9s,rr10s,rr11s,rr12s,rr13s,rr14s,rr15s;
wire [23:0] rr0,rr1,rr2,rr3,rr4,rr5,rr6,rr7,rr8,rr9,rr10,rr11,rr12,rr13,rr14,rr15;

adder24 a0(i0s,{16'd0,i0},i31s,{16'd0,i31},r0s,r0);
adder24 a1(i1s,{16'd0,i1},i30s,{16'd0,i30},r1s,r1);
adder24 a2(i2s,{16'd0,i2},i29s,{16'd0,i29},r2s,r2);
adder24 a3(i3s,{16'd0,i3},i28s,{16'd0,i28},r3s,r3);
adder24 a4(i4s,{16'd0,i4},i27s,{16'd0,i27},r4s,r4);
adder24 a5(i5s,{16'd0,i5},i26s,{16'd0,i26},r5s,r5);
adder24 a6(i6s,{16'd0,i6},i25s,{16'd0,i25},r6s,r6);
adder24 a7(i7s,{16'd0,i7},i24s,{16'd0,i24},r7s,r7);
adder24 a8(i8s,{16'd0,i8},i23s,{16'd0,i23},r8s,r8);
adder24 a9(i9s,{16'd0,i9},i22s,{16'd0,i22},r9s,r9);
adder24 a10(i10s,{16'd0,i10},i21s,{16'd0,i21},r10s,r10);
adder24 a11(i11s,{16'd0,i11},i20s,{16'd0,i20},r11s,r11);
adder24 a12(i12s,{16'd0,i12},i19s,{16'd0,i19},r12s,r12);
adder24 a13(i13s,{16'd0,i13},i18s,{16'd0,i18},r13s,r13);
adder24 a14(i14s,{16'd0,i14},i17s,{16'd0,i17},r14s,r14);
adder24 a15(i15s,{16'd0,i15},i16s,{16'd0,i16},r15s,r15);

adder24 aa0(i0s,{16'd0,i0},(~i31s),{16'd0,i31},rr0s,rr0);
adder24 aa1(i1s,{16'd0,i1},(~i30s),{16'd0,i30},rr1s,rr1);
adder24 aa2(i2s,{16'd0,i2},(~i29s),{16'd0,i29},rr2s,rr2);
adder24 aa3(i3s,{16'd0,i3},(~i28s),{16'd0,i28},rr3s,rr3);
adder24 aa4(i4s,{16'd0,i4},(~i27s),{16'd0,i27},rr4s,rr4);
adder24 aa5(i5s,{16'd0,i5},(~i26s),{16'd0,i26},rr5s,rr5);
adder24 aa6(i6s,{16'd0,i6},(~i25s),{16'd0,i25},rr6s,rr6);
adder24 aa7(i7s,{16'd0,i7},(~i24s),{16'd0,i24},rr7s,rr7);
adder24 aa8(i8s,{16'd0,i8},(~i23s),{16'd0,i23},rr8s,rr8);
adder24 aa9(i9s,{16'd0,i9},(~i22s),{16'd0,i22},rr9s,rr9);
adder24 aa10(i10s,{16'd0,i10},(~i21s),{16'd0,i21},rr10s,rr10);
adder24 aa11(i11s,{16'd0,i11},(~i20s),{16'd0,i20},rr11s,rr11);
adder24 aa12(i12s,{16'd0,i12},(~i19s),{16'd0,i19},rr12s,rr12);
adder24 aa13(i13s,{16'd0,i13},(~i18s),{16'd0,i18},rr13s,rr13);
adder24 aa14(i14s,{16'd0,i14},(~i17s),{16'd0,i17},rr14s,rr14);
adder24 aa15(i15s,{16'd0,i15},(~i16s),{16'd0,i16},rr15s,rr15);

//stage2-add-shift n/w

wire z0s,z1s,z2s,z3s,z4s,z5s,z6s,z7s,z8s,z9s,z10s,z11s,z12s,z13s,z14s,z15s;
wire [23:0] z0,z1,z2,z3,z4,z5,z6,z7,z8,z9,z10,z11,z12,z13,z14,z15;

wire zz0s,zz1s,zz2s,zz3s,zz4s,zz5s,zz6s,zz7s,zz8s,zz9s,zz10s,zz11s,zz12s,zz13s,zz14s,zz15s;
wire [23:0] zz0,zz1,zz2,zz3,zz4,zz5,zz6,zz7,zz8,zz9,zz10,zz11,zz12,zz13,zz14,zz15;

add_shift_parallel sds0(r0s,z0s,r0,z0,s);
add_shift_parallel sds1(r1s,z1s,r1,z1,s);
add_shift_parallel sds2(r2s,z2s,r2,z2,s);
add_shift_parallel sds3(r3s,z3s,r3,z3,s);
add_shift_parallel sds4(r4s,z4s,r4,z4,s);
add_shift_parallel sds5(r5s,z5s,r5,z5,s);
add_shift_parallel sds6(r6s,z6s,r6,z6,s);
add_shift_parallel sds7(r7s,z7s,r7,z7,s);
add_shift_parallel sds8(r8s,z8s,r8,z8,s);
add_shift_parallel sds9(r9s,z9s,r9,z9,s);
add_shift_parallel sds10(r10s,z10s,r10,z10,s);
add_shift_parallel sds11(r11s,z11s,r11,z11,s);
add_shift_parallel sds12(r12s,z12s,r12,z12,s);
add_shift_parallel sds13(r13s,z13s,r13,z13,s);
add_shift_parallel sds14(r14s,z14s,r14,z14,s);
add_shift_parallel sds15(r15s,z15s,r15,z15,s);

add_shift_parallel ss0(rr0s,zz0s,rr0,zz0,s);
add_shift_parallel ss1(rr1s,zz1s,rr1,zz1,s);
add_shift_parallel ss2(rr2s,zz2s,rr2,zz2,s);
add_shift_parallel ss3(rr3s,zz3s,rr3,zz3,s);
add_shift_parallel ss4(rr4s,zz4s,rr4,zz4,s);
add_shift_parallel ss5(rr5s,zz5s,rr5,zz5,s);
add_shift_parallel ss6(rr6s,zz6s,rr6,zz6,s);
add_shift_parallel ss7(rr7s,zz7s,rr7,zz7,s);
add_shift_parallel ss8(rr8s,zz8s,rr8,zz8,s);
add_shift_parallel ss9(rr9s,zz9s,rr9,zz9,s);
add_shift_parallel ss10(rr10s,zz10s,rr10,zz10,s);
add_shift_parallel ss11(rr11s,zz11s,rr11,zz11,s);
add_shift_parallel ss12(rr12s,zz12s,rr12,zz12,s);
add_shift_parallel ss13(rr13s,zz13s,rr13,zz13,s);
add_shift_parallel ss14(rr14s,zz14s,rr14,zz14,s);
add_shift_parallel ss15(rr15s,zz15s,rr15,zz15,s);

//stage3-output adder tree (4 levels of adders)

//first level

wire 
i0_0s,i0_1s,i0_2s,i0_3s,i0_4s,i0_5s,i0_6s,i0_7s,i0_8s,i0_9s,
i0_10s,i0_11s,i0_12s,i0_13s,i0_14s,i0_15s,i0_16s,i0_17s,i0_18s,i0_19s,
i0_20s,i0_21s,i0_22s,i0_23s,i0_24s,i0_25s,i0_26s,i0_27s,i0_28s,i0_29s,
i0_30s,i0_31s,i0_32s,i0_33s,i0_34s,i0_35s,i0_36s,i0_37s,i0_38s,i0_39s,
i0_40s,i0_41s,i0_42s,i0_43s,i0_44s,i0_45s,i0_46s,i0_47s,i0_48s,i0_49s,
i0_50s,i0_51s,i0_52s,i0_53s,i0_54s,i0_55s,i0_56s,i0_57s,i0_58s,i0_59s,
i0_60s,i0_61s,i0_62s,i0_63s,i0_64s,i0_65s,i0_66s,i0_67s,i0_68s,i0_69s,
i0_70s,i0_71s,i0_72s,i0_73s,i0_74s,i0_75s,i0_76s,i0_77s,i0_78s,i0_79s,
i0_80s,i0_81s,i0_82s,i0_83s,i0_84s,i0_85s,i0_86s,i0_87s,i0_88s,i0_89s,
i0_90s,i0_91s,i0_92s,i0_93s,i0_94s,i0_95s,i0_96s,i0_97s,i0_98s,i0_99s,
i0_100s,i0_101s,i0_102s,i0_103s,i0_104s,i0_105s,i0_106s,i0_107s,i0_108s,i0_109s,
i0_110s,i0_111s,i0_112s,i0_113s,i0_114s,i0_115s,i0_116s,i0_117s,i0_118s,i0_119s,
i0_120s,i0_121s,i0_122s,i0_123s,i0_124s,i0_125s,i0_126s,i0_127s,i0_128s,i0_129s,
i0_130s,i0_131s,i0_132s,i0_133s,i0_134s,i0_135s,i0_136s,i0_137s,i0_138s,i0_139s,
i0_140s,i0_141s,i0_142s,i0_143s,i0_144s,i0_145s,i0_146s,i0_147s,i0_148s,i0_149s,
i0_150s,i0_151s,i0_152s,i0_153s,i0_154s,i0_155s,i0_156s,i0_157s,i0_158s,i0_159s,
i0_160s,i0_161s,i0_162s,i0_163s,i0_164s,i0_165s,i0_166s,i0_167s,i0_168s,i0_169s,
i0_170s,i0_171s,i0_172s,i0_173s,i0_174s,i0_175s,i0_176s,i0_177s,i0_178s,i0_179s,
i0_180s,i0_181s,i0_182s,i0_183s,i0_184s,i0_185s,i0_186s,i0_187s,i0_188s,i0_189s,
i0_190s,i0_191s,i0_192s,i0_193s,i0_194s,i0_195s,i0_196s,i0_197s,i0_198s,i0_199s,
i0_200s,i0_201s,i0_202s,i0_203s,i0_204s,i0_205s,i0_206s,i0_207s,i0_208s,i0_209s,
i0_210s,i0_211s,i0_212s,i0_213s,i0_214s,i0_215s,i0_216s,i0_217s,i0_218s,i0_219s,
i0_220s,i0_221s,i0_222s,i0_223s,i0_224s,i0_225s,i0_226s,i0_227s,i0_228s,i0_229s,
i0_230s,i0_231s,i0_232s,i0_233s,i0_234s,i0_235s,i0_236s,i0_237s,i0_238s,i0_239s,
i0_240s,i0_241s,i0_242s,i0_243s,i0_244s,i0_245s,i0_246s,i0_247s,i0_248s,i0_249s,
i0_250s,i0_251s,i0_252s,i0_253s,i0_254s,i0_255s;

wire [23:0] 
i0_0,i0_1,i0_2,i0_3,i0_4,i0_5,i0_6,i0_7,i0_8,i0_9,
i0_10,i0_11,i0_12,i0_13,i0_14,i0_15,i0_16,i0_17,i0_18,i0_19,
i0_20,i0_21,i0_22,i0_23,i0_24,i0_25,i0_26,i0_27,i0_28,i0_29,
i0_30,i0_31,i0_32,i0_33,i0_34,i0_35,i0_36,i0_37,i0_38,i0_39,
i0_40,i0_41,i0_42,i0_43,i0_44,i0_45,i0_46,i0_47,i0_48,i0_49,
i0_50,i0_51,i0_52,i0_53,i0_54,i0_55,i0_56,i0_57,i0_58,i0_59,
i0_60,i0_61,i0_62,i0_63,i0_64,i0_65,i0_66,i0_67,i0_68,i0_69,
i0_70,i0_71,i0_72,i0_73,i0_74,i0_75,i0_76,i0_77,i0_78,i0_79,
i0_80,i0_81,i0_82,i0_83,i0_84,i0_85,i0_86,i0_87,i0_88,i0_89,
i0_90,i0_91,i0_92,i0_93,i0_94,i0_95,i0_96,i0_97,i0_98,i0_99,
i0_100,i0_101,i0_102,i0_103,i0_104,i0_105,i0_106,i0_107,i0_108,i0_109,
i0_110,i0_111,i0_112,i0_113,i0_114,i0_115,i0_116,i0_117,i0_118,i0_119,
i0_120,i0_121,i0_122,i0_123,i0_124,i0_125,i0_126,i0_127,i0_128,i0_129,
i0_130,i0_131,i0_132,i0_133,i0_134,i0_135,i0_136,i0_137,i0_138,i0_139,
i0_140,i0_141,i0_142,i0_143,i0_144,i0_145,i0_146,i0_147,i0_148,i0_149,
i0_150,i0_151,i0_152,i0_153,i0_154,i0_155,i0_156,i0_157,i0_158,i0_159,
i0_160,i0_161,i0_162,i0_163,i0_164,i0_165,i0_166,i0_167,i0_168,i0_169,
i0_170,i0_171,i0_172,i0_173,i0_174,i0_175,i0_176,i0_177,i0_178,i0_179,
i0_180,i0_181,i0_182,i0_183,i0_184,i0_185,i0_186,i0_187,i0_188,i0_189,
i0_190,i0_191,i0_192,i0_193,i0_194,i0_195,i0_196,i0_197,i0_198,i0_199,
i0_200,i0_201,i0_202,i0_203,i0_204,i0_205,i0_206,i0_207,i0_208,i0_209,
i0_210,i0_211,i0_212,i0_213,i0_214,i0_215,i0_216,i0_217,i0_218,i0_219,
i0_220,i0_221,i0_222,i0_223,i0_224,i0_225,i0_226,i0_227,i0_228,i0_229,
i0_230,i0_231,i0_232,i0_233,i0_234,i0_235,i0_236,i0_237,i0_238,i0_239,
i0_240,i0_241,i0_242,i0_243,i0_244,i0_245,i0_246,i0_247,i0_248,i0_249,
i0_250,i0_251,i0_252,i0_253,i0_254,i0_255;

adder24 s1_0(z0s,z0,z1s,z1,i0_0s,i0_0);
adder24 s1_1(z2s,z2,z3s,z3,i0_1s,i0_1);
adder24 s1_2(z4s,z4,z5s,z5,i0_2s,i0_2);
adder24 s1_3(z6s,z6,z7s,z7,i0_3s,i0_3);
adder24 s1_4(z8s,z8,z9s,z9,i0_4s,i0_4);
adder24 s1_5(z10s,z10,z11s,z11,i0_5s,i0_5);
adder24 s1_6(z12s,z12,z13s,z13,i0_6s,i0_6);
adder24 s1_7(z14s,z14,z15s,z15,i0_7s,i0_7);
adder24 s1_8(z10s,z10,z10s,z11,i0_8s,i0_8);
adder24 s1_9(z10s,z10,z10s,z11,i0_9s,i0_9);
adder24 s1_10(z2s,z2,z2s,z2,i0_10s,i0_10);
adder24 s1_11(z2s,z2,z2s,z2,i0_11s,i0_11);
adder24 s1_12(z2s,z2,z2s,z2,i0_12s,i0_12);
adder24 s1_13(z2s,z2,z2s,z2,i0_13s,i0_13);
adder24 s1_14(z2s,z2,z2s,z2,i0_14s,i0_14);
adder24 s1_15(z3s,z3,z3s,z3,i0_15s,i0_15);
adder24 s1_16(z3s,z3,z3s,z3,i0_16s,i0_16);
adder24 s1_17(z3s,z3,z3s,z3,i0_17s,i0_17);
adder24 s1_18(z3s,z3,z3s,z3,i0_18s,i0_18);
adder24 s1_19(z3s,z3,z3s,z3,i0_19s,i0_19);
adder24 s1_20(z4s,z4,z4s,z4,i0_20s,i0_20);
adder24 s1_21(z4s,z4,z4s,z4,i0_21s,i0_21);
adder24 s1_22(z4s,z4,z4s,z4,i0_22s,i0_22);
adder24 s1_23(z4s,z4,z4s,z4,i0_23s,i0_23);
adder24 s1_24(z4s,z4,z4s,z4,i0_24s,i0_24);
adder24 s1_25(z5s,z5,z5s,z5,i0_25s,i0_25);
adder24 s1_26(z5s,z5,z5s,z5,i0_26s,i0_26);
adder24 s1_27(z5s,z5,z5s,z5,i0_27s,i0_27);
adder24 s1_28(z5s,z5,z5s,z5,i0_28s,i0_28);
adder24 s1_29(z5s,z5,z5s,z5,i0_29s,i0_29);
adder24 s1_30(z6s,z6,z6s,z6,i0_30s,i0_30);
adder24 s1_31(z6s,z6,z6s,z6,i0_31s,i0_31);
adder24 s1_32(z6s,z6,z6s,z6,i0_32s,i0_32);
adder24 s1_33(z6s,z6,z6s,z6,i0_33s,i0_33);
adder24 s1_34(z6s,z6,z6s,z6,i0_34s,i0_34);
adder24 s1_35(z7s,z7,z7s,z7,i0_35s,i0_35);
adder24 s1_36(z7s,z7,z7s,z7,i0_36s,i0_36);
adder24 s1_37(z7s,z7,z7s,z7,i0_37s,i0_37);
adder24 s1_38(z7s,z7,z7s,z7,i0_38s,i0_38);
adder24 s1_39(z7s,z7,z7s,z7,i0_39s,i0_39);
adder24 s1_40(z8s,z8,z8s,z8,i0_40s,i0_40);
adder24 s1_41(z8s,z8,z8s,z8,i0_41s,i0_41);
adder24 s1_42(z8s,z8,z8s,z8,i0_42s,i0_42);
adder24 s1_43(z8s,z8,z8s,z8,i0_43s,i0_43);
adder24 s1_44(z8s,z8,z8s,z8,i0_44s,i0_44);
adder24 s1_45(z9s,z9,z9s,z9,i0_45s,i0_45);
adder24 s1_46(z9s,z9,z9s,z9,i0_46s,i0_46);
adder24 s1_47(z9s,z9,z9s,z9,i0_47s,i0_47);
adder24 s1_48(z9s,z9,z9s,z9,i0_48s,i0_48);
adder24 s1_49(z9s,z9,z9s,z9,i0_49s,i0_49);
adder24 s1_50(z1s,z1,z1s,z1,i0_50s,i0_50);
adder24 s1_51(z1s,z1,z1s,z1,i0_51s,i0_51);
adder24 s1_52(z1s,z1,z1s,z1,i0_52s,i0_52);
adder24 s1_53(z1s,z1,z1s,z1,i0_53s,i0_53);
adder24 s1_54(z1s,z1,z1s,z1,i0_54s,i0_54);
adder24 s1_55(z1s,z1,z1s,z1,i0_55s,i0_55);
adder24 s1_56(z1s,z1,z1s,z1,i0_56s,i0_56);
adder24 s1_57(z1s,z1,z1s,z1,i0_57s,i0_57);
adder24 s1_58(z1s,z1,z1s,z1,i0_58s,i0_58);
adder24 s1_59(z1s,z1,z1s,z1,i0_59s,i0_59);
adder24 s1_60(z1s,z1,z1s,z1,i0_60s,i0_60);
adder24 s1_61(z1s,z1,z1s,z1,i0_61s,i0_61);
adder24 s1_62(z1s,z1,z1s,z1,i0_62s,i0_62);
adder24 s1_63(z1s,z1,z1s,z1,i0_63s,i0_63);
adder24 s1_64(z1s,z1,z1s,z1,i0_64s,i0_64);
adder24 s1_65(z1s,z1,z1s,z1,i0_65s,i0_65);
adder24 s1_66(z1s,z1,z1s,z1,i0_66s,i0_66);
adder24 s1_67(z1s,z1,z1s,z1,i0_67s,i0_67);
adder24 s1_68(z1s,z1,z1s,z1,i0_68s,i0_68);
adder24 s1_69(z1s,z1,z1s,z1,i0_69s,i0_69);
adder24 s1_70(z1s,z1,z1s,z1,i0_70s,i0_70);
adder24 s1_71(z1s,z1,z1s,z1,i0_71s,i0_71);
adder24 s1_72(z1s,z1,z1s,z1,i0_72s,i0_72);
adder24 s1_73(z1s,z1,z1s,z1,i0_73s,i0_73);
adder24 s1_74(z1s,z1,z1s,z1,i0_74s,i0_74);
adder24 s1_75(z1s,z1,z1s,z1,i0_75s,i0_75);
adder24 s1_76(z1s,z1,z1s,z1,i0_76s,i0_76);
adder24 s1_77(z1s,z1,z1s,z1,i0_77s,i0_77);
adder24 s1_78(z1s,z1,z1s,z1,i0_78s,i0_78);
adder24 s1_79(z1s,z1,z1s,z1,i0_79s,i0_79);
adder24 s1_80(z1s,z1,z1s,z1,i0_80s,i0_80);
adder24 s1_81(z1s,z1,z1s,z1,i0_81s,i0_81);
adder24 s1_82(z1s,z1,z1s,z1,i0_82s,i0_82);
adder24 s1_83(z1s,z1,z1s,z1,i0_83s,i0_83);
adder24 s1_84(z1s,z1,z1s,z1,i0_84s,i0_84);
adder24 s1_85(z1s,z1,z1s,z1,i0_85s,i0_85);
adder24 s1_86(z1s,z1,z1s,z1,i0_86s,i0_86);
adder24 s1_87(z1s,z1,z1s,z1,i0_87s,i0_87);
adder24 s1_88(z1s,z1,z1s,z1,i0_88s,i0_88);
adder24 s1_89(z1s,z1,z1s,z1,i0_89s,i0_89);
adder24 s1_90(z1s,z1,z1s,z1,i0_90s,i0_90);
adder24 s1_91(z1s,z1,z1s,z1,i0_91s,i0_91);
adder24 s1_92(z1s,z1,z1s,z1,i0_92s,i0_92);
adder24 s1_93(z1s,z1,z1s,z1,i0_93s,i0_93);
adder24 s1_94(z1s,z1,z1s,z1,i0_94s,i0_94);
adder24 s1_95(z1s,z1,z1s,z1,i0_95s,i0_95);
adder24 s1_96(z1s,z1,z1s,z1,i0_96s,i0_96);
adder24 s1_97(z1s,z1,z1s,z1,i0_97s,i0_97);
adder24 s1_98(z1s,z1,z1s,z1,i0_98s,i0_98);
adder24 s1_99(z1s,z1,z1s,z1,i0_99s,i0_99);
adder24 s1_100(z2s,z2,z2s,z2,i0_100s,i0_100);
adder24 s1_101(z2s,z2,z2s,z2,i0_101s,i0_101);
adder24 s1_102(z2s,z2,z2s,z2,i0_102s,i0_102);
adder24 s1_103(z2s,z2,z2s,z2,i0_103s,i0_103);
adder24 s1_104(z2s,z2,z2s,z2,i0_104s,i0_104);
adder24 s1_105(z2s,z2,z2s,z2,i0_105s,i0_105);
adder24 s1_106(z2s,z2,z2s,z2,i0_106s,i0_106);
adder24 s1_107(z2s,z2,z2s,z2,i0_107s,i0_107);
adder24 s1_108(z2s,z2,z2s,z2,i0_108s,i0_108);
adder24 s1_109(z2s,z2,z2s,z2,i0_109s,i0_109);
adder24 s1_110(z2s,z2,z2s,z2,i0_110s,i0_110);
adder24 s1_111(z2s,z2,z2s,z2,i0_111s,i0_111);
adder24 s1_112(z2s,z2,z2s,z2,i0_112s,i0_112);
adder24 s1_113(z2s,z2,z2s,z2,i0_113s,i0_113);
adder24 s1_114(z2s,z2,z2s,z2,i0_114s,i0_114);
adder24 s1_115(z2s,z2,z2s,z2,i0_115s,i0_115);
adder24 s1_116(z2s,z2,z2s,z2,i0_116s,i0_116);
adder24 s1_117(z2s,z2,z2s,z2,i0_117s,i0_117);
adder24 s1_118(z2s,z2,z2s,z2,i0_118s,i0_118);
adder24 s1_119(z2s,z2,z2s,z2,i0_119s,i0_119);
adder24 s1_120(z2s,z2,z2s,z2,i0_120s,i0_120);
adder24 s1_121(z2s,z2,z2s,z2,i0_121s,i0_121);
adder24 s1_122(z2s,z2,z2s,z2,i0_122s,i0_122);
adder24 s1_123(z2s,z2,z2s,z2,i0_123s,i0_123);
adder24 s1_124(z2s,z2,z2s,z2,i0_124s,i0_124);
adder24 s1_125(z2s,z2,z2s,z2,i0_125s,i0_125);
adder24 s1_126(z2s,z2,z2s,z2,i0_126s,i0_126);
adder24 s1_127(z2s,z2,z2s,z2,i0_127s,i0_127);

adder24 s1_128(zz5s,zz5,zz5s,zz5,i0_128s,i0_128);
adder24 s1_129(zz5s,zz5,zz5s,zz5,i0_129s,i0_129);
adder24 s1_130(zz6s,zz6,zz6s,zz6,i0_130s,i0_130);
adder24 s1_131(zz6s,zz6,zz6s,zz6,i0_131s,i0_131);
adder24 s1_132(zz6s,zz6,zz6s,zz6,i0_132s,i0_132);
adder24 s1_133(zz6s,zz6,zz6s,zz6,i0_133s,i0_133);
adder24 s1_134(zz6s,zz6,zz6s,zz6,i0_134s,i0_134);
adder24 s1_135(zz7s,zz7,zz7s,zz7,i0_135s,i0_135);
adder24 s1_136(zz7s,zz7,zz7s,zz7,i0_136s,i0_136);
adder24 s1_137(zz7s,zz7,zz7s,zz7,i0_137s,i0_137);
adder24 s1_138(zz7s,zz7,zz7s,zz7,i0_138s,i0_138);
adder24 s1_139(zz7s,zz7,zz7s,zz7,i0_139s,i0_139);
adder24 s1_140(zz8s,zz8,zz8s,zz8,i0_140s,i0_140);
adder24 s1_141(zz8s,zz8,zz8s,zz8,i0_141s,i0_141);
adder24 s1_142(zz8s,zz8,zz8s,zz8,i0_142s,i0_142);
adder24 s1_143(zz8s,zz8,zz8s,zz8,i0_143s,i0_143);
adder24 s1_144(zz8s,zz8,zz8s,zz8,i0_144s,i0_144);
adder24 s1_145(zz9s,zz9,zz9s,zz9,i0_145s,i0_145);
adder24 s1_146(zz9s,zz9,zz9s,zz9,i0_146s,i0_146);
adder24 s1_147(zz9s,zz9,zz9s,zz9,i0_147s,i0_147);
adder24 s1_148(zz9s,zz9,zz9s,zz9,i0_148s,i0_148);
adder24 s1_149(zz9s,zz9,zz9s,zz9,i0_149s,i0_149);
adder24 s1_150(zz1s,zz1,zz1s,zz1,i0_150s,i0_150);
adder24 s1_151(zz1s,zz1,zz1s,zz1,i0_151s,i0_151);
adder24 s1_152(zz1s,zz1,zz1s,zz1,i0_152s,i0_152);
adder24 s1_153(zz1s,zz1,zz1s,zz1,i0_153s,i0_153);
adder24 s1_154(zz1s,zz1,zz1s,zz1,i0_154s,i0_154);
adder24 s1_155(zz1s,zz1,zz1s,zz1,i0_155s,i0_155);
adder24 s1_156(zz1s,zz1,zz1s,zz1,i0_156s,i0_156);
adder24 s1_157(zz1s,zz1,zz1s,zz1,i0_157s,i0_157);
adder24 s1_158(zz1s,zz1,zz1s,zz1,i0_158s,i0_158);
adder24 s1_159(zz1s,zz1,zz1s,zz1,i0_159s,i0_159);
adder24 s1_160(zz1s,zz1,zz1s,zz1,i0_160s,i0_160);
adder24 s1_161(zz1s,zz1,zz1s,zz1,i0_161s,i0_161);
adder24 s1_162(zz1s,zz1,zz1s,zz1,i0_162s,i0_162);
adder24 s1_163(zz1s,zz1,zz1s,zz1,i0_163s,i0_163);
adder24 s1_164(zz1s,zz1,zz1s,zz1,i0_164s,i0_164);
adder24 s1_165(zz1s,zz1,zz1s,zz1,i0_165s,i0_165);
adder24 s1_166(zz1s,zz1,zz1s,zz1,i0_166s,i0_166);
adder24 s1_167(zz1s,zz1,zz1s,zz1,i0_167s,i0_167);
adder24 s1_168(zz1s,zz1,zz1s,zz1,i0_168s,i0_168);
adder24 s1_169(zz1s,zz1,zz1s,zz1,i0_169s,i0_169);
adder24 s1_170(zz1s,zz1,zz1s,zz1,i0_170s,i0_170);
adder24 s1_171(zz1s,zz1,zz1s,zz1,i0_171s,i0_171);
adder24 s1_172(zz1s,zz1,zz1s,zz1,i0_172s,i0_172);
adder24 s1_173(zz1s,zz1,zz1s,zz1,i0_173s,i0_173);
adder24 s1_174(zz1s,zz1,zz1s,zz1,i0_174s,i0_174);
adder24 s1_175(zz1s,zz1,zz1s,zz1,i0_175s,i0_175);
adder24 s1_176(zz1s,zz1,zz1s,zz1,i0_176s,i0_176);
adder24 s1_177(zz1s,zz1,zz1s,zz1,i0_177s,i0_177);
adder24 s1_178(zz1s,zz1,zz1s,zz1,i0_178s,i0_178);
adder24 s1_179(zz1s,zz1,zz1s,zz1,i0_179s,i0_179);
adder24 s1_180(zz1s,zz1,zz1s,zz1,i0_180s,i0_180);
adder24 s1_181(zz1s,zz1,zz1s,zz1,i0_181s,i0_181);
adder24 s1_182(zz1s,zz1,zz1s,zz1,i0_182s,i0_182);
adder24 s1_183(zz1s,zz1,zz1s,zz1,i0_183s,i0_183);
adder24 s1_184(zz1s,zz1,zz1s,zz1,i0_184s,i0_184);
adder24 s1_185(zz1s,zz1,zz1s,zz1,i0_185s,i0_185);
adder24 s1_186(zz1s,zz1,zz1s,zz1,i0_186s,i0_186);
adder24 s1_187(zz1s,zz1,zz1s,zz1,i0_187s,i0_187);
adder24 s1_188(zz1s,zz1,zz1s,zz1,i0_188s,i0_188);
adder24 s1_189(zz1s,zz1,zz1s,zz1,i0_189s,i0_189);
adder24 s1_190(zz1s,zz1,zz1s,zz1,i0_190s,i0_190);
adder24 s1_191(zz1s,zz1,zz1s,zz1,i0_191s,i0_191);
adder24 s1_192(zz1s,zz1,zz1s,zz1,i0_192s,i0_192);
adder24 s1_193(zz1s,zz1,zz1s,zz1,i0_193s,i0_193);
adder24 s1_194(zz1s,zz1,zz1s,zz1,i0_194s,i0_194);
adder24 s1_195(zz1s,zz1,zz1s,zz1,i0_195s,i0_195);
adder24 s1_196(zz1s,zz1,zz1s,zz1,i0_196s,i0_196);
adder24 s1_197(zz1s,zz1,zz1s,zz1,i0_197s,i0_197);
adder24 s1_198(zz1s,zz1,zz1s,zz1,i0_198s,i0_198);
adder24 s1_199(zz1s,zz1,zz1s,zz1,i0_199s,i0_199);
adder24 s1_200(zz2s,zz2,zz2s,zz2,i0_200s,i0_200);
adder24 s1_201(zz2s,zz2,zz2s,zz2,i0_201s,i0_201);
adder24 s1_202(zz2s,zz2,zz2s,zz2,i0_202s,i0_202);
adder24 s1_203(zz2s,zz2,zz2s,zz2,i0_203s,i0_203);
adder24 s1_204(zz2s,zz2,zz2s,zz2,i0_204s,i0_204);
adder24 s1_205(zz2s,zz2,zz2s,zz2,i0_205s,i0_205);
adder24 s1_206(zz2s,zz2,zz2s,zz2,i0_206s,i0_206);
adder24 s1_207(zz2s,zz2,zz2s,zz2,i0_207s,i0_207);
adder24 s1_208(zz2s,zz2,zz2s,zz2,i0_208s,i0_208);
adder24 s1_209(zz2s,zz2,zz2s,zz2,i0_209s,i0_209);
adder24 s1_210(zz2s,zz2,zz2s,zz2,i0_210s,i0_210);
adder24 s1_211(zz2s,zz2,zz2s,zz2,i0_211s,i0_211);
adder24 s1_212(zz2s,zz2,zz2s,zz2,i0_212s,i0_212);
adder24 s1_213(zz2s,zz2,zz2s,zz2,i0_213s,i0_213);
adder24 s1_214(zz2s,zz2,zz2s,zz2,i0_214s,i0_214);
adder24 s1_215(zz2s,zz2,zz2s,zz2,i0_215s,i0_215);
adder24 s1_216(zz2s,zz2,zz2s,zz2,i0_216s,i0_216);
adder24 s1_217(zz2s,zz2,zz2s,zz2,i0_217s,i0_217);
adder24 s1_218(zz2s,zz2,zz2s,zz2,i0_218s,i0_218);
adder24 s1_219(zz2s,zz2,zz2s,zz2,i0_219s,i0_219);
adder24 s1_220(zz2s,zz2,zz2s,zz2,i0_220s,i0_220);
adder24 s1_221(zz2s,zz2,zz2s,zz2,i0_221s,i0_221);
adder24 s1_222(zz2s,zz2,zz2s,zz2,i0_222s,i0_222);
adder24 s1_223(zz2s,zz2,zz2s,zz2,i0_223s,i0_223);
adder24 s1_224(zz2s,zz2,zz2s,zz2,i0_224s,i0_224);
adder24 s1_225(zz2s,zz2,zz2s,zz2,i0_225s,i0_225);
adder24 s1_226(zz2s,zz2,zz2s,zz2,i0_226s,i0_226);
adder24 s1_227(zz2s,zz2,zz2s,zz2,i0_227s,i0_227);
adder24 s1_228(zz5s,zz5,zz5s,zz5,i0_228s,i0_228);
adder24 s1_229(zz5s,zz5,zz5s,zz5,i0_229s,i0_229);
adder24 s1_230(zz6s,zz6,zz6s,zz6,i0_230s,i0_230);
adder24 s1_231(zz6s,zz6,zz6s,zz6,i0_231s,i0_231);
adder24 s1_232(zz6s,zz6,zz6s,zz6,i0_232s,i0_232);
adder24 s1_233(zz6s,zz6,zz6s,zz6,i0_233s,i0_233);
adder24 s1_234(zz6s,zz6,zz6s,zz6,i0_234s,i0_234);
adder24 s1_235(zz7s,zz7,zz7s,zz7,i0_235s,i0_235);
adder24 s1_236(zz7s,zz7,zz7s,zz7,i0_236s,i0_236);
adder24 s1_237(zz7s,zz7,zz7s,zz7,i0_237s,i0_237);
adder24 s1_238(zz7s,zz7,zz7s,zz7,i0_238s,i0_238);
adder24 s1_239(zz7s,zz7,zz7s,zz7,i0_239s,i0_239);
adder24 s1_240(zz8s,zz8,zz8s,zz8,i0_240s,i0_240);
adder24 s1_241(zz8s,zz8,zz8s,zz8,i0_241s,i0_241);
adder24 s1_242(zz8s,zz8,zz8s,zz8,i0_242s,i0_242);
adder24 s1_243(zz8s,zz8,zz8s,zz8,i0_243s,i0_243);
adder24 s1_244(zz8s,zz8,zz8s,zz8,i0_244s,i0_244);
adder24 s1_245(zz9s,zz9,zz9s,zz9,i0_245s,i0_245);
adder24 s1_246(zz9s,zz9,zz9s,zz9,i0_246s,i0_246);
adder24 s1_247(zz9s,zz9,zz9s,zz9,i0_247s,i0_247);
adder24 s1_248(zz9s,zz9,zz9s,zz9,i0_248s,i0_248);
adder24 s1_249(zz9s,zz9,zz9s,zz9,i0_249s,i0_249);
adder24 s1_250(zz1s,zz1,zz1s,zz1,i0_250s,i0_250);
adder24 s1_251(zz1s,zz1,zz1s,zz1,i0_251s,i0_251);
adder24 s1_252(zz1s,zz1,zz1s,zz1,i0_252s,i0_252);
adder24 s1_253(zz1s,zz1,zz1s,zz1,i0_253s,i0_253);
adder24 s1_254(zz1s,zz1,zz1s,zz1,i0_254s,i0_254);
adder24 s1_255(zz1s,zz1,zz1s,zz1,i0_255s,i0_255);

//second level

wire 
i1_0s,i1_1s,i1_2s,i1_3s,i1_4s,i1_5s,i1_6s,i1_7s,i1_8s,i1_9s,
i1_10s,i1_11s,i1_12s,i1_13s,i1_14s,i1_15s,i1_16s,i1_17s,i1_18s,i1_19s,
i1_20s,i1_21s,i1_22s,i1_23s,i1_24s,i1_25s,i1_26s,i1_27s,i1_28s,i1_29s,
i1_30s,i1_31s,i1_32s,i1_33s,i1_34s,i1_35s,i1_36s,i1_37s,i1_38s,i1_39s,
i1_40s,i1_41s,i1_42s,i1_43s,i1_44s,i1_45s,i1_46s,i1_47s,i1_48s,i1_49s,
i1_50s,i1_51s,i1_52s,i1_53s,i1_54s,i1_55s,i1_56s,i1_57s,i1_58s,i1_59s,
i1_60s,i1_61s,i1_62s,i1_63s,i1_64s,i1_65s,i1_66s,i1_67s,i1_68s,i1_69s,
i1_70s,i1_71s,i1_72s,i1_73s,i1_74s,i1_75s,i1_76s,i1_77s,i1_78s,i1_79s,
i1_80s,i1_81s,i1_82s,i1_83s,i1_84s,i1_85s,i1_86s,i1_87s,i1_88s,i1_89s,
i1_90s,i1_91s,i1_92s,i1_93s,i1_94s,i1_95s,i1_96s,i1_97s,i1_98s,i1_99s,
i1_100s,i1_101s,i1_102s,i1_103s,i1_104s,i1_105s,i1_106s,i1_107s,i1_108s,i1_109s,
i1_110s,i1_111s,i1_112s,i1_113s,i1_114s,i1_115s,i1_116s,i1_117s,i1_118s,i1_119s,
i1_120s,i1_121s,i1_122s,i1_123s,i1_124s,i1_125s,i1_126s,i1_127s;



wire [23:0] 
i1_0,i1_1,i1_2,i1_3,i1_4,i1_5,i1_6,i1_7,i1_8,i1_9,
i1_10,i1_11,i1_12,i1_13,i1_14,i1_15,i1_16,i1_17,i1_18,i1_19,
i1_20,i1_21,i1_22,i1_23,i1_24,i1_25,i1_26,i1_27,i1_28,i1_29,
i1_30,i1_31,i1_32,i1_33,i1_34,i1_35,i1_36,i1_37,i1_38,i1_39,
i1_40,i1_41,i1_42,i1_43,i1_44,i1_45,i1_46,i1_47,i1_48,i1_49,
i1_50,i1_51,i1_52,i1_53,i1_54,i1_55,i1_56,i1_57,i1_58,i1_59,
i1_60,i1_61,i1_62,i1_63,i1_64,i1_65,i1_66,i1_67,i1_68,i1_69,
i1_70,i1_71,i1_72,i1_73,i1_74,i1_75,i1_76,i1_77,i1_78,i1_79,
i1_80,i1_81,i1_82,i1_83,i1_84,i1_85,i1_86,i1_87,i1_88,i1_89,
i1_90,i1_91,i1_92,i1_93,i1_94,i1_95,i1_96,i1_97,i1_98,i1_99,
i1_100,i1_101,i1_102,i1_103,i1_104,i1_105,i1_106,i1_107,i1_108,i1_109,
i1_110,i1_111,i1_112,i1_113,i1_114,i1_115,i1_116,i1_117,i1_118,i1_119,
i1_120,i1_121,i1_122,i1_123,i1_124,i1_125,i1_126,i1_127;

adder24 s2_0(i0_0s,i0_0,i0_1s,i0_1,i1_0s,i1_0);
adder24 s2_1(i0_2s,i0_2,i0_3s,i0_3,i1_1s,i1_1);
adder24 s2_2(i0_4s,i0_4,i0_5s,i0_5,i1_2s,i1_2);
adder24 s2_3(i0_6s,i0_6,i0_7s,i0_7,i1_3s,i1_3);
adder24 s2_4(i0_8s,i0_8,i0_9s,i0_9,i1_4s,i1_4);
adder24 s2_5(i0_10s,i0_10,i0_11s,i0_11,i1_5s,i1_5);
adder24 s2_6(i0_12s,i0_12,i0_13s,i0_13,i1_6s,i1_6);
adder24 s2_7(i0_14s,i0_14,i0_15s,i0_15,i1_7s,i1_7);
adder24 s2_8(i0_16s,i0_16,i0_17s,i0_17,i1_8s,i1_8);
adder24 s2_9(i0_18s,i0_18,i0_19s,i0_19,i1_9s,i1_9);
adder24 s2_10(i0_20s,i0_20,i0_21s,i0_21,i1_10s,i1_10);
adder24 s2_11(i0_22s,i0_22,i0_23s,i0_23,i1_11s,i1_11);
adder24 s2_12(i0_24s,i0_24,i0_25s,i0_25,i1_12s,i1_12);
adder24 s2_13(i0_26s,i0_26,i0_27s,i0_27,i1_13s,i1_13);
adder24 s2_14(i0_28s,i0_28,i0_29s,i0_29,i1_14s,i1_14);
adder24 s2_15(i0_30s,i0_30,i0_31s,i0_31,i1_15s,i1_15);
adder24 s2_16(i0_32s,i0_32,i0_33s,i0_33,i1_16s,i1_16);
adder24 s2_17(i0_34s,i0_34,i0_35s,i0_35,i1_17s,i1_17);
adder24 s2_18(i0_36s,i0_36,i0_37s,i0_37,i1_18s,i1_18);
adder24 s2_19(i0_38s,i0_38,i0_39s,i0_39,i1_19s,i1_19);
adder24 s2_20(i0_40s,i0_40,i0_41s,i0_41,i1_20s,i1_20);
adder24 s2_21(i0_42s,i0_42,i0_43s,i0_43,i1_21s,i1_21);
adder24 s2_22(i0_44s,i0_44,i0_45s,i0_45,i1_22s,i1_22);
adder24 s2_23(i0_46s,i0_46,i0_47s,i0_47,i1_23s,i1_23);
adder24 s2_24(i0_48s,i0_48,i0_49s,i0_49,i1_24s,i1_24);
adder24 s2_25(i0_50s,i0_50,i0_51s,i0_51,i1_25s,i1_25);
adder24 s2_26(i0_52s,i0_52,i0_53s,i0_53,i1_26s,i1_26);
adder24 s2_27(i0_54s,i0_54,i0_55s,i0_55,i1_27s,i1_27);
adder24 s2_28(i0_56s,i0_56,i0_57s,i0_57,i1_28s,i1_28);
adder24 s2_29(i0_58s,i0_58,i0_59s,i0_59,i1_29s,i1_29);
adder24 s2_30(i0_60s,i0_60,i0_61s,i0_61,i1_30s,i1_30);
adder24 s2_31(i0_62s,i0_62,i0_63s,i0_63,i1_31s,i1_31);
adder24 s2_32(i0_64s,i0_64,i0_65s,i0_65,i1_32s,i1_32);
adder24 s2_33(i0_66s,i0_66,i0_67s,i0_67,i1_33s,i1_33);
adder24 s2_34(i0_68s,i0_68,i0_69s,i0_69,i1_34s,i1_34);
adder24 s2_35(i0_70s,i0_70,i0_71s,i0_71,i1_35s,i1_35);
adder24 s2_36(i0_72s,i0_72,i0_73s,i0_73,i1_36s,i1_36);
adder24 s2_37(i0_74s,i0_74,i0_75s,i0_75,i1_37s,i1_37);
adder24 s2_38(i0_76s,i0_76,i0_77s,i0_77,i1_38s,i1_38);
adder24 s2_39(i0_78s,i0_78,i0_79s,i0_79,i1_39s,i1_39);
adder24 s2_40(i0_80s,i0_80,i0_81s,i0_81,i1_40s,i1_40);
adder24 s2_41(i0_82s,i0_82,i0_83s,i0_83,i1_41s,i1_41);
adder24 s2_42(i0_84s,i0_84,i0_85s,i0_85,i1_42s,i1_42);
adder24 s2_43(i0_86s,i0_86,i0_87s,i0_87,i1_43s,i1_43);
adder24 s2_44(i0_88s,i0_88,i0_89s,i0_89,i1_44s,i1_44);
adder24 s2_45(i0_90s,i0_90,i0_91s,i0_91,i1_45s,i1_45);
adder24 s2_46(i0_92s,i0_92,i0_93s,i0_93,i1_46s,i1_46);
adder24 s2_47(i0_94s,i0_94,i0_95s,i0_95,i1_47s,i1_47);
adder24 s2_48(i0_96s,i0_96,i0_97s,i0_97,i1_48s,i1_48);
adder24 s2_49(i0_98s,i0_98,i0_99s,i0_99,i1_49s,i1_49);
adder24 s2_50(i0_100s,i0_100,i0_101s,i0_101,i1_50s,i1_50);
adder24 s2_51(i0_102s,i0_102,i0_103s,i0_103,i1_51s,i1_51);
adder24 s2_52(i0_104s,i0_104,i0_105s,i0_105,i1_52s,i1_52);
adder24 s2_53(i0_106s,i0_106,i0_107s,i0_107,i1_53s,i1_53);
adder24 s2_54(i0_108s,i0_108,i0_109s,i0_109,i1_54s,i1_54);
adder24 s2_55(i0_110s,i0_110,i0_111s,i0_111,i1_55s,i1_55);
adder24 s2_56(i0_112s,i0_112,i0_113s,i0_113,i1_56s,i1_56);
adder24 s2_57(i0_114s,i0_114,i0_115s,i0_115,i1_57s,i1_57);
adder24 s2_58(i0_116s,i0_116,i0_117s,i0_117,i1_58s,i1_58);
adder24 s2_59(i0_118s,i0_118,i0_119s,i0_119,i1_59s,i1_59);
adder24 s2_60(i0_120s,i0_120,i0_121s,i0_121,i1_60s,i1_60);
adder24 s2_61(i0_122s,i0_122,i0_123s,i0_123,i1_61s,i1_61);
adder24 s2_62(i0_124s,i0_124,i0_125s,i0_125,i1_62s,i1_62);
adder24 s2_63(i0_126s,i0_126,i0_127s,i0_127,i1_63s,i1_63);
adder24 s2_64(i0_128s,i0_128,i0_129s,i0_129,i1_64s,i1_64);
adder24 s2_65(i0_130s,i0_130,i0_131s,i0_131,i1_65s,i1_65);
adder24 s2_66(i0_132s,i0_132,i0_133s,i0_133,i1_66s,i1_66);
adder24 s2_67(i0_134s,i0_134,i0_135s,i0_135,i1_67s,i1_67);
adder24 s2_68(i0_136s,i0_136,i0_137s,i0_137,i1_68s,i1_68);
adder24 s2_69(i0_138s,i0_138,i0_139s,i0_139,i1_69s,i1_69);
adder24 s2_70(i0_140s,i0_140,i0_141s,i0_141,i1_70s,i1_70);
adder24 s2_71(i0_142s,i0_142,i0_143s,i0_143,i1_71s,i1_71);
adder24 s2_72(i0_144s,i0_144,i0_145s,i0_145,i1_72s,i1_72);
adder24 s2_73(i0_146s,i0_146,i0_147s,i0_147,i1_73s,i1_73);
adder24 s2_74(i0_148s,i0_148,i0_149s,i0_149,i1_74s,i1_74);
adder24 s2_75(i0_150s,i0_150,i0_151s,i0_151,i1_75s,i1_75);
adder24 s2_76(i0_152s,i0_152,i0_153s,i0_153,i1_76s,i1_76);
adder24 s2_77(i0_154s,i0_154,i0_155s,i0_155,i1_77s,i1_77);
adder24 s2_78(i0_156s,i0_156,i0_157s,i0_157,i1_78s,i1_78);
adder24 s2_79(i0_158s,i0_158,i0_159s,i0_159,i1_79s,i1_79);
adder24 s2_80(i0_160s,i0_160,i0_161s,i0_161,i1_80s,i1_80);
adder24 s2_81(i0_162s,i0_162,i0_163s,i0_163,i1_81s,i1_81);
adder24 s2_82(i0_164s,i0_164,i0_165s,i0_165,i1_82s,i1_82);
adder24 s2_83(i0_166s,i0_166,i0_167s,i0_167,i1_83s,i1_83);
adder24 s2_84(i0_168s,i0_168,i0_169s,i0_169,i1_84s,i1_84);
adder24 s2_85(i0_170s,i0_170,i0_171s,i0_171,i1_85s,i1_85);
adder24 s2_86(i0_172s,i0_172,i0_173s,i0_173,i1_86s,i1_86);
adder24 s2_87(i0_174s,i0_174,i0_175s,i0_175,i1_87s,i1_87);
adder24 s2_88(i0_176s,i0_176,i0_177s,i0_177,i1_88s,i1_88);
adder24 s2_89(i0_178s,i0_178,i0_179s,i0_179,i1_89s,i1_89);
adder24 s2_90(i0_180s,i0_180,i0_181s,i0_181,i1_90s,i1_90);
adder24 s2_91(i0_182s,i0_182,i0_183s,i0_183,i1_91s,i1_91);
adder24 s2_92(i0_184s,i0_184,i0_185s,i0_185,i1_92s,i1_92);
adder24 s2_93(i0_186s,i0_186,i0_187s,i0_187,i1_93s,i1_93);
adder24 s2_94(i0_188s,i0_188,i0_189s,i0_189,i1_94s,i1_94);
adder24 s2_95(i0_190s,i0_190,i0_191s,i0_191,i1_95s,i1_95);
adder24 s2_96(i0_192s,i0_192,i0_193s,i0_193,i1_96s,i1_96);
adder24 s2_97(i0_194s,i0_194,i0_195s,i0_195,i1_97s,i1_97);
adder24 s2_98(i0_196s,i0_196,i0_197s,i0_197,i1_98s,i1_98);
adder24 s2_99(i0_198s,i0_198,i0_199s,i0_199,i1_99s,i1_99);
adder24 s2_100(i0_200s,i0_200,i0_201s,i0_201,i1_100s,i1_100);
adder24 s2_101(i0_202s,i0_202,i0_203s,i0_203,i1_101s,i1_101);
adder24 s2_102(i0_204s,i0_204,i0_205s,i0_205,i1_102s,i1_102);
adder24 s2_103(i0_206s,i0_206,i0_207s,i0_207,i1_103s,i1_103);
adder24 s2_104(i0_208s,i0_208,i0_209s,i0_209,i1_104s,i1_104);
adder24 s2_105(i0_210s,i0_210,i0_211s,i0_211,i1_105s,i1_105);
adder24 s2_106(i0_212s,i0_212,i0_213s,i0_213,i1_106s,i1_106);
adder24 s2_107(i0_214s,i0_214,i0_215s,i0_215,i1_107s,i1_107);
adder24 s2_108(i0_216s,i0_216,i0_217s,i0_217,i1_108s,i1_108);
adder24 s2_109(i0_218s,i0_218,i0_219s,i0_219,i1_109s,i1_109);
adder24 s2_110(i0_220s,i0_220,i0_221s,i0_221,i1_110s,i1_110);
adder24 s2_111(i0_222s,i0_222,i0_223s,i0_223,i1_111s,i1_111);
adder24 s2_112(i0_224s,i0_224,i0_225s,i0_225,i1_112s,i1_112);
adder24 s2_113(i0_226s,i0_226,i0_227s,i0_227,i1_113s,i1_113);
adder24 s2_114(i0_228s,i0_228,i0_229s,i0_229,i1_114s,i1_114);
adder24 s2_115(i0_230s,i0_230,i0_231s,i0_231,i1_115s,i1_115);
adder24 s2_116(i0_232s,i0_232,i0_233s,i0_233,i1_116s,i1_116);
adder24 s2_117(i0_234s,i0_234,i0_235s,i0_235,i1_117s,i1_117);
adder24 s2_118(i0_236s,i0_236,i0_237s,i0_237,i1_118s,i1_118);
adder24 s2_119(i0_238s,i0_238,i0_239s,i0_239,i1_119s,i1_119);
adder24 s2_120(i0_240s,i0_240,i0_241s,i0_241,i1_120s,i1_120);
adder24 s2_121(i0_242s,i0_242,i0_243s,i0_243,i1_121s,i1_121);
adder24 s2_122(i0_244s,i0_244,i0_245s,i0_245,i1_122s,i1_122);
adder24 s2_123(i0_246s,i0_246,i0_247s,i0_247,i1_123s,i1_123);
adder24 s2_124(i0_248s,i0_248,i0_249s,i0_249,i1_124s,i1_124);
adder24 s2_125(i0_250s,i0_250,i0_251s,i0_251,i1_125s,i1_125);
adder24 s2_126(i0_252s,i0_252,i0_253s,i0_253,i1_126s,i1_126);
adder24 s2_127(i0_254s,i0_254,i0_255s,i0_255,i1_127s,i1_127);

//third level

wire 
i2_0s,i2_1s,i2_2s,i2_3s,i2_4s,i2_5s,i2_6s,i2_7s,i2_8s,i2_9s,
i2_10s,i2_11s,i2_12s,i2_13s,i2_14s,i2_15s,i2_16s,i2_17s,i2_18s,i2_19s,
i2_20s,i2_21s,i2_22s,i2_23s,i2_24s,i2_25s,i2_26s,i2_27s,i2_28s,i2_29s,
i2_30s,i2_31s,i2_32s,i2_33s,i2_34s,i2_35s,i2_36s,i2_37s,i2_38s,i2_39s,
i2_40s,i2_41s,i2_42s,i2_43s,i2_44s,i2_45s,i2_46s,i2_47s,i2_48s,i2_49s,
i2_50s,i2_51s,i2_52s,i2_53s,i2_54s,i2_55s,i2_56s,i2_57s,i2_58s,i2_59s,
i2_60s,i2_61s,i2_62s,i2_63s;

wire [23:0]
i2_0,i2_1,i2_2,i2_3,i2_4,i2_5,i2_6,i2_7,i2_8,i2_9,
i2_10,i2_11,i2_12,i2_13,i2_14,i2_15,i2_16,i2_17,i2_18,i2_19,
i2_20,i2_21,i2_22,i2_23,i2_24,i2_25,i2_26,i2_27,i2_28,i2_29,
i2_30,i2_31,i2_32,i2_33,i2_34,i2_35,i2_36,i2_37,i2_38,i2_39,
i2_40,i2_41,i2_42,i2_43,i2_44,i2_45,i2_46,i2_47,i2_48,i2_49,
i2_50,i2_51,i2_52,i2_53,i2_54,i2_55,i2_56,i2_57,i2_58,i2_59,
i2_60,i2_61,i2_62,i2_63;

adder24 s3_0(i1_0s,i1_0,i1_1s,i1_1,i2_0s,i2_0);
adder24 s3_1(i1_2s,i1_2,i1_3s,i1_3,i2_1s,i2_1);
adder24 s3_2(i1_4s,i1_4,i1_5s,i1_5,i2_2s,i2_2);
adder24 s3_3(i1_6s,i1_6,i1_7s,i1_7,i2_3s,i2_3);
adder24 s3_4(i1_8s,i1_8,i1_9s,i1_9,i2_4s,i2_4);
adder24 s3_5(i1_10s,i1_10,i1_11s,i1_11,i2_5s,i2_5);
adder24 s3_6(i1_12s,i1_12,i1_13s,i1_13,i2_6s,i2_6);
adder24 s3_7(i1_14s,i1_14,i1_15s,i1_15,i2_7s,i2_7);
adder24 s3_8(i1_16s,i1_16,i1_17s,i1_17,i2_8s,i2_8);
adder24 s3_9(i1_18s,i1_18,i1_19s,i1_19,i2_9s,i2_9);
adder24 s3_10(i1_20s,i1_20,i1_21s,i1_21,i2_10s,i2_10);
adder24 s3_11(i1_22s,i1_22,i1_23s,i1_23,i2_11s,i2_11);
adder24 s3_12(i1_24s,i1_24,i1_25s,i1_25,i2_12s,i2_12);
adder24 s3_13(i1_26s,i1_26,i1_27s,i1_27,i2_13s,i2_13);
adder24 s3_14(i1_28s,i1_28,i1_29s,i1_29,i2_14s,i2_14);
adder24 s3_15(i1_30s,i1_30,i1_31s,i1_31,i2_15s,i2_15);
adder24 s3_16(i1_32s,i1_32,i1_33s,i1_33,i2_16s,i2_16);
adder24 s3_17(i1_34s,i1_34,i1_35s,i1_35,i2_17s,i2_17);
adder24 s3_18(i1_36s,i1_36,i1_37s,i1_37,i2_18s,i2_18);
adder24 s3_19(i1_38s,i1_38,i1_39s,i1_39,i2_19s,i2_19);
adder24 s3_20(i1_40s,i1_40,i1_41s,i1_41,i2_20s,i2_20);
adder24 s3_21(i1_42s,i1_42,i1_43s,i1_43,i2_21s,i2_21);
adder24 s3_22(i1_44s,i1_44,i1_45s,i1_45,i2_22s,i2_22);
adder24 s3_23(i1_46s,i1_46,i1_47s,i1_47,i2_23s,i2_23);
adder24 s3_24(i1_48s,i1_48,i1_49s,i1_49,i2_24s,i2_24);
adder24 s3_25(i1_50s,i1_50,i1_51s,i1_51,i2_25s,i2_25);
adder24 s3_26(i1_52s,i1_52,i1_53s,i1_53,i2_26s,i2_26);
adder24 s3_27(i1_54s,i1_54,i1_55s,i1_55,i2_27s,i2_27);
adder24 s3_28(i1_56s,i1_56,i1_57s,i1_57,i2_28s,i2_28);
adder24 s3_29(i1_58s,i1_58,i1_59s,i1_59,i2_29s,i2_29);
adder24 s3_30(i1_60s,i1_60,i1_61s,i1_61,i2_30s,i2_30);
adder24 s3_31(i1_62s,i1_62,i1_63s,i1_63,i2_31s,i2_31);
adder24 s3_32(i1_64s,i1_64,i1_65s,i1_65,i2_32s,i2_32);
adder24 s3_33(i1_66s,i1_66,i1_67s,i1_67,i2_33s,i2_33);
adder24 s3_34(i1_68s,i1_68,i1_69s,i1_69,i2_34s,i2_34);
adder24 s3_35(i1_70s,i1_70,i1_71s,i1_71,i2_35s,i2_35);
adder24 s3_36(i1_72s,i1_72,i1_73s,i1_73,i2_36s,i2_36);
adder24 s3_37(i1_74s,i1_74,i1_75s,i1_75,i2_37s,i2_37);
adder24 s3_38(i1_76s,i1_76,i1_77s,i1_77,i2_38s,i2_38);
adder24 s3_39(i1_78s,i1_78,i1_79s,i1_79,i2_39s,i2_39);
adder24 s3_40(i1_80s,i1_80,i1_81s,i1_81,i2_40s,i2_40);
adder24 s3_41(i1_82s,i1_82,i1_83s,i1_83,i2_41s,i2_41);
adder24 s3_42(i1_84s,i1_84,i1_85s,i1_85,i2_42s,i2_42);
adder24 s3_43(i1_86s,i1_86,i1_87s,i1_87,i2_43s,i2_43);
adder24 s3_44(i1_88s,i1_88,i1_89s,i1_89,i2_44s,i2_44);
adder24 s3_45(i1_90s,i1_90,i1_91s,i1_91,i2_45s,i2_45);
adder24 s3_46(i1_92s,i1_92,i1_93s,i1_93,i2_46s,i2_46);
adder24 s3_47(i1_94s,i1_94,i1_95s,i1_95,i2_47s,i2_47);
adder24 s3_48(i1_96s,i1_96,i1_97s,i1_97,i2_48s,i2_48);
adder24 s3_49(i1_98s,i1_98,i1_99s,i1_99,i2_49s,i2_49);
adder24 s3_50(i1_100s,i1_100,i1_101s,i1_101,i2_50s,i2_50);
adder24 s3_51(i1_102s,i1_102,i1_103s,i1_103,i2_51s,i2_51);
adder24 s3_52(i1_104s,i1_104,i1_105s,i1_105,i2_52s,i2_52);
adder24 s3_53(i1_106s,i1_106,i1_107s,i1_107,i2_53s,i2_53);
adder24 s3_54(i1_108s,i1_108,i1_109s,i1_109,i2_54s,i2_54);
adder24 s3_55(i1_110s,i1_110,i1_111s,i1_111,i2_55s,i2_55);
adder24 s3_56(i1_112s,i1_112,i1_113s,i1_113,i2_56s,i2_56);
adder24 s3_57(i1_114s,i1_114,i1_115s,i1_115,i2_57s,i2_57);
adder24 s3_58(i1_116s,i1_116,i1_117s,i1_117,i2_58s,i2_58);
adder24 s3_59(i1_118s,i1_118,i1_119s,i1_119,i2_59s,i2_59);
adder24 s3_60(i1_120s,i1_120,i1_121s,i1_121,i2_60s,i2_60);
adder24 s3_61(i1_122s,i1_122,i1_123s,i1_123,i2_61s,i2_61);
adder24 s3_62(i1_124s,i1_124,i1_125s,i1_125,i2_62s,i2_62);
adder24 s3_63(i1_126s,i1_126,i1_127s,i1_127,i2_63s,i2_63);

//fourth level

adder24 s4_0(i2_0s,i2_0,i2_1s,i2_1,ou0s,ou0);
adder24 s4_1(i2_2s,i2_2,i2_3s,i2_3,ou1s,ou1);
adder24 s4_2(i2_4s,i2_4,i2_5s,i2_5,ou2s,ou2);
adder24 s4_3(i2_6s,i2_6,i2_7s,i2_7,ou3s,ou3);
adder24 s4_4(i2_8s,i2_8,i2_9s,i2_9,ou4s,ou4);
adder24 s4_5(i2_10s,i2_10,i2_11s,i2_11,ou5s,ou5);
adder24 s4_6(i2_12s,i2_12,i2_13s,i2_13,ou6s,ou6);
adder24 s4_7(i2_14s,i2_14,i2_15s,i2_15,ou7s,ou7);
adder24 s4_8(i2_16s,i2_16,i2_17s,i2_17,ou8s,ou8);
adder24 s4_9(i2_18s,i2_18,i2_19s,i2_19,ou9s,ou9);
adder24 s4_10(i2_20s,i2_20,i2_21s,i2_21,ou10s,ou10);
adder24 s4_11(i2_22s,i2_22,i2_23s,i2_23,ou11s,ou11);
adder24 s4_12(i2_24s,i2_24,i2_25s,i2_25,ou12s,ou12);
adder24 s4_13(i2_26s,i2_26,i2_27s,i2_27,ou13s,ou13);
adder24 s4_14(i2_28s,i2_28,i2_29s,i2_29,ou14s,ou14);
adder24 s4_15(i2_30s,i2_30,i2_31s,i2_31,ou15s,ou15);
adder24 s4_16(i2_32s,i2_32,i2_33s,i2_33,ou16s,ou16);
adder24 s4_17(i2_34s,i2_34,i2_35s,i2_35,ou17s,ou17);
adder24 s4_18(i2_36s,i2_36,i2_37s,i2_37,ou18s,ou18);
adder24 s4_19(i2_38s,i2_38,i2_39s,i2_39,ou19s,ou19);
adder24 s4_20(i2_40s,i2_40,i2_41s,i2_41,ou20s,ou20);
adder24 s4_21(i2_42s,i2_42,i2_43s,i2_43,ou21s,ou21);
adder24 s4_22(i2_44s,i2_44,i2_45s,i2_45,ou22s,ou22);
adder24 s4_23(i2_46s,i2_46,i2_47s,i2_47,ou23s,ou23);
adder24 s4_24(i2_48s,i2_48,i2_49s,i2_49,ou24s,ou24);
adder24 s4_25(i2_50s,i2_50,i2_51s,i2_51,ou25s,ou25);
adder24 s4_26(i2_52s,i2_52,i2_53s,i2_53,ou26s,ou26);
adder24 s4_27(i2_54s,i2_54,i2_55s,i2_55,ou27s,ou27);
adder24 s4_28(i2_56s,i2_56,i2_57s,i2_57,ou28s,ou28);
adder24 s4_29(i2_58s,i2_58,i2_59s,i2_59,ou29s,ou29);
adder24 s4_30(i2_60s,i2_60,i2_61s,i2_61,ou30s,ou30);
adder24 s4_31(i2_62s,i2_62,i2_63s,i2_63,ou31s,ou31);

endmodule




//24 bit fixed point adder

//`include "recurse24.v"
//`include "kgp.v"
//`include "kgp_carry.v"
//`include "recursive_stage1.v"

module adder24(as,a,bs,in_b,rrs,rr);

input as,bs;
input [23:0] a,in_b;
output rrs;
output [23:0] rr;

reg rrs;
reg [23:0] rr;
wire z;
assign z=as^bs;
wire cout,cout1;

wire [23:0] r1,b1,b2;
assign b1=(~in_b);

recurse24 c0(b2,cout1,b1,24'b000000000000000000000001);

reg [23:0] b;

always@(z or in_b or b2)
	begin
		if(z==0)
			b=in_b;
		else if (z==1)
			b=b2;
	end
	
recurse24 c1(r1,cout,a,b);

wire cout2;
wire [23:0] r11,r22;
assign r11=(~r1);
recurse24 c2(r22,cout2,r11,24'b000000000000000000000001);

reg carry;
always@(r1 or cout or z or as or bs or r22)
 begin
	if(z==0)	
		begin
			rrs=as;
			rr=r1;
			carry=cout;
		end
	else if (z==1 && cout==1)
		begin	
			rrs=as;
			rr=r1;
			carry=1'b0;
		end
	else if (z==1 && cout==0)
		begin
			rrs=(~as);
			rr=r22;
			carry=1'b0;
		end
 end

endmodule


//24 bit recursive doubling technique

module recurse24(sum,carry,a,b); 

output [23:0] sum;
output  carry;
input [23:0] a,b;

wire [49:0] x;

assign x[1:0]=2'b00;  // kgp generation

kgp a00(a[0],b[0],x[3:2]);
kgp a01(a[1],b[1],x[5:4]);
kgp a02(a[2],b[2],x[7:6]);
kgp a03(a[3],b[3],x[9:8]);
kgp a04(a[4],b[4],x[11:10]);
kgp a05(a[5],b[5],x[13:12]);
kgp a06(a[6],b[6],x[15:14]);
kgp a07(a[7],b[7],x[17:16]);
kgp a08(a[8],b[8],x[19:18]);
kgp a09(a[9],b[9],x[21:20]);
kgp a10(a[10],b[10],x[23:22]);
kgp a11(a[11],b[11],x[25:24]);
kgp a12(a[12],b[12],x[27:26]);
kgp a13(a[13],b[13],x[29:28]);
kgp a14(a[14],b[14],x[31:30]);
kgp a15(a[15],b[15],x[33:32]);
kgp a16(a[16],b[16],x[35:34]);
kgp a17(a[17],b[17],x[37:36]);
kgp a18(a[18],b[18],x[39:38]);
kgp a19(a[19],b[19],x[41:40]);
kgp a20(a[20],b[20],x[43:42]);
kgp a21(a[21],b[21],x[45:44]);
kgp a22(a[22],b[22],x[47:46]);
kgp a23(a[23],b[23],x[49:48]);

wire [49:0] x1;  //recursive doubling stage 1
assign x1[1:0]=x[1:0];

recursive_stage1 s00(x[1:0],x[3:2],x1[3:2]);
recursive_stage1 s01(x[3:2],x[5:4],x1[5:4]);
recursive_stage1 s02(x[5:4],x[7:6],x1[7:6]);
recursive_stage1 s03(x[7:6],x[9:8],x1[9:8]);
recursive_stage1 s04(x[9:8],x[11:10],x1[11:10]);
recursive_stage1 s05(x[11:10],x[13:12],x1[13:12]);
recursive_stage1 s06(x[13:12],x[15:14],x1[15:14]);
recursive_stage1 s07(x[15:14],x[17:16],x1[17:16]);
recursive_stage1 s08(x[17:16],x[19:18],x1[19:18]);
recursive_stage1 s09(x[19:18],x[21:20],x1[21:20]);
recursive_stage1 s10(x[21:20],x[23:22],x1[23:22]);
recursive_stage1 s11(x[23:22],x[25:24],x1[25:24]);
recursive_stage1 s12(x[25:24],x[27:26],x1[27:26]);
recursive_stage1 s13(x[27:26],x[29:28],x1[29:28]);
recursive_stage1 s14(x[29:28],x[31:30],x1[31:30]);
recursive_stage1 s15(x[31:30],x[33:32],x1[33:32]);
recursive_stage1 s16(x[33:32],x[35:34],x1[35:34]);
recursive_stage1 s17(x[35:34],x[37:36],x1[37:36]);
recursive_stage1 s18(x[37:36],x[39:38],x1[39:38]);
recursive_stage1 s19(x[39:38],x[41:40],x1[41:40]);
recursive_stage1 s20(x[41:40],x[43:42],x1[43:42]);
recursive_stage1 s21(x[43:42],x[45:44],x1[45:44]);
recursive_stage1 s22(x[45:44],x[47:46],x1[47:46]);
recursive_stage1 s23(x[47:46],x[49:48],x1[49:48]);

wire [49:0] x2;  //recursive doubling stage2
assign x2[3:0]=x1[3:0];

recursive_stage1 s101(x1[1:0],x1[5:4],x2[5:4]);
recursive_stage1 s102(x1[3:2],x1[7:6],x2[7:6]);
recursive_stage1 s103(x1[5:4],x1[9:8],x2[9:8]);
recursive_stage1 s104(x1[7:6],x1[11:10],x2[11:10]);
recursive_stage1 s105(x1[9:8],x1[13:12],x2[13:12]);
recursive_stage1 s106(x1[11:10],x1[15:14],x2[15:14]);
recursive_stage1 s107(x1[13:12],x1[17:16],x2[17:16]);
recursive_stage1 s108(x1[15:14],x1[19:18],x2[19:18]);
recursive_stage1 s109(x1[17:16],x1[21:20],x2[21:20]);
recursive_stage1 s110(x1[19:18],x1[23:22],x2[23:22]);
recursive_stage1 s111(x1[21:20],x1[25:24],x2[25:24]);
recursive_stage1 s112(x1[23:22],x1[27:26],x2[27:26]);
recursive_stage1 s113(x1[25:24],x1[29:28],x2[29:28]);
recursive_stage1 s114(x1[27:26],x1[31:30],x2[31:30]);
recursive_stage1 s115(x1[29:28],x1[33:32],x2[33:32]);
recursive_stage1 s116(x1[31:30],x1[35:34],x2[35:34]);
recursive_stage1 s117(x1[33:32],x1[37:36],x2[37:36]);
recursive_stage1 s118(x1[35:34],x1[39:38],x2[39:38]);
recursive_stage1 s119(x1[37:36],x1[41:40],x2[41:40]);
recursive_stage1 s120(x1[39:38],x1[43:42],x2[43:42]);
recursive_stage1 s121(x1[41:40],x1[45:44],x2[45:44]);
recursive_stage1 s122(x1[43:42],x1[47:46],x2[47:46]);
recursive_stage1 s123(x1[45:44],x1[49:48],x2[49:48]);

wire [49:0] x3;  //recursive doubling stage3
assign x3[7:0]=x2[7:0];

recursive_stage1 s203(x2[1:0],x2[9:8],x3[9:8]);
recursive_stage1 s204(x2[3:2],x2[11:10],x3[11:10]);
recursive_stage1 s205(x2[5:4],x2[13:12],x3[13:12]);
recursive_stage1 s206(x2[7:6],x2[15:14],x3[15:14]);
recursive_stage1 s207(x2[9:8],x2[17:16],x3[17:16]);
recursive_stage1 s208(x2[11:10],x2[19:18],x3[19:18]);
recursive_stage1 s209(x2[13:12],x2[21:20],x3[21:20]);
recursive_stage1 s210(x2[15:14],x2[23:22],x3[23:22]);
recursive_stage1 s211(x2[17:16],x2[25:24],x3[25:24]);
recursive_stage1 s212(x2[19:18],x2[27:26],x3[27:26]);
recursive_stage1 s213(x2[21:20],x2[29:28],x3[29:28]);
recursive_stage1 s214(x2[23:22],x2[31:30],x3[31:30]);
recursive_stage1 s215(x2[25:24],x2[33:32],x3[33:32]);
recursive_stage1 s216(x2[27:26],x2[35:34],x3[35:34]);
recursive_stage1 s217(x2[29:28],x2[37:36],x3[37:36]);
recursive_stage1 s218(x2[31:30],x2[39:38],x3[39:38]);
recursive_stage1 s219(x2[33:32],x2[41:40],x3[41:40]);
recursive_stage1 s220(x2[35:34],x2[43:42],x3[43:42]);
recursive_stage1 s221(x2[37:36],x2[45:44],x3[45:44]);
recursive_stage1 s222(x2[39:38],x2[47:46],x3[47:46]);
recursive_stage1 s223(x2[41:40],x2[49:48],x3[49:48]);

wire [49:0] x4;  //recursive doubling stage 4
assign x4[15:0]=x3[15:0];

recursive_stage1 s307(x3[1:0],x3[17:16],x4[17:16]);
recursive_stage1 s308(x3[3:2],x3[19:18],x4[19:18]);
recursive_stage1 s309(x3[5:4],x3[21:20],x4[21:20]);
recursive_stage1 s310(x3[7:6],x3[23:22],x4[23:22]);
recursive_stage1 s311(x3[9:8],x3[25:24],x4[25:24]);
recursive_stage1 s312(x3[11:10],x3[27:26],x4[27:26]);
recursive_stage1 s313(x3[13:12],x3[29:28],x4[29:28]);
recursive_stage1 s314(x3[15:14],x3[31:30],x4[31:30]);
recursive_stage1 s315(x3[17:16],x3[33:32],x4[33:32]);
recursive_stage1 s316(x3[19:18],x3[35:34],x4[35:34]);
recursive_stage1 s317(x3[21:20],x3[37:36],x4[37:36]);
recursive_stage1 s318(x3[23:22],x3[39:38],x4[39:38]);
recursive_stage1 s319(x3[25:24],x3[41:40],x4[41:40]);
recursive_stage1 s320(x3[27:26],x3[43:42],x4[43:42]);
recursive_stage1 s321(x3[29:28],x3[45:44],x4[45:44]);
recursive_stage1 s322(x3[31:30],x3[47:46],x4[47:46]);
recursive_stage1 s323(x3[33:32],x3[49:48],x4[49:48]);

wire [49:0] x5;  //recursive doubling stage 5
assign x5[31:0]=x4[31:0];

recursive_stage1 s415(x4[1:0],x4[33:32],x5[33:32]);
recursive_stage1 s416(x4[3:2],x4[35:34],x5[35:34]);
recursive_stage1 s417(x4[5:4],x4[37:36],x5[37:36]);
recursive_stage1 s418(x4[7:6],x4[39:38],x5[39:38]);
recursive_stage1 s419(x4[9:8],x4[41:40],x5[41:40]);
recursive_stage1 s420(x4[11:10],x4[43:42],x5[43:42]);
recursive_stage1 s421(x4[13:12],x4[45:44],x5[45:44]);
recursive_stage1 s422(x4[15:14],x4[47:46],x5[47:46]);
recursive_stage1 s423(x4[17:16],x4[49:48],x5[49:48]);

 // final sum and carry

assign sum[0]=a[0]^b[0]^x5[0];
assign sum[1]=a[1]^b[1]^x5[2];
assign sum[2]=a[2]^b[2]^x5[4];
assign sum[3]=a[3]^b[3]^x5[6];
assign sum[4]=a[4]^b[4]^x5[8];
assign sum[5]=a[5]^b[5]^x5[10];
assign sum[6]=a[6]^b[6]^x5[12];
assign sum[7]=a[7]^b[7]^x5[14];
assign sum[8]=a[8]^b[8]^x5[16];
assign sum[9]=a[9]^b[9]^x5[18];
assign sum[10]=a[10]^b[10]^x5[20];
assign sum[11]=a[11]^b[11]^x5[22];
assign sum[12]=a[12]^b[12]^x5[24];
assign sum[13]=a[13]^b[13]^x5[26];
assign sum[14]=a[14]^b[14]^x5[28];
assign sum[15]=a[15]^b[15]^x5[30];
assign sum[16]=a[16]^b[16]^x5[32];
assign sum[17]=a[17]^b[17]^x5[34];
assign sum[18]=a[18]^b[18]^x5[36];
assign sum[19]=a[19]^b[19]^x5[38];
assign sum[20]=a[20]^b[20]^x5[40];
assign sum[21]=a[21]^b[21]^x5[42];
assign sum[22]=a[22]^b[22]^x5[44];
assign sum[23]=a[23]^b[23]^x5[46];

kgp_carry kkc(x[49:48],x5[47:46],carry);

endmodule



//add shift network used for odd/even decomposed based integer DCT

//`include "kgp.v"
//`include "kgp_carry.v"
//`include "recursive_stage1.v"
//`include "recurse24.v"
//`include "mux2to1_25.v"

module add_shift_parallel(xs,ys,x,y,sel);

input xs,sel;
output ys;
input [23:0] x;
output [23:0] y;

wire [23:0] s1,s2,s3,s4;
wire c1,c2,c3,c4;

recurse24 r1(s1,c1,{6'b0,x[23:6]},{4'b0,x[23:4]}); 
recurse24 r2(s2,c2,{2'b0,x[23:2]},{1'b0,x[23:1]});
recurse24 r3(s3,c3,s1,s2);
recurse24 r4(s4,c4,s3,x);

mux2to1_25 m1({ys,y},{xs,s4},{(~xs),s4},sel);


endmodule


//odd_even decomposition based 1D DCT used for 2D parallel architecture

/*`include "adder40.v"
`include "kgp.v"
`include "kgp_carry.v"
`include "recursive_stage1.v"
`include "recurse24.v"
`include "add_shift_folded.v"
`include "mux2to1_41.v"*/

module odd_even_folded(

i0s,i1s,i2s,i3s,i4s,i5s,i6s,i7s,i8s,i9s,i10s,i11s,i12s,i13s,i14s,i15s,i16s,i17s,i18s,i19s,i20s,i21s,i22s,i23s,i24s,i25s,i26s,i27s,i28s,i29s,i30s,i31s,
i0,i1,i2,i3,i4,i5,i6,i7,i8,i9,i10,i11,i12,i13,i14,i15,i16,i17,i18,i19,i20,i21,i22,i23,i24,i25,i26,i27,i28,i29,i30,i31,
s,
ou0s,ou1s,ou2s,ou3s,ou4s,ou5s,ou6s,ou7s,ou8s,ou9s,ou10s,ou11s,ou12s,ou13s,ou14s,ou15s,ou16s,ou17s,ou18s,ou19s,ou20s,ou21s,ou22s,ou23s,ou24s,ou25s,ou26s,ou27s,ou28s,ou29s,ou30s,ou31s,
ou0,ou1,ou2,ou3,ou4,ou5,ou6,ou7,ou8,ou9,ou10,ou11,ou12,ou13,ou14,ou15,ou16,ou17,ou18,ou19,ou20,ou21,ou22,ou23,ou24,ou25,ou26,ou27,ou28,ou29,ou30,ou31

);

input i0s,i1s,i2s,i3s,i4s,i5s,i6s,i7s,i8s,i9s,i10s,i11s,i12s,i13s,i14s,i15s,i16s,i17s,i18s,i19s,i20s,i21s,i22s,i23s,i24s,i25s,i26s,i27s,i28s,i29s,i30s,i31s;
input [39:0] i0,i1,i2,i3,i4,i5,i6,i7,i8,i9,i10,i11,i12,i13,i14,i15,i16,i17,i18,i19,i20,i21,i22,i23,i24,i25,i26,i27,i28,i29,i30,i31;

input s;

output ou0s,ou1s,ou2s,ou3s,ou4s,ou5s,ou6s,ou7s,ou8s,ou9s,ou10s,ou11s,ou12s,ou13s,ou14s,ou15s,ou16s,ou17s,ou18s,ou19s,ou20s,ou21s,ou22s,ou23s,ou24s,ou25s,ou26s,ou27s,ou28s,ou29s,ou30s,ou31s;
output [39:0] ou0,ou1,ou2,ou3,ou4,ou5,ou6,ou7,ou8,ou9,ou10,ou11,ou12,ou13,ou14,ou15,ou16,ou17,ou18,ou19,ou20,ou21,ou22,ou23,ou24,ou25,ou26,ou27,ou28,ou29,ou30,ou31;

//stage1-adders

wire r0s,r1s,r2s,r3s,r4s,r5s,r6s,r7s,r8s,r9s,r10s,r11s,r12s,r13s,r14s,r15s;
wire [39:0] r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,r13,r14,r15;

wire rr0s,rr1s,rr2s,rr3s,rr4s,rr5s,rr6s,rr7s,rr8s,rr9s,rr10s,rr11s,rr12s,rr13s,rr14s,rr15s;
wire [39:0] rr0,rr1,rr2,rr3,rr4,rr5,rr6,rr7,rr8,rr9,rr10,rr11,rr12,rr13,rr14,rr15;

adder40 a0(i0s,i0,i31s,i31,r0s,r0);
adder40 a1(i1s,i1,i30s,i30,r1s,r1);
adder40 a2(i2s,i2,i29s,i29,r2s,r2);
adder40 a3(i3s,i3,i28s,i28,r3s,r3);
adder40 a4(i4s,i4,i27s,i27,r4s,r4);
adder40 a5(i5s,i5,i26s,i26,r5s,r5);
adder40 a6(i6s,i6,i25s,i25,r6s,r6);
adder40 a7(i7s,i7,i24s,i24,r7s,r7);
adder40 a8(i8s,i8,i23s,i23,r8s,r8);
adder40 a9(i9s,i9,i22s,i22,r9s,r9);
adder40 a10(i10s,i10,i21s,i21,r10s,r10);
adder40 a11(i11s,i11,i20s,i20,r11s,r11);
adder40 a12(i12s,i12,i19s,i19,r12s,r12);
adder40 a13(i13s,i13,i18s,i18,r13s,r13);
adder40 a14(i14s,i14,i17s,i17,r14s,r14);
adder40 a15(i15s,i15,i16s,i16,r15s,r15);

adder40 aa0(i0s,i0,(~i31s),i31,rr0s,rr0);
adder40 aa1(i1s,i1,(~i30s),i30,rr1s,rr1);
adder40 aa2(i2s,i2,(~i29s),i29,rr2s,rr2);
adder40 aa3(i3s,i3,(~i28s),i28,rr3s,rr3);
adder40 aa4(i4s,i4,(~i27s),i27,rr4s,rr4);
adder40 aa5(i5s,i5,(~i26s),i26,rr5s,rr5);
adder40 aa6(i6s,i6,(~i25s),i25,rr6s,rr6);
adder40 aa7(i7s,i7,(~i24s),i24,rr7s,rr7);
adder40 aa8(i8s,i8,(~i23s),i23,rr8s,rr8);
adder40 aa9(i9s,i9,(~i22s),i22,rr9s,rr9);
adder40 aa10(i10s,i10,(~i21s),i21,rr10s,rr10);
adder40 aa11(i11s,i11,(~i20s),i20,rr11s,rr11);
adder40 aa12(i12s,i12,(~i19s),i19,rr12s,rr12);
adder40 aa13(i13s,i13,(~i18s),i18,rr13s,rr13);
adder40 aa14(i14s,i14,(~i17s),i17,rr14s,rr14);
adder40 aa15(i15s,i15,(~i16s),i16,rr15s,rr15);

//stage2-add-shift n/w

wire z0s,z1s,z2s,z3s,z4s,z5s,z6s,z7s,z8s,z9s,z10s,z11s,z12s,z13s,z14s,z15s;
wire [39:0] z0,z1,z2,z3,z4,z5,z6,z7,z8,z9,z10,z11,z12,z13,z14,z15;

wire zz0s,zz1s,zz2s,zz3s,zz4s,zz5s,zz6s,zz7s,zz8s,zz9s,zz10s,zz11s,zz12s,zz13s,zz14s,zz15s;
wire [39:0] zz0,zz1,zz2,zz3,zz4,zz5,zz6,zz7,zz8,zz9,zz10,zz11,zz12,zz13,zz14,zz15;

add_shift_folded sds0(r0s,z0s,r0,z0,s);
add_shift_folded sds1(r1s,z1s,r1,z1,s);
add_shift_folded sds2(r2s,z2s,r2,z2,s);
add_shift_folded sds3(r3s,z3s,r3,z3,s);
add_shift_folded sds4(r4s,z4s,r4,z4,s);
add_shift_folded sds5(r5s,z5s,r5,z5,s);
add_shift_folded sds6(r6s,z6s,r6,z6,s);
add_shift_folded sds7(r7s,z7s,r7,z7,s);
add_shift_folded sds8(r8s,z8s,r8,z8,s);
add_shift_folded sds9(r9s,z9s,r9,z9,s);
add_shift_folded sds10(r10s,z10s,r10,z10,s);
add_shift_folded sds11(r11s,z11s,r11,z11,s);
add_shift_folded sds12(r12s,z12s,r12,z12,s);
add_shift_folded sds13(r13s,z13s,r13,z13,s);
add_shift_folded sds14(r14s,z14s,r14,z14,s);
add_shift_folded sds15(r15s,z15s,r15,z15,s);

add_shift_folded ss0(rr0s,zz0s,rr0,zz0,s);
add_shift_folded ss1(rr1s,zz1s,rr1,zz1,s);
add_shift_folded ss2(rr2s,zz2s,rr2,zz2,s);
add_shift_folded ss3(rr3s,zz3s,rr3,zz3,s);
add_shift_folded ss4(rr4s,zz4s,rr4,zz4,s);
add_shift_folded ss5(rr5s,zz5s,rr5,zz5,s);
add_shift_folded ss6(rr6s,zz6s,rr6,zz6,s);
add_shift_folded ss7(rr7s,zz7s,rr7,zz7,s);
add_shift_folded ss8(rr8s,zz8s,rr8,zz8,s);
add_shift_folded ss9(rr9s,zz9s,rr9,zz9,s);
add_shift_folded ss10(rr10s,zz10s,rr10,zz10,s);
add_shift_folded ss11(rr11s,zz11s,rr11,zz11,s);
add_shift_folded ss12(rr12s,zz12s,rr12,zz12,s);
add_shift_folded ss13(rr13s,zz13s,rr13,zz13,s);
add_shift_folded ss14(rr14s,zz14s,rr14,zz14,s);
add_shift_folded ss15(rr15s,zz15s,rr15,zz15,s);

//stage3-output adder tree (4 levels of adders)

//first level

wire 
i0_0s,i0_1s,i0_2s,i0_3s,i0_4s,i0_5s,i0_6s,i0_7s,i0_8s,i0_9s,
i0_10s,i0_11s,i0_12s,i0_13s,i0_14s,i0_15s,i0_16s,i0_17s,i0_18s,i0_19s,
i0_20s,i0_21s,i0_22s,i0_23s,i0_24s,i0_25s,i0_26s,i0_27s,i0_28s,i0_29s,
i0_30s,i0_31s,i0_32s,i0_33s,i0_34s,i0_35s,i0_36s,i0_37s,i0_38s,i0_39s,
i0_40s,i0_41s,i0_42s,i0_43s,i0_44s,i0_45s,i0_46s,i0_47s,i0_48s,i0_49s,
i0_50s,i0_51s,i0_52s,i0_53s,i0_54s,i0_55s,i0_56s,i0_57s,i0_58s,i0_59s,
i0_60s,i0_61s,i0_62s,i0_63s,i0_64s,i0_65s,i0_66s,i0_67s,i0_68s,i0_69s,
i0_70s,i0_71s,i0_72s,i0_73s,i0_74s,i0_75s,i0_76s,i0_77s,i0_78s,i0_79s,
i0_80s,i0_81s,i0_82s,i0_83s,i0_84s,i0_85s,i0_86s,i0_87s,i0_88s,i0_89s,
i0_90s,i0_91s,i0_92s,i0_93s,i0_94s,i0_95s,i0_96s,i0_97s,i0_98s,i0_99s,
i0_100s,i0_101s,i0_102s,i0_103s,i0_104s,i0_105s,i0_106s,i0_107s,i0_108s,i0_109s,
i0_110s,i0_111s,i0_112s,i0_113s,i0_114s,i0_115s,i0_116s,i0_117s,i0_118s,i0_119s,
i0_120s,i0_121s,i0_122s,i0_123s,i0_124s,i0_125s,i0_126s,i0_127s,i0_128s,i0_129s,
i0_130s,i0_131s,i0_132s,i0_133s,i0_134s,i0_135s,i0_136s,i0_137s,i0_138s,i0_139s,
i0_140s,i0_141s,i0_142s,i0_143s,i0_144s,i0_145s,i0_146s,i0_147s,i0_148s,i0_149s,
i0_150s,i0_151s,i0_152s,i0_153s,i0_154s,i0_155s,i0_156s,i0_157s,i0_158s,i0_159s,
i0_160s,i0_161s,i0_162s,i0_163s,i0_164s,i0_165s,i0_166s,i0_167s,i0_168s,i0_169s,
i0_170s,i0_171s,i0_172s,i0_173s,i0_174s,i0_175s,i0_176s,i0_177s,i0_178s,i0_179s,
i0_180s,i0_181s,i0_182s,i0_183s,i0_184s,i0_185s,i0_186s,i0_187s,i0_188s,i0_189s,
i0_190s,i0_191s,i0_192s,i0_193s,i0_194s,i0_195s,i0_196s,i0_197s,i0_198s,i0_199s,
i0_200s,i0_201s,i0_202s,i0_203s,i0_204s,i0_205s,i0_206s,i0_207s,i0_208s,i0_209s,
i0_210s,i0_211s,i0_212s,i0_213s,i0_214s,i0_215s,i0_216s,i0_217s,i0_218s,i0_219s,
i0_220s,i0_221s,i0_222s,i0_223s,i0_224s,i0_225s,i0_226s,i0_227s,i0_228s,i0_229s,
i0_230s,i0_231s,i0_232s,i0_233s,i0_234s,i0_235s,i0_236s,i0_237s,i0_238s,i0_239s,
i0_240s,i0_241s,i0_242s,i0_243s,i0_244s,i0_245s,i0_246s,i0_247s,i0_248s,i0_249s,
i0_250s,i0_251s,i0_252s,i0_253s,i0_254s,i0_255s;

wire [39:0] 
i0_0,i0_1,i0_2,i0_3,i0_4,i0_5,i0_6,i0_7,i0_8,i0_9,
i0_10,i0_11,i0_12,i0_13,i0_14,i0_15,i0_16,i0_17,i0_18,i0_19,
i0_20,i0_21,i0_22,i0_23,i0_24,i0_25,i0_26,i0_27,i0_28,i0_29,
i0_30,i0_31,i0_32,i0_33,i0_34,i0_35,i0_36,i0_37,i0_38,i0_39,
i0_40,i0_41,i0_42,i0_43,i0_44,i0_45,i0_46,i0_47,i0_48,i0_49,
i0_50,i0_51,i0_52,i0_53,i0_54,i0_55,i0_56,i0_57,i0_58,i0_59,
i0_60,i0_61,i0_62,i0_63,i0_64,i0_65,i0_66,i0_67,i0_68,i0_69,
i0_70,i0_71,i0_72,i0_73,i0_74,i0_75,i0_76,i0_77,i0_78,i0_79,
i0_80,i0_81,i0_82,i0_83,i0_84,i0_85,i0_86,i0_87,i0_88,i0_89,
i0_90,i0_91,i0_92,i0_93,i0_94,i0_95,i0_96,i0_97,i0_98,i0_99,
i0_100,i0_101,i0_102,i0_103,i0_104,i0_105,i0_106,i0_107,i0_108,i0_109,
i0_110,i0_111,i0_112,i0_113,i0_114,i0_115,i0_116,i0_117,i0_118,i0_119,
i0_120,i0_121,i0_122,i0_123,i0_124,i0_125,i0_126,i0_127,i0_128,i0_129,
i0_130,i0_131,i0_132,i0_133,i0_134,i0_135,i0_136,i0_137,i0_138,i0_139,
i0_140,i0_141,i0_142,i0_143,i0_144,i0_145,i0_146,i0_147,i0_148,i0_149,
i0_150,i0_151,i0_152,i0_153,i0_154,i0_155,i0_156,i0_157,i0_158,i0_159,
i0_160,i0_161,i0_162,i0_163,i0_164,i0_165,i0_166,i0_167,i0_168,i0_169,
i0_170,i0_171,i0_172,i0_173,i0_174,i0_175,i0_176,i0_177,i0_178,i0_179,
i0_180,i0_181,i0_182,i0_183,i0_184,i0_185,i0_186,i0_187,i0_188,i0_189,
i0_190,i0_191,i0_192,i0_193,i0_194,i0_195,i0_196,i0_197,i0_198,i0_199,
i0_200,i0_201,i0_202,i0_203,i0_204,i0_205,i0_206,i0_207,i0_208,i0_209,
i0_210,i0_211,i0_212,i0_213,i0_214,i0_215,i0_216,i0_217,i0_218,i0_219,
i0_220,i0_221,i0_222,i0_223,i0_224,i0_225,i0_226,i0_227,i0_228,i0_229,
i0_230,i0_231,i0_232,i0_233,i0_234,i0_235,i0_236,i0_237,i0_238,i0_239,
i0_240,i0_241,i0_242,i0_243,i0_244,i0_245,i0_246,i0_247,i0_248,i0_249,
i0_250,i0_251,i0_252,i0_253,i0_254,i0_255;

adder40 s1_0(z0s,z0,z1s,z1,i0_0s,i0_0);
adder40 s1_1(z2s,z2,z3s,z3,i0_1s,i0_1);
adder40 s1_2(z4s,z4,z5s,z5,i0_2s,i0_2);
adder40 s1_3(z6s,z6,z7s,z7,i0_3s,i0_3);
adder40 s1_4(z8s,z8,z9s,z9,i0_4s,i0_4);
adder40 s1_5(z10s,z10,z11s,z11,i0_5s,i0_5);
adder40 s1_6(z12s,z12,z13s,z13,i0_6s,i0_6);
adder40 s1_7(z14s,z14,z15s,z15,i0_7s,i0_7);
adder40 s1_8(z10s,z10,z10s,z11,i0_8s,i0_8);
adder40 s1_9(z10s,z10,z10s,z11,i0_9s,i0_9);
adder40 s1_10(z2s,z2,z2s,z2,i0_10s,i0_10);
adder40 s1_11(z2s,z2,z2s,z2,i0_11s,i0_11);
adder40 s1_12(z2s,z2,z2s,z2,i0_12s,i0_12);
adder40 s1_13(z2s,z2,z2s,z2,i0_13s,i0_13);
adder40 s1_14(z2s,z2,z2s,z2,i0_14s,i0_14);
adder40 s1_15(z3s,z3,z3s,z3,i0_15s,i0_15);
adder40 s1_16(z3s,z3,z3s,z3,i0_16s,i0_16);
adder40 s1_17(z3s,z3,z3s,z3,i0_17s,i0_17);
adder40 s1_18(z3s,z3,z3s,z3,i0_18s,i0_18);
adder40 s1_19(z3s,z3,z3s,z3,i0_19s,i0_19);
adder40 s1_20(z4s,z4,z4s,z4,i0_20s,i0_20);
adder40 s1_21(z4s,z4,z4s,z4,i0_21s,i0_21);
adder40 s1_22(z4s,z4,z4s,z4,i0_22s,i0_22);
adder40 s1_23(z4s,z4,z4s,z4,i0_23s,i0_23);
adder40 s1_24(z4s,z4,z4s,z4,i0_24s,i0_24);
adder40 s1_25(z5s,z5,z5s,z5,i0_25s,i0_25);
adder40 s1_26(z5s,z5,z5s,z5,i0_26s,i0_26);
adder40 s1_27(z5s,z5,z5s,z5,i0_27s,i0_27);
adder40 s1_28(z5s,z5,z5s,z5,i0_28s,i0_28);
adder40 s1_29(z5s,z5,z5s,z5,i0_29s,i0_29);
adder40 s1_30(z6s,z6,z6s,z6,i0_30s,i0_30);
adder40 s1_31(z6s,z6,z6s,z6,i0_31s,i0_31);
adder40 s1_32(z6s,z6,z6s,z6,i0_32s,i0_32);
adder40 s1_33(z6s,z6,z6s,z6,i0_33s,i0_33);
adder40 s1_34(z6s,z6,z6s,z6,i0_34s,i0_34);
adder40 s1_35(z7s,z7,z7s,z7,i0_35s,i0_35);
adder40 s1_36(z7s,z7,z7s,z7,i0_36s,i0_36);
adder40 s1_37(z7s,z7,z7s,z7,i0_37s,i0_37);
adder40 s1_38(z7s,z7,z7s,z7,i0_38s,i0_38);
adder40 s1_39(z7s,z7,z7s,z7,i0_39s,i0_39);
adder40 s1_40(z8s,z8,z8s,z8,i0_40s,i0_40);
adder40 s1_41(z8s,z8,z8s,z8,i0_41s,i0_41);
adder40 s1_42(z8s,z8,z8s,z8,i0_42s,i0_42);
adder40 s1_43(z8s,z8,z8s,z8,i0_43s,i0_43);
adder40 s1_44(z8s,z8,z8s,z8,i0_44s,i0_44);
adder40 s1_45(z9s,z9,z9s,z9,i0_45s,i0_45);
adder40 s1_46(z9s,z9,z9s,z9,i0_46s,i0_46);
adder40 s1_47(z9s,z9,z9s,z9,i0_47s,i0_47);
adder40 s1_48(z9s,z9,z9s,z9,i0_48s,i0_48);
adder40 s1_49(z9s,z9,z9s,z9,i0_49s,i0_49);
adder40 s1_50(z1s,z1,z1s,z1,i0_50s,i0_50);
adder40 s1_51(z1s,z1,z1s,z1,i0_51s,i0_51);
adder40 s1_52(z1s,z1,z1s,z1,i0_52s,i0_52);
adder40 s1_53(z1s,z1,z1s,z1,i0_53s,i0_53);
adder40 s1_54(z1s,z1,z1s,z1,i0_54s,i0_54);
adder40 s1_55(z1s,z1,z1s,z1,i0_55s,i0_55);
adder40 s1_56(z1s,z1,z1s,z1,i0_56s,i0_56);
adder40 s1_57(z1s,z1,z1s,z1,i0_57s,i0_57);
adder40 s1_58(z1s,z1,z1s,z1,i0_58s,i0_58);
adder40 s1_59(z1s,z1,z1s,z1,i0_59s,i0_59);
adder40 s1_60(z1s,z1,z1s,z1,i0_60s,i0_60);
adder40 s1_61(z1s,z1,z1s,z1,i0_61s,i0_61);
adder40 s1_62(z1s,z1,z1s,z1,i0_62s,i0_62);
adder40 s1_63(z1s,z1,z1s,z1,i0_63s,i0_63);
adder40 s1_64(z1s,z1,z1s,z1,i0_64s,i0_64);
adder40 s1_65(z1s,z1,z1s,z1,i0_65s,i0_65);
adder40 s1_66(z1s,z1,z1s,z1,i0_66s,i0_66);
adder40 s1_67(z1s,z1,z1s,z1,i0_67s,i0_67);
adder40 s1_68(z1s,z1,z1s,z1,i0_68s,i0_68);
adder40 s1_69(z1s,z1,z1s,z1,i0_69s,i0_69);
adder40 s1_70(z1s,z1,z1s,z1,i0_70s,i0_70);
adder40 s1_71(z1s,z1,z1s,z1,i0_71s,i0_71);
adder40 s1_72(z1s,z1,z1s,z1,i0_72s,i0_72);
adder40 s1_73(z1s,z1,z1s,z1,i0_73s,i0_73);
adder40 s1_74(z1s,z1,z1s,z1,i0_74s,i0_74);
adder40 s1_75(z1s,z1,z1s,z1,i0_75s,i0_75);
adder40 s1_76(z1s,z1,z1s,z1,i0_76s,i0_76);
adder40 s1_77(z1s,z1,z1s,z1,i0_77s,i0_77);
adder40 s1_78(z1s,z1,z1s,z1,i0_78s,i0_78);
adder40 s1_79(z1s,z1,z1s,z1,i0_79s,i0_79);
adder40 s1_80(z1s,z1,z1s,z1,i0_80s,i0_80);
adder40 s1_81(z1s,z1,z1s,z1,i0_81s,i0_81);
adder40 s1_82(z1s,z1,z1s,z1,i0_82s,i0_82);
adder40 s1_83(z1s,z1,z1s,z1,i0_83s,i0_83);
adder40 s1_84(z1s,z1,z1s,z1,i0_84s,i0_84);
adder40 s1_85(z1s,z1,z1s,z1,i0_85s,i0_85);
adder40 s1_86(z1s,z1,z1s,z1,i0_86s,i0_86);
adder40 s1_87(z1s,z1,z1s,z1,i0_87s,i0_87);
adder40 s1_88(z1s,z1,z1s,z1,i0_88s,i0_88);
adder40 s1_89(z1s,z1,z1s,z1,i0_89s,i0_89);
adder40 s1_90(z1s,z1,z1s,z1,i0_90s,i0_90);
adder40 s1_91(z1s,z1,z1s,z1,i0_91s,i0_91);
adder40 s1_92(z1s,z1,z1s,z1,i0_92s,i0_92);
adder40 s1_93(z1s,z1,z1s,z1,i0_93s,i0_93);
adder40 s1_94(z1s,z1,z1s,z1,i0_94s,i0_94);
adder40 s1_95(z1s,z1,z1s,z1,i0_95s,i0_95);
adder40 s1_96(z1s,z1,z1s,z1,i0_96s,i0_96);
adder40 s1_97(z1s,z1,z1s,z1,i0_97s,i0_97);
adder40 s1_98(z1s,z1,z1s,z1,i0_98s,i0_98);
adder40 s1_99(z1s,z1,z1s,z1,i0_99s,i0_99);
adder40 s1_100(z2s,z2,z2s,z2,i0_100s,i0_100);
adder40 s1_101(z2s,z2,z2s,z2,i0_101s,i0_101);
adder40 s1_102(z2s,z2,z2s,z2,i0_102s,i0_102);
adder40 s1_103(z2s,z2,z2s,z2,i0_103s,i0_103);
adder40 s1_104(z2s,z2,z2s,z2,i0_104s,i0_104);
adder40 s1_105(z2s,z2,z2s,z2,i0_105s,i0_105);
adder40 s1_106(z2s,z2,z2s,z2,i0_106s,i0_106);
adder40 s1_107(z2s,z2,z2s,z2,i0_107s,i0_107);
adder40 s1_108(z2s,z2,z2s,z2,i0_108s,i0_108);
adder40 s1_109(z2s,z2,z2s,z2,i0_109s,i0_109);
adder40 s1_110(z2s,z2,z2s,z2,i0_110s,i0_110);
adder40 s1_111(z2s,z2,z2s,z2,i0_111s,i0_111);
adder40 s1_112(z2s,z2,z2s,z2,i0_112s,i0_112);
adder40 s1_113(z2s,z2,z2s,z2,i0_113s,i0_113);
adder40 s1_114(z2s,z2,z2s,z2,i0_114s,i0_114);
adder40 s1_115(z2s,z2,z2s,z2,i0_115s,i0_115);
adder40 s1_116(z2s,z2,z2s,z2,i0_116s,i0_116);
adder40 s1_117(z2s,z2,z2s,z2,i0_117s,i0_117);
adder40 s1_118(z2s,z2,z2s,z2,i0_118s,i0_118);
adder40 s1_119(z2s,z2,z2s,z2,i0_119s,i0_119);
adder40 s1_120(z2s,z2,z2s,z2,i0_120s,i0_120);
adder40 s1_121(z2s,z2,z2s,z2,i0_121s,i0_121);
adder40 s1_122(z2s,z2,z2s,z2,i0_122s,i0_122);
adder40 s1_123(z2s,z2,z2s,z2,i0_123s,i0_123);
adder40 s1_124(z2s,z2,z2s,z2,i0_124s,i0_124);
adder40 s1_125(z2s,z2,z2s,z2,i0_125s,i0_125);
adder40 s1_126(z2s,z2,z2s,z2,i0_126s,i0_126);
adder40 s1_127(z2s,z2,z2s,z2,i0_127s,i0_127);

adder40 s1_128(zz5s,zz5,zz5s,zz5,i0_128s,i0_128);
adder40 s1_129(zz5s,zz5,zz5s,zz5,i0_129s,i0_129);
adder40 s1_130(zz6s,zz6,zz6s,zz6,i0_130s,i0_130);
adder40 s1_131(zz6s,zz6,zz6s,zz6,i0_131s,i0_131);
adder40 s1_132(zz6s,zz6,zz6s,zz6,i0_132s,i0_132);
adder40 s1_133(zz6s,zz6,zz6s,zz6,i0_133s,i0_133);
adder40 s1_134(zz6s,zz6,zz6s,zz6,i0_134s,i0_134);
adder40 s1_135(zz7s,zz7,zz7s,zz7,i0_135s,i0_135);
adder40 s1_136(zz7s,zz7,zz7s,zz7,i0_136s,i0_136);
adder40 s1_137(zz7s,zz7,zz7s,zz7,i0_137s,i0_137);
adder40 s1_138(zz7s,zz7,zz7s,zz7,i0_138s,i0_138);
adder40 s1_139(zz7s,zz7,zz7s,zz7,i0_139s,i0_139);
adder40 s1_140(zz8s,zz8,zz8s,zz8,i0_140s,i0_140);
adder40 s1_141(zz8s,zz8,zz8s,zz8,i0_141s,i0_141);
adder40 s1_142(zz8s,zz8,zz8s,zz8,i0_142s,i0_142);
adder40 s1_143(zz8s,zz8,zz8s,zz8,i0_143s,i0_143);
adder40 s1_144(zz8s,zz8,zz8s,zz8,i0_144s,i0_144);
adder40 s1_145(zz9s,zz9,zz9s,zz9,i0_145s,i0_145);
adder40 s1_146(zz9s,zz9,zz9s,zz9,i0_146s,i0_146);
adder40 s1_147(zz9s,zz9,zz9s,zz9,i0_147s,i0_147);
adder40 s1_148(zz9s,zz9,zz9s,zz9,i0_148s,i0_148);
adder40 s1_149(zz9s,zz9,zz9s,zz9,i0_149s,i0_149);
adder40 s1_150(zz1s,zz1,zz1s,zz1,i0_150s,i0_150);
adder40 s1_151(zz1s,zz1,zz1s,zz1,i0_151s,i0_151);
adder40 s1_152(zz1s,zz1,zz1s,zz1,i0_152s,i0_152);
adder40 s1_153(zz1s,zz1,zz1s,zz1,i0_153s,i0_153);
adder40 s1_154(zz1s,zz1,zz1s,zz1,i0_154s,i0_154);
adder40 s1_155(zz1s,zz1,zz1s,zz1,i0_155s,i0_155);
adder40 s1_156(zz1s,zz1,zz1s,zz1,i0_156s,i0_156);
adder40 s1_157(zz1s,zz1,zz1s,zz1,i0_157s,i0_157);
adder40 s1_158(zz1s,zz1,zz1s,zz1,i0_158s,i0_158);
adder40 s1_159(zz1s,zz1,zz1s,zz1,i0_159s,i0_159);
adder40 s1_160(zz1s,zz1,zz1s,zz1,i0_160s,i0_160);
adder40 s1_161(zz1s,zz1,zz1s,zz1,i0_161s,i0_161);
adder40 s1_162(zz1s,zz1,zz1s,zz1,i0_162s,i0_162);
adder40 s1_163(zz1s,zz1,zz1s,zz1,i0_163s,i0_163);
adder40 s1_164(zz1s,zz1,zz1s,zz1,i0_164s,i0_164);
adder40 s1_165(zz1s,zz1,zz1s,zz1,i0_165s,i0_165);
adder40 s1_166(zz1s,zz1,zz1s,zz1,i0_166s,i0_166);
adder40 s1_167(zz1s,zz1,zz1s,zz1,i0_167s,i0_167);
adder40 s1_168(zz1s,zz1,zz1s,zz1,i0_168s,i0_168);
adder40 s1_169(zz1s,zz1,zz1s,zz1,i0_169s,i0_169);
adder40 s1_170(zz1s,zz1,zz1s,zz1,i0_170s,i0_170);
adder40 s1_171(zz1s,zz1,zz1s,zz1,i0_171s,i0_171);
adder40 s1_172(zz1s,zz1,zz1s,zz1,i0_172s,i0_172);
adder40 s1_173(zz1s,zz1,zz1s,zz1,i0_173s,i0_173);
adder40 s1_174(zz1s,zz1,zz1s,zz1,i0_174s,i0_174);
adder40 s1_175(zz1s,zz1,zz1s,zz1,i0_175s,i0_175);
adder40 s1_176(zz1s,zz1,zz1s,zz1,i0_176s,i0_176);
adder40 s1_177(zz1s,zz1,zz1s,zz1,i0_177s,i0_177);
adder40 s1_178(zz1s,zz1,zz1s,zz1,i0_178s,i0_178);
adder40 s1_179(zz1s,zz1,zz1s,zz1,i0_179s,i0_179);
adder40 s1_180(zz1s,zz1,zz1s,zz1,i0_180s,i0_180);
adder40 s1_181(zz1s,zz1,zz1s,zz1,i0_181s,i0_181);
adder40 s1_182(zz1s,zz1,zz1s,zz1,i0_182s,i0_182);
adder40 s1_183(zz1s,zz1,zz1s,zz1,i0_183s,i0_183);
adder40 s1_184(zz1s,zz1,zz1s,zz1,i0_184s,i0_184);
adder40 s1_185(zz1s,zz1,zz1s,zz1,i0_185s,i0_185);
adder40 s1_186(zz1s,zz1,zz1s,zz1,i0_186s,i0_186);
adder40 s1_187(zz1s,zz1,zz1s,zz1,i0_187s,i0_187);
adder40 s1_188(zz1s,zz1,zz1s,zz1,i0_188s,i0_188);
adder40 s1_189(zz1s,zz1,zz1s,zz1,i0_189s,i0_189);
adder40 s1_190(zz1s,zz1,zz1s,zz1,i0_190s,i0_190);
adder40 s1_191(zz1s,zz1,zz1s,zz1,i0_191s,i0_191);
adder40 s1_192(zz1s,zz1,zz1s,zz1,i0_192s,i0_192);
adder40 s1_193(zz1s,zz1,zz1s,zz1,i0_193s,i0_193);
adder40 s1_194(zz1s,zz1,zz1s,zz1,i0_194s,i0_194);
adder40 s1_195(zz1s,zz1,zz1s,zz1,i0_195s,i0_195);
adder40 s1_196(zz1s,zz1,zz1s,zz1,i0_196s,i0_196);
adder40 s1_197(zz1s,zz1,zz1s,zz1,i0_197s,i0_197);
adder40 s1_198(zz1s,zz1,zz1s,zz1,i0_198s,i0_198);
adder40 s1_199(zz1s,zz1,zz1s,zz1,i0_199s,i0_199);
adder40 s1_200(zz2s,zz2,zz2s,zz2,i0_200s,i0_200);
adder40 s1_201(zz2s,zz2,zz2s,zz2,i0_201s,i0_201);
adder40 s1_202(zz2s,zz2,zz2s,zz2,i0_202s,i0_202);
adder40 s1_203(zz2s,zz2,zz2s,zz2,i0_203s,i0_203);
adder40 s1_204(zz2s,zz2,zz2s,zz2,i0_204s,i0_204);
adder40 s1_205(zz2s,zz2,zz2s,zz2,i0_205s,i0_205);
adder40 s1_206(zz2s,zz2,zz2s,zz2,i0_206s,i0_206);
adder40 s1_207(zz2s,zz2,zz2s,zz2,i0_207s,i0_207);
adder40 s1_208(zz2s,zz2,zz2s,zz2,i0_208s,i0_208);
adder40 s1_209(zz2s,zz2,zz2s,zz2,i0_209s,i0_209);
adder40 s1_210(zz2s,zz2,zz2s,zz2,i0_210s,i0_210);
adder40 s1_211(zz2s,zz2,zz2s,zz2,i0_211s,i0_211);
adder40 s1_212(zz2s,zz2,zz2s,zz2,i0_212s,i0_212);
adder40 s1_213(zz2s,zz2,zz2s,zz2,i0_213s,i0_213);
adder40 s1_214(zz2s,zz2,zz2s,zz2,i0_214s,i0_214);
adder40 s1_215(zz2s,zz2,zz2s,zz2,i0_215s,i0_215);
adder40 s1_216(zz2s,zz2,zz2s,zz2,i0_216s,i0_216);
adder40 s1_217(zz2s,zz2,zz2s,zz2,i0_217s,i0_217);
adder40 s1_218(zz2s,zz2,zz2s,zz2,i0_218s,i0_218);
adder40 s1_219(zz2s,zz2,zz2s,zz2,i0_219s,i0_219);
adder40 s1_220(zz2s,zz2,zz2s,zz2,i0_220s,i0_220);
adder40 s1_221(zz2s,zz2,zz2s,zz2,i0_221s,i0_221);
adder40 s1_222(zz2s,zz2,zz2s,zz2,i0_222s,i0_222);
adder40 s1_223(zz2s,zz2,zz2s,zz2,i0_223s,i0_223);
adder40 s1_224(zz2s,zz2,zz2s,zz2,i0_224s,i0_224);
adder40 s1_225(zz2s,zz2,zz2s,zz2,i0_225s,i0_225);
adder40 s1_226(zz2s,zz2,zz2s,zz2,i0_226s,i0_226);
adder40 s1_227(zz2s,zz2,zz2s,zz2,i0_227s,i0_227);
adder40 s1_228(zz5s,zz5,zz5s,zz5,i0_228s,i0_228);
adder40 s1_229(zz5s,zz5,zz5s,zz5,i0_229s,i0_229);
adder40 s1_230(zz6s,zz6,zz6s,zz6,i0_230s,i0_230);
adder40 s1_231(zz6s,zz6,zz6s,zz6,i0_231s,i0_231);
adder40 s1_232(zz6s,zz6,zz6s,zz6,i0_232s,i0_232);
adder40 s1_233(zz6s,zz6,zz6s,zz6,i0_233s,i0_233);
adder40 s1_234(zz6s,zz6,zz6s,zz6,i0_234s,i0_234);
adder40 s1_235(zz7s,zz7,zz7s,zz7,i0_235s,i0_235);
adder40 s1_236(zz7s,zz7,zz7s,zz7,i0_236s,i0_236);
adder40 s1_237(zz7s,zz7,zz7s,zz7,i0_237s,i0_237);
adder40 s1_238(zz7s,zz7,zz7s,zz7,i0_238s,i0_238);
adder40 s1_239(zz7s,zz7,zz7s,zz7,i0_239s,i0_239);
adder40 s1_240(zz8s,zz8,zz8s,zz8,i0_240s,i0_240);
adder40 s1_241(zz8s,zz8,zz8s,zz8,i0_241s,i0_241);
adder40 s1_242(zz8s,zz8,zz8s,zz8,i0_242s,i0_242);
adder40 s1_243(zz8s,zz8,zz8s,zz8,i0_243s,i0_243);
adder40 s1_244(zz8s,zz8,zz8s,zz8,i0_244s,i0_244);
adder40 s1_245(zz9s,zz9,zz9s,zz9,i0_245s,i0_245);
adder40 s1_246(zz9s,zz9,zz9s,zz9,i0_246s,i0_246);
adder40 s1_247(zz9s,zz9,zz9s,zz9,i0_247s,i0_247);
adder40 s1_248(zz9s,zz9,zz9s,zz9,i0_248s,i0_248);
adder40 s1_249(zz9s,zz9,zz9s,zz9,i0_249s,i0_249);
adder40 s1_250(zz1s,zz1,zz1s,zz1,i0_250s,i0_250);
adder40 s1_251(zz1s,zz1,zz1s,zz1,i0_251s,i0_251);
adder40 s1_252(zz1s,zz1,zz1s,zz1,i0_252s,i0_252);
adder40 s1_253(zz1s,zz1,zz1s,zz1,i0_253s,i0_253);
adder40 s1_254(zz1s,zz1,zz1s,zz1,i0_254s,i0_254);
adder40 s1_255(zz1s,zz1,zz1s,zz1,i0_255s,i0_255);

//second level

wire 
i1_0s,i1_1s,i1_2s,i1_3s,i1_4s,i1_5s,i1_6s,i1_7s,i1_8s,i1_9s,
i1_10s,i1_11s,i1_12s,i1_13s,i1_14s,i1_15s,i1_16s,i1_17s,i1_18s,i1_19s,
i1_20s,i1_21s,i1_22s,i1_23s,i1_24s,i1_25s,i1_26s,i1_27s,i1_28s,i1_29s,
i1_30s,i1_31s,i1_32s,i1_33s,i1_34s,i1_35s,i1_36s,i1_37s,i1_38s,i1_39s,
i1_40s,i1_41s,i1_42s,i1_43s,i1_44s,i1_45s,i1_46s,i1_47s,i1_48s,i1_49s,
i1_50s,i1_51s,i1_52s,i1_53s,i1_54s,i1_55s,i1_56s,i1_57s,i1_58s,i1_59s,
i1_60s,i1_61s,i1_62s,i1_63s,i1_64s,i1_65s,i1_66s,i1_67s,i1_68s,i1_69s,
i1_70s,i1_71s,i1_72s,i1_73s,i1_74s,i1_75s,i1_76s,i1_77s,i1_78s,i1_79s,
i1_80s,i1_81s,i1_82s,i1_83s,i1_84s,i1_85s,i1_86s,i1_87s,i1_88s,i1_89s,
i1_90s,i1_91s,i1_92s,i1_93s,i1_94s,i1_95s,i1_96s,i1_97s,i1_98s,i1_99s,
i1_100s,i1_101s,i1_102s,i1_103s,i1_104s,i1_105s,i1_106s,i1_107s,i1_108s,i1_109s,
i1_110s,i1_111s,i1_112s,i1_113s,i1_114s,i1_115s,i1_116s,i1_117s,i1_118s,i1_119s,
i1_120s,i1_121s,i1_122s,i1_123s,i1_124s,i1_125s,i1_126s,i1_127s;



wire [39:0] 
i1_0,i1_1,i1_2,i1_3,i1_4,i1_5,i1_6,i1_7,i1_8,i1_9,
i1_10,i1_11,i1_12,i1_13,i1_14,i1_15,i1_16,i1_17,i1_18,i1_19,
i1_20,i1_21,i1_22,i1_23,i1_24,i1_25,i1_26,i1_27,i1_28,i1_29,
i1_30,i1_31,i1_32,i1_33,i1_34,i1_35,i1_36,i1_37,i1_38,i1_39,
i1_40,i1_41,i1_42,i1_43,i1_44,i1_45,i1_46,i1_47,i1_48,i1_49,
i1_50,i1_51,i1_52,i1_53,i1_54,i1_55,i1_56,i1_57,i1_58,i1_59,
i1_60,i1_61,i1_62,i1_63,i1_64,i1_65,i1_66,i1_67,i1_68,i1_69,
i1_70,i1_71,i1_72,i1_73,i1_74,i1_75,i1_76,i1_77,i1_78,i1_79,
i1_80,i1_81,i1_82,i1_83,i1_84,i1_85,i1_86,i1_87,i1_88,i1_89,
i1_90,i1_91,i1_92,i1_93,i1_94,i1_95,i1_96,i1_97,i1_98,i1_99,
i1_100,i1_101,i1_102,i1_103,i1_104,i1_105,i1_106,i1_107,i1_108,i1_109,
i1_110,i1_111,i1_112,i1_113,i1_114,i1_115,i1_116,i1_117,i1_118,i1_119,
i1_120,i1_121,i1_122,i1_123,i1_124,i1_125,i1_126,i1_127;

adder40 s2_0(i0_0s,i0_0,i0_1s,i0_1,i1_0s,i1_0);
adder40 s2_1(i0_2s,i0_2,i0_3s,i0_3,i1_1s,i1_1);
adder40 s2_2(i0_4s,i0_4,i0_5s,i0_5,i1_2s,i1_2);
adder40 s2_3(i0_6s,i0_6,i0_7s,i0_7,i1_3s,i1_3);
adder40 s2_4(i0_8s,i0_8,i0_9s,i0_9,i1_4s,i1_4);
adder40 s2_5(i0_10s,i0_10,i0_11s,i0_11,i1_5s,i1_5);
adder40 s2_6(i0_12s,i0_12,i0_13s,i0_13,i1_6s,i1_6);
adder40 s2_7(i0_14s,i0_14,i0_15s,i0_15,i1_7s,i1_7);
adder40 s2_8(i0_16s,i0_16,i0_17s,i0_17,i1_8s,i1_8);
adder40 s2_9(i0_18s,i0_18,i0_19s,i0_19,i1_9s,i1_9);
adder40 s2_10(i0_20s,i0_20,i0_21s,i0_21,i1_10s,i1_10);
adder40 s2_11(i0_22s,i0_22,i0_23s,i0_23,i1_11s,i1_11);
adder40 s2_12(i0_24s,i0_24,i0_25s,i0_25,i1_12s,i1_12);
adder40 s2_13(i0_26s,i0_26,i0_27s,i0_27,i1_13s,i1_13);
adder40 s2_14(i0_28s,i0_28,i0_29s,i0_29,i1_14s,i1_14);
adder40 s2_15(i0_30s,i0_30,i0_31s,i0_31,i1_15s,i1_15);
adder40 s2_16(i0_32s,i0_32,i0_33s,i0_33,i1_16s,i1_16);
adder40 s2_17(i0_34s,i0_34,i0_35s,i0_35,i1_17s,i1_17);
adder40 s2_18(i0_36s,i0_36,i0_37s,i0_37,i1_18s,i1_18);
adder40 s2_19(i0_38s,i0_38,i0_39s,i0_39,i1_19s,i1_19);
adder40 s2_20(i0_40s,i0_40,i0_41s,i0_41,i1_20s,i1_20);
adder40 s2_21(i0_42s,i0_42,i0_43s,i0_43,i1_21s,i1_21);
adder40 s2_22(i0_44s,i0_44,i0_45s,i0_45,i1_22s,i1_22);
adder40 s2_23(i0_46s,i0_46,i0_47s,i0_47,i1_23s,i1_23);
adder40 s2_24(i0_48s,i0_48,i0_49s,i0_49,i1_24s,i1_24);
adder40 s2_25(i0_50s,i0_50,i0_51s,i0_51,i1_25s,i1_25);
adder40 s2_26(i0_52s,i0_52,i0_53s,i0_53,i1_26s,i1_26);
adder40 s2_27(i0_54s,i0_54,i0_55s,i0_55,i1_27s,i1_27);
adder40 s2_28(i0_56s,i0_56,i0_57s,i0_57,i1_28s,i1_28);
adder40 s2_29(i0_58s,i0_58,i0_59s,i0_59,i1_29s,i1_29);
adder40 s2_30(i0_60s,i0_60,i0_61s,i0_61,i1_30s,i1_30);
adder40 s2_31(i0_62s,i0_62,i0_63s,i0_63,i1_31s,i1_31);
adder40 s2_32(i0_64s,i0_64,i0_65s,i0_65,i1_32s,i1_32);
adder40 s2_33(i0_66s,i0_66,i0_67s,i0_67,i1_33s,i1_33);
adder40 s2_34(i0_68s,i0_68,i0_69s,i0_69,i1_34s,i1_34);
adder40 s2_35(i0_70s,i0_70,i0_71s,i0_71,i1_35s,i1_35);
adder40 s2_36(i0_72s,i0_72,i0_73s,i0_73,i1_36s,i1_36);
adder40 s2_37(i0_74s,i0_74,i0_75s,i0_75,i1_37s,i1_37);
adder40 s2_38(i0_76s,i0_76,i0_77s,i0_77,i1_38s,i1_38);
adder40 s2_39(i0_78s,i0_78,i0_79s,i0_79,i1_39s,i1_39);
adder40 s2_40(i0_80s,i0_80,i0_81s,i0_81,i1_40s,i1_40);
adder40 s2_41(i0_82s,i0_82,i0_83s,i0_83,i1_41s,i1_41);
adder40 s2_42(i0_84s,i0_84,i0_85s,i0_85,i1_42s,i1_42);
adder40 s2_43(i0_86s,i0_86,i0_87s,i0_87,i1_43s,i1_43);
adder40 s2_44(i0_88s,i0_88,i0_89s,i0_89,i1_44s,i1_44);
adder40 s2_45(i0_90s,i0_90,i0_91s,i0_91,i1_45s,i1_45);
adder40 s2_46(i0_92s,i0_92,i0_93s,i0_93,i1_46s,i1_46);
adder40 s2_47(i0_94s,i0_94,i0_95s,i0_95,i1_47s,i1_47);
adder40 s2_48(i0_96s,i0_96,i0_97s,i0_97,i1_48s,i1_48);
adder40 s2_49(i0_98s,i0_98,i0_99s,i0_99,i1_49s,i1_49);
adder40 s2_50(i0_100s,i0_100,i0_101s,i0_101,i1_50s,i1_50);
adder40 s2_51(i0_102s,i0_102,i0_103s,i0_103,i1_51s,i1_51);
adder40 s2_52(i0_104s,i0_104,i0_105s,i0_105,i1_52s,i1_52);
adder40 s2_53(i0_106s,i0_106,i0_107s,i0_107,i1_53s,i1_53);
adder40 s2_54(i0_108s,i0_108,i0_109s,i0_109,i1_54s,i1_54);
adder40 s2_55(i0_110s,i0_110,i0_111s,i0_111,i1_55s,i1_55);
adder40 s2_56(i0_112s,i0_112,i0_113s,i0_113,i1_56s,i1_56);
adder40 s2_57(i0_114s,i0_114,i0_115s,i0_115,i1_57s,i1_57);
adder40 s2_58(i0_116s,i0_116,i0_117s,i0_117,i1_58s,i1_58);
adder40 s2_59(i0_118s,i0_118,i0_119s,i0_119,i1_59s,i1_59);
adder40 s2_60(i0_120s,i0_120,i0_121s,i0_121,i1_60s,i1_60);
adder40 s2_61(i0_122s,i0_122,i0_123s,i0_123,i1_61s,i1_61);
adder40 s2_62(i0_124s,i0_124,i0_125s,i0_125,i1_62s,i1_62);
adder40 s2_63(i0_126s,i0_126,i0_127s,i0_127,i1_63s,i1_63);
adder40 s2_64(i0_128s,i0_128,i0_129s,i0_129,i1_64s,i1_64);
adder40 s2_65(i0_130s,i0_130,i0_131s,i0_131,i1_65s,i1_65);
adder40 s2_66(i0_132s,i0_132,i0_133s,i0_133,i1_66s,i1_66);
adder40 s2_67(i0_134s,i0_134,i0_135s,i0_135,i1_67s,i1_67);
adder40 s2_68(i0_136s,i0_136,i0_137s,i0_137,i1_68s,i1_68);
adder40 s2_69(i0_138s,i0_138,i0_139s,i0_139,i1_69s,i1_69);
adder40 s2_70(i0_140s,i0_140,i0_141s,i0_141,i1_70s,i1_70);
adder40 s2_71(i0_142s,i0_142,i0_143s,i0_143,i1_71s,i1_71);
adder40 s2_72(i0_144s,i0_144,i0_145s,i0_145,i1_72s,i1_72);
adder40 s2_73(i0_146s,i0_146,i0_147s,i0_147,i1_73s,i1_73);
adder40 s2_74(i0_148s,i0_148,i0_149s,i0_149,i1_74s,i1_74);
adder40 s2_75(i0_150s,i0_150,i0_151s,i0_151,i1_75s,i1_75);
adder40 s2_76(i0_152s,i0_152,i0_153s,i0_153,i1_76s,i1_76);
adder40 s2_77(i0_154s,i0_154,i0_155s,i0_155,i1_77s,i1_77);
adder40 s2_78(i0_156s,i0_156,i0_157s,i0_157,i1_78s,i1_78);
adder40 s2_79(i0_158s,i0_158,i0_159s,i0_159,i1_79s,i1_79);
adder40 s2_80(i0_160s,i0_160,i0_161s,i0_161,i1_80s,i1_80);
adder40 s2_81(i0_162s,i0_162,i0_163s,i0_163,i1_81s,i1_81);
adder40 s2_82(i0_164s,i0_164,i0_165s,i0_165,i1_82s,i1_82);
adder40 s2_83(i0_166s,i0_166,i0_167s,i0_167,i1_83s,i1_83);
adder40 s2_84(i0_168s,i0_168,i0_169s,i0_169,i1_84s,i1_84);
adder40 s2_85(i0_170s,i0_170,i0_171s,i0_171,i1_85s,i1_85);
adder40 s2_86(i0_172s,i0_172,i0_173s,i0_173,i1_86s,i1_86);
adder40 s2_87(i0_174s,i0_174,i0_175s,i0_175,i1_87s,i1_87);
adder40 s2_88(i0_176s,i0_176,i0_177s,i0_177,i1_88s,i1_88);
adder40 s2_89(i0_178s,i0_178,i0_179s,i0_179,i1_89s,i1_89);
adder40 s2_90(i0_180s,i0_180,i0_181s,i0_181,i1_90s,i1_90);
adder40 s2_91(i0_182s,i0_182,i0_183s,i0_183,i1_91s,i1_91);
adder40 s2_92(i0_184s,i0_184,i0_185s,i0_185,i1_92s,i1_92);
adder40 s2_93(i0_186s,i0_186,i0_187s,i0_187,i1_93s,i1_93);
adder40 s2_94(i0_188s,i0_188,i0_189s,i0_189,i1_94s,i1_94);
adder40 s2_95(i0_190s,i0_190,i0_191s,i0_191,i1_95s,i1_95);
adder40 s2_96(i0_192s,i0_192,i0_193s,i0_193,i1_96s,i1_96);
adder40 s2_97(i0_194s,i0_194,i0_195s,i0_195,i1_97s,i1_97);
adder40 s2_98(i0_196s,i0_196,i0_197s,i0_197,i1_98s,i1_98);
adder40 s2_99(i0_198s,i0_198,i0_199s,i0_199,i1_99s,i1_99);
adder40 s2_100(i0_200s,i0_200,i0_201s,i0_201,i1_100s,i1_100);
adder40 s2_101(i0_202s,i0_202,i0_203s,i0_203,i1_101s,i1_101);
adder40 s2_102(i0_204s,i0_204,i0_205s,i0_205,i1_102s,i1_102);
adder40 s2_103(i0_206s,i0_206,i0_207s,i0_207,i1_103s,i1_103);
adder40 s2_104(i0_208s,i0_208,i0_209s,i0_209,i1_104s,i1_104);
adder40 s2_105(i0_210s,i0_210,i0_211s,i0_211,i1_105s,i1_105);
adder40 s2_106(i0_212s,i0_212,i0_213s,i0_213,i1_106s,i1_106);
adder40 s2_107(i0_214s,i0_214,i0_215s,i0_215,i1_107s,i1_107);
adder40 s2_108(i0_216s,i0_216,i0_217s,i0_217,i1_108s,i1_108);
adder40 s2_109(i0_218s,i0_218,i0_219s,i0_219,i1_109s,i1_109);
adder40 s2_110(i0_220s,i0_220,i0_221s,i0_221,i1_110s,i1_110);
adder40 s2_111(i0_222s,i0_222,i0_223s,i0_223,i1_111s,i1_111);
adder40 s2_112(i0_224s,i0_224,i0_225s,i0_225,i1_112s,i1_112);
adder40 s2_113(i0_226s,i0_226,i0_227s,i0_227,i1_113s,i1_113);
adder40 s2_114(i0_228s,i0_228,i0_229s,i0_229,i1_114s,i1_114);
adder40 s2_115(i0_230s,i0_230,i0_231s,i0_231,i1_115s,i1_115);
adder40 s2_116(i0_232s,i0_232,i0_233s,i0_233,i1_116s,i1_116);
adder40 s2_117(i0_234s,i0_234,i0_235s,i0_235,i1_117s,i1_117);
adder40 s2_118(i0_236s,i0_236,i0_237s,i0_237,i1_118s,i1_118);
adder40 s2_119(i0_238s,i0_238,i0_239s,i0_239,i1_119s,i1_119);
adder40 s2_120(i0_240s,i0_240,i0_241s,i0_241,i1_120s,i1_120);
adder40 s2_121(i0_242s,i0_242,i0_243s,i0_243,i1_121s,i1_121);
adder40 s2_122(i0_244s,i0_244,i0_245s,i0_245,i1_122s,i1_122);
adder40 s2_123(i0_246s,i0_246,i0_247s,i0_247,i1_123s,i1_123);
adder40 s2_124(i0_248s,i0_248,i0_249s,i0_249,i1_124s,i1_124);
adder40 s2_125(i0_250s,i0_250,i0_251s,i0_251,i1_125s,i1_125);
adder40 s2_126(i0_252s,i0_252,i0_253s,i0_253,i1_126s,i1_126);
adder40 s2_127(i0_254s,i0_254,i0_255s,i0_255,i1_127s,i1_127);

//third level

wire 
i2_0s,i2_1s,i2_2s,i2_3s,i2_4s,i2_5s,i2_6s,i2_7s,i2_8s,i2_9s,
i2_10s,i2_11s,i2_12s,i2_13s,i2_14s,i2_15s,i2_16s,i2_17s,i2_18s,i2_19s,
i2_20s,i2_21s,i2_22s,i2_23s,i2_24s,i2_25s,i2_26s,i2_27s,i2_28s,i2_29s,
i2_30s,i2_31s,i2_32s,i2_33s,i2_34s,i2_35s,i2_36s,i2_37s,i2_38s,i2_39s,
i2_40s,i2_41s,i2_42s,i2_43s,i2_44s,i2_45s,i2_46s,i2_47s,i2_48s,i2_49s,
i2_50s,i2_51s,i2_52s,i2_53s,i2_54s,i2_55s,i2_56s,i2_57s,i2_58s,i2_59s,
i2_60s,i2_61s,i2_62s,i2_63s;

wire [39:0]
i2_0,i2_1,i2_2,i2_3,i2_4,i2_5,i2_6,i2_7,i2_8,i2_9,
i2_10,i2_11,i2_12,i2_13,i2_14,i2_15,i2_16,i2_17,i2_18,i2_19,
i2_20,i2_21,i2_22,i2_23,i2_24,i2_25,i2_26,i2_27,i2_28,i2_29,
i2_30,i2_31,i2_32,i2_33,i2_34,i2_35,i2_36,i2_37,i2_38,i2_39,
i2_40,i2_41,i2_42,i2_43,i2_44,i2_45,i2_46,i2_47,i2_48,i2_49,
i2_50,i2_51,i2_52,i2_53,i2_54,i2_55,i2_56,i2_57,i2_58,i2_59,
i2_60,i2_61,i2_62,i2_63;

adder40 s3_0(i1_0s,i1_0,i1_1s,i1_1,i2_0s,i2_0);
adder40 s3_1(i1_2s,i1_2,i1_3s,i1_3,i2_1s,i2_1);
adder40 s3_2(i1_4s,i1_4,i1_5s,i1_5,i2_2s,i2_2);
adder40 s3_3(i1_6s,i1_6,i1_7s,i1_7,i2_3s,i2_3);
adder40 s3_4(i1_8s,i1_8,i1_9s,i1_9,i2_4s,i2_4);
adder40 s3_5(i1_10s,i1_10,i1_11s,i1_11,i2_5s,i2_5);
adder40 s3_6(i1_12s,i1_12,i1_13s,i1_13,i2_6s,i2_6);
adder40 s3_7(i1_14s,i1_14,i1_15s,i1_15,i2_7s,i2_7);
adder40 s3_8(i1_16s,i1_16,i1_17s,i1_17,i2_8s,i2_8);
adder40 s3_9(i1_18s,i1_18,i1_19s,i1_19,i2_9s,i2_9);
adder40 s3_10(i1_20s,i1_20,i1_21s,i1_21,i2_10s,i2_10);
adder40 s3_11(i1_22s,i1_22,i1_23s,i1_23,i2_11s,i2_11);
adder40 s3_12(i1_24s,i1_24,i1_25s,i1_25,i2_12s,i2_12);
adder40 s3_13(i1_26s,i1_26,i1_27s,i1_27,i2_13s,i2_13);
adder40 s3_14(i1_28s,i1_28,i1_29s,i1_29,i2_14s,i2_14);
adder40 s3_15(i1_30s,i1_30,i1_31s,i1_31,i2_15s,i2_15);
adder40 s3_16(i1_32s,i1_32,i1_33s,i1_33,i2_16s,i2_16);
adder40 s3_17(i1_34s,i1_34,i1_35s,i1_35,i2_17s,i2_17);
adder40 s3_18(i1_36s,i1_36,i1_37s,i1_37,i2_18s,i2_18);
adder40 s3_19(i1_38s,i1_38,i1_39s,i1_39,i2_19s,i2_19);
adder40 s3_20(i1_40s,i1_40,i1_41s,i1_41,i2_20s,i2_20);
adder40 s3_21(i1_42s,i1_42,i1_43s,i1_43,i2_21s,i2_21);
adder40 s3_22(i1_44s,i1_44,i1_45s,i1_45,i2_22s,i2_22);
adder40 s3_23(i1_46s,i1_46,i1_47s,i1_47,i2_23s,i2_23);
adder40 s3_24(i1_48s,i1_48,i1_49s,i1_49,i2_24s,i2_24);
adder40 s3_25(i1_50s,i1_50,i1_51s,i1_51,i2_25s,i2_25);
adder40 s3_26(i1_52s,i1_52,i1_53s,i1_53,i2_26s,i2_26);
adder40 s3_27(i1_54s,i1_54,i1_55s,i1_55,i2_27s,i2_27);
adder40 s3_28(i1_56s,i1_56,i1_57s,i1_57,i2_28s,i2_28);
adder40 s3_29(i1_58s,i1_58,i1_59s,i1_59,i2_29s,i2_29);
adder40 s3_30(i1_60s,i1_60,i1_61s,i1_61,i2_30s,i2_30);
adder40 s3_31(i1_62s,i1_62,i1_63s,i1_63,i2_31s,i2_31);
adder40 s3_32(i1_64s,i1_64,i1_65s,i1_65,i2_32s,i2_32);
adder40 s3_33(i1_66s,i1_66,i1_67s,i1_67,i2_33s,i2_33);
adder40 s3_34(i1_68s,i1_68,i1_69s,i1_69,i2_34s,i2_34);
adder40 s3_35(i1_70s,i1_70,i1_71s,i1_71,i2_35s,i2_35);
adder40 s3_36(i1_72s,i1_72,i1_73s,i1_73,i2_36s,i2_36);
adder40 s3_37(i1_74s,i1_74,i1_75s,i1_75,i2_37s,i2_37);
adder40 s3_38(i1_76s,i1_76,i1_77s,i1_77,i2_38s,i2_38);
adder40 s3_39(i1_78s,i1_78,i1_79s,i1_79,i2_39s,i2_39);
adder40 s3_40(i1_80s,i1_80,i1_81s,i1_81,i2_40s,i2_40);
adder40 s3_41(i1_82s,i1_82,i1_83s,i1_83,i2_41s,i2_41);
adder40 s3_42(i1_84s,i1_84,i1_85s,i1_85,i2_42s,i2_42);
adder40 s3_43(i1_86s,i1_86,i1_87s,i1_87,i2_43s,i2_43);
adder40 s3_44(i1_88s,i1_88,i1_89s,i1_89,i2_44s,i2_44);
adder40 s3_45(i1_90s,i1_90,i1_91s,i1_91,i2_45s,i2_45);
adder40 s3_46(i1_92s,i1_92,i1_93s,i1_93,i2_46s,i2_46);
adder40 s3_47(i1_94s,i1_94,i1_95s,i1_95,i2_47s,i2_47);
adder40 s3_48(i1_96s,i1_96,i1_97s,i1_97,i2_48s,i2_48);
adder40 s3_49(i1_98s,i1_98,i1_99s,i1_99,i2_49s,i2_49);
adder40 s3_50(i1_100s,i1_100,i1_101s,i1_101,i2_50s,i2_50);
adder40 s3_51(i1_102s,i1_102,i1_103s,i1_103,i2_51s,i2_51);
adder40 s3_52(i1_104s,i1_104,i1_105s,i1_105,i2_52s,i2_52);
adder40 s3_53(i1_106s,i1_106,i1_107s,i1_107,i2_53s,i2_53);
adder40 s3_54(i1_108s,i1_108,i1_109s,i1_109,i2_54s,i2_54);
adder40 s3_55(i1_110s,i1_110,i1_111s,i1_111,i2_55s,i2_55);
adder40 s3_56(i1_112s,i1_112,i1_113s,i1_113,i2_56s,i2_56);
adder40 s3_57(i1_114s,i1_114,i1_115s,i1_115,i2_57s,i2_57);
adder40 s3_58(i1_116s,i1_116,i1_117s,i1_117,i2_58s,i2_58);
adder40 s3_59(i1_118s,i1_118,i1_119s,i1_119,i2_59s,i2_59);
adder40 s3_60(i1_120s,i1_120,i1_121s,i1_121,i2_60s,i2_60);
adder40 s3_61(i1_122s,i1_122,i1_123s,i1_123,i2_61s,i2_61);
adder40 s3_62(i1_124s,i1_124,i1_125s,i1_125,i2_62s,i2_62);
adder40 s3_63(i1_126s,i1_126,i1_127s,i1_127,i2_63s,i2_63);

//fourth level

adder40 s4_0(i2_0s,i2_0,i2_1s,i2_1,ou0s,ou0);
adder40 s4_1(i2_2s,i2_2,i2_3s,i2_3,ou1s,ou1);
adder40 s4_2(i2_4s,i2_4,i2_5s,i2_5,ou2s,ou2);
adder40 s4_3(i2_6s,i2_6,i2_7s,i2_7,ou3s,ou3);
adder40 s4_4(i2_8s,i2_8,i2_9s,i2_9,ou4s,ou4);
adder40 s4_5(i2_10s,i2_10,i2_11s,i2_11,ou5s,ou5);
adder40 s4_6(i2_12s,i2_12,i2_13s,i2_13,ou6s,ou6);
adder40 s4_7(i2_14s,i2_14,i2_15s,i2_15,ou7s,ou7);
adder40 s4_8(i2_16s,i2_16,i2_17s,i2_17,ou8s,ou8);
adder40 s4_9(i2_18s,i2_18,i2_19s,i2_19,ou9s,ou9);
adder40 s4_10(i2_20s,i2_20,i2_21s,i2_21,ou10s,ou10);
adder40 s4_11(i2_22s,i2_22,i2_23s,i2_23,ou11s,ou11);
adder40 s4_12(i2_24s,i2_24,i2_25s,i2_25,ou12s,ou12);
adder40 s4_13(i2_26s,i2_26,i2_27s,i2_27,ou13s,ou13);
adder40 s4_14(i2_28s,i2_28,i2_29s,i2_29,ou14s,ou14);
adder40 s4_15(i2_30s,i2_30,i2_31s,i2_31,ou15s,ou15);
adder40 s4_16(i2_32s,i2_32,i2_33s,i2_33,ou16s,ou16);
adder40 s4_17(i2_34s,i2_34,i2_35s,i2_35,ou17s,ou17);
adder40 s4_18(i2_36s,i2_36,i2_37s,i2_37,ou18s,ou18);
adder40 s4_19(i2_38s,i2_38,i2_39s,i2_39,ou19s,ou19);
adder40 s4_20(i2_40s,i2_40,i2_41s,i2_41,ou20s,ou20);
adder40 s4_21(i2_42s,i2_42,i2_43s,i2_43,ou21s,ou21);
adder40 s4_22(i2_44s,i2_44,i2_45s,i2_45,ou22s,ou22);
adder40 s4_23(i2_46s,i2_46,i2_47s,i2_47,ou23s,ou23);
adder40 s4_24(i2_48s,i2_48,i2_49s,i2_49,ou24s,ou24);
adder40 s4_25(i2_50s,i2_50,i2_51s,i2_51,ou25s,ou25);
adder40 s4_26(i2_52s,i2_52,i2_53s,i2_53,ou26s,ou26);
adder40 s4_27(i2_54s,i2_54,i2_55s,i2_55,ou27s,ou27);
adder40 s4_28(i2_56s,i2_56,i2_57s,i2_57,ou28s,ou28);
adder40 s4_29(i2_58s,i2_58,i2_59s,i2_59,ou29s,ou29);
adder40 s4_30(i2_60s,i2_60,i2_61s,i2_61,ou30s,ou30);
adder40 s4_31(i2_62s,i2_62,i2_63s,i2_63,ou31s,ou31);

endmodule




//40 bit fixed point adder

//`include "recurse40.v"
//`include "kgp.v"
//`include "kgp_carry.v"
//`include "recursive_stage1.v"

module adder40(as,a,bs,in_b,rrs,rr);

input as,bs;
input [39:0] a,in_b;
output rrs;
output [39:0] rr;

reg rrs;
reg [39:0] rr;
wire z;
assign z=as^bs;
wire cout,cout1;

wire [39:0] r1,b1,b2;
assign b1=(~in_b);

recurse40 c0(b2,cout1,b1,40'd1);

reg [39:0] b;

always@(z or in_b or b2)
	begin
		if(z==0)
			b=in_b;
		else if (z==1)
			b=b2;
	end
	
recurse40 c1(r1,cout,a,b);

wire cout2;
wire [39:0] r11,r22;
assign r11=(~r1);
recurse40 c2(r22,cout2,r11,40'd1);

reg carry;
always@(r1 or cout or z or as or bs or r22)
 begin
	if(z==0)	
		begin
			rrs=as;
			rr=r1;
			carry=cout;
		end
	else if (z==1 && cout==1)
		begin	
			rrs=as;
			rr=r1;
			carry=1'b0;
		end
	else if (z==1 && cout==0)
		begin
			rrs=(~as);
			rr=r22;
			carry=1'b0;
		end
 end

endmodule


//40 bit recursive doubling technique

module recurse40(sum,carry,a,b); 

output [39:0] sum;
output  carry;
input [39:0] a,b;

wire [81:0] x;

assign x[1:0]=2'b00;  // kgp generation

kgp a00(a[0],b[0],x[3:2]);
kgp a01(a[1],b[1],x[5:4]);
kgp a02(a[2],b[2],x[7:6]);
kgp a03(a[3],b[3],x[9:8]);
kgp a04(a[4],b[4],x[11:10]);
kgp a05(a[5],b[5],x[13:12]);
kgp a06(a[6],b[6],x[15:14]);
kgp a07(a[7],b[7],x[17:16]);
kgp a08(a[8],b[8],x[19:18]);
kgp a09(a[9],b[9],x[21:20]);
kgp a10(a[10],b[10],x[23:22]);
kgp a11(a[11],b[11],x[25:24]);
kgp a12(a[12],b[12],x[27:26]);
kgp a13(a[13],b[13],x[29:28]);
kgp a14(a[14],b[14],x[31:30]);
kgp a15(a[15],b[15],x[33:32]);
kgp a16(a[16],b[16],x[35:34]);
kgp a17(a[17],b[17],x[37:36]);
kgp a18(a[18],b[18],x[39:38]);
kgp a19(a[19],b[19],x[41:40]);
kgp a20(a[20],b[20],x[43:42]);
kgp a21(a[21],b[21],x[45:44]);
kgp a22(a[22],b[22],x[47:46]);
kgp a23(a[23],b[23],x[49:48]);
kgp a24(a[24],b[24],x[51:50]);
kgp a25(a[25],b[25],x[53:52]);
kgp a26(a[26],b[26],x[55:54]);
kgp a27(a[27],b[27],x[57:56]);
kgp a28(a[28],b[28],x[59:58]);
kgp a29(a[29],b[29],x[61:60]);
kgp a30(a[30],b[30],x[63:62]);
kgp a31(a[31],b[31],x[65:64]);
kgp a32(a[32],b[32],x[67:66]);
kgp a33(a[33],b[33],x[69:68]);
kgp a34(a[34],b[34],x[71:70]);
kgp a35(a[35],b[35],x[73:72]);
kgp a36(a[36],b[36],x[75:74]);
kgp a37(a[37],b[37],x[77:76]);
kgp a38(a[38],b[38],x[79:78]);
kgp a39(a[39],b[39],x[81:80]);

wire [79:0] x1;  //recursive doubling stage 1
assign x1[1:0]=x[1:0];

recursive_stage1 s00(x[1:0],x[3:2],x1[3:2]);
recursive_stage1 s01(x[3:2],x[5:4],x1[5:4]);
recursive_stage1 s02(x[5:4],x[7:6],x1[7:6]);
recursive_stage1 s03(x[7:6],x[9:8],x1[9:8]);
recursive_stage1 s04(x[9:8],x[11:10],x1[11:10]);
recursive_stage1 s05(x[11:10],x[13:12],x1[13:12]);
recursive_stage1 s06(x[13:12],x[15:14],x1[15:14]);
recursive_stage1 s07(x[15:14],x[17:16],x1[17:16]);
recursive_stage1 s08(x[17:16],x[19:18],x1[19:18]);
recursive_stage1 s09(x[19:18],x[21:20],x1[21:20]);
recursive_stage1 s10(x[21:20],x[23:22],x1[23:22]);
recursive_stage1 s11(x[23:22],x[25:24],x1[25:24]);
recursive_stage1 s12(x[25:24],x[27:26],x1[27:26]);
recursive_stage1 s13(x[27:26],x[29:28],x1[29:28]);
recursive_stage1 s14(x[29:28],x[31:30],x1[31:30]);
recursive_stage1 s15(x[31:30],x[33:32],x1[33:32]);
recursive_stage1 s16(x[33:32],x[35:34],x1[35:34]);
recursive_stage1 s17(x[35:34],x[37:36],x1[37:36]);
recursive_stage1 s18(x[37:36],x[39:38],x1[39:38]);
recursive_stage1 s19(x[39:38],x[41:40],x1[41:40]);
recursive_stage1 s20(x[41:40],x[43:42],x1[43:42]);
recursive_stage1 s21(x[43:42],x[45:44],x1[45:44]);
recursive_stage1 s22(x[45:44],x[47:46],x1[47:46]);
recursive_stage1 s23(x[47:46],x[49:48],x1[49:48]);
recursive_stage1 s24(x[49:48],x[51:50],x1[51:50]);
recursive_stage1 s25(x[51:50],x[53:52],x1[53:52]);
recursive_stage1 s26(x[53:52],x[55:54],x1[55:54]);
recursive_stage1 s27(x[55:54],x[57:56],x1[57:56]);
recursive_stage1 s28(x[57:56],x[59:58],x1[59:58]);
recursive_stage1 s29(x[59:58],x[61:60],x1[61:60]);
recursive_stage1 s30(x[61:60],x[63:62],x1[63:62]);
recursive_stage1 s31(x[63:62],x[65:64],x1[65:64]);
recursive_stage1 s32(x[65:64],x[67:66],x1[67:66]);
recursive_stage1 s33(x[67:66],x[69:68],x1[69:68]);
recursive_stage1 s34(x[69:68],x[71:70],x1[71:70]);
recursive_stage1 s35(x[71:70],x[73:72],x1[73:72]);
recursive_stage1 s36(x[73:72],x[75:74],x1[75:74]);
recursive_stage1 s37(x[75:74],x[77:76],x1[77:76]);
recursive_stage1 s38(x[77:76],x[79:78],x1[79:78]);

wire [79:0] x2;  //recursive doubling stage2
assign x2[3:0]=x1[3:0];

recursive_stage1 s101(x1[1:0],x1[5:4],x2[5:4]);
recursive_stage1 s102(x1[3:2],x1[7:6],x2[7:6]);
recursive_stage1 s103(x1[5:4],x1[9:8],x2[9:8]);
recursive_stage1 s104(x1[7:6],x1[11:10],x2[11:10]);
recursive_stage1 s105(x1[9:8],x1[13:12],x2[13:12]);
recursive_stage1 s106(x1[11:10],x1[15:14],x2[15:14]);
recursive_stage1 s107(x1[13:12],x1[17:16],x2[17:16]);
recursive_stage1 s108(x1[15:14],x1[19:18],x2[19:18]);
recursive_stage1 s109(x1[17:16],x1[21:20],x2[21:20]);
recursive_stage1 s110(x1[19:18],x1[23:22],x2[23:22]);
recursive_stage1 s111(x1[21:20],x1[25:24],x2[25:24]);
recursive_stage1 s112(x1[23:22],x1[27:26],x2[27:26]);
recursive_stage1 s113(x1[25:24],x1[29:28],x2[29:28]);
recursive_stage1 s114(x1[27:26],x1[31:30],x2[31:30]);
recursive_stage1 s115(x1[29:28],x1[33:32],x2[33:32]);
recursive_stage1 s116(x1[31:30],x1[35:34],x2[35:34]);
recursive_stage1 s117(x1[33:32],x1[37:36],x2[37:36]);
recursive_stage1 s118(x1[35:34],x1[39:38],x2[39:38]);
recursive_stage1 s119(x1[37:36],x1[41:40],x2[41:40]);
recursive_stage1 s120(x1[39:38],x1[43:42],x2[43:42]);
recursive_stage1 s121(x1[41:40],x1[45:44],x2[45:44]);
recursive_stage1 s122(x1[43:42],x1[47:46],x2[47:46]);
recursive_stage1 s123(x1[45:44],x1[49:48],x2[49:48]);
recursive_stage1 s124(x1[47:46],x1[51:50],x2[51:50]);
recursive_stage1 s125(x1[49:48],x1[53:52],x2[53:52]);
recursive_stage1 s126(x1[51:50],x1[55:54],x2[55:54]);
recursive_stage1 s127(x1[53:52],x1[57:56],x2[57:56]);
recursive_stage1 s128(x1[55:54],x1[59:58],x2[59:58]);
recursive_stage1 s129(x1[57:56],x1[61:60],x2[61:60]);
recursive_stage1 s130(x1[59:58],x1[63:62],x2[63:62]);
recursive_stage1 s131(x1[61:60],x1[65:64],x2[65:64]);
recursive_stage1 s132(x1[63:62],x1[67:66],x2[67:66]);
recursive_stage1 s133(x1[65:64],x1[69:68],x2[69:68]);
recursive_stage1 s134(x1[67:66],x1[71:70],x2[71:70]);
recursive_stage1 s135(x1[69:68],x1[73:72],x2[73:72]);
recursive_stage1 s136(x1[71:70],x1[75:74],x2[75:74]);
recursive_stage1 s137(x1[73:72],x1[77:76],x2[77:76]);
recursive_stage1 s138(x1[75:74],x1[79:78],x2[79:78]);

wire [79:0] x3;  //recursive doubling stage3
assign x3[7:0]=x2[7:0];

recursive_stage1 s203(x2[1:0],x2[9:8],x3[9:8]);
recursive_stage1 s204(x2[3:2],x2[11:10],x3[11:10]);
recursive_stage1 s205(x2[5:4],x2[13:12],x3[13:12]);
recursive_stage1 s206(x2[7:6],x2[15:14],x3[15:14]);
recursive_stage1 s207(x2[9:8],x2[17:16],x3[17:16]);
recursive_stage1 s208(x2[11:10],x2[19:18],x3[19:18]);
recursive_stage1 s209(x2[13:12],x2[21:20],x3[21:20]);
recursive_stage1 s210(x2[15:14],x2[23:22],x3[23:22]);
recursive_stage1 s211(x2[17:16],x2[25:24],x3[25:24]);
recursive_stage1 s212(x2[19:18],x2[27:26],x3[27:26]);
recursive_stage1 s213(x2[21:20],x2[29:28],x3[29:28]);
recursive_stage1 s214(x2[23:22],x2[31:30],x3[31:30]);
recursive_stage1 s215(x2[25:24],x2[33:32],x3[33:32]);
recursive_stage1 s216(x2[27:26],x2[35:34],x3[35:34]);
recursive_stage1 s217(x2[29:28],x2[37:36],x3[37:36]);
recursive_stage1 s218(x2[31:30],x2[39:38],x3[39:38]);
recursive_stage1 s219(x2[33:32],x2[41:40],x3[41:40]);
recursive_stage1 s220(x2[35:34],x2[43:42],x3[43:42]);
recursive_stage1 s221(x2[37:36],x2[45:44],x3[45:44]);
recursive_stage1 s222(x2[39:38],x2[47:46],x3[47:46]);
recursive_stage1 s223(x2[41:40],x2[49:48],x3[49:48]);
recursive_stage1 s224(x2[43:42],x2[51:50],x3[51:50]);
recursive_stage1 s225(x2[45:44],x2[53:52],x3[53:52]);
recursive_stage1 s226(x2[47:46],x2[55:54],x3[55:54]);
recursive_stage1 s227(x2[49:48],x2[57:56],x3[57:56]);
recursive_stage1 s228(x2[51:50],x2[59:58],x3[59:58]);
recursive_stage1 s229(x2[53:52],x2[61:60],x3[61:60]);
recursive_stage1 s230(x2[55:54],x2[63:62],x3[63:62]);
recursive_stage1 s231(x2[57:56],x2[65:64],x3[65:64]);
recursive_stage1 s232(x2[59:58],x2[67:66],x3[67:66]);
recursive_stage1 s233(x2[61:60],x2[69:68],x3[69:68]);
recursive_stage1 s234(x2[63:62],x2[71:70],x3[71:70]);
recursive_stage1 s235(x2[65:64],x2[73:72],x3[73:72]);
recursive_stage1 s236(x2[67:66],x2[75:74],x3[75:74]);
recursive_stage1 s237(x2[69:68],x2[77:76],x3[77:76]);
recursive_stage1 s238(x2[71:70],x2[79:78],x3[79:78]);

wire [79:0] x4;  //recursive doubling stage 4
assign x4[15:0]=x3[15:0];

recursive_stage1 s307(x3[1:0],x3[17:16],x4[17:16]);
recursive_stage1 s308(x3[3:2],x3[19:18],x4[19:18]);
recursive_stage1 s309(x3[5:4],x3[21:20],x4[21:20]);
recursive_stage1 s310(x3[7:6],x3[23:22],x4[23:22]);
recursive_stage1 s311(x3[9:8],x3[25:24],x4[25:24]);
recursive_stage1 s312(x3[11:10],x3[27:26],x4[27:26]);
recursive_stage1 s313(x3[13:12],x3[29:28],x4[29:28]);
recursive_stage1 s314(x3[15:14],x3[31:30],x4[31:30]);
recursive_stage1 s315(x3[17:16],x3[33:32],x4[33:32]);
recursive_stage1 s316(x3[19:18],x3[35:34],x4[35:34]);
recursive_stage1 s317(x3[21:20],x3[37:36],x4[37:36]);
recursive_stage1 s318(x3[23:22],x3[39:38],x4[39:38]);
recursive_stage1 s319(x3[25:24],x3[41:40],x4[41:40]);
recursive_stage1 s320(x3[27:26],x3[43:42],x4[43:42]);
recursive_stage1 s321(x3[29:28],x3[45:44],x4[45:44]);
recursive_stage1 s322(x3[31:30],x3[47:46],x4[47:46]);
recursive_stage1 s323(x3[33:32],x3[49:48],x4[49:48]);
recursive_stage1 s324(x3[35:34],x3[51:50],x4[51:50]);
recursive_stage1 s325(x3[37:36],x3[53:52],x4[53:52]);
recursive_stage1 s326(x3[39:38],x3[55:54],x4[55:54]);
recursive_stage1 s327(x3[41:40],x3[57:56],x4[57:56]);
recursive_stage1 s328(x3[43:42],x3[59:58],x4[59:58]);
recursive_stage1 s329(x3[45:44],x3[61:60],x4[61:60]);
recursive_stage1 s330(x3[47:46],x3[63:62],x4[63:62]);
recursive_stage1 s331(x3[49:48],x3[65:64],x4[65:64]);
recursive_stage1 s332(x3[51:50],x3[67:66],x4[67:66]);
recursive_stage1 s333(x3[53:52],x3[69:68],x4[69:68]);
recursive_stage1 s334(x3[55:54],x3[71:70],x4[71:70]);
recursive_stage1 s335(x3[57:56],x3[73:72],x4[73:72]);
recursive_stage1 s336(x3[59:58],x3[75:74],x4[75:74]);
recursive_stage1 s337(x3[61:60],x3[77:76],x4[77:76]);
recursive_stage1 s338(x3[63:62],x3[79:78],x4[79:78]);

wire [79:0] x5;  //recursive doubling stage 5
assign x5[31:0]=x4[31:0];

recursive_stage1 s415(x4[1:0],x4[33:32],x5[33:32]);
recursive_stage1 s416(x4[3:2],x4[35:34],x5[35:34]);
recursive_stage1 s417(x4[5:4],x4[37:36],x5[37:36]);
recursive_stage1 s418(x4[7:6],x4[39:38],x5[39:38]);
recursive_stage1 s419(x4[9:8],x4[41:40],x5[41:40]);
recursive_stage1 s420(x4[11:10],x4[43:42],x5[43:42]);
recursive_stage1 s421(x4[13:12],x4[45:44],x5[45:44]);
recursive_stage1 s422(x4[15:14],x4[47:46],x5[47:46]);
recursive_stage1 s423(x4[17:16],x4[49:48],x5[49:48]);
recursive_stage1 s424(x4[19:18],x4[51:50],x5[51:50]);
recursive_stage1 s425(x4[21:20],x4[53:52],x5[53:52]);
recursive_stage1 s426(x4[23:22],x4[55:54],x5[55:54]);
recursive_stage1 s427(x4[25:24],x4[57:56],x5[57:56]);
recursive_stage1 s428(x4[27:26],x4[59:58],x5[59:58]);
recursive_stage1 s429(x4[29:28],x4[61:60],x5[61:60]);
recursive_stage1 s430(x4[31:30],x4[63:62],x5[63:62]);
recursive_stage1 s431(x4[33:32],x4[65:64],x5[65:64]);
recursive_stage1 s432(x4[35:34],x4[67:66],x5[67:66]);
recursive_stage1 s433(x4[37:36],x4[69:68],x5[69:68]);
recursive_stage1 s434(x4[39:38],x4[71:70],x5[71:70]);
recursive_stage1 s435(x4[41:40],x4[73:72],x5[73:72]);
recursive_stage1 s436(x4[43:42],x4[75:74],x5[75:74]);
recursive_stage1 s437(x4[45:44],x4[77:76],x5[77:76]);
recursive_stage1 s438(x4[47:46],x4[79:78],x5[79:78]);

wire [79:0] x6;  // recursive doubling stage 6
assign x6[63:0]=x5[63:0];

recursive_stage1 s531(x5[1:0],x5[65:64],x6[65:64]);
recursive_stage1 s532(x5[3:2],x5[67:66],x6[67:66]);
recursive_stage1 s533(x5[5:4],x5[69:68],x6[69:68]);
recursive_stage1 s534(x5[7:6],x5[71:70],x6[71:70]);
recursive_stage1 s535(x5[9:8],x5[73:72],x6[73:72]);
recursive_stage1 s536(x5[11:10],x5[75:74],x6[75:74]);
recursive_stage1 s537(x5[13:12],x5[77:76],x6[77:76]);
recursive_stage1 s538(x5[15:14],x5[79:78],x6[79:78]);

// final sum and carry

assign sum[0]=a[0]^b[0]^x6[0];
assign sum[1]=a[1]^b[1]^x6[2];
assign sum[2]=a[2]^b[2]^x6[4];
assign sum[3]=a[3]^b[3]^x6[6];
assign sum[4]=a[4]^b[4]^x6[8];
assign sum[5]=a[5]^b[5]^x6[10];
assign sum[6]=a[6]^b[6]^x6[12];
assign sum[7]=a[7]^b[7]^x6[14];
assign sum[8]=a[8]^b[8]^x6[16];
assign sum[9]=a[9]^b[9]^x6[18];
assign sum[10]=a[10]^b[10]^x6[20];
assign sum[11]=a[11]^b[11]^x6[22];
assign sum[12]=a[12]^b[12]^x6[24];
assign sum[13]=a[13]^b[13]^x6[26];
assign sum[14]=a[14]^b[14]^x6[28];
assign sum[15]=a[15]^b[15]^x6[30];
assign sum[16]=a[16]^b[16]^x6[32];
assign sum[17]=a[17]^b[17]^x6[34];
assign sum[18]=a[18]^b[18]^x6[36];
assign sum[19]=a[19]^b[19]^x6[38];
assign sum[20]=a[20]^b[20]^x6[40];
assign sum[21]=a[21]^b[21]^x6[42];
assign sum[22]=a[22]^b[22]^x6[44];
assign sum[23]=a[23]^b[23]^x6[46];
assign sum[24]=a[24]^b[24]^x6[48];
assign sum[25]=a[25]^b[25]^x6[50];
assign sum[26]=a[26]^b[26]^x6[52];
assign sum[27]=a[27]^b[27]^x6[54];
assign sum[28]=a[28]^b[28]^x6[56];
assign sum[29]=a[29]^b[29]^x6[58];
assign sum[30]=a[30]^b[30]^x6[60];
assign sum[31]=a[31]^b[31]^x6[62];
assign sum[32]=a[32]^b[32]^x6[64];
assign sum[33]=a[33]^b[33]^x6[66];
assign sum[34]=a[34]^b[34]^x6[68];
assign sum[35]=a[35]^b[35]^x6[70];
assign sum[36]=a[36]^b[36]^x6[72];
assign sum[37]=a[37]^b[37]^x6[74];
assign sum[38]=a[38]^b[38]^x6[76];
assign sum[39]=a[39]^b[39]^x6[79];

kgp_carry kkc(x[81:80],x6[79:78],carry);

endmodule



module kgp(a,b,y);

input a,b;
output [1:0] y;
//reg [1:0] y;

//always@(a or b)
//begin
//case({a,b})
//2'b00:y=2'b00;  //kill
//2'b11:y=2'b11;	  //generate
//2'b01:y=2'b01;	//propagate
//2'b10:y=2'b01;  //propagate
//endcase   //y[1]=ab  y[0]=a+b  
//end

assign y[0]=a | b;
assign y[1]=a & b;

endmodule


module kgp_carry(a,b,carry);

input [1:0] a,b;
output carry;
reg carry;

always@(a or b)
begin
case(a)
2'b00:carry=1'b0;  
2'b11:carry=1'b1;
2'b01:carry=b[0];
2'b10:carry=b[0];
default:carry=1'bx;
endcase
end

/*wire carry;

wire f,g;
assign g=a[0] & a[1];
assign f=a[0] ^ a[1];

assign carry=g|(b[0] & f);*/

endmodule


module recursive_stage1(a,b,y);

input [1:0] a,b;
output [1:0] y;

wire [1:0] y;
wire b0;
not n1(b0,b[1]);
wire f,g0,g1;
and a1(f,b[0],b[1]);
and a2(g0,b0,b[0],a[0]);
and a3(g1,b0,b[0],a[1]);

or o1(y[0],f,g0);
or o2(y[1],f,g1);

//reg [1:0] y;
//always@(a or b)
//begin
//case(b)
//2'b00:y=2'b00;  
//2'b11:y=2'b11;
//2'b01:y=a;
//default:y=2'bx;
//endcase
//end

//always@(a or b)
//begin
//if(b==2'b00)
//	y=2'b00;  
//else if (b==2'b11)
//	y=2'b11;
//else if (b==2'b01)
//	y=a;
//end

//wire x;
//assign x=a[0] ^ b[0];
//always@(a or b or x)
//begin
//case(x)
//1'b0:y[0]=b[0];  
//1'b1:y[0]=a[0]; 
//endcase
//end
//
//always@(a or b or x)
//begin
//case(x)
//1'b0:y[1]=b[1];  
//1'b1:y[1]=a[1];
//endcase
//end


//always@(a or b)
//begin
//if (b==2'b00)
//	y=2'b00; 
//else if (b==2'b11)	
//	y=2'b11;
//else if (b==2'b01 && a==2'b00)
//	y=2'b00;
//else if (b==2'b01 && a==2'b11)
//	y=2'b11;
//else if (b==2'b01 && a==2'b01)
//	y=2'b01;
//end

endmodule

//add shift network used for odd/even decomposed based integer DCT

//`include "kgp.v"
//`include "kgp_carry.v"
//`include "recursive_stage1.v"
//`include "recurse40.v"
//`include "mux2to1_41.v"

module add_shift_folded(xs,ys,x,y,sel);

input xs,sel;
output ys;
input [39:0] x;
output [39:0] y;

wire [39:0] s1,s2,s3,s4;
wire c1,c2,c3,c4;

recurse40 r1(s1,c1,{6'b0,x[39:6]},{4'b0,x[39:4]}); 
recurse40 r2(s2,c2,{2'b0,x[39:2]},{1'b0,x[39:1]});
recurse40 r3(s3,c3,s1,s2);
recurse40 r4(s4,c4,s3,x);

mux2to1_41 m1({ys,y},{xs,s4},{(~xs),s4},sel);


endmodule


//2 to 1 multiplexer design

module mux2to1_41(out,i1,i2,s);

input [40:0] i1,i2;
input s;
output [40:0] out;
reg [40:0] out;

always@(i1 or i2 or s)
	begin
	 case(s)
	  1'b0:out=i1;
	  1'b1:out=i2;
	 endcase
	end

endmodule

//2 to 1 multiplexer design

module mux2to1_25(out,i1,i2,s);

input [24:0] i1,i2;
input s;
output [24:0] out;
reg [24:0] out;

always@(i1 or i2 or s)
	begin
	 case(s)
	  1'b0:out=i1;
	  1'b1:out=i2;
	 endcase
	end

endmodule
`default_nettype wire
