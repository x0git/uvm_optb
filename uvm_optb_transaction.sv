/**
//////////////////////////////////////////////////////////////////////////////////
// Community: Open Source
// File Creator: x0git
// Create Date: 2025/01/01 00:00:00
// Design Name: O.P.T.B.
// Class Name: uvm_optb_transaction
// Project Name: Open Platform for Test Bench(UVM, Universal Verification Methodology)
// Target Devices: ANY
// Tool Versions: develop tools, UVM & Systemverilog supported
// Description:
// 1. Wrapper of Transaction Seed, generate transcation for driver@platform.
// 2. Transaction Seed's type should be defined before used.
// 3. Transaction Seed's instance should be init before used.
// 4. Variables     Type                Comments
//    SEED_TYPE     paremeter type      default:uvm_sequence_item
//                                      should be set other than uvm_sequence_item.
//    seed          SEED_TYPE           default:null, init by call init()
//                                      should be defined outside of the platform.
// Dependencies:
// 1. uvm(1.2) library/package
// 2. Transaction Seed instance(SEED_TYPE) outside of model
// Revision:
// Date         Version             Author          Comment
// 2025.Jan.01  Revision 0.00       x0git           Frame of Project(Origin)
// Author List:
//  Code                        Information
//  x0git                       @404 NOT FOUND
// Additional Comments:
// 1. [Freedom] License: LGPLv3
// 2. [Bussiness] Warning: For Technical and Acadamic Exchanges.
// 3. [Industry] Compatible Environment List:
// No.      Name         Version             Company
// 000      Vivado       2020.2              Xilinx(AMD)
//////////////////////////////////////////////////////////////////////////////////
*/
`ifndef UVM_OPTB_TRANSACTION_SV
`define UVM_OPTB_TRANSACTION_SV

`include "uvm_macros.svh"
import uvm_pkg::*;

`ifndef GLOBAL_TIMESCALE_STEP_PRECISION
    `timescale 1ns / 1ps
`else
    `GLOBAL_TIMESCALE_STEP_PRECISION
`endif

class uvm_optb_transaction
#(parameter type SEED_TYPE = uvm_sequence_item)
extends uvm_sequence_item;
`uvm_object_param_utils(uvm_optb_transaction #(.SEED_TYPE(SEED_TYPE)))

local const string uvm_optb_name = "uvm_optb_transaction";
rand SEED_TYPE seed;

/**
* construct function
* 1. Check $SEED_TYPE has been set by USER.
* 2. Set $seed to null.
*/
function new(input string name = "uvm_optb_transaction");
    SEED_TYPE seed_type_chk;
    uvm_sequence_item uvm_sequence_item_type_chk;

    super.new(name);
    `uvm_info(this.uvm_optb_name,
              $sformatf("\n@%0t: %s ->> [%s] (new) is called.\n",
                        $realtime, this.get_full_name(), this.uvm_optb_name),
              UVM_LOW);

    assert($typename(seed_type_chk) != $typename(uvm_sequence_item_type_chk)) else
    begin
        `uvm_fatal(this.uvm_optb_name,
                   $sformatf("\n@%0t: %s ->> [%s] $SEED_TYPE has not been SET! -- Different From 'uvm_sequence_item'\n",
                             $realtime, this.get_full_name(), this.uvm_optb_name));
        $finish;
    end

    this.seed = null;
endfunction:new

/**
* init
* 1. Set $seed by USER.
*/
function void init(SEED_TYPE seed_src);
    `uvm_info(this.uvm_optb_name,
              $sformatf("\n@%0t: %s ->> [%s] (init) is called.\n",
                        $realtime, this.get_full_name(), this.uvm_optb_name),
              UVM_LOW);

    this.seed = seed_src;
endfunction:init

/**
* pre_randomize
* 1. Check $seed that has been set by USER.
* 2. Callback $seed's vper_randomize.
*/
function void pre_randomize();
    `uvm_info(this.uvm_optb_name,
              $sformatf("\n@%0t: %s ->> [%s] (pre_randomize) is called.\n",
                        $realtime, this.get_full_name(), this.uvm_optb_name),
              UVM_LOW);

    assert(this.seed != null) void'(this.seed.pre_randomize());
    else
    begin
        `uvm_fatal(this.uvm_optb_name,
                   $sformatf("\n@%0t: %s ->> [%s] should be <init> before used!\n",
                             $realtime, this.get_full_name(), this.uvm_optb_name));
        $finish;
    end
endfunction:pre_randomize

/**
* pre_randomize
* 1. Check $seed that has been set by USER.
* 2. Callback $seed's post_randomize.
*/
function void post_randomize();
    `uvm_info("uvm_optb_transaction",
              $sformatf("\n@%0t: %s ->> [%s] (post_randomize) is called.\n",
                        $realtime, this.get_full_name(), this.uvm_optb_name),
              UVM_LOW);

    assert(this.seed != null) void'(this.seed.post_randomize());
    else
    begin
        `uvm_fatal(this.uvm_optb_name,
                   $sformatf("\n@%0t: %s ->> [%s] should be <init> before used!\n",
                             $realtime, this.get_full_name(), this.uvm_optb_name));
        $finish;
    end
endfunction:post_randomize

endclass:uvm_optb_transaction

`endif
