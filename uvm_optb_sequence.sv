/**
//////////////////////////////////////////////////////////////////////////////////
// Community: Open Source
// File Creator: x0git
// Create Date: 2025/01/01 00:00:00
// Design Name: O.P.T.B.
// Class Name: uvm_optb_sequence
// Project Name: Open Platform for Test Bench(UVM, Universal Verification Methodology)
// Target Devices: ANY
// Tool Versions: develop tools, UVM & Systemverilog supported
// Description:
// 1. Transaction Seed's type SUGGESTED be defined before used.
// 2. Transaction Seed's instance SUGGESTED be init before used.
// 3. Variables     Type                Comments
//    SEED_TYPE     paremeter type      default:uvm_sequence_item
//                                      be set other than uvm_sequence_item.
//    tr.seed       SEED_TYPE           default as tr defined, init by call init()
//                                      SUGGESTED be defined outside of the platform.
// 4. Type definition
//      name                definition
//      tr_type             uvm_optb_transaction #(.SEED_TYPE(SEED_TYPE))
// Dependencies:
// 1. uvm(1.2) library/package
// 2. uvm_optb_transaction.sv
// 3. Transaction Seed instance(SEED_TYPE) outside of model
// Revision:
// Date         Version             Author          Comment
// 2025.Jan.01  Revision 0.00       x0git           Frame of Project(Origin)
// Author List:
//  Code                        Information
//  x0git                       @404 NOT FOUND
// Additional Comments:
// 1. [Freedom] License: LGPLv3
// 2. [Business] Warning: For Technical and Acadamic Exchanges.
// 3. [Industry] Compatible Environment List:
// No.      Name         Version             Company
// 000      Vivado       2020.2              Xilinx(AMD)
//////////////////////////////////////////////////////////////////////////////////
*/

`ifndef UVM_OPTB_SEQUENCE_SV
`define UVM_OPTB_SEQUENCE_SV

`include "uvm_macros.svh"
import uvm_pkg::*;

`include "uvm_optb_transaction.sv"

`ifndef GLOBAL_TIMESCALE_STEP_PRECISION
    `timescale 1ns / 1ps
`else
    `GLOBAL_TIMESCALE_STEP_PRECISION
`endif

class uvm_optb_sequence
#(parameter type SEED_TYPE = uvm_sequence_item)
extends uvm_sequence #(uvm_optb_transaction #(.SEED_TYPE(SEED_TYPE)));
`uvm_object_param_utils(uvm_optb_sequence #(.SEED_TYPE(SEED_TYPE)))

typedef uvm_optb_transaction #(.SEED_TYPE(SEED_TYPE)) tr_type;

local const string uvm_optb_name = "uvm_optb_sequence";
protected tr_type tr;

/**
* construct function
* 1. Build $tr's instance.
*/
function new(input string name = "uvm_optb_sequence");
    super.new(name);

    `uvm_info(this.uvm_optb_name,
              $sformatf("\n@%0t: %s ->> [%s] (new) is called.\n",
                        $realtime, this.get_full_name(), this.uvm_optb_name),
              UVM_LOW);

    this.tr = new("tr");
endfunction:new

/**
* init
* 1. Set $tr.seed by USER.
*/
function void init(SEED_TYPE seed_src);
    `uvm_info(this.uvm_optb_name,
              $sformatf("\n@%0t: %s ->> [%s] (init) is called.\n",
                        $realtime, this.get_full_name(), this.uvm_optb_name),
              UVM_LOW);

    this.tr.init(seed_src);
endfunction:init

/**
* body
* 1. Generate $tr.
*/
virtual task body();
    `uvm_info(this.uvm_optb_name,
              $sformatf("\n@%0t: %s ->> [%s] ((body)) is called.\n",
                        $realtime, this.get_full_name(), this.uvm_optb_name),
              UVM_LOW);

    forever
    begin
        `uvm_info(this.uvm_optb_name,
                  $sformatf("\n@%0t: %s ->> [%s] Transaction $tr generation process starts...\n",
                            $realtime, this.get_full_name(), this.uvm_optb_name),
                  UVM_LOW);

        `uvm_rand_send(this.tr);

        `uvm_info(this.uvm_optb_name,
                  $sformatf("\n@%0t: %s ->> [%s] Transaction $tr has been generated.\n",
                            $realtime, this.get_full_name(), this.uvm_optb_name),
                  UVM_LOW);
    end
endtask:body

endclass:uvm_optb_sequence

`endif
