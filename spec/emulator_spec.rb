require 'spec_helper'

module  Chip8
  describe Emulator do
    context ".load" do
      it "should initialie the emulator state" do
        program = [0x00, 0xE0, 0x00, 0xEE]
        emulator = Emulator.load(program)

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
        emulator = Emulator.load(program)
        emulator.execute

        expect(emulator.pc).to eq(549)
      end
    end

    context "6xkk" do
      it "should set Vx = kk" do
        program = [0x6F, 0xFF]
        emulator = Emulator.load(program)
        emulator.execute

        expect(emulator.registers[:v15]).to eq(255)
      end
    end

    context "7xkk" do
      it "should set Vx = Vx + kk" do
        program = [0x7E, 0xEE]
        emulator = Emulator.load(program)
        emulator.execute

        expect(emulator.registers[:v14]).to eq(238)
      end
    end

    context "8xy0" do
      it "should set Vx = Vy" do
        program = [0x61, 0x10, 0x82, 0x10]
        emulator = Emulator.load(program)
        emulator.execute

        expect(emulator.registers[:v1]).to eq(16)
        expect(emulator.registers[:v2]).to eq(emulator.registers[:v1])
      end
    end

  end
end
