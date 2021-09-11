//========================================================================
//
// ca_prng_core.v
// --------------
// Cellular Automata (CA) PRNG. This version produces PRNG words
// with 32 bits.
//
//
// Author: Joachim Strombergson
// Copyright (c) 2019, Assured AB
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions
// are met:
//     * Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
//
//     * Redistributions in binary form must reproduce the above
//       copyright notice, this list of conditions and the following
//       disclaimer in the documentation and/or other materials
//       provided with the distribution.
//
// THIS SOFTWARE IS PROVIDED BY InformAsic AB ''AS IS'' AND ANY EXPRESS
// OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
// WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL InformAsic AB BE LIABLE FOR ANY
// DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
// DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
// GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
// WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
// NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
//========================================================================

`default_nettype none

module ca_prng_core(
                    input wire           clk,
                    input wire           reset_n,

                    input wire [31 : 0]  init_pattern_data,
                    input wire           load_init_pattern,
                    input wire           next_pattern,

                    input wire [7 : 0]   update_rule,
                    input wire           load_update_rule,

                    output wire [31 : 0] prng_data
                   );


  //--------------------------------------------------------------------
  // Constant declarations.
  //--------------------------------------------------------------------
  // DEFAULT_RULE
  // The Default update rule - rule 30.
  localparam [7 : 0] DEFAULT_RULE = 8'b00011110;


  //--------------------------------------------------------------------
  // Register declarations.
  //--------------------------------------------------------------------
  // ca_state_reg
  // State register for the CA cells, one bit for each cell.
  reg [31 : 0] ca_state_reg;
  reg [31 : 0] ca_state_new;
  reg          ca_state_we;

  // update_rule_reg
  // Register for the update rule.
  reg [7 : 0] update_rule_reg;


  //--------------------------------------------------------------------
  // Wire declarations.
  //--------------------------------------------------------------------
  // tmp_ca_state_new
  // temporary update vector. Is muxed to the real update vector
  // if the load_init_pattern control signal is not set.
  reg [31 : 0] tmp_ca_state_new;


  //--------------------------------------------------------------------
  // Assignments.
  //--------------------------------------------------------------------
  // Connect the PRNG output port to the CA state registers.
  assign prng_data = ca_state_reg;


  //--------------------------------------------------------------------
  // reg_update
  //
  // This clocked process impement all register updates including
  // synchronous, active low reset.
  //--------------------------------------------------------------------
  always @ (posedge clk)
    begin : reg_update
      if (!reset_n)
        begin
          // Register reset.
          update_rule_reg <= DEFAULT_RULE;
          ca_state_reg    <= 32'b0;
        end
      else
        begin
          if (load_update_rule)
            update_rule_reg <= update_rule;

          if (ca_state_we)
            ca_state_reg <= ca_state_new;
         end
    end // reg_update


  //--------------------------------------------------------------------
  // ca_state_update
  //
  // State update logic for the CA cells. This is where we implement
  // the Rule 30-logic as well as init pattern assignment.
  //--------------------------------------------------------------------
  always @*
    begin : ca_state_update
      // Update for ca_state_reg bit 0.
      case({ca_state_reg[31], ca_state_reg[0], ca_state_reg[1]})
        0:
        begin
          tmp_ca_state_new[0] = update_rule_reg[0];
        end
        1:
        begin
          tmp_ca_state_new[0] = update_rule_reg[1];
        end
        2:
        begin
          tmp_ca_state_new[0] = update_rule_reg[2];
        end
        3:
        begin
          tmp_ca_state_new[0] = update_rule_reg[3];
        end
        4:
        begin
          tmp_ca_state_new[0] = update_rule_reg[4];
        end
        5:
        begin
          tmp_ca_state_new[0] = update_rule_reg[5];
        end
        6:
        begin
          tmp_ca_state_new[0] = update_rule_reg[6];
        end
        7:
        begin
          tmp_ca_state_new[0] = update_rule_reg[7];
        end
      endcase // tmp_ca_state_new[0]

      // Update for ca_state_reg bit 1.
      case({ca_state_reg[0], ca_state_reg[1], ca_state_reg[2]})
        0:
        begin
          tmp_ca_state_new[1] = update_rule_reg[0];
        end
        1:
        begin
          tmp_ca_state_new[1] = update_rule_reg[1];
        end
        2:
        begin
          tmp_ca_state_new[1] = update_rule_reg[2];
        end
        3:
        begin
          tmp_ca_state_new[1] = update_rule_reg[3];
        end
        4:
        begin
          tmp_ca_state_new[1] = update_rule_reg[4];
        end
        5:
        begin
          tmp_ca_state_new[1] = update_rule_reg[5];
        end
        6:
        begin
          tmp_ca_state_new[1] = update_rule_reg[6];
        end
        7:
        begin
          tmp_ca_state_new[1] = update_rule_reg[7];
        end
      endcase // tmp_ca_state_new[1]

      // Update for ca_state_reg bit 2.
      case({ca_state_reg[1], ca_state_reg[2], ca_state_reg[3]})
        0:
        begin
          tmp_ca_state_new[2] = update_rule_reg[0];
        end
        1:
        begin
          tmp_ca_state_new[2] = update_rule_reg[1];
        end
        2:
        begin
          tmp_ca_state_new[2] = update_rule_reg[2];
        end
        3:
        begin
          tmp_ca_state_new[2] = update_rule_reg[3];
        end
        4:
        begin
          tmp_ca_state_new[2] = update_rule_reg[4];
        end
        5:
        begin
          tmp_ca_state_new[2] = update_rule_reg[5];
        end
        6:
        begin
          tmp_ca_state_new[2] = update_rule_reg[6];
        end
        7:
        begin
          tmp_ca_state_new[2] = update_rule_reg[7];
        end
      endcase // tmp_ca_state_new[2]

      // Update for ca_state_reg bit 3.
      case({ca_state_reg[2], ca_state_reg[3], ca_state_reg[4]})
        0:
        begin
          tmp_ca_state_new[3] = update_rule_reg[0];
        end
        1:
        begin
          tmp_ca_state_new[3] = update_rule_reg[1];
        end
        2:
        begin
          tmp_ca_state_new[3] = update_rule_reg[2];
        end
        3:
        begin
          tmp_ca_state_new[3] = update_rule_reg[3];
        end
        4:
        begin
          tmp_ca_state_new[3] = update_rule_reg[4];
        end
        5:
        begin
          tmp_ca_state_new[3] = update_rule_reg[5];
        end
        6:
        begin
          tmp_ca_state_new[3] = update_rule_reg[6];
        end
        7:
        begin
          tmp_ca_state_new[3] = update_rule_reg[7];
        end
      endcase // tmp_ca_state_new[3]

      // Update for ca_state_reg bit 4.
      case({ca_state_reg[3], ca_state_reg[4], ca_state_reg[5]})
        0:
        begin
          tmp_ca_state_new[4] = update_rule_reg[0];
        end
        1:
        begin
          tmp_ca_state_new[4] = update_rule_reg[1];
        end
        2:
        begin
          tmp_ca_state_new[4] = update_rule_reg[2];
        end
        3:
        begin
          tmp_ca_state_new[4] = update_rule_reg[3];
        end
        4:
        begin
          tmp_ca_state_new[4] = update_rule_reg[4];
        end
        5:
        begin
          tmp_ca_state_new[4] = update_rule_reg[5];
        end
        6:
        begin
          tmp_ca_state_new[4] = update_rule_reg[6];
        end
        7:
        begin
          tmp_ca_state_new[4] = update_rule_reg[7];
        end
      endcase // tmp_ca_state_new[4]

      // Update for ca_state_reg bit 5.
      case({ca_state_reg[4], ca_state_reg[5], ca_state_reg[6]})
        0:
        begin
          tmp_ca_state_new[5] = update_rule_reg[0];
        end
        1:
        begin
          tmp_ca_state_new[5] = update_rule_reg[1];
        end
        2:
        begin
          tmp_ca_state_new[5] = update_rule_reg[2];
        end
        3:
        begin
          tmp_ca_state_new[5] = update_rule_reg[3];
        end
        4:
        begin
          tmp_ca_state_new[5] = update_rule_reg[4];
        end
        5:
        begin
          tmp_ca_state_new[5] = update_rule_reg[5];
        end
        6:
        begin
          tmp_ca_state_new[5] = update_rule_reg[6];
        end
        7:
        begin
          tmp_ca_state_new[5] = update_rule_reg[7];
        end
      endcase // tmp_ca_state_new[5]

      // Update for ca_state_reg bit 6.
      case({ca_state_reg[5], ca_state_reg[6], ca_state_reg[7]})
        0:
        begin
          tmp_ca_state_new[6] = update_rule_reg[0];
        end
        1:
        begin
          tmp_ca_state_new[6] = update_rule_reg[1];
        end
        2:
        begin
          tmp_ca_state_new[6] = update_rule_reg[2];
        end
        3:
        begin
          tmp_ca_state_new[6] = update_rule_reg[3];
        end
        4:
        begin
          tmp_ca_state_new[6] = update_rule_reg[4];
        end
        5:
        begin
          tmp_ca_state_new[6] = update_rule_reg[5];
        end
        6:
        begin
          tmp_ca_state_new[6] = update_rule_reg[6];
        end
        7:
        begin
          tmp_ca_state_new[6] = update_rule_reg[7];
        end
      endcase // tmp_ca_state_new[6]

      // Update for ca_state_reg bit 7.
      case({ca_state_reg[6], ca_state_reg[7], ca_state_reg[8]})
        0:
        begin
          tmp_ca_state_new[7] = update_rule_reg[0];
        end
        1:
        begin
          tmp_ca_state_new[7] = update_rule_reg[1];
        end
        2:
        begin
          tmp_ca_state_new[7] = update_rule_reg[2];
        end
        3:
        begin
          tmp_ca_state_new[7] = update_rule_reg[3];
        end
        4:
        begin
          tmp_ca_state_new[7] = update_rule_reg[4];
        end
        5:
        begin
          tmp_ca_state_new[7] = update_rule_reg[5];
        end
        6:
        begin
          tmp_ca_state_new[7] = update_rule_reg[6];
        end
        7:
        begin
          tmp_ca_state_new[7] = update_rule_reg[7];
        end
      endcase // tmp_ca_state_new[7]

      // Update for ca_state_reg bit 8.
      case({ca_state_reg[7], ca_state_reg[8], ca_state_reg[9]})
        0:
        begin
          tmp_ca_state_new[8] = update_rule_reg[0];
        end
        1:
        begin
          tmp_ca_state_new[8] = update_rule_reg[1];
        end
        2:
        begin
          tmp_ca_state_new[8] = update_rule_reg[2];
        end
        3:
        begin
          tmp_ca_state_new[8] = update_rule_reg[3];
        end
        4:
        begin
          tmp_ca_state_new[8] = update_rule_reg[4];
        end
        5:
        begin
          tmp_ca_state_new[8] = update_rule_reg[5];
        end
        6:
        begin
          tmp_ca_state_new[8] = update_rule_reg[6];
        end
        7:
        begin
          tmp_ca_state_new[8] = update_rule_reg[7];
        end
      endcase // tmp_ca_state_new[8]

      // Update for ca_state_reg bit 9.
      case({ca_state_reg[8], ca_state_reg[9], ca_state_reg[10]})
        0:
        begin
          tmp_ca_state_new[9] = update_rule_reg[0];
        end
        1:
        begin
          tmp_ca_state_new[9] = update_rule_reg[1];
        end
        2:
        begin
          tmp_ca_state_new[9] = update_rule_reg[2];
        end
        3:
        begin
          tmp_ca_state_new[9] = update_rule_reg[3];
        end
        4:
        begin
          tmp_ca_state_new[9] = update_rule_reg[4];
        end
        5:
        begin
          tmp_ca_state_new[9] = update_rule_reg[5];
        end
        6:
        begin
          tmp_ca_state_new[9] = update_rule_reg[6];
        end
        7:
        begin
          tmp_ca_state_new[9] = update_rule_reg[7];
        end
      endcase // tmp_ca_state_new[9]

      // Update for ca_state_reg bit 10.
      case({ca_state_reg[9], ca_state_reg[10], ca_state_reg[11]})
        0:
        begin
          tmp_ca_state_new[10] = update_rule_reg[0];
        end
        1:
        begin
          tmp_ca_state_new[10] = update_rule_reg[1];
        end
        2:
        begin
          tmp_ca_state_new[10] = update_rule_reg[2];
        end
        3:
        begin
          tmp_ca_state_new[10] = update_rule_reg[3];
        end
        4:
        begin
          tmp_ca_state_new[10] = update_rule_reg[4];
        end
        5:
        begin
          tmp_ca_state_new[10] = update_rule_reg[5];
        end
        6:
        begin
          tmp_ca_state_new[10] = update_rule_reg[6];
        end
        7:
        begin
          tmp_ca_state_new[10] = update_rule_reg[7];
        end
      endcase // tmp_ca_state_new[10]

      // Update for ca_state_reg bit 11.
      case({ca_state_reg[10], ca_state_reg[11], ca_state_reg[12]})
        0:
        begin
          tmp_ca_state_new[11] = update_rule_reg[0];
        end
        1:
        begin
          tmp_ca_state_new[11] = update_rule_reg[1];
        end
        2:
        begin
          tmp_ca_state_new[11] = update_rule_reg[2];
        end
        3:
        begin
          tmp_ca_state_new[11] = update_rule_reg[3];
        end
        4:
        begin
          tmp_ca_state_new[11] = update_rule_reg[4];
        end
        5:
        begin
          tmp_ca_state_new[11] = update_rule_reg[5];
        end
        6:
        begin
          tmp_ca_state_new[11] = update_rule_reg[6];
        end
        7:
        begin
          tmp_ca_state_new[11] = update_rule_reg[7];
        end
      endcase // tmp_ca_state_new[11]

      // Update for ca_state_reg bit 12.
      case({ca_state_reg[11], ca_state_reg[12], ca_state_reg[13]})
        0:
        begin
          tmp_ca_state_new[12] = update_rule_reg[0];
        end
        1:
        begin
          tmp_ca_state_new[12] = update_rule_reg[1];
        end
        2:
        begin
          tmp_ca_state_new[12] = update_rule_reg[2];
        end
        3:
        begin
          tmp_ca_state_new[12] = update_rule_reg[3];
        end
        4:
        begin
          tmp_ca_state_new[12] = update_rule_reg[4];
        end
        5:
        begin
          tmp_ca_state_new[12] = update_rule_reg[5];
        end
        6:
        begin
          tmp_ca_state_new[12] = update_rule_reg[6];
        end
        7:
        begin
          tmp_ca_state_new[12] = update_rule_reg[7];
        end
      endcase // tmp_ca_state_new[12]

      // Update for ca_state_reg bit 13.
      case({ca_state_reg[12], ca_state_reg[13], ca_state_reg[14]})
        0:
        begin
          tmp_ca_state_new[13] = update_rule_reg[0];
        end
        1:
        begin
          tmp_ca_state_new[13] = update_rule_reg[1];
        end
        2:
        begin
          tmp_ca_state_new[13] = update_rule_reg[2];
        end
        3:
        begin
          tmp_ca_state_new[13] = update_rule_reg[3];
        end
        4:
        begin
          tmp_ca_state_new[13] = update_rule_reg[4];
        end
        5:
        begin
          tmp_ca_state_new[13] = update_rule_reg[5];
        end
        6:
        begin
          tmp_ca_state_new[13] = update_rule_reg[6];
        end
        7:
        begin
          tmp_ca_state_new[13] = update_rule_reg[7];
        end
      endcase // tmp_ca_state_new[13]

      // Update for ca_state_reg bit 14.
      case({ca_state_reg[13], ca_state_reg[14], ca_state_reg[15]})
        0:
        begin
          tmp_ca_state_new[14] = update_rule_reg[0];
        end
        1:
        begin
          tmp_ca_state_new[14] = update_rule_reg[1];
        end
        2:
        begin
          tmp_ca_state_new[14] = update_rule_reg[2];
        end
        3:
        begin
          tmp_ca_state_new[14] = update_rule_reg[3];
        end
        4:
        begin
          tmp_ca_state_new[14] = update_rule_reg[4];
        end
        5:
        begin
          tmp_ca_state_new[14] = update_rule_reg[5];
        end
        6:
        begin
          tmp_ca_state_new[14] = update_rule_reg[6];
        end
        7:
        begin
          tmp_ca_state_new[14] = update_rule_reg[7];
        end
      endcase // tmp_ca_state_new[14]

      // Update for ca_state_reg bit 15.
      case({ca_state_reg[14], ca_state_reg[15], ca_state_reg[16]})
        0:
        begin
          tmp_ca_state_new[15] = update_rule_reg[0];
        end
        1:
        begin
          tmp_ca_state_new[15] = update_rule_reg[1];
        end
        2:
        begin
          tmp_ca_state_new[15] = update_rule_reg[2];
        end
        3:
        begin
          tmp_ca_state_new[15] = update_rule_reg[3];
        end
        4:
        begin
          tmp_ca_state_new[15] = update_rule_reg[4];
        end
        5:
        begin
          tmp_ca_state_new[15] = update_rule_reg[5];
        end
        6:
        begin
          tmp_ca_state_new[15] = update_rule_reg[6];
        end
        7:
        begin
          tmp_ca_state_new[15] = update_rule_reg[7];
        end
      endcase // tmp_ca_state_new[15]

      // Update for ca_state_reg bit 16.
      case({ca_state_reg[15], ca_state_reg[16], ca_state_reg[17]})
        0:
        begin
          tmp_ca_state_new[16] = update_rule_reg[0];
        end
        1:
        begin
          tmp_ca_state_new[16] = update_rule_reg[1];
        end
        2:
        begin
          tmp_ca_state_new[16] = update_rule_reg[2];
        end
        3:
        begin
          tmp_ca_state_new[16] = update_rule_reg[3];
        end
        4:
        begin
          tmp_ca_state_new[16] = update_rule_reg[4];
        end
        5:
        begin
          tmp_ca_state_new[16] = update_rule_reg[5];
        end
        6:
        begin
          tmp_ca_state_new[16] = update_rule_reg[6];
        end
        7:
        begin
          tmp_ca_state_new[16] = update_rule_reg[7];
        end
      endcase // tmp_ca_state_new[16]

      // Update for ca_state_reg bit 17.
      case({ca_state_reg[16], ca_state_reg[17], ca_state_reg[18]})
        0:
        begin
          tmp_ca_state_new[17] = update_rule_reg[0];
        end
        1:
        begin
          tmp_ca_state_new[17] = update_rule_reg[1];
        end
        2:
        begin
          tmp_ca_state_new[17] = update_rule_reg[2];
        end
        3:
        begin
          tmp_ca_state_new[17] = update_rule_reg[3];
        end
        4:
        begin
          tmp_ca_state_new[17] = update_rule_reg[4];
        end
        5:
        begin
          tmp_ca_state_new[17] = update_rule_reg[5];
        end
        6:
        begin
          tmp_ca_state_new[17] = update_rule_reg[6];
        end
        7:
        begin
          tmp_ca_state_new[17] = update_rule_reg[7];
        end
      endcase // tmp_ca_state_new[17]

      // Update for ca_state_reg bit 18.
      case({ca_state_reg[17], ca_state_reg[18], ca_state_reg[19]})
        0:
        begin
          tmp_ca_state_new[18] = update_rule_reg[0];
        end
        1:
        begin
          tmp_ca_state_new[18] = update_rule_reg[1];
        end
        2:
        begin
          tmp_ca_state_new[18] = update_rule_reg[2];
        end
        3:
        begin
          tmp_ca_state_new[18] = update_rule_reg[3];
        end
        4:
        begin
          tmp_ca_state_new[18] = update_rule_reg[4];
        end
        5:
        begin
          tmp_ca_state_new[18] = update_rule_reg[5];
        end
        6:
        begin
          tmp_ca_state_new[18] = update_rule_reg[6];
        end
        7:
        begin
          tmp_ca_state_new[18] = update_rule_reg[7];
        end
      endcase // tmp_ca_state_new[18]

      // Update for ca_state_reg bit 19.
      case({ca_state_reg[18], ca_state_reg[19], ca_state_reg[20]})
        0:
        begin
          tmp_ca_state_new[19] = update_rule_reg[0];
        end
        1:
        begin
          tmp_ca_state_new[19] = update_rule_reg[1];
        end
        2:
        begin
          tmp_ca_state_new[19] = update_rule_reg[2];
        end
        3:
        begin
          tmp_ca_state_new[19] = update_rule_reg[3];
        end
        4:
        begin
          tmp_ca_state_new[19] = update_rule_reg[4];
        end
        5:
        begin
          tmp_ca_state_new[19] = update_rule_reg[5];
        end
        6:
        begin
          tmp_ca_state_new[19] = update_rule_reg[6];
        end
        7:
        begin
          tmp_ca_state_new[19] = update_rule_reg[7];
        end
      endcase // tmp_ca_state_new[19]

      // Update for ca_state_reg bit 20.
      case({ca_state_reg[19], ca_state_reg[20], ca_state_reg[21]})
        0:
        begin
          tmp_ca_state_new[20] = update_rule_reg[0];
        end
        1:
        begin
          tmp_ca_state_new[20] = update_rule_reg[1];
        end
        2:
        begin
          tmp_ca_state_new[20] = update_rule_reg[2];
        end
        3:
        begin
          tmp_ca_state_new[20] = update_rule_reg[3];
        end
        4:
        begin
          tmp_ca_state_new[20] = update_rule_reg[4];
        end
        5:
        begin
          tmp_ca_state_new[20] = update_rule_reg[5];
        end
        6:
        begin
          tmp_ca_state_new[20] = update_rule_reg[6];
        end
        7:
        begin
          tmp_ca_state_new[20] = update_rule_reg[7];
        end
      endcase // tmp_ca_state_new[20]

      // Update for ca_state_reg bit 21.
      case({ca_state_reg[20], ca_state_reg[21], ca_state_reg[22]})
        0:
        begin
          tmp_ca_state_new[21] = update_rule_reg[0];
        end
        1:
        begin
          tmp_ca_state_new[21] = update_rule_reg[1];
        end
        2:
        begin
          tmp_ca_state_new[21] = update_rule_reg[2];
        end
        3:
        begin
          tmp_ca_state_new[21] = update_rule_reg[3];
        end
        4:
        begin
          tmp_ca_state_new[21] = update_rule_reg[4];
        end
        5:
        begin
          tmp_ca_state_new[21] = update_rule_reg[5];
        end
        6:
        begin
          tmp_ca_state_new[21] = update_rule_reg[6];
        end
        7:
        begin
          tmp_ca_state_new[21] = update_rule_reg[7];
        end
      endcase // tmp_ca_state_new[21]

      // Update for ca_state_reg bit 22.
      case({ca_state_reg[21], ca_state_reg[22], ca_state_reg[23]})
        0:
        begin
          tmp_ca_state_new[22] = update_rule_reg[0];
        end
        1:
        begin
          tmp_ca_state_new[22] = update_rule_reg[1];
        end
        2:
        begin
          tmp_ca_state_new[22] = update_rule_reg[2];
        end
        3:
        begin
          tmp_ca_state_new[22] = update_rule_reg[3];
        end
        4:
        begin
          tmp_ca_state_new[22] = update_rule_reg[4];
        end
        5:
        begin
          tmp_ca_state_new[22] = update_rule_reg[5];
        end
        6:
        begin
          tmp_ca_state_new[22] = update_rule_reg[6];
        end
        7:
        begin
          tmp_ca_state_new[22] = update_rule_reg[7];
        end
      endcase // tmp_ca_state_new[22]

      // Update for ca_state_reg bit 23.
      case({ca_state_reg[22], ca_state_reg[23], ca_state_reg[24]})
        0:
        begin
          tmp_ca_state_new[23] = update_rule_reg[0];
        end
        1:
        begin
          tmp_ca_state_new[23] = update_rule_reg[1];
        end
        2:
        begin
          tmp_ca_state_new[23] = update_rule_reg[2];
        end
        3:
        begin
          tmp_ca_state_new[23] = update_rule_reg[3];
        end
        4:
        begin
          tmp_ca_state_new[23] = update_rule_reg[4];
        end
        5:
        begin
          tmp_ca_state_new[23] = update_rule_reg[5];
        end
        6:
        begin
          tmp_ca_state_new[23] = update_rule_reg[6];
        end
        7:
        begin
          tmp_ca_state_new[23] = update_rule_reg[7];
        end
      endcase // tmp_ca_state_new[23]

      // Update for ca_state_reg bit 24.
      case({ca_state_reg[23], ca_state_reg[24], ca_state_reg[25]})
        0:
        begin
          tmp_ca_state_new[24] = update_rule_reg[0];
        end
        1:
        begin
          tmp_ca_state_new[24] = update_rule_reg[1];
        end
        2:
        begin
          tmp_ca_state_new[24] = update_rule_reg[2];
        end
        3:
        begin
          tmp_ca_state_new[24] = update_rule_reg[3];
        end
        4:
        begin
          tmp_ca_state_new[24] = update_rule_reg[4];
        end
        5:
        begin
          tmp_ca_state_new[24] = update_rule_reg[5];
        end
        6:
        begin
          tmp_ca_state_new[24] = update_rule_reg[6];
        end
        7:
        begin
          tmp_ca_state_new[24] = update_rule_reg[7];
        end
      endcase // tmp_ca_state_new[24]

      // Update for ca_state_reg bit 25.
      case({ca_state_reg[24], ca_state_reg[25], ca_state_reg[26]})
        0:
        begin
          tmp_ca_state_new[25] = update_rule_reg[0];
        end
        1:
        begin
          tmp_ca_state_new[25] = update_rule_reg[1];
        end
        2:
        begin
          tmp_ca_state_new[25] = update_rule_reg[2];
        end
        3:
        begin
          tmp_ca_state_new[25] = update_rule_reg[3];
        end
        4:
        begin
          tmp_ca_state_new[25] = update_rule_reg[4];
        end
        5:
        begin
          tmp_ca_state_new[25] = update_rule_reg[5];
        end
        6:
        begin
          tmp_ca_state_new[25] = update_rule_reg[6];
        end
        7:
        begin
          tmp_ca_state_new[25] = update_rule_reg[7];
        end
      endcase // tmp_ca_state_new[25]

      // Update for ca_state_reg bit 26.
      case({ca_state_reg[25], ca_state_reg[26], ca_state_reg[27]})
        0:
        begin
          tmp_ca_state_new[26] = update_rule_reg[0];
        end
        1:
        begin
          tmp_ca_state_new[26] = update_rule_reg[1];
        end
        2:
        begin
          tmp_ca_state_new[26] = update_rule_reg[2];
        end
        3:
        begin
          tmp_ca_state_new[26] = update_rule_reg[3];
        end
        4:
        begin
          tmp_ca_state_new[26] = update_rule_reg[4];
        end
        5:
        begin
          tmp_ca_state_new[26] = update_rule_reg[5];
        end
        6:
        begin
          tmp_ca_state_new[26] = update_rule_reg[6];
        end
        7:
        begin
          tmp_ca_state_new[26] = update_rule_reg[7];
        end
      endcase // tmp_ca_state_new[26]

      // Update for ca_state_reg bit 27.
      case({ca_state_reg[26], ca_state_reg[27], ca_state_reg[28]})
        0:
        begin
          tmp_ca_state_new[27] = update_rule_reg[0];
        end
        1:
        begin
          tmp_ca_state_new[27] = update_rule_reg[1];
        end
        2:
        begin
          tmp_ca_state_new[27] = update_rule_reg[2];
        end
        3:
        begin
          tmp_ca_state_new[27] = update_rule_reg[3];
        end
        4:
        begin
          tmp_ca_state_new[27] = update_rule_reg[4];
        end
        5:
        begin
          tmp_ca_state_new[27] = update_rule_reg[5];
        end
        6:
        begin
          tmp_ca_state_new[27] = update_rule_reg[6];
        end
        7:
        begin
          tmp_ca_state_new[27] = update_rule_reg[7];
        end
      endcase // tmp_ca_state_new[27]

      // Update for ca_state_reg bit 28.
      case({ca_state_reg[27], ca_state_reg[28], ca_state_reg[29]})
        0:
        begin
          tmp_ca_state_new[28] = update_rule_reg[0];
        end
        1:
        begin
          tmp_ca_state_new[28] = update_rule_reg[1];
        end
        2:
        begin
          tmp_ca_state_new[28] = update_rule_reg[2];
        end
        3:
        begin
          tmp_ca_state_new[28] = update_rule_reg[3];
        end
        4:
        begin
          tmp_ca_state_new[28] = update_rule_reg[4];
        end
        5:
        begin
          tmp_ca_state_new[28] = update_rule_reg[5];
        end
        6:
        begin
          tmp_ca_state_new[28] = update_rule_reg[6];
        end
        7:
        begin
          tmp_ca_state_new[28] = update_rule_reg[7];
        end
      endcase // tmp_ca_state_new[28]

      // Update for ca_state_reg bit 29.
      case({ca_state_reg[28], ca_state_reg[29], ca_state_reg[30]})
        0:
        begin
          tmp_ca_state_new[29] = update_rule_reg[0];
        end
        1:
        begin
          tmp_ca_state_new[29] = update_rule_reg[1];
        end
        2:
        begin
          tmp_ca_state_new[29] = update_rule_reg[2];
        end
        3:
        begin
          tmp_ca_state_new[29] = update_rule_reg[3];
        end
        4:
        begin
          tmp_ca_state_new[29] = update_rule_reg[4];
        end
        5:
        begin
          tmp_ca_state_new[29] = update_rule_reg[5];
        end
        6:
        begin
          tmp_ca_state_new[29] = update_rule_reg[6];
        end
        7:
        begin
          tmp_ca_state_new[29] = update_rule_reg[7];
        end
      endcase // tmp_ca_state_new[29]

      // Update for ca_state_reg bit 30.
      case({ca_state_reg[29], ca_state_reg[30], ca_state_reg[31]})
        0:
        begin
          tmp_ca_state_new[30] = update_rule_reg[0];
        end
        1:
        begin
          tmp_ca_state_new[30] = update_rule_reg[1];
        end
        2:
        begin
          tmp_ca_state_new[30] = update_rule_reg[2];
        end
        3:
        begin
          tmp_ca_state_new[30] = update_rule_reg[3];
        end
        4:
        begin
          tmp_ca_state_new[30] = update_rule_reg[4];
        end
        5:
        begin
          tmp_ca_state_new[30] = update_rule_reg[5];
        end
        6:
        begin
          tmp_ca_state_new[30] = update_rule_reg[6];
        end
        7:
        begin
          tmp_ca_state_new[30] = update_rule_reg[7];
        end
      endcase // tmp_ca_state_new[30]

      // Update for ca_state_reg bit 31.
      case({ca_state_reg[30], ca_state_reg[31], ca_state_reg[0]})
        0:
        begin
          tmp_ca_state_new[31] = update_rule_reg[0];
        end
        1:
        begin
          tmp_ca_state_new[31] = update_rule_reg[1];
        end
        2:
        begin
          tmp_ca_state_new[31] = update_rule_reg[2];
        end
        3:
        begin
          tmp_ca_state_new[31] = update_rule_reg[3];
        end
        4:
        begin
          tmp_ca_state_new[31] = update_rule_reg[4];
        end
        5:
        begin
          tmp_ca_state_new[31] = update_rule_reg[5];
        end
        6:
        begin
          tmp_ca_state_new[31] = update_rule_reg[6];
        end
        7:
        begin
          tmp_ca_state_new[31] = update_rule_reg[7];
        end
      endcase // tmp_ca_state_new[31]


      if (load_init_pattern)
        begin
          ca_state_new = init_pattern_data;
        end
      else
        begin
          ca_state_new = tmp_ca_state_new;
        end

      // Should an init pattern or the next pattern be stored in
      // the CA array?
      if (load_init_pattern || next_pattern)
        begin
          ca_state_we = 1;
        end
      else
        begin
          ca_state_we = 0;
        end
    end // ca_state_update
endmodule // ca_prng

//========================================================================
// EOF ca_prng.v
//========================================================================