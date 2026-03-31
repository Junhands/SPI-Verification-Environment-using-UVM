/*
 * =====================================================
 * Created on Tue Mar 31 2026
 * University of Information Technology (UIT)
 * Copyright (c) 2026 Cong Nguyen
 * Email: congnguyen1024@gmail.com
 * =====================================================
 */

package spi_chk_pkg;

   import uvm_pkg::*;
   import spi_tlm_pkg::*;
   import spi_cfg_pkg::*;
   

   `include "uvm_macros.svh"
   `uvm_analysis_imp_decl(_ref_ob_imp)
   `uvm_analysis_imp_decl(_act_ob_imp)
   `include "sb.sv"
   
endpackage
