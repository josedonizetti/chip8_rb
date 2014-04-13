module Chip8
  class Emulator
    attr_reader :memory, :sp, :pc, :registers

    def initialize(program)
      @program = program
      initialize_memory
      load_program

      @sp = 0
      @pc = 0x200


      @registers = {}
      # 0 to F
      16.times { |i| @registers["v#{i}".to_sym] = 0 }
    end

    def initialize_memory
      @memory = []
      4096.times { |i| @memory[i] = 0 }
    end

    def load_program
      index = 0
      while index < @program.size
        memory[0x200 + index] = @program[index]
        index += 1
      end
    end

    def execute
      index = 0
      while index < @program.size
        byte1 = memory[0x200 + index]
        byte2 = memory[0x200 + index + 1]

        case (byte1 >> 4)
        when 0x1; op0x1(byte1, byte2)
        end

        index += 2
      end
    end

    class << self
      def load(program)
        Emulator.new(program)
      end
    end

    private

    def op0x1(byte1, byte2)
      @pc = "#{(byte1 & 0xf).to_s(16)}#{byte2.to_s(16)}".hex
    end
  end
end
