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
        program = [0x62, 0x15, 0x42, 0x10]
        emulator = VM.load(program)
        initial_pc = emulator.pc
        emulator.execute

        expect(emulator.pc).to eq(initial_pc + 4 + 2)
      end
    end

    context "5xy0" do
      it "should skip next instruction if Vx = Vy" do
        program = [0x69, 0xA0, 0x65, 0xA0, 0x59, 0x50]
        emulator = VM.load(program)
        initial_pc = emulator.pc
        emulator.execute

        expect(emulator.pc).to eq(initial_pc + 6 + 2)
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
        program = [0x6E, 0x55, 0x7E, 0xEE]
        emulator = VM.load(program)
        emulator.execute

        expect(emulator.registers[:v14]).to eq(323)
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
        program = [0x67, 0x08, 0x65, 0x64, 0x87, 0x51]
        emulator = VM.load(program)
        emulator.execute

        expect(emulator.registers[:v7]).to eq(108)
      end
    end

    context "8xy2" do
      it "should set Vx = Vx AND Vy" do
        program = [0x61, 0x12, 0x62, 0x14, 0x81, 0x22]
        emulator = VM.load(program)
        emulator.execute

        expect(emulator.registers[:v1]).to eq(16)
      end
    end

    context "8xy3" do
      it "should set Vx = Vx XOR Vy" do
        program = [0x68, 0x10, 0x6A, 0x20, 0x88, 0xA3]
        emulator = VM.load(program)
        emulator.execute

        expect(emulator.registers[:v8]).to eq(48)
      end
    end

    context "8xy4" do
      it "should set Vx = Vx + Vy" do
        program = [0x6A, 0x10, 0x6B, 0xFF, 0x8A, 0xB4]
        emulator = VM.load(program)
        emulator.execute

        expect(emulator.registers[:v10]).to eq(15)
      end

      it "should set VF 1 if (Vx + Vy) > 255" do
        program = [0x6C, 0xF1, 0x6D, 0x0F, 0x8C, 0xD4]
        emulator = VM.load(program)
        emulator.execute

        expect(emulator.registers[:v15]).to eq(1)
      end

      it "should set VF 0 if (Vx + Vy) =< 255" do
        program = [0x6C, 0xF0, 0x6D, 0x0F, 0x8C, 0xD4]
        emulator = VM.load(program)
        emulator.registers[:v15] = 1
        emulator.execute

        expect(emulator.registers[:v15]).to eq(0)
      end
    end

    context "8xy5" do
      it "should set Vx = Vx - Vy" do
        program = [0x6D, 0x25, 0x61, 0x15, 0x8D, 0x15]
        emulator = VM.load(program)
        emulator.execute

        expect(emulator.registers[:v13]).to eq(16)
      end

      it "should set VF = 1 if Vx > Vy" do
        program = [0x6D, 0x25, 0x61, 0x15, 0x8D, 0x15]
        emulator = VM.load(program)
        emulator.execute

        expect(emulator.registers[:v15]).to eq(1)
      end

      it "should set VF = 0 if Vx <= Vy" do
        program = [0x6D, 0x15, 0x61, 0x25, 0x8D, 0x15]
        emulator = VM.load(program)
        emulator.registers[:v15] = 1
        emulator.execute

        expect(emulator.registers[:v13]).to eq(240)
        expect(emulator.registers[:v15]).to eq(0)
      end
    end

    context "8xy6" do
      it "should set Vx = Vx >> 1" do
        program = [0x63, 0x64, 0x83, 0x16]
        emulator = VM.load(program)
        emulator.execute

        expect(emulator.registers[:v3]).to eq(50)
      end

      it "should set VF to 1 if Vx least-significant bit is 1" do
        program = [0x63, 0x63, 0x83, 0x16]
        emulator = VM.load(program)
        emulator.execute

        expect(emulator.registers[:v15]).to eq(1)
      end

      it "should set VF to 0 if Vx least-significant bit is not 1" do
        program = [0x63, 0x64, 0x83, 0x16]
        emulator = VM.load(program)
        emulator.registers[:v15] = 1
        emulator.execute

        expect(emulator.registers[:v15]).to eq(0)
      end
    end

    context "8xy7" do
      it "should set Vx = Vy - Vx" do
        program = [0x65, 0x05, 0x66, 0x10, 0x85, 0x67]
        emulator = VM.load(program)
        emulator.execute

        expect(emulator.registers[:v5]).to eq(11)
      end

      it "should set VF to 1 if Vy > Vx" do
        program = [0x65, 0x05, 0x66, 0x10, 0x85, 0x67]
        emulator = VM.load(program)
        emulator.execute

        expect(emulator.registers[:v15]).to eq(1)
      end

      it "should set VF to 0 if Vy =< Vx" do
        program = [0x65, 0x10, 0x66, 0x05, 0x85, 0x67]
        emulator = VM.load(program)
        emulator.registers[:v15] = 1
        emulator.execute

        expect(emulator.registers[:v15]).to eq(0)
      end
    end

    context "8xyE" do
      it "should set Vx = Vx << 1" do
        program = [0x68, 0x32, 0x88, 0x0E]
        emulator = VM.load(program)
        emulator.execute

        expect(emulator.registers[:v8]).to eq(100)
      end

      it "should set VF to 1 if Vx most-signiticant bit is 1" do
        program = [0x68, 0xFF, 0x88, 0x0E]
        emulator = VM.load(program)
        emulator.execute

        expect(emulator.registers[:v15]).to eq(1)
      end

      it "should set VF to 0 if Vx most-signiticant bit is 0" do
        program = [0x68, 0x32, 0x88, 0x0E]
        emulator = VM.load(program)
        emulator.registers[:v15] = 1
        emulator.execute

        expect(emulator.registers[:v15]).to eq(0)
      end
    end

    context "9xy0" do
      it "should skip next instruction if Vx != Vy" do
        program = [0x61, 0x12, 0x62, 0x13, 0x91, 0x20]
        emulator = VM.load(program)
        initial_pc = emulator.pc
        emulator.execute

        expect(emulator.pc).to eq(initial_pc + 6 + 2)
      end
    end

    context "Annn" do
      it "should set the register I = nnn" do
        program = [0xA2, 0x25]
        emulator = VM.load(program)
        emulator.execute

        expect(emulator.i).to eq(0x225)
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
