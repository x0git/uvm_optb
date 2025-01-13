/**
//////////////////////////////////////////////////////////////////////////////////
// Community: Open Source
// File Creator: x0git
// Create Date: 2025/01/01 00:00:00
// Design Name: O.P.T.B.
// Class Name: uvm_optb_sequencer
// Project Name: Open Platform for Test Bench(UVM, Universal Verification Methodology)
// Target Devices: ANY
// Tool Versions: develop tools, UVM & Systemverilog supported
// Description:
// 1. Transaction Seed's type SUGGESTED be defined before used.
// 2. Transaction Seed's instance SUGGESTED be init before used.
// 3. Variables         Type                Comments
//    SEED_TYPE         paremeter type      default:uvm_sequence_item
//                                          SUGGESTED be set other than uvm_sequence_item.
//    seq.seed          SEED_TYPE           default as seq defined, init by call init()
//    (protected)                           SUGGESTED be defined outside of the platform.
//    testcase_domain   uvm_domain          default:null, null "default domain"
//                                          Access directly.
// 3. Type definition
//      name                definition
//      seq_type            uvm_optb_sequence #(.SEED_TYPE(SEED_TYPE))
// Dependencies:
// 1. uvm(1.2) library/package
// 2. uvm_optb_transaction.sv
// 3. uvm_optb_sequence.sv
// 4. Transaction Seed instance(SEED_TYPE) outside of model
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

`ifndef UVM_OPTB_SEQUENCER_SV
`define UVM_OPTB_SEQUENCER_SV

`include "uvm_macros.svh"
import uvm_pkg::*;

`include "uvm_optb_transaction.sv"
`include "uvm_optb_sequence.sv"

`ifndef GLOBAL_TIMESCALE_STEP_PRECISION
    `timescale 1ns / 1ps
`else
    `GLOBAL_TIMESCALE_STEP_PRECISION
`endif

class uvm_optb_sequencer
#(parameter type SEED_TYPE = uvm_sequence_item)
extends uvm_sequencer #(uvm_optb_transaction #(.SEED_TYPE(SEED_TYPE)));
`uvm_component_param_utils(uvm_optb_sequencer #(.SEED_TYPE(SEED_TYPE)))

typedef uvm_optb_sequence #(.SEED_TYPE(SEED_TYPE)) seq_type;

local const string uvm_optb_name = "uvm_optb_sequencer";
protected seq_type seq;

uvm_domain testcase_domain;

/**
 * construct function
 * 1. set $testcase_domain to null.
 */
function new(input string name = "uvm_optb_sequencer",
             uvm_component parent = null);
    super.new(name, parent);

    `uvm_info(this.uvm_optb_name,
              $sformatf("\n@%0t: %s ->> [%s] (new) is called.\n",
                        $realtime, this.get_full_name(), this.uvm_optb_name),
              UVM_LOW);

    this.testcase_domain = null;
endfunction:new

/**
 * init
 * 1. Set $seq.seed by USER.
 */
function void init(SEED_TYPE seed_src);
    `uvm_info(this.uvm_optb_name,
              $sformatf("\n@%0t: %s ->> [%s] (init) is called.\n",
                        $realtime, this.get_full_name(), this.uvm_optb_name),
              UVM_LOW);

    this.seq.init(seed_src);
endfunction:init

/**
 * build_phase
 * 1. Build $seq's instance.
 */
virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    `uvm_info(this.uvm_optb_name,
              $sformatf("\n@%0t: %s ->> [%s] (build_phase)@<phase:%s> is called.\n",
                        $realtime, this.get_full_name(), this.uvm_optb_name, phase.get_name()),
              UVM_LOW);

    this.seq = seq_type::type_id::create("seq");
    assert(this.seq != null) else
    begin
        `uvm_fatal(this.uvm_optb_name,
                   $sformatf("\n@%0t: %s ->> [%s] $seq is null! create() failed.\n",
                             $realtime, this.get_full_name(), this.uvm_optb_name));
        $finish;
    end
endfunction:build_phase

/**
 * connect_phase
 * 1. Set domain to $testcase_domain.
 */
virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    `uvm_info(this.uvm_optb_name,
              $sformatf("\n@%0t: %s ->> [%s] (connect_phase)@<phase:%s> is called.\n",
                        $realtime, this.get_full_name(), this.uvm_optb_name, phase.get_name()),
              UVM_LOW);

    if(this.testcase_domain != null)
    begin
        this.set_domain(this.testcase_domain);
        `uvm_info(this.uvm_optb_name,
                  $sformatf("\n@%0t: %s ->> [%s] set_domain@<%s>\n",
                            $realtime, this.get_full_name(), this.uvm_optb_name, this.testcase_domain.get_name()),
                  UVM_LOW);
    end
    else
    begin
        `uvm_info(this.uvm_optb_name,
                  $sformatf("\n@%0t: %s ->> [%s] set_domain@<%s>\n",
                            $realtime, this.get_full_name(), this.uvm_optb_name, "default"),
                  UVM_LOW);
    end
endfunction:connect_phase

/**
 * main_phase
 * 1. Main_phase in simulation, it's called by platform automatically.
 * 2. DO NOT TOUCH!!
 */
virtual task main_phase(uvm_phase phase);
    `uvm_info(this.uvm_optb_name,
              $sformatf("\n@%0t: %s ->> [%s] ((main_phase))@<phase:%s> is called.\n",
                        $realtime, this.get_full_name(), this.uvm_optb_name, phase.get_name()),
              UVM_LOW);

    this.seq.starting_phase = phase;
    this.seq.start(this);
endtask:main_phase

endclass:uvm_optb_sequencer

`endif
