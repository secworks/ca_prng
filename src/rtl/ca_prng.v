//======================================================================
//
// ca_prng.v
// --------
// Top level wrapper for the CA_PRNG pseudo random generator core.
//
//
// Author: Joachim Strombergson
// Copyright (c) 2021, Assured AB
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or
// without modification, are permitted provided that the following
// conditions are met:
//
// 1. Redistributions of source code must retain the above copyright
//    notice, this list of conditions and the following disclaimer.
//
// 2. Redistributions in binary form must reproduce the above copyright
//    notice, this list of conditions and the following disclaimer in
//    the documentation and/or other materials provided with the
//    distribution.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
// FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
// COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
// INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
// BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
// LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
// CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
// STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
// ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
//======================================================================

`default_nettype none

module ca_prng(
               input wire           clk,
               input wire           reset_n,

               input wire           cs,
               input wire           we,

               input wire  [7 : 0]  address,
               input wire  [31 : 0] write_data,
               output wire [31 : 0] read_data
              );


  //----------------------------------------------------------------
  // Internal constant and parameter definitions.
  //----------------------------------------------------------------
  localparam ADDR_NAME0     = 8'h00;
  localparam ADDR_NAME1     = 8'h01;
  localparam ADDR_VERSION   = 8'h02;

  localparam ADDR_CTRL      = 8'h08;
  localparam CTRL_NEXT_BIT  = 0;

  localparam ADDR_RULE      = 8'h0a;
  localparam RULE_LSB       = 0;
  localparam RULE_MSB       = 7;

  localparam ADDR_PATTERN   = 8'h10;

  localparam ADDR_PRNG_DATA = 8'h30;

  localparam CORE_NAME0     = 32'h63615f70; // "ca_p"
  localparam CORE_NAME1     = 32'h726e6720; // "rng "
  localparam CORE_VERSION   = 32'h302e3130; // "0.10"


  localparam [7 : 0] DEFAULT_RULE = 8'b00011110;


  //----------------------------------------------------------------
  // Registers including update variables and write enable.
  //----------------------------------------------------------------
  reg          next_reg;
  reg          next_we;

  reg [7 : 0]  rule_reg;
  reg          load_rule_reg;
  reg          load_rule_new;

  reg [31 : 0] pattern_reg;
  reg          load_pattern_reg;
  reg          load_pattern_new;


  //----------------------------------------------------------------
  // Wires.
  //----------------------------------------------------------------
  reg [31 : 0]   tmp_read_data;

  wire [31 : 0]  core_prng_data;


  //----------------------------------------------------------------
  // Concurrent connectivity for ports etc.
  //----------------------------------------------------------------
  assign read_data = tmp_read_data;


  //----------------------------------------------------------------
  // core instantiation.
  //----------------------------------------------------------------
  ca_prng_core core(
                   .clk(clk),
                   .reset_n(reset_n),

                   .init_pattern_data(pattern_reg),
                   .load_init_pattern(load_pattern_reg),

                   .next_pattern(next_reg),

                   .update_rule(rule_reg),
                   .load_update_rule(load_rule_reg),

                   .prng_data(core_prng_data)
                  );


  //----------------------------------------------------------------
  // reg_update
  // Update functionality for all registers in the core.
  // All registers are positive edge triggered with synchronous
  // active low reset.
  //----------------------------------------------------------------
  always @ (posedge clk)
    begin : reg_update
      if (!reset_n)
        begin
          next_reg         <= 1'h0;
          load_rule_reg    <= 1'h0;
          rule_reg         <= DEFAULT_RULE;
          load_pattern_reg <= 1'h0;
          pattern_reg      <= 32'hffff_ffff;
        end
      else
        begin
          load_rule_reg    <= load_rule_new;
          load_pattern_reg <= load_pattern_new;

          if (next_we)
            begin
              next_reg <= write_data[CTRL_NEXT_BIT];
            end

          if (load_rule_new)
            rule_reg <= write_data[RULE_MSB : RULE_LSB];

          if (load_pattern_new)
            pattern_reg <= write_data;
        end
    end // reg_update


  //----------------------------------------------------------------
  // api
  //
  // The interface command decoding logic.
  //----------------------------------------------------------------
  always @*
    begin : api
      next_we          = 1'h0;
      load_rule_new    = 1'h0;
      load_pattern_new = 1'h0;
      tmp_read_data    = 32'h0;

      if (cs)
        begin
          if (we)
            begin
              case (address)
                ADDR_CTRL :    next_we          = 1'h1;
                ADDR_RULE :    load_rule_new    = 1'h1;
                ADDR_PATTERN : load_pattern_new = 1'h1;
                default :;
              endcase // case (address)
            end
          else
            begin
              case (address)
                ADDR_NAME0 :     tmp_read_data = CORE_NAME0;
                ADDR_NAME1 :     tmp_read_data = CORE_NAME1;
                ADDR_VERSION :   tmp_read_data = CORE_VERSION;
                ADDR_PRNG_DATA : tmp_read_data = core_prng_data;
                default :;
              endcase // case (address)
            end
        end
    end // addr_decoder
endmodule // ca_prng

//======================================================================
// EOF ca_prng.v
//======================================================================
