//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
//***************************************************************************************************************
// Interface module for the APB bus         
//***************************************************************************************************************
`timescale 1ns/1ps
interface apb_if (input logic rst, input logic clk);
  logic                            PCLK;            // APB System Clock
  logic                            PRESETN;         // APB Reset - Active low
  logic [4:0]                      PADDR;           // APB Address
  logic [31:0]                     PWDATA;          // Write data
  wire  [31:0]                     PRDATA;          // Read data
  logic                            PWRITE;
  logic                            PSEL;
  logic                            PENABLE;
  wire                             PREADY;
  wire                             PSLVERR;
  wire                             IRQ;

endinterface

