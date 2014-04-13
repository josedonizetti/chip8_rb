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

  end
end
