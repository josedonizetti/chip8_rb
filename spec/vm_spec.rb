require 'spec_helper'

module  Chip8
  describe VM do
    context ".load" do
      it "should initialie the emulator state" do
        program = [0x00, 0xE0, 0x00, 0xEE]
        emulator = VM.load(program)

        expect(emulator.pc).to eq(0x200)
        expect(emulator.sp).to eq(0)

        pc = emulator.pc
        expect(emulator.memory[pc]).to eq(0x00)
        expect(emulator.memory[pc + 1]).to eq(0xE0)

        16.times { |i|
          register = "v#{i}".to_sym
          expect(emulator.registers[register]).to eq(0)
        }
      end
    end

    context "1nnn" do
      it "should set program counter to nnn" do
        program = [0x12, 0x25]
        emulator = VM.load(program)
        emulator.execute

        expect(emulator.pc).to eq(549)
      end
    end

    context "0x2nnn" do
      it "should call subroutine at nnn" do
        pending
      end
    end

    context "3xkk" do
      it "should skip next instruction if Vx = kk" do
        # 6xkk - LD Vx, V1
        # 6112 - LD V1, 12
        # 3xkk - SE Vx
        # 3112 - SE (PC + 2) IF V1 == 12
        program = [0x61, 0x12, 0x31, 0x12]
        emulator = VM.load(program)
        initial_pc = emulator.pc
        emulator.execute

        expect(emulator.pc).to eq(initial_pc + 4 + 2)
      end
    end

    context "4xkk" do
      it "should skip next instruction if Vx != kk" do
      end
    end

    context "5xy0" do
      it "should skip next instruction if Vx = Vy" do
      end
    end

    context "6xkk" do
      it "should set Vx = kk" do
        program = [0x6F, 0xFF]
        emulator = VM.load(program)
        emulator.execute

        expect(emulator.registers[:v15]).to eq(255)
      end
    end

    context "7xkk" do
      it "should set Vx = Vx + kk" do
        program = [0x7E, 0xEE]
        emulator = VM.load(program)
        emulator.execute

        expect(emulator.registers[:v14]).to eq(238)
      end
    end

    context "8xy0" do
      it "should set Vx = Vy" do
        program = [0x61, 0x10, 0x82, 0x10]
        emulator = VM.load(program)
        emulator.execute

        expect(emulator.registers[:v1]).to eq(16)
        expect(emulator.registers[:v2]).to eq(emulator.registers[:v1])
      end
    end

    context "8xy1" do
      it "should set Vx = Vx OR Vy" do
        pending
      end
    end

    context "8xy2" do
      it "should set Vx = Vx AND Vy" do
        pending
      end
    end

    context "8xy3" do
      it "should set Vx = Vx XOR Vy" do
        pending
      end
    end

    context "8xy4" do
      it "should set Vx = Vx + Vy" do
        pending
      end

      it "should set VF 1 if (Vx + Vy) > 255" do
      end

      it "should set VF 0 if (Vx + Vy) < 255" do
      end
    end

    context "8xy5" do
      it "should set Vx = Vx - Vy" do
        pending
      end

      it "should set VF = 1 if Vx > Vy" do
        pending
      end

      it "should set VF = 0 if Vx < Vy" do
        pending
      end
    end

    context "8xy6" do
      it "should set Vx = Vx >> 1" do
        pending
      end

      it "should set VF to 1 if Vx least-significant bit is 1" do
        pending
      end

      it "should set VF to 0 if Vx least-significant bit is not 1" do
        pending
      end

      it "should divide Vx by 2" do
        pending
      end
    end

    context "8xy7" do
      it "should set Vx = Vy - Vx" do
      end

      it "should set VF to 1 if Vy > Vx" do
      end

      it "should set VF to 0 if Vy < Vx" do
      end
    end

    context "8xyE" do
      it "should set Vx = Vx << 1" do
        pending
      end

      it "should set VF to 1 if Vx most-signiticant bit is 1" do
        pending
      end

      it "should set VF to 0 if Vx most-signiticant bit is 0" do
        pending
      end

      it "should multiply Vx by 2" do
        pending
      end
    end

    context "9xy0" do
      it "should skip next instruction if Vx != Vy" do
      end
    end

    context "Annn" do
      it "should set the register I = nnn" do
        pending
      end
    end

    context "Bnnn" do
      it "should jump to location nnn + V0" do
        pending
      end
    end

    context "Cxkk" do
      it "should set Vx = random number between(0 and 255) AND kk" do
        pending
      end
    end

    context "Dxyn" do
      it "should read n bytes from before starting at I" do
        pending
      end

      it "should display sprites at Vx, and Vy" do
        pending
      end

      it "should xor sprites and set VF to 1 if any pixel is erased" do
        pending
      end

      it "should xor sprites and set VF to 0 if no pixel is erased" do
        pending
      end
    end

    context "Ex9E" do
      it "should skip next instruction if key with Vx value is pressed" do
      end
    end

    context "ExA1" do
      it "should skip next instruction if key with Vx is not pressed" do
        pending
      end
    end

    context "Fx07" do
      it "should set Vx = delay times value" do
        pending
      end
    end

    context "Fx0A" do
      it "should stop execution until a key is pressed" do
        pending
      end

      it "should set the key press down to Vx" do
        pending
      end
    end

    context "Fx15" do
      it "should set delay timer to Vx" do
        pending
      end
    end

    context "Fx18" do
      it "should set sound times to Vx" do
        pending
      end
    end

    context "Fx1E" do
      it "should set I = I + Vx" do
        pending
      end
    end

    context "Fx29" do
      it "should set I = location of sprite for digit Vx" do
        pending
      end
    end

    context "Fx33" do
      it "should store bcd representation of Vx in memory I" do
        pending
      end

      it "should store bcd representation of Vx in memory I + 1" do
        pending
      end

      it "should store bcd representation of Vx in memory I + 2" do
        pending
      end
    end

    context "Fx55" do
      it "should store registers V0 through Vx in memory starting at location I" do
        pending
      end
    end

    context "Fx65" do
      it "should read registers V0 through Vx from memory starting at location I" do
        pending
      end
    end
  end
end
